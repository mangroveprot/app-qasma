import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/manager/notificaitons_manager.dart';
import '../../../../infrastructure/injection/service_locator.dart';
import '../../domain/usecases/mark_as_read_usecase.dart';
import '../bloc/notifications_cubit.dart';

class NotificationsController {
  late final NotificationsCubit _notificationCubit;

  late final NotificationsManager _notificationsManager;

  late final MarkAsReadUsecase _markAsReadUsecase;

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  List<BlocProvider> get blocProviders => [
        BlocProvider<NotificationsCubit>(
          create: (context) => _notificationCubit,
        ),
      ];

  void initialize() {
    _initializeManagers();
    _initializeCubits();
    _loadInitialData();
    _initializeUsecases();
    _isInitialized = true;
  }

  void _initializeCubits() {
    _notificationCubit = NotificationsCubit();
  }

  void _initializeUsecases() {
    _markAsReadUsecase = sl<MarkAsReadUsecase>();
  }

  void _initializeManagers() {
    _notificationsManager = NotificationsManager();
  }

  void _loadInitialData() {
    loadNotificationsData(_notificationCubit);
  }

  Future<void> loadNotificationsData(NotificationsCubit cubit) async {
    await _notificationsManager.refreshNotifications(cubit);
  }

  MarkAsReadUsecase get markAsReadUsecase => _markAsReadUsecase;
}
