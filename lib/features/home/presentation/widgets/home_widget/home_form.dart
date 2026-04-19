import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../common/helpers/helpers.dart';
import '../../../../../common/helpers/spacing.dart';
import '../../../../../common/utils/constant.dart';
import '../../../../../infrastructure/theme/theme_extensions.dart';
import '../../../../appointment/data/models/appointment_model.dart';
import '../../../../appointment/presentation/bloc/appointments/appointments_cubit.dart';
import '../../../../users/data/models/user_model.dart';
import '../../../../users/presentation/bloc/user_cubit.dart';
import '../../pages/home_page.dart';
import '../../models/home_appointment_filter_model.dart';
import '../home_skeletonloader.dart';
import 'home_appointment_list.dart';
import 'home_appointment_filter_bottom_sheet.dart';
import 'home_status_card.dart';

class HomeForm extends StatefulWidget {
  final HomePageState state;

  const HomeForm({
    super.key,
    required this.state,
  });

  @override
  State<HomeForm> createState() => _HomeFormState();
}

class _HomeFormState extends State<HomeForm> {
  DateTime? _lastRefreshTime;
  bool _isRefreshing = false;
  bool _isMinimumLoadingTime = true;
  static const Duration _refreshCooldown = Duration(seconds: 30);

  String _searchQuery = '';
  HomeAppointmentFilterModel _filter = const HomeAppointmentFilterModel();
  late final TextEditingController _searchController;

  List<AppointmentModel>? _lastRawAppointments;
  List<AppointmentModel> _cachedFilteredAppointments = [];

  List<UserModel>? _lastRawUsers;
  List<UserModel> _cachedUsers = [];

