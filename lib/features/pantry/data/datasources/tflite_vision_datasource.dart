import 'dart:io';
import 'package:flutter/services.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../../domain/entities/recognition.dart';
import 'dart:ui';

abstract class VisionDataSource {
  Future<void> loadModel();
  Future<List<Recognition>> predict(File imageFile);
  Future<List<Recognition>> predictFromStream(Uint8List bytes, int width, int height);
}

@LazySingleton(as: VisionDataSource)
class TFLiteVisionDataSource implements VisionDataSource {
  ObjectDetector? _objectDetector;

  static const String _modelPath = 'assets/models/ssd_mobilenet.tflite';

  @override
  Future<void> loadModel() async {
    final modelPath = await _getModelPath(_modelPath);
    final options = LocalObjectDetectorOptions(
      mode: DetectionMode.single,
      modelPath: modelPath,
      classifyObjects: true,
      multipleObjects: true,
    );
    _objectDetector = ObjectDetector(options: options);
  }

  @override
  Future<List<Recognition>> predict(File imageFile) async {
    if (_objectDetector == null) await loadModel();
    
    final inputImage = InputImage.fromFile(imageFile);
    final objects = await _objectDetector!.processImage(inputImage);

    return objects.map((obj) {
      return Recognition(
        id: obj.trackingId ?? 0,
        label: obj.labels.isNotEmpty ? obj.labels.first.text : 'Unknown',
        score: obj.labels.isNotEmpty ? obj.labels.first.confidence : 0.0,
        location: obj.boundingBox,
      );
    }).toList();
  }

  @override
  Future<List<Recognition>> predictFromStream(Uint8List bytes, int width, int height) async {
    // Note: Stream processing with ML Kit usually requires InputImageMetadata
    // For simplicity in this datasource, we focus on the file-based prediction first.
    return [];
  }

  Future<String> _getModelPath(String asset) async {
    final path = '${(await getApplicationSupportDirectory()).path}/$asset';
    await Directory(dirname(path)).create(recursive: true);
    final file = File(path);
    if (!await file.exists()) {
      final byteData = await rootBundle.load(asset);
      await file.writeAsBytes(byteData.buffer.asUint8List(
          byteData.offsetInBytes, byteData.lengthInBytes));
    }
    return file.path;
  }
}
