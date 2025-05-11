import 'package:breakly/entities/reminder.dart';
import 'package:breakly/lib/routes.dart';
import 'package:breakly/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

const List<String> kRepeatOptions = <String>[
  'Every hour',
  'Every day',
  'Every week',
  'Every month',
  'Select weekdays',
  'Custom',
  'No repeat',
];

const List<String> kReminderTypes = <String>['Rest', 'Medicine'];

class ReminderFormData {
  String? title;
  String? description;
  DateTime? date;
  TimeOfDay? time;
  String? repeatOption;
  String? type;

  bool get isValid {
    return title != null &&
        title!.isNotEmpty &&
        date != null &&
        time != null &&
        type != null;
  }
}

class AddReminderScreen extends StatefulWidget {
  const AddReminderScreen({super.key});

  @override
  State<AddReminderScreen> createState() => _AddReminderScreenState();
}

class _AddReminderScreenState extends State<AddReminderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final _notificationService = NotificationService();

  final _formData = ReminderFormData();

  bool _titleHasError = false;
  bool _dateHasError = false;
  bool _timeHasError = false;
  bool _typeHasError = false;

  @override
  void initState() {
    super.initState();
    _notificationService.initialize();
  }

  Future<void> _scheduleNotification() async {
    if (_formData.date == null ||
        _formData.time == null ||
        _formData.title == null) {
      return;
    }

    final DateTime scheduledDate = DateTime(
      _formData.date!.year,
      _formData.date!.month,
      _formData.date!.day,
      _formData.time!.hour,
      _formData.time!.minute,
    );

    final Reminder reminder = await _notificationService.scheduleNotification(
      title: _formData.title!,
      description: _formData.description,
      scheduledDate: scheduledDate,
      type: _formData.type!,
      repeatOption: _formData.repeatOption,
      context: context,
    );

    // Print the reminder as JSON
    print('Reminder created: ${reminder.toJsonString()}');
  }

  DateTimeComponents? getRepeatInterval() {
    switch (_formData.repeatOption) {
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

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  String formatTime(TimeOfDay time) {
    final hours = time.hour.toString().padLeft(2, '0');
    final minutes = time.minute.toString().padLeft(2, '0');
    return '$hours:$minutes';
  }

  void validateForm() {
    setState(() {
      _titleHasError = _titleController.text.isEmpty;
      _dateHasError = _formData.date == null;
      _timeHasError = _formData.time == null;
      _typeHasError = _formData.type == null;
    });
  }

  void saveReminder() async {
    if (_formKey.currentState!.validate() && _formData.isValid) {
      await _scheduleNotification();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Reminder saved successfully!'),
          backgroundColor: Colors.white12,
        ),
      );
      context.replace(Routes.homePage);
    } else {
      validateForm();
    }
  }

  Future<void> showRepeatOptionsModal(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildModalHeader(context, 'Select Repeat Option'),
              const Divider(),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: kRepeatOptions.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(kRepeatOptions[index]),
                      trailing:
                          _formData.repeatOption == kRepeatOptions[index]
                              ? Icon(
                                Icons.check,
                                color: Theme.of(context).colorScheme.primary,
                              )
                              : null,
                      onTap: () {
                        setState(() {
                          _formData.repeatOption = kRepeatOptions[index];
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> showTypeOptionsModal(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildModalHeader(context, 'Select Type Option'),
              const Divider(),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: kReminderTypes.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(kReminderTypes[index]),
                      trailing:
                          _formData.type == kReminderTypes[index]
                              ? Icon(
                                Icons.check,
                                color: Theme.of(context).colorScheme.primary,
                              )
                              : null,
                      onTap: () {
                        setState(() {
                          _formData.type = kReminderTypes[index];
                          _typeHasError = false;
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Reusable widget for modal headers
  Widget buildModalHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: TextButton.icon(
        label: Text(title, style: Theme.of(context).textTheme.titleMedium),
        icon: const Icon(Icons.close),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Future<void> onTimePress() async {
    final ThemeData theme = Theme.of(context);
    final bool isDarkMode = theme.brightness == Brightness.dark;

    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _formData.time ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme:
                isDarkMode
                    ? ColorScheme.dark(
                      primary: theme.colorScheme.primary,
                      onPrimary: Colors.white,
                      surface: const Color(0xFF303030),
                      onSurface: Colors.white,
                    )
                    : ColorScheme.light(
                      primary: theme.colorScheme.primary,
                      onPrimary: Colors.white,
                      surface: Colors.white,
                      onSurface: Colors.black,
                    ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: theme.colorScheme.primary,
              ),
            ),
            dialogTheme: DialogTheme(
              backgroundColor:
                  isDarkMode ? const Color(0xFF303030) : Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedTime != null) {
      setState(() {
        _formData.time = pickedTime;
        _timeHasError = false;
      });
    }
  }

  Future<void> onDatePress() async {
    final ThemeData theme = Theme.of(context);
    final bool isDarkMode = theme.brightness == Brightness.dark;

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _formData.date ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme:
                isDarkMode
                    ? ColorScheme.dark(
                      primary: theme.colorScheme.primary,
                      onPrimary: Colors.white,
                      surface: const Color(0xFF303030),
                      onSurface: Colors.white,
                    )
                    : ColorScheme.light(
                      primary: theme.colorScheme.primary,
                      onPrimary: Colors.white,
                      surface: Colors.white,
                      onSurface: Colors.black,
                    ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: theme.colorScheme.primary,
              ),
            ),
            dialogTheme: DialogTheme(
              backgroundColor:
                  isDarkMode ? const Color(0xFF303030) : Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null) {
      setState(() {
        _formData.date = pickedDate;
        _dateHasError = false;
      });
    }
  }

  // Reusable widget for form field containers
  Widget buildFormField({
    required String label,
    required Widget content,
    bool hasError = false,
    String? errorText,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: hasError ? Colors.red : Theme.of(context).dividerColor,
            width: 1.0,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(color: hasError ? Colors.red : null),
              ),
              content,
            ],
          ),
          if (hasError && errorText != null)
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                errorText,
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Reminder'),
        actions: [
          TextButton(
            onPressed: _formData.isValid ? saveReminder : null,
            child: Text(
              'Save',
              style: TextStyle(
                color:
                    _formData.isValid
                        ? theme.colorScheme.primary
                        : theme.disabledColor,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // Title field
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  hintText: 'Enter reminder title',
                  border: const UnderlineInputBorder(),
                  errorText: _titleHasError ? 'Title is required' : null,
                ),
                onChanged: (value) {
                  setState(() {
                    _formData.title = value;
                    _titleHasError = value.isEmpty;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Title is required';
                  }
                  return null;
                },
              ),

              // Description field
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  hintText: 'Enter reminder description (optional)',
                  border: const UnderlineInputBorder(),
                ),
                onChanged: (value) {
                  _formData.description = value;
                },
                maxLines: 2,
              ),
              const SizedBox(height: 20),

              // Date field
              buildFormField(
                label: 'Date',
                hasError: _dateHasError,
                errorText: 'Date is required',
                content: TextButton.icon(
                  iconAlignment: IconAlignment.end,
                  label: Text(
                    _formData.date != null
                        ? formatDate(_formData.date!)
                        : 'Select date',
                    style: TextStyle(
                      color:
                          _formData.date != null
                              ? theme.textTheme.bodyMedium?.color
                              : theme.hintColor,
                    ),
                  ),
                  icon: const Icon(Icons.calendar_today),
                  onPressed: onDatePress,
                ),
              ),

              // Time field
              buildFormField(
                label: 'Time',
                hasError: _timeHasError,
                errorText: 'Time is required',
                content: TextButton.icon(
                  iconAlignment: IconAlignment.end,
                  label: Text(
                    _formData.time != null
                        ? formatTime(_formData.time!)
                        : 'Select time',
                    style: TextStyle(
                      color:
                          _formData.time != null
                              ? theme.textTheme.bodyMedium?.color
                              : theme.hintColor,
                    ),
                  ),
                  icon: const Icon(Icons.timer_outlined),
                  onPressed: onTimePress,
                ),
              ),

              buildFormField(
                label: 'Repeat',
                content: TextButton.icon(
                  iconAlignment: IconAlignment.end,
                  icon: const Icon(Icons.repeat),
                  onPressed: () => showRepeatOptionsModal(context),
                  label: Text(
                    _formData.repeatOption ?? 'No repeat',
                    style: TextStyle(
                      color:
                          _formData.repeatOption != null
                              ? theme.textTheme.bodyMedium?.color
                              : theme.hintColor,
                    ),
                  ),
                ),
              ),

              // Type field
              buildFormField(
                label: 'Type',
                hasError: _typeHasError,
                errorText: 'Type is required',
                content: TextButton.icon(
                  iconAlignment: IconAlignment.end,
                  icon: const Icon(Icons.category_outlined),
                  label: Text(
                    _formData.type ?? 'Select type',
                    style: TextStyle(
                      color:
                          _formData.type != null
                              ? theme.textTheme.bodyMedium?.color
                              : theme.hintColor,
                    ),
                  ),
                  onPressed: () => showTypeOptionsModal(context),
                ),
              ),

              const SizedBox(height: 40),

              // Save button
              ElevatedButton(
                onPressed: saveReminder,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Save Reminder',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
