import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
// Riverpod 3 giấu type `Override` khỏi export chính — misc.dart là nơi chuẩn.
import 'package:flutter_riverpod/misc.dart';

import 'package:vit_trade_flutter/core/network/session_refresh.dart';
import 'package:vit_trade_flutter/core/storage/secure_store.dart';
import 'package:vit_trade_flutter/features/auth/data/dto/auth_dto_mappers.dart';
import 'package:vit_trade_flutter/features/auth/data/dto/auth_session_dto.dart';
import 'package:vit_trade_flutter/features/auth/data/providers/auth_repository_provider.dart'
    as data;
import 'package:vit_trade_flutter/features/auth/presentation/controllers/auth_controller.dart';

export 'package:vit_trade_flutter/features/auth/presentation/controllers/auth_controller.dart';

final authControllerProvider = Provider<AuthController>((ref) {
  return AuthController(repository: ref.watch(data.authRepositoryProvider));
});

/// Phiên đăng nhập đang hoạt động (GĐ4-F1) — nguồn sự thật cho token của
/// `ApiClient` (SEC-S46) và cho khôi phục phiên khi khởi động
/// (`SessionBootstrap`).
///
/// KHÔNG `autoDispose` (khuôn `MarketListStateController` —
/// `market_controller_providers.dart`): phiên phải sống theo vòng đời app,
/// không phụ thuộc widget nào đang lắng nghe nó — mất listener tạm thời
/// (điều hướng qua lại) không được phép xóa phiên đăng nhập.
final class AuthSessionController extends Notifier<AuthSession?> {
  @override
  AuthSession? build() => null;

  /// Khôi phục phiên đã lưu khi khởi động app. Fail-safe: JSON hỏng hoặc
  /// thiếu trường KHÔNG throw — chỉ xóa khóa lưu và giữ state `null`.
  ///
  /// Giải mã qua [AuthSessionDto] (GĐ4-F8, ADR-010) — `fromJson` ném
  /// `CheckedFromJsonException` có kiểm soát khi thiếu trường/sai kiểu,
  /// `jsonDecode` ném `FormatException` khi chuỗi không phải JSON hợp lệ; cả
  /// hai đều rơi vào nhánh `catch` bên dưới như hành vi cũ.
  Future<void> restore() async {
    final store = ref.read(secureStoreProvider);
    final raw = await store.read(SecureStoreKeys.authSession);
    if (raw == null) return;

    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      state = AuthSessionDto.fromJson(json).toEntity();
    } catch (_) {
      await _clearStoredSession(store);
      state = null;
    }
  }

  /// Đăng nhập qua [AuthController], rồi lưu phiên + access/refresh token vào
  /// [SecureStore]. Token demo hiện là `'demo.<identifier>'` /
  /// `'demo-refresh.<identifier>'` (P0.4) — backend thật thay giá trị, không
  /// đổi cơ chế truyền. Lỗi từ repository ném nguyên, KHÔNG ghi gì vào store.
  ///
  /// Mã hóa qua [AuthSessionDto] (GĐ4-F8, ADR-010) — cùng shape JSON
  /// (`identifier`/`demo`/`issuedAt` ISO-8601) như trước, tương thích ngược
  /// với dữ liệu đã lưu bằng code cũ.
  Future<AuthSession> login({
    required String identifier,
    required String password,
    bool demo = false,
  }) async {
    final session = await ref
        .read(authControllerProvider)
        .login(identifier: identifier, password: password, demo: demo);

    final store = ref.read(secureStoreProvider);
    await store.write(
      SecureStoreKeys.authSession,
      jsonEncode(session.toDto().toJson()),
    );
    await store.write(SecureStoreKeys.authToken, 'demo.${session.identifier}');
    await store.write(
      SecureStoreKeys.authRefreshToken,
      'demo-refresh.${session.identifier}',
    );
    state = session;
    return session;
  }

  /// Làm mới access token từ refresh token trong SecureStore (P0.4).
  ///
  /// Trả access token mới hoặc `null` khi thiếu refresh / repo lỗi — caller
  /// (session-refresh interceptor) sẽ gọi [logout].
  Future<String?> tryRefreshAccessToken() async {
    final store = ref.read(secureStoreProvider);
    final refreshToken = await store.read(SecureStoreKeys.authRefreshToken);
    if (refreshToken == null || refreshToken.isEmpty) {
      return null;
    }

    try {
      final pair = await ref
          .read(authControllerProvider)
          .refreshSession(refreshToken: refreshToken);
      await store.write(SecureStoreKeys.authToken, pair.accessToken);
      if (pair.refreshToken != null && pair.refreshToken!.isNotEmpty) {
        await store.write(SecureStoreKeys.authRefreshToken, pair.refreshToken!);
      }
      return pair.accessToken;
    } catch (_) {
      return null;
    }
  }

  /// Đăng xuất: xóa phiên + token đã lưu, đưa state về `null`.
  Future<void> logout() async {
    final store = ref.read(secureStoreProvider);
    await _clearStoredSession(store);
    state = null;
  }

  Future<void> _clearStoredSession(SecureStore store) async {
    await store.delete(SecureStoreKeys.authSession);
    await store.delete(SecureStoreKeys.authToken);
    await store.delete(SecureStoreKeys.authRefreshToken);
  }
}

/// Provider [AuthSessionController] dùng chung toàn app — nguồn sự thật cho
/// phiên đăng nhập hiện tại (SEC-S46, GĐ4-F1).
final authSessionControllerProvider =
    NotifierProvider<AuthSessionController, AuthSession?>(
      AuthSessionController.new,
    );

/// Nối AuthSession ↔ ApiClient refresh mà `core/` không import `app/`.
/// Gắn vào [VitTradeApp.overrides] (và test ProviderContainer khi cần).
List<Override> authSessionNetworkOverrides() => [
  sessionAccessTokenRefresherProvider.overrideWith((ref) {
    return () => ref
        .read(authSessionControllerProvider.notifier)
        .tryRefreshAccessToken();
  }),
  sessionInvalidatedHandlerProvider.overrideWith((ref) {
    return () => ref.read(authSessionControllerProvider.notifier).logout();
  }),
];
