import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/widgets/custom_app_bar.dart';
import '../../../../common/widgets/toast/app_toast.dart';
import '../../../../infrastructure/theme/theme_extensions.dart';
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
  bool isSelectionMode = false;
  Set<String> selectedNotificationIds = {};

  @override
  void initState() {
    super.initState();
    controller = NotificationsController();
    controller.initialize();
  }

  void toggleSelectionMode() {
    setState(() {
      isSelectionMode = !isSelectionMode;
      if (!isSelectionMode) {
        selectedNotificationIds.clear();
      }
    });
  }

  void toggleSelectAll(BuildContext context) {
    final state = context.read<NotificationsCubit>().state;
    if (state is! NotificationsLoadedState) return;

    final allIds = state.notifications.map((n) => n.notificationId).toSet();

    setState(() {
      if (selectedNotificationIds.length == allIds.length &&
          allIds.isNotEmpty) {
        selectedNotificationIds.clear();
      } else {
        selectedNotificationIds = allIds;
      }
    });
  }

  void toggleNotificationSelection(String notificationId) {
    setState(() {
      if (selectedNotificationIds.contains(notificationId)) {
        selectedNotificationIds.remove(notificationId);
      } else {
        selectedNotificationIds.add(notificationId);
      }
    });
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
        child: Builder(
          builder: (context) {
            final colors = context.colors;
            final notificationState = context.watch<NotificationsCubit>().state;
            final int totalNotifications =
                notificationState is NotificationsLoadedState
                    ? notificationState.notifications.length
                    : 0;

            final bool allSelected = selectedNotificationIds.isNotEmpty &&
                totalNotifications > 0 &&
                selectedNotificationIds.length == totalNotifications;

            return Scaffold(
              appBar: CustomAppBar(
                title: isSelectionMode
                    ? '${selectedNotificationIds.length} Selected'
                    : 'Notifications',
                onBackPressed: isSelectionMode
                    ? (context) async {
                        toggleSelectionMode();
                      }
                    : _handleBack,
                actions: [
                  if (isSelectionMode)
                    IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: context.colors.error,
                        size: 26,
                      ),
                      onPressed: selectedNotificationIds.isEmpty
                          ? null
                          : () => _deleteSelectedNotifications(context),
                    )
                  else
                    IconButton(
                      icon: const Icon(Icons.delete_outline, size: 26),
                      onPressed: toggleSelectionMode,
                    ),
                ],
              ),
              body: Column(
                children: [
                  if (isSelectionMode)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(
                          left: 16, right: 26, top: 10, bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            allSelected ? 'Deselect All' : 'Select All',
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: totalNotifications == 0
                                ? null
                                : () => toggleSelectAll(context),
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: allSelected
                                      ? colors.secondary
                                      : const Color(0xFFD1D5DB),
                                  width: 2,
                                ),
                                color: allSelected
                                    ? colors.secondary
                                    : Colors.transparent,
                              ),
                              child: allSelected
                                  ? Icon(
                                      Icons.check,
                                      size: 16,
                                      color: colors.white,
                                    )
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                  Expanded(
                    child: NotificationsListWidget(
                      state: this,
                      isSelectionMode: isSelectionMode,
                      selectedNotificationIds: selectedNotificationIds,
                      onNotificationSelect: toggleNotificationSelection,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _deleteSelectedNotifications(BuildContext context) {
    if (selectedNotificationIds.isEmpty) return;

    final cubit = context.read<NotificationsCubit>();
    cubit.deleteNotifications(
      notificationIds: selectedNotificationIds.toList(),
      usecase: controller.deleteNotificationsUsecase,
    );

    setState(() {
      isSelectionMode = false;
      selectedNotificationIds.clear();
    });
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
