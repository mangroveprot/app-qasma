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
  final UserModel user;

  UserLoadedState(this.user);

  @override
  List<Object?> get props => [user];

  // Helper getters
  String get fullName => user.fullName;
  bool get isVerified => user.verified;
  bool get isActive => user.active;
  bool get canPerformActions => user.canPerformActions;
  String get role => user.role;
  String get email => user.email;
  String get idNumber => user.idNumber;
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

  // Helper getter to get the first error message
  String get primaryError =>
      errorMessages.isNotEmpty ? errorMessages.first : 'Unknown error occurred';

  // Helper getter to check if there are multiple errors
  bool get hasMultipleErrors => errorMessages.length > 1;

  // Helper getter to get formatted error message
  String get formattedMessage {
    if (errorMessages.length <= 1) {
      return primaryError;
    }
    return '${errorMessages.first}\n• ${errorMessages.skip(1).join('\n• ')}';
  }

  // Helper getter to get combined error message
  String get combinedMessage => errorMessages.join(', ');
}
