import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../common/utils/constant.dart';
import '../../../../appointment/data/models/appointment_model.dart';
import '../../../../appointment/presentation/bloc/appointments/appointments_cubit.dart';
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

  List<AppointmentModel>? _cachedFilteredAppointments;
  AppointmentsLoadedState? _lastProcessedState;

  static final String _approvedStatus = StatusType.approved.field;
  static final String _pendingStatus = StatusType.pending.field;

  @override
  void initState() {
    super.initState();
  }

  List<AppointmentModel> _getFilteredAppointments(
      AppointmentsLoadedState state) {
    if (_lastProcessedState != state) {
      _cachedFilteredAppointments = state.appointments.where((appointment) {
        final status = appointment.status.toLowerCase();
        return status == _approvedStatus || status == _pendingStatus;
      }).toList();
      _lastProcessedState = state;
    }

    _cachedFilteredAppointments!.sort(
      (a, b) =>
          widget.state.controller.appointmentManager.compareAppointments(a, b),
    );

    return _cachedFilteredAppointments!;
  }

  Future<void> _onRefresh() async {
    if (_isRefreshing || _shouldThrottle) return;

    setState(() => _isRefreshing = true);

    try {
      await Future.wait([
        widget.state.controller.appoitnmentRefreshData(),
        widget.state.controller.appointConfigRefreshData(),
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
      child: BlocBuilder<AppointmentsCubit, AppointmentCubitState>(
        buildWhen: (previous, current) {
          return previous.runtimeType != current.runtimeType ||
              previous is AppointmentsLoadingState ||
              current is AppointmentsLoadingState;
        },
        builder: (context, state) {
          if (state is AppointmentsLoadingState) {
            return const LoadingContent();
          }

          if (state is AppointmentsLoadedState) {
            return LoadedContent(
              key: ValueKey(state.appointments.length),
              state: widget.state,
              appointments: _getFilteredAppointments(state),
              onRefresh: _onRefresh,
              onCancel: (id) =>
                  widget.state.controller.handleCancelAppointment(id, context),
              onReschedule: widget.state.controller.handleRescheduleAppointment,
              userName: widget.firstName,
            );
          }

          if (state is AppointmentsFailureState) {
            return ErrorContent(
              userName: widget.firstName,
              error: state.primaryError,
              onRefresh: _onRefresh,
              onRetry: widget.state.controller.appoitnmentRefreshData,
              isRefreshing: _isRefreshing,
            );
          }

          return EmptyContent(onRefresh: _onRefresh);
        },
      ),
    );
  }
}
