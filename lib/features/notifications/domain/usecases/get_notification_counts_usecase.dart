import '../../../../core/_usecase/usecase.dart';
import '../../../../infrastructure/injection/service_locator.dart';
import '../repository/notificaiton_repository.dart';

class GetNotificationCountsUsecase implements Usecase<void, Map<String, int>> {
  @override
  Future<Map<String, int>> call({void param}) {
    return sl<NotificationRepository>().getNotificationCounts();
  }
}
