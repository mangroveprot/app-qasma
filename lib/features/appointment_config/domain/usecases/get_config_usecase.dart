import '../../../../core/_usecase/usecase.dart';
import '../../../../infrastructure/injection/service_locator.dart';
import '../repository/appointment_config_repositories.dart';

class GetConfigUseCase implements Usecase {
  @override
  Future call({param}) {
    return sl<AppointmentConfigRepository>().getConfig();
  }
}
