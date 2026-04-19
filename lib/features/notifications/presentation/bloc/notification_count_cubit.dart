import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../infrastructure/injection/service_locator.dart';
import '../../domain/usecases/get_notification_counts_usecase.dart';

class NotificationCountCubit extends Cubit<int> {
  NotificationCountCubit() : super(0);

  final GetNotificationCountsUsecase _getCountsUsecase =
      sl<GetNotificationCountsUsecase>();

  Future<void> refresh() async {
    final counts = await _getCountsUsecase();
    final unread = counts['unread'] ?? 0;
    emit(unread);
  }
}
