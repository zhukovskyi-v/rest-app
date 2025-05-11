import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
import 'dart:async';
import 'dart:math' as math;

class HomeTimer extends StatefulWidget {
  final double height;
  final double width;
  final double strokeWidth;
  final bool withVibration;
  final DateTime? targetDate;
  final Color? progressColor;
  final Color? backgroundColor;

  const HomeTimer({
    super.key,
    this.height = 180,
    this.width = 180,
    this.strokeWidth = 10,
    this.withVibration = false,
    this.targetDate,
    this.progressColor,
    this.backgroundColor,
  });

  @override
  State<HomeTimer> createState() => _HomeTimerState();
}

class _HomeTimerState extends State<HomeTimer>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  Timer? _timer;
  bool isCompleted = false;
  bool isVibrationSupported = false;
  DateTime? _endTime;
  Duration _timeRemaining = Duration.zero;
  late AnimationController _pulseController;

  static const int minutesInHour = 60;
  static const int secondsInMinute = 60;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _initializeTimer();
    _checkVibration();
  }

  void _initializeTimer() {
    if (widget.targetDate != null) {
      _endTime = widget.targetDate;
      _updateTimeRemaining();
    }
    _startTimer();
  }

  void _updateTimeRemaining() {
    if (_endTime != null) {
      final now = DateTime.now();
      if (_endTime!.isAfter(now)) {
        setState(() {
          _timeRemaining = _endTime!.difference(now);
        });

        if (_timeRemaining.inMinutes < 1 && !_pulseController.isAnimating) {
          _pulseController.repeat(reverse: true);
        } else if (_timeRemaining.inMinutes >= 1 &&
            _pulseController.isAnimating) {
          _pulseController.stop();
          _pulseController.reset();
        }
      } else {
        setState(() {
          _timeRemaining = Duration.zero;
          isCompleted = true;
        });
        _timer?.cancel();
        _pulseController.stop();
      }
    }
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
      _updateTimeRemaining();

      if (_timeRemaining == Duration.zero) {
        setState(() {
          isCompleted = true;
        });
        _timer?.cancel();

        if (isVibrationSupported) {
          Vibration.vibrate(duration: 500);
        }
      } else if (isVibrationSupported && widget.withVibration) {
        // Add subtle vibration for each second in the last 10 seconds
        if (_timeRemaining.inSeconds <= 10) {
          Vibration.vibrate(duration: 20);
        }
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    _pulseController.dispose();
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
      _updateTimeRemaining();
    }
  }

  @override
  void didUpdateWidget(HomeTimer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.targetDate != oldWidget.targetDate) {
      _timer?.cancel();
      _initializeTimer();
    }
  }

  // Adaptive progress calculation based on remaining time
  double _getProgress() {
    if (_timeRemaining == Duration.zero) {
      return 1.0;
    }

    final totalSeconds = _timeRemaining.inSeconds;

    // For short durations (under 5 minutes), use a 5-minute scale
    if (totalSeconds <= 5 * minutesInHour) {
      return 1.0 - (totalSeconds / (5 * minutesInHour));
    }

    // For medium durations (under 1 hour), use a 1-hour scale
    if (totalSeconds <= minutesInHour * secondsInMinute) {
      return 1.0 - (totalSeconds / (minutesInHour * secondsInMinute));
    }

    // For longer durations (1-12 hours), use a 12-hour scale
    if (totalSeconds <= 12 * minutesInHour * secondsInMinute) {
      return 1.0 - (totalSeconds / (12 * minutesInHour * secondsInMinute));
    }

    // For very long durations (over 12 hours), cap at 0.0 (empty circle)
    return 0.0;
  }

  String _getTimeString() {
    final hours = _timeRemaining.inHours;
    final minutes = _timeRemaining.inMinutes % 60;
    final seconds = _timeRemaining.inSeconds % 60;

    if (hours > 0) {
      return '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
  }

  String _getHumanReadableTime() {
    final hours = _timeRemaining.inHours;
    final minutes = _timeRemaining.inMinutes % 60;

    if (hours > 0 && minutes > 0) {
      return '$hours hr $minutes min';
    } else if (hours > 0) {
      return '$hours hour${hours > 1 ? 's' : ''}';
    } else if (minutes > 0) {
      return '$minutes minute${minutes > 1 ? 's' : ''}';
    } else {
      return 'Less than a minute';
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color progressColor =
        widget.progressColor ?? theme.colorScheme.secondary;
    final Color backgroundColor =
        widget.backgroundColor ??
        (theme.brightness == Brightness.dark ? Colors.white12 : Colors.black12);

    final Color accentColor = theme.colorScheme.primary;

    final bool isLastMinute =
        _timeRemaining.inMinutes < 1 && _timeRemaining.inSeconds > 0;

    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        final double pulseValue =
            isLastMinute ? 1.0 + (_pulseController.value * 0.1) : 1.0;

        return Transform.scale(
          scale: pulseValue,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: widget.width,
                height: widget.height,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: backgroundColor.withOpacity(0.1),
                  boxShadow: [
                    BoxShadow(
                      color:
                          isLastMinute
                              ? accentColor.withOpacity(
                                0.2 * _pulseController.value,
                              )
                              : Colors.transparent,
                      blurRadius: 15,
                      spreadRadius: 5,
                    ),
                  ],
                ),
              ),

              SizedBox(
                width: widget.width,
                height: widget.height,
                child: CircularProgressIndicator(
                  value: _getProgress(),
                  strokeWidth: widget.strokeWidth,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isLastMinute
                        ? Color.lerp(
                              progressColor,
                              accentColor,
                              _pulseController.value,
                            ) ??
                            progressColor
                        : progressColor,
                  ),
                  backgroundColor: backgroundColor,
                  strokeCap: StrokeCap.round,
                ),
              ),

              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _getTimeString(),
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 28,
                      color:
                          isLastMinute
                              ? Color.lerp(
                                theme.textTheme.titleLarge?.color ??
                                    Colors.white,
                                accentColor,
                                _pulseController.value,
                              )
                              : theme.textTheme.titleLarge?.color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _getHumanReadableTime(),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.textTheme.bodyMedium?.color?.withOpacity(
                        0.7,
                      ),
                    ),
                  ),
                  if (_endTime != null)
                    Text(
                      'Until ${_endTime!.hour}:${_endTime!.minute.toString().padLeft(2, '0')}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.textTheme.bodySmall?.color?.withOpacity(
                          0.7,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
