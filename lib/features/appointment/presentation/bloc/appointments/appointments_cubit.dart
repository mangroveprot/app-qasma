import 'package:dartz/dartz.dart';

import '../../../../../common/error/app_error.dart';
import '../../../../../core/_base/_bloc_cubit/base_cubit.dart';
import '../../../../../core/_usecase/usecase.dart';
import '../../../data/models/appointment_model.dart';

part 'appointments_cubit_state.dart';

class AppointmentsCubit extends BaseCubit<AppointmentCubitState> {
  AppointmentsCubit() : super(AppointmentsInitialState());

  @override
  void emitLoading({bool isRefreshing = false}) {
    emit(AppointmentsLoadingState(isRefreshing: isRefreshing));
  }

  @override
  void emitInitial({bool isRefreshing = false}) {
    emit(AppointmentsInitialState());
  }

  @override
  void emitError({
    String? message,
    List<String>? errorMessages,
    dynamic error,
    StackTrace? stackTrace,
    List<String>? suggestions,
  }) {
    final List<String> finalSuggestions =
        error is AppError ? error.suggestions ?? [] : [];

    final List<String> finalErrorMessages = errorMessages ??
        (error is AppError
            ? error.allMessages
            : [message ?? 'Failed to load appointments']);

    emit(
      AppointmentsFailureState(
        errorMessages: finalErrorMessages,
        suggestions: finalSuggestions,
      ),
    );
  }

  // Load all appointments
  Future<void> loadAppointments({
    dynamic params,
    required Usecase usecase,
    bool isRefreshing = false,
  }) async {
    emitLoading(isRefreshing: isRefreshing);

    try {
      final Either result = await usecase.call(param: params);

      result.fold(
        (error) {
          emitError(
            errorMessages: error.messages ?? ['Failed to load appointments'],
            suggestions: error.suggestions,
            error: error,
          );
        },
        (data) {
          final List<AppointmentModel> appointments =
              data as List<AppointmentModel>;
          emit(AppointmentsLoadedState(appointments));
        },
      );
    } catch (e, stackTrace) {
      emitError(
        errorMessages: ['Failed to load appointments: ${e.toString()}'],
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  // Load appointments by status
  Future<void> loadAppointmentsByStatus({
    required String status,
    required Usecase usecase,
    bool isRefreshing = false,
  }) async {
    await loadAppointments(
      params: {'status': status},
      usecase: usecase,
      isRefreshing: isRefreshing,
    );
  }

  // Load appointments by date range
  Future<void> loadAppointmentsByDateRange({
    required DateTime startDate,
    required DateTime endDate,
    required Usecase usecase,
    bool isRefreshing = false,
  }) async {
    await loadAppointments(
      params: {
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
      },
      usecase: usecase,
      isRefreshing: isRefreshing,
    );
  }

  // Refresh appointments
  Future<void> refreshAppointments({
    dynamic params,
    required Usecase usecase,
  }) async {
    await loadAppointments(
      params: params,
      usecase: usecase,
      isRefreshing: true,
    );
  }

  // Filter appointments locally by status
  void filterByStatus(String status) {
    if (state is AppointmentsLoadedState) {
      final currentState = state as AppointmentsLoadedState;
      final filteredAppointments = currentState.allAppointments
          .where((appointment) =>
              appointment.status.toLowerCase() == status.toLowerCase())
          .toList();

      emit(AppointmentsLoadedState(
        filteredAppointments,
        allAppointments: currentState.allAppointments,
      ));
    }
  }

  // Clear filters and show all appointments
  void clearFilters() {
    if (state is AppointmentsLoadedState) {
      final currentState = state as AppointmentsLoadedState;
      if (currentState.allAppointments.isNotEmpty) {
        emit(AppointmentsLoadedState(currentState.allAppointments));
      }
    }
  }

  // Search appointments by description or category
  void searchAppointments(String query) {
    if (state is AppointmentsLoadedState) {
      final currentState = state as AppointmentsLoadedState;
      final searchResults = currentState.allAppointments
          .where((appointment) =>
              appointment.description
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              appointment.appointmentCategory
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              appointment.appointmentType
                  .toLowerCase()
                  .contains(query.toLowerCase()))
          .toList();

      emit(AppointmentsLoadedState(
        searchResults,
        allAppointments: currentState.allAppointments,
      ));
    }
  }
}
