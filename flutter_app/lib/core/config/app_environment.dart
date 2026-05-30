enum AppEnvironment { development, staging, production }

final class AppConfig {
  const AppConfig({
    required this.environment,
    required this.apiBaseUrl,
    this.enableMockData = true,
  });

  final AppEnvironment environment;
  final Uri apiBaseUrl;
  final bool enableMockData;

  bool get isProduction => environment == AppEnvironment.production;

  static final AppConfig local = AppConfig(
    environment: AppEnvironment.development,
    apiBaseUrl: Uri.parse('https://api.vittrade.local'),
  );

  static final AppConfig current = AppConfig.fromDartDefines();

  factory AppConfig.fromDartDefines({
    String environmentName = const String.fromEnvironment(
      'APP_ENV',
      defaultValue: 'development',
    ),
    String apiBaseUrl = const String.fromEnvironment(
      'API_BASE_URL',
      defaultValue: 'https://api.vittrade.local',
    ),
    String enableMockData = const String.fromEnvironment('ENABLE_MOCK_DATA'),
  }) {
    final environment = parseEnvironment(environmentName);
    return AppConfig(
      environment: environment,
      apiBaseUrl: Uri.parse(apiBaseUrl),
      enableMockData: parseMockDataFlag(
        enableMockData,
        environment: environment,
      ),
    );
  }

  static AppEnvironment parseEnvironment(String value) {
    return switch (value.trim().toLowerCase()) {
      'production' || 'prod' => AppEnvironment.production,
      'staging' || 'stage' => AppEnvironment.staging,
      _ => AppEnvironment.development,
    };
  }

  static bool parseMockDataFlag(
    String value, {
    required AppEnvironment environment,
  }) {
    if (environment == AppEnvironment.production) return false;

    final normalized = value.trim().toLowerCase();
    if (normalized.isEmpty) return true;
    return switch (normalized) {
      '1' || 'true' || 'yes' || 'on' => true,
      _ => false,
    };
  }
}
