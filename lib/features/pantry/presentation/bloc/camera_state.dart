import 'package:equatable/equatable.dart';
import 'package:camera/camera.dart';
import '../../domain/entities/recognition.dart';

abstract class CameraState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CameraInitial extends CameraState {}

class CameraReady extends CameraState {
  final CameraController controller;
  CameraReady(this.controller);

  @override
  List<Object?> get props => [controller];
}

class CameraScanning extends CameraState {
  final CameraController controller;
  final List<Recognition> recognitions;
  CameraScanning(this.controller, this.recognitions);

  @override
  List<Object?> get props => [controller, recognitions];
}

class CameraFailure extends CameraState {
  final String message;
  CameraFailure(this.message);

  @override
  List<Object?> get props => [message];
}
