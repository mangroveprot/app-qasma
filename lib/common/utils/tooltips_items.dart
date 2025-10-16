class ToolTip {
  final String tips;

  const ToolTip({
    required this.tips,
  });
}

class ToolTips {
  static const buffer_time =
      ToolTip(tips: 'Gap time between bookings for preparation.');

  static const booking_lead_time = ToolTip(
      tips:
          'Block bookings within X minutes from now (e.g., 120 min = 2 hours ahead).');

  static const slot_days_range =
      ToolTip(tips: 'How many days of slots to generate.');

  static const available_schedule =
      ToolTip(tips: 'Working days and hours when appointments can be booked.');

  static const category_types = ToolTip(
    tips:
        'Set up appointment categories and types. Add different appointment types with specific durations for each type. Use the + button to add new types and customize durations as needed.',
  );

  static const my_schedule = ToolTip(
      tips:
          'Unavailable times when counselor is not present for appointments.');
}
