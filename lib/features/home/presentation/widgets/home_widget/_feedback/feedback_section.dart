import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../../common/utils/constant.dart';
import '../../../../../../common/widgets/bloc/button/button_cubit.dart';
import '../../../../../../common/widgets/toast/app_toast.dart';
import '../../../../../appointment/data/models/appointment_model.dart';
import '../../../../../appointment/presentation/bloc/appointments/appointments_cubit.dart';
import 'feedback_dialog.dart';

class FeedBackSection {
  final BuildContext context;
  final ButtonCubit? buttonCubit;

  FeedBackSection({
    required this.context,
    this.buttonCubit,
  });

  void checkPendingFeedback() {
    final state = context.read<AppointmentsCubit>().state;
    if (state is AppointmentsLoadedState) {
      final completedWithoutFeedback = state.appointments.where((appointment) {
        final status = appointment.status.toLowerCase();
        final feedbackSubmitted = appointment.feedbackSubmitted;
        return status == StatusType.completed.field &&
            feedbackSubmitted != true;
      }).toList();

      if (completedWithoutFeedback.isNotEmpty) {
        _showFeedbackModal(completedWithoutFeedback.first);
      }
    }
  }

  void _performUpdateFeedback() {}

  void _showFeedbackModal(AppointmentModel appointment) {
    FeedbackRequiredDialog.show(
      context: context,
      appointment: appointment,
      onSubmitLater: () {},
      onSubmitNow: () async {
        await openFeedbackLink(appointment);
      },
    );
  }

  Future<void> openFeedbackLink(AppointmentModel appointment) async {
    final feedbackUrl = Uri.parse(
      feedback_url,
    );

    try {
      if (await canLaunchUrl(feedbackUrl)) {
        await launchUrl(
          feedbackUrl,
          mode: LaunchMode.externalApplication,
        );
      } else {
        _showErrorToast('Could not redirect to JRMSU CSM Online');
      }
    } catch (e) {
      _showErrorToast('Error: ${e.toString()}');
    }
  }

  void _showErrorToast(String message) {
    if (!context.mounted) return;

    AppToast.show(message: message, type: ToastType.error);
  }
}
