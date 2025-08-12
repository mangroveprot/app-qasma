part of 'button_cubit.dart';

abstract class ButtonState extends BaseState {}

class ButtonInitialState extends ButtonState {}

class ButtonLoadingState extends ButtonState {
  final String? buttonId;
  ButtonLoadingState([this.buttonId]);
}

class ButtonSuccessState extends ButtonState {
  final dynamic data;
  final String? buttonId;

  ButtonSuccessState([this.data, this.buttonId]);

  @override
  List<Object?> get props => [data, buttonId];
}

class ButtonFailureState extends ButtonState {
  final List<String> errorMessages;
  final List<String> suggestions;
  final String? buttonId;

  ButtonFailureState({
    this.suggestions = const [],
    required this.errorMessages,
    this.buttonId,
  });

  @override
  List<Object?> get props => [suggestions, errorMessages, buttonId];
}
