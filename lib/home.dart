// import 'package:flutter/material.dart';
// import 'package:tasknotetimetable/Timetable/timetablePage.dart';
// //import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
// //import 'package:sampleproject1/bookmark/bookmarkListScreen.dart';

// class HomePageWidget extends StatefulWidget {
//   const HomePageWidget({Key? key}) : super(key: key);

//   @override
//   _HomePageWidgetState createState() => _HomePageWidgetState();
// }

// class _HomePageWidgetState extends State<HomePageWidget> {
//   // int _currentIndex = 0;

//   @override
//   Widget build(BuildContext context) {
//     String currentDay = _getCurrentDay();

//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.blue,
//         automaticallyImplyLeading: false,
//         title: Text(
//           'Page Title',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 22,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         actions: [],
//         centerTitle: false,
//         elevation: 2,
//       ),
      
//       // bottomNavigationBar: SalomonBottomBar(
//       //   currentIndex: _currentIndex,
//       //   onTap: (index) {
//       //     setState(() {
//       //       _currentIndex = index;
//       //     });
//       //     // switch (index) {
//       //     //   case 0:
//       //     //     Navigator.of(context)
//       //     //         .push(MaterialPageRoute(builder: (_) => HomePageWidget()));
//       //     //     break;
//       //     //   case 1:
//       //     //     Navigator.of(context)
//       //     //         .push(MaterialPageRoute(builder: (_) => AddScheduleWidget()));
//       //     //     break;
//       //     //   case 2:
//       //     //     Navigator.of(context)
//       //     //         .push(MaterialPageRoute(builder: (_) => BookmarkListScreenWidget()));
//       //     //     break;
//       //     //   // case 3:
//       //     //   //   Navigator.of(context)
//       //     //   //       .push(MaterialPageRoute(builder: (_) => ProfilePage()));
//       //     //   //   break;
//       //     // }
//       //   },
//       //   items: [
//       //     SalomonBottomBarItem(
//       //       icon: Icon(Icons.home),
//       //       title: Text("Home"),
//       //       selectedColor: Colors.purple,
//       //     ),
//       //     SalomonBottomBarItem(
//       //       icon: Icon(Icons.favorite_border),
//       //       title: Text("Likes"),
//       //       selectedColor: Colors.pink,
//       //     ),
//       //     SalomonBottomBarItem(
//       //       icon: Icon(Icons.search),
//       //       title: Text("Search"),
//       //       selectedColor: Colors.orange,
//       //     ),
//       //     // SalomonBottomBarItem(
//       //     //   icon: Icon(Icons.person),
//       //     //   title: Text("Profile"),
//       //     //   selectedColor: Colors.teal,
//       //     // ),
//       //   ],
//       // ),
//       body: SafeArea(
//         top: true,
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Row(
//                 children: [
//                   Container(
//                     width: MediaQuery.of(context).size.width * 0.5,
//                     height: MediaQuery.of(context).size.height * 0.08,
//                     color: Colors.grey[200],
//                     child: Padding(
//                       padding: EdgeInsets.only(left: 8),
//                       child: Row(
//                         mainAxisSize: MainAxisSize.max,
//                         children: [
//                           Text(
//                             '$currentDay',
//                             style: TextStyle(
//                               color: Colors.black,
//                               fontSize: 24,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   Container(
//                     width: MediaQuery.of(context).size.width * 0.5,
//                     height: MediaQuery.of(context).size.height * 0.08,
//                     color: Colors.grey[200],
//                     child: Row(
//                       mainAxisSize: MainAxisSize.max,
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         Padding(
//                           padding:
//                               const EdgeInsetsDirectional.fromSTEB(0, 0, 24, 0),
//                           child: SizedBox(
//                             width: 100.0,
//                             child: ElevatedButton(
//                               onPressed: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (context) =>
//                                           const AddScheduleWidget()),
//                                 );
//                               },
//                               style: ButtonStyle(
//                                 backgroundColor: MaterialStateProperty.all(
//                                     Colors.transparent),
//                                 padding:
//                                     MaterialStateProperty.all(EdgeInsets.zero),
//                               ),
//                               child: Text(
//                                 'Timetable',
//                                 style: TextStyle(
//                                   color: Colors.black,
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               Row(
//                 mainAxisSize: MainAxisSize.max,
//                 children: [
//                   Container(
//                     width: MediaQuery.of(context).size.width * 0.18,
//                     height: MediaQuery.of(context).size.height * 1,
//                     color: Colors.grey[300],
//                     child: SingleChildScrollView(
//                       child: Column(
//                         mainAxisSize: MainAxisSize.max,
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           buildTimeContainer(context),
//                         ],
//                       ),
//                     ),
//                   ),
//                   Column(
//                     mainAxisSize: MainAxisSize.max,
//                     children: [
//                       Container(
//                         padding:
//                             const EdgeInsetsDirectional.fromSTEB(24, 0, 0, 0),
//                         width: MediaQuery.of(context).size.width * 0.82,
//                         height: MediaQuery.of(context).size.height * 1,
//                         color: Colors.grey[200],
//                         child: SingleChildScrollView(
//                           scrollDirection: Axis.horizontal,
//                           child: Column(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Container(
//                                 width: MediaQuery.of(context).size.width * 0.70,
//                                 height:
//                                     MediaQuery.of(context).size.height * 0.12,
//                                 color: Colors.blue[200],
//                                 child: const Row(
//                                   mainAxisSize: MainAxisSize.max,
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Padding(
//                                       padding: EdgeInsets.only(left: 16),
//                                       child: Text(
//                                         'Activity',
//                                         style: TextStyle(
//                                           color: Colors.black,
//                                           fontSize: 24,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                     ),
//                                     Padding(
//                                       padding: EdgeInsets.only(right: 16),
//                                       child: Text(
//                                         'Tempat',
//                                         style: TextStyle(
//                                           color: Colors.black,
//                                           fontSize: 24,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               const Padding(
//                                 padding: EdgeInsets.only(top: 24),
//                                 child: Row(
//                                   children: [
//                                     Text(
//                                       'Urgent Task',
//                                       style: TextStyle(
//                                         color: Colors.black,
//                                         fontSize: 24,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsetsDirectional.fromSTEB(
//                                     2, 8, 0, 0),
//                                 child: Container(
//                                   width:
//                                       MediaQuery.of(context).size.width * 0.70,
//                                   height:
//                                       MediaQuery.of(context).size.height * 0.22,
//                                   color: Colors.grey[400],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   String _getCurrentDay() {
//     DateTime now = DateTime.now();
//     switch (now.weekday) {
//       case DateTime.monday:
//         return 'Monday';
//       case DateTime.tuesday:
//         return 'Tuesday';
//       case DateTime.wednesday:
//         return 'Wednesday';
//       case DateTime.thursday:
//         return 'Thursday';
//       case DateTime.friday:
//         return 'Friday';
//       case DateTime.saturday:
//         return 'Saturday';
//       case DateTime.sunday:
//         return 'Sunday';
//       default:
//         return '';
//     }
//   }

//   Widget buildTimeContainer(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
//       child: Container(
//         width: MediaQuery.of(context).size.width * 0.16,
//         height: MediaQuery.of(context).size.height * 0.08,
//         color: Colors.grey[200],
//         child: Center(
//           child: Text(
//             'TIME',
//             style: TextStyle(
//               color: Colors.black,
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
