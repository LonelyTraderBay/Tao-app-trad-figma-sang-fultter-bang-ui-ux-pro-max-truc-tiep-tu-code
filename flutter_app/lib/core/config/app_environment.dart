enum AppEnvironment { development, staging, production }

final class AppConfig {
  const AppConfig({
    required this.environment,
    required this.apiBaseUrl,
    this.enableMockData = true,
    this.maintenanceMode = false,
    this.minSupportedBuild = 0,
    this.buildNumber = 0,
  });

  final AppEnvironment environment;
  final Uri apiBaseUrl;
  final bool enableMockData;

  /// GĐ4-F1 kill-switch: khi `true`, `root_routes.dart` redirect toàn bộ
  /// app về trang bảo trì (`AppRoutePaths.maintenanceGate`) bất kể route
  /// nào đang được yêu cầu. Đọc từ dart-define `MAINTENANCE_MODE` — chỗ
  /// cắm remote-config/kill-switch server-side sau DEC-backend (xem
  /// `RuntimeConfigSource`).
  final bool maintenanceMode;

  /// Phiên bản build tối thiểu còn được hỗ trợ. `0` nghĩa là chưa bật ràng
  /// buộc force-update (mọi build đều hợp lệ). Đọc từ dart-define
  /// `MIN_SUPPORTED_BUILD`.
  final int minSupportedBuild;

  /// Số build hiện tại của app (không phải version string) — dùng để so
  /// sánh với [minSupportedBuild]. Đọc từ dart-define `APP_BUILD_NUMBER`.
  final int buildNumber;

  bool get isProduction => environment == AppEnvironment.production;

  /// `true` khi build hiện tại thấp hơn [minSupportedBuild] — kích hoạt
  /// redirect toàn cục sang trang bắt buộc cập nhật
  /// (`AppRoutePaths.forceUpdateGate`). `minSupportedBuild == 0` nghĩa là
  /// ràng buộc chưa bật, luôn trả `false`.
  bool get forceUpdateRequired =>
      minSupportedBuild > 0 && buildNumber < minSupportedBuild;

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
    String maintenanceMode = const String.fromEnvironment('MAINTENANCE_MODE'),
    String minSupportedBuild = const String.fromEnvironment(
      'MIN_SUPPORTED_BUILD',
    ),
    String buildNumber = const String.fromEnvironment('APP_BUILD_NUMBER'),
  }) {
    final environment = parseEnvironment(environmentName);
    return AppConfig(
      environment: environment,
      apiBaseUrl: Uri.parse(apiBaseUrl),
      enableMockData: parseMockDataFlag(
        enableMockData,
        environment: environment,
      ),
      maintenanceMode: parseRuntimeFlag(maintenanceMode),
      minSupportedBuild: parseBuildNumber(minSupportedBuild),
      buildNumber: parseBuildNumber(buildNumber),
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

  /// Parse cờ runtime dạng chặn (kill-switch) — khác [parseMockDataFlag]:
  /// giá trị rỗng mặc định là `false` vì đây là cờ CHẶN (an toàn khi thiếu
  /// dart-define), không phải cờ bật tính năng dev.
  static bool parseRuntimeFlag(String value) {
    final normalized = value.trim().toLowerCase();
    if (normalized.isEmpty) return false;
    return switch (normalized) {
      '1' || 'true' || 'yes' || 'on' => true,
      _ => false,
    };
  }

  /// Parse số build từ dart-define. Giá trị không hợp lệ hoặc âm về `0`
  /// (nghĩa là "chưa có ràng buộc") thay vì ném lỗi ở đường khởi động app.
  static int parseBuildNumber(String value) {
    final parsed = int.tryParse(value.trim()) ?? 0;
    return parsed < 0 ? 0 : parsed;
  }
}
