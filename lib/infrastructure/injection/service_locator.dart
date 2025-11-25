import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

import '../../common/data/repository/common_repositories_impl.dart';
import '../../common/domain/repository/common_repositories.dart';
import '../../common/domain/services/master_list_report_service.dart';
import '../../common/domain/usecases/GenerateMasterListReportUsecase.dart';
import '../../common/networks/api_client.dart';
import '../../common/data/services/master_list_report_service_impl.dart';
import '../../core/_base/_models/sync_model.dart';
import '../../core/_base/_repository/base_repository/abstract_repositories.dart';
import '../../core/_base/_repository/remote_repository/remote_reposiories.dart';
import '../../core/_base/_repository/local_repository/local_repositories.dart';
import '../../core/_base/_services/db/database_service.dart';
import '../../core/_base/_services/fcm/fcm_service.dart';
import '../../core/_base/_services/package_info/package_info_service.dart';
import '../../core/_config/app_config.dart';
import '../../core/_config/url_provider.dart';
import '../../features/appointment/data/models/appointment_model.dart';
import '../../features/appointment/data/models/appointment_table_model.dart';
import '../../features/appointment/data/repository/appointment_repositories_impl.dart';
import '../../features/appointment/data/services/appointment_service_impl.dart';
import '../../features/appointment/domain/repository/appointment_repositories.dart';
import '../../features/appointment/domain/services/appointment_service.dart';
import '../../features/appointment/domain/usecases/approved_appointment_usecase.dart';
import '../../features/appointment/domain/usecases/cancel_appointment_usecase.dart';
import '../../features/appointment/domain/usecases/counselors_availability_usecase.dart';
import '../../features/appointment/domain/usecases/create_new_appointment_usecase.dart';
import '../../features/appointment/domain/usecases/get_slots_usecase.dart';
import '../../features/appointment/domain/usecases/getall_appointments_by_user_usecase.dart';
import '../../features/appointment/domain/usecases/getall_appointments_usecase.dart';
import '../../features/appointment/domain/usecases/sync_appointments_usecase.dart';
import '../../features/appointment/domain/usecases/update_appointment_usecase.dart';
import '../../features/appointment/domain/usecases/verify_appointment_usecase.dart';
import '../../features/appointment_config/data/models/appointment_config_model.dart';
import '../../features/appointment_config/data/models/appointment_config_table_model.dart';
import '../../features/appointment_config/data/repository/appointment_config_repositories_impl.dart';
import '../../features/appointment_config/data/services/appointment_config_service_impl.dart';
import '../../features/appointment_config/domain/repository/appointment_config_repositories.dart';
import '../../features/appointment_config/domain/services/appointment_config_services.dart';
import '../../features/appointment_config/domain/usecases/get_config_usecase.dart';
import '../../features/appointment_config/domain/usecases/sync_config_usecase.dart';
import '../../features/appointment_config/domain/usecases/update_config_uscase.dart';
import '../../features/auth/domain/services/auth_service.dart';
import '../../features/auth/domain/usecases/change_password_usecase.dart';
import '../../features/auth/domain/usecases/forgot_password_usecase.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/auth/domain/usecases/resend_otp_usecase.dart';
import '../../features/auth/domain/usecases/reset_password_usecase.dart';
import '../../features/auth/domain/usecases/signin_usecase.dart';
import '../../features/auth/domain/usecases/signup_usecase.dart';
import '../../features/auth/domain/usecases/verify_usecase.dart';
import '../../features/notifications/data/models/notificaiton_model.dart';
import '../../features/notifications/data/models/notification_table_model.dart';
import '../../features/notifications/data/repository/notification_repository_impl.dart';
import '../../features/notifications/data/services/notification_service_impl.dart';
import '../../features/notifications/domain/repository/notificaiton_repository.dart';
import '../../features/notifications/domain/services/notification_service.dart';
import '../../features/notifications/domain/usecases/delete_notifications_usecase.dart';
import '../../features/notifications/domain/usecases/get_notification_counts_usecase.dart';
import '../../features/notifications/domain/usecases/get_notification_usecase.dart';
import '../../features/notifications/domain/usecases/mark_as_read_usecase.dart';
import '../../features/notifications/domain/usecases/sync_notification_usecase.dart';
import '../../features/update/data/repository/update_repository_impl.dart';
import '../../features/update/data/services/update_service_impl.dart';
import '../../features/update/domain/repository/update_repository.dart';
import '../../features/update/domain/services/update_service.dart';
import '../../features/update/domain/usecases/check_update_usecase.dart';
import '../../features/update/domain/usecases/fetch_latest_usecase.dart';
import '../../features/update/domain/usecases/is_update_available_usecase.dart';
import '../../features/users/data/models/user_model.dart';
import '../../features/auth/data/repository/auth_impl_repositories.dart';
import '../../features/auth/data/services/auth_service_impl.dart';
import '../../features/auth/domain/repository/auth_repositories.dart';
import '../../features/users/data/models/user_table_model.dart';
import '../../features/users/data/repository/user_repositories_impl.dart';
import '../../features/users/data/services/user_service_impl.dart';
import '../../features/users/domain/repository/user_repositories.dart';
import '../../features/users/domain/services/user_service.dart';
import '../../features/users/domain/usecases/get_all_user_usecase.dart';
import '../../features/users/domain/usecases/get_user_usecase.dart';
import '../../features/users/domain/usecases/is_register_usecase.dart';
import '../../features/users/domain/usecases/save_fcm_token_usecase.dart';
import '../../features/users/domain/usecases/sync_user_usecase.dart';
import '../../features/users/domain/usecases/update_user_usecase.dart';

