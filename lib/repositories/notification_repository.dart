import 'package:breakly/entities/reminder.dart';

abstract class NotificationRepository {
  Future<Reminder> saveReminder(Reminder reminder);

  Future<List<Reminder>> getAllReminders();

  Future<Reminder?> getReminderById(int id);

  Future<Reminder> updateReminder(Reminder reminder);

  Future<bool> deleteReminder(int id);

  Future<bool> deleteAllReminders();

  Future<List<Reminder>> getFutureReminders();
}
