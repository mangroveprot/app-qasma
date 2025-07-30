import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../common/helpers/spacing.dart';
import '../../../../appointment/data/models/appointment_model.dart';
import '../../../../appointment/presentation/bloc/appointments_cubit.dart';

import '../../pages/home_page.dart';
import '../../pages/test.dart';
import 'home_appointment_list.dart';
import 'home_greeting.dart';

class HomeForm extends StatelessWidget {
  final HomePageState state;

  const HomeForm({super.key, required this.state});

  // Helper method to filter appointments
  List<AppointmentModel> _getFilteredAppointments(
      List<AppointmentModel> appointments) {
    return appointments.where((appointment) {
      final status = appointment.status.toLowerCase();
      return status == 'pending' || status == 'approved';
    }).toList();
  }

  // Handle refresh functionality
  Future<void> _onRefresh() async {
    await state.refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          ElevatedButton(
            child: const Text('Go to Second Page'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MyScreen()),
              );
            },
          ),
          const HomeGreetingCard(),
          Spacing.verticalSmall,

          // Use RefreshIndicator to wrap the appointments section
          Expanded(
            child: RefreshIndicator(
              onRefresh: _onRefresh,
              child: RepaintBoundary(
                child: BlocBuilder<AppointmentsCubit, AppointmentCubitState>(
                  builder: (context, appointmentState) {
                    if (appointmentState is AppointmentsLoadingState) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (appointmentState is AppointmentsLoadedState) {
                      // Filter appointments to only show pending and approved
                      final filteredAppointments = _getFilteredAppointments(
                        appointmentState.appointments,
                      );

                      return HomeAppointmentList(
                        appointments: filteredAppointments,
                        onCancel: state.handleCancelAppointment,
                        onReschedule: state.handleRescheduleAppointment,
                      );
                    }

                    if (appointmentState is AppointmentsFailureState) {
                      return SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: SizedBox(
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
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  appointmentState.primaryError,
                                  style: Theme.of(context).textTheme.bodySmall,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () => state.refreshData(),
                                  child: const Text('Retry'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }

                    // Initial state - show empty container with scrollable area
                    return SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: const Center(
                          child: Text('No appointments to display'),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
