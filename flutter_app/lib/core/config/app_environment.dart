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

  static final AppConfig local = AppConfig(
    environment: AppEnvironment.development,
    apiBaseUrl: Uri.parse('https://api.vittrade.local'),
  );
}
