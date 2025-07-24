part of 'button_cubit.dart';

abstract class ButtonState extends BaseState {}

class ButtonInitialState extends ButtonState {}

class ButtonLoadingState extends ButtonState {}

class ButtonSuccessState extends ButtonState {
  final dynamic data;

  ButtonSuccessState([this.data]);

  @override
  List<Object?> get props => [data];
}

class ButtonFailureState extends ButtonState {
  final List<String> errorMessages;
  final List<String> suggestions;

  ButtonFailureState({
    this.suggestions = const [],
    required this.errorMessages,
  });

  @override
  List<Object?> get props => [suggestions, errorMessages];

  // // Helper getter to get all error messages
  // List<String> get allMessages {
  //   final result = [errorMessage];
  //   if (errorMessages != null && errorMessages!.isNotEmpty) {
  //     result.addAll(errorMessages!);
  //   }
  //   return result;
  // }

  // // Helper getter to get formatted error message
  // String get formattedMessage {
  //   if (errorMessages == null || errorMessages!.isEmpty) {
  //     return errorMessage;
  //   }
  //   return '$errorMessage\n• ${errorMessages!.join('\n• ')}';
  // }

  // // Helper getter to check if there are multiple messages
  // bool get hasMultipleMessages =>
  //     errorMessages != null && errorMessages!.isNotEmpty;

  // // Helper getter to get a simple combined message (comma separated)
  // String get combinedMessage {
  //   if (errorMessages == null || errorMessages!.isEmpty) {
  //     return errorMessage;
  //   }
  //   return '$errorMessage: ${errorMessages!.join(', ')}';
  // }
}
