import 'package:flutter/material.dart';

class OnboardingNotification extends StatelessWidget {
  const OnboardingNotification({super.key});

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.notifications_active_outlined,
      size: 100,
      color: Theme.of(context).textTheme.bodyMedium?.color,
    );
  }
}