import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:vit_trade_flutter/app/providers/auth_controller_providers.dart';
import 'package:vit_trade_flutter/core/storage/secure_store.dart';
import 'package:vit_trade_flutter/features/auth/data/auth_repository.dart';

void main() {
  ProviderContainer buildContainer({
    InMemorySecureStore? store,
    AuthRepository? repository,
  }) {
    final container = ProviderContainer(
      overrides: [
        secureStoreProvider.overrideWithValue(store ?? InMemorySecureStore()),
        authRepositoryProvider.overrideWithValue(
          repository ?? const MockAuthRepository(delay: Duration.zero),
        ),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  test('login lưu phiên + token vào SecureStore và cập nhật state', () async {
    final store = InMemorySecureStore();
    final container = buildContainer(store: store);

    final session = await container
        .read(authSessionControllerProvider.notifier)
        .login(identifier: 'user@vittrade.vn', password: 'secret');

    expect(container.read(authSessionControllerProvider), isNotNull);
    expect(
      container.read(authSessionControllerProvider)!.identifier,
      session.identifier,
    );

    final savedSession = await store.read(SecureStoreKeys.authSession);
    expect(savedSession, isNotNull);
    final json = jsonDecode(savedSession!) as Map<String, dynamic>;
    expect(json['identifier'], 'user@vittrade.vn');
    expect(json['demo'], isFalse);

    final savedToken = await store.read(SecureStoreKeys.authToken);
    expect(savedToken, 'demo.user@vittrade.vn');
  });

  test('restore đọc phiên đã lưu từ SecureStore', () async {
    final issuedAt = DateTime.utc(2026, 7, 18, 10, 30);
    final store = InMemorySecureStore(
      seed: {
        SecureStoreKeys.authSession: jsonEncode({
          'identifier': 'seed@vittrade.vn',
          'demo': true,
          'issuedAt': issuedAt.toIso8601String(),
        }),
      },
    );
    final container = buildContainer(store: store);

    await container.read(authSessionControllerProvider.notifier).restore();

    final state = container.read(authSessionControllerProvider);
    expect(state, isNotNull);
    expect(state!.identifier, 'seed@vittrade.vn');
    expect(state.demo, isTrue);
    expect(state.issuedAt, issuedAt);
  });

  test('restore với JSON hỏng xóa khóa và giữ state null', () async {
    final store = InMemorySecureStore(
      seed: {SecureStoreKeys.authSession: 'khong-phai-json'},
    );
    final container = buildContainer(store: store);

    await container.read(authSessionControllerProvider.notifier).restore();

    expect(container.read(authSessionControllerProvider), isNull);
    expect(await store.read(SecureStoreKeys.authSession), isNull);
  });

  test('logout xóa cả hai khóa và đưa state về null', () async {
    final store = InMemorySecureStore();
    final container = buildContainer(store: store);
    final notifier = container.read(authSessionControllerProvider.notifier);

    await notifier.login(identifier: 'user@vittrade.vn', password: 'secret');
    expect(await store.read(SecureStoreKeys.authSession), isNotNull);

    await notifier.logout();

    expect(container.read(authSessionControllerProvider), isNull);
    expect(await store.read(SecureStoreKeys.authSession), isNull);
    expect(await store.read(SecureStoreKeys.authToken), isNull);
  });

  test('login lỗi từ repository không ghi gì vào SecureStore', () async {
    final store = InMemorySecureStore();
    final container = buildContainer(
      store: store,
      repository: const FailClosedAuthRepository(),
    );
    final notifier = container.read(authSessionControllerProvider.notifier);

    await expectLater(
      notifier.login(identifier: 'user@vittrade.vn', password: 'secret'),
      throwsA(isA<AuthBackendContractMissingException>()),
    );

    expect(container.read(authSessionControllerProvider), isNull);
    expect(await store.read(SecureStoreKeys.authSession), isNull);
    expect(await store.read(SecureStoreKeys.authToken), isNull);
  });
}
