import 'package:flutter/material.dart';

class TaskStatusColor {
  Map<int, Color> textToColorMap = {
    0: Colors.yellow,
    1: Colors.blue,
    2: Colors.green
  };

  Color getColorFromIndex(int index) {
    return textToColorMap[index]!;
  }
}