final sl = GetIt.instance;

void setupServiceLocator() {
  _registerCore();
  _registerInfrastructure();
  _registerRepositories();
  _registerServices();
  _registerUseCases();
  _registerAppointmentConfigRepositories();
  _registerNotificationRepositories();
}

void _registerCore() {
  sl
    ..registerLazySingleton<AppConfig>(() => AppConfig())
    ..registerLazySingleton<URLProviderConfig>(() => URLProviderConfig())
    ..registerLazySingleton<Logger>(() => Logger())
    ..registerLazySingleton<FCMService>(() => FCMService());
}

void _registerInfrastructure() {
  sl
    ..registerLazySingleton<PackageInfoService>(() => PackageInfoService())
    ..registerLazySingleton<ApiClient>(() => ApiClient())
    ..registerLazySingleton<DatabaseService>(
      () => DatabaseService([
        UserTableModel(),
        AppointmentTableModel(),
        AppointmentConfigTableModel(),
        NotificationTableModel(),
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

  // User repository
  sl.registerLazySingleton<UserRepository>(() => UserRepositoryImpl());

  // Common repository
  sl.registerLazySingleton<CommonRepository>(() => CommonRepositoryImpl());

  // Appointment repository
  sl.registerLazySingleton<AppointmentRepository>(
    () => AppointmentRepositoryImpl(),
  );

  // Appointment Config repository
  sl.registerLazySingleton<AppointmentConfigRepository>(
    () => AppointmentConfigRepositoryImpl(),
  );

  // App update repository
  sl.registerLazySingleton<UpdateRepository>(
    () => UpdateRepositoryImpl(),
  );

  // Notification repository
  sl.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(),
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
    ),
  );

  // Abstract repository for User (Remote)
  sl.registerLazySingleton<AbstractRepository<UserModel>>(
    () => RemoteRepository<UserModel>(
      localRepository: sl<LocalRepository<UserModel>>(),
      endpoint: '/api/user',
      fromJson: UserModel.fromJson,
      toJson: (user) => user.toJson(),
      getId: (model) => model.idNumber,
      getItemPath: (id) => '/api/user/getProfile',
      deletePath: (id) => '/api/user/delete/$id',
      includeId: false,
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
    ),
  );

  sl.registerLazySingleton<AbstractRepository<AppointmentModel>>(
    () => RemoteRepository<AppointmentModel>(
      localRepository: sl<LocalRepository<AppointmentModel>>(),
      endpoint: '/api/appointment',
      fromJson: AppointmentModel.fromJson,
      toJson: (appointment) => appointment.toJson(),
      getId: (model) => model.appointmentId,
      getItemPath: (id) => '/getAppointmentById',
      deletePath: (id) => '/cancel/',
      includeId: false,
      syncField: SyncField<AppointmentModel>(
        name: 'updatedAt',
        accessor: (appointment) => appointment.updatedAt,
      ),
    ),
  );
}

void _registerAppointmentConfigRepositories() {
  sl.registerLazySingleton<LocalRepository<AppointmentConfigModel>>(
    () => LocalRepository<AppointmentConfigModel>(
      tableName: 'appointment_configs',
      keyField: 'configId',
      fromDb: AppointmentConfigModel.fromDb,
      toDb: (config) => config.toDb(),
      databaseService: sl<DatabaseService>(),
    ),
  );

  sl.registerLazySingleton<AbstractRepository<AppointmentConfigModel>>(
    () => RemoteRepository<AppointmentConfigModel>(
      localRepository: sl<LocalRepository<AppointmentConfigModel>>(),
      endpoint: '/api/config',
      fromJson: AppointmentConfigModel.fromJson,
      toJson: (config) => config.toJson(),
      getId: (model) => model.configId!,
      getItemPath: (id) => '/',
      deletePath: (id) => '/cancel/',
      includeId: false,
      syncField: SyncField<AppointmentConfigModel>(
        name: 'updatedAt',
        accessor: (config) => config.updatedAt,
      ),
    ),
  );
}

void _registerNotificationRepositories() {
  sl.registerLazySingleton<LocalRepository<NotificationModel>>(
    () => LocalRepository<NotificationModel>(
      tableName: 'notifications',
      keyField: 'notificationId',
      fromDb: NotificationModel.fromDb,
      toDb: (notification) => notification.toDb(),
      databaseService: sl<DatabaseService>(),
    ),
  );

  sl.registerLazySingleton<AbstractRepository<NotificationModel>>(
    () => RemoteRepository<NotificationModel>(
      localRepository: sl<LocalRepository<NotificationModel>>(),
      endpoint: '/api/notifications',
      fromJson: NotificationModel.fromJson,
      toJson: (notification) => notification.toJson(),
      getId: (model) => model.notificationId,
      getItemPath: (id) => '/$id',
      deletePath: (id) => '/$id',
      includeId: true,
      syncField: SyncField<NotificationModel>(
        name: 'updatedAt',
        accessor: (notification) => notification.updatedAt,
      ),
    ),
  );
}

void _registerServices() {
  sl
    ..registerLazySingleton<MasterlistReportService>(
      () => MasterlistReportServiceImpl(),
    )
    ..registerLazySingleton<AuthService>(
      () => AuthServiceImpl(sl<AbstractRepository<UserModel>>()),
    )
    ..registerLazySingleton<UserService>(
      () => UserServiceImpl(sl<AbstractRepository<UserModel>>()),
    )
    ..registerLazySingleton<AppointmentService>(
      () => AppointmentServiceImpl(sl<AbstractRepository<AppointmentModel>>()),
    )
    ..registerLazySingleton<AppointmentConfigService>(
      () => AppointmentConfigServiceImpl(
          sl<AbstractRepository<AppointmentConfigModel>>()),
    )
    ..registerLazySingleton<UpdateService>(() => UpdateServiceImpl())
    ..registerLazySingleton<NotificationService>(() =>
        NotificationServiceImpl(sl<AbstractRepository<NotificationModel>>()));
}

void _registerUseCases() {
  // Auth use cases
  sl
    ..registerLazySingleton<SigninUsecase>(() => SigninUsecase())
    ..registerLazySingleton<SignupUsecase>(() => SignupUsecase())
    ..registerLazySingleton<ResendOTPUsecase>(() => ResendOTPUsecase())
    ..registerLazySingleton<ResetPasswordUsecase>(() => ResetPasswordUsecase())
    ..registerLazySingleton<ChangePasswordUsecase>(
        () => ChangePasswordUsecase())
    ..registerLazySingleton<LogoutUsecase>(() => LogoutUsecase())
    ..registerLazySingleton<ForgotPasswordUsecase>(
        () => ForgotPasswordUsecase())
    ..registerLazySingleton<VerifyUsecase>(() => VerifyUsecase());

  // User use cases
  sl
    ..registerLazySingleton<SaveFcmTokenUsecase>(() => SaveFcmTokenUsecase())
    ..registerLazySingleton<GetAllUserUsecase>(() => GetAllUserUsecase())
    ..registerLazySingleton<SyncUserUsecase>(() => SyncUserUsecase())
    ..registerLazySingleton<UpdateUserUsecase>(() => UpdateUserUsecase())
    ..registerLazySingleton<IsRegisterUsecase>(() => IsRegisterUsecase())
    ..registerLazySingleton<GetUserUsecase>(() => GetUserUsecase());

  // Appointment use cases
  sl
    ..registerLazySingleton<VerifyAppointmentUsecase>(
        () => VerifyAppointmentUsecase())
    ..registerLazySingleton<ApprovedAppointmentUsecase>(
        () => ApprovedAppointmentUsecase())
    ..registerLazySingleton<CancelAppointmentUsecase>(
        () => CancelAppointmentUsecase())
    ..registerLazySingleton<GetAllAppointmentsUsecase>(
        () => GetAllAppointmentsUsecase())
    ..registerLazySingleton<GetAllAppointmentByUserUsecase>(
        () => GetAllAppointmentByUserUsecase())
    ..registerLazySingleton<SyncAppointmentsUsecase>(
        () => SyncAppointmentsUsecase())
    ..registerLazySingleton<GetSlotsUseCase>(() => GetSlotsUseCase())
    ..registerLazySingleton<CounselorsAvailabilityUsecase>(
        () => CounselorsAvailabilityUsecase())
    ..registerLazySingleton<UpdateAppointmentUsecase>(
        () => UpdateAppointmentUsecase())
    ..registerLazySingleton<CreateNewAppointmentUsecase>(
        () => CreateNewAppointmentUsecase());

  // Appointment config use cases
  sl
    ..registerLazySingleton<UpdateConfigUsecase>(() => UpdateConfigUsecase())
    ..registerLazySingleton<GetConfigUseCase>(() => GetConfigUseCase())
    ..registerLazySingleton<SyncConfigUsecase>(() => SyncConfigUsecase());

  // Common use cases
  sl
    ..registerLazySingleton<GenerateMasterListReportUsecase>(
        () => GenerateMasterListReportUsecase());

  // App update use cases
  sl
    ..registerLazySingleton<CheckUpdateUsecase>(() => CheckUpdateUsecase())
    ..registerLazySingleton<FetchLatestReleaseUsecase>(
        () => FetchLatestReleaseUsecase())
    ..registerLazySingleton<IsUpdateAvailableUsecase>(
        () => IsUpdateAvailableUsecase());

  // Notification use cases
  sl
    ..registerLazySingleton<GetNotificationCountsUsecase>(
        () => GetNotificationCountsUsecase())
    ..registerLazySingleton<GetNotificationUsecase>(
        () => GetNotificationUsecase())
    ..registerLazySingleton<MarkAsReadUsecase>(() => MarkAsReadUsecase())
    ..registerLazySingleton<DeleteNotificationsUsecase>(
        () => DeleteNotificationsUsecase())
    ..registerLazySingleton<SyncNotificationsUsecase>(
        () => SyncNotificationsUsecase());
}
