part of 'appointment_config_cubit.dart';

abstract class AppointmentConfigCubitState extends BaseState {}

class AppointmentConfigInitialState extends AppointmentConfigCubitState {}

class AppointmentConfigLoadingState extends AppointmentConfigCubitState {
  final bool isRefreshing;

  AppointmentConfigLoadingState({this.isRefreshing = false});

  @override
  List<Object?> get props => [isRefreshing];
}

class AppointmentConfigLoadedState extends AppointmentConfigCubitState {
  final AppointmentConfigModel config;

  AppointmentConfigLoadedState(this.config);

  @override
  List<Object?> get props => [config];
}

class AppointmentConfigFailureState extends AppointmentConfigCubitState {
  final List<String> errorMessages;
  final List<String> suggestions;

  AppointmentConfigFailureState({
    this.suggestions = const [],
    required this.errorMessages,
  });

  @override
  List<Object?> get props => [errorMessages, suggestions];

  String get primaryError =>
      errorMessages.isNotEmpty ? errorMessages.first : 'Unknown error occurred';

  String get formattedMessage {
    if (errorMessages.length <= 1) return primaryError;
    return '${errorMessages.first}\n• ${errorMessages.skip(1).join('\n• ')}';
  }
}
