import '../../../../core/_base/_bloc_cubit/base_cubit.dart';

part 'form_state.dart';

class FormCubit extends BaseCubit<FormValidationState> {
  FormCubit() : super(const FormValidationState());

  void updateError(String fieldName, bool hasError, [String? errorMessage]) {
    final newErrors = Map<String, bool>.from(state.fieldErrors)
      ..[fieldName] = hasError;

    final newErrorMessages = Map<String, String?>.from(state.errorMessages);
    if (hasError && errorMessage != null) {
      newErrorMessages[fieldName] = errorMessage;
    } else if (!hasError) {
      newErrorMessages.remove(fieldName);
    }

    emit(
      state.copyWith(fieldErrors: newErrors, errorMessages: newErrorMessages),
    );
  }

  bool validateField(
    String fieldName,
    String value, {
    bool isRequired = true,
    String? customErrorMessage,
  }) {
    final hasError = isRequired && value.trim().isEmpty;
    updateError(fieldName, hasError, customErrorMessage);
    return !hasError;
  }

  bool validateAll(
    Map<String, String> fieldValues, {
    List<String>? optionalFields,
    Map<String, String>? customErrorMessages,
  }) {
    bool isValid = true;
    final newErrors = <String, bool>{};
    final newErrorMessages = <String, String?>{};

    for (final entry in fieldValues.entries) {
      final isOptional = optionalFields?.contains(entry.key) ?? false;
      final hasError = !isOptional && entry.value.trim().isEmpty;
      newErrors[entry.key] = hasError;

      if (hasError) {
        isValid = false;
        final customMessage = customErrorMessages?[entry.key];
        if (customMessage != null) {
          newErrorMessages[entry.key] = customMessage;
        }
      }
    }

    emit(
      state.copyWith(fieldErrors: newErrors, errorMessages: newErrorMessages),
    );
    return isValid;
  }

  void setFieldError(String fieldName, String errorMessage) {
    updateError(fieldName, true, errorMessage);
  }

  void clearFieldError(String fieldName) {
    updateError(fieldName, false);
  }

  bool hasError(String fieldName) => state.hasError(fieldName);

  String? getErrorMessage(String fieldName) => state.getErrorMessage(fieldName);

  void clearAll() {
    emit(const FormValidationState());
  }
}
