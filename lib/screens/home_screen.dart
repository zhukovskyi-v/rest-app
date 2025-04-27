import 'package:breakly/constants/constants.dart';
import 'package:breakly/service/auth_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:timezone/timezone.dart' as tz;

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> showImmediateNotification() async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'immediate_channel_id',
          'Immediate Notifications',
          channelDescription: 'Channel for instant notifications',
          sound: RawResourceAndroidNotificationSound('timer_sound'),
          // твій звук
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
        );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      sound: 'timer_sound.aiff', // iOS версія звуку
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      'Одразу сповіщення 🔥',
      'Це миттєве сповіщення!',
      notificationDetails,
    );
  }

  Future<void> scheduleNotification() async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'timer_channel_id_1',
          'Timer Notifications',
          channelDescription: 'Channel for timer alarms',
          sound: RawResourceAndroidNotificationSound('timer_sound'),
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
        );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      sound: 'timer_sound.aiff',
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Таймер завершено!',
      'Ваш таймер закінчився 🎵',
      tz.TZDateTime.now(tz.local).add(const Duration(seconds: 10)),
      notificationDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: ElevatedButton(
        onPressed: () {
          context.read<AuthAPI>().signOut();
          Navigator.pushReplacementNamed(context, '/authentication');
        },
        child: Text(
          'Logout',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.inverseSurface,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(child: Text('Home Screen')),
          ElevatedButton(
            onPressed: scheduleNotification,
            child: Text(
              'Schedule Timer',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.inverseSurface,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: showImmediateNotification,
            child: Text(
              'Start Timer',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.inverseSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
