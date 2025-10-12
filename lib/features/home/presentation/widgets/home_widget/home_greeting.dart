import 'dart:async';
import 'package:flutter/material.dart';

import '../../../../../common/helpers/helpers.dart';
import '../../../../../common/helpers/spacing.dart';
import '../../../../../common/utils/constant.dart';
import '../../../../../theme/theme_extensions.dart';
import '../../../../appointment/data/models/appointment_model.dart';

class HomeGreetingCard extends StatefulWidget {
  final String userName;
  final List<AppointmentModel> appointments;

  const HomeGreetingCard({
    super.key,
    this.userName = 'Unknown',
    required this.appointments,
  });

  @override
  State<HomeGreetingCard> createState() => _HomeGreetingCardState();
}

class _HomeGreetingCardState extends State<HomeGreetingCard> {
  late DateTime _now;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      if (mounted) {
        setState(() {
          _now = DateTime.now();
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  AppointmentModel? get _nextAppointment {
    final now = _now;
    final upcomingAppointments = widget.appointments.where((appointment) {
      if (appointment.status != StatusType.approved.field) return false;
      final utcTime = appointment.scheduledStartAt;
      return stripMicroseconds(utcTime).isAfter(now);
    }).toList();

    if (upcomingAppointments.isEmpty) return null;

    upcomingAppointments
        .sort((a, b) => a.scheduledStartAt.compareTo(b.scheduledStartAt));
    return upcomingAppointments.first;
  }

  String get _countdownText {
    final nextAppointment = _nextAppointment;
    if (nextAppointment == null) return 'No upcoming appointments';

    final utcTime = nextAppointment.scheduledStartAt;
    final difference = stripMicroseconds(utcTime).difference(_now);

    if (difference.isNegative) {
      return 'Your appointment has started';
    }

    final days = difference.inDays;
    final hours = difference.inHours % 24;
    final minutes = difference.inMinutes % 60;

    if (days > 0) {
      return "You have an appointment in $days day${days > 1 ? 's' : ''}";
    } else if (hours > 0) {
      return "You have an appointment in $hours hour${hours > 1 ? 's' : ''}";
    } else if (minutes > 0) {
      return "You have an appointment in $minutes minute${minutes > 1 ? 's' : ''}";
    } else {
      return 'Your appointment is starting now';
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final weight = context.weight;
    final radius = context.radii;
    final color_white = colors.white;

    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 2,
        color: color_white,
        surfaceTintColor: color_white,
        shape: RoundedRectangleBorder(
          borderRadius: radius.medium,
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Good ${getTimeOfDayGreeting()} ${widget.userName}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: weight.bold,
                        color: colors.textPrimary,
                        fontFamily: 'System',
                      ),
                    ),
                    const TextSpan(
                      text: ' 👋',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              Spacing.horizontalXSmall,
              Text(
                'Hope you\'re having a great day! How can we assist you today?',
                style: TextStyle(
                  fontSize: 12,
                  color: colors.textPrimary,
                  height: 1.3,
                  fontWeight: weight.regular,
                ),
              ),

              // Countdown section
              if (_nextAppointment != null) ...[
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: colors.primary.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: colors.primary.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.schedule,
                        size: 14,
                        color: colors.primary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _countdownText,
                          style: TextStyle(
                            fontSize: 12,
                            color: colors.primary,
                            fontWeight: weight.medium,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
