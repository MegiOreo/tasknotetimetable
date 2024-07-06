import 'package:flutter/material.dart';
import 'package:tasknotetimetable/Timetable/timetableEditor.dart';
import 'package:tasknotetimetable/Timetable/timetablePage.dart';
import 'package:tasknotetimetable/bookmark/bookmarkListScreen.dart';
import 'package:tasknotetimetable/favicon_page.dart';
import 'package:tasknotetimetable/home/home.dart';
import 'package:tasknotetimetable/loginregisterpage.dart';
import 'package:tasknotetimetable/tasks/tasksScreen.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tasknotetimetable/widget_tree.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tasknotetimetable/auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey:"AIzaSyDEdGPSYPCmjetXCgRN7vnvikD4WZNHwd4",
        appId: "1:348411679939:android:7d053040b3dad13f477e76",
        messagingSenderId: "348411679939",
        projectId: "tasknotetimetable",
      )
    );
  } catch (e) {
    print('Firebase initialization error: $e');
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const WidgetTree(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  bool _showExitAlert = false;

  final screens = [
    HomePageWidget(),
    //AddScheduleWidget(),
    TimetableEditor(),
    TasksListWidget(),
    BookmarkListScreenWidget(),
  ];

  Future<void> signOut() async {
    await Auth().signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const WidgetTree()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_currentIndex != 0) {
          setState(() {
            _currentIndex = 0;
          });
          return false;
        } else {
          if (_showExitAlert) {
            return true;
          } else {
            setState(() {
              _showExitAlert = true;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Tap again to exit'),
                duration: Duration(seconds: 2),
              ),
            );
            Future.delayed(Duration(seconds: 2), () {
              setState(() {
                _showExitAlert = false;
              });
            });
            return false;
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Tasknote Timetable"),//(widget.title),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text(
                  'Navigation Drawer',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.home),
                title: Text('Home'),
                onTap: () {
                  setState(() {
                    _currentIndex = 0;
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.calendar_today),
                title: Text('Timeslots'),
                onTap: () {
                  setState(() {
                    _currentIndex = 1;
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.check),
                title: Text('Tasks'),
                onTap: () {
                  setState(() {
                    _currentIndex = 2;
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.bookmark),
                title: Text('Bookmarks'),
                onTap: () {
                  setState(() {
                    _currentIndex = 3;
                  });
                  Navigator.pop(context);
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('Logout'),
                onTap: signOut,
              ),
            ],
          ),
        ),
        body: screens[_currentIndex],
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 5,
                blurRadius: 10,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: SalomonBottomBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            items: [
              SalomonBottomBarItem(
                icon: Icon(Icons.home),
                title: Text("Home"),
                selectedColor: Color.fromARGB(255, 172, 110, 13)//Colors.purple,

              ),
              SalomonBottomBarItem(
                icon: Icon(Icons.calendar_month),
                title: Text("Timeslots"),
                selectedColor: Color.fromARGB(255, 13, 112, 165)//Color.fromARGB(255, 5, 53, 78)//Colors.pink,
              ),
              SalomonBottomBarItem(
                icon: Icon(Icons.fact_check_outlined),
                // Image.asset(
                //   'lib/assets/icons/checklist.png',
                //   width: 28,
                //   height: 26,
                // ),
                title: Text("Tasks"),
                selectedColor: Color.fromARGB(255, 198, 10, 10)//Color.fromARGB(255, 14, 169, 92),
              ),
              SalomonBottomBarItem(
                icon: Icon(Icons.bookmarks),
                // Image.asset(
                //   'lib/assets/icons/bookmark.png',
                //   width: 28,
                //   height: 26,
                // ),
                title: Text("Bookmarks"),
                selectedColor: Colors.orange,
              ),
            ],
          ),
        ),
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:tasknotetimetable/Timetable/timetablePage.dart';
// import 'package:tasknotetimetable/bookmark/bookmarkListScreen.dart';
// import 'package:tasknotetimetable/favicon_page.dart';
// import 'package:tasknotetimetable/home/home.dart';
// //import 'package:tasknotetimetable/home.dart';
// import 'package:tasknotetimetable/tasks/tasksScreen.dart';
// //import 'package:tasknotetimetable/tasks/tasksscreen.dart';
// import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:tasknotetimetable/widget_tree.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// //import 'package:tasknotetimetable/loginScreen.dart';

// // Future main() async {
// //   WidgetsFlutterBinding.ensureInitialized();
// //   //await Firebase.initializeApp();
// //   runApp(const MyApp());
// // }

// // void main(){
// //   runApp(const MyApp());
// // }

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   try {
//     await Firebase.initializeApp();
//   } catch (e) {
//     print('Firebase initialization error: $e');
//   }
//   runApp(MyApp());
// }


// // void main(){
// //   runApp(ChangeNotifierProvider(
// //       create: (context) => TaskDataProvider(), // Creating the provider
// //       child: MyApp(),
// //     ),);
// // }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       //home: const MyHomePage(title: 'Flutter Demo Home'),
//       //home: const LoginScreen(),
//       //home:  FaviconPage(),
//       home:  const WidgetTree(),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key, required this.title});

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int _currentIndex = 0;
//   bool _showExitAlert = false;

//   final screens = [
//     HomePageWidget(),
//     AddScheduleWidget(),
//     TasksListWidget(),
//     BookmarkListScreenWidget(),
//     //TasksListWidget()
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         if (_currentIndex != 0) {
//           setState(() {
//             _currentIndex = 0;
//           });
//           return false;
//         } else {
//           if (_showExitAlert) {
//             return true;
//           } else {
//             setState(() {
//               _showExitAlert = true;
//             });
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text('Tap again to exit'),
//                 duration: Duration(seconds: 2),
//               ),
//             );
//             Future.delayed(Duration(seconds: 2), () {
//               setState(() {
//                 _showExitAlert = false;
//               });
//             });
//             return false;
//           }
//         }
//       },
//       child: Scaffold(
//         body: screens[_currentIndex],
//         bottomNavigationBar: SalomonBottomBar(
//           currentIndex: _currentIndex,
//           onTap: (index) {
//             setState(() {
//               _currentIndex = index;
//             });
//           },
//           items: [
//             SalomonBottomBarItem(
//               icon: Icon(Icons.home),
//               title: Text("Home"),
//               selectedColor: Colors.purple,
//             ),
//             SalomonBottomBarItem(
//               icon: Icon(Icons.calendar_month),
//               title: Text("Timeslots"),
//               selectedColor: Colors.pink,
//             ),
//             SalomonBottomBarItem(
//               icon: Image.asset(
//                 'lib/assets/icons/checklist.png',
//                 width: 28,
//                 height: 26,
//               ),
//               title: Text("Tasks"),
//               selectedColor: Color.fromARGB(255, 14, 169, 92),
//             ),
//             SalomonBottomBarItem(
//               icon: Image.asset(
//                 'lib/assets/icons/bookmark.png',
//                 width: 28,
//                 height: 26,
//               ),
//               title: Text("Bookmarks"),
//               selectedColor: Colors.orange,
//             ),
//             // SalomonBottomBarItem(
//             //   icon: Icon(Icons.search),
//             //   title: Text("Search"),
//             //   selectedColor: Colors.orange,
//             // ),
//           ],
//         ),
//         // appBar: AppBar(
//         //   backgroundColor: Colors.blue,
//         //   automaticallyImplyLeading: false,
//         //   title: Text(
//         //     widget.title,
//         //     style: TextStyle(
//         //       color: Colors.white,
//         //       fontSize: 22,
//         //       fontWeight: FontWeight.bold,
//         //     ),
//         //   ),
//         //   actions: [],
//         //   centerTitle: false,
//         //   elevation: 2,
//         // ),
//       ),
//     );
//   }
// }
