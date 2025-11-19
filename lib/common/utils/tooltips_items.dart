class ToolTipsModel {
  final String key;
  final String tips;

  const ToolTipsModel({
    required this.key,
    required this.tips,
  });
}

class ToolTip {
  static const description = ToolTipsModel(
    key: 'Description',
    tips:
        'Please provide a short description to help us understand your situation better.',
  );

  static const remarks = ToolTipsModel(
    key: 'Reason for making this change',
    tips:
        'Please share a short reason for your update so we can better understand your needs.',
  );

  static const dateAndTime = ToolTipsModel(
    key: 'Date & Time',
    tips: 'Select your preferred date and time for the appointment.',
  );

  static const appointmentType = ToolTipsModel(
    key: 'Appointment Type',
    tips: 'Choose the appointment type that best suits your needs.',
  );

  static const buffer_time = ToolTipsModel(
    key: 'Buffer Time (minutes)',
    tips: 'Set the gap between bookings to allow for preparation.',
  );

  static const booking_lead_time = ToolTipsModel(
    key: 'Booking Lead Time (minutes)',
    tips:
        'Set how far in advance bookings can be made (e.g., 120 minutes = 2 hours).',
  );

  static const slot_days_range = ToolTipsModel(
    key: 'Slot Days Range',
    tips: 'Set how many days of booking slots to generate.',
  );

  static const available_schedule = ToolTipsModel(
    key: 'Available Schedule',
    tips: 'Working days and hours when appointments can be booked.',
  );

  static const category_types = ToolTipsModel(
    key: 'Category Types',
    tips:
        'Set up appointment categories and types. Add different appointment types with specific durations for each type. Use the + button to add new types and customize durations as needed.',
  );

  static const my_schedule = ToolTipsModel(
    key: 'My Schedule',
    tips: 'Unavailable times when counselor is not present for appointments.',
  );
}
