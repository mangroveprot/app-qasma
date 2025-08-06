import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../common/utils/form_field_config.dart';
import '../../../../../common/widgets/bloc/form/form_cubit.dart';
import '../../../../../infrastructure/injection/service_locator.dart';
import '../../../../../theme/theme_extensions.dart';
import '../../../domain/usecases/get_slots_usecase.dart';
import '../../bloc/slots/slots_cubit.dart';
import '../../../../appointment_config/presentation/bloc/appointment_config_cubit.dart';

class BookTypeDataTimeSection extends StatelessWidget {
  final Map<String, TextEditingController> textControllers;
  final Map<String, ValueNotifier<String?>> dropdownControllers;
  final String? category;

  const BookTypeDataTimeSection({
    super.key,
    required this.textControllers,
    required this.dropdownControllers,
    this.category,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final radii = context.radii;
    final weight = context.weight;

    return BlocBuilder<SlotsCubit, SlotsCubitState>(
      builder: (context, state) {
        List<String> availableSlots = [];
        final isLoading = state is SlotsLoadingState;

        if (state is SlotsLoadedState) {
          availableSlots = state.formattedSlots;
        }

        return BlocBuilder<AppointmentConfigCubit, AppointmentConfigCubitState>(
          builder: (context, configState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Appointment Type
                Padding(
                  padding: const EdgeInsets.only(bottom: 8, left: 4),
                  child: Row(
                    children: [
                      Text(
                        'Appointment Type',
                        style: TextStyle(
                          color: colors.textPrimary,
                          fontSize: 14,
                          fontWeight: weight.medium,
                        ),
                      ),
                      Text(
                        ' *',
                        style: TextStyle(
                          color: colors.error,
                          fontSize: 14,
                          fontWeight: weight.medium,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                BlocSelector<FormCubit, FormValidationState, bool>(
                  selector: (state) =>
                      state.hasError(field_appointmentType.field_key),
                  builder: (context, hasError) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ValueListenableBuilder<String?>(
                          valueListenable: dropdownControllers[
                              field_appointmentType.field_key]!,
                          builder: (context, value, _) {
                            final configCubit =
                                context.read<AppointmentConfigCubit>();
                            final appointmentTypes = category != null
                                ? configCubit.getTypesByCategory(category!)
                                : <String>[];

                            return Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: colors.white.withOpacity(0.8),
                                borderRadius: radii.small,
                                border: Border.all(
                                  color: hasError
                                      ? colors.error
                                      : colors.accent.withOpacity(0.4),
                                  width: 1.0,
                                ),
                              ),
                              child: appointmentTypes.isEmpty
                                  ? Container(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Text(
                                        'No types available for this category',
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 14,
                                        ),
                                      ),
                                    )
                                  : DropdownButtonFormField<String>(
                                      value: value,
                                      hint: const Text(
                                        'Select appointment type',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 14,
                                        ),
                                      ),
                                      items: appointmentTypes
                                          .map<DropdownMenuItem<String>>(
                                              (String type) {
                                        return DropdownMenuItem<String>(
                                          value: type,
                                          child: Text(
                                            type,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (newValue) async {
                                        if (newValue != null) {
                                          dropdownControllers[
                                                  field_appointmentType
                                                      .field_key]!
                                              .value = newValue;
                                          dropdownControllers[
                                                  field_appointmentDateTime
                                                      .field_key]!
                                              .value = null;

                                          context
                                              .read<FormCubit>()
                                              .clearFieldError(
                                                  field_appointmentType
                                                      .field_key);

                                          // Get duration for the selected type
                                          final duration = category != null
                                              ? configCubit
                                                  .getDurationByTypeInCategory(
                                                      category!, newValue)
                                              : 10;

                                          print(duration);

                                          context.read<SlotsCubit>().loadSlots(
                                                duration:
                                                    duration?.toString() ??
                                                        '10',
                                                usecase:
                                                    await sl<GetSlotsUseCase>(),
                                              );
                                        }
                                      },
                                      decoration: const InputDecoration(
                                        contentPadding: EdgeInsets.all(12.0),
                                        border: InputBorder.none,
                                      ),
                                    ),
                            );
                          },
                        ),
                        if (hasError)
                          Padding(
                            padding: const EdgeInsets.only(top: 8, left: 4),
                            child: Text(
                              'This field is required',
                              style: TextStyle(
                                color: colors.error,
                                fontSize: 12,
                                fontWeight: weight.regular,
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 20),

                // Date & Time
                Padding(
                  padding: const EdgeInsets.only(bottom: 8, left: 4),
                  child: Row(
                    children: [
                      Text(
                        'Date & Time',
                        style: TextStyle(
                          color: colors.textPrimary,
                          fontSize: 14,
                          fontWeight: weight.medium,
                        ),
                      ),
                      Text(
                        ' *',
                        style: TextStyle(
                          color: colors.error,
                          fontSize: 14,
                          fontWeight: weight.medium,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                BlocSelector<FormCubit, FormValidationState, bool>(
                  selector: (state) =>
                      state.hasError(field_appointmentDateTime.field_key),
                  builder: (context, hasError) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ValueListenableBuilder<String?>(
                          valueListenable: dropdownControllers[
                              field_appointmentDateTime.field_key]!,
                          builder: (context, value, _) {
                            if (isLoading) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 14),
                                decoration: BoxDecoration(
                                  color: colors.white.withOpacity(0.8),
                                  borderRadius: radii.small,
                                  border: Border.all(
                                    color: colors.accent.withOpacity(0.4),
                                    width: 1.0,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      'Loading slots...',
                                      style: TextStyle(
                                          color: Colors.grey.shade600),
                                    ),
                                  ],
                                ),
                              );
                            }

                            return Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: colors.white.withOpacity(0.8),
                                borderRadius: radii.small,
                                border: Border.all(
                                  color: hasError
                                      ? colors.error
                                      : colors.accent.withOpacity(0.4),
                                  width: 1.0,
                                ),
                              ),
                              child: DropdownButtonFormField<String>(
                                value: value,
                                hint: const Text(
                                  'Select date and time',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                                items: availableSlots.map((String slot) {
                                  return DropdownMenuItem<String>(
                                    value: slot,
                                    child: Text(
                                      slot,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  dropdownControllers[
                                          field_appointmentDateTime.field_key]!
                                      .value = newValue;

                                  // Clear error when user makes a selection
                                  if (newValue != null) {
                                    context.read<FormCubit>().clearFieldError(
                                        field_appointmentDateTime.field_key);
                                  }
                                },
                                menuMaxHeight: 400,
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.all(12.0),
                                  border: InputBorder.none,
                                ),
                              ),
                            );
                          },
                        ),
                        if (hasError)
                          Padding(
                            padding: const EdgeInsets.only(top: 8, left: 4),
                            child: Text(
                              'This field is required',
                              style: TextStyle(
                                color: colors.error,
                                fontSize: 12,
                                fontWeight: weight.regular,
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
