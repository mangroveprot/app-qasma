part of 'button_cubit.dart';

abstract class ButtonState extends BaseState {}

class ButtonInitialState extends ButtonState {}

class ButtonLoadingState extends ButtonState {}

class ButtonSuccessState extends ButtonState {}

class ButtonFailureState extends ButtonState {
  final String errorMessage;

  ButtonFailureState({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}
