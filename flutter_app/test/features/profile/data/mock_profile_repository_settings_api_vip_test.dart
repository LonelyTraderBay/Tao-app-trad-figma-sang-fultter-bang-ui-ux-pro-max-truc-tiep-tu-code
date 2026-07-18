import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/profile/data/repositories/mock_profile_repository.dart';

/// Repository-layer smoke test for [MockProfileRepository] under the
/// `test/features/<feature>/data/` convention (see
/// `test/features/p2p/data/mock_p2p_repository_orders_test.dart`).
///
/// Every method on `ProfileRepository` already gets an isA<>/isNotEmpty
/// smoke pass in the sibling
/// `test/features/profile/mock_profile_repository_test.dart`. This file
/// complements that coverage by pinning concrete, hand-verified values from
/// `lib/features/profile/data/repositories/mock_profile_repository_settings_fixtures.dart`
/// and `mock_profile_repository_vip_fixtures.dart` so a silent fixture
/// edit shows up as a failing assertion. Every method here is a plain
/// synchronous getter — `ProfileRepository` has no write/action methods.
///
/// Split by behavior group (Profile has 11 getters — too many for one
/// ~400-line file): this file covers settings, API key create/manage,
/// VIP, and sub-account surfaces. See
/// `mock_profile_repository_identity_security_test.dart` for
/// identity/security/KYC/activity/device surfaces.
///
/// SEC-S41 note: the API key `key`/`secret` fixture values below use the
/// literal `vt_live_VI_DU_KHONG_THAT_*` / `sk_live_VI_DU_KHONG_THAT_*`
/// placeholder markers (low-entropy, clearly-fake) — this is the current,
/// correct fixture shape, not a real credential.
void main() {
  const repository = MockProfileRepository(loadDelay: Duration.zero);

  group('MockProfileRepository settings/api/vip data smoke test', () {
    test(
      'getSettings pins the currency/language defaults and list sizes',
      () async {
        final snapshot = await repository.getSettings();

        expect(snapshot.endpoint, '/api/mobile/profile/profile-settings');
        expect(snapshot.currencyOptions, ['USD', 'VND', 'EUR', 'BTC']);
        expect(snapshot.selectedCurrency, 'USD');
        expect(snapshot.languages, hasLength(2));
        expect(snapshot.selectedLanguageId, 'vi');
        expect(snapshot.tradeSecurity, hasLength(3));
        expect(snapshot.notifications, hasLength(6));
        expect(snapshot.appInfo, hasLength(3));
        expect(snapshot.appInfo.first.value, '2.4.1 (Build 241)');
      },
    );

    test(
      'getApiKeyCreate pins the permission and expiry option counts',
      () async {
        final snapshot = await repository.getApiKeyCreate();

        expect(snapshot.endpoint, '/api/mobile/profile/profile-api-create');
        expect(snapshot.permissions, hasLength(3));
        expect(snapshot.permissions.first.id, 'read');
        expect(snapshot.permissions.first.required, isTrue);
        expect(snapshot.permissions.last.id, 'withdraw');
        expect(snapshot.expiryOptions, hasLength(4));
        expect(snapshot.securityTips, hasLength(4));
      },
    );

    test(
      'getApiManagement pins the SEC-S41 placeholder key/secret markers',
      () async {
        final snapshot = await repository.getApiManagement();

        expect(snapshot.endpoint, '/api/mobile/profile/profile-api');
        expect(snapshot.keys, hasLength(3));
        expect(snapshot.keys.first.id, 'key1');
        expect(snapshot.keys.first.name, 'Trading Bot Alpha');
        expect(
          snapshot.keys.first.key,
          'vt_live_VI_DU_KHONG_THAT_bot_alpha_01',
        );
        expect(
          snapshot.keys.first.secret,
          'sk_live_VI_DU_KHONG_THAT_bot_alpha_02',
        );
        expect(snapshot.keys.first.isActive, isTrue);
        expect(snapshot.keys.last.isActive, isFalse);
      },
    );

    test(
      'getVip pins the current tier, fee, and tier/history counts',
      () async {
        final snapshot = await repository.getVip();

        expect(snapshot.endpoint, '/api/mobile/profile/profile-vip');
        expect(snapshot.currentLevel, 1);
        expect(snapshot.monthlyVolume, 12450);
        expect(snapshot.tiers, hasLength(6));
        expect(snapshot.tiers[1].name, 'VIP 1');
        expect(snapshot.tiers[1].makerFee, .09);
        expect(snapshot.history, hasLength(5));
        expect(snapshot.currentTier.level, 1);
        expect(snapshot.nextTier?.level, 2);
      },
    );

    test(
      'getSubAccounts pins the account/balance totals and a known account',
      () async {
        final snapshot = await repository.getSubAccounts();

        expect(snapshot.endpoint, '/api/mobile/profile/profile-sub-accounts');
        expect(snapshot.accounts, hasLength(5));
        expect(snapshot.accounts.first.id, 'sub001');
        expect(snapshot.accounts.first.type, 'spot');
        expect(snapshot.totalBalance, greaterThan(0));
        expect(snapshot.activeCount, 4);
        expect(
          snapshot.accounts.where((a) => a.status == 'frozen'),
          hasLength(1),
        );
      },
    );
  });
}
