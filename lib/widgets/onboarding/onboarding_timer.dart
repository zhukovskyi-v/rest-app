import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
import 'dart:async';

class OnboardingTimer extends StatefulWidget {
  const OnboardingTimer({super.key});

  @override
  State<OnboardingTimer> createState() => _OnboardingTimerState();
}

class _OnboardingTimerState extends State<OnboardingTimer> {
  static const int totalSeconds = 119;
  late int secondsLeft;
  Timer? _timer;
  bool isCompleted = false;
  var isVibrationSupported = true;

  @override
  void initState() {
    super.initState();
    secondsLeft = totalSeconds;
    _startTimer();
    Vibration.hasVibrator().then((value){
      isVibrationSupported = value;
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (secondsLeft > 0) {
        setState(() {
          secondsLeft--;
        });
        if (isVibrationSupported) {
          Vibration.vibrate(duration: 20);
        }
      } else {
        setState(() {
          isCompleted = true;
        });
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  double _getProgress() {
    return 1.0 - (secondsLeft / totalSeconds);
  }

  String _getTimeString() {
    final int minutes = secondsLeft ~/ 60;
    final int seconds = secondsLeft % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 100,
          height: 100,
          child: CircularProgressIndicator(
            value: _getProgress(),
            strokeWidth: 6,
            valueColor: AlwaysStoppedAnimation<Color>(
              theme.colorScheme.secondary,
            ),
            backgroundColor:
                theme.brightness == Brightness.dark
                    ? Colors.white12
                    : Colors.black12,
          ),
        ),
        Text(
          _getTimeString(),
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
