import 'package:flutter/material.dart';
import '../../domain/entities/recognition.dart';

class RecognitionBox extends StatelessWidget {
  final Recognition recognition;
  final Size previewSize;
  final Size screenSize;

  const RecognitionBox({
    super.key,
    required this.recognition,
    required this.previewSize,
    required this.screenSize,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate scaling factors
    final double scaleX = screenSize.width / previewSize.width;
    final double scaleY = screenSize.height / previewSize.height;

    final rect = Rect.fromLTRB(
      recognition.location.left * scaleX,
      recognition.location.top * scaleY,
      recognition.location.right * scaleX,
      recognition.location.bottom * scaleY,
    );

    return Positioned.fromRect(
      rect: rect,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: _getColor(recognition.score),
            width: 3,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Align(
          alignment: Alignment.topLeft,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            color: _getColor(recognition.score),
            child: Text(
              '${recognition.label} ${(recognition.score * 100).toStringAsFixed(0)}%',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getColor(double score) {
    if (score > 0.8) return Colors.greenAccent;
    if (score > 0.6) return Colors.orangeAccent;
    return Colors.redAccent;
  }
}
