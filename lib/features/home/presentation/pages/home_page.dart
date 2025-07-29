import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/utils/menu_items_config.dart';
import '../../../../common/widgets/bloc/button/button_cubit.dart';
import '../../../../common/widgets/button_text/custom_text_button.dart';
import '../../../../common/widgets/custom_modal/custom_modal.dart';
import '../../../../common/widgets/modal.dart';
import '../../../../common/widgets/toast/custom_toast.dart';
import '../../../../theme/theme_extensions.dart';
import '../../data/models/appointment_model.dart';
import '../widgets/home_widget/home_fab.dart';
import '../widgets/home_widget/home_form.dart';
import '../widgets/main_appbar.dart';
import '../widgets/sidbar_widget/custom_sidebar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  // Sample appointment data - replace with your actual data source
  final List<AppointmentData> appointments = [
    const AppointmentData(
        id: '1',
        date: 'December 25, 20204',
        time: '10:30 am',
        type: 'Counselling',
        appointmentType: 'Unknown',
        status: AppointmentStatus.approved,
        qrCode: 'QR_CODE_DATA_1',
        description: 'dkkjihuibkjnlkmjhuighbjknljgyuhjbkjohuighb'),
    const AppointmentData(
        id: '2',
        date: 'December 25, 20204',
        time: '10:30 am',
        type: 'Counselling',
        appointmentType: 'Unknown',
        status: AppointmentStatus.approved,
        qrCode: 'QR_CODE_DATA_2',
        description: 'dkkjihuibkjnlkmjhuighbjknljgyuhjbkjohuighb'),
    const AppointmentData(
        id: '3',
        date: 'December 25, 20204',
        time: '10:30 am',
        type: 'Counselling',
        appointmentType: 'Unknown',
        status: AppointmentStatus.approved,
        qrCode: 'QR_CODE_DATA_3',
        description: 'dkkjihuibkjnlkmjhuighbjknljgyuhjbkjohuighb'),
    const AppointmentData(
        id: '4',
        date: 'December 25, 20204',
        time: '10:30 am',
        type: 'Counselling',
        appointmentType: 'Unknown',
        status: AppointmentStatus.approved,
        qrCode: 'QR_CODE_DATA_4',
        description: 'dkkjihuibkjnlkmjhuighbjknljgyuhjbkjohuighb'),
  ];

  Future<void> handleCancelAppointment(String appointmentId) async {
    final result = await CustomModal.showCenteredModal<bool>(
      context,
      title: 'Are you sure to cancel this appointment?',
      subtitle: 'Date: December 24, 2025 - 10:30am',
      icon: CustomModal.warningIcon(
          iconColor: Colors.red,
          backgroundColor: Colors.red.withOpacity(0.1),
          size: 58,
          iconSize: 28),
      actions: [
        // Primary button (Yes) - uses ButtonCubit
        CustomTextButton(
          onPressed: () async {
            final cubit = context.read<ButtonCubit>();
            cubit.emitLoading();
            await Future.delayed(const Duration(milliseconds: 500));
            cubit.emitInitial();
            Navigator.of(context).pop(true);
          },
          text: 'Yes',
          textColor: context.colors.white,
          fontSize: 14,
          fontWeight: context.weight.medium,
          backgroundColor: Colors.red,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          borderRadius: context.radii.large,
          width: 100,
          height: 44,
        ),
        // Secondary button (No) - simple text button
        ModalUI.secondaryButton(
            text: 'No',
            onPressed: () {
              context.pop(false);
            }),
      ],
    );
  }

  void handleRescheduleAppointment(String appointmentId) {
    // Handle appointment rescheduling
    debugPrint('Reschedule appointment: $appointmentId');
  }

  void handleShowHistory() {
    // Handle show history
    debugPrint('Show appointment history');
  }

  void _handleMenuItemTap(String menuItem) {
    // Handle navigation based on menu item
    switch (menuItem) {
      case MenuKeys.appointments:
        // Navigate to appointments page
        debugPrint('Navigating to Appointments');
        break;
      case MenuKeys.myProfile:
        // Navigate to profile page
        debugPrint('Navigating to Profile');
        break;
      case MenuKeys.history:
        // Navigate to history page
        debugPrint('Navigating to History');
        break;
      case MenuKeys.history:
        // Navigate to privacy policy page
        debugPrint('Navigating to Privacy Policy');
        break;
      case MenuKeys.termsAndCondition:
        // Navigate to terms page
        debugPrint('Navigating to Terms');
        break;
      case MenuKeys.settings:
        // Navigate to settings page
        debugPrint('Navigating to Settings');
        break;
      case MenuKeys.logout:
        // Handle logout
        _handleLogout();
        break;
    }
  }

  void _handleLogout() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Add your actual logout logic here
                debugPrint('User logged out');
              },
              child: const Text('Logout', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _handleNotificationTap() {
    // Handle notification bell tap
    debugPrint('Notification bell tapped');
    // Add your notification logic here
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ButtonCubit(),
      child: Scaffold(
        drawerEnableOpenDragGesture: true,
        drawerScrimColor: Colors.black54,
        drawerEdgeDragWidth: 60,
        appBar: MainAppBar(
          title: 'JRMSU-KC QASMA',
          onNotificationTap: _handleNotificationTap,
        ),
        drawer: CustomSidebar(
          userName: 'Jane Doe',
          onMenuItemTap: _handleMenuItemTap,
        ),
        body: BlocListener<ButtonCubit, ButtonState>(
          listener: _handleButtonState,
          child: SafeArea(
            child: HomeForm(
              state: this,
            ),
          ),
        ),
        floatingActionButton: const RepaintBoundary(child: HomeFab()),
      ),
    );
  }

  void _handleButtonState(BuildContext context, ButtonState state) {
    if (state is ButtonFailureState) {
      if (state.errorMessages.isNotEmpty) {
        CustomToast.error(context: context, message: state.errorMessages.first);
      }
    }

    if (state is ButtonSuccessState) {}
  }
}
