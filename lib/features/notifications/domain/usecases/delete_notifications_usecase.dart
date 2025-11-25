import 'package:dartz/dartz.dart';

import '../../../../core/_usecase/usecase.dart';
import '../../../../infrastructure/injection/service_locator.dart';
import '../../data/models/params/notifcations_params.dart';
import '../repository/notificaiton_repository.dart';

class DeleteNotificationsUsecase
    implements Usecase<Either, NotificationsParams> {
  @override
  Future<Either> call({NotificationsParams? param}) {
    return sl<NotificationRepository>().deleteNotifications(param!);
  }
}
