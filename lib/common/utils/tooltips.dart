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
    key: 'Appoinmment Type',
    tips: 'Choose the appointment type that best suits your needs',
  );
}
