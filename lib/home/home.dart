import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:favicon/favicon.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tasknotetimetable/Timetable/timetablePage.dart';
import 'package:tasknotetimetable/auth.dart';

//import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
//import 'package:sampleproject1/bookmark/bookmarkListScreen.dart';
import 'package:tasknotetimetable/dummydata/dummyData.dart';
import 'package:tasknotetimetable/tasks/tasksScreen.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class HomePageWidget extends StatefulWidget {
  HomePageWidget({Key? key}) : super(key: key);

  final User? user = Auth().currentUser;

  //final currentUserUid = FirebaseAuth.instance.currentUser?.uid;

  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  int _current = 0;
  final CarouselController _carouselController = CarouselController();

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good morning';
    } else if (hour < 17) {
      return 'Good afternoon';
    } else if (hour < 20) {
      return 'Good evening';
    } else {
      return 'Good night';
    }
  }

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

  final Map<String, String> dayAbbreviations = {
    "Monday": "M",
    "Tuesday": "T",
    "Wednesday": "W",
    "Thursday": "T",
    "Friday": "F",
    "Saturday": "S",
    "Sunday": "S"
  };

  // Widget _dayButton(BuildContext context, String day) {
  //   return ElevatedButton(
  //     onPressed: () {
  //       setState(() {
  //         showDay = day;
  //       });
  //     },
  //     child: Text(dayAbbreviations[day]!)//Text(day),
  //   );
  // }
  Widget _dayButton(BuildContext context, String day) {
    return Container(
      // decoration: BoxDecoration(
      //  color: Colors.blue
      // ),
      width: MediaQuery.sizeOf(context).width * 0.14,
      height: MediaQuery.sizeOf(context).height * 0.05,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: showDay == day ? Colors.black : Colors.white,
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
              showDay = day;
            });
          },
          child: Center(
              child: Text(dayAbbreviations[day]!,
                  style: TextStyle(
                      color: showDay == day ? Colors.white : Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold))) //Text(day),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //String currentDay = _getCurrentDay();

    return Scaffold(
      body: SafeArea(
        top: true,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
            child: Column(
              //mainAxisSize: MainAxisSize.max,
              //mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 0, 0),
                  child: Row(
                    children: [
                      Text(getGreeting(),
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                Divider(
                  thickness: 2, //start
                  indent: 0,
                  endIndent: 0,
                  color: Color(0xEF4A4A4A),
                ),

                //_timeslotContainer(),

                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Row(
                      children:
                          days.map((day) => _dayButton(context, day)).toList(),
                    ),
                  ),
                ),

                Container(
                  width: MediaQuery.of(context).size.width * 1,
                  height: MediaQuery.of(context).size.height * 0.2,
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
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else {
                          if (snapshot.hasData) {
                            List<QueryDocumentSnapshot> docs =
                                snapshot.data!.docs;
                            if (docs.isEmpty) {
                              return Center(child: Text('No timeslot created'));
                            }

                            docs.sort((a, b) {
                              String startTimeA = (a.data()
                                      as Map<String, dynamic>)['starttime'] ??
                                  '';
                              String startTimeB = (b.data()
                                      as Map<String, dynamic>)['starttime'] ??
                                  '';
                              return startTimeA.compareTo(startTimeB);
                            });

                            // Filter timeslots that are not in current time range
                            List<QueryDocumentSnapshot> filteredDocs =
                                docs.where((doc) {
                              Map<String, dynamic>? data =
                                  doc.data() as Map<String, dynamic>?;
                              String startTime = data?['starttime'] ?? '';
                              String endTime = data?['endtime'] ?? '';
                              final DateFormat timeFormat = DateFormat.Hm();
                              final DateTime startDateTime =
                                  timeFormat.parse(startTime);
                              final DateTime endDateTime =
                                  timeFormat.parse(endTime);
                              final TimeOfDay startTOD =
                                  TimeOfDay.fromDateTime(startDateTime);
                              final TimeOfDay endTOD =
                                  TimeOfDay.fromDateTime(endDateTime);
                              final TimeOfDay currentTimeTOD = TimeOfDay.now();

                              int toMinutes(TimeOfDay tod) =>
                                  tod.hour * 60 + tod.minute;
                              return toMinutes(currentTimeTOD) >=
                                      toMinutes(startTOD) &&
                                  toMinutes(currentTimeTOD) < toMinutes(endTOD);
                            }).toList();

                            if (filteredDocs.isEmpty) {
                              return Center(
                                  child: Text('No slots at this time'));
                            }

                            return CarouselSlider.builder(
                              itemCount: filteredDocs.length,
                              itemBuilder: (BuildContext context, int index,
                                  int realIndex) {
                                Map<String, dynamic>? data = filteredDocs[index]
                                    .data() as Map<String, dynamic>?;
                                String subject = data?['subject'] ?? '';
                                String details = data?['details'] ?? '';
                                String startTime = data?['starttime'] ?? '';
                                String endTime = data?['endtime'] ?? '';
                                String location = data?['location'] ?? '';
                                return _timeslotContainer(subject, details,
                                    startTime, endTime, location);
                              },
                              options: CarouselOptions(
                                aspectRatio: 16 / 7,
                                viewportFraction: 0.8,
                                initialPage: 0,
                                enableInfiniteScroll: false,
                                reverse: false,
                                autoPlay: false,
                                autoPlayInterval: Duration(seconds: 3),
                                autoPlayAnimationDuration:
                                    Duration(milliseconds: 800),
                                autoPlayCurve: Curves.fastOutSlowIn,
                                enlargeCenterPage: true,
                                scrollDirection: Axis.horizontal,
                              ),
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
                ),

                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: deadlineContainer(context),
                ),

                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 1,
                    height: MediaQuery.of(context).size.height * 0.42,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16), //78,189,136
                        color: Color.fromARGB(255, 78, 189, 136),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3),
                          ),
                        ]),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text('Bookmarks',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Container(
                            width: MediaQuery.sizeOf(context).width * 0.99,
                            height: MediaQuery.sizeOf(context).height * 0.3,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.0),
                              color: Colors.white,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
                              child: StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('usersBookmarks')
                                    .doc(widget.user!.uid)
                                    .collection('bookmarks')
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return Center(
                                        child: CircularProgressIndicator());
                                  }

                                  var urlData = snapshot.data!.docs
                                      .map((doc) => [
                                            doc['url'] as String,
                                            doc['name'] as String
                                          ])
                                      .toList();

                                  return GridView.builder(
                                    padding: EdgeInsets.fromLTRB(8, 8, 8, 10),
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                      childAspectRatio: 1,
                                    ),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: urlData.length,
                                    itemBuilder: (context, index) {
                                      return _bookmarkLinkContainer(
                                          context, urlData[index]);
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _timeslotContainer(String subject, String details, String startTime,
      String endTime, String location) {
    final DateFormat timeFormat = DateFormat.Hm();
    final DateTime startDateTime = timeFormat.parse(startTime);
    final DateTime endDateTime = timeFormat.parse(endTime);
    final TimeOfDay startTOD = TimeOfDay.fromDateTime(startDateTime);
    final TimeOfDay endTOD = TimeOfDay.fromDateTime(endDateTime);
    final TimeOfDay currentTimeTOD = TimeOfDay.now();

    int toMinutes(TimeOfDay tod) => tod.hour * 60 + tod.minute;

    bool isCurrentTimeInRange =
        toMinutes(currentTimeTOD) >= toMinutes(startTOD) &&
            toMinutes(currentTimeTOD) < toMinutes(endTOD);

    if (!isCurrentTimeInRange) {
      return SizedBox.shrink(); // Hide the widget if not in current time range
    }

    final String formattedStartTime = timeFormat.format(startDateTime);
    final String formattedEndTime = timeFormat.format(endDateTime);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.2,
          decoration: BoxDecoration(
              color: Colors.blue, borderRadius: BorderRadius.circular(16)),
          child: Row(
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(8, 8, 0, 8),
                //const EdgeInsets.all(8.0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: MediaQuery.of(context).size.height * 0.2,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Container(
                        //   width: MediaQuery.of(context).size.width*1,
                        //   height: MediaQuery.of(context).size.height*0.1,
                        Text(subject + "hahahahahaahhhahaaha", //'Title',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                                fontSize: 28, fontWeight: FontWeight.bold)),
                        //),
                        Text(details + "hahahahhahahahahhahahahhaah", //'Desc',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text("Schedule",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                    Text(formattedStartTime, //startTime,//"00:00",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    Text(formattedEndTime, //endTime,//"00:00",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                  ],
                ),
              )
            ],
          )),
    ); //sini
  }

  Widget _bookmarkLinkContainer(BuildContext context, List<String> urlData) {
    return FutureBuilder<Favicon?>(
      future: FaviconFinder.getBest(urlData[0]),
      // Assume urlData[0] contains the URL
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.1,
              height: MediaQuery.of(context).size.width * 0.1,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          );
        }
        if (snapshot.hasError || !snapshot.hasData) {
          // Display the name field when there's an error
          return GestureDetector(
            onTap: () {
              launchUrlString(urlData[
                  0]); // Launch the URL in browser when container is tapped
            },
            child: Container(
              decoration: BoxDecoration(
                //start remove comment
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  width: 2,
                  color: Color.fromARGB(255, 78, 189, 136),
                ),
              ),
              child: Column(
                children: [
                  Icon(Icons.error_outline, size: 50, color: Colors.red),
                  // Placeholder for error icon
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(8, 8, 8, 0),
                    child: Text(
                      urlData[1], // Display the name field (title)
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        final favicon = snapshot.data!;
        return GestureDetector(
          onTap: () {
            launchUrlString(urlData[
                0]); // Launch the URL in browser when container is tapped
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                width: 2,
                color: Color.fromARGB(255, 78, 189, 136),
              ),
            ),
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.1,
                  height: MediaQuery.of(context).size.width * 0.1,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(favicon.url),
                    ),
                    shape: BoxShape.circle,
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(8, 8, 8, 0),
                  child: Text(
                    urlData[1],
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _urgentTaskContainer(
      BuildContext context, DocumentSnapshot taskSnapshot) {
    // Extract data from the document snapshot
    String taskName = taskSnapshot['name'] ?? '';
    String taskDescription = taskSnapshot['description'] ?? '';
    Timestamp timestamp = taskSnapshot['timestamp'];

    // Calculate time difference
    DateTime taskTime = timestamp.toDate();
    DateTime now = DateTime.now();
    int daysDifference = taskTime.difference(now).inDays;

    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(16)),
        border: Border.all(width: 2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  taskName,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 24),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.02,
                ),
                Text(
                  taskDescription,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      //color: Color.fromARGB(93, 0, 0, 0)
                    ),
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.3,
                height: MediaQuery.of(context).size.height * 0.05,
                decoration: BoxDecoration(
                  color: daysDifference <= 7 ? Color.fromARGB(255, 172, 75, 75) : Colors.transparent,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomRight: Radius.circular(14),
                  ),
                ),
                child: Center(
                  child: Text(
                    daysDifference <= 7 ? 'in ${daysDifference}d' : '',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget deadlineContainer(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 1,
      height: MediaQuery.of(context).size.height * 0.4,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Color.fromARGB(255, 224, 104, 104),
        border: Border.all(color: Colors.black, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Due soon',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.99,
            height: MediaQuery.of(context).size.height * 0.3,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('usersTasks')
                  .doc(widget.user!.uid)
                  .collection('tasks')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                List<DocumentSnapshot> taskSnapshots = snapshot.data!.docs;

                // Sort tasks by daysDifference in ascending order
                taskSnapshots.sort((a, b) {
                  Timestamp timestampA = a['timestamp'];
                  Timestamp timestampB = b['timestamp'];
                  DateTime taskTimeA = timestampA.toDate();
                  DateTime taskTimeB = timestampB.toDate();
                  DateTime now = DateTime.now();
                  int daysDifferenceA = taskTimeA.difference(now).inDays;
                  int daysDifferenceB = taskTimeB.difference(now).inDays;
                  return daysDifferenceA.compareTo(daysDifferenceB);
                });

                List<DocumentSnapshot> dueSoonTasks = [];

                // Filter tasks due within 7 days and get the first 4
                dueSoonTasks = taskSnapshots
                    .where((taskSnapshot) {
                  Timestamp timestamp = taskSnapshot['timestamp'];
                  DateTime taskTime = timestamp.toDate();
                  DateTime now = DateTime.now();
                  int daysDifference = taskTime.difference(now).inDays;
                  return daysDifference <= 7;
                })
                    .take(4) // Limit to first 4 due soon tasks
                    .toList();

                if (dueSoonTasks.isEmpty) {
                  return Center(child: Text('No tasks due soon'));
                }

                return GridView.builder(
                  padding: EdgeInsets.fromLTRB(8, 8, 8, 10),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1,
                  ),
                  scrollDirection: Axis.horizontal,
                  itemCount: dueSoonTasks.length + 1, // +1 for "See All" button
                  itemBuilder: (context, index) {
                    if (index == dueSoonTasks.length) {
                      // This is the last item, return the "See All" button
                      return GestureDetector(
                        onTap: () {
                          // Handle "See All" button tap
                          print("See All tapped");
                          Navigator.push(context, MaterialPageRoute(builder: (context) => TasksListWidget()));
                          // You can navigate to another screen or perform any other action here
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            'See All',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    } else {
                      return _urgentTaskContainer(context, dueSoonTasks[index]);
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }


// Widget _urgentTaskContainer(BuildContext context, List<String> taskData) {
  //   return Container(
  //     width: 100,
  //     height: 100,
  //     decoration: BoxDecoration(
  //         color: Colors.white,
  //         borderRadius: BorderRadius.all(Radius.circular(16)),
  //         border: Border.all(width: 2)),
  //     child: Column(
  //       mainAxisSize: MainAxisSize.max,
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Padding(
  //           padding: const EdgeInsets.all(8.0),
  //           child: Container(
  //             width: MediaQuery.sizeOf(context).width * 1,
  //             height: MediaQuery.sizeOf(context).height * 0.2,
  //             //decoration: BoxDecoration(color: Colors.blue),
  //             child: Column(
  //               mainAxisSize: MainAxisSize.max,
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Text(
  //                   taskData[0], //'Task Name',
  //                   style: const TextStyle(
  //                       fontWeight: FontWeight.bold, fontSize: 24),
  //                   maxLines: 2,
  //                   overflow: TextOverflow.ellipsis,
  //                 ),
  //                 SizedBox(
  //                   height: MediaQuery.sizeOf(context).height * 0.02,
  //                 ),
  //                 Text(
  //                     taskData[1] +
  //                         "hahahhhaahhahaahahhahaaaaaaaaaaaaaaaaaaaaaaaaaahahhahahahhahaaahahahhahhahhahahahhahahahaaahahahahahhahahahahhahahahahahahahhahahahahahahahahahaahhahahahaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
  //                     //'Description',
  //                     style: TextStyle(
  //                       fontWeight: FontWeight.bold,
  //                       fontSize: 16,
  //                       //color: Color.fromARGB(93, 0, 0, 0)
  //                     ),
  //                     maxLines: 5,
  //                     overflow: TextOverflow.ellipsis),
  //               ],
  //             ),
  //           ),
  //         ),
  //         Row(
  //           mainAxisSize: MainAxisSize.max,
  //           mainAxisAlignment: MainAxisAlignment.end,
  //           children: [
  //             Container(
  //               width: MediaQuery.sizeOf(context).width * 0.3,
  //               height: MediaQuery.sizeOf(context).height * 0.05,
  //               decoration: BoxDecoration(
  //                   color: Color.fromARGB(255, 172, 75, 75),
  //                   borderRadius: BorderRadius.only(
  //                       topLeft: Radius.circular(16),
  //                       bottomRight: Radius.circular(14))),
  //               child: Center(
  //                 child: Text("in " + taskData[2], //'Time Left',
  //                     textAlign: TextAlign.center,
  //                     style: TextStyle(
  //                         fontWeight: FontWeight.bold,
  //                         color: Colors.white,
  //                         fontSize: 15)),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }
  //
  // ///////////////////////////////////////////////////////////////////////////////////////////////////////////////
  // Widget deadlineContainer(BuildContext context) {
  //   return Container(
  //     width: MediaQuery.of(context).size.width * 1,
  //     height: MediaQuery.of(context).size.height * 0.4,
  //     decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(16),
  //         color: Color.fromARGB(255, 224, 104, 104),
  //         border: Border.all(color: Colors.black, width: 2),
  //         boxShadow: [
  //           BoxShadow(
  //             color: Colors.grey.withOpacity(0.5),
  //             spreadRadius: 5,
  //             blurRadius: 7,
  //             offset: Offset(0, 3),
  //           ),
  //         ]),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Padding(
  //           padding: const EdgeInsets.all(16.0),
  //           child: Text('Due soon',
  //               style: TextStyle(
  //                   fontSize: 24,
  //                   fontWeight: FontWeight.bold,
  //                   color: Colors.white)),
  //         ),
  //         Container(
  //           width: MediaQuery.sizeOf(context).width * 0.99,
  //           height: MediaQuery.sizeOf(context).height * 0.3,
  //           decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
  //           child: GridView.builder(
  //             padding: EdgeInsets.fromLTRB(8, 8, 8, 10),
  //             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //               crossAxisCount: 1,
  //               crossAxisSpacing: 10,
  //               mainAxisSpacing: 10,
  //               childAspectRatio: 1,
  //             ),
  //             scrollDirection: Axis.horizontal,
  //             itemCount: 5,
  //             // Add 1 for the "See All" button
  //             itemBuilder: (context, index) {
  //               if (index == 4) {
  //                 // This is the last item, return the "See All" button
  //                 return GestureDetector(
  //                   onTap: () {
  //                     // Handle "See All" button tap
  //                     print("See All tapped");
  //                     // You can navigate to another screen or perform any other action here
  //                   },
  //                   child: Container(
  //                     alignment: Alignment.center,
  //                     decoration: BoxDecoration(
  //                       color: Colors.blueAccent, // Change this color as needed
  //                       borderRadius: BorderRadius.circular(16),
  //                     ),
  //                     child: Text(
  //                       'See All',
  //                       style: TextStyle(
  //                         color: Colors.white,
  //                         fontSize: 16,
  //                         fontWeight: FontWeight.bold,
  //                       ),
  //                     ),
  //                   ),
  //                 );
  //               } else {
  //                 // Return the regular item
  //                 return _urgentTaskContainer(context, taskData[index]);
  //               }
  //             },
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }
}
