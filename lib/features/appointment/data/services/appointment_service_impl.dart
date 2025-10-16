import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';

import '../../../../common/error/app_error.dart';
import '../../../../common/networks/api_client.dart';
import '../../../../common/networks/response/api_response.dart';
import '../../../../core/_base/_repository/base_repository/abstract_repositories.dart';
import '../../../../core/_base/_repository/local_repository/local_repositories.dart';
import '../../../../core/_base/_services/base_service/base_service.dart';
import '../../../../core/_base/_services/storage/shared_preference.dart';
import '../../../../core/_config/url_provider.dart';
import '../../../../infrastructure/injection/service_locator.dart';
import '../../../users/data/models/params/dynamic_param.dart';
import '../../domain/services/appointment_service.dart';
import '../models/appointment_model.dart';
import '../models/params/approved_params.dart';
import '../models/params/availability_params.dart';
import '../models/params/cancel_params.dart';
import '../models/params/qr_scan_params.dart';

class AppointmentServiceImpl extends BaseService<AppointmentModel>
    implements AppointmentService {
  AppointmentServiceImpl(AbstractRepository<AppointmentModel> repository)
      : super(repository);
  final ApiClient _apiClient = sl<ApiClient>();
  final URLProviderConfig _urlProviderConfig = sl<URLProviderConfig>();
  final _logger = Logger();

  @override
  Future<Either<AppError, List<AppointmentModel>>> getAllAppointments() async {
    try {
      final allAppoitnments = await repository.getAllItems();
      return Right(allAppoitnments);
    } catch (e, stackTrace) {
      return Left(AppError.create(
        message: 'Unexpected error during fetching appointments.',
        type: ErrorType.unknown,
        originalError: e,
        stackTrace: stackTrace,
      ));
    }
  }

  @override
  Future<Either<AppError, List<AppointmentModel>>>
      getAllAppointmentByUser() async {
    final currentUserId = SharedPrefs().getString('currentUserId');

    if (currentUserId == null || currentUserId.isEmpty) {
      return Left(AppError.create(
        message: 'User ID not found',
        type: ErrorType.validation,
      ));
    }

    try {
      final response = await _apiClient
          .get('${_urlProviderConfig.getAllAppointmentByUser}/$currentUserId');

      if (response.data['success'] == true &&
          response.data['documents'] != null) {
        final List<dynamic> documentsJson =
            response.data['documents'] as List<dynamic>;

        final List<AppointmentModel> appointments = documentsJson
            .map((json) =>
                AppointmentModel.fromJson(json as Map<String, dynamic>))
            .toList();

        try {
          await repository.saveAllItems(appointments);
        } catch (e, stackTrace) {
          _logger.e('Failed to save user data locally', e, stackTrace);

          return Left(AppError.create(
            message:
                'Something went wrong while saving your data. Please contact the administrator.',
            type: ErrorType.database,
            originalError: e,
            stackTrace: stackTrace,
          ));
        }

        return Right(appointments);
      } else {
        return Left(AppError.create(
          message:
              'Failed to get appointments: ${response.data['message'] ?? 'Unknown error'}',
          type: ErrorType.server,
        ));
      }
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
  Future<Either<AppError, List<AppointmentModel>>> syncAppointments() async {
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
  Future<Either<AppError, Map<String, dynamic>>> getSlots(
      String duration) async {
    try {
      final response = await _apiClient.get(
        _urlProviderConfig.getSlots + '/${duration}',
        requiresAuth: true,
      );

      if (response.statusCode == 200) {
        final apiResponse = ApiResponse.fromJson(
          response.data,
          (json) => json,
        );

        if (apiResponse.isSuccess && apiResponse.document != null) {
          return Right(apiResponse.document!);
        } else {
          return Left(apiResponse.error ??
              AppError.create(
                message: 'Failed to fetch time slots',
                type: ErrorType.server,
              ));
        }
      } else {
        return Left(AppError.create(
          message: response.data?['message'] ?? 'Failed to fetch time slots',
          type: ErrorType.server,
        ));
      }
    } catch (e, stack) {
      final error = e is AppError
          ? e
          : AppError.create(
              message: 'Unexpected error during getting time slots',
              type: ErrorType.unknown,
              originalError: e,
              stackTrace: stack,
            );
      return Left(error);
    }
  }

  @override
  Future<Either<AppError, List<Map<String, dynamic>>>> counselorsAvailability(
      AvailabilityParams availabilityParams) async {
    try {
      final response = await _apiClient.post(
        _urlProviderConfig.counselorsAvailability,
        data: availabilityParams,
      );

      if (response.statusCode == 200) {
        final apiResponse = ApiResponse.fromJson(
          response.data,
          (json) => json,
        );

        if (apiResponse.isSuccess && apiResponse.documents != null) {
          return Right(apiResponse.documents!);
        } else {
          return Left(apiResponse.error ??
              AppError.create(
                message: 'Failed to fetch  counselors availability',
                type: ErrorType.server,
              ));
        }
      } else {
        return Left(AppError.create(
          message: response.data?['message'] ??
              'Failed to fetch counselors availability',
          type: ErrorType.server,
        ));
      }
    } catch (e, stack) {
      final error = e is AppError
          ? e
          : AppError.create(
              message:
                  'Unexpected error during getting counselors availability',
              type: ErrorType.unknown,
              originalError: e,
              stackTrace: stack,
            );
      return Left(error);
    }
  }

  @override
  Future<Either<AppError, AppointmentModel>> createNewAppointment(
      AppointmentModel model) async {
    try {
      final response = await _apiClient.post(
        _urlProviderConfig.newAppointment,
        data: model.createAppointmentToJson(),
        requiresAuth: true,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final apiResponse = ApiResponse.fromJson(
          response.data,
          (json) => AppointmentModel.fromJson(json),
        );

        try {
          if (apiResponse.document != null) {
            final localRepo = sl<LocalRepository<AppointmentModel>>();
            await localRepo.saveItem(apiResponse.document);
          } else {
            _logger.w('Document is null, skipping save operation');
          }
        } catch (e, stackTrace) {
          _logger.e('Failed to save user data locally', e, stackTrace);

          return Left(AppError.create(
            message:
                'Something went wrong while saving your data. Please contact the administrator.',
            type: ErrorType.database,
            originalError: e,
            stackTrace: stackTrace,
          ));
        }

        if (apiResponse.isSuccess && apiResponse.document != null) {
          return Right(apiResponse.document!);
        } else {
          return Left(apiResponse.error ??
              AppError.create(
                message: 'Failed to fetch appointment',
                type: ErrorType.server,
              ));
        }
      } else {
        return Left(AppError.create(
          message: response.data?['message'] ?? 'Failed to fetch appointment',
          type: ErrorType.server,
        ));
      }
    } catch (e, stack) {
      final error = e is AppError
          ? e
          : AppError.create(
              message: 'Unexpected error during creating new appointment',
              type: ErrorType.unknown,
              originalError: e,
              stackTrace: stack,
            );
      return Left(error);
    }
  }

  @override
  Future<Either<AppError, AppointmentModel>> updateAppointment(
      DynamicParam model) async {
    try {
      final response = await _apiClient.patch(
        _urlProviderConfig.updateAppointment,
        data: model.toJson(),
        requiresAuth: true,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final apiResponse = ApiResponse.fromJson(
          response.data,
          (json) => AppointmentModel.fromJson(json),
        );

        try {
          if (apiResponse.document != null) {
            final localRepo = sl<LocalRepository<AppointmentModel>>();
            await localRepo.saveItem(apiResponse.document);
          } else {
            _logger.w('Document is null, skipping update operation');
          }
        } catch (e, stackTrace) {
          _logger.e('Failed to update appointment data locally', e, stackTrace);

          return Left(AppError.create(
            message:
                'Something went wrong while updating your data. Please contact the administrator.',
            type: ErrorType.database,
            originalError: e,
            stackTrace: stackTrace,
          ));
        }

        if (apiResponse.isSuccess && apiResponse.document != null) {
          return Right(apiResponse.document!);
        } else {
          return Left(apiResponse.error ??
              AppError.create(
                message: 'Failed to update appointment',
                type: ErrorType.server,
              ));
        }
      } else {
        return Left(AppError.create(
          message: response.data?['message'] ?? 'Failed to update appointment',
          type: ErrorType.server,
        ));
      }
    } catch (e, stack) {
      final error = e is AppError
          ? e
          : AppError.create(
              message: 'Unexpected error during updating appointment',
              type: ErrorType.unknown,
              originalError: e,
              stackTrace: stack,
            );
      return Left(error);
    }
  }

  @override
  Future<Either<AppError, bool>> cancelAppointment(
      CancelParams cancelReq) async {
    try {
      final response = await _apiClient.patch(
        _urlProviderConfig.cancelAppointment,
        data: cancelReq.toJson(),
        requiresAuth: true,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final apiResponse = ApiResponse.fromJson(
          response.data,
          (json) => AppointmentModel.fromJson(json),
        );

        if (apiResponse.isSuccess) {
          return const Right(true);
        } else {
          return Left(apiResponse.error ??
              AppError.create(
                message: 'Failed to update appointment',
                type: ErrorType.server,
              ));
        }
      } else {
        return Left(AppError.create(
          message: response.data?['message'] ?? 'Failed to update appointment',
          type: ErrorType.server,
        ));
      }
    } catch (e, stack) {
      final error = e is AppError
          ? e
          : AppError.create(
              message: 'Unexpected error during updating appointment',
              type: ErrorType.unknown,
              originalError: e,
              stackTrace: stack,
            );
      return Left(error);
    }
  }

  @override
  Future<Either<AppError, bool>> approved(ApprovedParams approvedReq) async {
    try {
      final response = await _apiClient.put(
        _urlProviderConfig.acceptAppointment,
        data: approvedReq.toJson(),
        requiresAuth: true,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final apiResponse = ApiResponse.fromJson(
          response.data,
          (json) => AppointmentModel.fromJson(json),
        );

        if (apiResponse.isSuccess) {
          return const Right(true);
        } else {
          return Left(apiResponse.error ??
              AppError.create(
                message: 'Failed to approve appointment',
                type: ErrorType.server,
              ));
        }
      } else {
        return Left(AppError.create(
          message: response.data?['message'] ?? 'Failed to approve appointment',
          type: ErrorType.server,
        ));
      }
    } catch (e, stack) {
      final error = e is AppError
          ? e
          : AppError.create(
              message: 'Unexpected error during approving appointment',
              type: ErrorType.unknown,
              originalError: e,
              stackTrace: stack,
            );
      return Left(error);
    }
  }

  @override
  Future<Either<AppError, bool>> verifyAppointment(
    QRScanParams qrRequest,
  ) async {
    try {
      final response = await _apiClient.put(
        _urlProviderConfig.verifyAppointment,
        data: qrRequest.toJson(),
        requiresAuth: true,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final apiResponse = ApiResponse.fromJson(
          response.data,
          (json) => AppointmentModel.fromJson(json),
        );

        if (apiResponse.isSuccess) {
          return const Right(true);
        } else {
          return Left(apiResponse.error ??
              AppError.create(
                message: 'Failed to verify appointment',
                type: ErrorType.server,
              ));
        }
      } else {
        return Left(AppError.create(
          message: response.data?['message'] ?? 'Failed to verify appointment',
          type: ErrorType.server,
        ));
      }
    } catch (e, stack) {
      final error = e is AppError
          ? e
          : AppError.create(
              message: 'Unexpected error during verifying appointment',
              type: ErrorType.unknown,
              originalError: e,
              stackTrace: stack,
            );
      return Left(error);
    }
  }
}
