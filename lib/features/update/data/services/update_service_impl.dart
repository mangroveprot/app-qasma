import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';

import '../../../../common/error/app_error.dart';
import '../../../../common/networks/api_client.dart';
import '../../../../core/_base/_services/package_info/package_info_service.dart';
import '../../../../core/_config/app_config.dart';
import '../../../../infrastructure/injection/service_locator.dart';
import '../../domain/services/update_service.dart';
import '../models/github_release_model.dart';
import '../models/release_info_model.dart';
import '../utils/release_parser.dart';

class CachedReleaseData {
  final ReleaseInfoModel data;
  final DateTime timestamp;
  final String owner;
  final String repo;

  CachedReleaseData({
    required this.data,
    required this.timestamp,
    required this.owner,
    required this.repo,
  });
}

class UpdateServiceImpl implements UpdateService {
  final ApiClient _apiClient = sl<ApiClient>();
  final _logger = Logger();

  static const Duration cacheDuration = Duration(minutes: 30);
  static CachedReleaseData? _cachedReleaseData;

  final String githubOwner = AppConfig.githubOwner;
  final String githubRepo = AppConfig.githubRepo;

  @override
  Future<Either<AppError, GitHubReleaseModel>> getLatestRelease({
    bool bypassCache = false,
  }) async {
    try {
      final url =
          'https://api.github.com/repos/$githubOwner/$githubRepo/releases';

      final response = await _apiClient.get(url, requiresAuth: false);

      if (response.data == null || (response.data as List).isEmpty) {
        return Left(AppError.create(
          message: 'No releases found',
          type: ErrorType.notFound,
        ));
      }

      final releases = response.data as List<dynamic>;
      final latestRelease = GitHubReleaseModel.fromJson(
        releases[0] as Map<String, dynamic>,
      );

      return Right(latestRelease);
    } catch (e, stack) {
      _logger.e('Failed to fetch GitHub release', e, stack);

      final error = e is AppError
          ? e
          : AppError.create(
              message: 'Failed to fetch release information',
              type: ErrorType.network,
              originalError: e,
              stackTrace: stack,
            );
      return Left(error);
    }
  }

  @override
  Future<Either<AppError, ReleaseInfoModel>> fetchLatestRelease({
    bool bypassCache = false,
  }) async {
    try {
      final now = DateTime.now();
      final isCacheValid = !bypassCache &&
          _cachedReleaseData != null &&
          _cachedReleaseData!.owner == githubOwner &&
          _cachedReleaseData!.repo == githubRepo &&
          now.difference(_cachedReleaseData!.timestamp) < cacheDuration;

      if (isCacheValid) {
        return Right(_cachedReleaseData!.data);
      }

      final releaseResult = await getLatestRelease();

      return releaseResult.fold(
        (error) {
          if (_cachedReleaseData != null &&
              _cachedReleaseData!.owner == githubOwner &&
              _cachedReleaseData!.repo == githubRepo) {
            _logger.w('Using stale cache due to fetch error');
            return Right(_cachedReleaseData!.data);
          }
          return Left(error);
        },
        (release) {
          final parsedInfo = ReleaseParser.parseRelease(release);

          _cachedReleaseData = CachedReleaseData(
            data: parsedInfo,
            timestamp: now,
            owner: githubOwner,
            repo: githubRepo,
          );

          return Right(parsedInfo);
        },
      );
    } catch (e, stack) {
      _logger.e('Unexpected error fetching release', e, stack);

      final error = AppError.create(
        message: 'Unexpected error checking for updates',
        type: ErrorType.unknown,
        originalError: e,
        stackTrace: stack,
      );
      return Left(error);
    }
  }

  @override
  Future<Either<AppError, bool>> isUpdateAvailable() async {
    try {
      final packageInfo = sl<PackageInfoService>();
      final currentVersion =
          ReleaseParser.normalizeVersion(packageInfo.version);
      final currentBuild = packageInfo.buildNumber;

      final latestReleaseResult = await fetchLatestRelease();

      return latestReleaseResult.fold(
        (error) => Left(error),
        (latestRelease) {
          final isVersionNewer = _compareVersions(
                latestRelease.version,
                currentVersion,
              ) >
              0;

          final isBuildNewer = int.tryParse(latestRelease.buildNumber) !=
                  null &&
              int.tryParse(currentBuild) != null &&
              int.parse(latestRelease.buildNumber) > int.parse(currentBuild);

          return Right(isVersionNewer || isBuildNewer);
        },
      );
    } catch (e, stack) {
      _logger.e('Error checking for updates', e, stack);

      final error = AppError.create(
        message: 'Failed to check for updates',
        type: ErrorType.unknown,
        originalError: e,
        stackTrace: stack,
      );
      return Left(error);
    }
  }

  @override
  Future<Either<AppError, Map<String, dynamic>>> getUpdateInfo() async {
    try {
      final packageInfo = sl<PackageInfoService>();
      final currentVersion =
          ReleaseParser.normalizeVersion(packageInfo.version);
      final currentBuild = packageInfo.buildNumber;

      _logger
          .d('Package Info - Version: $currentVersion, Build: $currentBuild');

      final latestReleaseResult = await fetchLatestRelease();

      return latestReleaseResult.fold(
        (error) {
          _logger.e('Failed to fetch latest release: ${error.message}');
          return Left(error);
        },
        (latestRelease) async {
          _logger.d(
              'Latest Release - Version: ${latestRelease.version}, Build: ${latestRelease.buildNumber}');

          final hasUpdateResult = await isUpdateAvailable();

          return hasUpdateResult.fold(
            (error) {
              _logger
                  .e('Failed to check if update available: ${error.message}');
              return Left(error);
            },
            (hasUpdate) {
              final isMandatory = currentVersion != latestRelease.version;

              _logger.d('Update check: current=$currentVersion+$currentBuild, '
                  'latest=${latestRelease.version}+${latestRelease.buildNumber}, '
                  'mandatory=$isMandatory, hasUpdate=$hasUpdate');

              final resultMap = {
                'hasUpdate': hasUpdate,
                'currentVersion': currentVersion,
                'currentBuild': currentBuild,
                'latestVersion': latestRelease.version,
                'latestBuild': latestRelease.buildNumber,
                'isMandatory': isMandatory,
                'releaseInfo': latestRelease.copyWith(isMandatory: isMandatory),
                'releaseNotes': latestRelease.releaseNotes,
                'publishedAt': latestRelease.publishedAt,
              };

              return Right(resultMap);
            },
          );
        },
      );
    } catch (e, stack) {
      _logger.e('Error getting update info', e, stack);

      final error = AppError.create(
        message: 'Failed to get update information',
        type: ErrorType.unknown,
        originalError: e,
        stackTrace: stack,
      );
      return Left(error);
    }
  }

  int _compareVersions(String v1, String v2) {
    final parts1 = v1.split('.').map((e) => int.tryParse(e) ?? 0).toList();
    final parts2 = v2.split('.').map((e) => int.tryParse(e) ?? 0).toList();

    final maxLength =
        parts1.length > parts2.length ? parts1.length : parts2.length;

    for (int i = 0; i < maxLength; i++) {
      final p1 = i < parts1.length ? parts1[i] : 0;
      final p2 = i < parts2.length ? parts2[i] : 0;

      if (p1 > p2) return 1;
      if (p1 < p2) return -1;
    }

    return 0;
  }
}
