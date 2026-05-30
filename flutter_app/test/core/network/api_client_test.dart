import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/core/config/app_environment.dart';
import 'package:vit_trade_flutter/core/network/api_client.dart';

void main() {
  AppConfig config() {
    return AppConfig(
      environment: AppEnvironment.staging,
      apiBaseUrl: Uri.parse('https://staging-api.vittrade.example'),
      enableMockData: false,
    );
  }

  test('ApiClient configures explicit Dio defaults', () {
    final client = ApiClient(config: config());
    final options = client.dio.options;

    expect(options.baseUrl, 'https://staging-api.vittrade.example');
    expect(options.connectTimeout, ApiClient.defaultConnectTimeout);
    expect(options.sendTimeout, ApiClient.defaultSendTimeout);
    expect(options.receiveTimeout, ApiClient.defaultReceiveTimeout);
    expect(options.responseType, ResponseType.json);
    expect(options.contentType, Headers.jsonContentType);
    expect(options.headers['Accept'], 'application/json');
    expect(options.validateStatus(200), isTrue);
    expect(options.validateStatus(302), isFalse);
    expect(options.validateStatus(500), isFalse);
  });

  test('ApiClient preserves injected Dio instance for tests', () {
    final dio = Dio(BaseOptions(baseUrl: 'https://custom.example'));
    final client = ApiClient(config: config(), dio: dio);

    expect(identical(client.dio, dio), isTrue);
    expect(client.dio.options.baseUrl, 'https://custom.example');
  });
}
