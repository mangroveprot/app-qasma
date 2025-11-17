import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';
import '../../../../common/error/app_error.dart';
import '../../../../common/networks/api_client.dart';
import '../../../../common/networks/response/api_response.dart';
import '../../../../core/_base/_repository/base_repository/abstract_repositories.dart';
import '../../../../core/_base/_repository/local_repository/local_repositories.dart';
import '../../../../core/_base/_services/base_service/base_service.dart';
import '../../../../core/_config/url_provider.dart';
import '../../../../infrastructure/injection/service_locator.dart';
import '../../domain/entities/notification.dart';
import '../../domain/services/notification_service.dart';
import '../models/notificaiton_model.dart';

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
          await repository.saveAllItems(apiResponse.documents!.toList());
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
  Future<Either<AppError, bool>> markAsRead(String notificationId) async {
    NotificationModel? originalNotification;

    originalNotification = await localRepo.getItemById(notificationId);

    if (originalNotification == null) {
      return Left(AppError.create(
        message: 'Notification not found',
        type: ErrorType.notFound,
      ));
    }

    try {
      final url = _urlProviderConfig.addPathSegments(
        _urlProviderConfig.notificationEndPoint,
        [notificationId, 'read'],
      );

      final response = await _apiClient.patch(url, requiresAuth: true);
      final apiResponse = ApiResponse.fromJson(
        response.data,
        (json) => NotificationModel.fromJson(json),
      );

      if (apiResponse.isSuccess && apiResponse.document != null) {
        await localRepo.saveItem(apiResponse.document);
        return const Right(true);
      }

      await repository.saveItem(originalNotification);

      return Left(apiResponse.error ??
          AppError.create(
            message: 'Failed to mark as read',
            type: ErrorType.server,
          ));
    } catch (e, stackTrace) {
      _logger.e('API failed, rolling back', e, stackTrace);

      await repository.saveItem(originalNotification);

      return Left(AppError.create(
        message: 'Failed to mark notification as read',
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
