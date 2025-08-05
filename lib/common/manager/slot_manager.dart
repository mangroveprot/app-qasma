class SlotManager {
  static List<String> formatSlotsForDropdown(Map<String, dynamic> slotsData) {
    final List<String> formattedSlots = [];

    if (slotsData.isEmpty) return formattedSlots;

    // Iterate through each date
    slotsData.forEach((date, timeSlots) {
      if (timeSlots is List) {
        final List<String> slots = List<String>.from(timeSlots);

        // Group consecutive time slots
        final groupedSlots = _groupConsecutiveSlots(slots);

        // Format each group with date
        for (final group in groupedSlots) {
          formattedSlots.add('$date | $group');
        }
      }
    });

    // Sort by date and time
    formattedSlots.sort((a, b) {
      final dateTimeA = _extractDateTime(a);
      final dateTimeB = _extractDateTime(b);
      return dateTimeA.compareTo(dateTimeB);
    });

    return formattedSlots;
  }

  static List<String> _groupConsecutiveSlots(List<String> slots) {
    if (slots.isEmpty) return [];

    final List<String> groupedSlots = [];
    String? currentStart;
    String? currentEnd;

    for (int i = 0; i < slots.length; i++) {
      final slot = slots[i];
      final parts = slot.split(' - ');
      if (parts.length != 2) continue;

      final startTime = parts[0];
      final endTime = parts[1];

      if (currentStart == null) {
        // Start new group
        currentStart = startTime;
        currentEnd = endTime;
      } else {
        // Check if this slot is consecutive with the previous one
        if (_areConsecutiveSlots(currentEnd!, startTime)) {
          // Extend current group
          currentEnd = endTime;
        } else {
          // Finish current group and start new one
          groupedSlots.add('$currentStart - $currentEnd');
          currentStart = startTime;
          currentEnd = endTime;
        }
      }
    }

    // Add the last group
    if (currentStart != null && currentEnd != null) {
      groupedSlots.add('$currentStart - $currentEnd');
    }

    return groupedSlots;
  }

  static bool _areConsecutiveSlots(String endTime, String startTime) {
    // Simple check - in real implementation, you might want more robust time parsing
    return endTime == startTime;
  }

  static DateTime _extractDateTime(String formattedSlot) {
    final parts = formattedSlot.split(' | ');
    if (parts.length != 2) return DateTime.now();

    final datePart = parts[0];
    final timePart = parts[1].split(' - ')[0];

    try {
      final date = DateTime.parse('${datePart}T${timePart}:00');
      return date;
    } catch (e) {
      return DateTime.now();
    }
  }

  // Extract selected date and time from formatted string
  static Map<String, String> parseSelectedSlot(String formattedSlot) {
    final parts = formattedSlot.split(' | ');
    if (parts.length != 2) {
      return {'date': '', 'time': ''};
    }

    return {
      'date': parts[0],
      'time': parts[1],
    };
  }
}
