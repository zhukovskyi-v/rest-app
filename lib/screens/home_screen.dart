import 'package:breakly/entities/reminder.dart';
import 'package:breakly/lib/routes.dart';
import 'package:breakly/service/auth_api.dart';
import 'package:breakly/services/notification_service.dart';
import 'package:breakly/widgets/home/home_timer.dart';
import 'package:breakly/widgets/home/reminder_home_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

Reminder? _findNextReminder(List<Reminder> reminders) {
  final now = DateTime.now();
  for (final reminder in reminders) {
    if (reminder.scheduledDate.isAfter(now)) {
      return reminder;
    }
  }
  return null;
}

IconData _getIconForReminderType(String type) {
  switch (type) {
    case 'Eye Rest':
      return Icons.remove_red_eye;
    case 'Short Break':
      return Icons.coffee;
    case 'Long Break':
      return Icons.self_improvement;
    case 'Stretching':
      return Icons.accessibility_new;
    case 'Water':
      return Icons.water_drop;
    default:
      return Icons.notifications;
  }
}

Color _getColorForReminderType(String type, ColorScheme colorScheme) {
  switch (type) {
    case 'Eye Rest':
      return Colors.blue;
    case 'Short Break':
      return colorScheme.primary;
    case 'Long Break':
      return Colors.green;
    case 'Stretching':
      return Colors.orange;
    case 'Water':
      return Colors.lightBlue;
    default:
      return colorScheme.secondary;
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NotificationService _notificationService = NotificationService();
  List<Reminder> _reminders = [];
  bool _isLoading = true;
  Reminder? _nextReminder;

  @override
  void initState() {
    super.initState();
    _loadReminders();
  }

  Future<void> _loadReminders() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final reminders = await _notificationService.getFutureReminders();

      reminders.sort((a, b) => b.scheduledDate.compareTo(a.scheduledDate));

      setState(() {
        _reminders = reminders;
        _nextReminder = _findNextReminder(reminders);
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading reminders: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: colorScheme.secondary.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: Icon(Icons.add, color: colorScheme.secondary),
                onPressed: () {
                  context.go(Routes.nestedAddReminder);
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: Icon(Icons.refresh, color: colorScheme.secondary),
                onPressed: _loadReminders,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: Icon(Icons.logout, color: colorScheme.secondary),
                onPressed: () {
                  context.read<AuthAPI>().signOut();
                  Navigator.pushReplacementNamed(context, '/authentication');
                },
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child:
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: ListView(
                    children: [
                      const SizedBox(height: 20),
                      if (_nextReminder != null)
                        Center(
                          child: Column(
                            children: [
                              Text(
                                'Next Reminder In:',
                                style: textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 10),
                              HomeTimer(
                                height: 180,
                                width: 180,
                                strokeWidth: 10,
                                targetDate: _nextReminder!.scheduledDate,
                              ),
                              const SizedBox(height: 40),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Upcoming Reminders',
                                    style: textTheme.titleMedium?.copyWith(
                                      color: textTheme.bodyMedium?.color,
                                      fontSize: 20,
                                    ),
                                  ),
                                  Text(
                                    '${_reminders.length} reminders',
                                    style: textTheme.bodyMedium?.copyWith(
                                      color: textTheme.bodyMedium?.color
                                          ?.withOpacity(0.7),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                      // Reminder Cards
                      if (_reminders.isEmpty)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.notifications_off,
                                  size: 64,
                                  color: colorScheme.primary.withOpacity(0.5),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No reminders yet',
                                  style: textTheme.titleMedium,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Tap the + button to add your first reminder',
                                  style: textTheme.bodyMedium,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        ...List.generate(_reminders.length, (index) {
                          final reminder = _reminders[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: ReminderHomeCard(
                              reminder: reminder,
                              icon: _getIconForReminderType(reminder.type),
                              iconColor: _getColorForReminderType(
                                reminder.type,
                                colorScheme,
                              ),
                            ),
                          );
                        }),
                    ],
                  ),
                ),
      ),
    );
  }
}
