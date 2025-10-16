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
  DateTime _now = DateTime.now();
  Timer? _timer;

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
    // Only update time if appointment hasn't ended
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
              AppointmentDateTimeStatus(
                appointment: widget.appointment,
                isOverdue: _isOverdue,
                isOnSession: _isOnSession,
                user: widget.user,
              ),
              Spacing.verticalMedium,
              _buildDivider(colors),
              Spacing.verticalMedium,
              _buildContentRow(),
              Spacing.verticalMedium,
              _buildDivider(colors),
              Spacing.verticalSmall,
              _buildToggleButton(colors, weight),
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

  Widget _buildContentRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
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
    );
  }

  Widget _buildToggleButton(dynamic colors, dynamic weight) {
    return GestureDetector(
      onTap: () => setState(() => _showActions = !_showActions),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _showActions ? 'Collapse' : 'Expand',
                style: TextStyle(
                  fontSize: 12,
                  color: colors.textPrimary,
                  fontWeight: weight.medium,
                ),
              ),
              const SizedBox(width: 4),
              AnimatedRotation(
                turns: _showActions ? 0.5 : 0,
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  Icons.keyboard_arrow_down,
                  color: colors.textPrimary,
                  size: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return ClipRect(
      child: AnimatedAlign(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        heightFactor: _showActions ? 1.0 : 0.0,
        alignment: Alignment.topCenter,
        child: Column(
          children: [
            Spacing.verticalMedium,
            Row(
              children: [
                Expanded(
                  child: _PressableButton(
                    child: CardRescheduleButton(
                      buttonId:
                          'reschedule_${widget.appointment.appointmentId}',
                      onPressed: widget.onReschedule,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _PressableButton(
                    child: CardCancelButton(
                      buttonId: 'cancel${widget.appointment.appointmentId}',
                      onPressed: widget.onCancel,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PressableButton extends StatefulWidget {
  final Widget child;

  const _PressableButton({required this.child});

  @override
  State<_PressableButton> createState() => _PressableButtonState();
}

class _PressableButtonState extends State<_PressableButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        child: widget.child,
      ),
    );
  }
}
