import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tasknotetimetable/Timetable/timetableEditor.dart';
import 'package:tasknotetimetable/Timetable/timetableEditor1.dart';
import 'package:tasknotetimetable/auth.dart';

class AddScheduleWidget extends StatefulWidget {
  AddScheduleWidget({Key? key}) : super(key: key);

  final User? user = Auth().currentUser;

  @override
  State<AddScheduleWidget> createState() => _AddScheduleWidgetState();
}

class _AddScheduleWidgetState extends State<AddScheduleWidget> {
  List<String> savedTimetables = []; // List to store saved timetables

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF1F4F8),
      appBar: AppBar(
        title: Text(
          'Page Title',
          style: TextStyle(color: Colors.white, fontSize: 22),
        ),
        backgroundColor: Colors.blue,
        actions: [],
        centerTitle: false,
        elevation: 2,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: IconButton(
                      iconSize: 32,
                      icon: Icon(
                        Icons.add,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        print('IconButton pressed ...');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TimetableEditor(),
                            //builder: (context) => TimetableEditor1(),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(width: 16), // Add spacing between buttons
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: savedTimetables.length,
                      itemBuilder: (context, index) {
                        return ElevatedButton(
                          onPressed: () {
                            // Display the respective timetable
                            print('Timetable ${savedTimetables[index]} clicked.');
                          },
                          child: Text(savedTimetables[index]),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            if (savedTimetables.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Text(
                  'No schedules yet...',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
