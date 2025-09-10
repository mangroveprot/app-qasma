import 'package:flutter/material.dart';

import '../../../../appointment_config/data/models/time_slot_model.dart';
import 'time_slot_row.dart';

class DayScheduleCard extends StatelessWidget {
  final String day;
  final List<TimeSlotModel> slots;
  final VoidCallback onAddSlot;
  final ValueChanged<int> onRemoveSlot;
  final void Function(int, String, String) onUpdateSlot;
  final Future<String?> Function(BuildContext, String) onSelectTime;

  const DayScheduleCard({
    super.key,
    required this.day,
    required this.slots,
    required this.onAddSlot,
    required this.onRemoveSlot,
    required this.onUpdateSlot,
    required this.onSelectTime,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  day,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[900],
                  ),
                ),
                IconButton(
                  onPressed: onAddSlot,
                  icon: const Icon(Icons.add),
                  color: Colors.blue[600],
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.blue[50],
                    padding: const EdgeInsets.all(8),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (slots.isEmpty)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'No time slots set for $day',
                  style: TextStyle(color: Colors.grey[500], fontSize: 14),
                ),
              )
            else
              ...slots.asMap().entries.map((entry) => TimeSlotRow(
                    key:
                        ValueKey('${day}_${entry.key}_${entry.value.hashCode}'),
                    slot: entry.value,
                    index: entry.key,
                    onRemove: onRemoveSlot,
                    onUpdate: onUpdateSlot,
                    onSelectTime: onSelectTime,
                  )),
          ],
        ),
      ),
    );
  }
}
