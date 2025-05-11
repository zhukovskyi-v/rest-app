import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
import 'dart:async';

class OnboardingTimer extends StatefulWidget {
  final double height;
  final double width;
  final double strokeWidth;
  final bool withVibration;
  final DateTime? targetDate;

  const OnboardingTimer({
    super.key,
    this.height = 100,
    this.width = 100,
    this.strokeWidth = 6,
    this.withVibration = false,
    this.targetDate,
  });

  @override
  State<OnboardingTimer> createState() => _OnboardingTimerState();
}

class _OnboardingTimerState extends State<OnboardingTimer>
    with WidgetsBindingObserver {
  static const int totalSeconds = 119;
  late int secondsLeft;
  Timer? _timer;
  bool isCompleted = false;
  var isVibrationSupported = false;
  DateTime? _endTime;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeTimer();
    _checkVibration();
  }

  void _initializeTimer() {
    if (widget.targetDate != null) {
      _endTime = widget.targetDate;
      final now = DateTime.now();
      final difference = _endTime!.difference(now);
      secondsLeft = difference.inSeconds > 0 ? difference.inSeconds : 0;
    } else {
      secondsLeft = totalSeconds;
    }
    _startTimer();
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
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      setState(() {
        isVibrationSupported = false;
      });
    } else if (state == AppLifecycleState.resumed) {
      _checkVibration();
      // Recalculate time left if using targetDate
      if (_endTime != null) {
        final now = DateTime.now();
        final difference = _endTime!.difference(now);
        setState(() {
          secondsLeft = difference.inSeconds > 0 ? difference.inSeconds : 0;
        });
      }
    }
  }

  @override
  void didUpdateWidget(OnboardingTimer oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update timer if targetDate changes
    if (widget.targetDate != oldWidget.targetDate) {
      _timer?.cancel();
      _initializeTimer();
    }
  }

  double _getProgress() {
    if (widget.targetDate != null) {
      final now = DateTime.now();
      final total =
          _endTime!
              .difference(now.subtract(Duration(seconds: secondsLeft)))
              .inSeconds;
      return total > 0 ? 1.0 - (secondsLeft / total) : 1.0;
    }
    return 1.0 - (secondsLeft / totalSeconds);
  }

  String _getTimeString() {
    if (secondsLeft >= 3600) {
      final int hours = secondsLeft ~/ 3600;
      final int minutes = (secondsLeft % 3600) ~/ 60;
      return '$hours:${minutes.toString().padLeft(2, '0')}';
    } else {
      final int minutes = secondsLeft ~/ 60;
      final int seconds = secondsLeft % 60;
      return '$minutes:${seconds.toString().padLeft(2, '0')}';
    }
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
