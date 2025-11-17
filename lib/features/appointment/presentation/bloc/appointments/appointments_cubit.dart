import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';

import '../../../../../common/error/app_error.dart';
import '../../../../../core/_base/_bloc_cubit/base_cubit.dart';
import '../../../../../core/_usecase/usecase.dart';
import '../../../data/models/appointment_model.dart';

part 'appointments_cubit_state.dart';

class AppointmentsCubit extends BaseCubit<AppointmentCubitState> {
  final Logger _logger = Logger();

  AppointmentsCubit() : super(AppointmentsInitialState());

  @override
  void emitLoading({bool isRefreshing = false}) {
    if (!isClosed) {
      emit(AppointmentsLoadingState(isRefreshing: isRefreshing));
    }
  }

  @override
  void emitInitial({bool isRefreshing = false}) {
    if (!isClosed) {
      emit(AppointmentsInitialState());
    }
  }

  @override
  void emitError({
    String? message,
    List<String>? errorMessages,
    dynamic error,
    StackTrace? stackTrace,
    List<String>? suggestions,
  }) {
    if (isClosed) return;

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
    if (isClosed) {
      _logger.d('Cubit closed, skipping loadAppointments');
      return;
    }

    emitLoading(isRefreshing: isRefreshing);

    try {
      final Either result = await usecase.call(param: params);

      if (isClosed) {
        _logger.d('Cubit closed after usecase call');
        return;
      }

      result.fold(
        (error) {
          if (isClosed) {
            _logger.d('Cubit closed in fold error callback');
            return;
          }
          _logger.e('Failed to load appointments: $error');
          emitError(
            errorMessages: error.messages ?? ['Failed to load appointments'],
            suggestions: error.suggestions,
            error: error,
          );
        },
        (data) {
          if (isClosed) {
            _logger.d('Cubit closed in fold success callback');
            return;
          }
          final List<AppointmentModel> appointments =
              data as List<AppointmentModel>;
          _logger.i('Successfully loaded ${appointments.length} appointments');
          emit(AppointmentsLoadedState(appointments));
        },
      );
    } catch (e, stackTrace) {
      if (isClosed) {
        _logger.d('Cubit closed in catch block');
        return;
      }
      _logger.e('Error loading appointments: $e\n$stackTrace');
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
    if (isClosed) return;
    _logger.d('Loading appointments by status: $status');
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
    if (isClosed) return;
    _logger.d('Loading appointments from $startDate to $endDate');
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
    if (isClosed) return;
    _logger.d('Refreshing appointments');
    await loadAppointments(
      params: params,
      usecase: usecase,
      isRefreshing: true,
    );
  }

  // Filter appointments locally by status
  void filterByStatus(String status) {
    if (isClosed) return;

    if (state is AppointmentsLoadedState) {
      final currentState = state as AppointmentsLoadedState;
      final filteredAppointments = currentState.allAppointments
          .where((appointment) =>
              appointment.status.toLowerCase() == status.toLowerCase())
          .toList();

      if (isClosed) return;

      _logger.d(
          'Filtered appointments by status: $status (${filteredAppointments.length} results)');
      emit(AppointmentsLoadedState(
        filteredAppointments,
        allAppointments: currentState.allAppointments,
      ));
    }
  }

  // Clear filters and show all appointments
  void clearFilters() {
    if (isClosed) return;

    if (state is AppointmentsLoadedState) {
      final currentState = state as AppointmentsLoadedState;
      if (currentState.allAppointments.isNotEmpty) {
        if (isClosed) return;
        _logger.d(
            'Cleared all filters, showing all ${currentState.allAppointments.length} appointments');
        emit(AppointmentsLoadedState(currentState.allAppointments));
      }
    }
  }

  // Search appointments by description or category
  void searchAppointments(String query) {
    if (isClosed) return;

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

      if (isClosed) return;

      _logger.d('Search for "$query" returned ${searchResults.length} results');
      emit(AppointmentsLoadedState(
        searchResults,
        allAppointments: currentState.allAppointments,
      ));
    }
  }

  @override
  Future<void> close() {
    _logger.d('Closing AppointmentsCubit');
    return super.close();
  }
}
