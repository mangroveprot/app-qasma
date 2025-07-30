import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

import '../../common/networks/api_client.dart';
import '../../core/_base/_models/sync_model.dart';
import '../../core/_base/_repository/base_repository/abstract_repositories.dart';
import '../../core/_base/_repository/remote_repository/remote_reposiories.dart';
import '../../core/_base/_repository/local_repository/local_repositories.dart';
import '../../core/_base/_services/db/database_service.dart';
import '../../core/_config/app_config.dart';
import '../../core/_config/url_provider.dart';
import '../../features/appointment/data/models/appointment_model.dart';
import '../../features/appointment/data/models/appointment_table_model.dart';
import '../../features/appointment/data/repository/appointment_repositories_impl.dart';
import '../../features/appointment/data/services/appointment_service_impl.dart';
import '../../features/appointment/domain/repository/appointment_repositories.dart';
import '../../features/appointment/domain/services/appointment_service.dart';
import '../../features/appointment/domain/usecases/getall_appointments_usecase.dart';
import '../../features/auth/domain/services/auth_service.dart';
import '../../features/auth/domain/usecases/signin_usecase.dart';
import '../../features/auth/domain/usecases/signup_usecase.dart';
import '../../features/users/data/models/user_model.dart';
import '../../features/auth/data/repository/auth_impl_repositories.dart';
import '../../features/auth/data/services/auth_service_impl.dart';
import '../../features/auth/domain/repository/auth_repositories.dart';
import '../../features/users/data/models/user_table_model.dart';
import '../../features/users/data/repository/user_repositories_impl.dart';
import '../../features/users/data/services/user_service_impl.dart';
import '../../features/users/domain/repository/auth_repositories.dart';
import '../../features/users/domain/services/user_service.dart';
import '../../features/users/domain/usecases/is_register_usecase.dart';

final sl = GetIt.instance;

void setupServiceLocator() {
  _registerCore();
  _registerInfrastructure();
  _registerRepositories();
  _registerServices();
  _registerUseCases();
}

void _registerCore() {
  sl
    ..registerLazySingleton<AppConfig>(() => AppConfig())
    ..registerLazySingleton<URLProviderConfig>(() => URLProviderConfig())
    ..registerLazySingleton<Logger>(() => Logger());
}

void _registerInfrastructure() {
  sl
    ..registerLazySingleton<ApiClient>(() => ApiClient())
    ..registerLazySingleton<DatabaseService>(
      () => DatabaseService([
        UserTableModel(),
        AppointmentTableModel(),
      ]),
    );
}

void _registerRepositories() {
  // User repositories
  _registerUserRepositories();

  // Appointment repositories
  _registerAppointmentRepositories();

  // Auth repositories
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());

  // User domain repository
  sl.registerLazySingleton<UserRepository>(() => UserRepositoryImpl());

  // Appointment repository
  sl.registerLazySingleton<AppointmentRepository>(
    () => AppointmentRepositoryImpl(),
  );
}

void _registerUserRepositories() {
  // Local repository for User
  sl.registerLazySingleton<LocalRepository<UserModel>>(
    () => LocalRepository<UserModel>(
      tableName: 'users',
      keyField: 'idNumber',
      fromDb: UserModel.fromDb,
      toDb: (user) => user.toDb(),
      databaseService: sl<DatabaseService>(),
      logger: sl<Logger>(),
    ),
  );

  // Abstract repository for User (Remote)
  sl.registerLazySingleton<AbstractRepository<UserModel>>(
    () => RemoteRepository<UserModel>(
      localRepository: sl<LocalRepository<UserModel>>(),
      endpoint: '/user',
      fromJson: UserModel.fromJson,
      toJson: (user) => user.toJson(),
      getId: (model) => model.idNumber,
      getItemPath: (id) => '/getUserById/$id',
      deletePath: (id) => '/delete/$id',
      syncField: SyncField<UserModel>(
        name: 'updateAt',
        accessor: (user) => user.updatedAt,
      ),
    ),
  );
}

void _registerAppointmentRepositories() {
  sl.registerLazySingleton<LocalRepository<AppointmentModel>>(
    () => LocalRepository<AppointmentModel>(
      tableName: 'appointments',
      keyField: 'appointmentId',
      fromDb: AppointmentModel.fromDb,
      toDb: (appointment) => appointment.toDb(),
      databaseService: sl<DatabaseService>(),
      logger: sl<Logger>(),
    ),
  );

  sl.registerLazySingleton<AbstractRepository<AppointmentModel>>(
    () => RemoteRepository<AppointmentModel>(
      localRepository: sl<LocalRepository<AppointmentModel>>(),
      endpoint: '/api/appointment',
      fromJson: AppointmentModel.fromJson,
      toJson: (appointment) => appointment.toJson(),
      getId: (model) => model.appointmentId,
      getItemPath: (id) => '/getAppointmentById/$id',
      deletePath: (id) => '/cancel/$id',
      syncField: SyncField<AppointmentModel>(
        name: 'updatedAt',
        accessor: (appointment) => appointment.updatedAt,
      ),
    ),
  );
}

void _registerServices() {
  sl
    ..registerLazySingleton<AuthService>(
      () => AuthServiceImpl(sl<AbstractRepository<UserModel>>()),
    )
    ..registerLazySingleton<UserService>(
      () => UserServiceImpl(sl<AbstractRepository<UserModel>>()),
    )
    ..registerLazySingleton<AppointmentService>(
      () => AppointmentServiceImpl(sl<AbstractRepository<AppointmentModel>>()),
    );
}

void _registerUseCases() {
  // Auth use cases
  sl
    ..registerLazySingleton<SigninUsecase>(() => SigninUsecase())
    ..registerLazySingleton<SignupUsecase>(() => SignupUsecase());

  // User use cases
  sl.registerLazySingleton<IsRegisterUsecase>(() => IsRegisterUsecase());

  // Appointment usecases
  sl.registerLazySingleton<GetAllAppointmentUsecase>(
      () => GetAllAppointmentUsecase());
}
