import 'package:equatable/equatable.dart';
import 'package:camera/camera.dart';

abstract class CameraEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitializeCamera extends CameraEvent {}

class StartImageStream extends CameraEvent {}

class StopImageStream extends CameraEvent {}

class ProcessCameraFrame extends CameraEvent {
  final CameraImage image;
  ProcessCameraFrame(this.image);

  @override
  List<Object?> get props => [image];
}
