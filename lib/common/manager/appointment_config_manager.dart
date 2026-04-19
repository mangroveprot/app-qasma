import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/appointment_config/domain/usecases/sync_config_usecase.dart';
import '../../features/appointment_config/presentation/bloc/appointment_config_cubit.dart';
import '../../infrastructure/injection/service_locator.dart';
import '../../infrastructure/routes/app_routes.dart';
import '../utils/content_item.dart';
import '../widgets/custom_modal/custom_modal.dart';
import '../widgets/models/modal_option.dart';

class AppointmentConfigManager {
  late final SyncConfigUsecase _syncConfigUsacase;

  AppointmentConfigManager() {
    _syncConfigUsacase = sl<SyncConfigUsecase>();
  }

  void loadAllAppointmentsConfig(AppointmentConfigCubit cubit) {
    cubit.loadAppointmentConfig(usecase: _syncConfigUsacase);
  }

  Future<void> refreshAppointmentsConfig(AppointmentConfigCubit cubit) async {
    await cubit.loadAppointmentConfig(usecase: _syncConfigUsacase);
  }

  Future<void> showAppointmentModal(
    BuildContext context, {
    required List<ModalOption> options,
    VoidCallback? onAppointmentSuccess,
  }) async {
    final category = await CustomModal.showSelectionModal(
      context,
      title: ContentItems.appointmentSelection.title,
      subtitle: ContentItems.appointmentSelection.description,
      options: options,
      showBackButton: false,
    );

    if (category != null && context.mounted) {
      context.push(
        Routes.appointment,
        extra: {
          'category': category,
          'onSuccess': () async {
            onAppointmentSuccess?.call();
          },
        },
      );
    }
  }
}
