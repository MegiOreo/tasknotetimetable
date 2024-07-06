import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class TimetableEditor1 extends StatefulWidget {
  const TimetableEditor1({Key? key}) : super(key: key);

  @override
  State<TimetableEditor1> createState() => _TimetableEditor1State();
}

class _TimetableEditor1State extends State<TimetableEditor1> {
  List<Appointment> meetings = <Appointment>[];
  late DateTime selectedDateTime;
  late int selectedHours = 0;
  late int selectedMinutes = 0;
  TextEditingController subjectController = TextEditingController();
  TextEditingController placeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Timetable Editor'),
      ),
      body: SfCalendar(
        view: CalendarView.week,
        dataSource: MeetingDataSource(meetings),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddAppointmentDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddAppointmentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Appointment'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: subjectController,
                  decoration: InputDecoration(
                    labelText: 'Subject',
                  ),
                ),

                TextField(
                  controller: placeController,
                  decoration: InputDecoration(
                    labelText: 'Place',
                  ),
                ),

                SizedBox(height: 16),
                Text('Select Date and Time:'),
                ElevatedButton(
                  onPressed: () async {
                    final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now().subtract(Duration(days: 365)),
                      lastDate: DateTime.now().add(Duration(days: 365)),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        selectedDateTime = pickedDate;
                      });
                    }
                  },
                  child: Text('Select Date'),
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () async {
                    final TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (pickedTime != null) {
                      setState(() {
                        selectedDateTime = DateTime(
                          selectedDateTime.year,
                          selectedDateTime.month,
                          selectedDateTime.day,
                          pickedTime.hour,
                          pickedTime.minute,
                        );
                      });
                    }
                  },
                  child: Text('Select Time'),
                ),
                SizedBox(height: 16),
                Text('Select Duration:'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 60,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(labelText: 'Hours'),
                        onChanged: (value) {
                          setState(() {
                            selectedHours = int.tryParse(value) ?? 0;
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 16),
                    SizedBox(
                      width: 60,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(labelText: 'Minutes'),
                        onChanged: (value) {
                          setState(() {
                            selectedMinutes = int.tryParse(value) ?? 0;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                addAppointment();
                Navigator.pop(context);
              },
              child: Text('Add'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void addAppointment() {
    if (selectedDateTime != null) {
      final Duration selectedDuration = Duration(
        hours: selectedHours,
        minutes: selectedMinutes,
      );
      final DateTime endTime = selectedDateTime.add(selectedDuration);
      meetings.add(Appointment(
        startTime: selectedDateTime,
        endTime: endTime,
        subject: subjectController.text,
        color: Colors.blue,
        isAllDay: false,
      ));
      setState(() {
        subjectController.clear();
        placeController.clear();
        selectedDateTime = DateTime.now();
        selectedHours = 0;
        selectedMinutes = 0;
      });
    }
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
}