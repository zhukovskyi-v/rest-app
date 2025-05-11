import 'package:breakly/entities/reminder.dart';
import 'package:breakly/repositories/notification_repository.dart';
import 'package:flutter/foundation.dart';

class SupabaseNotificationRepository implements NotificationRepository {
  // TODO: Implement Supabase client and configuration

  @override
  Future<Reminder> saveReminder(Reminder reminder) async {
    // TODO: Implement Supabase save logic
    throw UnimplementedError('Supabase repository not implemented yet');
  }

  @override
  Future<List<Reminder>> getAllReminders() async {
    // TODO: Implement Supabase fetch logic
    throw UnimplementedError('Supabase repository not implemented yet');
  }

  @override
  Future<Reminder?> getReminderById(int id) async {
    // TODO: Implement Supabase fetch by id logic
    throw UnimplementedError('Supabase repository not implemented yet');
  }

  @override
  Future<Reminder> updateReminder(Reminder reminder) async {
    // TODO: Implement Supabase update logic
    throw UnimplementedError('Supabase repository not implemented yet');
  }

  @override
  Future<bool> deleteReminder(int id) async {
    // TODO: Implement Supabase delete logic
    throw UnimplementedError('Supabase repository not implemented yet');
  }

  @override
  Future<bool> deleteAllReminders() async {
    // TODO: Implement Supabase delete all logic
    throw UnimplementedError('Supabase repository not implemented yet');
  }

  @override
  Future<List<Reminder>> getFutureReminders() {
    // TODO: implement getFutureReminders
    throw UnimplementedError();
  }
}
