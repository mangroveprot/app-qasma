import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final List<dynamic>? suggestions;

  const Failure({required this.message, this.suggestions});

  @override
  List<Object?> get props => [message, suggestions];
}

class ServerFailure extends Failure {
  const ServerFailure({required super.message, super.suggestions});
}

class NetworkFailure extends Failure {
  const NetworkFailure({required super.message, super.suggestions});
}

class AuthenticationFailure extends Failure {
  const AuthenticationFailure({required super.message, super.suggestions});
}

class ValidationFailure extends Failure {
  const ValidationFailure({required super.message, super.suggestions});
}

class UnknownFailure extends Failure {
  const UnknownFailure({required super.message, super.suggestions});
}
