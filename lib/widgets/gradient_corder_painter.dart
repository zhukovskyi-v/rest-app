import 'package:flutter/material.dart';

class GradientBorderPainter extends CustomPainter {
  final double borderWidth;
  final List<Color> gradientColors;

  GradientBorderPainter({
    required this.borderWidth,
    required this.gradientColors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final Paint paint =
        Paint()
          ..shader = SweepGradient(colors: gradientColors).createShader(rect)
          ..style = PaintingStyle.stroke
          ..strokeWidth = borderWidth;

    final double radius = (size.width / 2) - (borderWidth / 2);
    canvas.drawCircle(size.center(Offset.zero), radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
