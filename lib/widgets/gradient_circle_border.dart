import 'package:flutter/material.dart';

import 'gradient_corder_painter.dart';

class GradientCircleBorder extends StatelessWidget {
  final double size;
  final double borderWidth;
  final List<Color> gradientColors;

  const GradientCircleBorder({
    super.key,
    this.size = 120,
    this.borderWidth = 6,
    this.gradientColors = const [Color(0xFF00E0FF), Color(0xFF7F53FF)],
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: GradientBorderPainter(
          borderWidth: borderWidth,
          gradientColors: gradientColors,
        ),
      ),
    );
  }
}