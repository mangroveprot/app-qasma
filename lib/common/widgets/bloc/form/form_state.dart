part of 'form_cubit.dart';

class FormValidationState extends BaseState {
  final Map<String, bool> fieldErrors;

  const FormValidationState({this.fieldErrors = const {}});

  FormValidationState copyWith({Map<String, bool>? fieldErrors}) {
    return FormValidationState(fieldErrors: fieldErrors ?? this.fieldErrors);
  }

  bool hasError(String fieldName) => fieldErrors[fieldName] == true;

  @override
  List<Object?> get props => [fieldErrors];
}
