import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  // const carouSliderWithDots({

  // })

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: SafeArea(
          child: Container(
        child: CarouselSlider(
            items: [1, 2, 3, 4, 5].map((e) {
              return Container();
            }).toList(),
            options: CarouselOptions(height: 300)),
      )),
    );
  }
}
