import 'package:breakly/widgets/home/reminder_home_card.dart';
import 'package:breakly/widgets/onboarding/onboarding_timer.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> showImmediateNotification() async {
    // ... existing code ...
  }

  Future<void> scheduleNotification() async {
    // ... existing code ...
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
        title: Text(
          'Breakly',
          style: textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.secondary,
          ),
        ),
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
                  Navigator.pushNamed(context, '/add-reminder');
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: theme.cardTheme.color,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: textTheme.bodyMedium?.color?.withValues(
          alpha: 0.5,
        ),
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Stats'),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: ListView(
            children: [
              SizedBox(height: 20),
              Center(
                child: Column(
                  children: [
                    Text('Next Reminder In:', style: textTheme.bodyMedium),
                    const SizedBox(height: 10),
                    const OnboardingTimer(
                      height: 180,
                      width: 180,
                      strokeWidth: 10,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              // Upcoming Reminders
              Text(
                'Upcoming Reminders',
                style: textTheme.titleMedium?.copyWith(
                  color: textTheme.bodyMedium?.color,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 16),
              // Reminder Cards
              ReminderHomeCard(
                time: '1h 20m',
                title: 'Short Break',
                icon: Icons.coffee,
                iconColor: colorScheme.primary,
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
