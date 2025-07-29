import 'package:flutter/material.dart';

import '../../../../../common/helpers/spacing.dart';
import '../../pages/home_page.dart';
import '../../pages/test.dart';
import 'home_appointment_list.dart';
import 'home_greeting.dart';

class HomeForm extends StatelessWidget {
  final HomePageState state;
  const HomeForm({super.key, required this.state});

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
              // context.go(Routes.buildPath(Routes.aut_path, Routes.otp_verification));
            },
          ),
          const HomeGreetingCard(),
          Spacing.verticalMedium,
          Expanded(
              child: RepaintBoundary(
            child: HomeAppointmentList(
              appointments: state.appointments,
              onCancel: state.handleCancelAppointment,
              onReschedule: state.handleRescheduleAppointment,
            ),
          ))
        ],
      ),
    );
  }
}
