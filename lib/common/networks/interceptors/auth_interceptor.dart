import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../../../core/_base/_services/storage/shared_preference.dart';
import '../../../core/_config/url_provider.dart';

class AuthInterceptor extends InterceptorsWrapper {
  final Dio dio;
  final URLProviderConfig urlProvider;
  final Logger logger;
  final int maxRetries;
  final Future<bool> Function() onRefreshToken;
  final void Function(RequestOptions, ErrorInterceptorHandler) retryRequest;
  final Function()? onLogout;

  AuthInterceptor({
    required this.dio,
    required this.urlProvider,
    required this.logger,
    required this.maxRetries,
    required this.onRefreshToken,
    required this.retryRequest,
    this.onLogout,
  }) : super(
          onError: (DioException error, ErrorInterceptorHandler handler) async {
            if (error.response?.statusCode == 401) {
              final requestOptions = error.requestOptions;

              if (requestOptions.path.contains('refresh')) {
                logger.w(
                    'Refresh token request failed with 401 - tokens expired');
                onLogout?.call();
                handler.reject(error);
                return;
              }

              if (requestOptions.extra['requiresAuth'] == false) {
                handler.reject(error);
                return;
              }

              final hasAttemptedRefresh =
                  requestOptions.extra['refreshAttempted'] ?? false;

              if (!hasAttemptedRefresh) {
                logger.i('Attempting to refresh token due to 401 error');
                try {
                  final refreshSuccess = await onRefreshToken();

                  if (refreshSuccess) {
                    logger.i(
                        'Token refresh successful, retrying original request');
                    requestOptions.extra['refreshAttempted'] = true;

                    final newAccessToken =
                        SharedPrefs().getString('accessToken');
                    if (newAccessToken != null) {
                      requestOptions.headers['Authorization'] =
                          'Bearer $newAccessToken';
                    }

                    try {
                      final response = await dio.fetch(requestOptions);
                      handler.resolve(response);
                      return;
                    } catch (retryError) {
                      logger.e('Retry after token refresh failed: $retryError');
                      handler.reject(
                        retryError is DioException
                            ? retryError
                            : DioException(
                                requestOptions: requestOptions,
                                error: retryError,
                              ),
                      );
                      return;
                    }
                  } else {
                    logger.w('Token refresh failed, user needs to login again');
                    onLogout?.call();
                    handler.reject(error);
                    return;
                  }
                } catch (refreshError) {
                  logger.e('Token refresh error: $refreshError');
                  onLogout?.call();
                  handler.reject(error);
                  return;
                }
              } else {
                logger
                    .w('Already attempted refresh for this request, giving up');
                onLogout?.call();
                handler.reject(error);
                return;
              }
            }

            handler.reject(error);
          },
        );
}
