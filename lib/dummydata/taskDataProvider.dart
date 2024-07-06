import 'package:flutter/material.dart';

class TaskDataProvider extends ChangeNotifier {
  final List<List<String>> _taskData = [
    ['lab4', 'use case diagram', '3 days'],
    ['assignment1', 'individual', '40 minutes'],
    ['lab4', 'use case diagram', '3 days'],
    ['lab4', 'use case diagram', '3 days'],
    ['lab4', 'use case diagram', '3 days'],
    ['lab4', 'use case diagram', '3 days'],
    ['lab4', 'use case diagram', '3 days'],
    ['lab4', 'use case diagram', '3 days'],
    ['lab4', 'use case diagram', '3 days'],
    ['lab4', 'use case diagram', '3 days'],
    ['lab5', 'use case diagram', '3 days'],
    ['lab6', 'use case diagram', '3 days'],
    ['lab5', 'use case diagram', '3 days'],
  ];

  List<List<String>> get taskData => _taskData;

  void addTask(List<String> newTask) {
    _taskData.add(newTask);
    notifyListeners();
  }
}
