import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../common/utils/constant.dart';
import '../../../../../common/utils/content_item.dart';
import '../../../../../common/widgets/bloc/button/button_cubit.dart';
import '../../../../../common/widgets/custom_modal/custom_modal.dart';
import '../../../../../theme/theme_extensions.dart';

class HomeFab extends StatelessWidget {
  const HomeFab({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final weight = context.weight;

    return BlocProvider(
      create: (context) => ButtonCubit(),
      child: BlocBuilder<ButtonCubit, ButtonState>(builder: (context, state) {
        final isLoading = state is ButtonLoadingState;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton(
              onPressed: isLoading
                  ? null
                  : () async {
                      final cubit = context.read<ButtonCubit>();
                      cubit.emitLoading();
                      final category = await CustomModal.showSelectionModal(
                          context,
                          title: ContentItems.appointmentSelection.title,
                          subtitle:
                              ContentItems.appointmentSelection.description,
                          options: newAppointmentOptions);
                      cubit.emitInitial();
                      if (category != null) {
                        debugPrint(category);
                      }
                    },
              backgroundColor: isLoading ? colors.textPrimary : colors.primary,
              foregroundColor: colors.white,
              elevation: 4,
              child: isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(colors.white),
                      ),
                    )
                  : const Icon(
                      Icons.add,
                      size: 28,
                    ),
            ),
            const SizedBox(height: 8),
            Text(
              'New Appointments',
              style: TextStyle(
                  fontSize: 12,
                  color: colors.textPrimary,
                  fontWeight: weight.medium),
            ),
          ],
        );
      }),
    );
  }
}
