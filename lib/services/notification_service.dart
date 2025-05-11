import 'package:breakly/entities/reminder.dart';
import 'package:breakly/repositories/notification_repository.dart';
import 'package:breakly/repositories/sqlite_notification_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'dart:io' show Platform;
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_init;

enum DateTimeRepeatComponent { time, dayOfWeekAndTime, dayOfMonthAndTime, none }

class NotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final List<NotificationRepository> _repositories = [];

  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() {
    return _instance;
  }

  NotificationService._internal() {
    _repositories.add(SQLiteNotificationRepository());
  }

  void addRepository(NotificationRepository repository) {
    _repositories.add(repository);
  }

  Future<void> initialize() async {
    tz_init.initializeTimeZones();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    final InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsDarwin,
        );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (
        NotificationResponse notificationResponse,
      ) async {
        // Handle notification tap
        final String? payload = notificationResponse.payload;
        if (payload != null) {
          debugPrint('Notification payload: $payload');
          if (payload.startsWith('reminder_')) {
            final int? notificationId = notificationResponse.id;
            if (notificationId != null) {
              await updateReminderAfterTrigger(notificationId);
            }
          }
        }
      },
    );

    // Request permissions for iOS
    if (Platform.isIOS) {
      await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    }
  }

  DateTimeComponents? _getRepeatInterval(String? repeatOption) {
    switch (repeatOption) {
      case 'Every hour':
        return DateTimeComponents.time;
      case 'Every day':
        return DateTimeComponents.time;
      case 'Every week':
        return DateTimeComponents.dayOfWeekAndTime;
      case 'Every month':
        return DateTimeComponents.dayOfMonthAndTime;
      default:
        return null;
    }
  }

  Future<Reminder> scheduleNotification({
    required String title,
    String? description,
    required DateTime scheduledDate,
    required String type,
    String? repeatOption,
    required BuildContext context,
  }) async {
    try {
      final tz.TZDateTime scheduledTZDate = tz.TZDateTime.from(
        scheduledDate,
        tz.local,
      );

      final AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
            'reminder_channel_id',
            'Reminder Notifications',
            channelDescription: 'Channel for reminder notifications',
            importance: Importance.max,
            priority: Priority.high,
            sound: const RawResourceAndroidNotificationSound('timer_sound'),
          );

      final DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        sound: 'timer_sound.aiff',
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      final NotificationDetails notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      final int notificationId = scheduledDate.millisecondsSinceEpoch ~/ 1000;

      await _flutterLocalNotificationsPlugin.zonedSchedule(
        notificationId,
        title,
        description ?? 'Time for your reminder!',
        scheduledTZDate,
        notificationDetails,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: 'reminder_$type',
        matchDateTimeComponents: _getRepeatInterval(repeatOption),
        androidScheduleMode: AndroidScheduleMode.alarmClock,
      );

      final reminder = Reminder(
        id: notificationId,
        title: title,
        description: description,
        scheduledDate: scheduledDate,
        type: type,
        repeatOption: repeatOption,
      );

      // Calculate next trigger date for repeating reminders
      final Reminder finalReminder =
          repeatOption != null ? reminder.calculateNextTrigger() : reminder;

      for (final repository in _repositories) {
        await repository.saveReminder(finalReminder);
      }

      debugPrint('Scheduled reminder: ${finalReminder.toJsonString()}');

      return finalReminder;
    } catch (exception, stackTrace) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error scheduling notification. ${exception.toString()}',
            ),
            backgroundColor: Colors.white12,
          ),
        );
      }
      await Sentry.captureException(exception, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<void> updateReminderAfterTrigger(int id) async {
    if (_repositories.isEmpty) {
      return;
    }

    final reminder = await _repositories[0].getReminderById(id);
    if (reminder != null && reminder.repeatOption != null) {
      // Update the last triggered date to now and calculate the next trigger
      final updatedReminder =
          Reminder(
            id: reminder.id,
            title: reminder.title,
            description: reminder.description,
            scheduledDate: reminder.scheduledDate,
            type: reminder.type,
            repeatOption: reminder.repeatOption,
            lastTriggeredDate: DateTime.now(),
            nextTriggerDate: reminder.nextTriggerDate,
          ).calculateNextTrigger();

      await updateReminder(updatedReminder);
    }
  }

  Future<List<Reminder>> getFutureReminders() async {
    if (_repositories.isEmpty) {
      return [];
    }
    return await _repositories[0].getFutureReminders();
  }

  Future<List<Reminder>> getAllReminders() async {
    if (_repositories.isEmpty) {
      return [];
    }
    return await _repositories[0].getAllReminders();
  }

  Future<Reminder?> getReminderById(int id) async {
    if (_repositories.isEmpty) {
      return null;
    }
    return await _repositories[0].getReminderById(id);
  }

  Future<Reminder> updateReminder(Reminder reminder) async {
    if (_repositories.isEmpty) {
      throw Exception('No repositories available');
    }

    // Update in all repositories
    for (final repository in _repositories) {
      await repository.updateReminder(reminder);
    }

    return reminder;
  }

  Future<bool> deleteReminder(int id) async {
    if (_repositories.isEmpty) {
      return false;
    }

    bool result = true;

    // Delete from all repositories
    for (final repository in _repositories) {
      final success = await repository.deleteReminder(id);
      result = result && success;
    }

    return result;
  }

  Future<bool> deleteAllReminders() async {
    if (_repositories.isEmpty) {
      return false;
    }

    bool result = true;

    // Delete from all repositories
    for (final repository in _repositories) {
      final success = await repository.deleteAllReminders();
      result = result && success;
    }

    return result;
  }
}
