import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/profile/data/repositories/mock_profile_repository.dart';
import 'package:vit_trade_flutter/features/profile/presentation/controllers/profile_controller.dart';

void main() {
  group('ProfileController', () {
    test('exposes profile snapshots through repository contract', () async {
      final controller = const ProfileController(
        MockProfileRepository(loadDelay: Duration.zero),
      );

      final profile = await controller.getProfile();
      final security = await controller.getSecurity();
      final vip = await controller.getVip();
      final subAccounts = await controller.getSubAccounts();

      expect(profile.endpoint, '/api/mobile/profile/profile');
      expect(profile.user.id, 'USR001');
      expect(security.supportedStates, contains(ProfileScreenState.submitting));
      expect(vip.currentTier.level, vip.currentLevel);
      expect(subAccounts.totalBalance, greaterThan(0));
    });
  });
}
