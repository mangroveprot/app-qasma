import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../common/widgets/custom_filter_bar.dart';
import '../../../../../theme/theme_extensions.dart';
import '../../../data/models/appointment_model.dart';
import '../../bloc/appointments/appointments_cubit.dart';
import '../../pages/appointment_history_page.dart';
import '../../utils/history_utils.dart';
import 'history_card.dart';

class HistoryForm extends StatefulWidget {
  final AppointmentHistoryState state;
  const HistoryForm({super.key, required this.state});

  @override
  State<HistoryForm> createState() => _HistoryFormState();
}

class _HistoryFormState extends State<HistoryForm> {
  DateTime? _lastRefreshTime;
  bool _isRefreshing = false;
  static const Duration _refreshCooldown = Duration(seconds: 30);
  List<AppointmentModel>? _cachedFilteredAppointments;
  AppointmentsLoadedState? _lastProcessedState;
  AppointmentHistoryStatus _selectedFilter = AppointmentHistoryStatus.all;

  List<AppointmentModel> _getFilteredAppointments(
      AppointmentsLoadedState state) {
    if (_lastProcessedState != state) {
      final baseAppointments = state.allAppointments.where((appointment) {
        final status = appointment.status.toLowerCase();
        return status == 'cancelled' || status == 'completed';
      }).toList();
      _cachedFilteredAppointments = _filterByStatus(baseAppointments);
      _lastProcessedState = state;
    }

    return _cachedFilteredAppointments!;
  }

  List<AppointmentModel> _filterByStatus(List<AppointmentModel> appointments) {
    List<AppointmentModel> filteredAppointments;

    switch (_selectedFilter) {
      case AppointmentHistoryStatus.all:
        filteredAppointments = appointments;
        break;
      case AppointmentHistoryStatus.cancelled:
        filteredAppointments = appointments
            .where((appointment) =>
                appointment.status.toLowerCase() == 'cancelled')
            .toList();
        break;
      case AppointmentHistoryStatus.completed:
        filteredAppointments = appointments
            .where((appointment) =>
                appointment.status.toLowerCase() == 'completed')
            .toList();
        break;
    }

    filteredAppointments.sort((a, b) {
      return widget.state.controller.appointmentManager
          .compareAppointments(a, b);
    });

    return filteredAppointments;
  }

  void _onFilterChanged(AppointmentHistoryStatus status) {
    setState(() {
      _selectedFilter = status;
      _cachedFilteredAppointments = null;
      _lastProcessedState = null;
    });
  }

  Future<void> _onRefresh() async {
    if (_isRefreshing || _shouldThrottle) return;

    setState(() => _isRefreshing = true);

    try {
      await widget.state.controller.appointmentRefreshData();
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
    return Column(
      children: [
        CustomDropdownFilter<AppointmentHistoryStatus>(
          options: [
            const FilterOption(
                label: 'All', value: AppointmentHistoryStatus.all),
            const FilterOption(
                label: 'Cancelled', value: AppointmentHistoryStatus.cancelled),
            const FilterOption(
                label: 'Completed', value: AppointmentHistoryStatus.completed),
          ],
          onFilterChanged: _onFilterChanged,
          initialSelection: _selectedFilter,
        ),
        Expanded(
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
                  appointments: _getFilteredAppointments(state),
                  onRefresh: _onRefresh,
                  state: widget.state,
                );
              }

              if (state is AppointmentsFailureState) {
                return _ErrorContent(
                  error: state.primaryError,
                  onRefresh: _onRefresh,
                  onRetry: widget.state.controller.appointmentRefreshData,
                  isRefreshing: _isRefreshing,
                );
              }

              return _EmptyContent(onRefresh: _onRefresh);
            },
          ),
        ),
      ],
    );
  }
}

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
  final AppointmentHistoryState state;

  const _LoadedContent({
    Key? key,
    required this.appointments,
    required this.onRefresh,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (appointments.isEmpty) {
      return _EmptyContent(onRefresh: onRefresh);
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        itemCount: appointments.length,
        itemBuilder: (context, index) {
          final appointment = appointments[index];
          // final user = state.controller.getUserByIdNumber(
          //   appointment.counselorId ?? '',
          // );
          return RepaintBoundary(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: HistoryCard(
                appointment: appointment,
                users: state.controller.getUsers(),
              ),
            ),
          );
        },
      ),
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
        title: 'No history of appointments',
        subtitle: '',
      ),
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
    return RefreshIndicator(
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
                      Icon(icon, size: 64, color: colors.textPrimary),
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
