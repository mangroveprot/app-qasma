import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../../common/helpers/helpers.dart';
import '../../../../../common/helpers/spacing.dart';
import '../../../../../theme/theme_extensions.dart';
import '../../../../appointment/data/models/appointment_model.dart';
import '../../../../users/data/models/user_model.dart';
import 'appointment_date_time_status.dart';
import 'appointment_details_section.dart';
import 'appointment_more_details.dart';
import 'appointment_stat_indicator.dart';
import 'card_cancel_button.dart';
import 'card_qrcode_section.dart';
import 'card_reschedule_button.dart';

class AppointmentCard extends StatefulWidget {
  final AppointmentModel appointment;
  final VoidCallback onCancel;
  final VoidCallback? onBackPressed;
  final VoidCallback onReschedule;

  final UserModel? student;
  final UserModel? counselor;
  final UserModel? rescheduledByUser;

  const AppointmentCard({
    super.key,
    required this.appointment,
    required this.onCancel,
    required this.onReschedule,
    this.onBackPressed,
    this.student,
    this.counselor,
    this.rescheduledByUser,
  });

  @override
  State<AppointmentCard> createState() => _AppointmentCardState();
}

class _AppointmentCardState extends State<AppointmentCard> {
  DateTime _now = DateTime.now();
  Timer? _timer;
  final bool _isDetailsExpanded = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    if (_now.isBefore(widget.appointment.scheduledEndAt)) {
      _timer = Timer.periodic(const Duration(minutes: 1), (_) {
        if (mounted) {
          setState(() => _now = DateTime.now());
        }
      });
    }
  }

  bool get _isOnSession {
    return _now
            .isAfter(stripMicroseconds(widget.appointment.scheduledStartAt)) &&
        _now.isBefore(stripMicroseconds(widget.appointment.scheduledEndAt));
  }

  bool get _isOverdue {
    return stripMicroseconds(widget.appointment.scheduledEndAt).isBefore(_now);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final weight = context.weight;
    final radius = context.radii;

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
              if (widget.student != null)
                AppointmentDateTimeStatus(
                  appointment: widget.appointment,
                  isOverdue: _isOverdue,
                  isOnSession: _isOnSession,
                  user: widget.student,
                  rescheduledByUser: widget.rescheduledByUser,
                ),
              Spacing.verticalMedium,
              _buildDivider(colors),
              Spacing.verticalMedium,
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: AppointmentDetailsSection(
                      appointment: widget.appointment,
                      counselor: widget.counselor,
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

              //
              //
              //
              // ADD LETTER
              //
              //
              //
              // InkWell(
              //   onTap: () {
              //     setState(() {
              //       _isDetailsExpanded = !_isDetailsExpanded;
              //     });
              //   },
              //   borderRadius: BorderRadius.circular(8),
              //   child: Container(
              //     padding:
              //         const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              //     decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(8),
              //     ),
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //       children: [
              //         Text(
              //           _isDetailsExpanded
              //               ? 'Hide Details'
              //               : 'Appointment Details',
              //           style: TextStyle(
              //             fontSize: 13,
              //             fontWeight: weight.medium,
              //             color: colors.textPrimary,
              //           ),
              //         ),
              //         Icon(
              //           _isDetailsExpanded
              //               ? Icons.keyboard_arrow_up
              //               : Icons.keyboard_arrow_down,
              //           size: 20,
              //           color: colors.textPrimary,
              //         ),
              //       ],
              //     ),
              //   ),
              // ),

              if (widget.student != null)
                AnimatedCrossFade(
                  firstChild: const SizedBox.shrink(),
                  secondChild: Column(
                    children: [
                      Spacing.verticalMedium,
                      AppointmentMoreDetails(
                        appointment: widget.appointment,
                        userModel: widget.student!,
                      ),
                    ],
                  ),
                  crossFadeState: _isDetailsExpanded
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 300),
                ),

              Spacing.verticalMedium,
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider(dynamic colors) {
    return Container(
      height: 1,
      color: colors.textPrimary.withOpacity(0.1),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: CardRescheduleButton(
            buttonId: 'reschedule_${widget.appointment.appointmentId}',
            onPressed: widget.onReschedule,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: CardCancelButton(
            buttonId: 'cancel${widget.appointment.appointmentId}',
            onPressed: widget.onCancel,
          ),
        ),
      ],
    );
  }
}
