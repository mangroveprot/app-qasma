import 'package:flutter/material.dart';

import '../../../../appointment_config/data/models/time_slot_model.dart';
import 'time_button.dart';

class TimeSlotRow extends StatelessWidget {
  const TimeSlotRow({
    super.key,
    required this.slot,
    required this.index,
    required this.onRemove,
    required this.onUpdate,
    required this.onSelectTime,
  });

  final TimeSlotModel slot;
  final int index;
  final ValueChanged<int> onRemove;
  final void Function(int, String, String) onUpdate;
  final Future<String?> Function(BuildContext, String) onSelectTime;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: TimeButton(
              time: slot.start,
              onTap: () async {
                final newTime = await onSelectTime(context, slot.start);
                if (newTime != null) {
                  onUpdate(index, 'start', newTime);
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              'to',
              style: TextStyle(
                color: Colors.grey[500],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: TimeButton(
              time: slot.end,
              onTap: () async {
                final newTime = await onSelectTime(context, slot.end);
                if (newTime != null) {
                  onUpdate(index, 'end', newTime);
                }
              },
            ),
          ),
          IconButton(
            onPressed: () => onRemove(index),
            icon: const Icon(Icons.delete_outline),
            color: Colors.red[500],
            style: IconButton.styleFrom(
              backgroundColor: Colors.red[50],
              padding: const EdgeInsets.all(8),
            ),
          ),
        ],
      ),
    );
  }
}
