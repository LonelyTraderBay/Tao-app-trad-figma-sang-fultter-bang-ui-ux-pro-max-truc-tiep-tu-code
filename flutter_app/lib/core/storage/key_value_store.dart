import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Seam persistence key-value KHÔNG nhạy cảm (watchlist, cờ onboarding,
/// settings toggle...) — GĐ4-F1.
///
/// Đọc đồng bộ (SharedPreferences cache toàn bộ vào bộ nhớ khi khởi tạo),
/// ghi bất đồng bộ. Dữ liệu nhạy cảm (token, session) KHÔNG đi qua đây —
/// dùng `SecureStore`. Chỉ `lib/core/storage/` được import trực tiếp
/// `shared_preferences` (guardrail runtime_seams canh).
abstract interface class KeyValueStore {
  /// Đọc chuỗi đã lưu, `null` nếu chưa có.
  String? getString(String key);

  /// Đọc cờ bool đã lưu, `null` nếu chưa có.
  bool? getBool(String key);

  /// Đọc danh sách chuỗi đã lưu, `null` nếu chưa có.
  List<String>? getStringList(String key);

  /// Ghi một chuỗi.
  Future<void> setString(String key, String value);

  /// Ghi một cờ bool.
  Future<void> setBool(String key, bool value);

  /// Ghi một danh sách chuỗi.
  Future<void> setStringList(String key, List<String> value);

  /// Xóa giá trị theo khóa (không lỗi nếu khóa chưa tồn tại).
  Future<void> remove(String key);
}

/// Impl bộ nhớ thuần — mặc định của [keyValueStoreProvider] để widget test /
/// golden test không chạm đĩa; cũng là impl dùng trong unit test.
class InMemoryKeyValueStore implements KeyValueStore {
  /// Tạo store rỗng, hoặc seed sẵn giá trị ban đầu qua [seed].
  InMemoryKeyValueStore({Map<String, Object>? seed}) : _values = {...?seed};

  final Map<String, Object> _values;

  @override
  String? getString(String key) => _values[key] as String?;

  @override
  bool? getBool(String key) => _values[key] as bool?;

  @override
  List<String>? getStringList(String key) =>
      (_values[key] as List<String>?)?.toList();

  @override
  Future<void> setString(String key, String value) async {
    _values[key] = value;
  }

  @override
  Future<void> setBool(String key, bool value) async {
    _values[key] = value;
  }

  @override
  Future<void> setStringList(String key, List<String> value) async {
    _values[key] = List<String>.of(value);
  }

  @override
  Future<void> remove(String key) async {
    _values.remove(key);
  }
}

/// Impl production bọc một [SharedPreferences] ĐÃ `await` xong ở bootstrap
/// (main.dart) — nhờ đó mọi phép đọc là đồng bộ.
class SharedPreferencesKeyValueStore implements KeyValueStore {
  /// Bọc instance [preferences] đã khởi tạo.
  const SharedPreferencesKeyValueStore(this._preferences);

  final SharedPreferences _preferences;

  @override
  String? getString(String key) => _preferences.getString(key);

  @override
  bool? getBool(String key) => _preferences.getBool(key);

  @override
  List<String>? getStringList(String key) => _preferences.getStringList(key);

  @override
  Future<void> setString(String key, String value) =>
      _preferences.setString(key, value);

  @override
  Future<void> setBool(String key, bool value) =>
      _preferences.setBool(key, value);

  @override
  Future<void> setStringList(String key, List<String> value) =>
      _preferences.setStringList(key, value);

  @override
  Future<void> remove(String key) => _preferences.remove(key);
}

/// Seam DI: mặc định in-memory (an toàn cho mọi test); bootstrap production
/// override bằng [SharedPreferencesKeyValueStore] qua `ProviderScope`.
final keyValueStoreProvider = Provider<KeyValueStore>(
  (ref) => InMemoryKeyValueStore(),
);

/// Registry khóa [KeyValueStore] dùng chung — MỌI khóa persistence thường
/// khai ở đây (một chỗ nhìn thấy toàn bộ bề mặt lưu trữ, tránh trùng khóa).
abstract final class KeyValueStoreKeys {
  /// Danh sách id cặp giao dịch user đánh dấu sao (watchlist).
  static const String marketWatchlistFavorites = 'market.watchlist.favorites';

  /// Cờ user đã đi qua (hoặc bỏ qua) onboarding lần đầu.
  static const String onboardingSeen = 'onboarding.seen';

  /// Đơn vị tiền hiển thị user chọn ở Settings.
  static const String settingsCurrency = 'settings.currency';

  /// Ngôn ngữ user chọn ở Settings.
  static const String settingsLanguage = 'settings.language';

  /// Prefix cho từng toggle Settings — khóa đầy đủ = prefix + id toggle.
  static const String settingsTogglePrefix = 'settings.toggle.';
}
