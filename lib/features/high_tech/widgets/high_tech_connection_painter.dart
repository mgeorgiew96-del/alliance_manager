import 'package:flutter/material.dart';

import '../models/high_tech_tree_layout.dart';

class HighTechConnectionPainter extends CustomPainter {
  const HighTechConnectionPainter({required this.layout});

  final HighTechTreeLayout layout;

  @override
  void paint(Canvas canvas, Size size) {
    final shadowPaint = Paint()
      ..color = const Color(0x66000000)
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final linePaint = Paint()
      ..color = const Color(0xFFC89B4A)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    for (final connection in layout.connections) {
      final startCenter = layout.centerFor(connection.fromNodeId);
      final endCenter = layout.centerFor(connection.toNodeId);

      final start = Offset(
        startCenter.dx,
        startCenter.dy + (highTechNodeHeight / 2),
      );
      final end = Offset(endCenter.dx, endCenter.dy - (highTechNodeHeight / 2));

      final midpointY = (start.dy + end.dy) / 2;
      final path = Path()
        ..moveTo(start.dx, start.dy)
        ..cubicTo(start.dx, midpointY, end.dx, midpointY, end.dx, end.dy);

      canvas.drawPath(path, shadowPaint);
      canvas.drawPath(path, linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant HighTechConnectionPainter oldDelegate) {
    return oldDelegate.layout != layout;
  }
}
