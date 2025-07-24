part of 'base_cubit.dart';

abstract class BaseState extends Equatable {
  const BaseState();

  @override
  List<Object?> get props => [];
}

class InitialState extends BaseState {
  const InitialState();
}

class LoadingState extends BaseState {
  final bool isRefreshing;

  const LoadingState({this.isRefreshing = false});

  @override
  List<Object?> get props => [isRefreshing];
}

class ErrorState extends BaseState {
  final String? message;
  final List<String>? errorMessages;
  final dynamic error;
  final StackTrace? stackTrace;

  const ErrorState({
    this.message,
    this.errorMessages,
    this.error,
    this.stackTrace,
  });

  @override
  List<Object?> get props => [message, error, stackTrace];
}
