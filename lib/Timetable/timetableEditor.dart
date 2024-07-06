import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasknotetimetable/Timetable/addTimeslot.dart';
import 'package:tasknotetimetable/Timetable/editTimeslot/editTimeslot.dart';
import 'package:tasknotetimetable/auth.dart';
import 'package:tasknotetimetable/subject/subjectscreen.dart';
import 'package:intl/intl.dart';

class TimetableEditor extends StatefulWidget {
  TimetableEditor({super.key});

  final User? user = Auth().currentUser;

  @override
  State<TimetableEditor> createState() => _TimetableEditorState();
}

class _TimetableEditorState extends State<TimetableEditor> {
  final Set<DocumentSnapshot> _selectedTimeslot = {};

  bool get _selectionMode => _selectedTimeslot.isNotEmpty;

  String showDay = "";
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
    setShowDay();
  }

  void setShowDay() {
    DateTime now = DateTime.now();
    int weekday = now.weekday;
    setState(() {
      showDay = days[
          weekday - 1]; // DateTime.weekday gives 1 for Monday and 7 for Sunday
    });
  }

  void _toggleTimeslotSelection(DocumentSnapshot timeslot) {
    setState(() {
      // Check if the bookmark ID is already in the selected bookmarks set
      if (_selectedTimeslot.any((snapshot) => snapshot.id == timeslot.id)) {
        // If yes, remove it
        _selectedTimeslot.removeWhere((snapshot) => snapshot.id == timeslot.id);
      } else {
        // If not, add it
        _selectedTimeslot.add(timeslot);
      }
    });
  }

  void _deleteSelectedTimeslots() {
    for (var timeslot in _selectedTimeslot) {
      timeslot.reference.delete();
    }
    setState(() {
      _selectedTimeslot.clear();
    });
  }

  void _clearSelection() {
    setState(() {
      _selectedTimeslot.clear();
    });
  }

  AppBar _buildDefaultAppBar() {
    return AppBar(
      title: Text("Timeslot",
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 2)),
      backgroundColor: Color.fromARGB(255, 81, 151, 190),
      // leading: IconButton(
      //   color: Colors.white,
      //   onPressed: () {
      //     Navigator.pop(context);
      //   },
      //   icon: Icon(Icons.arrow_back_ios_new),
      // ),
      // actions: [
      //   onPressed: (){}
      // ],
    );
    //   AppBar(
    //   //backgroundColor: Colors.blue,
    //   title: Text(
    //     'Timeslot',
    //     style: GoogleFonts.nunito(
    //       textStyle: TextStyle(
    //         color: Colors.black,
    //         fontSize: 22,
    //         fontWeight: FontWeight.bold,
    //       ),
    //     ),
    //   ),
    // );
  } //start

  AppBar _buildSelectionAppBar() {
    return AppBar(
      //backgroundColor: Colors.blue,
      leading: IconButton(
        icon: Icon(Icons.clear, color: Colors.white),
        onPressed: _clearSelection,
      ),
      title: Text('${_selectedTimeslot.length} selected', style: TextStyle(color: Colors.white),),
      backgroundColor: Color.fromARGB(255, 81, 151, 190),
      actions: [
        IconButton(
          icon: Icon(Icons.delete, color: Colors.white,),
          onPressed: _deleteSelectedTimeslots,
        ),
        IconButton(
          icon: Icon(Icons.select_all, color: Colors.white),
          onPressed: () {
            _selectAllTimeslots();
          },
        ),
        // IconButton(
        //   icon: Icon(Icons.select_off),
        //   onPressed: () {
        //     _clearSelection();
        //   },
        // ),
      ],
    );
  }

  void _selectAllTimeslots() async {
    final timeslots = await FirebaseFirestore.instance
        .collection('usersTimeslot')
        .doc(widget.user!.uid)
        .collection('timeslots')
        .where('day', isEqualTo: showDay)
        .get();
    setState(() {
      _selectedTimeslot.clear();
      _selectedTimeslot.addAll(timeslots.docs);
    });
  }

  void _timeslotDetails() async{

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('FloatingActionButton pressed ...');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddTimeslotScreen(selectedDay: showDay,),
              //builder: (context) => TimetableEditor1(),
            ),
          );
        },
        backgroundColor: Colors.black,
        elevation: 8,
        child: Icon(
          Icons.add,
          color: Colors.white, // Change to your desired color
          size: 24,
        ),
      ),
      appBar: _selectionMode ? _buildSelectionAppBar() : _buildDefaultAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            // Padding(
            //   padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
            //   child: Container(
            //     width: MediaQuery.of(context).size.width * 1,
            //     height: MediaQuery.of(context).size.height * 0.05,
            //     child: const Row(
            //       mainAxisSize: MainAxisSize.max,
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: [
            //         // Padding(
            //         //   padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
            //         //   child: Text(
            //         //     'Timeslots',
            //         //     style: TextStyle(
            //         //       fontFamily: 'Readex Pro',
            //         //       fontSize: 24,
            //         //       fontWeight: FontWeight.bold,
            //         //     ),
            //         //   ),
            //         // ),
            //         // Padding(
            //         //   padding: EdgeInsets.fromLTRB(0, 0, 16, 0),
            //         //   child: TextButton(
            //         //     onPressed: () {
            //         //       print('Button pressed ...');
            //         //     },
            //         //     child: Text(
            //         //       'Edit Timeslots',
            //         //       style: TextStyle(
            //         //         fontFamily: 'Readex Pro',
            //         //         color: Colors.black,
            //         //         fontSize: 16,
            //         //       ),
            //         //     ),
            //         //     style: ButtonStyle(
            //         //       backgroundColor: MaterialStateProperty.all<Color>(
            //         //         Color(0xFFF8F5F5),
            //         //       ),
            //         //       padding: MaterialStateProperty.all<EdgeInsets>(
            //         //         EdgeInsets.fromLTRB(24, 0, 24, 0),
            //         //       ),
            //         //       elevation: MaterialStateProperty.all<double>(3),
            //         //       side: MaterialStateProperty.all<BorderSide>(
            //         //         BorderSide(
            //         //           color: Colors.black,
            //         //           width: 1,
            //         //         ),
            //         //       ),
            //         //       shape: MaterialStateProperty.all<OutlinedBorder>(
            //         //         RoundedRectangleBorder(
            //         //           borderRadius: BorderRadius.circular(8),
            //         //         ),
            //         //       ),
            //         //     ),
            //         //   ),
            //         // ),
            //       ],
            //     ),
            //   ),
            // ),
            Divider(
              thickness: 2,
              indent: 16,
              endIndent: 16,
              color: Color(0xEF4A4A4A),
            ),
            // Days row
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
              child: Container(
                //decoration: BoxDecoration(color: Colors.blue),
                width: MediaQuery.sizeOf(context).width*1,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: days.map((day) => _dayButton(context, day)).toList(),
                  ),
                ),
              ),
            ),
            Divider(
              thickness: 2,
              indent: 16,
              endIndent: 16,
              color: Color(0xEF4A4A4A),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(16.0),
            //   child: Text(
            //     showDay.isNotEmpty
            //         ? "Selected Day: $showDay"
            //         : "No Day Selected",
            //     style: TextStyle(fontSize: 20),
            //   ),
            // ),

            //_timeslotCard(),

            // Expanded(
            //   child: StreamBuilder(
            //     stream: FirebaseFirestore.instance
            //         .collection('usersTimeslot')
            //         .doc(widget.user!.uid)
            //         .collection('timeslots')
            //         .where('day', isEqualTo: showDay)
            //         .snapshots(),
            //     builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            //       if (snapshot.connectionState == ConnectionState.waiting) {
            //         return Center(child: CircularProgressIndicator());
            //       } else {
            //         if (snapshot.hasError) {
            //           return Center(child: Text('Error: ${snapshot.error}'));
            //         } else {
            //           return ListView.builder(
            //             itemCount: snapshot.data!.docs.length,
            //             itemBuilder: (context, index) {
            //               Map<String, dynamic>? data =
            //                   snapshot.data!.docs[index].data()
            //                       as Map<String, dynamic>?;
            //               String subject = data?['subject'] ?? '';
            //               String details = data?['details'] ?? '';
            //               String startTime = data?['starttime'] ?? '';
            //               String endTime = data?['endtime'] ?? '';
            //               String location = data?['location'] ?? '';
            //               return _timeslotCard(
            //                   subject, details, startTime, endTime, location);
            //             },
            //           );

            //         }
            //       }
            //     },
            //   ),
            // ),

            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('usersTimeslot')
                    .doc(widget.user!.uid)
                    .collection('timeslots')
                    .where('day', isEqualTo: showDay)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      if (snapshot.hasData) {
                        List<QueryDocumentSnapshot> docs = snapshot.data!.docs;
                        if (docs.isEmpty) {
                          return Center(
                              child: Text('No slots for this day yet.'));
                        }
                        docs.sort((a, b) {
                          String startTimeA =
                              (a.data() as Map<String, dynamic>)['starttime'] ??
                                  '';
                          String startTimeB =
                              (b.data() as Map<String, dynamic>)['starttime'] ??
                                  '';
                          return startTimeA.compareTo(startTimeB);
                        });

                        return ListView(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 100),
                          scrollDirection: Axis.vertical,
                          children: docs.map((DocumentSnapshot document) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Slidable(
                                key: Key(document.id),
                                endActionPane: ActionPane(
                                  motion: ScrollMotion(),
                                  children: [
                                    SlidableAction(
                                      onPressed: (context) {
                                        // Define your action here for edit
                                        //print('Edit ${document.id}');
                                        //navigate to edit screen
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                EditTimeslotScreen(
                                                    timeslot: document),
                                          ),
                                        );
                                      },
                                      backgroundColor: Colors.blue,
                                      foregroundColor: Colors.white,
                                      icon: Icons.edit,
                                      label: 'Edit',
                                    ),
                                  ],
                                ),
                                // endActionPane: ActionPane(
                                //   motion: ScrollMotion(),
                                //   children: [
                                //     SlidableAction(
                                //       onPressed: (context) {
                                //         // Define your action here for delete
                                //         document.reference.delete();
                                //         print('Delete ${document.id}');
                                //       },
                                //       backgroundColor: Colors.red,
                                //       foregroundColor: Colors.white,
                                //       icon: Icons.delete,
                                //       label: 'Delete',
                                //     ),
                                //   ],
                                // ),
                                child: _timeslotCard(document),
                              ),
                            );
                          }).toList(),
                        );
                      } else {
                        return Center(
                            child: Text(
                                'No timeslots found for the selected day.'));
                      }
                    }
                  }
                },
              ),
            )

            // Container(
            //   height: MediaQuery.of(context).size.height*0.2,
            //   child: StreamBuilder(
            //     stream: FirebaseFirestore.instance
            //         .collection('usersTimeslot')
            //         .doc(widget.user!.uid)
            //         .collection('timeslots')
            //         .where('day', isEqualTo: showDay)
            //         .snapshots(),
            //     builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            //       if (snapshot.connectionState == ConnectionState.waiting) {
            //         return Center(child: CircularProgressIndicator());
            //       } else {
            //         if (snapshot.hasError) {
            //           return Center(child: Text('Error: ${snapshot.error}'));
            //         } else {
            //           if (snapshot.hasData) {
            //             List<QueryDocumentSnapshot> docs = snapshot.data!.docs;
            //             if (docs.isEmpty) {
            //               return Center(
            //                   child: Text('No slots at this moment.'));
            //             }
            //             docs.sort((a, b) {
            //               String startTimeA =
            //                   (a.data() as Map<String, dynamic>)['starttime'] ??
            //                       '';
            //               String startTimeB =
            //                   (b.data() as Map<String, dynamic>)['starttime'] ??
            //                       '';
            //               return startTimeA.compareTo(startTimeB);
            //             });

            //             return CarouselSlider.builder(
            //               itemCount: docs.length,
            //               itemBuilder:
            //                   (BuildContext context, int index, int realIndex) {
            //                 Map<String, dynamic>? data =
            //                     docs[index].data() as Map<String, dynamic>?;
            //                 String subject = data?['subject'] ?? '';
            //                 String details = data?['details'] ?? '';
            //                 String startTime = data?['starttime'] ?? '';
            //                 String endTime = data?['endtime'] ?? '';
            //                 String location = data?['location'] ?? '';
            //                 return _timeslotCard(
            //                     subject, details, startTime, endTime, location);
            //               },
            //               options: CarouselOptions(
            //                 aspectRatio: 16 / 7,
            //                 viewportFraction: 1,
            //                 initialPage: 0,
            //                 enableInfiniteScroll: false,
            //                 reverse: false,
            //                 autoPlay: false,
            //                 autoPlayInterval: Duration(seconds: 3),
            //                 autoPlayAnimationDuration:
            //                     Duration(milliseconds: 800),
            //                 autoPlayCurve: Curves.fastOutSlowIn,
            //                 enlargeCenterPage: true,
            //                 scrollDirection: Axis.horizontal,
            //               ),
            //             );
            //           } else {
            //             return Center(
            //                 child: Text(
            //                     'No timeslots found for the selected day.'));
            //           }
            //         }
            //       }
            //     },
            //   ),
            // ),

            // Table or other content can be added here
            // SingleChildScrollView(
            //   // Add content here
            // )
          ],
        ),
      ),
    );
  }

  // Widget _timeslotCard(String subject, String details, String startTime,
  //     String endTime, String location) {
  //   return Padding(
  //     //padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
  //     padding: EdgeInsets.all(8.0),
  //     child: Container(
  //       width: MediaQuery.of(context).size.width * 1,
  //       height: MediaQuery.of(context).size.height * 0.13,
  //       decoration: BoxDecoration(
  //           color: Color.fromARGB(255, 217, 217, 217),
  //           boxShadow: [
  //             BoxShadow(
  //               color: Colors.grey.withOpacity(1),
  //               spreadRadius: 1,
  //               blurRadius: 4,
  //               offset: Offset(0, 2),
  //             )
  //           ]),
  //       child: Row(
  //         mainAxisSize: MainAxisSize.max,
  //         children: [
  //           // Time text container
  //           Container(
  //             width: 100,
  //             height: 100,
  //             child: Column(
  //               mainAxisSize: MainAxisSize.max,
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 Text(startTime,
  //                     style: TextStyle(fontWeight: FontWeight.bold)),
  //                 Text(endTime, style: TextStyle(fontWeight: FontWeight.bold)),
  //               ],
  //             ),
  //           ),
  //           SizedBox(
  //             height: 80,
  //             child: VerticalDivider(
  //               thickness: 1,
  //               color: Color.fromARGB(89, 0, 0, 0),
  //             ),
  //           ),

  //           // Subject text container
  //           Container(
  //             width: MediaQuery.of(context).size.width * 0.5,
  //             height: 100,
  //             child: Column(
  //               mainAxisSize: MainAxisSize.max,
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 SizedBox(
  //                   width: 300,
  //                   child: Text(
  //                     subject,
  //                     style:
  //                         TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
  //                     overflow: TextOverflow.ellipsis,
  //                   ),
  //                 ),
  //                 SizedBox(
  //                     width: 300,
  //                     child: Text(
  //                       details,
  //                       style: TextStyle(fontWeight: FontWeight.bold),
  //                       overflow: TextOverflow.ellipsis,
  //                     )),
  //               ],
  //             ),
  //           ),

  //           Container(
  //             width: MediaQuery.of(context).size.width * 0.16,
  //             height: 100,
  //             decoration: BoxDecoration(),
  //             child: Column(
  //               mainAxisSize: MainAxisSize.max,
  //               mainAxisAlignment: MainAxisAlignment.end,
  //               children: [
  //                 SizedBox(
  //                   child: Text(
  //                     location,
  //                     style: TextStyle(fontWeight: FontWeight.bold),
  //                     overflow: TextOverflow.ellipsis,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }start

  void _showDetailsDialog(BuildContext context, Map<String, dynamic> data) {
    final DateFormat displayFormat = DateFormat('HH:mm');
    final DateFormat timeFormat = DateFormat.Hm();

    final DateTime startDateTime = timeFormat.parse(data['starttime']);
    final DateTime endDateTime = timeFormat.parse(data['endtime']);

    final String formattedStartTime = displayFormat.format(startDateTime);
    final String formattedEndTime = displayFormat.format(endDateTime);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(data['subject']),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Details: ${data['details']}'),
              Text('Start Time: $formattedStartTime'),
              Text('End Time: $formattedEndTime'),
              Text('Location: ${data['location']}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }


  Widget _timeslotCard(DocumentSnapshot? timeslotSnapshot) {
  if (timeslotSnapshot == null || timeslotSnapshot.data() == null) {
    return SizedBox();
  }

  Map<String, dynamic> data = timeslotSnapshot.data() as Map<String, dynamic>;
  String subject = data?['subject'] ?? '';
  String details = data?['details'] ?? '';
  String startTime = data?['starttime'] ?? '';
  String endTime = data?['endtime'] ?? '';
  String location = data?['location'] ?? '';

  final DateFormat timeFormat = DateFormat.Hm();
  final DateTime startDateTime = timeFormat.parse(startTime);
  final DateTime endDateTime = timeFormat.parse(endTime);
  final String formattedStartTime = DateFormat('HH:mm').format(startDateTime);
  final String formattedEndTime = DateFormat('HH:mm').format(endDateTime);

  final DateTime currentTime = DateTime.now();
  final int currentMinutesSinceMidnight =
      currentTime.hour * 60 + currentTime.minute;
  final int startMinutesSinceMidnight =
      startDateTime.hour * 60 + startDateTime.minute;
  final int endMinutesSinceMidnight =
      endDateTime.hour * 60 + endDateTime.minute;

  bool isCurrentTimeInRange =
      currentMinutesSinceMidnight >= startMinutesSinceMidnight &&
      currentMinutesSinceMidnight < endMinutesSinceMidnight;

  bool isSelected =
      _selectedTimeslot.any((snapshot) => snapshot.id == timeslotSnapshot.id);

  Color containerColor = isCurrentTimeInRange
      ? Colors.green
      : Color.fromARGB(255, 217, 217, 217);

  return Padding(
    padding: EdgeInsets.all(8.0),
    child: GestureDetector(
      onLongPress: () {
        _toggleTimeslotSelection(timeslotSnapshot);
      },
      onTap: () {
        if (_selectionMode) {
          _toggleTimeslotSelection(timeslotSnapshot);
        } else {
          //_launchURL(url);
          _showDetailsDialog(context, data);
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 1,
        height: MediaQuery.of(context).size.height * 0.13,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          color: isSelected
              ? const Color.fromARGB(140, 33, 149, 243)
              : containerColor,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: Offset(0, 2),
            )
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            // Time text container
            Container(
              width: 100,
              height: 100,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(formattedStartTime,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(formattedEndTime,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            SizedBox(
              height: 80,
              child: VerticalDivider(
                thickness: 1,
                color: Color.fromARGB(89, 0, 0, 0),
              ),
            ),

            // Subject text container
            Container(
              width: MediaQuery.of(context).size.width * 0.5,
              height: 100,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 300,
                    child: Text(
                      subject,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(
                    width: 300,
                    child: Text(
                      details,
                      style: TextStyle(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

            Container(
              width: MediaQuery.of(context).size.width * 0.16,
              height: 100,
              decoration: BoxDecoration(),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    child: Text(
                      location,
                      style: TextStyle(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}


  // Widget _timeslotCard() {
  //   return Padding(
  //     padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
  //     child: Container(
  //       width: MediaQuery.of(context).size.width * 1,
  //       height: MediaQuery.of(context).size.height * 0.13,
  //       decoration: BoxDecoration(
  //           color: Color.fromARGB(255, 217, 217, 217),
  //           //borderRadius: BorderRadius.all(Radius.circular(8)),
  //           boxShadow: [
  //             BoxShadow(
  //               color: Colors.grey.withOpacity(1),
  //               spreadRadius: 1,
  //               blurRadius: 4,
  //               offset: Offset(0, 2),
  //             )
  //           ]),
  //       child: Row(
  //         mainAxisSize: MainAxisSize.max,
  //         children: [
  //           //***********************Time text container */
  //           Container(
  //             width: 100,
  //             height: 100,
  //             child: Column(
  //               mainAxisSize: MainAxisSize.max,
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 Text('Start time',
  //                     style: TextStyle(fontWeight: FontWeight.bold)),
  //                 Text('End time',
  //                     style: TextStyle(fontWeight: FontWeight.bold)),
  //               ],
  //             ),
  //           ),
  //           SizedBox(
  //             height: 80,
  //             child: VerticalDivider(
  //               thickness: 1,
  //               color: Color.fromARGB(89, 0, 0, 0),
  //             ),
  //           ),

  //           //**************Subject text container */
  //           Container(
  //             width: MediaQuery.sizeOf(context).width * 0.5,
  //             height: 100,
  //             child: Column(
  //               mainAxisSize: MainAxisSize.max,
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Text('Subject',
  //                     style:
  //                         TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
  //                 Text('Details', style: TextStyle(fontWeight: FontWeight.bold)),
  //               ],
  //             ),
  //           ),

  //           Container(
  //             width: MediaQuery.sizeOf(context).width * 0.16,
  //             height: 100,
  //             decoration: BoxDecoration(
  //                 //color: FlutterFlowTheme.of(context).secondaryBackground,
  //                 ),
  //             child: Column(
  //               mainAxisSize: MainAxisSize.max,
  //               mainAxisAlignment: MainAxisAlignment.end,
  //               children: [
  //                 Text(
  //                   'Location', style: TextStyle(fontWeight: FontWeight.bold),
  //                   //style:
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
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
      width: MediaQuery.sizeOf(context).width*0.136,
      height: MediaQuery.sizeOf(context).height*0.05,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: showDay == day ? Colors.black : Colors.white,
            shape: CircleBorder(
              side: BorderSide(
              color: Colors.black, // Outline border color
              width: 2.0, // Outline border width
            ),),
        //padding: EdgeInsets.all(0),
          ),
          onPressed: () {
            setState(() {
              showDay = day;
            });
          },
          child: Center(child: Text(dayAbbreviations[day]!, style: TextStyle(color: showDay == day ? Colors.white : Colors.black, fontSize: 18, fontWeight: FontWeight.bold)))//Text(day),
      ),
    );
  }

  // Widget _dayButton(BuildContext context, String day) {
  //   return ElevatedButton(
  //     onPressed: () {
  //       setState(() {
  //         showDay = day;
  //       });
  //     },
  //     child: Text(day),
  //   );
  // }

  void _addTimeCard() {}
}
