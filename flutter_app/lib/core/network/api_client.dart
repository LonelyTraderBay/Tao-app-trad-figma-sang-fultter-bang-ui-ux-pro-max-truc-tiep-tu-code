import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/core/config/app_environment.dart';

final appConfigProvider = Provider<AppConfig>((ref) => AppConfig.current);

final apiClientProvider = Provider<ApiClient>(
  (ref) => ApiClient(config: ref.watch(appConfigProvider)),
);

final class ApiClient {
  static const defaultConnectTimeout = Duration(seconds: 10);
  static const defaultSendTimeout = Duration(seconds: 15);
  static const defaultReceiveTimeout = Duration(seconds: 20);

  ApiClient({required AppConfig config, Dio? dio})
    : dio = dio ?? Dio(_baseOptions(config));

  final Dio dio;

  static BaseOptions _baseOptions(AppConfig config) {
    return BaseOptions(
      baseUrl: config.apiBaseUrl.toString(),
      connectTimeout: defaultConnectTimeout,
      sendTimeout: defaultSendTimeout,
      receiveTimeout: defaultReceiveTimeout,
      responseType: ResponseType.json,
      contentType: Headers.jsonContentType,
      headers: const {'Accept': 'application/json'},
      validateStatus: (status) =>
          status != null && status >= 200 && status < 300,
    );
  }
}
