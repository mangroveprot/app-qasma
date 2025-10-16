import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../common/helpers/helpers.dart';
import '../../../../../common/utils/button_ids.dart';
import '../../../../../common/widgets/bloc/button/button_cubit.dart';
import '../../../../../common/widgets/button_text/custom_text_button.dart';
import '../../../../../common/widgets/toast/app_toast.dart';
import '../../../../../infrastructure/theme/theme_extensions.dart';
import '../../../data/models/appointment_model.dart';

class ScannerResultDialog extends StatelessWidget {
  final String scannedData;
  final VoidCallback onScanAgain;
  final VoidCallback onDone;
  final AppointmentModel appointment;
  final ButtonCubit buttonCubit;

  const ScannerResultDialog({
    super.key,
    required this.scannedData,
    required this.onScanAgain,
    required this.onDone,
    required this.appointment,
    required this.buttonCubit,
  });

  static Future<void> show({
    required AppointmentModel appointment,
    required BuildContext context,
    required String scannedData,
    required VoidCallback onScanAgain,
    required VoidCallback onDone,
    required ButtonCubit buttonCubit,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => ScannerResultDialog(
        appointment: appointment,
        scannedData: scannedData,
        onScanAgain: onScanAgain,
        onDone: onDone,
        buttonCubit: buttonCubit,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: buttonCubit,
      child: Builder(builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.9,
              maxHeight: MediaQuery.of(context).size.height * 0.85,
            ),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 8,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildHeader(context),
                      const SizedBox(height: 16),
                      _buildContent(context),
                      const SizedBox(height: 16),
                      _buildActions(context),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final colors = context.colors;
    final fontWeight = context.weight;
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: colors.secondary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Icon(
            Icons.qr_code_scanner,
            size: 24,
            color: colors.secondary,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Confirm Appointment',
          style: TextStyle(
            fontSize: 18,
            fontWeight: fontWeight.bold,
            color: colors.black,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 6),
        Text(
          'Is this the session you want to verify?',
          style: TextStyle(
            fontSize: 13,
            color: colors.textPrimary,
            fontWeight: fontWeight.regular,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    final colors = context.colors;
    final fontWeight = context.weight;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.check_circle,
              color: colors.primary,
              size: 16,
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'Ready to verify this appointment:',
                style: TextStyle(
                  fontSize: 12,
                  color: colors.primary,
                  fontWeight: fontWeight.medium,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Appointment details container - reduced padding
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFEDF2F7),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDataRow(
                  'Date',
                  '${formatUtcToLocal(utcTime: appointment.scheduledStartAt.toString(), style: DateTimeFormatStyle.dateOnly)}',
                  Icons.calendar_today,
                  colors),
              const SizedBox(height: 8),
              _buildDataRow(
                  'Time',
                  '${formatUtcToLocal(utcTime: appointment.scheduledStartAt.toString(), style: DateTimeFormatStyle.timeOnly)} - '
                      '${formatUtcToLocal(
                    utcTime: appointment.scheduledEndAt.toString(),
                    style: DateTimeFormatStyle.timeOnly,
                  )}',
                  Icons.access_time,
                  colors),
              const SizedBox(height: 8),
              _buildDataRow(
                'Student ID',
                appointment.studentId,
                Icons.person,
                colors,
              ),
              const SizedBox(height: 8),
              _buildDataRow(
                'Counselor ID',
                appointment.counselorId ?? '',
                Icons.person_outline,
                colors,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDataRow(
      String label, String value, IconData icon, dynamic colors) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 14,
          color: colors.textPrimary,
        ),
        const SizedBox(width: 6),
        SizedBox(
          width: 80,
          child: Text(
            '$label:',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: colors.textPrimary,
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              Clipboard.setData(ClipboardData(text: value));
              AppToast.show(
                  message: '$label copied to clipboard',
                  type: ToastType.original);
            },
            child: Text(
              value,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: colors.textPrimary,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActions(BuildContext context) {
    final colors = context.colors;
    return Column(
      children: [
        CustomTextButton(
          backgroundColor: colors.primary,
          width: double.infinity,
          onPressed: onDone,
          text: 'Verify Session',
          buttonId: ButtonsUniqeKeys.verifyQR.id,
          borderRadius: BorderRadius.circular(10),
          iconData: Icons.check,
          iconPosition: Position.left,
          iconSize: 14,
          textColor: colors.white,
          iconColor: colors.white,
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          height: 44,
          child: OutlinedButton(
            onPressed: () {
              Navigator.of(context).pop();
              onScanAgain();
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.grey,
              side: const BorderSide(color: Colors.grey),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(vertical: 8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.qr_code_scanner,
                  size: 14,
                  color: colors.black,
                ),
                const SizedBox(width: 6),
                Text(
                  'Wrong Appointment',
                  style: TextStyle(fontSize: 14, color: colors.black),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
