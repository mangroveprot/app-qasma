import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../theme/theme_extensions.dart';
import 'book_type_label.dart';

import '../../../../../common/utils/form_field_config.dart';
import '../../../../../common/widgets/bloc/form/form_cubit.dart';
import '../../../../../infrastructure/injection/service_locator.dart';
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
    return BlocBuilder<SlotsCubit, SlotsCubitState>(
      builder: (context, slotsState) {
        return BlocBuilder<AppointmentConfigCubit, AppointmentConfigCubitState>(
          builder: (context, configState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _AppointmentTypeDropdown(
                  controller:
                      dropdownControllers[field_appointmentType.field_key]!,
                  category: category,
                  onTypeSelected: (type) =>
                      _onAppointmentTypeSelected(context, type),
                ),
                const SizedBox(height: 20),
                _DateTimeDropdown(
                  controller:
                      dropdownControllers[field_appointmentDateTime.field_key]!,
                  appointmentTypeController:
                      dropdownControllers[field_appointmentType.field_key]!,
                  slotsState: slotsState,
                  category: category,
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _onAppointmentTypeSelected(
      BuildContext context, String type) async {
    dropdownControllers[field_appointmentDateTime.field_key]!.value = null;

    context.read<FormCubit>().clearFieldError(field_appointmentType.field_key);

    final configCubit = context.read<AppointmentConfigCubit>();
    final duration = category != null
        ? configCubit.getDurationByTypeInCategory(category!, type) ?? 10
        : 10;

    context.read<SlotsCubit>().loadSlots(
          duration: duration.toString(),
          usecase: await sl<GetSlotsUseCase>(),
        );
  }
}

class _AppointmentTypeDropdown extends StatelessWidget {
  final ValueNotifier<String?> controller;
  final String? category;
  final Function(String) onTypeSelected;

  const _AppointmentTypeDropdown({
    required this.controller,
    this.category,
    required this.onTypeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const BookTypeLabel(
          text: 'Appointment Type',
          tooltip: 'sdaasdsads',
        ),
        const SizedBox(height: 8),
        BlocSelector<FormCubit, FormValidationState, bool>(
          selector: (state) => state.hasError(field_appointmentType.field_key),
          builder: (context, hasError) {
            return ValueListenableBuilder<String?>(
              valueListenable: controller,
              builder: (context, value, _) {
                final appointmentTypes = _getAppointmentTypes(context);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _CustomDropdown<String>(
                      value: value,
                      hint: 'Select appointment type',
                      items: appointmentTypes,
                      hasError: hasError,
                      onChanged: (newValue) {
                        if (newValue != null) {
                          controller.value = newValue;
                          onTypeSelected(newValue);
                        }
                      },
                      emptyMessage: 'No types available for this category',
                    ),
                    if (hasError)
                      const _ErrorText(text: 'This field is required'),
                  ],
                );
              },
            );
          },
        ),
      ],
    );
  }

  List<String> _getAppointmentTypes(BuildContext context) {
    if (category == null) return [];

    final configCubit = context.read<AppointmentConfigCubit>();
    return configCubit.getTypesByCategory(category!);
  }
}

class _DateTimeDropdown extends StatelessWidget {
  final ValueNotifier<String?> controller;
  final ValueNotifier<String?> appointmentTypeController;
  final SlotsCubitState slotsState;
  final String? category;

  const _DateTimeDropdown({
    required this.controller,
    required this.appointmentTypeController,
    required this.slotsState,
    this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const BookTypeLabel(
          text: 'Date & Time',
          tooltip: 'dsadnsakdbjl',
        ),
        const SizedBox(height: 8),
        BlocSelector<FormCubit, FormValidationState, bool>(
          selector: (state) =>
              state.hasError(field_appointmentDateTime.field_key),
          builder: (context, hasError) {
            return ValueListenableBuilder<String?>(
              valueListenable: controller,
              builder: (context, value, _) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDateTimeField(context, value, hasError),
                    if (hasError)
                      const _ErrorText(text: 'This field is required'),
                  ],
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildDateTimeField(
      BuildContext context, String? value, bool hasError) {
    if (slotsState is SlotsLoadingState) {
      return _LoadingContainer();
    }

    final availableSlots = slotsState is SlotsLoadedState
        ? (slotsState as SlotsLoadedState).formattedSlots
        : <String>[];

    final uniqueSlots = availableSlots.toSet().toList();

    final List<String> dropdownItems = List.from(uniqueSlots);

    if (value != null && !dropdownItems.contains(value)) {
      dropdownItems.insert(0, value);
    }

    final hasOnlyCurrentValue =
        dropdownItems.length <= 1 && value != null && uniqueSlots.isEmpty;

    final canFetchSlots =
        appointmentTypeController.value != null && category != null;

    return _CustomDropdown<String>(
      value: value,
      hint: 'Select date and time',
      items: dropdownItems,
      hasError: hasError,
      menuMaxHeight: 400,
      onTap: (hasOnlyCurrentValue && canFetchSlots)
          ? () => _fetchSlotsForRescheduling(context)
          : null,
      onChanged: (newValue) {
        controller.value = newValue;
        if (newValue != null) {
          context
              .read<FormCubit>()
              .clearFieldError(field_appointmentDateTime.field_key);
        }
      },
      emptyMessage: (hasOnlyCurrentValue && canFetchSlots)
          ? 'Tap to load more available slots'
          : 'No slots available',
    );
  }

  Future<void> _fetchSlotsForRescheduling(BuildContext context) async {
    final appointmentType = appointmentTypeController.value;
    if (appointmentType == null || category == null) return;

    // Get duration for the selected type
    final configCubit = context.read<AppointmentConfigCubit>();
    final duration =
        configCubit.getDurationByTypeInCategory(category!, appointmentType) ??
            10;

    // Load available slots
    context.read<SlotsCubit>().loadSlots(
          duration: duration.toString(),
          usecase: await sl<GetSlotsUseCase>(),
        );
  }
}

class _CustomDropdown<T> extends StatelessWidget {
  final T? value;
  final String hint;
  final List<T> items;
  final bool hasError;
  final Function(T?) onChanged;
  final String? emptyMessage;
  final double? menuMaxHeight;
  final VoidCallback? onTap;

  const _CustomDropdown({
    this.value,
    required this.hint,
    required this.items,
    this.hasError = false,
    required this.onChanged,
    this.emptyMessage,
    this.menuMaxHeight,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final radii = context.radii;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colors.white.withOpacity(0.8),
        borderRadius: radii.small,
        border: Border.all(
          color: hasError ? colors.error : colors.accent.withOpacity(0.4),
          width: 1.0,
        ),
      ),
      child: items.isEmpty && emptyMessage != null
          ? _EmptyState(message: emptyMessage!)
          : DropdownButtonFormField<T>(
              value: value,
              hint: Text(
                hint,
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
              items: items
                  .map((item) => DropdownMenuItem<T>(
                        value: item,
                        child: Text(
                          item.toString(),
                          style: TextStyle(
                            fontSize: item.toString().length > 10 ? 12.0 : 14.0,
                            color: Colors.black,
                          ),
                        ),
                      ))
                  .toList(),
              onTap: onTap,
              onChanged: onChanged,
              menuMaxHeight: menuMaxHeight,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(12.0),
                border: InputBorder.none,
              ),
            ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String message;

  const _EmptyState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      child: Text(
        message,
        style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
      ),
    );
  }
}

class _LoadingContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final radii = context.radii;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          const SizedBox(width: 12),
          Text(
            'Loading slots...',
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}

class _ErrorText extends StatelessWidget {
  final String text;

  const _ErrorText({required this.text});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final weight = context.weight;

    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 4),
      child: Text(
        text,
        style: TextStyle(
          color: colors.error,
          fontSize: 12,
          fontWeight: weight.regular,
        ),
      ),
    );
  }
}
