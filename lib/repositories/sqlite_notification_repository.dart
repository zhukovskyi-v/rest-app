import 'package:breakly/entities/reminder.dart';
import 'package:breakly/repositories/notification_repository.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/foundation.dart';

class SQLiteNotificationRepository implements NotificationRepository {
  static const String _tableName = 'reminders';
  static Database? _database;
  static const int _databaseVersion = 2;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final String path = join(await getDatabasesPath(), 'reminders.db');
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: (Database db, int version) async {
        await _createDatabase(db);
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        if (oldVersion < 2) {
          await _upgradeToV2(db);
        }
      },
    );
  }

  Future<void> _createDatabase(Database db) async {
    await db.execute('''
      CREATE TABLE $_tableName (
        id INTEGER PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT,
        scheduledDate TEXT NOT NULL,
        type TEXT NOT NULL,
        repeatOption TEXT,
        lastTriggeredDate TEXT,
        nextTriggerDate TEXT
      )
    ''');
  }

  Future<void> _upgradeToV2(Database db) async {
    // Add new columns for repeat functionality
    await db.execute('ALTER TABLE $_tableName ADD COLUMN lastTriggeredDate TEXT');
    await db.execute('ALTER TABLE $_tableName ADD COLUMN nextTriggerDate TEXT');
    
    // Update existing repeating reminders to calculate next trigger date
    final List<Map<String, dynamic>> reminders = await db.query(
      _tableName,
      where: 'repeatOption IS NOT NULL',
    );
    
    for (final reminderMap in reminders) {
      final reminder = Reminder.fromJson(reminderMap);
      final updatedReminder = reminder.calculateNextTrigger();
      
      await db.update(
        _tableName,
        updatedReminder.toJson(),
        where: 'id = ?',
        whereArgs: [reminder.id],
      );
    }
  }

  @override
  Future<Reminder> saveReminder(Reminder reminder) async {
    final db = await database;
    
    // For repeating reminders, calculate the next trigger date
    Reminder reminderToSave = reminder;
    if (reminder.repeatOption != null && reminder.nextTriggerDate == null) {
      reminderToSave = reminder.calculateNextTrigger();
    }
    
    await db.insert(
      _tableName,
      reminderToSave.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    debugPrint('Saved reminder to SQLite: ${reminderToSave.toJsonString()}');
    return reminderToSave;
  }

  @override
  Future<List<Reminder>> getAllReminders() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(_tableName);
    return List.generate(maps.length, (i) {
      return Reminder.fromJson(maps[i]);
    });
  }

  @override
  Future<List<Reminder>> getFutureReminders() async {
    final db = await database;
    final now = DateTime.now();
    final String nowString = now.toIso8601String();

    // Get non-repeating reminders with future scheduledDate
    final List<Map<String, dynamic>> nonRepeatingMaps = await db.query(
      _tableName,
      where: 'scheduledDate > ? AND repeatOption IS NULL',
      whereArgs: [nowString],
      orderBy: 'scheduledDate ASC',
    );

    // Get repeating reminders with future nextTriggerDate
    final List<Map<String, dynamic>> repeatingMaps = await db.query(
      _tableName,
      where: 'nextTriggerDate > ? AND repeatOption IS NOT NULL',
      whereArgs: [nowString],
      orderBy: 'nextTriggerDate ASC',
    );

    // Combine both lists
    final List<Map<String, dynamic>> allMaps = [
      ...nonRepeatingMaps,
      ...repeatingMaps,
    ];

    return List.generate(allMaps.length, (i) {
      return Reminder.fromJson(allMaps[i]);
    });
  }

  @override
  Future<Reminder?> getReminderById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) {
      return null;
    }

    return Reminder.fromJson(maps.first);
  }

  @override
  Future<Reminder> updateReminder(Reminder reminder) async {
    final db = await database;
    
    // For repeating reminders, recalculate the next trigger date if needed
    Reminder reminderToUpdate = reminder;
    if (reminder.repeatOption != null && 
        (reminder.nextTriggerDate == null || 
         reminder.nextTriggerDate!.isBefore(DateTime.now()))) {
      reminderToUpdate = reminder.calculateNextTrigger();
    }
    
    await db.update(
      _tableName,
      reminderToUpdate.toJson(),
      where: 'id = ?',
      whereArgs: [reminder.id],
    );
    return reminderToUpdate;
  }

  @override
  Future<bool> deleteReminder(int id) async {
    final db = await database;
    final int rowsDeleted = await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    return rowsDeleted > 0;
  }

  @override
  Future<bool> deleteAllReminders() async {
    final db = await database;
    final int rowsDeleted = await db.delete(_tableName);
    return rowsDeleted > 0;
  }
}
