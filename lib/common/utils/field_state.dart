class FieldState {
  final bool hasError;
  final String? errorMessage;

  const FieldState({
    required this.hasError,
    this.errorMessage,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FieldState &&
          runtimeType == other.runtimeType &&
          hasError == other.hasError &&
          errorMessage == other.errorMessage;

  @override
  int get hashCode => hasError.hashCode ^ errorMessage.hashCode;
}
