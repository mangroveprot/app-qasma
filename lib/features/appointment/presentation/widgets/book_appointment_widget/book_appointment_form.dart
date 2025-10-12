import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../common/helpers/spacing.dart';
import '../../../../../common/widgets/toast/app_toast.dart';
import '../../../../../theme/theme_extensions.dart';
import '../../bloc/slots/slots_cubit.dart';
import '../../pages/book_appointment_page.dart';
import 'book_appointment_buttons.dart';
import 'book_category_section.dart';
import 'book_description_section.dart';
import 'book_type_date_time_section.dart';
import 'reschedule_remarks_section.dart';

class BookAppointmentForm extends StatelessWidget {
  final BookAppointmentPageState state;

  const BookAppointmentForm({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SlotsCubit(),
      child: BlocListener<SlotsCubit, SlotsCubitState>(
        listener: _handleSlotsState,
        child: Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          decoration: _buildContainerDecoration(context),
          child: Column(
            children: [
              Expanded(child: _buildScrollableContent()),
              _buildBottomButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  void _handleSlotsState(BuildContext context, SlotsCubitState slotsState) {
    if (slotsState is SlotsFailureState) {
      AppToast.show(
        message: slotsState.errorMessages.first,
        type: ToastType.error,
      );
    }
  }

  BoxDecoration _buildContainerDecoration(BuildContext context) {
    final colors = context.colors;
    final shadows = context.shadows;

    return BoxDecoration(
      color: colors.white,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      boxShadow: [shadows.light],
    );
  }

  Widget _buildScrollableContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          BookCategorySection(category: state.category ?? ''),
          Spacing.verticalLarge,
          BookTypeDataTimeSection(
            textControllers: state.textControllers,
            dropdownControllers: state.dropdownControllers,
            category: state.category,
          ),
          Spacing.verticalMedium,
          if (!state.isRescheduling) ...[
            Spacing.verticalMedium,
            BookDescriptionSection(textControllers: state.textControllers),
          ],
          if (state.isRescheduling) ...[
            Spacing.verticalMedium,
            RescheduleRemarksSection(textControllers: state.textControllers),
          ],
        ],
      ),
    );
  }

  Widget _buildBottomButtons(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: BookAppointmentButtons(
          onPressed: () => state.handleSubmit(context),
          isRescheduling: state.isRescheduling,
        ),
      ),
    );
  }
}
