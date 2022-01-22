import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '/controllers/task_controller.dart';
import '/models/task.dart';
import '/services/notification_services.dart';
import '/services/theme_services.dart';
import '/ui/size_config.dart';
import '/ui/widgets/button.dart';
import '/ui/widgets/task_tile.dart';
import '../theme.dart';
import 'add_task_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late NotifyHelper notifyHelper;

  @override
  void initState() {
    super.initState();
    notifyHelper = NotifyHelper();
    _taskController.getTasks();
  }

  final TaskController _taskController = TaskController();
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _appBar(),
      body: Column(
        children: [
          _addTaskBar(),
          _addDateBar(),
          const SizedBox(
            height: 6,
          ),
          _showTasks(),
        ],
      ),
    );
  }

  AppBar _appBar() => AppBar(
    elevation: 0,
        backgroundColor: context.theme.backgroundColor,
        centerTitle: true,
        actions: [
          IconButton(
              color: Get.isDarkMode ? Colors.white : darkGreyClr,
              onPressed: () {
                NotifyHelper().cancelAllNotification();
                _taskController.deleteAll();
              },
              icon: const Icon(Icons.cleaning_services_outlined)),
          const SizedBox(
            width: 15,
          ),
          const CircleAvatar(
            backgroundImage: AssetImage('images/person.jpeg'),
            radius: 18,
          ),
          const SizedBox(
            width: 15,
          )
        ],
        leading: IconButton(
          color: primaryClr,
          onPressed: () {
            ThemeServices().switchTheme();
            // notifyHelper.displayNotification(
            //     title: 'the title', body: 'the body of the notification');
            // notifyHelper.scheduledNotification(
            //     title: 'Scheduled notification title',
            //     body: 'the Scheduled notification description');
          },
          icon: Icon(
            Get.isDarkMode
                ? Icons.wb_sunny_outlined
                : Icons.nightlight_round_outlined,
            size: 24,
          ),
        ),
      );

  Container _addTaskBar() => Container(
        margin: const EdgeInsets.only(left: 20, right: 10, top: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat.yMMMMd().format(DateTime.now()),
                  style: Themes().subHeadingStyle,
                ),
                Text(
                  'Today',
                  style: Themes().headingStyle,
                )
              ],
            ),
            const SizedBox(
              width: 10,
            ),
            MyButton(
              onTap: () async {
                await Get.to(const AddTaskPage());
                _taskController.getTasks();
              },
              label: 'Add Task',
            )
          ],
        ),
      );

  _addDateBar() {
    return Container(
      margin: const EdgeInsets.only(top: 6),
      child: DatePicker(
        DateTime.now(),
        daysCount: 90,
        initialSelectedDate: DateTime.now(),
        dayTextStyle: Themes().dayStyle,
        dateTextStyle: Themes().dateStyle,
        monthTextStyle: Themes().monthStyle,
        width: 80,
        height: 100,
        selectedTextColor: Colors.white,
        selectionColor: primaryClr,
        onDateChange: (newDate) {
          setState(() {
            _selectedDate = newDate;
          });
        },
      ),
    );
  }

  _showTasks() {
    return Expanded(
      child: Obx(() => _taskController.taskList.isEmpty
          ? _noTaskMsg()
          : RefreshIndicator(
              onRefresh: () => _taskController.getTasks(),
              child: ListView.builder(
                scrollDirection: SizeConfig.orientation == Orientation.portrait
                    ? Axis.vertical
                    : Axis.horizontal,
                itemCount: _taskController.taskList.length,
                itemBuilder: (BuildContext context, int index) {
                  Task task = _taskController.taskList[index];
                  if (task.date != DateFormat.yMd().format(_selectedDate) &&
                      task.repeat != 'Daily')
                    return Container(
                      height: 0,
                    );
                  var myDate = DateFormat('hh:mm')
                      .format(DateFormat.jm().parse(task.startTime!));
                  var hour = myDate.split(':')[0];
                  var minute = myDate.split(':')[1];
                  notifyHelper.scheduledNotification(
                      int.parse(hour), int.parse(minute), task);
                  return AnimationConfiguration.staggeredList(
                    duration: const Duration(milliseconds: 750),
                    position: index,
                    child: SlideAnimation(
                      horizontalOffset: 300,
                      child: FadeInAnimation(
                        child: GestureDetector(
                            onTap: () => _showButtomSheet(context, task),
                            child: TaskTile(task)),
                      ),
                    ),
                  );
                },
              ),
            )),
    );
  }

  _noTaskMsg() {
    return Center(
      child: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(seconds: 1),
            child: SingleChildScrollView(
              child: Wrap(
                direction: SizeConfig.orientation == Orientation.portrait
                    ? Axis.vertical
                    : Axis.horizontal,
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  SvgPicture.asset(
                    'images/task.svg',
                    color: primaryClr.withOpacity(0.75),
                    height: SizeConfig.orientation == Orientation.portrait
                        ? 300
                        : SizeConfig.screenHeight * 0.3,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Text(
                      'You do not have any tasks yet!\nAdd new tasks to make your days productive',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  _showButtomSheet(BuildContext context, Task task) {
    Get.bottomSheet(SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.only(top: 4),
        width: SizeConfig.screenWidth,
        height: SizeConfig.orientation == Orientation.landscape
            ? task.isCompleted == 0
                ? SizeConfig.screenHeight * 0.6
                : SizeConfig.screenHeight * 0.8
            : task.isCompleted == 0
                ? SizeConfig.screenHeight * 0.3
                : SizeConfig.screenHeight * 0.39,
        color: Get.isDarkMode ? darkHeaderClr : Colors.white,
        child: Column(
          children: [
            Flexible(
                child: Container(
              height: 6,
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300],
              ),
            )),
            const SizedBox(height: 20),
            task.isCompleted == 1
                ? Container()
                : _buildBottomSheet(
                    label: 'Task Completed?',
                    onTap: () {
                      _taskController.markAsCompleted(id: task.id!);
                      Get.back();
                    },
                    clr: primaryClr,
                  ),
            _buildBottomSheet(
              label: 'Delete task',
              onTap: () {
                _taskController.deleteTasks(task: task);
                Get.back();
              },
              clr: primaryClr,
            ),
            Divider(
              color: Get.isDarkMode ? Colors.grey : darkGreyClr,
            ),
            _buildBottomSheet(
              label: 'Cancel',
              onTap: () {
                Get.back();
              },
              clr: primaryClr,
            ),
          ],
        ),
      ),
    ));
  }

  _buildBottomSheet(
      {required String label,
      required Function() onTap,
      required Color clr,
      bool isClose = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 50,
        width: SizeConfig.screenWidth * 0.9,
        decoration: BoxDecoration(
            border: Border.all(
              width: 2,
              color: isClose
                  ? Get.isDarkMode
                      ? Colors.grey[600]!
                      : Colors.grey[300]!
                  : clr,
            ),
            borderRadius: BorderRadius.circular(20),
            color: isClose ? Colors.transparent : clr),
        child: Center(
          child: Text(
            label,
            style: isClose
                ? Themes().titleStyle
                : Themes().titleStyle.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
