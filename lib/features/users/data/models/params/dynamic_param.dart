class DynamicParam {
  final Map<String, dynamic> fields;

  DynamicParam({required this.fields});

  Map<String, dynamic> toJson() => fields;
}
