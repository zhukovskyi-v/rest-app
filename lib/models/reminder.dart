enum ReminderType {
  eyeRest,
  stretch,
  hydration,
  posture,
  custom
}

class Reminder {
  final int? id;
  final int userId;
  final String name;
  final String? description;
  final ReminderType type;
  final int duration; // in minutes
  final int? intervalMinutes;
  final List<String>? customTimes;
  final List<int> activeDays; // 1-7 for Monday-Sunday
  final int priority; // 1-3 for low, medium, high
  final String? sound;
  final String? vibration;
  final bool isEnabled;
  final int createdAt;
  
  Reminder({
    this.id,
    required this.userId,
    required this.name,
    this.description,
    required this.type,
    required this.duration,
    this.intervalMinutes,
    this.customTimes,
    required this.activeDays,
    required this.priority,
    this.sound,
    this.vibration,
    required this.isEnabled,
    int? createdAt,
  }) : createdAt = createdAt ?? DateTime.now().millisecondsSinceEpoch;
  
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'user_id': userId,
      'name': name,
      'description': description,
      'type': type.toString().split('.').last,
      'duration': duration,
      'interval_minutes': intervalMinutes,
      'custom_times': customTimes?.join(','),
      'active_days': activeDays.join(','),
      'priority': priority,
      'sound': sound,
      'vibration': vibration,
      'is_enabled': isEnabled ? 1 : 0,
      'created_at': createdAt,
    };
  }
  
  factory Reminder.fromMap(Map<String, dynamic> map) {
    return Reminder(
      id: map['id'],
      userId: map['user_id'],
      name: map['name'],
      description: map['description'],
      type: ReminderType.values.firstWhere(
        (e) => e.toString().split('.').last == map['type'],
        orElse: () => ReminderType.custom,
      ),
      duration: map['duration'],
      intervalMinutes: map['interval_minutes'],
      customTimes: map['custom_times']?.split(','),
      activeDays: map['active_days'].split(',').map((e) => int.parse(e)).toList(),
      priority: map['priority'],
      sound: map['sound'],
      vibration: map['vibration'],
      isEnabled: map['is_enabled'] == 1,
      createdAt: map['created_at'],
    );
  }
  
  Reminder copyWith({
    int? id,
    int? userId,
    String? name,
    String? description,
    ReminderType? type,
    int? duration,
    int? intervalMinutes,
    List<String>? customTimes,
    List<int>? activeDays,
    int? priority,
    String? sound,
    String? vibration,
    bool? isEnabled,
    int? createdAt,
  }) {
    return Reminder(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      duration: duration ?? this.duration,
      intervalMinutes: intervalMinutes ?? this.intervalMinutes,
      customTimes: customTimes ?? this.customTimes,
      activeDays: activeDays ?? this.activeDays,
      priority: priority ?? this.priority,
      sound: sound ?? this.sound,
      vibration: vibration ?? this.vibration,
      isEnabled: isEnabled ?? this.isEnabled,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}