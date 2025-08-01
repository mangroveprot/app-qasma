import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../common/helpers/spacing.dart';
import '../../../../../common/widgets/toast/custom_toast.dart';
import '../../../../../common/widgets/toast/toast_enums.dart';
import '../../../../appointment/data/models/appointment_model.dart';
import '../../../../appointment/presentation/bloc/appointments_cubit.dart';

import '../../pages/home_page.dart';
import 'home_appointment_list.dart';
import 'home_greeting.dart';

class HomeForm extends StatefulWidget {
  final HomePageState state;

  const HomeForm({super.key, required this.state});

  @override
  State<HomeForm> createState() => _HomeFormState();
}

class _HomeFormState extends State<HomeForm> {
  DateTime? _lastRefreshTime;
  bool _isRefreshing = false;
  static const Duration _refreshCooldown = Duration(seconds: 30);

  List<AppointmentModel> _getFilteredAppointments(
      List<AppointmentModel> appointments) {
    return appointments.where((appointment) {
      final status = appointment.status.toLowerCase();
      return status == 'pending' || status == 'approved';
    }).toList();
  }

  Future<void> _onRefresh() async {
    final now = DateTime.now();

    if (_isRefreshing) {
      return;
    }

    if (_lastRefreshTime != null &&
        now.difference(_lastRefreshTime!) < _refreshCooldown) {
      if (mounted) {
        CustomToast.info(
            position: ToastPosition.topRight,
            context: context,
            message:
                'Please wait ${_refreshCooldown.inSeconds - now.difference(_lastRefreshTime!).inSeconds} seconds before refreshing again');
      }
      return;
    }

    setState(() {
      _isRefreshing = true;
    });

    try {
      await widget.state.controller.refreshData();
      _lastRefreshTime = now;
    } finally {
      if (mounted) {
        setState(() {
          _isRefreshing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const HomeGreetingCard(),
          Spacing.verticalSmall,
          Expanded(
            child: RepaintBoundary(
              child: BlocBuilder<AppointmentsCubit, AppointmentCubitState>(
                builder: (context, appointmentState) {
                  if (appointmentState is AppointmentsLoadingState) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (appointmentState is AppointmentsLoadedState) {
                    final filteredAppointments = _getFilteredAppointments(
                      appointmentState.appointments,
                    );

                    return RefreshIndicator(
                      onRefresh: _onRefresh,
                      child: filteredAppointments.isEmpty
                          ? _buildEmptyState()
                          : HomeAppointmentList(
                              appointments: filteredAppointments,
                              onCancel: (appointmentId) => widget
                                  .state.controller
                                  .handleCancelAppointment(
                                      appointmentId, context),
                              onReschedule: (appointmentId) => widget
                                  .state.controller
                                  .handleRescheduleAppointment(appointmentId),
                            ),
                    );
                  }

                  if (appointmentState is AppointmentsFailureState) {
                    return _buildErrorState(appointmentState);
                  }

                  // Initial state
                  return _buildEmptyState();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.calendar_today_outlined,
                    size: 48,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  const Text('No appointments to display'),
                  const SizedBox(height: 8),
                  const Text(
                    'Pull down to refresh',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(AppointmentsFailureState appointmentState) {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 48,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Failed to load appointments',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    appointmentState.primaryError,
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _isRefreshing
                        ? null
                        : () => widget.state.controller.refreshData(),
                    child: _isRefreshing
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
