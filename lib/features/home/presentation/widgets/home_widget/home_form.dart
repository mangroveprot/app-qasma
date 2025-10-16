import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../common/helpers/spacing.dart';
import '../../../../../common/utils/constant.dart';
import '../../../../../infrastructure/theme/theme_extensions.dart';
import '../../../../appointment/data/models/appointment_model.dart';
import '../../../../appointment/presentation/bloc/appointments/appointments_cubit.dart';
import '../../../../users/data/models/user_model.dart';
import '../../../../users/presentation/bloc/user_cubit.dart';
import '../../pages/home_page.dart';
import '../home_skeletonloader.dart';
import 'home_appointment_list.dart';
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

  List<AppointmentModel>? _lastRawAppointments;
  List<AppointmentModel> _cachedFilteredAppointments = [];

  List<UserModel>? _lastRawUsers;
  List<UserModel> _cachedUsers = [];

  static final String _approvedStatus = StatusType.approved.field;
  static final String _pendingStatus = StatusType.pending.field;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() => _isMinimumLoadingTime = false);
      }
    });
  }

  void _processAppointments(AppointmentsLoadedState state) {
    if (identical(_lastRawAppointments, state.appointments)) return;

    _cachedFilteredAppointments = state.appointments.where((appointment) {
      final status = appointment.status.toLowerCase();
      return status == _approvedStatus || status == _pendingStatus;
    }).toList();
    _lastRawAppointments = state.appointments;

    _cachedFilteredAppointments.sort((a, b) {
      return widget.state.controller.appointmentManager.compareAppointments(
        a,
        b,
        sortBy: (m) => m.updatedAt,
      );
    });

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
              padding: const EdgeInsets.all(16.0),
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
      if (_cachedFilteredAppointments.isEmpty) {
        return _buildEmptyState();
      }

      return HomeAppointmentList(
        state: widget.state,
        appointments: _cachedFilteredAppointments,
        users: _cachedUsers,
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
