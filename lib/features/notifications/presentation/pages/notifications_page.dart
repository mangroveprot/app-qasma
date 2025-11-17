import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/widgets/custom_app_bar.dart';
import '../../../../common/widgets/toast/app_toast.dart';
import '../bloc/notifications_cubit.dart';
import '../controllers/notifications_controller.dart';
import '../widgets/notifcations_list.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => NotificationsPageState();
}

class NotificationsPageState extends State<NotificationsPage> {
  late final NotificationsController controller;

  @override
  void initState() {
    super.initState();
    controller = NotificationsController();
    controller.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: controller.blocProviders,
      child: MultiBlocListener(
        listeners: [
          BlocListener<NotificationsCubit, NotificationCubitState>(
            listener: _handleNotificationsState,
          ),
        ],
        child: Scaffold(
          appBar: CustomAppBar(
            title: 'Notifications',
            onBackPressed: _handleBack,
          ),
          body: LayoutBuilder(
            builder: (context, constraints) {
              return SizedBox(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                child: NotificationsListWidget(
                  state: this,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _handleNotificationsState(
      BuildContext context, NotificationCubitState state) {
    switch (state.runtimeType) {
      case NotificationsFailureState:
        final failureState = state as NotificationsFailureState;
        AppToast.show(
          message: failureState.primaryError,
          type: ToastType.error,
        );
        break;

      case NotificationsLoadedState:
        final loadedState = state as NotificationsLoadedState;
        if (loadedState.notifications.isEmpty) {
          AppToast.show(
            message: 'You don\'t have any notifications yet!',
            type: ToastType.original,
          );
        }
        break;
    }
  }

  Future<void> _handleBack(BuildContext context) async {
    if (context.mounted) {
      final extra = GoRouterState.of(context).extra as Map<String, dynamic>?;
      final onSuccess = extra?['onSuccess'] as Function()?;

      try {
        onSuccess?.call();
      } catch (e) {
        debugPrint('Error calling success callback: $e');
      }
      context.pop();
    }
  }
}
