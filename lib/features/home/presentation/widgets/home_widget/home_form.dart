import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../common/utils/constant.dart';
import '../../../../appointment/data/models/appointment_model.dart';
import '../../../../appointment/presentation/bloc/appointments/appointments_cubit.dart';
import '../../../../users/data/models/user_model.dart';
import '../../../../users/presentation/bloc/user_cubit.dart';
import '../../pages/home_page.dart';
import 'home_content.dart';

class HomeForm extends StatefulWidget {
  final HomePageState state;
  final String firstName;

  const HomeForm({super.key, required this.state, required this.firstName});

  @override
  State<HomeForm> createState() => _HomeFormState();
}

class _HomeFormState extends State<HomeForm> {
  DateTime? _lastRefreshTime;
  bool _isRefreshing = false;
  static const Duration _refreshCooldown = Duration(seconds: 30);

  static const int _maxRetryAttempts = 3;
  static const Duration _retryDelay = Duration(seconds: 3);
  int _appointmentRetryCount = 0;
  int _userRetryCount = 0;
  bool _isRetrying = false;

  List<AppointmentModel>? _cachedFilteredAppointments;
  AppointmentsLoadedState? _lastProcessedAppointmentState;

  List<UserModel> _cachedUsers = [];
  List<UserModel>? _lastRawUsers;

  static final String _approvedStatus = StatusType.approved.field;
  static final String _pendingStatus = StatusType.pending.field;

  @override
  void initState() {
    super.initState();
  }

  List<AppointmentModel> _getFilteredAppointments(
      AppointmentsLoadedState state) {
    if (_lastProcessedAppointmentState != state) {
      _cachedFilteredAppointments = state.appointments.where((appointment) {
        final status = appointment.status.toLowerCase();
        return status == _approvedStatus || status == _pendingStatus;
      }).toList();
      _lastProcessedAppointmentState = state;
    }

    _cachedFilteredAppointments!.sort(
      (a, b) =>
          widget.state.controller.appointmentManager.compareAppointments(a, b),
    );

    return _cachedFilteredAppointments!;
  }

  void _processUsers(UserLoadedState state) {
    if (identical(_lastRawUsers, state.users)) return;

    _cachedUsers = List.from(state.users);
    _lastRawUsers = state.users;
  }

  Future<void> _retryAppointmentLoad() async {
    if (_isRetrying || _appointmentRetryCount >= _maxRetryAttempts) return;

    _appointmentRetryCount++;
    setState(() => _isRetrying = true);

    await Future.delayed(_retryDelay);

    try {
      await widget.state.controller.appoitnmentRefreshData();
    } catch (e) {
    } finally {
      if (mounted) setState(() => _isRetrying = false);
    }
  }

  Future<void> _retryUserLoad() async {
    if (_isRetrying || _userRetryCount >= _maxRetryAttempts) return;

    _userRetryCount++;
    setState(() => _isRetrying = true);

    await Future.delayed(_retryDelay);

    try {
      await widget.state.controller.userRefreshData();
    } catch (e) {
    } finally {
      if (mounted) setState(() => _isRetrying = false);
    }
  }

  void _resetRetryCounters() {
    _appointmentRetryCount = 0;
    _userRetryCount = 0;
  }

  Future<void> _onRefresh() async {
    if (_isRefreshing || _shouldThrottle) return;

    setState(() => _isRefreshing = true);
    _resetRetryCounters();

    try {
      await Future.wait([
        widget.state.controller.appoitnmentRefreshData(),
        widget.state.controller.appointConfigRefreshData(),
        widget.state.controller.userRefreshData(),
        widget.state.controller.notificationsRefreshData(),
      ]);
      _lastRefreshTime = DateTime.now();
    } finally {
      if (mounted) setState(() => _isRefreshing = false);
    }
  }

  bool get _shouldThrottle {
    return _lastRefreshTime != null &&
        DateTime.now().difference(_lastRefreshTime!) < _refreshCooldown;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: BlocBuilder<UserCubit, UserCubitState>(
        builder: (context, userState) {
          if (userState is UserLoadedState) {
            _userRetryCount = 0;
            _processUsers(userState);
          }

          if (userState is UserFailureState &&
              _userRetryCount < _maxRetryAttempts &&
              !_isRetrying) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _retryUserLoad();
            });
            return const LoadingContent();
          }

          return BlocBuilder<AppointmentsCubit, AppointmentCubitState>(
            buildWhen: (previous, current) {
              return previous.runtimeType != current.runtimeType ||
                  previous is AppointmentsLoadingState ||
                  current is AppointmentsLoadingState;
            },
            builder: (context, appointmentState) {
              if (appointmentState is AppointmentsLoadingState ||
                  userState is UserLoadingState) {
                return const LoadingContent();
              }

              if (appointmentState is AppointmentsLoadedState) {
                _appointmentRetryCount = 0;
              }

              if (appointmentState is AppointmentsFailureState &&
                  _appointmentRetryCount < _maxRetryAttempts &&
                  !_isRetrying) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _retryAppointmentLoad();
                });
                return const LoadingContent();
              }

              if (userState is UserFailureState &&
                  _userRetryCount >= _maxRetryAttempts &&
                  !_isRetrying) {
                return ErrorContent(
                  userName: widget.firstName,
                  error: userState.primaryError,
                  onRefresh: _onRefresh,
                  onRetry: () async {
                    _resetRetryCounters();
                    await widget.state.controller.userRefreshData();
                  },
                  isRefreshing: _isRefreshing,
                );
              }

              if (appointmentState is AppointmentsLoadedState) {
                return LoadedContent(
                  key: ValueKey(appointmentState.appointments.length),
                  state: widget.state,
                  appointments: _getFilteredAppointments(appointmentState),
                  users: _cachedUsers,
                  onRefresh: _onRefresh,
                  onCancel: (id) => widget.state.controller
                      .handleCancelAppointment(id, context),
                  onReschedule:
                      widget.state.controller.handleRescheduleAppointment,
                  userName: widget.firstName,
                );
              }

              // Show appointment error only after retry attempts exhausted
              if (appointmentState is AppointmentsFailureState &&
                  _appointmentRetryCount >= _maxRetryAttempts) {
                return ErrorContent(
                  userName: widget.firstName,
                  error: appointmentState.primaryError,
                  onRefresh: _onRefresh,
                  onRetry: () async {
                    _resetRetryCounters();
                    await widget.state.controller.appoitnmentRefreshData();
                  },
                  isRefreshing: _isRefreshing,
                );
              }

              return EmptyContent(onRefresh: _onRefresh);
            },
          );
        },
      ),
    );
  }
}
