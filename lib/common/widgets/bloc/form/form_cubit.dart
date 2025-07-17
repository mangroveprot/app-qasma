import '../../../../core/_base/_bloc_cubit/base_cubit.dart';

part 'form_state.dart';

class FormCubit extends BaseCubit<FormValidationState> {
  FormCubit() : super(const FormValidationState());

  void updateError(String fieldName, bool hasError) {
    final newErrors = Map<String, bool>.from(state.fieldErrors)
      ..[fieldName] = hasError;
    emit(state.copyWith(fieldErrors: newErrors));
  }

  bool validateField(String fieldName, String value, {bool isRequired = true}) {
    final hasError = isRequired && value.trim().isEmpty;
    updateError(fieldName, hasError);
    return !hasError;
  }

  bool validateAll(
    Map<String, String> fieldValues, {
    List<String>? requiredFields,
  }) {
    bool isValid = true;
    final newErrors = <String, bool>{};

    for (final entry in fieldValues.entries) {
      final isRequired = requiredFields?.contains(entry.key) ?? true;
      final hasError = isRequired && entry.value.trim().isEmpty;
      newErrors[entry.key] = hasError;
      if (hasError) isValid = false;
    }

    emit(state.copyWith(fieldErrors: newErrors));
    return isValid;
  }

  bool hasError(String fieldName) => state.hasError(fieldName);

  void clearAll() {
    emit(const FormValidationState());
  }
}
