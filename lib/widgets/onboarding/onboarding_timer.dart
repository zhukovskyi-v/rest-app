import 'package:flutter/material.dart';

class OnboardingTimer extends StatelessWidget {
  const OnboardingTimer({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 100,
          height: 100,
          child: CircularProgressIndicator(
            value: 0.25,
            strokeWidth: 6,
            valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.secondary,),
            backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.white12
              : Colors.black12,
          ),
        ),
        Text(
          '1:45',
          style:Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600)
        ),
      ],
    );
  }
}
