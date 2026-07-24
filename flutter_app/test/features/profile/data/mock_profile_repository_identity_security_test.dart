import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/profile/data/repositories/mock_profile_repository.dart';

/// Repository-layer smoke test for [MockProfileRepository] under the
/// `test/features/<feature>/data/` convention (see
/// `test/features/p2p_core/data/mock_p2p_repository_orders_test.dart`).
///
/// Every method on `ProfileRepository` already gets an isA<>/isNotEmpty
/// smoke pass in the sibling
/// `test/features/profile/mock_profile_repository_test.dart`. This file
/// complements that coverage by pinning concrete, hand-verified values from
/// `lib/features/profile/data/repositories/mock_profile_repository_core_fixtures.dart`
/// and `mock_profile_repository_settings_fixtures.dart` so a silent
/// fixture edit shows up as a failing assertion. Every method here is a
/// plain synchronous getter — `ProfileRepository` has no write/action
/// methods.
///
/// Split by behavior group (Profile has 11 getters — too many for one
/// ~400-line file): this file covers identity/account, security, KYC,
/// activity log, and device management surfaces. See
/// `mock_profile_repository_settings_api_vip_test.dart` for
/// settings/API-key/VIP/sub-account surfaces.
void main() {
  const repository = MockProfileRepository(loadDelay: Duration.zero);

  group('MockProfileRepository identity/security data smoke test', () {
    test('getProfile pins the user identity and menu section count', () async {
      final snapshot = await repository.getProfile();

      expect(snapshot.endpoint, '/api/mobile/profile/profile');
      expect(snapshot.user.id, 'USR001');
      expect(snapshot.user.email, 'nguyenvana@email.com');
      expect(snapshot.user.referralCode, 'VITTA-A2B3C');
      expect(snapshot.vip.label, 'VIP 1');
      expect(snapshot.prediction.positions, 5);
      expect(snapshot.arena.rooms, 3);
      expect(snapshot.arena.pointsLabel, '2,220');
      expect(snapshot.productShortcuts, hasLength(6));
      expect(snapshot.sections, hasLength(6));
      expect(snapshot.sections.map((section) => section.id), [
        'account',
        'security',
        'portfolio',
        'referral',
        'support',
        'legal',
      ]);
      expect(snapshot.sections.first.id, 'account');
      expect(snapshot.sections.first.items, hasLength(9));
    });

    test('getEditProfile pins the same user identity for edit', () async {
      final snapshot = await repository.getEditProfile();

      expect(snapshot.endpoint, '/api/mobile/profile/profile-edit');
      expect(snapshot.user.id, 'USR001');
      expect(snapshot.user.phone, '+84 912 345 678');
    });

    test('getSecurity pins the score and the profile_security_review '
        'high-risk contract id', () async {
      final snapshot = await repository.getSecurity();

      expect(snapshot.endpoint, '/api/mobile/profile/profile-security');
      expect(snapshot.score, 3);
      expect(snapshot.scoreLabel, 'Cao');
      expect(snapshot.items, hasLength(5));
      expect(snapshot.items.first.id, 'two-factor');
      expect(snapshot.devices, hasLength(3));
      expect(snapshot.devices.first.id, 'd1');
      expect(snapshot.devices.first.isCurrent, isTrue);
      expect(snapshot.supportRoute, isNotEmpty);
      // Deliberately not registered in HighRiskFlowContractIds — this is a
      // display-only, profile-scoped contract id (see the doc comment on
      // `_profileSecurityReviewContractId` in mock_profile_repository.dart).
      expect(snapshot.highRiskContractId, 'profile_security_review');
    });

    test('getKyc pins the current level and level count', () async {
      final snapshot = await repository.getKyc();

      expect(snapshot.endpoint, '/api/mobile/profile/profile-kyc');
      expect(snapshot.currentLevel, 2);
      expect(snapshot.levels, hasLength(3));
      expect(snapshot.levels.first.level, 0);
      expect(snapshot.levels.last.level, 2);
    });

    test(
      'getActivity pins the filter and log counts with a known entry',
      () async {
        final snapshot = await repository.getActivity();

        expect(snapshot.endpoint, '/api/mobile/profile/profile-activity');
        expect(snapshot.filters, hasLength(3));
        expect(snapshot.logs, hasLength(7));
        expect(snapshot.logs.first.id, 'act001');
        expect(snapshot.logs.first.type, 'login');
        expect(snapshot.logs.first.status, 'success');
        expect(
          snapshot.logs.where((log) => log.status == 'suspicious'),
          hasLength(1),
        );
      },
    );

    test(
      'getDeviceManagement pins the trusted/untrusted device split',
      () async {
        final snapshot = await repository.getDeviceManagement();

        expect(snapshot.endpoint, '/api/mobile/profile/profile-devices');
        expect(snapshot.devices, hasLength(4));
        expect(snapshot.currentDevice?.id, 'dev001');
        expect(
          snapshot.devices.where((device) => device.isTrusted),
          hasLength(3),
        );
        expect(
          snapshot.devices.where((device) => !device.isTrusted),
          hasLength(1),
        );
      },
    );
  });
}
