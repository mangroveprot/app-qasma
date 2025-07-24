part of 'form_cubit.dart';

class FormValidationState extends BaseState {
  final Map<String, bool> fieldErrors;
  final Map<String, String?> errorMessages;

  const FormValidationState({
    this.fieldErrors = const {},
    this.errorMessages = const {},
  });

  bool hasError(String fieldName) => fieldErrors[fieldName] == true;

  String? getErrorMessage(String fieldName) => errorMessages[fieldName];

  FormValidationState copyWith({
    Map<String, bool>? fieldErrors,
    Map<String, String?>? errorMessages,
  }) {
    return FormValidationState(
      fieldErrors: fieldErrors ?? this.fieldErrors,
      errorMessages: errorMessages ?? this.errorMessages,
    );
  }

  @override
  List<Object?> get props => [fieldErrors, errorMessages];
}
