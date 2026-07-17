// Smoke test for MockProfileRepository: exercises every method on
// ProfileRepository against the mock implementation and asserts each call
// succeeds (doesn't throw) and returns a plausible, well-formed snapshot.
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/profile/data/repositories/mock_profile_repository.dart';
import 'package:vit_trade_flutter/features/profile/domain/entities/profile_entities.dart';

void main() {
  const repository = MockProfileRepository();

  group('MockProfileRepository smoke test', () {
    test('getProfile returns a populated snapshot', () {
      final snapshot = repository.getProfile();

      expect(snapshot, isA<ProfileSnapshot>());
      expect(snapshot.user.id, 'USR001');
      expect(snapshot.vip.label, 'VIP 1');
      expect(snapshot.prediction.positions, 5);
      expect(snapshot.arena.rooms, 3);
      expect(snapshot.productShortcuts, isNotEmpty);
      expect(snapshot.sections, hasLength(3));
      expect(snapshot.endpoint, isNotEmpty);
    });

    test('getEditProfile returns a populated snapshot', () {
      final snapshot = repository.getEditProfile();

      expect(snapshot, isA<ProfileEditSnapshot>());
      expect(snapshot.user.email, 'nguyenvana@email.com');
      expect(snapshot.endpoint, isNotEmpty);
    });

    test('getSecurity returns a populated snapshot with a high-risk '
        'contract id', () {
      final snapshot = repository.getSecurity();

      expect(snapshot, isA<ProfileSecuritySnapshot>());
      expect(snapshot.score, 3);
      expect(snapshot.items, hasLength(5));
      expect(snapshot.devices, hasLength(3));
      expect(snapshot.supportRoute, isNotEmpty);
      expect(snapshot.highRiskContractId, 'profile_security_review');
      expect(snapshot.endpoint, isNotEmpty);
    });

    test('getKyc returns a populated snapshot', () {
      final snapshot = repository.getKyc();

      expect(snapshot, isA<ProfileKycSnapshot>());
      expect(snapshot.currentLevel, 2);
      expect(snapshot.levels, hasLength(3));
      expect(snapshot.endpoint, isNotEmpty);
    });

    test('getSettings returns a populated snapshot', () {
      final snapshot = repository.getSettings();

      expect(snapshot, isA<ProfileSettingsSnapshot>());
      expect(snapshot.currencyOptions, hasLength(4));
      expect(snapshot.selectedCurrency, 'USD');
      expect(snapshot.languages, hasLength(2));
      expect(snapshot.tradeSecurity, hasLength(3));
      expect(snapshot.notifications, hasLength(6));
      expect(snapshot.appInfo, hasLength(3));
      expect(snapshot.endpoint, isNotEmpty);
    });

    test('getActivity returns a populated snapshot', () {
      final snapshot = repository.getActivity();

      expect(snapshot, isA<ProfileActivitySnapshot>());
      expect(snapshot.filters, hasLength(3));
      expect(snapshot.logs, hasLength(7));
      expect(snapshot.endpoint, isNotEmpty);
    });

    test('getApiKeyCreate returns a populated snapshot', () {
      final snapshot = repository.getApiKeyCreate();

      expect(snapshot, isA<ProfileApiKeyCreateSnapshot>());
      expect(snapshot.permissions, hasLength(3));
      expect(snapshot.expiryOptions, hasLength(4));
      expect(snapshot.securityTips, isNotEmpty);
      expect(snapshot.endpoint, isNotEmpty);
    });

    test('getApiManagement returns a populated snapshot', () {
      final snapshot = repository.getApiManagement();

      expect(snapshot, isA<ProfileApiManagementSnapshot>());
      expect(snapshot.keys, hasLength(3));
      expect(snapshot.keys.first.isActive, isTrue);
      expect(snapshot.endpoint, isNotEmpty);
    });

    test('getVip returns a populated snapshot', () {
      final snapshot = repository.getVip();

      expect(snapshot, isA<ProfileVipSnapshot>());
      expect(snapshot.currentLevel, 1);
      expect(snapshot.tiers, hasLength(6));
      expect(snapshot.history, hasLength(5));
      expect(snapshot.currentTier.level, snapshot.currentLevel);
      expect(snapshot.nextTier?.level, snapshot.currentLevel + 1);
      expect(snapshot.endpoint, isNotEmpty);
    });

    test('getDeviceManagement returns a populated snapshot', () {
      final snapshot = repository.getDeviceManagement();

      expect(snapshot, isA<ProfileDeviceManagementSnapshot>());
      expect(snapshot.devices, hasLength(4));
      expect(snapshot.currentDevice, isNotNull);
      expect(snapshot.trustedCount, 3);
      expect(snapshot.untrustedCount, 1);
      expect(snapshot.endpoint, isNotEmpty);
    });

    test('getSubAccounts returns a populated snapshot', () {
      final snapshot = repository.getSubAccounts();

      expect(snapshot, isA<ProfileSubAccountsSnapshot>());
      expect(snapshot.accounts, hasLength(5));
      expect(snapshot.totalBalance, greaterThan(0));
      expect(snapshot.activeCount, greaterThan(0));
      expect(snapshot.endpoint, isNotEmpty);
    });
  });
}
