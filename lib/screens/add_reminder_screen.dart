import 'package:breakly/models/reminder_type_option.dart';
import 'package:breakly/widgets/custom_animated_card.dart';
import 'package:breakly/widgets/reminder/reminder_type_card.dart';
import 'package:flutter/material.dart';
import 'package:breakly/models/reminder.dart';

class AddReminderScreen extends StatefulWidget {
  const AddReminderScreen({super.key});

  @override
  State<AddReminderScreen> createState() => _AddReminderScreenState();
}

class _AddReminderScreenState extends State<AddReminderScreen> {
  final List<ReminderTypeOption> _reminderOptions = [
    ReminderTypeOption(
      type: ReminderType.eyeRest,
      title: 'Break Reminder',
      icon: Icons.coffee,
      gradientColors: [const Color(0xFF6A3093), const Color(0xFFA044FF)],
    ),
    ReminderTypeOption(
      type: ReminderType.custom,
      title: 'Medication Reminder',
      icon: Icons.medication,
      gradientColors: [const Color(0xFF396AFC), const Color(0xFF2948FF)],
    ),
    ReminderTypeOption(
      type: ReminderType.stretch,
      title: 'Physiotherapy Reminder',
      icon: Icons.accessibility_new,
      gradientColors: [const Color(0xFF11998E), const Color(0xFF38EF7D)],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.surface),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Add Your First\nReminder',
                style: textTheme.headlineLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              Expanded(
                child: ListView(
                  children: [
                    ..._reminderOptions.map(
                      (option) => Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: ReminderTypeCard(option: option),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: _buildCustomReminderCard(theme),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Reminders help you stay consistent and healthy.',
                      style: textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomReminderCard(ThemeData theme) {
    return CustomAnimatedCard(
      onTap: () {
        // Handle custom reminder creation
        print('Create custom reminder tapped');
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Text(
            'Create Custom Reminder',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.inverseSurface,
            ),
          ),
        ),
      ),
    );
  }
}
