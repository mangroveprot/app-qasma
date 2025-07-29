class TitleDescriptionItem {
  final String key;
  final String title;
  final String description;

  const TitleDescriptionItem({
    required this.key,
    required this.title,
    required this.description,
  });
}

class ContentItems {
  static const appointmentSelection = TitleDescriptionItem(
    key: 'new-appointment-selection',
    title: 'Category',
    description: 'Choose from the list of available services.',
  );
}
