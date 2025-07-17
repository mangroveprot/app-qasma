class SyncField<T> {
  final String name;
  final DateTime? Function(T) accessor;

  SyncField({required this.name, required this.accessor});
}
