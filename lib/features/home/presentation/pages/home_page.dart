import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/utils/button_ids.dart';
import '../../../../common/widgets/bloc/button/button_cubit.dart';
import '../../../../common/widgets/models/modal_option.dart';
import '../../../../common/widgets/toast/app_toast.dart';
import '../../../../infrastructure/routes/app_routes.dart';
import '../../../appointment/presentation/bloc/appointments/appointments_cubit.dart';
import '../../../appointment_config/presentation/bloc/appointment_config_cubit.dart';
import '../../../users/presentation/bloc/user_cubit.dart';
import '../controllers/homepage_controller.dart';
import '../widgets/home_widget/_feedback/feedback_section.dart';
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
    if (route == Routes.root || route == '/login') {
      if (extra != null) {
        context.go(route, extra: extra);
      } else {
        context.go(route);
      }
    } else {
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
          BlocListener<ButtonCubit, ButtonState>(
            listener: _handleButtonState,
          ),
          BlocListener<AppointmentConfigCubit, AppointmentConfigCubitState>(
            listener: _handleAppointmentConfigState,
          ),
        ],
        child: BlocBuilder<UserCubit, UserCubitState>(
          builder: (context, userState) {
            final userProfile = controller.currentUserProfile();

            return Scaffold(
              drawerEnableOpenDragGesture: true,
              drawerScrimColor: Colors.black54,
              drawerEdgeDragWidth: 60,
              appBar: MainAppBar(
                title: 'JRMSU-KC QASMA',
                onNotificationTap: controller.handleNotificationTap,
              ),
              drawer: CustomSidebar(
                userName: userProfile?.fullName ?? '',
                idNumber: userProfile?.idNumber ?? '',
                onMenuItemTap: (menuItem) =>
                    controller.handleMenuItemTap(menuItem, context),
              ),
              body: SafeArea(
                child: HomeForm(
                  state: this,
                  firstName: userProfile?.first_name ?? '',
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
                      onAppointmentSuccess: () async {
                        await controller.appoitnmentRefreshData();
                      },
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
            message: 'You dont have appointment yet!',
            type: ToastType.original,
          );
        }

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            controller.checkPendingFeedback(context);
          }
        });
        break;
    }
  }

  void _handleUserState(BuildContext context, UserCubitState state) {
    if (state is UserFailureState) {
      Future.delayed(const Duration(seconds: 4), () {
        AppToast.show(
          message: 'Failed to load user data',
          type: ToastType.error,
        );
      });
    }
  }

  Future<void> _handleButtonState(
      BuildContext context, ButtonState state) async {
    if (state is ButtonFailureState) {
      if (state.errorMessages.isNotEmpty) {
        AppToast.show(
          message: state.errorMessages.first,
          type: ToastType.error,
        );
      }

      if (state.suggestions.isNotEmpty) {
        Future.delayed(const Duration(seconds: 4), () {
          AppToast.show(
            message: state.suggestions.first,
            type: ToastType.original,
          );
        });
      }
    }

    if (state is ButtonSuccessState) {
      if (state.buttonId != null &&
          state.buttonId == ButtonsUniqeKeys.feedback.id) {
        FeedBackSection.closeModalIfOpen(context);
      }
      if (state.buttonId != null &&
          state.buttonId!.startsWith('selection_canceled_')) {
        AppToast.show(
          message: 'Appointment has been canceled successfully.',
          type: ToastType.success,
        );
      }
      await controller.appoitnmentRefreshData();
    }
  }

  void _handleAppointmentConfigState(
      BuildContext context, AppointmentConfigCubitState state) {
    if (state is AppointmentConfigFailureState) {
      Future.delayed(const Duration(seconds: 4), () {
        AppToast.show(
          message: 'Failed to load appointment config',
          type: ToastType.error,
        );
      });
    }
  }
}
