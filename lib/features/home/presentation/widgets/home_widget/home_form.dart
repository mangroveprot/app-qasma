import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../common/helpers/spacing.dart';
import '../../../../appointment/data/models/appointment_model.dart';

import '../../../../appointment/presentation/bloc/appointments/appointments_cubit.dart';
import '../../../../appointment/presentation/pages/book_appointment_page.dart';
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

  List<AppointmentModel>? _cachedFilteredAppointments;
  AppointmentsLoadedState? _lastProcessedState;

  List<AppointmentModel> _getFilteredAppointments(
      AppointmentsLoadedState state) {
    if (_lastProcessedState != state) {
      _cachedFilteredAppointments = state.appointments.where((appointment) {
        final status = appointment.status.toLowerCase();
        return status == 'pending' || status == 'approved';
      }).toList();
      _lastProcessedState = state;
    }
    return _cachedFilteredAppointments!;
  }

  Future<void> _onRefresh() async {
    if (_isRefreshing || _shouldThrottle) return;

    setState(() => _isRefreshing = true);

    try {
      await widget.state.controller.appoitnmentRefreshData();
      await widget.state.controller.appointConfigRefreshData();
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
            return const _LoadingContent();
          }

          if (state is AppointmentsLoadedState) {
            return _LoadedContent(
              key: ValueKey(state.appointments.length),
              appointments: _getFilteredAppointments(state),
              onRefresh: _onRefresh,
              onCancel: (id) =>
                  widget.state.controller.handleCancelAppointment(id, context),
              onReschedule: widget.state.controller.handleRescheduleAppointment,
            );
          }

          if (state is AppointmentsFailureState) {
            return _ErrorContent(
              error: state.primaryError,
              onRefresh: _onRefresh,
              onRetry: widget.state.controller.appoitnmentRefreshData,
              isRefreshing: _isRefreshing,
            );
          }

          return _EmptyContent(onRefresh: _onRefresh);
        },
      ),
    );
  }
}

// stateless widgets to prevent unnecessary rebuilds, !!! maybe break down this to different files !!!!
class _LoadingContent extends StatelessWidget {
  const _LoadingContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

class _LoadedContent extends StatelessWidget {
  final List<AppointmentModel> appointments;
  final Future<void> Function() onRefresh;
  final void Function(String) onCancel;
  final void Function(String) onReschedule;

  const _LoadedContent({
    Key? key,
    required this.appointments,
    required this.onRefresh,
    required this.onCancel,
    required this.onReschedule,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          child: const Text('Go to Second Page'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const BookAppointmentPage()),
            );
            // context.go(Routes.buildPath(Routes.aut_path, Routes.otp_verification));
          },
        ),
        const HomeGreetingCard(),
        Spacing.verticalSmall,
        Expanded(
          child: appointments.isEmpty
              ? _EmptyContent(onRefresh: onRefresh)
              : RefreshIndicator(
                  onRefresh: onRefresh,
                  child: HomeAppointmentList(
                    appointments: appointments,
                    onCancel: onCancel,
                    onReschedule: onReschedule,
                  ),
                ),
        ),
      ],
    );
  }
}

class _ErrorContent extends StatelessWidget {
  final String error;
  final Future<void> Function() onRefresh;
  final VoidCallback onRetry;
  final bool isRefreshing;

  const _ErrorContent({
    Key? key,
    required this.error,
    required this.onRefresh,
    required this.onRetry,
    required this.isRefreshing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const HomeGreetingCard(),
        Spacing.verticalSmall,
        Expanded(
          child: RefreshIndicator(
            onRefresh: onRefresh,
            child: _ScrollableContent(
              icon: Icons.error_outline,
              title: 'Failed to load appointments',
              subtitle: error,
              action: ElevatedButton(
                onPressed: isRefreshing ? null : onRetry,
                child: isRefreshing
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Retry'),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _EmptyContent extends StatelessWidget {
  final Future<void> Function() onRefresh;

  const _EmptyContent({
    Key? key,
    required this.onRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: const _ScrollableContent(
        icon: Icons.calendar_today_outlined,
        title: 'No appointments to display',
        subtitle: 'Pull down to refresh',
      ),
    );
  }
}

class _ScrollableContent extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? action;

  const _ScrollableContent({
    Key? key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 48, color: Colors.grey),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey,
                      ),
                  textAlign: TextAlign.center,
                ),
                if (action != null) ...[
                  const SizedBox(height: 16),
                  action!,
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
