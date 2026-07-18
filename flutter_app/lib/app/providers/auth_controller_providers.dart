import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/core/storage/secure_store.dart';
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
  Future<void> restore() async {
    final store = ref.read(secureStoreProvider);
    final raw = await store.read(SecureStoreKeys.authSession);
    if (raw == null) return;

    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      state = AuthSession(
        identifier: json['identifier']! as String,
        demo: json['demo']! as bool,
        issuedAt: DateTime.parse(json['issuedAt']! as String),
      );
    } catch (_) {
      await store.delete(SecureStoreKeys.authSession);
      state = null;
    }
  }

  /// Đăng nhập qua [AuthController], rồi lưu phiên + token vào
  /// [SecureStore]. Token hiện là `'demo.<identifier>'` (SEC-S46 bật một
  /// nửa GĐ4-F1) — backend thật sẽ thay bằng token server cấp, không đổi
  /// cơ chế truyền. Lỗi từ repository ném nguyên, KHÔNG ghi gì vào store.
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
      jsonEncode({
        'identifier': session.identifier,
        'demo': session.demo,
        'issuedAt': session.issuedAt.toIso8601String(),
      }),
    );
    await store.write(SecureStoreKeys.authToken, 'demo.${session.identifier}');
    state = session;
    return session;
  }

  /// Đăng xuất: xóa phiên + token đã lưu, đưa state về `null`.
  Future<void> logout() async {
    final store = ref.read(secureStoreProvider);
    await store.delete(SecureStoreKeys.authSession);
    await store.delete(SecureStoreKeys.authToken);
    state = null;
  }
}

/// Provider [AuthSessionController] dùng chung toàn app — nguồn sự thật cho
/// phiên đăng nhập hiện tại (SEC-S46, GĐ4-F1).
final authSessionControllerProvider =
    NotifierProvider<AuthSessionController, AuthSession?>(
      AuthSessionController.new,
    );
