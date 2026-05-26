import 'package:dio/dio.dart';

import 'package:vit_trade_flutter/core/config/app_environment.dart';

final class ApiClient {
  ApiClient({required AppConfig config, Dio? dio})
    : dio = dio ?? Dio(BaseOptions(baseUrl: config.apiBaseUrl.toString()));

  final Dio dio;
}
