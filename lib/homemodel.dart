import 'package:flutter/material.dart';

class HomePageModel {
  final FocusNode unfocusNode = FocusNode();

  void initState(BuildContext context) {
    // Initialize any state here if needed
  }

  void dispose() {
    unfocusNode.dispose();
  }
}
