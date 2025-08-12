import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../common/helpers/spacing.dart';
import '../../../../../theme/theme_extensions.dart';
import '../../../../appointment/data/models/appointment_model.dart';

import '../../../../appointment/presentation/bloc/appointments/appointments_cubit.dart';
import '../../pages/home_page.dart';
import 'home_appointment_list.dart';
import 'home_greeting.dart';

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
              userName: widget.firstName,
            );
          }

          if (state is AppointmentsFailureState) {
            return _ErrorContent(
              userName: widget.firstName,
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
  final String userName;
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
    required this.userName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ElevatedButton(
        //     child: const Text('Go to Second Page'),
        //     onPressed: () {
        //       Navigator.push(
        //         context,
        //         MaterialPageRoute(builder: (context) => const MyProfilePage()),
        //       );
        //     }),
        HomeGreetingCard(
          userName: userName,
        ),
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
  final String userName;
  final Future<void> Function() onRefresh;
  final VoidCallback onRetry;
  final bool isRefreshing;

  const _ErrorContent({
    Key? key,
    required this.error,
    required this.onRefresh,
    required this.onRetry,
    required this.isRefreshing,
    required this.userName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
    final colors = context.colors;

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(24),
        children: [
          const SizedBox(height: 60),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: colors.textPrimary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.calendar_today_outlined,
              size: 58,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'No appointments yet',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
            textAlign: TextAlign.center,
          ),
          Spacing.verticalMedium,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Tap the ',
                style: TextStyle(color: colors.textPrimary),
              ),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: colors.textPrimary,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.add,
                  color: colors.white,
                  size: 14,
                ),
              ),
              Text(
                ' button to book an appointment',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
            ],
          ),
        ],
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
    final colors = context.colors;
    final fontWeight = context.weight;
    return LayoutBuilder(
      builder: (context, constraints) {
        return ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(
              height: constraints.maxHeight,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        icon,
                        size: 64,
                        color: colors.textPrimary,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        title,
                        style: TextStyle(
                          color: colors.black.withOpacity(0.8),
                          fontWeight: fontWeight.bold,
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: colors.textPrimary,
                            ),
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (action != null) ...[
                        const SizedBox(height: 24),
                        action!,
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
