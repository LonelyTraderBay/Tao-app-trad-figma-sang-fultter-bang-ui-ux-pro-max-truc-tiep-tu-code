// Split from app_environment_test.dart 2026-07-27 (400-line test file size
// gate, Future-Feature-Onboarding-Checklist). Covers the identity/account
// domain repository fail-closed wiring (auth, profile, notifications) when
// mock data is disabled in production. See app_environment_test.dart (config
// parsing) and sibling app_environment_fail_closed_*_test.dart files for the
// other domains.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/core/config/app_environment.dart';
import 'package:vit_trade_flutter/core/network/api_client.dart';
import 'package:vit_trade_flutter/features/auth/data/auth_repository.dart';
import 'package:vit_trade_flutter/features/notifications/data/notifications_repository.dart';
import 'package:vit_trade_flutter/features/profile/data/profile_repository.dart';

void main() {
  test(
    'auth repository fails closed without wiring mock or fake remote',
    () async {
      final container = ProviderContainer(
        overrides: [
          appConfigProvider.overrideWithValue(
            AppConfig(
              environment: AppEnvironment.production,
              apiBaseUrl: Uri.parse('https://api.vittrade.example'),
              enableMockData: false,
            ),
          ),
        ],
      );
      addTearDown(container.dispose);

      final repository = container.read(authRepositoryProvider);

      expect(repository, isA<FailClosedAuthRepository>());
      await expectLater(
        repository.login(identifier: 'user@vittrade.vn', password: 'secret'),
        throwsA(isA<AuthBackendContractMissingException>()),
      );
    },
  );

  test(
    'profile repository fails closed without wiring mock or fake remote',
    () {
      final container = ProviderContainer(
        overrides: [
          appConfigProvider.overrideWithValue(
            AppConfig(
              environment: AppEnvironment.production,
              apiBaseUrl: Uri.parse('https://api.vittrade.example'),
              enableMockData: false,
            ),
          ),
        ],
      );
      addTearDown(container.dispose);

      final repository = container.read(profileRepositoryProvider);

      expect(repository, isA<FailClosedProfileRepository>());
      expect(
        () => repository.getProfile(),
        throwsA(isA<ProfileBackendContractMissingException>()),
      );
    },
  );

  test(
    'notifications repository fails closed without wiring mock or fake remote',
    () {
      final container = ProviderContainer(
        overrides: [
          appConfigProvider.overrideWithValue(
            AppConfig(
              environment: AppEnvironment.production,
              apiBaseUrl: Uri.parse('https://api.vittrade.example'),
              enableMockData: false,
            ),
          ),
        ],
      );
      addTearDown(container.dispose);

      final repository = container.read(notificationsRepositoryProvider);

      expect(repository, isA<FailClosedNotificationsRepository>());
      expect(
        () => repository.getNotifications(),
        throwsA(isA<NotificationsBackendContractMissingException>()),
      );
    },
  );
}
