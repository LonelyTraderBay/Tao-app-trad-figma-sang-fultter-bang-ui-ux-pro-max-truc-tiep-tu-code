import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('product copy guardrails', () {
    test('Arena and RewardsHub reward surfaces stay points-only', () {
      final files = [
        'lib/features/arena/presentation/pages/arena_points_page.dart',
        'lib/features/arena/data/repositories/mock_arena_repository.dart',
        'lib/features/rewards/presentation/pages/rewards_hub_page.dart',
        'lib/features/rewards/data/repositories/mock_rewards_repository.dart',
      ];

      for (final path in files) {
        final source = _read(path);
        expect(source, isNot(contains('task-wallet')), reason: path);
        expect(
          RegExp(r"rewardLabel:\s*'[^']*\bUSDT\b").allMatches(source),
          isEmpty,
          reason: path,
        );
      }

      final visibleRewardSurfaces = [
        'lib/features/arena/presentation/pages/arena_points_page.dart',
        'lib/features/rewards/presentation/pages/rewards_hub_page.dart',
        'lib/features/rewards/data/repositories/mock_rewards_repository.dart',
      ];

      for (final path in visibleRewardSurfaces) {
        final source = _read(path);
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
        final source = _read(path);
        expect(unsafeRewardLabel.allMatches(source), isEmpty, reason: path);
      }
    });

    test('Arena user-facing pages avoid prohibited financial terms', () {
      final arenaPages = Directory('lib/features/arena/presentation/pages')
          .listSync()
          .whereType<File>()
          .where((file) => file.path.endsWith('.dart'));
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
      final source = _read(
        'lib/features/arena/data/repositories/mock_arena_repository.dart',
      );

      expect(source, contains('Open Arena = Points only'));
      expect(source, contains('Prediction Markets = Real positions'));
      expect(source, contains('no_wallet_link'));
      expect(source, contains('Points + PnL'));
    });

    test('Arena governance, report, and challenge state stay points-only', () {
      final source = _asciiFold(
        [
          'lib/features/arena/presentation/pages/arena_governance_gate_page.dart',
          'lib/features/arena/presentation/pages/arena_governance_gate_page_part_01.dart',
          'lib/features/arena/presentation/pages/arena_governance_gate_page_part_02.dart',
          'lib/features/arena/presentation/pages/arena_governance_gate_page_part_03.dart',
          'lib/features/arena/presentation/pages/arena_governance_gate_page_part_04.dart',
          'lib/features/arena/presentation/pages/arena_report_case_page.dart',
          'lib/features/arena/presentation/pages/arena_challenge_detail_page.dart',
          'lib/features/arena/presentation/pages/arena_challenge_detail_page_part_01.dart',
          'lib/features/arena/presentation/pages/arena_challenge_detail_page_part_02.dart',
          'lib/features/arena/presentation/pages/arena_challenge_detail_page_part_03.dart',
          'lib/features/arena/presentation/controllers/arena_controller.dart',
          'lib/features/arena/presentation/widgets/arena_state_cards.dart',
        ].map(_read).join('\n'),
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
      final source = _asciiFold(
        [
          'lib/features/arena/data/fixtures/mock_arena_repository_methods_part_03.dart',
          'lib/features/arena/data/fixtures/mock_arena_repository_methods_part_04.dart',
          'lib/features/arena/data/fixtures/mock_arena_repository_methods_part_05.dart',
          'lib/features/arena/data/fixtures/mock_arena_repository_methods_part_08.dart',
          'lib/features/arena/data/fixtures/mock_arena_repository_methods_part_09.dart',
          'lib/features/arena/data/fixtures/mock_arena_repository_methods_part_10.dart',
          'lib/features/arena/presentation/pages/verified_challenges_page.dart',
          'lib/features/arena/presentation/pages/arena_production_ready_page_part_01.dart',
          'lib/features/arena/presentation/pages/arena_production_ready_page_part_02.dart',
          'lib/features/arena/presentation/pages/connected_ecosystem_production_page.dart',
          'lib/features/arena/presentation/pages/connected_ecosystem_production_page_part_01.dart',
        ].map(_read).join('\n'),
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
        final otpPage = _read(
          'lib/features/auth/presentation/pages/otp_page.dart',
        );
        final authRoutes = _read(
          'lib/app/router/route_groups/auth_routes.dart',
        );

        expect(otpPage, isNot(contains('otp=')));
        expect(otpPage, isNot(contains('authResetPassword}?')));
        expect(authRoutes, isNot(contains("queryParameters['otp']")));
        expect(authRoutes, isNot(contains("queryParameters['email']")));
      },
    );

    test('Prediction and Wallet high-risk confirmations avoid unsafe copy', () {
      final predictionRisk = _read(
        'lib/features/predictions/presentation/pages/'
        'prediction_risk_calculator_page.dart',
      );
      expect(predictionRisk, isNot(contains('Total Bankroll')));
      expect(
        RegExp('bet size', caseSensitive: false).allMatches(predictionRisk),
        isEmpty,
      );
      expect(
        RegExp('payout', caseSensitive: false).allMatches(predictionRisk),
        isEmpty,
      );

      final tokenApproval = _read(
        'lib/features/wallet/presentation/pages/'
        'wallet_token_approval_page.dart',
      );
      expect(
        RegExp('mock flow', caseSensitive: false).allMatches(tokenApproval),
        isEmpty,
      );
    });

    test('Trade copy high-risk flow keeps suitability review roles', () {
      final source = _asciiFold(
        [
          'lib/features/trade/presentation/pages/copy_trading_page.dart',
          'lib/features/trade/presentation/pages/copy_trading_v2_page.dart',
          'lib/features/trade/presentation/pages/copy_confirmation_page.dart',
          'lib/features/trade/presentation/controllers/trade_controller_models.dart',
        ].map(_read).join('\n'),
      );

      final unsafe = RegExp(
        r'casino|jackpot|risk-free|guaranteed profit|no risk',
        caseSensitive: false,
      );
      expect(unsafe.allMatches(source), isEmpty);

      final roles = {
        'risk': [RegExp(r'\brisk\b|rui ro', caseSensitive: false)],
        'suitability': [
          RegExp(r'suitability|risk tolerance|phu hop', caseSensitive: false),
        ],
        'amount': [
          RegExp(r'copyCapital|copy amount|so von', caseSensitive: false),
        ],
        'limit': [RegExp(r'limit|20%|gioi han', caseSensitive: false)],
        'fee': [RegExp(r'\bfee\b|phi', caseSensitive: false)],
        'confirm': [RegExp(r'confirm|consent|xac nhan', caseSensitive: false)],
      };

      for (final entry in roles.entries) {
        final hasRole = entry.value.any((pattern) => pattern.hasMatch(source));
        expect(
          hasRole,
          isTrue,
          reason: 'Trade copy high-risk flow is missing ${entry.key} copy.',
        );
      }
    });

    test('Futures and margin flows keep leverage safety roles', () {
      final targets = [
        _HighRiskCopyTarget(
          path: 'lib/features/trade/presentation/pages/futures_page.dart',
          paths: [
            'lib/features/trade/presentation/pages/futures_page.dart',
            'lib/features/trade/presentation/pages/futures_page_part_01.dart',
            'lib/features/trade/presentation/pages/futures_page_part_02.dart',
            'lib/features/trade/presentation/pages/futures_page_part_03.dart',
          ],
          roles: {
            'risk': [RegExp(r'\brisk\b|rui ro', caseSensitive: false)],
            'margin': [RegExp(r'\bmargin\b|ky quy', caseSensitive: false)],
            'leverage': [
              RegExp(r'\bleverage\b|don bay|[0-9]+x', caseSensitive: false),
            ],
            'liquidation': [
              RegExp(r'liquidation|liquid|thanh ly', caseSensitive: false),
            ],
            'fee': [RegExp(r'\bfee\b|phi', caseSensitive: false)],
            'preview': [RegExp(r'\bpreview\b|review', caseSensitive: false)],
            'confirm': [
              RegExp(r'confirm|receipt|submit', caseSensitive: false),
            ],
          },
        ),
        _HighRiskCopyTarget(
          path:
              'lib/features/trade/presentation/pages/margin_trading_page.dart',
          paths: [
            'lib/features/trade/presentation/pages/margin_trading_page.dart',
            'lib/features/trade/presentation/pages/margin_trading_page_part_01.dart',
            'lib/features/trade/presentation/pages/margin_trading_page_part_02.dart',
            'lib/features/trade/presentation/pages/margin_trading_page_part_03.dart',
            'lib/features/trade/presentation/pages/margin_trading_page_part_04.dart',
            'lib/features/trade/presentation/pages/margin_trading_hub_page.dart',
            'lib/features/trade/presentation/widgets/margin_trading_hub_widgets.dart',
          ],
          roles: {
            'risk': [RegExp(r'\brisk\b|rui ro', caseSensitive: false)],
            'limit': [RegExp(r'\blimit\b|gioi han', caseSensitive: false)],
            'margin': [RegExp(r'\bmargin\b|ky quy', caseSensitive: false)],
            'leverage': [
              RegExp(r'\bleverage\b|don bay|[0-9]+x', caseSensitive: false),
            ],
            'liquidation': [
              RegExp(r'liquidation|liquid|thanh ly', caseSensitive: false),
            ],
            'fee': [RegExp(r'\bfee\b|phi', caseSensitive: false)],
            'preview': [RegExp(r'\bpreview\b|review', caseSensitive: false)],
          },
        ),
      ];

      final unsafe = RegExp(
        r'casino|jackpot|risk-free|guaranteed profit|no risk',
        caseSensitive: false,
      );

      for (final target in targets) {
        final source = _asciiFold(target.sourcePaths.map(_read).join('\n'));
        expect(unsafe.allMatches(source), isEmpty, reason: target.path);
        for (final entry in target.roles.entries) {
          final hasRole = entry.value.any(
            (pattern) => pattern.hasMatch(source),
          );
          expect(
            hasRole,
            isTrue,
            reason: '${target.path} is missing ${entry.key} safety copy.',
          );
        }
      }
    });

    test('Prediction event and portfolio surfaces keep Arena boundary copy', () {
      final source = _asciiFold(
        [
          'lib/features/predictions/presentation/pages/prediction_event_detail_page.dart',
          'lib/features/predictions/presentation/pages/prediction_event_detail_page_part_01.dart',
          'lib/features/predictions/presentation/pages/prediction_event_detail_page_part_02.dart',
          'lib/features/predictions/presentation/pages/prediction_event_detail_page_part_03.dart',
          'lib/features/predictions/presentation/pages/prediction_event_detail_page_part_04.dart',
          'lib/features/predictions/presentation/pages/prediction_event_detail_page_part_05.dart',
          'lib/features/predictions/presentation/pages/predictions_portfolio_page.dart',
          'lib/features/predictions/presentation/controllers/predictions_controller.dart',
        ].map(_read).join('\n'),
      );

      final unsafe = RegExp(
        r'casino|jackpot|risk-free|guaranteed profit|no risk',
        caseSensitive: false,
      );
      expect(unsafe.allMatches(source), isEmpty);

      final roles = {
        'positions': [RegExp(r'position|positions', caseSensitive: false)],
        'probability': [
          RegExp(r'probability|probabilityPct|chance', caseSensitive: false),
        ],
        'receipt': [RegExp(r'receipt', caseSensitive: false)],
        'rewards': [RegExp(r'rewards', caseSensitive: false)],
        'P/L': [RegExp(r'P/L|pnl', caseSensitive: false)],
        'order preview': [
          RegExp(r'Order Preview|PredictionOrderPreview|fee preview'),
        ],
        'Arena boundary': [
          RegExp(r'Arena Points only|Event context only', caseSensitive: false),
          RegExp(r'stay separate from Arena Points', caseSensitive: false),
        ],
      };

      for (final entry in roles.entries) {
        final hasRole = entry.value.any((pattern) => pattern.hasMatch(source));
        expect(
          hasRole,
          isTrue,
          reason: 'Prediction event/portfolio is missing ${entry.key} copy.',
        );
      }
    });

    test('P2P order, escrow, and wallet surfaces stay boundary-safe', () {
      final targets = [
        _HighRiskCopyTarget(
          path: 'lib/features/p2p/presentation/pages/p2p_order_page.dart',
          paths: [
            'lib/features/p2p/presentation/pages/p2p_order_page.dart',
            'lib/features/p2p/presentation/pages/p2p_order_page_part_01.dart',
            'lib/features/p2p/presentation/pages/p2p_order_page_part_02.dart',
            'lib/features/p2p/presentation/pages/p2p_order_page_part_03.dart',
          ],
          roles: {
            'escrow': [RegExp(r'escrow', caseSensitive: false)],
            'payment': [RegExp(r'payment|thanh toan', caseSensitive: false)],
            'fee': [RegExp(r'fee|feeLabel|phi', caseSensitive: false)],
            'confirm': [RegExp(r'confirm|xac nhan', caseSensitive: false)],
          },
        ),
        _HighRiskCopyTarget(
          path:
              'lib/features/p2p/presentation/pages/p2p_escrow_balance_page.dart',
          roles: {
            'escrow': [RegExp(r'escrow', caseSensitive: false)],
            'payment': [RegExp(r'payment', caseSensitive: false)],
            'release': [RegExp(r'release|giai phong', caseSensitive: false)],
            'dispute': [RegExp(r'dispute|tranh chap', caseSensitive: false)],
          },
        ),
        _HighRiskCopyTarget(
          path:
              'lib/features/p2p/presentation/pages/p2p_escrow_detail_page.dart',
          roles: {
            'escrow': [RegExp(r'escrow', caseSensitive: false)],
            'release': [RegExp(r'release|giai phong', caseSensitive: false)],
            'security': [RegExp(r'security|bao ve', caseSensitive: false)],
            'signature': [
              RegExp(r'signer|signed|chu ky', caseSensitive: false),
            ],
          },
        ),
        _HighRiskCopyTarget(
          path: 'lib/features/p2p/presentation/pages/p2p_wallet_page.dart',
          roles: {
            'wallet': [RegExp(r'wallet', caseSensitive: false)],
            'escrow': [RegExp(r'escrow', caseSensitive: false)],
            'transfer': [RegExp(r'transfer|chuyen', caseSensitive: false)],
            'locked': [RegExp(r'locked|khoa', caseSensitive: false)],
          },
        ),
      ];

      final arenaBoundaryLeak = RegExp(
        r'Arena\s+Points|points-only|points pool|rewardLabel',
        caseSensitive: false,
      );

      for (final target in targets) {
        final source = _asciiFold(target.sourcePaths.map(_read).join('\n'));
        expect(
          arenaBoundaryLeak.allMatches(source),
          isEmpty,
          reason: '${target.path} must not borrow Arena points language.',
        );
        for (final entry in target.roles.entries) {
          final hasRole = entry.value.any(
            (pattern) => pattern.hasMatch(source),
          );
          expect(
            hasRole,
            isTrue,
            reason: '${target.path} is missing ${entry.key} safety copy.',
          );
        }
      }
    });

    test('high-risk wallet and P2P flows keep confirmation safety roles', () {
      final targets = [
        _HighRiskCopyTarget(
          path: 'lib/features/wallet/presentation/pages/withdraw_page.dart',
          paths: [
            'lib/features/wallet/presentation/pages/withdraw_page.dart',
            'lib/features/wallet/presentation/widgets/withdraw_common.dart',
            'lib/features/wallet/presentation/widgets/withdraw_form_sections.dart',
            'lib/features/wallet/presentation/widgets/withdraw_network_picker.dart',
            'lib/features/wallet/presentation/widgets/withdraw_preview_sheet.dart',
            'lib/features/wallet/presentation/controllers/wallet_controller.dart',
          ],
          roles: {
            'preview': [RegExp(r'\bpreview\b|_PreviewRow')],
            'confirm': [RegExp(r'\bconfirm\b|xac nhan', caseSensitive: false)],
            'fee': [RegExp(r'\bfee\b|phi', caseSensitive: false)],
            'limit': [
              RegExp(r'minWithdraw|limit|toi thieu', caseSensitive: false),
            ],
            'risk': [
              RegExp(
                r'high-risk|\brisk\b|audit|maskedAddress',
                caseSensitive: false,
              ),
            ],
          },
        ),
        _HighRiskCopyTarget(
          path: 'lib/features/wallet/presentation/pages/address_add_page.dart',
          paths: [
            'lib/features/wallet/presentation/pages/address_add_page.dart',
            'lib/features/wallet/presentation/widgets/wallet_address_add_sections.dart',
            'lib/features/wallet/presentation/controllers/wallet_controller.dart',
          ],
          roles: {
            'preview': [RegExp(r'\bpreview\b|_PreviewPanel')],
            'confirm': [RegExp(r'\bconfirm\b|xac nhan', caseSensitive: false)],
            'destination': [
              RegExp(r'maskedAddress|address|dia chi', caseSensitive: false),
            ],
            'risk': [
              RegExp(
                r'auditTrailNote|khong the|kiem tra|\brisk\b',
                caseSensitive: false,
              ),
            ],
          },
        ),
        _HighRiskCopyTarget(
          path:
              'lib/features/wallet/presentation/pages/wallet_token_approval_page.dart',
          paths: [
            'lib/features/wallet/presentation/pages/wallet_token_approval_page.dart',
            'lib/features/wallet/presentation/widgets/wallet_token_revoke_sheet.dart',
            'lib/features/wallet/presentation/controllers/wallet_controller.dart',
          ],
          roles: {
            'preview': [RegExp(r'revokePreview|\bpreview\b')],
            'confirm': [
              RegExp(r'confirmLabel|\bconfirm\b', caseSensitive: false),
            ],
            'risk': [
              RegExp(r'\brisk\b|unlimited|protect', caseSensitive: false),
            ],
            'spender/token': [
              RegExp(r'spender|token|approval', caseSensitive: false),
            ],
          },
        ),
        _HighRiskCopyTarget(
          path:
              'lib/features/p2p/presentation/pages/p2p_payment_method_add_page.dart',
          roles: {
            'preview': [RegExp(r'\bpreview\b|_PaymentPreview')],
            'confirm': [RegExp(r'confirmMessage|confirmTitle|\bconfirm\b')],
            'account owner': [
              RegExp(r'ownerName|owner|chu tai khoan', caseSensitive: false),
            ],
            'security': [
              RegExp(
                r'securityNote|confirmMessage|ownership',
                caseSensitive: false,
              ),
            ],
          },
        ),
        _HighRiskCopyTarget(
          path: 'lib/features/p2p/presentation/pages/p2p_create_ad_page.dart',
          paths: [
            'lib/features/p2p/presentation/pages/p2p_create_ad_page.dart',
            'lib/features/p2p/presentation/widgets/p2p_create_ad_sections.dart',
            'lib/features/p2p/presentation/controllers/p2p_controller.dart',
          ],
          roles: {
            'preview': [RegExp(r'\bpreview\b|_LivePreviewCard')],
            'confirm': [
              RegExp(r'confirmPublish|\bconfirm\b', caseSensitive: false),
            ],
            'limit': [
              RegExp(
                r'minField|maxField|toi thieu|toi da',
                caseSensitive: false,
              ),
            ],
            'risk': [
              RegExp(
                r'warningNote|_WarningCard|terms|dieu khoan',
                caseSensitive: false,
              ),
            ],
            'payment': [RegExp(r'payment|thanh toan', caseSensitive: false)],
          },
        ),
      ];

      for (final target in targets) {
        final source = _asciiFold(target.sourcePaths.map(_read).join('\n'));
        for (final entry in target.roles.entries) {
          final hasRole = entry.value.any(
            (pattern) => pattern.hasMatch(source),
          );
          expect(
            hasRole,
            isTrue,
            reason: '${target.path} is missing ${entry.key} safety copy.',
          );
        }
      }
    });
  });
}

String _read(String path) {
  final file = File(path);
  expect(file.existsSync(), isTrue, reason: path);
  return file.readAsStringSync();
}

String _asciiFold(String value) {
  return value
      .replaceAll(RegExp('[àáạảãâầấậẩẫăằắặẳẵ]'), 'a')
      .replaceAll(RegExp('[èéẹẻẽêềếệểễ]'), 'e')
      .replaceAll(RegExp('[ìíịỉĩ]'), 'i')
      .replaceAll(RegExp('[òóọỏõôồốộổỗơờớợởỡ]'), 'o')
      .replaceAll(RegExp('[ùúụủũưừứựửữ]'), 'u')
      .replaceAll(RegExp('[ỳýỵỷỹ]'), 'y')
      .replaceAll(RegExp('[đ]'), 'd')
      .replaceAll(RegExp('[ÀÁẠẢÃÂẦẤẬẨẪĂẰẮẶẲẴ]'), 'A')
      .replaceAll(RegExp('[ÈÉẸẺẼÊỀẾỆỂỄ]'), 'E')
      .replaceAll(RegExp('[ÌÍỊỈĨ]'), 'I')
      .replaceAll(RegExp('[ÒÓỌỎÕÔỒỐỘỔỖƠỜỚỢỞỠ]'), 'O')
      .replaceAll(RegExp('[ÙÚỤỦŨƯỪỨỰỬỮ]'), 'U')
      .replaceAll(RegExp('[ỲÝỴỶỸ]'), 'Y')
      .replaceAll(RegExp('[Đ]'), 'D');
}

class _HighRiskCopyTarget {
  const _HighRiskCopyTarget({
    required this.path,
    this.paths = const <String>[],
    required this.roles,
  });

  final String path;
  final List<String> paths;
  final Map<String, List<RegExp>> roles;

  Iterable<String> get sourcePaths => paths.isEmpty ? [path] : paths;
}
