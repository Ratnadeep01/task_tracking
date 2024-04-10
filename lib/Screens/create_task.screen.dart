import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_tracking/Services/task_controller.service.dart';

import '../Models/Task.model.dart';
import '../Models/TaskstatusColor.model.dart';
import '../Utils/constants/colors.dart';

class CreateTask extends StatefulWidget {
  CreateTask({Key? key}) : super(key: key);

  @override
  State<CreateTask> createState() => _CreateTaskState();
}

class _CreateTaskState extends State<CreateTask> {
  final ChipSelectionController _chipSelectionController =
      Get.put(ChipSelectionController());

  RxBool noChipSelected = true.obs;

  RxBool showChipError = false.obs;

  final TextEditingController _titleController = TextEditingController();

  final TextEditingController _descriptionController = TextEditingController();

  final TaskController taskController = Get.put(TaskController());

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget buildChoiceChip(String label) {
    String chipLabel = _chipSelectionController.selectedLabel.value;
    bool chipSelected = chipLabel == label;
    return ChoiceChip(
      backgroundColor: TColors.black,
      selectedColor: TColors.black,
      shape: RoundedRectangleBorder(
          side: BorderSide(
              width: 2,
              color: chipSelected
                  ? TaskStatusColor().getColorFromLabel(chipLabel)
                  : Colors.grey)),
      label: Text(label),
      selected: chipSelected,
      onSelected: (bool selected) {
        noChipSelected.value = false;
        showChipError.value = false;
        _chipSelectionController.setSelectedLabel(label);
      },
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      labelStyle: TextStyle(
        color: chipSelected
            ? TaskStatusColor().getColorFromLabel(chipLabel)
            : Colors.grey,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Create Task',
          style: TextStyle(color: TColors.white),
        ),
        backgroundColor: TColors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          color: TColors.bodyBackground,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    cursorColor: TColors.cardBorder,
                    controller: _titleController,
                    decoration: InputDecoration(
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: TColors.cardBorder),
                      ),

                      labelText: 'Title',

                      labelStyle: const TextStyle(
                          color: Colors.grey), // Customize label text color
                      border: OutlineInputBorder(
                        // Add border
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      filled: true, // Apply background color
                      fillColor: TColors.black,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 16.0), // Adjust padding
                      prefixIcon: const Icon(
                        Icons.title,
                        color: TColors.cardBorder,
                      ), // Add prefix icon
                    ),
                    style: const TextStyle(color: TColors.white),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    maxLines: 8,
                    cursorColor: TColors.cardBorder,
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: TColors.cardBorder),
                      ),

                      labelText: 'Description',
                      labelStyle: const TextStyle(
                          color: Colors.grey), // Customize label text color
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      filled: true, // Apply background color
                      fillColor: TColors.black,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 16.0), // Adjust padding
                      prefixIcon: const Icon(
                        Icons.title,
                        color: TColors.cardBorder,
                      ), // Add prefix icon
                    ),
                    style: const TextStyle(color: TColors.white),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a Description';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      'Current Status of your task',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.spMin,
                          color: TColors.headingColor),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.start,
                      alignment: WrapAlignment.start,
                      runSpacing: 10,
                      spacing: 20,
                      children: [
                        Obx(() => buildChoiceChip('Pending')),
                        Obx(() => buildChoiceChip('InProgress')),
                        Obx(() => buildChoiceChip('Completed')),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 12.spMin,
                  ),
                  Obx(() {
                    return Visibility(
                      visible: showChipError.value,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          'Please select your task status',
                          style:
                              TextStyle(color: Colors.red, fontSize: 12.spMin),
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 32.0),
                  MaterialButton(
                    height: 50.spMin,
                    minWidth: 250.spMin,
                    shape: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    color: Colors.black,
                    onPressed: () {
                      if (_formKey.currentState!.validate() &&
                          noChipSelected.isFalse) {
                        SharedPreferences.getInstance();
                        Task task = Task(
                            title: _titleController.text,
                            description: _descriptionController.text,
                            taskStatus:
                                _chipSelectionController.selectedLabel.value);
                        taskController.addTask(task);
                        setState(() {});
                        Navigator.pop(context);
                      }
                      if (noChipSelected.isTrue) {
                        showChipError.value = true;
                      }
                    },
                    child: Text(
                      'SAVE',
                      style: TextStyle(
                          color: TColors.white,
                          fontSize: 18.spMin,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ChipSelectionController extends GetxController {
  RxString selectedLabel = "".obs;

  void setSelectedLabel(String label) {
    selectedLabel.value = label;
  }
}
