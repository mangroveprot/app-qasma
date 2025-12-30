import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';
import '../../../../common/error/app_error.dart';
import '../../../../common/networks/api_client.dart';
import '../../../../common/networks/response/api_response.dart';
import '../../../../common/widgets/toast/app_toast.dart';
import '../../../../core/_base/_repository/base_repository/abstract_repositories.dart';
import '../../../../core/_base/_repository/local_repository/local_repositories.dart';
import '../../../../core/_base/_services/base_service/base_service.dart';
import '../../../../core/_config/url_provider.dart';
import '../../../../infrastructure/injection/service_locator.dart';
import '../../domain/entities/notification.dart';
import '../../domain/services/notification_service.dart';
import '../models/notificaiton_model.dart';
import '../models/params/notifcations_params.dart';

class NotificationServiceImpl extends BaseService<NotificationModel>
    implements NotificationService {
  NotificationServiceImpl(AbstractRepository<NotificationModel> repository)
      : super(repository);

  final ApiClient _apiClient = sl<ApiClient>();
  final URLProviderConfig _urlProviderConfig = sl<URLProviderConfig>();
  final localRepo = sl<LocalRepository<NotificationModel>>();
  final _logger = Logger();

  @override
  Future<Either<AppError, List<Notification>>> getNotification() async {
    try {
      final response = await _apiClient
          .get(_urlProviderConfig.notificationEndPoint, requiresAuth: true);

      final apiResponse = ApiResponse.fromJson(
        response.data,
        (json) => NotificationModel.fromJson(json),
      );

      if (apiResponse.isSuccess && apiResponse.documents != null) {
        try {
          await localRepo.saveAllItems(apiResponse.documents!.toList());
        } catch (e, stackTrace) {
          _logger.e('Failed to save notification data locally', e, stackTrace);
          return Left(AppError.create(
            message:
                'Something went wrong while saving your data. Please contact the administrator.',
            type: ErrorType.database,
            originalError: e,
            stackTrace: stackTrace,
          ));
        }
        return Right(apiResponse.documents!);
      } else {
        return Left(apiResponse.error!);
      }
    } catch (e, stack) {
      final error = e is AppError
          ? e
          : AppError.create(
              message: 'Unexpected error during marking as read',
              type: ErrorType.unknown,
              originalError: e,
              stackTrace: stack,
            );
      return Left(error);
    }
  }

  @override
  Future<Either<AppError, List<Notification>>> syncNotifications() async {
    try {
      await sync();
      final response = await getAll();
      return Right(response);
    } catch (e, stack) {
      final error = e is AppError
          ? e
          : AppError.create(
              message: 'Unexpected error during getting all appointments',
              type: ErrorType.unknown,
              originalError: e,
              stackTrace: stack,
            );
      return Left(error);
    }
  }

  @override
  Future<Either<AppError, bool>> markAsRead(
      NotificationsParams notificationParams) async {
    final notificationIds = notificationParams.notificationIds;
    List<NotificationModel> originalNotifications = [];

    try {
      final notifications = await Future.wait(
        notificationIds.map((id) => localRepo.getItemById(id)),
      );

      originalNotifications =
          notifications.whereType<NotificationModel>().toList();

      if (originalNotifications.isEmpty) {
        return Left(AppError.create(
          message: 'No notifications found',
          type: ErrorType.notFound,
        ));
      }

      final url = _urlProviderConfig.addPathSegments(
        _urlProviderConfig.notificationEndPoint,
        ['read'],
      );

      final response = await _apiClient.patch(
        url,
        data: notificationParams.toJson(),
        requiresAuth: true,
      );

      final apiResponse = ApiResponse.fromJson(
        response.data,
        (json) => {'modifiedCount': json['modifiedCount']},
      );

      if (apiResponse.isSuccess) {
        final now = DateTime.now();
        final modifiedCount = apiResponse.document?['modifiedCount'] ?? 0;

        _logger.i(
            'Marked $modifiedCount of ${notificationIds.length} notifications as read');

        if (modifiedCount < notificationIds.length) {
          _logger.w(
              'Some notifications were not updated: expected ${notificationIds.length}, got $modifiedCount');
        }
        await Future.wait(
          originalNotifications.map((notification) {
            final updatedNotification = notification.copyWith(
              status: 'read',
              readAt: now,
            );
            return localRepo.saveItem(updatedNotification);
          }),
        );
        return const Right(true);
      }

      await Future.wait(
        originalNotifications
            .map((notification) => localRepo.saveItem(notification)),
      );

      return Left(apiResponse.error ??
          AppError.create(
            message: 'Failed to mark as read',
            type: ErrorType.server,
          ));
    } catch (e, stackTrace) {
      _logger.e('API failed, rolling back', e, stackTrace);

      await Future.wait(
        originalNotifications
            .map((notification) => localRepo.saveItem(notification)),
      );

      return Left(AppError.create(
        message: 'Failed to mark notifications as read',
        type: ErrorType.network,
        originalError: e,
        stackTrace: stackTrace,
      ));
    }
  }

  @override
  Future<Either<AppError, bool>> deleteNotifications(
      NotificationsParams notificationParams) async {
    final notificationIds = notificationParams.notificationIds;
    List<NotificationModel> originalNotifications = [];

    try {
      final notifications = await Future.wait(
        notificationIds.map((id) => localRepo.getItemById(id)),
      );

      originalNotifications =
          notifications.whereType<NotificationModel>().toList();

      if (originalNotifications.isEmpty) {
        return Left(AppError.create(
          message: 'No notifications found',
          type: ErrorType.notFound,
        ));
      }

      final response = await _apiClient.delete(
        _urlProviderConfig.notificationEndPoint,
        data: notificationParams.toJson(),
        requiresAuth: true,
      );

      final apiResponse = ApiResponse.fromJson(
        response.data,
        (json) => {'deletedCount': json['deletedCount']},
      );

      if (apiResponse.isSuccess) {
        final deletedCount = apiResponse.document?['deletedCount'] ?? 0;

        _logger.i(
            'Deleted $deletedCount of ${notificationIds.length} notifications');

        if (deletedCount < notificationIds.length) {
          _logger.w(
              'Some notifications were not deleted: expected ${notificationIds.length}, got $deletedCount');
        }

        await Future.wait(
          originalNotifications.map((notification) =>
              localRepo.deleteItemById(notification.notificationId)),
        );

        AppToast.show(
          message:
              'Successfully deleted $deletedCount notification${deletedCount > 1 ? 's' : ''}',
          type: ToastType.success,
        );

        return const Right(true);
      }

      return Left(apiResponse.error ??
          AppError.create(
            message: 'Failed to delete notifications',
            type: ErrorType.server,
          ));
    } catch (e, stackTrace) {
      _logger.e('API failed, no rollback needed for delete', e, stackTrace);

      return Left(AppError.create(
        message: 'Failed to delete notifications',
        type: ErrorType.network,
        originalError: e,
        stackTrace: stackTrace,
      ));
    }
  }

  @override
  Future<Map<String, int>> getNotificationCounts() async {
    try {
      final allNotifications = await localRepo.getAllItems();

      final unreadCount = allNotifications
          .where((notification) => notification.readAt == null)
          .length;

      final readCount = allNotifications
          .where((notification) => notification.readAt != null)
          .length;

      return {
        'unread': unreadCount,
        'read': readCount,
        'total': allNotifications.length,
      };
    } catch (e, stackTrace) {
      _logger.e('Failed to get notification counts', e, stackTrace);
      return {'unread': 0, 'read': 0, 'total': 0};
    }
  }
}
