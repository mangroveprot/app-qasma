import 'package:flutter/material.dart';

class TimeButton extends StatelessWidget {
  const TimeButton({
    super.key,
    required this.time,
    required this.onTap,
  });

  final String time;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(time),
      ),
    );
  }
}
