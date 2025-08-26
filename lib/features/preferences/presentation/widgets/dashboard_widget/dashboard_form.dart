import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dashboard_download_reports_button.dart';

import '../../../../../common/helpers/spacing.dart';
import '../../../../appointment/data/models/appointment_model.dart';
import '../../../../appointment/presentation/bloc/appointments/appointments_cubit.dart';
import '../../../../users/data/models/user_model.dart';
import '../../../../users/presentation/bloc/user_cubit.dart';
import '../../config/appointment_stats_data.dart';
import '../../pages/dashboard_page.dart';
import '../../utils/dashboard_utils.dart';
import 'dashboard_appointment.dart';
import 'dashboard_recent_appointments.dart';
import 'dashboard_stats.dart';

class DashboardForm extends StatelessWidget {
  final DashboardPageState state;
  const DashboardForm({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child:
          BlocBuilder<UserCubit, UserCubitState>(builder: (context, userState) {
        return BlocBuilder<AppointmentsCubit, AppointmentCubitState>(
            builder: (context, appointmentsState) {
          final appointments = appointmentsState is AppointmentsLoadedState
              ? appointmentsState.appointments
              : <AppointmentModel>[];

          final users =
              userState is UserLoadedState ? userState.users : <UserModel>[];

          final List<AppointmentStatsData> appointmentStatsData =
              DashboardUtils.apppointmentStatsData(
            appointments: appointments,
            context: context,
          );
          final List<AppointmentModel> recentAppointments =
              DashboardUtils.getRecentAppointments(appointments: appointments);

          return Column(
            children: [
              DashboardStats(
                appointments: appointments,
                users: users,
              ),
              Spacing.verticalMedium,
              AppointmentsDashboard(
                data: appointmentStatsData,
              ),
              DashboardDownloadReportsButton(
                onPressed: () => state.controller.handleGenerateReport(
                  context: context,
                  entries: DashboardUtils.masterListData(
                    appointments: appointments,
                    users: users,
                  ),
                ),
              ),
              Spacing.verticalMedium,
              DashboardRecentAppointments(
                appointments: recentAppointments,
                users: users,
              )
            ],
          );
        });
      }),
    );
  }
}
