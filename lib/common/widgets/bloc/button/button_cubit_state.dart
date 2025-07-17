part of 'button_cubit.dart';

abstract class ButtonState extends BaseState {}

class ButtonInitialState extends ButtonState {}

class ButtonLoadingState extends ButtonState {}

class ButtonSuccessState extends ButtonState {}

class ButtonFailureState extends ButtonState {
  final String errorMessage;
  final List<String> suggestions;

  ButtonFailureState({required this.errorMessage, this.suggestions = const []});

  @override
  List<Object?> get props => [errorMessage, suggestions];
}
