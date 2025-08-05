import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../common/helpers/spacing.dart';
import '../../../../../common/utils/form_field_config.dart';
import '../../../../../theme/theme_extensions.dart';
import '../../bloc/slots/slots_cubit.dart';
import '../../pages/book_appointment_page.dart';
import 'book_appointment_buttons.dart';
import 'book_category_section.dart';
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
          // Handle error states with better UX
          if (slotsState is SlotsFailureState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.white),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        slotsState.errorMessages.first,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
                backgroundColor: Colors.red.shade600,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                margin: const EdgeInsets.all(16),
                duration: const Duration(seconds: 4),
                action: SnackBarAction(
                  label: 'Dismiss',
                  textColor: Colors.white,
                  onPressed: () =>
                      ScaffoldMessenger.of(context).hideCurrentSnackBar(),
                ),
              ),
            );
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
                                    dateAndTimeController: state
                                            .dropdownControllers[
                                        field_appointmentDateTime.field_key]!,
                                    appointmentTypeController:
                                        state.dropdownControllers[
                                            field_appointmentType.field_key]!,
                                  ),
                                ),

                                // Add some bottom padding to ensure content doesn't get cut off
                                const SizedBox(height: 20),
                              ]),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Bottom buttons section
                    Container(
                      decoration: BoxDecoration(
                        color: colors.white,
                        border: Border(
                          top: BorderSide(
                            color: Colors.grey.shade200,
                            width: 1,
                          ),
                        ),
                      ),
                      child: const SafeArea(
                        top: false,
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: BookAppointmentButtons(),
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
