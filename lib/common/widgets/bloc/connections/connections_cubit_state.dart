part of 'connection_cubit.dart';

abstract class ConnectionCubitState {}

class ConnectionOnline extends ConnectionCubitState {}

class ConnectionOffline extends ConnectionCubitState {}

class ConnectionChecking extends ConnectionCubitState {}
