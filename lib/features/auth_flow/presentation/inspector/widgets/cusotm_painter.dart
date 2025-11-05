import 'package:flutter/material.dart';

class TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 5
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final triangle = Path();
    triangle.moveTo(186, 0);
    canvas.drawPath(triangle, paint);
    triangle.relativeLineTo(-24, 0);
    triangle.relativeLineTo(12, 12);

    triangle.close();
    canvas.drawPath(triangle, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
