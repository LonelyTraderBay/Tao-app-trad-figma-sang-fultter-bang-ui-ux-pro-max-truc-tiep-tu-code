import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/profile/data/repositories/mock_profile_repository.dart';
import 'package:vit_trade_flutter/features/profile/presentation/controllers/profile_controller.dart';

void main() {
  group('ProfileController', () {
    test('exposes profile snapshots through repository contract', () {
      final controller = ProfileController(const MockProfileRepository());

      final profile = controller.getProfile();
      final security = controller.getSecurity();
      final vip = controller.getVip();
      final subAccounts = controller.getSubAccounts();

      expect(profile.endpoint, '/api/mobile/profile/profile');
      expect(profile.user.id, 'USR001');
      expect(security.supportedStates, contains(ProfileScreenState.submitting));
      expect(vip.currentTier.level, vip.currentLevel);
      expect(subAccounts.totalBalance, greaterThan(0));
    });
  });
}
