enum BreakStatus {
  scheduled,
  completed,
  skipped,
  snoozed
}

class BreakRecord {
  final int? id;
  final int reminderId;
  final BreakStatus status;
  final int scheduledAt;
  final int? completedAt;
  final int? duration; // actual duration in minutes
  
  BreakRecord({
    this.id,
    required this.reminderId,
    required this.status,
    required this.scheduledAt,
    this.completedAt,
    this.duration,
  });
  
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'reminder_id': reminderId,
      'status': status.toString().split('.').last,
      'scheduled_at': scheduledAt,
      'completed_at': completedAt,
      'duration': duration,
    };
  }
  
  factory BreakRecord.fromMap(Map<String, dynamic> map) {
    return BreakRecord(
      id: map['id'],
      reminderId: map['reminder_id'],
      status: BreakStatus.values.firstWhere(
        (e) => e.toString().split('.').last == map['status'],
      ),
      scheduledAt: map['scheduled_at'],
      completedAt: map['completed_at'],
      duration: map['duration'],
    );
  }
  
  BreakRecord copyWith({
    int? id,
    int? reminderId,
    BreakStatus? status,
    int? scheduledAt,
    int? completedAt,
    int? duration,
  }) {
    return BreakRecord(
      id: id ?? this.id,
      reminderId: reminderId ?? this.reminderId,
      status: status ?? this.status,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      completedAt: completedAt ?? this.completedAt,
      duration: duration ?? this.duration,
    );
  }
}