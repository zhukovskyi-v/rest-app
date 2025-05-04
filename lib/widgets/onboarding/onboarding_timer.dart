import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
import 'dart:async';

class OnboardingTimer extends StatefulWidget {
  final double height;

  final double width;

  final double strokeWidth;
  final bool withVibration;

  const OnboardingTimer({
    super.key,
    this.height = 100,
    this.width = 100,
    this.strokeWidth = 6,
    this.withVibration = false,
  });

  @override
  State<OnboardingTimer> createState() => _OnboardingTimerState();
}

class _OnboardingTimerState extends State<OnboardingTimer> with WidgetsBindingObserver{
  static const int totalSeconds = 119;
  late int secondsLeft;
  Timer? _timer;
  bool isCompleted = false;
  var isVibrationSupported = false;

  @override
  void initState() {
    super.initState();
    secondsLeft = totalSeconds;
    _startTimer();
    _checkVibration();
  }

  void _checkVibration() {
    if (widget.withVibration) {
      Vibration.hasVibrator().then((value) {
        setState(() {
          isVibrationSupported = value;
        });
      });
    }
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
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      setState(() {
        isVibrationSupported = false;
      });
    } else if (state == AppLifecycleState.resumed) {
      _checkVibration();
    }
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
          width: widget.width,
          height: widget.height,
          child: CircularProgressIndicator(
            value: _getProgress(),
            strokeWidth: widget.strokeWidth,
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
