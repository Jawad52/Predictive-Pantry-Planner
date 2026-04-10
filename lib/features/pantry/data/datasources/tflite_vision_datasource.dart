import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import '../../domain/entities/recognition.dart';
import 'dart:ui';

abstract class VisionDataSource {
  Future<void> loadModel();
  Future<List<Recognition>> predict(File imageFile);
  Future<List<Recognition>> predictFromStream(Uint8List bytes, int width, int height);
}

class TFLiteVisionDataSource implements VisionDataSource {
  Interpreter? _interpreter;
  List<String>? _labels;

  static const String _modelPath = 'assets/models/ssd_mobilenet.tflite';
  static const String _labelPath = 'assets/labels.txt';

  @override
  Future<void> loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset(_modelPath);
      final labelData = await rootBundle.loadString(_labelPath);
      _labels = labelData.split('\n').where((s) => s.isNotEmpty).toList();
    } catch (e) {
      print("Error loading model: $e");
    }
  }

  @override
  Future<List<Recognition>> predict(File imageFile) async {
    if (_interpreter == null) return [];
    final imageBytes = await imageFile.readAsBytes();
    final image = img.decodeImage(imageBytes);
    if (image == null) return [];

    return _runInference(image);
  }

  @override
  Future<List<Recognition>> predictFromStream(Uint8List bytes, int width, int height) async {
    if (_interpreter == null) return [];

    // Convert YUV/BGRA to RGB image
    final image = img.Image.fromBytes(width: width, height: height, bytes: bytes.buffer);
    return _runInference(image);
  }

  List<Recognition> _runInference(img.Image image) {
    if (_interpreter == null || _labels == null) return [];

    // 1. Pre-process: Resize to 300x300 (standard for SSD MobileNet)
    final resizedImage = img.copyResize(image, width: 300, height: 300);

    // 2. Prepare Input Tensor [1, 300, 300, 3]
    var input = _imageToByteListFloat32(resizedImage, 300);

    // 3. Prepare Output Tensors
    // SSD MobileNet typically has 4 outputs:
    // 0: Locations [1, 10, 4]
    // 1: Classes [1, 10]
    // 2: Scores [1, 10]
    // 3: Number of detections [1]
    var outputLocations = List.generate(1, (_) => List.generate(10, (_) => List.filled(4, 0.0)));
    var outputClasses = List.generate(1, (_) => List.filled(10, 0.0));
    var outputScores = List.generate(1, (_) => List.filled(10, 0.0));
    var numDetections = List.filled(1, 0.0);

    Object outputs = {
      0: outputLocations,
      1: outputClasses,
      2: outputScores,
      3: numDetections,
    };

    _interpreter!.runForMultipleInputs([input], outputs as Map<int, Object>);

    // 4. Post-process into Recognition objects
    List<Recognition> recognitions = [];
    for (int i = 0; i < 10; i++) {
      final score = outputScores[0][i];
      if (score > 0.5) { // Confidence threshold
        final labelIndex = outputClasses[0][i].toInt();
        final label = labelIndex < _labels!.length ? _labels![labelIndex] : 'Unknown';

        // Bounding box [ymin, xmin, ymax, xmax]
        final loc = outputLocations[0][i];
        final rect = Rect.fromLTRB(
          loc[1] * image.width,
          loc[0] * image.height,
          loc[3] * image.width,
          loc[2] * image.height
        );

        recognitions.add(Recognition(
          id: i,
          label: label,
          score: score,
          location: rect,
        ));
      }
    }

    return recognitions;
  }

  Uint8List _imageToByteListFloat32(img.Image image, int inputSize) {
    var convertedBytes = Float32List(1 * inputSize * inputSize * 3);
    var buffer = Float32List.view(convertedBytes.buffer);
    int pixelIndex = 0;
    for (var i = 0; i < inputSize; i++) {
      for (var j = 0; j < inputSize; j++) {
        var pixel = image.getPixel(j, i);
        buffer[pixelIndex++] = (pixel.r - 127.5) / 127.5;
        buffer[pixelIndex++] = (pixel.g - 127.5) / 127.5;
        buffer[pixelIndex++] = (pixel.b - 127.5) / 127.5;
      }
    }
    return convertedBytes.buffer.asUint8List();
  }
}
