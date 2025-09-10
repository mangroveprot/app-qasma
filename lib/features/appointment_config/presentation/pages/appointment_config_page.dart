import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/helpers/spacing.dart';
import '../../../../common/widgets/custom_app_bar.dart';
import '../../../../infrastructure/routes/app_routes.dart';
import '../controller/appointment_config_controller.dart';
import '../widgets/appointment_config_widget/config_chevron.dart';

class AppointmentConfigPage extends StatefulWidget {
  const AppointmentConfigPage({super.key});

  @override
  State<AppointmentConfigPage> createState() => _AppointmentConfigPageState();
}

class _AppointmentConfigPageState extends State<AppointmentConfigPage> {
  late final AppointmentConfigController controller;
  bool _hasInitialized = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    controller = AppointmentConfigController();

    // delay to load the appointment data
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_hasInitialized) {
      controller.initialize();
      _hasInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Appointment Preference',
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    ConfigChevron(
                      type: 'Basic Settings',
                      icons: Icons.alarm_outlined,
                      subtitle:
                          'Buffer time, booking lead time, slot days range',
                      onPressed: () {
                        context.push(Routes.buildPath(
                          Routes.appointment_config,
                          Routes.basic_config,
                        ));
                      },
                    ),
                    Spacing.verticalMedium,
                    ConfigChevron(
                      type: 'Available Hours Schedule',
                      icons: Icons.calendar_month_outlined,
                      subtitle: 'Set working hours for each day of the week',
                      onPressed: () {
                        context.push(
                          Routes.buildPath(Routes.user_path, Routes.schedule),
                          extra: {
                            'isConfig': true,
                          },
                        );
                      },
                    ),
                    Spacing.verticalMedium,
                    ConfigChevron(
                      type: 'Reminders',
                      icons: Icons.chat_bubble_outline_sharp,
                      subtitle: 'Configure appointment reminder messages',
                      onPressed: () {
                        context.push(Routes.buildPath(
                          Routes.appointment_config,
                          Routes.reminders_config,
                        ));
                      },
                    ),
                    Spacing.verticalMedium,
                    ConfigChevron(
                      type: 'Categories & Types',
                      icons: Icons.local_offer_outlined,
                      subtitle:
                          'Manage appointment categories, types, and durations',
                      onPressed: () {
                        context.push(Routes.buildPath(
                          Routes.appointment_config,
                          Routes.categories_and_types,
                        ));
                      },
                    ),
                    Spacing.verticalMedium,
                  ],
                ),
              ),
            ),
    );
  }
}
