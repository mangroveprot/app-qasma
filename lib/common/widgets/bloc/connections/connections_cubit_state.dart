part of 'connection_cubit.dart';

abstract class ConnectionCubitState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ConnectionOnline extends ConnectionCubitState {}

class ConnectionOffline extends ConnectionCubitState {}

class ConnectionChecking extends ConnectionCubitState {}
