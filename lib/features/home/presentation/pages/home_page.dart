import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/widgets/models/modal_option.dart';
import '../../../../common/widgets/toast/app_toast.dart';
import '../../../../infrastructure/routes/app_routes.dart';
import '../../../appointment/presentation/bloc/appointments/appointments_cubit.dart';
import '../../../appointment_config/presentation/bloc/appointment_config_cubit.dart';
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

  void _handleNavigation(String route, {Object? extra}) {
    // Use go() only for root navigation (like after logout)
    if (route == Routes.root || route == '/login') {
      if (extra != null) {
        context.go(route, extra: extra);
      } else {
        context.go(route);
      }
    } else {
      // Use push() for all other navigation to maintain back stack
      if (extra != null) {
        context.push(route, extra: extra);
      } else {
        context.push(route);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    controller = HomePageController();
    controller.initialize(onNavigate: _handleNavigation);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

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
          BlocListener<AppointmentConfigCubit, AppointmentConfigCubitState>(
            listener: _handleAppointmentConfigState,
          ),
        ],
        child: BlocBuilder<UserCubit, UserCubitState>(
          builder: (context, userState) {
            final fullName = userState is UserLoadedState
                ? '${userState.user.first_name} ${userState.user.last_name}'
                    .trim()
                : '';

            final firstName =
                userState is UserLoadedState ? userState.user.first_name : '';

            return Scaffold(
              drawerEnableOpenDragGesture: true,
              drawerScrimColor: Colors.black54,
              drawerEdgeDragWidth: 60,
              appBar: MainAppBar(
                title: 'JRMSU-KC QASMA',
                onNotificationTap: controller.handleNotificationTap,
              ),
              drawer: CustomSidebar(
                userName: fullName,
                onMenuItemTap: (menuItem) =>
                    controller.handleMenuItemTap(menuItem, context),
              ),
              body: SafeArea(
                child: HomeForm(
                  state: this,
                  firstName: firstName,
                ),
              ),
              floatingActionButton: RepaintBoundary(
                child: BlocBuilder<AppointmentConfigCubit,
                    AppointmentConfigCubitState>(
                  builder: (context, state) {
                    List<ModalOption> options = [];

                    if (state is AppointmentConfigLoadedState) {
                      final configCubit =
                          context.read<AppointmentConfigCubit>();
                      final categories = configCubit.allCategories;
                      options =
                          controller.generateAppointmentOptions(categories);
                    }

                    return HomeFab(
                      options: options,
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _handleAppointmentsState(
      BuildContext context, AppointmentCubitState state) {
    switch (state.runtimeType) {
      case AppointmentsFailureState:
        final failureState = state as AppointmentsFailureState;
        AppToast.show(
          message: failureState.primaryError,
          type: ToastType.error,
        );
        break;

      case AppointmentsLoadedState:
        final loadedState = state as AppointmentsLoadedState;
        if (loadedState.appointments.isEmpty) {
          AppToast.show(
            message: 'No appointments found',
            type: ToastType.error,
          );
        }
        break;
    }
  }

  void _handleUserState(BuildContext context, UserCubitState state) {
    if (state is UserFailureState) {
      AppToast.show(message: 'Failed to load user data', type: ToastType.error);
      debugPrint('Failed to load user: ${state.errorMessages}');
    }
  }

  void _handleAppointmentConfigState(
      BuildContext context, AppointmentConfigCubitState state) {
    if (state is AppointmentConfigFailureState) {
      AppToast.show(
        message: 'Failed to load appointment config',
        type: ToastType.error,
      );
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
