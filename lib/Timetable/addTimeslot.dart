// import 'package:flutter/material.dart';
// import 'package:tasknotetimetable/subject/locationscreen.dart';
// import 'package:tasknotetimetable/subject/subjectscreen.dart';

// class AddTimeslotScreen extends StatefulWidget {
//   const AddTimeslotScreen({super.key});

//   @override
//   State<AddTimeslotScreen> createState() => _AddTimeslotScreenState();
// }

// class _AddTimeslotScreenState extends State<AddTimeslotScreen> {
//   TextEditingController _topicController = TextEditingController();

//   String subject = "Subject";
//   String location = "Location";
//   String topic = "";
//   //String day = "";
//   List<String> days = [
//     "Monday",
//     "Tuesday",
//     "Wednesday",
//     "Thursday",
//     "Friday",
//     "Saturday",
//     "Sunday"
//   ];

//   Widget _dayButton(BuildContext context, String day) {
//     return ElevatedButton(
//       onPressed: () {
//         // setState(() {
//         //   showDay = day;
//         // });
//       },
//       child: Text(day),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {},
//         backgroundColor: Colors.black,
//         elevation: 8,
//         child: Icon(
//           Icons.check,
//           color: Colors.white, // Change to your desired color
//           size: 24,
//         ),
//       ),
//       appBar: AppBar(
//         title: Text("Create TimeSlot"),
//       ),
//       body: SafeArea(
//           child: Column(
//         children: [
//           _subjectContainer(),
//           _topicContainer(),
//           _locationContainer(),
//           //_teacherContainer(),
//           SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Row(
//                 children: days.map((day) => _dayButton(context, day)).toList(),
//               ),
//             ),
//           ),
//           //_dayContainer(),
//           _startTimeContainer(),
//           _endTimeContainer(),
//           //_reminderContainer()
//         ],
//       )),
//     );
//   }

//   Widget _subjectContainer() {
//   return GestureDetector(
//     onTap: () {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => SubjectScreen(
//             onSubjectSelected: (selectedSubject) {
//               setState(() {
//                 subject = selectedSubject;
//               });
//             },
//           ),
//         ),
//       );
//     },
//     child: Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Container(
//         width: MediaQuery.of(context).size.width * 1,
//         height: MediaQuery.of(context).size.height * 0.07,
//         decoration: BoxDecoration(
//           color: Color.fromARGB(255, 230, 179, 179),
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.fromLTRB(24, 0, 0, 0),
//           child: Row(
//             children: [
//               Text(
//                 subject,
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.w600,
//                   color: Color.fromARGB(255, 95, 91, 91),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     ),
//   );
// }

//   // Widget _subjectContainer() {
//   //   return GestureDetector(
//   //       onTap: () {
//   //         Navigator.push(
//   //           context,
//   //           MaterialPageRoute(
//   //             builder: (context) => SubjectScreen(onSubjectSelected: (String ) {  },),
//   //             //builder: (context) => TimetableEditor1(),
//   //           ),
//   //         );
//   //       },
//   //       child: Padding(
//   //         padding: const EdgeInsets.all(8.0),
//   //         child: Container(
//   //           width: MediaQuery.of(context).size.width * 1,
//   //           height: MediaQuery.of(context).size.height * 0.07,
//   //           decoration: BoxDecoration(
//   //             color: Color.fromARGB(255, 230, 179, 179),
//   //             borderRadius: BorderRadius.circular(8),
//   //           ),
//   //           child: const Padding(
//   //             padding: EdgeInsets.fromLTRB(24, 0, 0, 0),
//   //             child: Row(
//   //               children: [
//   //                 Text(
//   //                   "Subject",
//   //                   style: TextStyle(
//   //                       fontSize: 24,
//   //                       fontWeight: FontWeight.w600,
//   //                       color: Color.fromARGB(255, 95, 91, 91)),
//   //                 ),
//   //               ],
//   //             ),
//   //           ),
//   //         ),
//   //       ));
//   // }

//   Widget _topicContainer() {
//     return GestureDetector(

//         child: Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: SizedBox(
//         width: MediaQuery.of(context).size.width * 0.95,
//         child: TextFormField(
//           maxLines: 5,
//           minLines: 1,
//           controller: _topicController,
//           decoration: const InputDecoration(
//             labelText: 'More about this class',
//             border: OutlineInputBorder(),
//           ),
//         ),
//       ),
//     ));
//   }

