import 'package:breakly/entities/reminder.dart';
import 'package:flutter/material.dart';

class ReminderHomeCard extends StatelessWidget {
  final Reminder reminder;
  final IconData icon;
  final Color iconColor;

  const ReminderHomeCard({
    super.key,
    required this.reminder,
    required this.icon,
    required this.iconColor,
  });

  String _getFormattedTimeUntil() {
    final now = DateTime.now();
    final scheduledDate = reminder.scheduledDate;

    if (scheduledDate.isBefore(now)) {
      return 'Overdue';
    }

    final difference = scheduledDate.difference(now);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ${difference.inHours % 24}h';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ${difference.inMinutes % 60}m';
    } else {
      return '${difference.inMinutes}m';
    }
  }

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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getFormattedTimeUntil(),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  reminder.title,
                  style: theme.textTheme.bodyMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
