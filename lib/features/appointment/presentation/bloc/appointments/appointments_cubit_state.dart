part of 'appointments_cubit.dart';

abstract class AppointmentCubitState extends BaseState {}

class AppointmentsInitialState extends AppointmentCubitState {}

class AppointmentsLoadingState extends AppointmentCubitState {
  final bool isRefreshing;

  AppointmentsLoadingState({this.isRefreshing = false});

  @override
  List<Object?> get props => [isRefreshing];
}

class AppointmentsLoadedState extends AppointmentCubitState {
  final List<AppointmentModel> appointments;
  final List<AppointmentModel> allAppointments;

  AppointmentsLoadedState(
    this.appointments, {
    List<AppointmentModel>? allAppointments,
  }) : allAppointments = allAppointments ?? appointments;

  @override
  List<Object?> get props => [appointments, allAppointments];

  // Helper getters
  bool get isEmpty => appointments.isEmpty;
  bool get isNotEmpty => appointments.isNotEmpty;
  int get count => appointments.length;

  // Get appointments by status
  List<AppointmentModel> getByStatus(String status) {
    return appointments
        .where((appointment) =>
            appointment.status.toLowerCase() == status.toLowerCase())
        .toList();
  }

  // Get upcoming appointments
  List<AppointmentModel> get upcomingAppointments {
    final now = DateTime.now();
    return appointments
        .where((appointment) =>
            appointment.scheduledStartAt.isAfter(now) &&
            appointment.status.toLowerCase() != 'cancelled')
        .toList();
  }

  // Get past appointments
  List<AppointmentModel> get pastAppointments {
    final now = DateTime.now();
    return appointments
        .where((appointment) => appointment.scheduledStartAt.isBefore(now))
        .toList();
  }

  // Get appointments by category
  List<AppointmentModel> getByCategory(String category) {
    return appointments
        .where((appointment) =>
            appointment.appointmentCategory.toLowerCase() ==
            category.toLowerCase())
        .toList();
  }
}

class AppointmentsFailureState extends AppointmentCubitState {
  final List<String> errorMessages;
  final List<String> suggestions;

  AppointmentsFailureState({
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
