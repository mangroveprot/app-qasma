import 'package:dartz/dartz.dart';

import '../../../../core/_usecase/usecase.dart';
import '../../../../infrastructure/injection/service_locator.dart';
import '../repository/notificaiton_repository.dart';

class SyncNotificationsUsecase implements Usecase<Either, void> {
  @override
  Future<Either> call({param}) {
    return sl<NotificationRepository>().syncNotifications();
  }
}
