import 'package:flutter/material.dart';

class ReminderHomeCard extends StatelessWidget {
  final String time;
  final String title;
  final IconData icon;
  final Color iconColor;

  const ReminderHomeCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.time,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                time,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(title, style: theme.textTheme.bodyMedium),
            ],
          ),
        ],
      ),
    );
  }
}
