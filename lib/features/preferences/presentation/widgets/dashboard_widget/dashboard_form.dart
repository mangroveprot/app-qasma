import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '_appointment_type_monthly/dashboard_appointment_type_monthly.dart';
import 'dashboard_download_reports_button.dart';

import '../../../../../common/helpers/spacing.dart';
import '../../../../activity_logs/data/models/activity_log_model.dart';
import '../../../../activity_logs/presentation/bloc/activity_logs_cubit.dart';
import '../../../../appointment/data/models/appointment_model.dart';
import '../../../../appointment/presentation/bloc/appointments/appointments_cubit.dart';
import '../../../../users/data/models/user_model.dart';
import '../../../../users/presentation/bloc/user_cubit.dart';
import '../../config/appointment_stats_data.dart';
import '../../models/appointment_filter_model.dart';
import '../../pages/dashboard_page.dart';
import '../../utils/dashboard_utils.dart';
import 'dashboard_appointment.dart';
import 'dashboard_recent_activity_logs.dart';
import 'dashboard_recent_appointments.dart';
import 'dashboard_stats.dart';

class DashboardForm extends StatelessWidget {
  final DashboardPageState state;
  final AppointmentFilterModel? filter;

  const DashboardForm({
    super.key,
    required this.state,
    this.filter,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserCubitState>(
      buildWhen: (prev, next) =>
          prev.runtimeType != next.runtimeType ||
          (prev is UserLoadedState &&
              next is UserLoadedState &&
              prev.users != next.users),
      builder: (context, userState) {
        return BlocBuilder<AppointmentsCubit, AppointmentCubitState>(
          buildWhen: (prev, next) =>
              prev.runtimeType != next.runtimeType ||
              (prev is AppointmentsLoadedState &&
                  next is AppointmentsLoadedState &&
                  prev.appointments != next.appointments),
          builder: (context, appointmentsState) {
            final allAppointments = appointmentsState is AppointmentsLoadedState
                ? appointmentsState.appointments
                : <AppointmentModel>[];

            final filteredAppointments =
                filter != null && filter!.hasActiveFilters
                    ? DashboardUtils.applyFilters(
                        appointments: allAppointments,
                        filter: filter!,
                      )
                    : allAppointments;

            final users =
                userState is UserLoadedState ? userState.users : <UserModel>[];

            final List<AppointmentStatsData> appointmentStatsData =
                DashboardUtils.apppointmentStatsData(
              appointments: filteredAppointments,
              context: context,
            );
            final List<AppointmentModel> recentAppointments =
                DashboardUtils.getRecentAppointments(
              appointments: filteredAppointments,
            );

            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: 5,
              addAutomaticKeepAlives: true,
              addRepaintBoundaries: true,
              cacheExtent: 2000,
              itemBuilder: (context, index) {
                switch (index) {
                  case 0:
                    return RepaintBoundary(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          DashboardStats(
                            appointments: filteredAppointments,
                            users: users,
                          ),
                          Spacing.verticalMedium,
                        ],
                      ),
                    );
                  case 1:
                    return RepaintBoundary(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          DashboardAppointments(
                            data: appointmentStatsData,
                            appointments: filteredAppointments,
                            filter: filter,
                            onFilterPressed: () =>
                                state.showFilterBottomSheet(context),
                          ),
                          Spacing.verticalMedium,
                        ],
                      ),
                    );
                  case 2:
                    return RepaintBoundary(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          DashboardAppointmentTypeMonthly(
                            appointments: filteredAppointments,
                            filter: filter,
                            onFilterPressed: () =>
                                state.showFilterBottomSheet(context),
                          ),
                          Spacing.verticalMedium,
                        ],
                      ),
                    );
                  case 3:
                    return RepaintBoundary(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          DashboardDownloadReportsButton(
                            onPressed: () =>
                                state.controller.handleGenerateReport(
                              context: context,
                              entries: DashboardUtils.masterListData(
                                appointments: filteredAppointments,
                                users: users,
                              ),
                            ),
                          ),
                          Spacing.verticalMedium,
                        ],
                      ),
                    );
                  case 4:
                    return RepaintBoundary(
                      child: _DashboardRecentSection(
                        recentAppointments: recentAppointments,
                        users: users,
                      ),
                    );
                  default:
                    return const SizedBox.shrink();
                }
              },
            );
          },
        );
      },
    );
  }
}

class _DashboardRecentSection extends StatelessWidget {
  final List<AppointmentModel> recentAppointments;
  final List<UserModel> users;

  const _DashboardRecentSection({
    required this.recentAppointments,
    required this.users,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActivityLogsCubit, ActivityLogsCubitState>(
      buildWhen: (prev, next) =>
          prev.runtimeType != next.runtimeType ||
          (prev is ActivityLogsLoadedState &&
              next is ActivityLogsLoadedState &&
              prev.activityLogs != next.activityLogs),
      builder: (context, activityLogsState) {
        final isActivityLogsLoading =
            activityLogsState is ActivityLogsLoadingState ||
                activityLogsState is ActivityLogsInitialState;
        List<ActivityLogModel> recentActivityLogs;

        if (activityLogsState is ActivityLogsLoadedState) {
          try {
            final logs = <ActivityLogModel>[
              ...activityLogsState.activityLogs,
            ];
            logs.sort((a, b) => b.createdAt.compareTo(a.createdAt));
            recentActivityLogs = logs.take(5).toList();
          } catch (_) {
            // In case of any unexpected data issue, fail safely instead of crashing.
            recentActivityLogs = const <ActivityLogModel>[];
          }
        } else {
          recentActivityLogs = const <ActivityLogModel>[];
        }

        return LayoutBuilder(
          builder: (context, sectionConstraints) {
            final isWide = sectionConstraints.maxWidth >= 900;
            if (isWide) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: RepaintBoundary(
                      child: DashboardRecentAppointments(
                        appointments: recentAppointments,
                        users: users,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: RepaintBoundary(
                      child: DashboardRecentActivityLogs(
                        logs: recentActivityLogs,
                        isLoading: isActivityLogsLoading,
                        users: users,
                      ),
                    ),
                  ),
                ],
              );
            }
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RepaintBoundary(
                  child: DashboardRecentAppointments(
                    appointments: recentAppointments,
                    users: users,
                  ),
                ),
                Spacing.verticalMedium,
                RepaintBoundary(
                  child: DashboardRecentActivityLogs(
                    logs: recentActivityLogs,
                    isLoading: isActivityLogsLoading,
                    users: users,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
