import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:task_tracking/Screens/task_list.screen.dart';

import 'Services/task_controller.service.dart';

void main() {
  Get.put(TaskController());
  runApp(const TaskTrackingApp());
}

class TaskTrackingApp extends StatelessWidget {
  const TaskTrackingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(412, 915),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Task Tracker',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: TaskList(),
        );
      },
    );
  }
}
