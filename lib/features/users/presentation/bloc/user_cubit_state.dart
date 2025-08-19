part of 'user_cubit.dart';

abstract class UserCubitState extends BaseState {}

class UserInitialState extends UserCubitState {}

class UserLoadingState extends UserCubitState {
  final bool isRefreshing;

  UserLoadingState({this.isRefreshing = false});

  @override
  List<Object?> get props => [isRefreshing];
}

class UserLoadedState extends UserCubitState {
  final List<UserModel> users;

  UserLoadedState(this.users);

  @override
  List<Object?> get props => [users];
}

class UserFailureState extends UserCubitState {
  final List<String> errorMessages;
  final List<String> suggestions;

  UserFailureState({
    this.suggestions = const [],
    required this.errorMessages,
  });

  @override
  List<Object?> get props => [suggestions, errorMessages];

  String get primaryError =>
      errorMessages.isNotEmpty ? errorMessages.first : 'Unknown error occurred';

  bool get hasMultipleErrors => errorMessages.length > 1;

  String get formattedMessage {
    if (errorMessages.length <= 1) {
      return primaryError;
    }
    return '${errorMessages.first}\n• ${errorMessages.skip(1).join('\n• ')}';
  }

  String get combinedMessage => errorMessages.join(', ');
}
