import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../../common/utils/button_ids.dart';
import '../../../../../../common/utils/constant.dart';
import '../../../../../../common/widgets/bloc/button/button_cubit.dart';
import '../../../../../../common/widgets/toast/app_toast.dart';
import '../../../../../../infrastructure/injection/service_locator.dart';
import '../../../../../appointment/data/models/appointment_model.dart';
import '../../../../../appointment/domain/usecases/update_appointment_usecase.dart';
import '../../../../../appointment/presentation/bloc/appointments/appointments_cubit.dart';
import '../../../../../users/data/models/params/dynamic_param.dart';
import 'feedback_dialog.dart';

class FeedBackSection {
  final BuildContext context;
  final ButtonCubit buttonCubit;
  static bool _isFeedbackModalOpen = false;
  static bool _hasPendingFeedback = false;
  static bool _hasUnfinishedAppointment = false;

  static bool get hasPendingFeedback => _hasPendingFeedback;
  static bool get hasUnfinishedAppointment => _hasUnfinishedAppointment;

  FeedBackSection({
    required this.context,
    required this.buttonCubit,
  });

  static void closeModalIfOpen(BuildContext context) {
    if (_isFeedbackModalOpen && context.mounted) {
      context.pop();
      _isFeedbackModalOpen = false;
    }
  }

  void checkPendingFeedback() {
    final state = context.read<AppointmentsCubit>().state;
    if (state is AppointmentsLoadedState) {
      final completedWithoutFeedback = state.appointments.where((appointment) {
        final status = appointment.status.toLowerCase();
        final feedbackSubmitted = appointment.feedbackSubmitted;
        return status == StatusType.completed.field &&
            feedbackSubmitted != true;
      }).toList();

      _hasPendingFeedback = completedWithoutFeedback.isNotEmpty;

      final unfinishedAppointments = state.appointments.where((appointment) {
        final status = appointment.status.toLowerCase();
        return status == StatusType.pending.field ||
            status == StatusType.approved.field;
      }).toList();

      _hasUnfinishedAppointment = unfinishedAppointments.isNotEmpty;

      if (completedWithoutFeedback.isNotEmpty) {
        _showAppointmentFeedback(completedWithoutFeedback.first);
      }
    } else {
      _hasPendingFeedback = false;
      _hasUnfinishedAppointment = false;
    }
  }

  void _showAppointmentFeedback(AppointmentModel appointment) {
    _isFeedbackModalOpen = true;

    FeedbackDialog.showForAppointment(
      context: context,
      appointment: appointment,
      onLater: () {
        _isFeedbackModalOpen = false;
      },
      buttonCubit: buttonCubit,
      onNow: () async {
        await _submitAppointmentFeedback(appointment);
      },
    ).then((_) => _isFeedbackModalOpen = false);
  }

  void showGeneralFeedback() {
    _isFeedbackModalOpen = true;

    FeedbackDialog.showGeneral(
      context: context,
      onCancel: () {
        _isFeedbackModalOpen = false;
      },
      onSubmit: () async {
        await openFeedbackLink();
        _isFeedbackModalOpen = false;
      },
      buttonCubit: buttonCubit,
    ).then((_) => _isFeedbackModalOpen = false);
  }

  Future<void> _submitAppointmentFeedback(AppointmentModel appointment) async {
    await openFeedbackLink();

    final params = DynamicParam(fields: {
      'appointmentId': appointment.appointmentId,
      'feedbackSubmitted': true,
    });

    context.read<ButtonCubit>().execute(
          buttonId: ButtonsUniqeKeys.feedback.id,
          usecase: sl<UpdateAppointmentUsecase>(),
          params: params,
        );
  }

  Future<void> openFeedbackLink() async {
    final feedbackUrl = Uri.parse(feedback_url);

    try {
      if (await canLaunchUrl(feedbackUrl)) {
        await launchUrl(feedbackUrl, mode: LaunchMode.externalApplication);
      } else {
        _showErrorToast('Could not redirect to JRMSU Feedback Form');
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
