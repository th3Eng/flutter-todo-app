import 'package:get/get.dart';
import '/db/db_helper.dart';
import '/models/task.dart';

class TaskController extends GetxController {
  final taskList = <Task>[];

  addTask({required Task task}) async {
    return DBHelper().insert(task);
  }

  getTasks() {}
}