//   Widget _locationContainer() {
//     return GestureDetector(
//       onTap: () {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => LocationScreen(
//             onLocationSelected: (selectedLocation) {
//               setState(() {
//                 location = selectedLocation;
//               });
//             },
//           ),
//         ),
//       );
//     },
//         child: Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Container(
//         width: MediaQuery.of(context).size.width * 1,
//         height: MediaQuery.of(context).size.height * 0.07,
//         decoration: BoxDecoration(
//           color: Color.fromARGB(255, 230, 179, 179),
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: const Padding(
//           padding: EdgeInsets.fromLTRB(24, 0, 0, 0),
//           child: Row(
//             children: [
//               Text(
//                 "Location",
//                 style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.w600,
//                     color: Color.fromARGB(255, 95, 91, 91)),
//               ),
//             ],
//           ),
//         ),
//       ),
//     ));
//   }

//   Widget _teacherContainer() {
//     return GestureDetector(child: Container());
//   }

//   Widget _dayContainer() {
//     return GestureDetector(child: Container());
//   }

//   Widget _reminderContainer() {
//     return GestureDetector(child: Container());
//   }

//   late TimeOfDay _selectedEndTime = TimeOfDay.now();

//   Widget _endTimeContainer() {
//     TextEditingController endTimeController =
//         TextEditingController(text: _selectedEndTime.format(context));
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
//       child: SizedBox(
//         width: MediaQuery.of(context).size.width * 0.9,
//         height: MediaQuery.of(context).size.height * 0.08,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text('End time:'),
//             Row(
//               children: [
//                 Expanded(
//                   child: TextFormField(
//                     controller: endTimeController,
//                     enabled: false,
//                   ),
//                 ),
//                 ElevatedButton(
//                   onPressed: () async {
//                     final TimeOfDay? pickedTime = await showTimePicker(
//                       context: context,
//                       initialTime: _selectedEndTime,
//                     );
//                     if (pickedTime != null) {
//                       setState(() {
//                         _selectedEndTime = pickedTime;
//                         endTimeController.text =
//                             _selectedEndTime.format(context);
//                       });
//                     }
//                   },
//                   child: const Text('Select End Time'),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   late TimeOfDay _selectedStartTime = TimeOfDay.now();

//   Widget _startTimeContainer() {
//     TextEditingController startTimeController =
//         TextEditingController(text: _selectedStartTime.format(context));
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
//       child: SizedBox(
//         width: MediaQuery.of(context).size.width * 0.9,
//         height: MediaQuery.of(context).size.height * 0.08,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text('Start time:'),
//             Row(
//               children: [
//                 Expanded(
//                   child: TextFormField(
//                     controller: startTimeController,
//                     enabled: false,
//                   ),
//                 ),
//                 ElevatedButton(
//                   onPressed: () async {
//                     final TimeOfDay? pickedTime = await showTimePicker(
//                       context: context,
//                       initialTime: _selectedStartTime,
//                     );
//                     if (pickedTime != null) {
//                       setState(() {
//                         _selectedStartTime = pickedTime;
//                         startTimeController.text =
//                             _selectedStartTime.format(context);
//                       });
//                     }
//                   },
//                   child: const Text('Select Start Time'),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tasknotetimetable/auth.dart';
import 'package:tasknotetimetable/subject/locationscreen.dart';
import 'package:tasknotetimetable/subject/subjectscreen.dart';

class AddTimeslotScreen extends StatefulWidget {
  final String selectedDay;

  AddTimeslotScreen({super.key, required this.selectedDay});

  final User? user = Auth().currentUser;

  @override
  State<AddTimeslotScreen> createState() => _AddTimeslotScreenState();
}

class _AddTimeslotScreenState extends State<AddTimeslotScreen> {
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

  @override
  void initState() {
    super.initState();
    selectedDays = widget
        .selectedDay; // Initialize selectedDays with the value from the widget
  }

  late TimeOfDay _selectedStartTime = TimeOfDay.now();
  late TimeOfDay _selectedEndTime = TimeOfDay.now();

  String _formatTimeOfDay(TimeOfDay timeOfDay) {
    return "${timeOfDay.hour}:${timeOfDay.minute}";
  }

  // Widget _dayButton(BuildContext context, String day) {
  //   return ElevatedButton(
  //     onPressed: () {
  //       setState(() {
  //         // selectedDays.clear(); // Clear the selected days list
  //         // selectedDays.add(day); // Add the currently selected day
  //         selectedDays = day;
  //       });
  //     },
  //     style: ButtonStyle(
  //       backgroundColor: MaterialStateProperty.all(
  //           selectedDays.contains(day) ? Colors.blue : Colors.grey),
  //     ),
  //     child: Text(day),
  //   );
  // }

  final Map<String, String> dayAbbreviations = {
    "Monday": "M",
    "Tuesday": "T",
    "Wednesday": "W",
    "Thursday": "T",
    "Friday": "F",
    "Saturday": "S",
    "Sunday": "S"
  };

  Widget _dayButton(BuildContext context, String day) {
    return Container(
      // decoration: BoxDecoration(
      //  color: Colors.blue
      // ),
      width: MediaQuery.sizeOf(context).width * 0.136,
      height: MediaQuery.sizeOf(context).height * 0.05,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: selectedDays == day ? Colors.black : Colors.white,
            shape: CircleBorder(
              side: BorderSide(
                color: Colors.black, // Outline border color
                width: 2.0, // Outline border width
              ),
            ),
            //padding: EdgeInsets.all(0),
          ),
          onPressed: () {
            setState(() {
              selectedDays = day;
            });
          },
          child: Center(
              child: Text(dayAbbreviations[day]!,
                  style: TextStyle(
                      color: selectedDays == day ? Colors.white : Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold))) //Text(day),
          ),
    );
  }

  // Widget _dayButton(BuildContext context, String day) {
  //   bool isSelected = selectedDays.contains(day);

  //   return ElevatedButton(
  //     onPressed: () {
  //       setState(() {
  //         if (isSelected) {
  //           selectedDays.remove(day);
  //         } else {
  //           selectedDays.add(day);
  //         }
  //       });
  //     },
  //     style: ButtonStyle(
  //       backgroundColor: MaterialStateProperty.all(isSelected ? Colors.blue : Colors.grey),
  //     ),
  //     child: Text(day),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (subject.isNotEmpty &&
              location.isNotEmpty &&
              selectedDays.isNotEmpty) {
            try {
              // Save bookmark under the user's collection
              await FirebaseFirestore.instance
                  .collection('usersTimeslot')
                  .doc(widget.user!.uid)
                  .collection('timeslots')
                  .add({
                'subject': subject,
                'details': _detailController.text,
                'day': selectedDays,
                'starttime': _formatTimeOfDay(_selectedStartTime),
                'endtime': _formatTimeOfDay(_selectedEndTime),
                'location': location
              });
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Timeslot added successfully.'),
              ));
              Navigator.of(context).pop();
            } catch (e) {
              print('Error adding timeslot: $e');
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Failed to add timeslot. Please try again.'),
              ));
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Fields cannot be empty.'),
              action: SnackBarAction(label: 'Dismiss', onPressed: () {}),
            ));
          }
          //Navigator.of(context).pop();
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
        title: Text("Create Timeslot",
            style: TextStyle(
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
        // actions: [
        //   onPressed: (){}
        // ],
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
                  children:
                      days.map((day) => _dayButton(context, day)).toList(),
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
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  subject.isNotEmpty ? subject : "Subject", //subject,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
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
          decoration: InputDecoration(
            labelText: 'More about this',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
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
            borderRadius: BorderRadius.circular(16),
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

  Widget _teacherContainer() {
    return GestureDetector(child: Container());
  }

  Widget _reminderContainer() {
    return GestureDetector(child: Container());
  }

  //late TimeOfDay _selectedEndTime = TimeOfDay.now();

  Widget _endTimeContainer() {
    TextEditingController endTimeController =
        TextEditingController(text: _selectedEndTime.format(context));
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.black, borderRadius: BorderRadius.circular(16)),
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
                    color: Colors.white, borderRadius: BorderRadius.circular(16)),
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
                        child: Icon(Icons.add_alarm)
                    ),
                    // IconButton(
                    //   onPressed: () async {
                    //     final TimeOfDay? pickedTime = await showTimePicker(
                    //       context: context,
                    //       initialTime: _selectedEndTime,
                    //     );
                    //     if (pickedTime != null) {
                    //       setState(() {
                    //         _selectedEndTime = pickedTime;
                    //         endTimeController.text =
                    //             _selectedEndTime.format(context);
                    //       });
                    //     }
                    //   },
                    //   icon: Icon(Icons.add_alarm),
                    //   //child: const Text('Select End Time'),
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //late TimeOfDay _selectedStartTime = TimeOfDay.now();

  Widget _startTimeContainer() {
    TextEditingController startTimeController =
        TextEditingController(text: _selectedStartTime.format(context));
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.black)),
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
                    startTimeController.text =
                        _selectedStartTime.format(context);
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
                          decoration:
                              new InputDecoration.collapsed(hintText: ''),
                          controller: startTimeController,
                          enabled: false,
                        ),
                      ),
                    ),

                    Padding(
                        padding: EdgeInsets.only(right: 8),
                        child: Icon(Icons.add_alarm)
                    ),

                    // IconButton(
                    //   onPressed: () async {
                    //     // final TimeOfDay? pickedTime = await showTimePicker(
                    //     //   context: context,
                    //     //   initialTime: _selectedStartTime,
                    //     // );
                    //     // if (pickedTime != null) {
                    //     //   setState(() {
                    //     //     _selectedStartTime = pickedTime;
                    //     //     startTimeController.text =
                    //     //         _selectedStartTime.format(context);
                    //     //   });
                    //     // }
                    //   },
                    //   icon: Icon(Icons.add_alarm),
                    // ),
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
