import 'package:flutter/material.dart';

class TaskStatusColor {
  Map<String, Color> textToColorMap = {
    "Pending": Colors.yellow,
    "InProgress": Colors.blue,
    "Completed": Colors.green
  };

  Color getColorFromLabel(String label) {
    return textToColorMap[label]!;
  }
}
