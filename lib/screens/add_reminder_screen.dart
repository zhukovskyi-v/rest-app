import 'package:flutter/material.dart';

const List<String> list = <String>[
  'Every hour',
  'Every day',
  'Every week',
  'Every month',
  'Select weekdays',
  'Custom',
  'No repeat',
];

const List<String> listType = <String>['Rest', 'Medicine'];

class AddReminderScreen extends StatefulWidget {
  const AddReminderScreen({super.key});

  @override
  State<AddReminderScreen> createState() => _AddReminderScreenState();
}

class _AddReminderScreenState extends State<AddReminderScreen> {
  final titleController = TextEditingController();

  final descriptionController = TextEditingController();

  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  String? _selectedRepeatOption;

  String? _selectedTypeOption;

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> _showRepeatOptionsModal(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
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
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Select Repeat Option',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              const Divider(),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: list.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(list[index]),
                      onTap: () {
                        setState(() {
                          _selectedRepeatOption = list[index];
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

  Future<void> _showTypeOptionsModal(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
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
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Select Type Option',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              const Divider(),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: listType.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(listType[index]),
                      onTap: () {
                        setState(() {
                          _selectedTypeOption = listType[index];
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Reminder')),
      floatingActionButton: FloatingActionButton(
        onPressed: null,
        tooltip: 'Add Reminder',
        disabledElevation: 0.0,
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: Icon(Icons.add),
      ),
      body: SafeArea(
        child: Center(
          child: ListView(
            children: [
              const SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.only(left: 25, right: 25),
                child: TextFormField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    border: UnderlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.only(left: 25, right: 25),
                child: TextFormField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: UnderlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.only(left: 25, right: 25),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Theme.of(context).dividerColor,
                        width: 1.0,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Date'),
                      Row(
                        children: [
                          Text(
                            selectedDate != null
                                ? '${selectedDate?.day}/${selectedDate?.month}/${selectedDate?.year}'
                                : '',
                          ),
                          IconButton(
                            icon: Icon(Icons.calendar_today),
                            onPressed: () async {
                              final ThemeData theme = Theme.of(context);
                              final bool isDarkMode =
                                  theme.brightness == Brightness.dark;

                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: selectedDate,
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2101),
                                builder: (context, child) {
                                  return Theme(
                                    data: Theme.of(context).copyWith(
                                      colorScheme:
                                          isDarkMode
                                              ? ColorScheme.dark(
                                                primary:
                                                    theme.colorScheme.primary,
                                                onPrimary: Colors.white,
                                                surface: const Color(
                                                  0xFF303030,
                                                ),
                                                onSurface: Colors.white,
                                              )
                                              : ColorScheme.light(
                                                primary:
                                                    theme.colorScheme.primary,
                                                onPrimary: Colors.white,
                                                surface: Colors.white,
                                                onSurface: Colors.black,
                                              ),
                                      textButtonTheme: TextButtonThemeData(
                                        style: TextButton.styleFrom(
                                          foregroundColor:
                                              theme.colorScheme.primary,
                                        ),
                                      ),
                                      dialogTheme: DialogThemeData(
                                        backgroundColor:
                                            isDarkMode
                                                ? const Color(0xFF303030)
                                                : Colors.white,
                                      ),
                                    ),
                                    child: child!,
                                  );
                                },
                              );
                              if (pickedDate != null &&
                                  pickedDate != selectedDate) {
                                setState(() {
                                  selectedDate = pickedDate;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.only(left: 25, right: 25),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Theme.of(context).dividerColor,
                        width: 1.0,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Time'),
                      Row(
                        children: [
                          Text(
                            selectedTime != null
                                ? '${selectedTime?.hour}-${selectedTime?.minute}'
                                : '',
                          ),
                          IconButton(
                            icon: Icon(Icons.timer_outlined),
                            onPressed: () async {
                              final ThemeData theme = Theme.of(context);
                              final bool isDarkMode =
                                  theme.brightness == Brightness.dark;

                              TimeOfDay? pickedDate = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                                builder: (context, child) {
                                  return Theme(
                                    data: Theme.of(context).copyWith(
                                      colorScheme:
                                          isDarkMode
                                              ? ColorScheme.dark(
                                                primary:
                                                    theme.colorScheme.primary,
                                                onPrimary: Colors.white,
                                                surface: const Color(
                                                  0xFF303030,
                                                ),
                                                onSurface: Colors.white,
                                              )
                                              : ColorScheme.light(
                                                primary:
                                                    theme.colorScheme.primary,
                                                onPrimary: Colors.white,
                                                surface: Colors.white,
                                                onSurface: Colors.black,
                                              ),
                                      textButtonTheme: TextButtonThemeData(
                                        style: TextButton.styleFrom(
                                          foregroundColor:
                                              theme.colorScheme.primary,
                                        ),
                                      ),
                                      dialogTheme: DialogThemeData(
                                        backgroundColor:
                                            isDarkMode
                                                ? const Color(0xFF303030)
                                                : Colors.white,
                                      ),
                                    ),
                                    child: child!,
                                  );
                                },
                              );
                              setState(() {
                                selectedTime = pickedDate;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.only(left: 25, right: 25),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Theme.of(context).dividerColor,
                        width: 1.0,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Repeat'),
                      Row(
                        children: [
                          Text(_selectedRepeatOption ?? ''),
                          IconButton(
                            icon: Icon(Icons.repeat),
                            onPressed: () async {
                              _showRepeatOptionsModal(context);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.only(left: 25, right: 25),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Theme.of(context).dividerColor,
                        width: 1.0,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Type'),
                      Row(
                        children: [
                          Text(_selectedTypeOption ?? ''),
                          IconButton(
                            icon: Icon(Icons.bloodtype_outlined),
                            onPressed: () async {
                              _showTypeOptionsModal(context);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
