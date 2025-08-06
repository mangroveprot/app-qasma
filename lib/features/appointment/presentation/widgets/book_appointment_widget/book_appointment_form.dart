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

class BookAppointmentForm extends StatelessWidget {
  final BookAppointmentPageState state;

  const BookAppointmentForm({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final boxShadows = context.shadows;

    final mainContainerDecoration = BoxDecoration(
      color: colors.white,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
      ),
      boxShadow: [boxShadows.light],
    );

    return BlocProvider(
      create: (context) => SlotsCubit(),
      child: BlocListener<SlotsCubit, SlotsCubitState>(
        listener: (context, slotsState) {
          if (slotsState is SlotsFailureState) {
            AppToast.show(
                message: slotsState.errorMessages.first, type: ToastType.error);
          }
        },
        child: Column(
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                decoration: mainContainerDecoration,
                child: Column(
                  children: [
                    // Main content area
                    Expanded(
                      child: CustomScrollView(
                        physics: const ClampingScrollPhysics(),
                        slivers: [
                          SliverPadding(
                            padding: const EdgeInsets.all(20),
                            sliver: SliverList(
                              delegate: SliverChildListDelegate([
                                // Category Section
                                BookCategorySection(
                                  category: state.category ?? '',
                                ),
                                Spacing.verticalLarge,

                                // Appointment Type and DateTime Section
                                RepaintBoundary(
                                  child: BookTypeDataTimeSection(
                                    textControllers: state.textControllers,
                                    dropdownControllers:
                                        state.dropdownControllers,
                                    category: state.category,
                                  ),
                                ),
                                Spacing.verticalMedium,
                                BookDescriptionSection(
                                  textControllers: state.textControllers,
                                ),
                              ]),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // buttons section
                    SafeArea(
                      top: false,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: BookAppointmentButtons(
                          onPressed: () => state.handleSubmit(context),
                          isRescheduling: state.isRescheduling,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
