import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../../common/helpers/helpers.dart';
import '../../../../../common/helpers/spacing.dart';
import '../../../../../common/utils/constant.dart';
import '../../../../../infrastructure/theme/theme_extensions.dart';
import '../../../../appointment/data/models/appointment_model.dart';
import '../../../../users/data/models/user_model.dart';
import 'appointment_date_time_status.dart';
import 'appointment_details_section.dart';
import 'appointment_stat_indicator.dart';
import 'card_approved_button.dart';
import 'card_cancel_button.dart';
import 'card_reschedule_button.dart';

class AppointmentCard extends StatefulWidget {
  final AppointmentModel appointment;
  final UserModel userModel;
  final UserModel? rescheduledByUser;
  final VoidCallback onCancel;
  final VoidCallback onReschedule;
  final VoidCallback onApproved;
  final bool isCurrentSessions;

  const AppointmentCard({
    super.key,
    required this.appointment,
    required this.onCancel,
    required this.onReschedule,
    required this.userModel,
    required this.onApproved,
    this.isCurrentSessions = false,
    this.rescheduledByUser,
  });

  @override
  State<AppointmentCard> createState() => _AppointmentCardState();
}

class _AppointmentCardState extends State<AppointmentCard> {
  late DateTime _now;
  late Timer _timer;
  bool _isDetailsExpanded = false;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    // every minute for countdown
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

    final appointmentId = widget.appointment.appointmentId;

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
              AppointmentDateTimeStatus(
                appointment: widget.appointment,
                isOverdue: _isOverdue,
                isOnSession: _isOnSession,
                user: widget.userModel,
                rescheduledByUser: widget.rescheduledByUser,
              ),
              // Spacing.verticalMedium,
              // _divider,
              Spacing.verticalSmall,

              // collapssible toggle button
              InkWell(
                onTap: () {
                  setState(() {
                    _isDetailsExpanded = !_isDetailsExpanded;
                  });
                },
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    // color: colors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    // border: Border.all(
                    //   color: colors.primary.withOpacity(0.3),
                    // ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _isDetailsExpanded
                            ? 'Hide Details'
                            : 'Appointment Details',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: weight.medium,
                          color: colors.textPrimary,
                        ),
                      ),
                      Icon(
                        _isDetailsExpanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        size: 20,
                        color: colors.textPrimary,
                      ),
                    ],
                  ),
                ),
              ),

              // animate collapsible details
              AnimatedCrossFade(
                firstChild: const SizedBox.shrink(),
                secondChild: Column(
                  children: [
                    Spacing.verticalMedium,
                    AppointmentDetailsSection(
                      appointment: widget.appointment,
                      userModel: widget.userModel,
                    ),
                  ],
                ),
                crossFadeState: _isDetailsExpanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 300),
              ),

              Spacing.verticalMedium,
              // _divider,
              // Spacing.verticalMedium,

              Column(
                children: [
                  if (widget.appointment.status !=
                      StatusType.approved.field) ...[
                    CardApproveButton(
                      buttonId: 'approved${appointmentId}',
                      onPressed: widget.onApproved,
                    ),
                    const SizedBox(height: 8),
                  ],
                  Row(
                    children: [
                      Expanded(
                        child: CardRescheduleButton(
                          buttonId: 'reschedule_${appointmentId}',
                          onPressed: widget.onReschedule,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: CardCancelButton(
                          buttonId: 'cancel${appointmentId}',
                          onPressed: widget.onCancel,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
