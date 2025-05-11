import 'dart:convert';

class Reminder {
  final int id;
  final String title;
  final String? description;
  final DateTime scheduledDate;
  final String type;
  final String? repeatOption;
  final DateTime? lastTriggeredDate;
  final DateTime? nextTriggerDate;

  Reminder({
    required this.id,
    required this.title,
    this.description,
    required this.scheduledDate,
    required this.type,
    this.repeatOption,
    this.lastTriggeredDate,
    this.nextTriggerDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'scheduledDate': scheduledDate.toIso8601String(),
      'type': type,
      'repeatOption': repeatOption,
      'lastTriggeredDate': lastTriggeredDate?.toIso8601String(),
      'nextTriggerDate': nextTriggerDate?.toIso8601String(),
    };
  }

  factory Reminder.fromJson(Map<String, dynamic> json) {
    return Reminder(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      scheduledDate: DateTime.parse(json['scheduledDate']),
      type: json['type'],
      repeatOption: json['repeatOption'],
      lastTriggeredDate: json['lastTriggeredDate'] != null 
          ? DateTime.parse(json['lastTriggeredDate']) 
          : null,
      nextTriggerDate: json['nextTriggerDate'] != null 
          ? DateTime.parse(json['nextTriggerDate']) 
          : null,
    );
  }

  String toJsonString() {
    return jsonEncode(toJson());
  }

  static Reminder fromJsonString(String jsonString) {
    return Reminder.fromJson(jsonDecode(jsonString));
  }

  /// Calculate the next trigger date based on repeat option
  Reminder calculateNextTrigger() {
    if (repeatOption == null) {
      return this;
    }

    final DateTime baseDate = lastTriggeredDate ?? scheduledDate;
    DateTime? calculatedNextTrigger;

    switch (repeatOption) {
      case 'Every hour':
        calculatedNextTrigger = DateTime(
          baseDate.year, 
          baseDate.month, 
          baseDate.day, 
          baseDate.hour + 1, 
          baseDate.minute,
        );
        break;
      case 'Every day':
        calculatedNextTrigger = DateTime(
          baseDate.year, 
          baseDate.month, 
          baseDate.day + 1, 
          baseDate.hour, 
          baseDate.minute,
        );
        break;
      case 'Every week':
        calculatedNextTrigger = DateTime(
          baseDate.year, 
          baseDate.month, 
          baseDate.day + 7, 
          baseDate.hour, 
          baseDate.minute,
        );
        break;
      case 'Every month':
        calculatedNextTrigger = DateTime(
          baseDate.year, 
          baseDate.month + 1, 
          baseDate.day, 
          baseDate.hour, 
          baseDate.minute,
        );
        break;
    }

    return Reminder(
      id: id,
      title: title,
      description: description,
      scheduledDate: scheduledDate,
      type: type,
      repeatOption: repeatOption,
      lastTriggeredDate: baseDate,
      nextTriggerDate: calculatedNextTrigger,
    );
  }

  @override
  String toString() {
    return 'Reminder(id: $id, title: $title, type: $type, scheduledDate: $scheduledDate, repeatOption: $repeatOption)';
  }
}
