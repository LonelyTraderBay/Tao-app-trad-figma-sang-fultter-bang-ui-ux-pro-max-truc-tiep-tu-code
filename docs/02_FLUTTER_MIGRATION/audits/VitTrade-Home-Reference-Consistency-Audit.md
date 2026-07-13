# VitTrade Home Reference Consistency Audit

Generated: 2026-07-07

Generated from `flutter_app/tool/home_reference_consistency_audit.dart`. Measures structural divergence from the patterns established by `lib/features/home/presentation/**` — the canonical UI reference ("SC-007 HomePage", see Flutter-Module-Identity-Standard.md): raw `Container`/`BoxDecoration` instead of `VitCard`, `BorderRadius.circular(`/`Radius.circular(` instead of `AppRadii.*`, raw `EdgeInsets.*(` literals, and oversized fixed width/height literals. Every module — not just a P0 subset — is hard-gated against its own frozen baseline below; regressions fail CI.

## Module Gate (all modules, frozen baseline)

| module | current divergence | baseline | status |
| --- | ---: | ---: | --- |
| admin | 0 | 0 | pass |
| arena | 5 | 6 | pass |
| auth | 0 | 0 | pass |
| cross_module | 0 | 0 | pass |
| dca | 1 | 1 | pass |
| dev | 0 | 0 | pass |
| discovery | 0 | 0 | pass |
| earn | 0 | 0 | pass |
| enterprise_states | 0 | 0 | pass |
| home | 0 | 0 | pass |
| launchpad | 0 | 0 | pass |
| markets | 0 | 0 | pass |
| news | 1 | 1 | pass |
| notifications | 1 | 1 | pass |
| onboarding | 0 | 0 | pass |
| p2p | 5 | 5 | pass |
| predictions | 0 | 0 | pass |
| profile | 0 | 0 | pass |
| referral | 0 | 0 | pass |
| rewards | 2 | 2 | pass |
| support | 3 | 3 | pass |
| trade_bots | 0 | 0 | pass |
| trade_compliance | 0 | 0 | pass |
| trade_copy | 0 | 0 | pass |
| trade_core | 0 | 0 | pass |
| trade_terminal | 0 | 0 | pass |
| wallet | 0 | 0 | pass |

## Top Divergence Files (non-exception)
| module | path | total | container | boxDecoration | borderRadius.circular | radius.circular | edgeInsets | fixedWidth | fixedHeight |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| rewards | `flutter_app/lib/features/rewards/presentation/pages/rewards_hub_page_part_01.dart` | 2 | 1 | 0 | 0 | 0 | 1 | 0 | 0 |
| arena | `flutter_app/lib/features/arena/presentation/pages/arena_challenge_detail_page_part_01.dart` | 1 | 1 | 0 | 0 | 0 | 0 | 0 | 0 |
| arena | `flutter_app/lib/features/arena/presentation/pages/arena_home_page_part_01.dart` | 1 | 1 | 0 | 0 | 0 | 0 | 0 | 0 |
| arena | `flutter_app/lib/features/arena/presentation/widgets/arena_mode_detail_hero.dart` | 1 | 1 | 0 | 0 | 0 | 0 | 0 | 0 |
| arena | `flutter_app/lib/features/arena/presentation/widgets/arena_points_ledger_page_sections.dart` | 1 | 1 | 0 | 0 | 0 | 0 | 0 | 0 |
| arena | `flutter_app/lib/features/arena/presentation/widgets/arena_points_ledger_page_sections.dart` | 1 | 1 | 0 | 0 | 0 | 0 | 0 | 0 |
| dca | `flutter_app/lib/features/dca/presentation/pages/dca_page_part_01.dart` | 1 | 0 | 0 | 0 | 0 | 1 | 0 | 0 |
| news | `flutter_app/lib/features/news/presentation/pages/news_page.dart` | 1 | 0 | 0 | 0 | 0 | 1 | 0 | 0 |
| notifications | `flutter_app/lib/features/notifications/presentation/pages/notifications_page.dart` | 1 | 0 | 0 | 0 | 0 | 1 | 0 | 0 |
| p2p | `flutter_app/lib/features/p2p/presentation/pages/p2p_claim_detail_page_part_01.dart` | 1 | 0 | 0 | 0 | 0 | 1 | 0 | 0 |
| p2p | `flutter_app/lib/features/p2p/presentation/widgets/p2p_escrow_balance_page_sections.dart` | 1 | 0 | 1 | 0 | 0 | 0 | 0 | 0 |
| p2p | `flutter_app/lib/features/p2p/presentation/widgets/p2p_escrow_balance_page_sections.dart` | 1 | 0 | 1 | 0 | 0 | 0 | 0 | 0 |
| p2p | `flutter_app/lib/features/p2p/presentation/widgets/p2p_insurance_score_page_sections.dart` | 1 | 0 | 1 | 0 | 0 | 0 | 0 | 0 |
| p2p | `flutter_app/lib/features/p2p/presentation/widgets/p2p_insurance_score_page_sections.dart` | 1 | 0 | 1 | 0 | 0 | 0 | 0 | 0 |
| support | `flutter_app/lib/features/support/presentation/pages/announcements_page.dart` | 1 | 0 | 0 | 0 | 0 | 1 | 0 | 0 |
| support | `flutter_app/lib/features/support/presentation/pages/help_center_page.dart` | 1 | 0 | 0 | 0 | 0 | 1 | 0 | 0 |
| support | `flutter_app/lib/features/support/presentation/pages/support_page.dart` | 1 | 0 | 0 | 0 | 0 | 1 | 0 | 0 |

## Verification Commands
```bash
cd flutter_app
dart run tool/home_reference_consistency_audit.dart
dart run tool/home_reference_consistency_audit.dart --check
```
