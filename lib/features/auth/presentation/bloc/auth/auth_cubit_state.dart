part of 'auth_cubit.dart';

abstract class AuthState extends BaseState {
  const AuthState();
}

class AuthInitialState extends AuthState {
  const AuthInitialState();

  @override
  List<Object?> get props => [];
}

class AuthLoadingState extends AuthState {
  final bool isRefreshing;
  final String? operation; // e.g., "logout", "checkAuth"

  const AuthLoadingState({this.isRefreshing = false, this.operation});

  @override
  List<Object?> get props => [isRefreshing, operation];
}

class AuthSuccessState extends AuthState {
  final dynamic data;
  final String? operation;

  const AuthSuccessState({this.data, this.operation});

  @override
  List<Object?> get props => [data, operation];
}

class AuthFailureState extends AuthState {
  final List<String> errorMessages;
  final List<String> suggestions;
  final String? operation;

  const AuthFailureState({
    required this.errorMessages,
    this.suggestions = const [],
    this.operation,
  });

  @override
  List<Object?> get props => [errorMessages, suggestions, operation];
}

class LogoutLoadingState extends AuthLoadingState {
  const LogoutLoadingState({bool isRefreshing = false})
      : super(isRefreshing: isRefreshing, operation: 'logout');
}

class LogoutSuccessState extends AuthSuccessState {
  const LogoutSuccessState({dynamic data})
      : super(data: data, operation: 'logout');
}

class LogoutFailureState extends AuthFailureState {
  const LogoutFailureState({
    required List<String> errorMessages,
    List<String> suggestions = const [],
  }) : super(
          errorMessages: errorMessages,
          suggestions: suggestions,
          operation: 'logout',
        );
}
