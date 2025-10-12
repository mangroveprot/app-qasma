import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../../common/helpers/helpers.dart';
import '../../../../../common/helpers/spacing.dart';
import '../../../../../theme/theme_extensions.dart';
import '../../../../appointment/data/models/appointment_model.dart';
import '../../../../users/data/models/user_model.dart';
import 'appointment_date_time_status.dart';
import 'appointment_details_section.dart';
import 'appointment_stat_indicator.dart';
import 'card_cancel_button.dart';
import 'card_qrcode_section.dart';
import 'card_reschedule_button.dart';

class AppointmentCard extends StatefulWidget {
  final AppointmentModel appointment;
  final UserModel? user;
  final VoidCallback onCancel;
  final VoidCallback? onBackPressed;
  final VoidCallback onReschedule;
  const AppointmentCard({
    super.key,
    required this.appointment,
    required this.onCancel,
    required this.onReschedule,
    this.user,
    this.onBackPressed,
  });

  @override
  State<AppointmentCard> createState() => _AppointmentCardState();
}

class _AppointmentCardState extends State<AppointmentCard> {
  bool _showActions = false;
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

  bool get _isOnSession {
    final utcStartTime = widget.appointment.scheduledStartAt;
    final utcEndTime = widget.appointment.scheduledEndAt;

    return _now.isAfter(stripMicroseconds(utcStartTime)) &&
        _now.isBefore(stripMicroseconds(utcEndTime));
  }

  bool get _isOverdue {
    final utcEndTime = widget.appointment.scheduledEndAt;

    return stripMicroseconds(utcEndTime).isBefore(_now);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final weight = context.weight;
    final radius = context.radii;
    final textPrimay = colors.textPrimary;

    final _divider = Container(
      height: 1,
      color: textPrimay.withOpacity(0.1),
    );

    return Card(
      elevation: 4,
      color: colors.white,
      surfaceTintColor: colors.white,
      shadowColor: colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: radius.large,
        side: _isOverdue
            ? BorderSide(color: colors.error.withOpacity(0.3), width: 1)
            : _isOnSession
                ? BorderSide(color: colors.primary.withOpacity(0.4), width: 1)
                : BorderSide.none,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: radius.large,
          color: _isOverdue
              ? colors.error.withOpacity(0.1)
              : _isOnSession
                  ? colors.primary.withOpacity(0.1)
                  : Colors.transparent,
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              AppointmentStatIndicator(
                isOnSession: _isOnSession,
                isOverdue: _isOverdue,
              ),
              // date/time and status
              AppointmentDateTimeStatus(
                appointment: widget.appointment,
                isOverdue: _isOverdue,
                isOnSession: _isOnSession,
                user: widget.user,
              ),

              Spacing.verticalMedium,
              _divider,
              Spacing.verticalMedium,

              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // left side - Appointment info
                  Expanded(
                    child: AppointmentDetailsSection(
                      appointment: widget.appointment,
                    ),
                  ),
                  if (widget.appointment.qrCode.token != null) ...[
                    const SizedBox(width: 16),
                    CardQRCodeSection(
                      qrData: widget.appointment.qrCode,
                      onBackPressed: widget.onBackPressed,
                    ),
                  ],
                ],
              ),

              Spacing.verticalMedium,
              _divider,
              Spacing.verticalSmall,

              // See More / Actions
              GestureDetector(
                onTap: () {
                  setState(() {
                    _showActions = !_showActions;
                  });
                },
                child: Center(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _showActions ? 'See less' : 'See more',
                          style: TextStyle(
                            fontSize: 12,
                            color: colors.textPrimary,
                            fontWeight: weight.medium,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          _showActions
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          color: colors.textPrimary,
                          size: 14,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              if (_showActions) ...[
                Spacing.verticalMedium,
                // action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CardRescheduleButton(onPressed: widget.onReschedule),
                    const SizedBox(width: 8),
                    CardCancelButton(onPressed: widget.onCancel),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
