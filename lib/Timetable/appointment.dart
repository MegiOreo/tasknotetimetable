import 'package:flutter/material.dart';
import 'dart:convert';

class Appointment {
  final DateTime startTime;
  final DateTime endTime;
  final String subject;
  final Color color;
  final bool isAllDay;

  Appointment({
    required this.startTime,
    required this.endTime,
    required this.subject,
    required this.color,
    required this.isAllDay,
  });

  Map<String, dynamic> toJson() {
    return {
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'subject': subject,
      // Convert color to ARGB int
      'color': color.value,
      'isAllDay': isAllDay,
    };
  }

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      subject: json['subject'],
      // Construct color from ARGB int
      color: Color(json['color']),
      isAllDay: json['isAllDay'],
    );
  }

  String toJsonString() {
    return jsonEncode(toJson());
  }

  // Add a factory method to create Appointment from JSON string
  factory Appointment.fromJsonString(String jsonString) {
    final Map<String, dynamic> json = jsonDecode(jsonString);
    return Appointment.fromJson(json);
  }
}