  static final String _approvedStatus = StatusType.approved.field;
  static final String _pendingStatus = StatusType.pending.field;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: _searchQuery);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() => _isMinimumLoadingTime = false);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _processAppointments(AppointmentsLoadedState state) {
    if (identical(_lastRawAppointments, state.appointments)) return;

    _cachedFilteredAppointments = state.appointments.where((appointment) {
      final status = appointment.status.toLowerCase();
      return status == _approvedStatus || status == _pendingStatus;
    }).toList();
    _lastRawAppointments = state.appointments;
  }

  void _processUsers(UserLoadedState state) {
    if (identical(_lastRawUsers, state.users)) return;

    _cachedUsers = List.from(state.users);
    _lastRawUsers = state.users;
  }

  Future<void> _onRefresh() async {
    if (_isRefreshing || _shouldThrottle) return;

    setState(() => _isRefreshing = true);

    try {
      await Future.wait([
        widget.state.controller.appoitnmentRefreshData(),
        widget.state.controller.appointConfigRefreshData(),
        widget.state.controller.userRefreshData(),
        widget.state.controller.notificationsRefreshData(),
      ]);
      _lastRefreshTime = DateTime.now();
    } catch (e) {
      debugPrint('Refresh failed: $e');
    } finally {
      if (mounted) setState(() => _isRefreshing = false);
    }
  }

  bool get _shouldThrottle {
    return _lastRefreshTime != null &&
        DateTime.now().difference(_lastRefreshTime!) < _refreshCooldown;
  }

  void _onSearchChanged(String query) {
    setState(() => _searchQuery = query);
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: HomeAppointmentFilterBottomSheet(
          initialFilter: _filter,
          onApply: (filter) {
            setState(() {
              _filter = filter;
            });
          },
        ),
      ),
    );
  }

  Map<String, UserModel> _buildUserMap() {
    return {for (final user in _cachedUsers) user.idNumber: user};
  }

  List<AppointmentModel> _getVisibleAppointments() {
    final base = _cachedFilteredAppointments;
    if (base.isEmpty) return const <AppointmentModel>[];

    final query = _searchQuery.trim().toLowerCase();
    final userMap = _buildUserMap();

    final now = DateTime.now();

    final filtered = query.isEmpty
        ? List<AppointmentModel>.from(base)
        : base.where((appointment) {
            final student = userMap[appointment.studentId];

            final haystacks = <String>[
              appointment.appointmentId,
              appointment.studentId,
              appointment.appointmentCategory,
              appointment.appointmentType,
              appointment.description,
              student?.fullName ?? '',
              student?.idNumber ?? '',
            ];

            return haystacks.any((v) => v.toLowerCase().contains(query));
          }).toList();

    // Overdue filter (default: all)
    final overdueFiltered = _filter.overdue == 'all'
        ? filtered
        : filtered.where((appointment) {
            final isOverdue =
                stripMicroseconds(appointment.scheduledEndAt).isBefore(now);
            if (_filter.overdue == 'overdue') return isOverdue;
            if (_filter.overdue == 'not_overdue') return !isOverdue;
            return true;
          }).toList();

    // Date range filter (inclusive, by scheduledStartAt local date)
    final DateTime? from = _filter.dateFrom != null
        ? DateTime(_filter.dateFrom!.year, _filter.dateFrom!.month,
            _filter.dateFrom!.day)
        : null;
    final DateTime? to = _filter.dateTo != null
        ? DateTime(_filter.dateTo!.year, _filter.dateTo!.month,
            _filter.dateTo!.day, 23, 59, 59, 999)
        : null;

    final dateFiltered = (from == null && to == null)
        ? overdueFiltered
        : overdueFiltered.where((appointment) {
            final localStart = appointment.scheduledStartAt.toLocal();
            if (from != null && localStart.isBefore(from)) return false;
            if (to != null && localStart.isAfter(to)) return false;
            return true;
          }).toList();

    final ascending = _filter.sortBy == 'oldest';
    dateFiltered.sort((a, b) {
      return widget.state.controller.appointmentManager.compareAppointments(
        a,
        b,
        sortBy: (m) => m.updatedAt,
        ascending: ascending,
      );
    });

    return dateFiltered;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserCubitState>(
      builder: (context, userState) {
        // Process users when loaded
        if (userState is UserLoadedState) {
          _processUsers(userState);
        }

        return BlocBuilder<AppointmentsCubit, AppointmentCubitState>(
          builder: (context, appointmentState) {
            // Show skeleton loader if either is loading
            final bool isLoading = _isMinimumLoadingTime ||
                appointmentState is AppointmentsLoadingState ||
                userState is UserLoadingState;

            if (isLoading) {
              return HomeSkeletonLoader.appointmentDashboard();
            }

            if (appointmentState is AppointmentsLoadedState) {
              _processAppointments(appointmentState);
            }

            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Column(
                children: [
                  HomeStatusCard(
                    appointments: _cachedFilteredAppointments,
                  ),
                  Spacing.verticalSmall,
                  Expanded(
                    child: _buildContent(appointmentState, userState),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildContent(
    AppointmentCubitState appointmentState,
    UserCubitState userState,
  ) {
    if (_isMinimumLoadingTime ||
        appointmentState is AppointmentsLoadingState ||
        userState is UserLoadingState) {
      return HomeSkeletonLoader.appointmentCardSkeleton();
    }

    // Handle user failure state
    if (userState is UserFailureState) {
      return _buildErrorState(userState.primaryError);
    }

    if (appointmentState is AppointmentsLoadedState) {
      _processAppointments(appointmentState);
      final visibleAppointments = _getVisibleAppointments();

      return HomeAppointmentList(
        state: widget.state,
        appointments: visibleAppointments,
        users: _cachedUsers,
        onSearchChanged: _onSearchChanged,
        searchController: _searchController,
        onOpenFilter: _showFilterBottomSheet,
        activeFilterCount: _filter.activeFilterCount,
        onCancel: (id) =>
            widget.state.controller.handleCancelAppointment(id, context),
        onReschedule: widget.state.controller.handleRescheduleAppointment,
        onRefresh: _onRefresh,
      );
    }

    if (appointmentState is AppointmentsFailureState) {
      return _buildErrorState(appointmentState.primaryError);
    }

    return _buildEmptyState();
  }

  Widget _buildEmptyState() {
    final colors = context.colors;

    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                        textAlign: TextAlign.center,
                      ),
                      Spacing.verticalMedium,
                      Text(
                        'Waiting for student bookings',
                        style: TextStyle(color: colors.textPrimary),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: context.colors.textPrimary,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Failed to load data',
                      style: TextStyle(
                        color: context.colors.black.withOpacity(0.8),
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      error,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: context.colors.textPrimary,
                          ),
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _isRefreshing
                          ? null
                          : () async {
                              await _onRefresh();
                            },
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
          ),
        ],
      ),
    );
  }
}
