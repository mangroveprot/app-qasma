import 'dart:async';
import 'package:flutter/material.dart';

import '../../../../../common/helpers/helpers.dart';
import '../../../../../common/utils/constant.dart';
import '../../../../../core/_base/_services/storage/shared_preference.dart';
import '../../../../../infrastructure/theme/theme_extensions.dart';
import '../../../../appointment/data/models/appointment_model.dart';

class HomeStatusCard extends StatefulWidget {
  final List<AppointmentModel> appointments;

  const HomeStatusCard({
    super.key,
    required this.appointments,
  });

  @override
  State<HomeStatusCard> createState() => _HomeStatusCardState();
}

class _HomeStatusCardState extends State<HomeStatusCard> {
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
    final currentUserId = SharedPrefs().getString('currentUserId') ?? '';
    final upcomingAppointments = widget.appointments.where((appointment) {
      if (appointment.status != StatusType.approved.field) return false;
      if (appointment.counselorId != currentUserId) return false;
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
      return 'Your next appointment has started';
    }

    final days = difference.inDays;
    final hours = difference.inHours % 24;
    final minutes = difference.inMinutes % 60;

    if (days > 0) {
      return "Your next appointment in $days day${days > 1 ? 's' : ''}";
    } else if (hours > 0) {
      return "Your next appointment in $hours hour${hours > 1 ? 's' : ''}";
    } else if (minutes > 0) {
      return "Your next appointment in $minutes minute${minutes > 1 ? 's' : ''}";
    } else {
      return 'Your next appointment is starting now';
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final radii = context.radii;
    final weight = context.weight;
    final nowUtc = DateTime.now().toUtc();

    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          color: colors.white,
          borderRadius: radii.medium,
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 16, color: colors.primary),
                    const SizedBox(width: 6),
                    Text(
                        formatUtcToLocal(
                          utcTime: nowUtc.toString(),
                          style: DateTimeFormatStyle.dateOnly,
                        ),
                        style: const TextStyle(fontSize: 14)),
                  ],
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: colors.primary.withOpacity(0.1),
                    borderRadius: radii.medium,
                  ),
                  child: Text(
                    'Today',
                    style: TextStyle(
                      fontSize: 10,
                      color: colors.primary,
                    ),
                  ),
                ),
              ],
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
    );
  }
}
