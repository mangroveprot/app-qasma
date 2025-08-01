import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/utils/menu_items_config.dart';
import '../../../../common/widgets/toast/custom_toast.dart';
import '../../../appointment/presentation/bloc/appointments_cubit.dart';
import '../../../users/presentation/bloc/user_cubit.dart';
import '../controllers/homepage_controller.dart';
import '../widgets/home_widget/home_fab.dart';
import '../widgets/home_widget/home_form.dart';
import '../widgets/main_appbar.dart';
import '../widgets/sidbar_widget/custom_sidebar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {
  late final HomePageController controller;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    controller = HomePageController();
    controller.initialize(
      onNavigate: _handleNavigation,
    );
  }

  void _handleNavigation(String route) {
    switch (route) {
      case MenuKeys.appointments:
        debugPrint('Navigating to Appointments');
        break;
      case MenuKeys.myProfile:
        debugPrint('Navigating to Profile');
        break;
      case MenuKeys.history:
        debugPrint('Navigating to History');
        break;
      case MenuKeys.privacyPolicy:
        debugPrint('Navigating to Privacy Policy');
        break;
      case MenuKeys.termsAndCondition:
        debugPrint('Navigating to Terms');
        break;
      case MenuKeys.settings:
        debugPrint('Navigating to Settings');
        break;
      case MenuKeys.logout:
        //   _handleLogout();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    // Ensure cubits are initialized
    if (!controller.isInitialized) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return MultiBlocProvider(
      providers: controller.blocProviders,
      child: MultiBlocListener(
        listeners: [
          BlocListener<AppointmentsCubit, AppointmentCubitState>(
            listener: _handleAppointmentsState,
          ),
          BlocListener<UserCubit, UserCubitState>(
            listener: _handleUserState,
          ),
        ],
        child: Scaffold(
          drawerEnableOpenDragGesture: true,
          drawerScrimColor: Colors.black54,
          drawerEdgeDragWidth: 60,
          appBar: MainAppBar(
            title: 'JRMSU-KC QASMA',
            onNotificationTap: controller.handleNotificationTap,
          ),
          drawer: BlocBuilder<UserCubit, UserCubitState>(
            builder: (context, state) {
              final userName = state is UserLoadedState
                  ? '${state.user.first_name} ${state.user.last_name}'.trim()
                  : '';

              return CustomSidebar(
                userName: userName,
                onMenuItemTap: (menuItem) =>
                    controller.handleMenuItemTap(menuItem, context),
              );
            },
          ),
          body: SafeArea(
            child: HomeForm(
              state: this,
            ),
          ),
          floatingActionButton: const RepaintBoundary(
            child: HomeFab(),
          ),
        ),
      ),
    );
  }

  void _handleAppointmentsState(
      BuildContext context, AppointmentCubitState state) {
    switch (state.runtimeType) {
      case AppointmentsFailureState:
        final failureState = state as AppointmentsFailureState;
        CustomToast.error(
          context: context,
          message: failureState.primaryError,
        );
        break;

      case AppointmentsLoadedState:
        final loadedState = state as AppointmentsLoadedState;
        if (loadedState.appointments.isEmpty) {
          CustomToast.info(context: context, message: 'No appointments found');
        }
        break;
    }
  }

  void _handleUserState(BuildContext context, UserCubitState state) {
    if (state is UserFailureState) {
      CustomToast.error(
        context: context,
        message: 'Failed to load user data',
      );
      debugPrint('Failed to load user: ${state.errorMessages}');
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
