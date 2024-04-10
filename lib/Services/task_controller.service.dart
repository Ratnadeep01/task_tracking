import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Models/Task.model.dart';

class TaskController extends GetxController {
  RxList<Task> tasks = <Task>[].obs;

  @override
  void onInit() {
    super.onInit();
    retrieveTasks();
  }

  void addTask(Task newTask) {
    tasks.add(newTask);
    saveTasks();
  }

  void saveTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> taskList =
        tasks.map((task) => "${task.title}###${task.description}").toList();
    await prefs.setStringList('tasks', taskList);
  }

  void retrieveTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? taskList = prefs.getStringList('tasks');
    if (taskList != null) {
      tasks.assignAll(
        taskList.map((taskString) {
          List<String> taskData = taskString.split("###");
          return Task(title: taskData[0], description: taskData[1]);
        }).toList(),
      );
    }
  }
}
