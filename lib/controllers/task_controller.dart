import 'package:get/get.dart';

import '/db/db_helper.dart';
import '/models/task.dart';

class TaskController extends GetxController {
  final RxList<Task> taskList = <Task>[].obs;

  Future<int> addTask({required Task task}) {
    return DBHelper().insert(task);
  }

  Future<void> getTasks() async {
    final List<Map<String, dynamic>> tasks = await DBHelper().query();
    taskList.assignAll(tasks.map((element) => Task.fromJson(element)).toList());
  }

  void deleteTasks({required Task task}) async {
    await DBHelper().delete(task);
    getTasks();
  }

  void deleteAll() async {
    await DBHelper().deleteAll();
    getTasks();
  }

  void markAsCompleted({required int id}) async {
    await DBHelper().update(id);
    getTasks();
  }
}
