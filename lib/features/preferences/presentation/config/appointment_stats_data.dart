import 'package:flutter/material.dart';

class AppointmentStatsData {
  final String label;
  final int count;
  final int percentage;
  final Color color;
  final IconData icon;

  AppointmentStatsData({
    required this.label,
    required this.count,
    required this.percentage,
    required this.color,
    required this.icon,
  });
}
