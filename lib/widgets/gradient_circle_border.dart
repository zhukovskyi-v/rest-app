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
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(width: borderWidth, color: Colors.transparent),
        gradient: SweepGradient(
          colors: [
            colorScheme.primary.withValues(alpha: 0.8),
            colorScheme.secondary,
            colorScheme.primary.withValues(alpha: 0.8),
          ],
          startAngle: 0.0,
          endAngle: 3.14 * 2,
        ),
      ),
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
