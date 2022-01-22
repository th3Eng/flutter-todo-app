import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo/models/task.dart';
import 'package:todo/ui/widgets/button.dart';
import 'package:todo/ui/widgets/input_field.dart';

import '/controllers/task_controller.dart';
import '../theme.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController _taskController = Get.put(TaskController());
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  String _startTime = DateFormat('hh:mm a').format(DateTime.now()).toString();
  String _endTime = DateFormat('hh:mm a')
      .format(DateTime.now().add(const Duration(hours: 1)))
      .toString();
  int _selectedRemind = 5;

  List<int> remindList = [5, 10, 15, 20];
  String _selectedRepeat = 'none';
  List<String> repeatList = ['none', 'Daily', 'Weekly', 'Monthly'];
  int _selectedColor = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: context.theme.backgroundColor,
        appBar: _appBar(),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  'Add task',
                  style: Themes().headingStyle,
                ),
                InputField(
                  controller: _titleController,
                  title: 'Title',
                  hint: 'Enter title here',
                ),
                InputField(
                  controller: _noteController,
                  title: 'Note',
                  hint: 'Enter note here',
                ),
                InputField(
                  title: 'Date',
                  hint: DateFormat.yMd().format(_selectedDate),
                  widget: IconButton(
                    onPressed: () => _getDateFromUser(),
                    icon: const Icon(
                      Icons.calendar_today,
                      color: Colors.grey,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: InputField(
                        title: 'Start Time',
                        hint: _startTime,
                        widget: IconButton(
                          onPressed: () => _getTimeFromUser(isStartTime: true),
                          icon: const Icon(
                            Icons.access_time_rounded,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: InputField(
                        title: 'End Time',
                        hint: _endTime,
                        widget: IconButton(
                          onPressed: () => _getTimeFromUser(isStartTime: false),
                          icon: const Icon(
                            Icons.access_time_rounded,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                InputField(
                  title: 'Reminder',
                  hint: '$_selectedRemind minutes early',
                  widget: Row(
                    children: [
                      DropdownButton(
                        borderRadius: BorderRadius.circular(10),
                        dropdownColor: Colors.blueGrey,
                        items: remindList
                            .map<DropdownMenuItem<String>>(
                              (int value) =>
                              DropdownMenuItem(
                                value: value.toString(),
                                child: Text(
                                  '$value',
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                        )
                            .toList(),
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.grey,
                        ),
                        iconSize: 32,
                        elevation: 4,
                        style: Themes().subTitleStyle,
                        onChanged: (String? newVal) {
                          setState(() {
                            _selectedRemind = int.parse(newVal!);
                          });
                        },
                        underline: Container(
                          height: 0,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                ),
                InputField(
                  title: 'Repeats',
                  hint: _selectedRepeat,
                  widget: Row(
                    children: [
                      DropdownButton(
                        dropdownColor: Colors.blueGrey,
                        borderRadius: BorderRadius.circular(10),
                        items: repeatList
                            .map<DropdownMenuItem<String>>(
                              (String value) =>
                              DropdownMenuItem(
                                value: value,
                                child: Text(
                                  value,
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                        )
                            .toList(),
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.grey,
                        ),
                        iconSize: 32,
                        elevation: 4,
                        style: Themes().subTitleStyle,
                        onChanged: (String? newVal) {
                          setState(() {
                            _selectedRepeat = newVal!;
                          });
                        },
                        underline: Container(
                          height: 0,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _colorPalette(),
                    MyButton(
                        label: 'Create Task', onTap: () => _validateDate()),
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  Column _colorPalette() {
    return Column(
      children: [
        Text(
          'Color',
          style: Themes().titleStyle,
        ),
        const SizedBox(
          height: 10,
        ),
        Wrap(
          children: List<Widget>.generate(
              3,
                  (index) =>
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedColor = index;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: CircleAvatar(
                        child: _selectedColor == index
                            ? const Icon(
                          Icons.done,
                          color: Colors.white,
                        )
                            : null,
                        backgroundColor: index == 0
                            ? primaryClr
                            : index == 1
                            ? pinkClr
                            : orangeClr,
                      ),
                    ),
                  )),
        )
      ],
    );
  }

  AppBar _appBar() =>
      AppBar(
        elevation: 0,
        backgroundColor: context.theme.backgroundColor,
        centerTitle: true,
        actions: const [
          CircleAvatar(
            backgroundImage: AssetImage('images/person.jpeg'),
            radius: 18,
          ),
          SizedBox(
            width: 15,
          )
        ],
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 24,
            color: primaryClr,
          ),
        ),
      );

  _validateDate() {
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      _addTasksToDb();
      Get.back();
    } else if (_titleController.text.isEmpty ||
        _noteController.text.isEmpty) {
      Get.snackbar(
        'Required',
        'All fields are required',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: primaryClr,
        icon: const Icon(
          Icons.warning_amber_rounded,
          color: Colors.red,
        ),
      );
    } else {
      print('############ SOMETHING BAD HAPPENED ############');
    }
  }

  _addTasksToDb() async {
    int value = await _taskController.addTask(
      task: Task(
        title: _titleController.text,
        note: _noteController.text,
        isCompleted: 0,
        date: DateFormat.yMd().format(_selectedDate),
        startTime: _startTime,
        endTime: _endTime,
        color: _selectedColor,
        remind: _selectedRemind,
        repeat: _selectedRepeat,
      ),
    );
    debugPrint('$value');
  }

  _getDateFromUser() async{
    DateTime? _pickedDate = await showDatePicker(context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2015),
      lastDate: DateTime(2030),);
    if(_pickedDate!=null) {
      setState(() {
        _selectedDate = _pickedDate;
      });
    }
  }
  _getTimeFromUser({required bool isStartTime}) async{
    TimeOfDay? _pickedDate = await showTimePicker(context: context,
      initialEntryMode: TimePickerEntryMode.input,
      initialTime: isStartTime?TimeOfDay.fromDateTime(DateTime.now()):TimeOfDay.fromDateTime(DateTime.now().add(const Duration(hours: 1))),);

    String _formattedTime = _pickedDate!.format(context);
    if(isStartTime)
      setState(() {
        _startTime = _formattedTime;
      });
    else if(!isStartTime)
      setState(() {
        _endTime = _formattedTime;
      });
    else {print('time canceled or something is wrong!');}

  }
}
