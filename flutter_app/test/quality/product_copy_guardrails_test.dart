import 'package:flutter_test/flutter_test.dart';

import 'product_copy_guardrail_test_utils.dart';

void main() {
  group('product copy guardrails - Arena and auth', () {
    test('Arena and RewardsHub reward surfaces stay points-only', () {
      final files = [
        'lib/features/arena/data/repositories/mock_arena_repository.dart',
        'lib/features/rewards/presentation/pages/rewards_hub_page.dart',
        'lib/features/rewards/data/repositories/mock_rewards_repository.dart',
      ];

      for (final path in files) {
        final source = readSource(path);
        expect(source, isNot(contains('task-wallet')), reason: path);
        expect(
          RegExp(r"rewardLabel:\s*'[^']*\bUSDT\b").allMatches(source),
          isEmpty,
          reason: path,
        );
      }

      final visibleRewardSurfaces = [
        'lib/features/rewards/presentation/pages/rewards_hub_page.dart',
        'lib/features/rewards/data/repositories/mock_rewards_repository.dart',
      ];

      for (final path in visibleRewardSurfaces) {
        final source = readSource(path);
        expect(source, isNot(contains('USDT')), reason: path);
      }
    });

    test('Arena reward labels avoid financial payout language', () {
      final files = [
        'lib/features/arena/data/repositories/mock_arena_repository.dart',
        'lib/features/rewards/data/repositories/mock_rewards_repository.dart',
      ];

      final unsafeRewardLabel = RegExp(
        r"rewardLabel:\s*'[^']*\b(USDT|USD|wallet|payout|profit|cash)\b",
        caseSensitive: false,
      );

      for (final path in files) {
        final source = readSource(path);
        expect(unsafeRewardLabel.allMatches(source), isEmpty, reason: path);
      }
    });

    test('Arena user-facing pages avoid prohibited financial terms', () {
      final arenaPages = listDartFiles('lib/features/arena/presentation/pages');
      final prohibited = RegExp(
        r'\b(wallet|profit|payout|stake|USDT|USD|cash|PnL|P/L)\b',
        caseSensitive: false,
      );
      final findings = <String>[];

      for (final file in arenaPages) {
        final lines = file.readAsLinesSync();
        for (var index = 0; index < lines.length; index += 1) {
          final line = lines[index];
          if (prohibited.hasMatch(line)) {
            findings.add('${file.path}:${index + 1}: ${line.trim()}');
          }
        }
      }

      expect(
        findings,
        isEmpty,
        reason:
            'Open Arena user-facing copy must stay points-only. '
            'Prediction/financial boundary text belongs in explicit bridge '
            'documentation and safety controls, not Arena action pages.',
      );
    });

    test('Arena bridge documentation keeps Prediction and Arena separated', () {
      final source = readSource(
        'lib/features/arena/data/repositories/mock_arena_repository.dart',
      );

      expect(source, contains('Open Arena = Points only'));
      expect(source, contains('Prediction Markets = Real positions'));
      expect(source, contains('no_wallet_link'));
      expect(source, contains('Points + PnL'));
    });

    test('Arena governance, report, and challenge state stay points-only', () {
      final source = asciiFold(
        [
          'lib/features/arena/presentation/pages/arena_governance_gate_page.dart',
          'lib/features/arena/presentation/pages/arena_governance_gate_page_part_04.dart',
          'lib/features/arena/presentation/pages/arena_report_case_page.dart',
          'lib/features/arena/presentation/pages/arena_challenge_detail_page.dart',
          'lib/features/arena/presentation/pages/arena_challenge_detail_page_part_01.dart',
          'lib/features/arena/presentation/pages/arena_challenge_detail_page_part_02.dart',
          'lib/features/arena/presentation/pages/arena_challenge_detail_page_part_03.dart',
          'lib/features/arena/presentation/controllers/arena_controller.dart',
          'lib/features/arena/presentation/controllers/arena_creation_controller.dart',
          'lib/features/arena/presentation/widgets/arena_state_cards.dart',
        ].map(readSource).join('\n'),
      );

      final unsafe = RegExp(
        r'\b(wallet|profit|payout|stake-return|USDT|USD|cash|PnL|P/L)\b',
        caseSensitive: false,
      );
      expect(unsafe.allMatches(source), isEmpty);

      final roles = {
        'Arena Points': [RegExp(r'Arena Points', caseSensitive: false)],
        'Points pool': [RegExp(r'Points pool', caseSensitive: false)],
        'governance state': [
          RegExp(r'Governance state|ArenaGovernanceActionState'),
        ],
        'report review': [
          RegExp(r'Moderation review state|ArenaReportReviewState'),
        ],
        'fair play': [RegExp(r'fair-play|fair play', caseSensitive: false)],
      };

      for (final entry in roles.entries) {
        final hasRole = entry.value.any((pattern) => pattern.hasMatch(source));
        expect(hasRole, isTrue, reason: 'Arena state is missing ${entry.key}.');
      }
    });

    test('Arena release-gated surfaces avoid placeholder readiness copy', () {
      final source = asciiFold(
        [
          'lib/features/arena/data/fixtures/arena_mode_challenge_detail_repository_methods.dart',
          'lib/features/arena/data/fixtures/arena_creator_trust_repository_methods.dart',
          'lib/features/arena/data/fixtures/arena_points_repository_methods.dart',
          'lib/features/arena/data/fixtures/arena_flow_map_repository_methods.dart',
          'lib/features/arena/data/fixtures/arena_production_ecosystem_repository_methods.dart',
          'lib/features/arena/data/fixtures/arena_connected_guide_repository_methods.dart',
          'lib/features/arena/presentation/pages/verified_challenges_page.dart',
          'lib/features/arena/presentation/pages/arena_production_ready_page_part_01.dart',
          'lib/features/arena/presentation/pages/arena_production_ready_page_part_02.dart',
          'lib/features/arena/presentation/pages/connected_ecosystem_production_page.dart',
          'lib/features/arena/presentation/pages/connected_ecosystem_production_page_part_01.dart',
        ].map(readSource).join('\n'),
      );

      final misleading = RegExp(
        r'placeholder future-ready|placeholder only|Coming Soon|Not available in production yet|Production Ready',
        caseSensitive: false,
      );
      expect(misleading.allMatches(source), isEmpty);
      expect(source, contains('Release-gated Preview'));
      expect(source, contains('release-readiness'));
    });

    test(
      'auth reset flow does not carry OTP secrets in route query params',
      () {
        final otpPage = readSource(
          'lib/features/auth/presentation/pages/otp_page.dart',
        );
        final authRoutes = readSource(
          'lib/app/router/route_groups/auth_routes.dart',
        );

        expect(otpPage, isNot(contains('otp=')));
        expect(otpPage, isNot(contains('authResetPassword}?')));
        expect(authRoutes, isNot(contains("queryParameters['otp']")));
        expect(authRoutes, isNot(contains("queryParameters['email']")));
      },
    );
  });
}
