import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/core/config/app_environment.dart';

/// Nguồn cấu hình runtime có thể ghi đè [AppConfig] sau khi app đã khởi
/// động — GĐ4-F1 dùng nó cho các cờ kill-switch (`maintenanceMode`,
/// `minSupportedBuild`). Hôm nay chỉ có một implementation "tĩnh"
/// ([DartDefineRuntimeConfigSource]) vì cấu hình đến hoàn toàn từ
/// dart-define lúc build; đây là chỗ cắm remote-config/kill-switch
/// server-side khi backend thật sẵn sàng (DEC-backend) — thay implementation
/// sau [runtimeConfigSourceProvider], không đổi call site nào khác.
abstract interface class RuntimeConfigSource {
  /// Trả về [AppConfig] đã được resolve, xuất phát từ [base]
  /// (`AppConfig.current`, đã nướng dart-define). Implementation
  /// server-side có thể fetch một cấu hình từ xa và merge/ghi đè lên
  /// [base]; implementation tĩnh chỉ trả nguyên [base].
  Future<AppConfig> resolve(AppConfig base);
}

/// Implementation mặc định: không có nguồn từ xa nào để hỏi, dart-define đã
/// nướng toàn bộ cờ vào [AppConfig] lúc build nên chỉ cần trả nguyên [base].
class DartDefineRuntimeConfigSource implements RuntimeConfigSource {
  const DartDefineRuntimeConfigSource();

  @override
  Future<AppConfig> resolve(AppConfig base) async => base;
}

/// Provider cho [RuntimeConfigSource] — cắm implementation remote-config
/// thật vào đây sau DEC-backend thay vì đổi call site nào khác.
final runtimeConfigSourceProvider = Provider<RuntimeConfigSource>(
  (ref) => const DartDefineRuntimeConfigSource(),
);
