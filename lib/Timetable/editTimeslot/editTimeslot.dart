import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tasknotetimetable/auth.dart';
import 'package:tasknotetimetable/subject/locationscreen.dart';
import 'package:tasknotetimetable/subject/subjectscreen.dart';

class EditTimeslotScreen extends StatefulWidget {
  final DocumentSnapshot timeslot;

  EditTimeslotScreen({required this.timeslot, super.key});

  final User? user = Auth().currentUser;

  @override
  State<EditTimeslotScreen> createState() => _EditTimeslotScreenState();
}

class _EditTimeslotScreenState extends State<EditTimeslotScreen> {
  // late TextEditingController _detailController;
  // late String subject;
  // late String location;
  // late String selectedDays;
  // late TimeOfDay _selectedStartTime;
  // late TimeOfDay _selectedEndTime;
  TextEditingController _detailController = TextEditingController();

  String subject = "";
  String location = "";
  //String detail = "Details";
  //List<String> selectedDays = [];
  String selectedDays = "";

  List<String> days = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday"
  ];

  late TimeOfDay _selectedStartTime = TimeOfDay.now();
  late TimeOfDay _selectedEndTime = TimeOfDay.now();

  @override
  void initState() {
    super.initState();
    // Initialize the controllers and variables with the existing timeslot data
    _detailController = TextEditingController(text: widget.timeslot['details']);
    subject = widget.timeslot['subject'];
    location = widget.timeslot['location'];
    selectedDays = widget.timeslot['day'];
    _selectedStartTime = _parseTimeOfDay(widget.timeslot['starttime']);
    _selectedEndTime = _parseTimeOfDay(widget.timeslot['endtime']);
  }

  TimeOfDay _parseTimeOfDay(String time) {
    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    return TimeOfDay(hour: hour, minute: minute);
  }

  String _formatTimeOfDay(TimeOfDay timeOfDay) {
    return "${timeOfDay.hour}:${timeOfDay.minute}";
  }

  Widget _dayButton(BuildContext context, String day) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedDays = day;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor:
            selectedDays == day ? Colors.black : Colors.white,
        shape: CircleBorder(
          side: BorderSide(
            color: Colors.black, // Outline border color
            width: 2.0, // Outline border width
          ),
        ),
      ),
      //child: Text(day),
      child: Center(
    child: Text(dayAbbreviations[day]!,
    style: TextStyle(
    color: selectedDays == day ? Colors.white : Colors.black,
    fontSize: 18,
    fontWeight: FontWeight.bold)))
    );
  }

  final Map<String, String> dayAbbreviations = {
    "Monday": "M",
    "Tuesday": "T",
    "Wednesday": "W",
    "Thursday": "T",
    "Friday": "F",
    "Saturday": "S",
    "Sunday": "S"
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (subject.isNotEmpty &&
              location.isNotEmpty &&
              selectedDays.isNotEmpty) {
            try {
              // Update the existing timeslot document
              await widget.timeslot.reference.update({
                'subject': subject,
                'details': _detailController.text,
                'day': selectedDays,
                'starttime': _formatTimeOfDay(_selectedStartTime),
                'endtime': _formatTimeOfDay(_selectedEndTime),
                'location': location,
              });
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Timeslot updated successfully.'),
              ));
              Navigator.of(context).pop();
            } catch (e) {
              print('Error updating timeslot: $e');
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Failed to update timeslot. Please try again.'),
              ));
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Fields cannot be empty.'),
            ));
          }
        },
        backgroundColor: Colors.black,
        elevation: 8,
        child: Icon(
          Icons.check,
          color: Colors.white,
          size: 24,
        ),
      ),
      appBar: AppBar(
        title: Text("Edit TimeSlot", style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 2)),
        backgroundColor: Color.fromARGB(255, 81, 151, 190),
        leading: IconButton(
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _subjectContainer(),
            _subjectDetailContainer(),
            _locationContainer(),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: days.map((day) => _dayButton(context, day)).toList(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _startTimeContainer(),
                  _endTimeContainer(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _subjectContainer() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SubjectScreen(
              onSubjectSelected: (selectedSubject) {
                setState(() {
                  subject = selectedSubject;
                });
              },
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: MediaQuery.of(context).size.width * 1,
          height: MediaQuery.of(context).size.height * 0.07,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 81, 151, 190),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 0, 0),
            // child: Row(
            //   children: [
            //     Text(
            //       subject.isNotEmpty ? subject : "Subject",
            //       style: TextStyle(
            //         fontSize: 24,
            //         fontWeight: FontWeight.w600,
            //         color: Color.fromARGB(255, 95, 91, 91),
            //       ),
            //     ),
            //   ],
            // ),
            child: Row(
              children: [
                SizedBox(
                  width: 350,
                  child: Text(
                    location.isNotEmpty ? subject : "Subject", //location,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.white, //Color.fromARGB(255, 95, 91, 91),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 40,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _subjectDetailContainer() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.95,
        child: TextFormField(
          maxLines: 5,
          minLines: 1,
          controller: _detailController,
          decoration: const InputDecoration(
            labelText: 'More about this class',
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }

  Widget _locationContainer() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LocationScreen(
              onLocationSelected: (selectedLocation) {
                setState(() {
                  location = selectedLocation;
                });
              },
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: MediaQuery.of(context).size.width * 1,
          height: MediaQuery.of(context).size.height * 0.07,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 0, 0),
            child: Row(
              children: [
                SizedBox(
                  width: 350,
                  child: Text(
                    location.isNotEmpty ? location : "Location", //location,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.white, //Color.fromARGB(255, 95, 91, 91),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 40,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _endTimeContainer() {
    TextEditingController endTimeController =
    TextEditingController(text: _selectedEndTime.format(context));
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(16),
        ),
        width: MediaQuery.of(context).size.width * 0.45,
        height: MediaQuery.of(context).size.height * 0.1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: const Text('End time',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.sizeOf(context).height * 0.01),
            GestureDetector(
              onTap: () async {
                final TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: _selectedEndTime,
                );
                if (pickedTime != null) {
                  setState(() {
                    _selectedEndTime = pickedTime;
                    endTimeController.text = _selectedEndTime.format(context);
                  });
                }
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.4,
                height: MediaQuery.of(context).size.height * 0.05,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16)),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: TextFormField(
                          controller: endTimeController,
                          enabled: false,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: Icon(Icons.add_alarm),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _startTimeContainer() {
    TextEditingController startTimeController =
    TextEditingController(text: _selectedStartTime.format(context));
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black),
        ),
        width: MediaQuery.of(context).size.width * 0.45,
        height: MediaQuery.of(context).size.height * 0.1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: const Text('Start time',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black)),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.sizeOf(context).height * 0.01),
            GestureDetector(
              onTap: () async {
                final TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: _selectedStartTime,
                );
                if (pickedTime != null) {
                  setState(() {
                    _selectedStartTime = pickedTime;
                    startTimeController.text = _selectedStartTime.format(context);
                  });
                }
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.4,
                height: MediaQuery.of(context).size.height * 0.05,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.black)),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: TextFormField(
                          decoration: InputDecoration.collapsed(hintText: ''),
                          controller: startTimeController,
                          enabled: false,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: Icon(Icons.add_alarm),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
