import 'package:flutter/material.dart';

import '../../../../../common/helpers/spacing.dart';
import '../../../../../common/utils/form_field_config.dart';
import '../../../../../theme/theme_extensions.dart';
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
    final radius = context.radii;
    final fontWeight = context.weight;
    final boxShadows = context.shadows;

    final mainContainerDecoration = BoxDecoration(
      color: colors.white,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
      ),
      boxShadow: [boxShadows.light],
    );

    return Column(
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
            decoration: mainContainerDecoration,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    clipBehavior: Clip.none,
                    physics: const ClampingScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BookCategorySection(
                          category: state.category ?? '',
                        ),
                        Spacing.verticalMedium,
                        RepaintBoundary(
                          child: BookTypeDataTimeSection(
                            dateAndTimeController: state.dropdownControllers[
                                field_appointmentDateTime.field_key]!,
                            appointmentTypeController:
                                state.dropdownControllers[
                                    field_appointmentType.field_key]!,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const BookAppointmentButtons()
              ],
            ),
          ),
        )
      ],
    );
  }
}
