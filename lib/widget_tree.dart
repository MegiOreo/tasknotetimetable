//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:tasknotetimetableapp/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tasknotetimetable/auth.dart';
import 'package:tasknotetimetable/home/home.dart';
import 'package:tasknotetimetable/loginregisterpage.dart';
import 'package:tasknotetimetable/main.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

// class _WidgetTreeState extends State<WidgetTree> {
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//         stream: Auth().authStateChanges, builder: (context, snapshot) {
//           if(snapshot.hasData){
//             return MyHomePage(title: 'Title',);
//           } else{
//             return const LoginScreen();
//           }
//         });
//   }
// }


class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final user = snapshot.data;
          if (user == null) {
            return const LoginScreen();
          } else {
            return const MyHomePage(title: 'Home');
          }
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
