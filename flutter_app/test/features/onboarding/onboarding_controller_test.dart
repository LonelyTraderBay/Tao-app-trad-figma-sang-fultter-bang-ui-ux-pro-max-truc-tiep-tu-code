import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/providers/onboarding_controller_providers.dart';
import 'package:vit_trade_flutter/core/storage/key_value_store.dart';
import 'package:vit_trade_flutter/features/onboarding/data/repositories/mock_onboarding_repository.dart';

void main() {
  group('OnboardingController', () {
    test('exposes onboarding flow through repository contract', () {
      final controller = const OnboardingController(MockOnboardingRepository());

      final snapshot = controller.getFlow();

      expect(snapshot.endpoint, '/api/mobile/onboarding/onboarding');
      expect(snapshot.steps, contains(OnboardingStepDraft.complete));
      expect(snapshot.modules, hasLength(5));
      expect(snapshot.boundaries.last.title, 'Open Arena');
      expect(snapshot.supportedStates, contains(OnboardingScreenState.offline));
    });
  });

  group('onboardingSeenProvider (persist GĐ4-F1)', () {
    test('mặc định false khi chưa lưu cờ', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(onboardingSeenProvider), isFalse);
    });

    test('trả true khi store đã seed cờ onboarding.seen', () {
      final container = ProviderContainer(
        overrides: [
          keyValueStoreProvider.overrideWithValue(
            InMemoryKeyValueStore(
              seed: {KeyValueStoreKeys.onboardingSeen: true},
            ),
          ),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(onboardingSeenProvider), isTrue);
    });
  });
}
