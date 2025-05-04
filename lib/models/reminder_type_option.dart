import 'package:breakly/models/reminder.dart';
import 'package:flutter/material.dart';

class ReminderTypeOption {
  final ReminderType type;
  final String title;
  final IconData icon;
  final List<Color> gradientColors;

  ReminderTypeOption({
    required this.type,
    required this.title,
    required this.icon,
    required this.gradientColors,
  });
}
