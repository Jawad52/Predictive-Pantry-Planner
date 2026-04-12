import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:camera/camera.dart';
import 'camera_event.dart';
import 'camera_state.dart';
import '../../data/datasources/tflite_vision_datasource.dart';

@injectable
class CameraBloc extends Bloc<CameraEvent, CameraState> {
  final VisionDataSource visionDataSource;
  CameraController? _controller;
  bool _isProcessing = false;

  CameraBloc({required this.visionDataSource}) : super(CameraInitial()) {
    on<InitializeCamera>(_onInitialize);
    on<StartImageStream>(_onStartStream);
    on<ProcessCameraFrame>(_onProcessFrame);
    on<StopImageStream>(_onStopStream);
  }

  Future<void> _onInitialize(InitializeCamera event, Emitter<CameraState> emit) async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        emit(CameraFailure("No cameras found"));
        return;
      }

      _controller = CameraController(
        cameras[0],
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await _controller!.initialize();
      await visionDataSource.loadModel();
      
      emit(CameraReady(_controller!));
    } catch (e) {
      emit(CameraFailure(e.toString()));
    }
  }

  Future<void> _onStartStream(StartImageStream event, Emitter<CameraState> emit) async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    _controller!.startImageStream((image) {
      if (!_isProcessing) {
        add(ProcessCameraFrame(image));
      }
    });
  }

  Future<void> _onProcessFrame(ProcessCameraFrame event, Emitter<CameraState> emit) async {
    _isProcessing = true;
    try {
      // Logic for frame processing...
      if (state is CameraReady || state is CameraScanning) {
        emit(CameraScanning(_controller!, []));
      }
    } finally {
      _isProcessing = false;
    }
  }

  Future<void> _onStopStream(StopImageStream event, Emitter<CameraState> emit) async {
    await _controller?.stopImageStream();
    if (_controller != null) {
      emit(CameraReady(_controller!));
    }
  }

  @override
  Future<void> close() {
    _controller?.dispose();
    return super.close();
  }
}
