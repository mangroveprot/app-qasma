import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../infrastructure/injection/service_locator.dart';
import '../../../domain/usecases/get_slots_usecase.dart';
import '../../bloc/slots/slots_cubit.dart';

class BookTypeDataTimeSection extends StatelessWidget {
  final ValueNotifier<String?> dateAndTimeController;
  final ValueNotifier<String?> appointmentTypeController;

  const BookTypeDataTimeSection({
    super.key,
    required this.dateAndTimeController,
    required this.appointmentTypeController,
  });

  static const List<String> _appointmentTypes = [
    'Individual Counseling',
    'Group Therapy',
    'Family Counseling',
    'Couples Therapy',
    'Crisis Intervention',
    'Online Session',
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SlotsCubit, SlotsCubitState>(
      builder: (context, state) {
        List<String> availableSlots = [];
        bool isLoading = state is SlotsLoadingState;

        if (state is SlotsLoadedState) {
          // Show only half of the available slots
          final allSlots = state.formattedSlots;
          final halfCount = (allSlots.length / 2).ceil();
          availableSlots = allSlots.take(halfCount).toList();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Appointment Type
            const Text(
              'Appointment Type',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            ValueListenableBuilder<String?>(
              valueListenable: appointmentTypeController,
              builder: (context, value, _) {
                return DropdownButtonFormField<String>(
                  value: value,
                  hint: const Text('Select appointment type'),
                  items: _appointmentTypes.map((String type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (newValue) async {
                    if (newValue != null) {
                      appointmentTypeController.value = newValue;
                      dateAndTimeController.value = null;
                      context.read<SlotsCubit>().loadSlots(
                            duration: '10',
                            usecase: await sl<GetSlotsUseCase>(),
                          );
                    }
                  },
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            // Date & Time
            const Text(
              'Date & Time',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            ValueListenableBuilder<String?>(
              valueListenable: dateAndTimeController,
              builder: (context, value, _) {
                if (isLoading) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
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

                return DropdownButtonFormField<String>(
                  value: value,
                  hint: const Text('Select date and time'),
                  items: availableSlots.map((String slot) {
                    return DropdownMenuItem<String>(
                      value: slot,
                      child: Text(slot),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    dateAndTimeController.value = newValue;
                  },
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
