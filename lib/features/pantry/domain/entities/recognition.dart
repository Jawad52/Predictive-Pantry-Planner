import 'dart:ui';
import 'package:equatable/equatable.dart';

class Recognition extends Equatable {
  final int id;
  final String label;
  final double score;
  final Rect location;

  const Recognition({
    required this.id,
    required this.label,
    required this.score,
    required this.location,
  });

  @override
  List<Object?> get props => [id, label, score, location];

  @override
  String toString() {
    return 'Recognition(label: $label, score: ${score.toStringAsFixed(2)}, location: $location)';
  }
}
