import 'package:dio/dio.dart';

import '../../../core/_config/app_config.dart';
import '../../../core/_base/_services/storage/shared_preference.dart';

class HeadersInterceptor extends InterceptorsWrapper {
  HeadersInterceptor()
      : super(
          onRequest: (options, handler) async {
            final accessToken = SharedPrefs().getString('accessToken');
            options.headers.addAll({
              ...AppConfig.headers,
              if (accessToken != null) 'Authorization': 'Bearer $accessToken',
            });
            handler.next(options);
          },
        );
}
