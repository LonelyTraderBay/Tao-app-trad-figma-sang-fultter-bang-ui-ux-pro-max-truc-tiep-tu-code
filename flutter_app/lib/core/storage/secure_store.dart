import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Seam lưu trữ NHẠY CẢM (token phiên, thông tin đăng nhập) — GĐ4-F1.
///
/// Toàn bộ API bất đồng bộ vì backend thật (Keychain/Keystore) là async.
/// Dữ liệu thường (watchlist, cờ UI...) dùng `KeyValueStore` thay vì đây.
/// Chỉ `lib/core/storage/` được import trực tiếp `flutter_secure_storage`
/// (guardrail runtime_seams canh).
abstract interface class SecureStore {
  /// Đọc giá trị đã lưu, `null` nếu chưa có.
  Future<String?> read(String key);

  /// Ghi một giá trị.
  Future<void> write(String key, String value);

  /// Xóa giá trị theo khóa (không lỗi nếu khóa chưa tồn tại).
  Future<void> delete(String key);
}

/// Impl bộ nhớ thuần — mặc định của [secureStoreProvider] cho test.
class InMemorySecureStore implements SecureStore {
  /// Tạo store rỗng, hoặc seed sẵn giá trị ban đầu qua [seed].
  InMemorySecureStore({Map<String, String>? seed}) : _values = {...?seed};

  final Map<String, String> _values;

  @override
  Future<String?> read(String key) async => _values[key];

  @override
  Future<void> write(String key, String value) async {
    _values[key] = value;
  }

  @override
  Future<void> delete(String key) async {
    _values.remove(key);
  }
}

/// Impl production trên Keychain (iOS) / Keystore (Android) qua
/// `flutter_secure_storage`.
class FlutterSecureStore implements SecureStore {
  /// Dùng cấu hình mặc định của plugin; test không đi qua lớp này.
  const FlutterSecureStore([this._storage = const FlutterSecureStorage()]);

  final FlutterSecureStorage _storage;

  @override
  Future<String?> read(String key) => _storage.read(key: key);

  @override
  Future<void> write(String key, String value) =>
      _storage.write(key: key, value: value);

  @override
  Future<void> delete(String key) => _storage.delete(key: key);
}

/// Seam DI: mặc định in-memory (an toàn cho mọi test); bootstrap production
/// override bằng [FlutterSecureStore] qua `ProviderScope`.
final secureStoreProvider = Provider<SecureStore>(
  (ref) => InMemorySecureStore(),
);

/// Registry khóa [SecureStore] dùng chung — MỌI khóa nhạy cảm khai ở đây.
abstract final class SecureStoreKeys {
  /// Phiên đăng nhập đã serialize (JSON) để khôi phục khi khởi động.
  static const String authSession = 'auth.session';

  /// Token phiên cho `AuthTokenProvider` của ApiClient (SEC-S46).
  static const String authToken = 'auth.token';
}
