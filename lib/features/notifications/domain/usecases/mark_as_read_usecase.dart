import 'package:dartz/dartz.dart';

import '../../../../core/_usecase/usecase.dart';
import '../../../../infrastructure/injection/service_locator.dart';
import '../repository/notificaiton_repository.dart';

class MarkAsReadUsecase implements Usecase<Either, String> {
  @override
  Future<Either> call({String? param}) {
    return sl<NotificationRepository>().markAsRead(param!);
  }
}
