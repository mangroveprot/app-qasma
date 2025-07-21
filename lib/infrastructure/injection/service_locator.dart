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
  // Core / Configs
  sl.registerLazySingleton<AppConfig>(() => AppConfig());
  sl.registerLazySingleton<URLProviderConfig>(() => URLProviderConfig());

  // Logger
  sl.registerLazySingleton<Logger>(() => Logger());

  // Network
  sl.registerLazySingleton<ApiClient>(() => ApiClient());

  // Services
  sl.registerLazySingleton<DatabaseService>(
    () => DatabaseService([UserTableModel()]),
  );

  sl.registerLazySingleton<AuthService>(
    () => AuthServiceImpl(sl<AbstractRepository<UserModel>>()),
  );

  sl.registerLazySingleton<UserService>(
    () => UserServiceImpl(sl<AbstractRepository<UserModel>>()),
  );

  // Repositories
  sl.registerLazySingleton<LocalRepository<UserModel>>(
    () => LocalRepository<UserModel>(
      tableName: 'users',
      keyField: 'idNumber',
      fromDb: (map) => UserModel.fromDb(map),
      toDb: (user) => user.toDb(),
      databaseService: sl<DatabaseService>(),
      logger: sl<Logger>(),
    ),
  );

  sl.registerLazySingleton<AbstractRepository<UserModel>>(
    () => RemoteRepository<UserModel>(
      localRepository: sl<LocalRepository<UserModel>>(),
      endpoint: '/user',
      fromJson: (map) => UserModel.fromJson(map),
      toJson: (user) => user.toJson(),
      getId: (model) => model.idNumber,
      getItemPath: (id) => '/user/getUserById/$id',
      deletePath: (id) => '/user/delete/$id',
      syncField: SyncField<UserModel>(
        name: 'updateAt',
        accessor: (user) => user.updatedAt,
      ),
    ),
  );

  //auth repo
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());

  // user repo
  sl.registerLazySingleton<UserRepository>(() => UserRepositoryImpl());

  //==== usecases=====

  // AUTH
  sl.registerLazySingleton<SigninUsecase>(() => SigninUsecase());
  sl.registerLazySingleton<SignupUsecase>(() => SignupUsecase());

  // USER
  sl.registerLazySingleton<IsRegisterUsecase>(() => IsRegisterUsecase());
}
