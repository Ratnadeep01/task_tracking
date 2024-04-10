import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:task_tracking/Models/TaskstatusColor.model.dart';
import 'package:task_tracking/Screens/create_task.screen.dart';
import 'package:task_tracking/Services/task_controller.service.dart';
import 'package:task_tracking/Utils/constants/colors.dart';

class TaskList extends StatefulWidget {
  TaskList({Key? key}) : super(key: key);

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  final TaskController taskController = Get.put(TaskController());

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double itemWidth = 400.spMin;
    int crossAxisCount = (screenWidth / itemWidth).floor();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Task List',
          style: TextStyle(color: TColors.white),
        ),
        backgroundColor: TColors.black,
        elevation: 0,
      ),
      body: Container(
        color: TColors.bodyBackground,
        child: taskController.tasks.isEmpty
            ? Center(
                child: Text(
                  "Add Tasks First",
                  style: TextStyle(fontSize: 18.spMin, color: TColors.white),
                ),
              )
            : Obx(
                () => Padding(
                  padding: EdgeInsets.all(10.spMin),
                  child: GridView.builder(
                      itemCount: taskController.tasks.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 6 / 2,
                          crossAxisCount: crossAxisCount),
                      itemBuilder: (BuildContext context, int index) {
                        final task = taskController.tasks[index];
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border:
                                Border.all(color: TColors.cardBorder, width: 2),
                            color: TColors.black,
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(10.spMin),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: 280.spMin,
                                      child: Text(
                                        task.title,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: TColors.headingColor,
                                          fontSize: 28.spMin,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 40.spMin,
                                      width: 80.spMin,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: TaskStatusColor()
                                                  .getColorFromLabel(
                                                      task.taskStatus)),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: TColors.bodyBackground),
                                      child: Center(
                                          child: Text(
                                        task.taskStatus,
                                        style: TextStyle(
                                            color: TaskStatusColor()
                                                .getColorFromLabel(
                                                    task.taskStatus),
                                            fontSize: 14.spMin,
                                            fontWeight: FontWeight.w600),
                                      )),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 20.spMin,
                                ),
                                Text(
                                  task.description,
                                  maxLines: 3,
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 18.spMin, color: TColors.white),
                                )
                              ],
                            ),
                          ),
                        );
                      }),
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: TColors.black,
          onPressed: () async {
            await Get.to(() => CreateTask());
            setState(() {});
          },
          child: Center(
              child: Icon(
            Icons.add,
            size: 18.spMin,
            color: TColors.white,
          ))),
    );
  }
}
