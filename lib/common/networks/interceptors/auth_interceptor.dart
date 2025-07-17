import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../../../core/_config/url_provider.dart';

class AuthInterceptor extends InterceptorsWrapper {
  final Dio dio;
  final URLProviderConfig urlProvider;
  final Logger logger;
  final int maxRetries;
  final Future<bool> Function() onRefreshToken;
  final void Function(RequestOptions, ErrorInterceptorHandler) retryRequest;
  AuthInterceptor({
    required this.dio,
    required this.urlProvider,
    required this.logger,
    required this.maxRetries,
    required this.onRefreshToken,
    required this.retryRequest,
  }) : super(
         onError: (DioException error, ErrorInterceptorHandler handler) async {
           if (error.response?.statusCode == 401) {
             final success = await onRefreshToken();
             if (success) {
               retryRequest(error.requestOptions, handler);
             } else {
               logger.e('❌ Failed to refresh token');
               handler.next(error);
             }
           } else {
             handler.next(error);
           }
         },
       );
}
