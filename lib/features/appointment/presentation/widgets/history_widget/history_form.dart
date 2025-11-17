import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../common/widgets/custom_filter_bar.dart';
import '../../../data/models/appointment_model.dart';
import '../../bloc/appointments/appointments_cubit.dart';
import '../../pages/appointment_history_page.dart';
import '../../utils/history_utils.dart';
import 'history_empty_content.dart';
import 'history_error_content.dart';
import 'history_loaded_content.dart';

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

  int currentPage = 0;
  final int itemsPerPage = 10;
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

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
      currentPage = 0;
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

  void _handlePageChange(int newPage) {
    setState(() => currentPage = newPage);

    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
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
                return const Center(child: CircularProgressIndicator());
              }

              if (state is AppointmentsLoadedState) {
                return HistoryLoadedContent(
                  appointments: _getFilteredAppointments(state),
                  onRefresh: _onRefresh,
                  state: widget.state,
                  currentPage: currentPage,
                  itemsPerPage: itemsPerPage,
                  onPageChanged: _handlePageChange,
                  scrollController: _scrollController,
                );
              }

              if (state is AppointmentsFailureState) {
                return HistoryErrorContent(
                  error: state.primaryError,
                  onRefresh: _onRefresh,
                  onRetry: widget.state.controller.appointmentRefreshData,
                  isRefreshing: _isRefreshing,
                );
              }

              return HistoryEmptyContent(onRefresh: _onRefresh);
            },
          ),
        ),
      ],
    );
  }
}
