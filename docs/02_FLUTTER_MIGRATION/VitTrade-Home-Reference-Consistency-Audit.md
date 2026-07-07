# VitTrade Home Reference Consistency Audit

Generated: 2026-07-07

Generated from `flutter_app/tool/home_reference_consistency_audit.dart`. Measures structural divergence from the patterns established by `lib/features/home/presentation/**` — the canonical UI reference ("SC-007 HomePage", see Flutter-Module-Identity-Standard.md): raw `Container`/`BoxDecoration` instead of `VitCard`, `BorderRadius.circular(`/`Radius.circular(` instead of `AppRadii.*`, raw `EdgeInsets.*(` literals, and oversized fixed width/height literals. Every module — not just a P0 subset — is hard-gated against its own frozen baseline below; regressions fail CI.

## Module Gate (all modules, frozen baseline)

| module | current divergence | baseline | status |
| --- | ---: | ---: | --- |
| admin | 0 | 0 | pass |
| arena | 6 | 6 | pass |
| auth | 0 | 0 | pass |
| cross_module | 0 | 0 | pass |
| dca | 1 | 1 | pass |
| dev | 0 | 0 | pass |
| discovery | 0 | 0 | pass |
| earn | 10 | 10 | pass |
| enterprise_states | 0 | 0 | pass |
| home | 0 | 0 | pass |
| launchpad | 0 | 0 | pass |
| markets | 0 | 0 | pass |
| news | 1 | 1 | pass |
| notifications | 1 | 1 | pass |
| onboarding | 0 | 0 | pass |
| p2p | 5 | 5 | pass |
| predictions | 12 | 12 | pass |
| profile | 0 | 0 | pass |
| referral | 0 | 0 | pass |
| rewards | 2 | 2 | pass |
| support | 3 | 3 | pass |
| trade | 15 | 15 | pass |
| wallet | 15 | 15 | pass |

## Top Divergence Files (non-exception)
| module | path | total | container | boxDecoration | borderRadius.circular | radius.circular | edgeInsets | fixedWidth | fixedHeight |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| predictions | `flutter_app/lib/features/predictions/presentation/widgets/predictions_home_highlights.dart` | 2 | 1 | 0 | 0 | 0 | 1 | 0 | 0 |
| earn | `flutter_app/lib/features/earn/presentation/widgets/savings_home_hero.dart` | 2 | 1 | 0 | 0 | 0 | 1 | 0 | 0 |
| earn | `flutter_app/lib/features/earn/presentation/widgets/savings_home_hero.dart` | 2 | 1 | 0 | 0 | 0 | 1 | 0 | 0 |
| earn | `flutter_app/lib/features/earn/presentation/widgets/staking_dashboard_summary.dart` | 2 | 1 | 0 | 0 | 0 | 1 | 0 | 0 |
| earn | `flutter_app/lib/features/earn/presentation/widgets/staking_earn_hero_tabs.dart` | 2 | 1 | 0 | 0 | 0 | 1 | 0 | 0 |
| earn | `flutter_app/lib/features/earn/presentation/widgets/staking_earn_hero_tabs.dart` | 2 | 1 | 0 | 0 | 0 | 1 | 0 | 0 |
| trade | `flutter_app/lib/features/trade/presentation/widgets/copy_trading_hero.dart` | 2 | 1 | 0 | 0 | 0 | 1 | 0 | 0 |
| wallet | `flutter_app/lib/features/wallet/presentation/widgets/withdraw_limits_page_sections.dart` | 2 | 1 | 1 | 0 | 0 | 0 | 0 | 0 |
| wallet | `flutter_app/lib/features/wallet/presentation/widgets/wallet_address_book_security.dart` | 2 | 1 | 1 | 0 | 0 | 0 | 0 | 0 |
| wallet | `flutter_app/lib/features/wallet/presentation/widgets/wallet_address_book_security.dart` | 2 | 1 | 1 | 0 | 0 | 0 | 0 | 0 |
| wallet | `flutter_app/lib/features/wallet/presentation/widgets/pending_deposits_page_sections.dart` | 2 | 0 | 2 | 0 | 0 | 0 | 0 | 0 |
| trade | `flutter_app/lib/features/trade/presentation/widgets/copy_trading_hero.dart` | 2 | 1 | 0 | 0 | 0 | 1 | 0 | 0 |
| trade | `flutter_app/lib/features/trade/presentation/widgets/bot_faq_cards_help.dart` | 2 | 0 | 1 | 0 | 0 | 1 | 0 | 0 |
| trade | `flutter_app/lib/features/trade/presentation/widgets/bot_faq_cards_help.dart` | 2 | 0 | 1 | 0 | 0 | 1 | 0 | 0 |
| trade | `flutter_app/lib/features/trade/presentation/pages/trading_bots_page_part_02.dart` | 2 | 1 | 1 | 0 | 0 | 0 | 0 | 0 |
| wallet | `flutter_app/lib/features/wallet/presentation/widgets/withdraw_limits_page_sections.dart` | 2 | 1 | 1 | 0 | 0 | 0 | 0 | 0 |
| rewards | `flutter_app/lib/features/rewards/presentation/pages/rewards_hub_page_part_01.dart` | 2 | 1 | 0 | 0 | 0 | 1 | 0 | 0 |
| predictions | `flutter_app/lib/features/predictions/presentation/widgets/predictions_home_highlights.dart` | 2 | 1 | 0 | 0 | 0 | 1 | 0 | 0 |
| wallet | `flutter_app/lib/features/wallet/presentation/widgets/pending_deposits_page_sections.dart` | 2 | 0 | 2 | 0 | 0 | 0 | 0 | 0 |
| predictions | `flutter_app/lib/features/predictions/presentation/widgets/predictions_breaking_page_common.dart` | 1 | 0 | 0 | 0 | 0 | 1 | 0 | 0 |
| predictions | `flutter_app/lib/features/predictions/presentation/widgets/predictions_breaking_page_common.dart` | 1 | 0 | 0 | 0 | 0 | 1 | 0 | 0 |
| predictions | `flutter_app/lib/features/predictions/presentation/widgets/predictions_global_activity_widgets.dart` | 1 | 1 | 0 | 0 | 0 | 0 | 0 | 0 |
| predictions | `flutter_app/lib/features/predictions/presentation/widgets/predictions_global_activity_widgets.dart` | 1 | 1 | 0 | 0 | 0 | 0 | 0 | 0 |
| predictions | `flutter_app/lib/features/predictions/presentation/widgets/predictions_home_events.dart` | 1 | 0 | 0 | 0 | 0 | 1 | 0 | 0 |
| predictions | `flutter_app/lib/features/predictions/presentation/widgets/predictions_home_events.dart` | 1 | 0 | 0 | 0 | 0 | 1 | 0 | 0 |
| p2p | `flutter_app/lib/features/p2p/presentation/widgets/p2p_insurance_score_page_sections.dart` | 1 | 0 | 1 | 0 | 0 | 0 | 0 | 0 |
| arena | `flutter_app/lib/features/arena/presentation/pages/arena_challenge_detail_page_part_01.dart` | 1 | 1 | 0 | 0 | 0 | 0 | 0 | 0 |
| predictions | `flutter_app/lib/features/predictions/presentation/widgets/predictions_search_page_common.dart` | 1 | 0 | 0 | 0 | 0 | 1 | 0 | 0 |
| predictions | `flutter_app/lib/features/predictions/presentation/widgets/predictions_search_page_common.dart` | 1 | 0 | 0 | 0 | 0 | 1 | 0 | 0 |
| p2p | `flutter_app/lib/features/p2p/presentation/widgets/p2p_escrow_balance_page_sections.dart` | 1 | 0 | 1 | 0 | 0 | 0 | 0 | 0 |
| support | `flutter_app/lib/features/support/presentation/pages/announcements_page.dart` | 1 | 0 | 0 | 0 | 0 | 1 | 0 | 0 |
| support | `flutter_app/lib/features/support/presentation/pages/help_center_page.dart` | 1 | 0 | 0 | 0 | 0 | 1 | 0 | 0 |
| support | `flutter_app/lib/features/support/presentation/pages/support_page.dart` | 1 | 0 | 0 | 0 | 0 | 1 | 0 | 0 |
| p2p | `flutter_app/lib/features/p2p/presentation/widgets/p2p_escrow_balance_page_sections.dart` | 1 | 0 | 1 | 0 | 0 | 0 | 0 | 0 |
| trade | `flutter_app/lib/features/trade/presentation/pages/target_market_definition_page.dart` | 1 | 0 | 1 | 0 | 0 | 0 | 0 | 0 |
| trade | `flutter_app/lib/features/trade/presentation/pages/trading_bots_page_part_01.dart` | 1 | 0 | 0 | 0 | 0 | 1 | 0 | 0 |
| p2p | `flutter_app/lib/features/p2p/presentation/pages/p2p_claim_detail_page_part_01.dart` | 1 | 0 | 0 | 0 | 0 | 1 | 0 | 0 |
| notifications | `flutter_app/lib/features/notifications/presentation/pages/notifications_page.dart` | 1 | 0 | 0 | 0 | 0 | 1 | 0 | 0 |
| news | `flutter_app/lib/features/news/presentation/pages/news_page.dart` | 1 | 0 | 0 | 0 | 0 | 1 | 0 | 0 |
| dca | `flutter_app/lib/features/dca/presentation/pages/dca_page_part_01.dart` | 1 | 0 | 0 | 0 | 0 | 1 | 0 | 0 |
| arena | `flutter_app/lib/features/arena/presentation/widgets/arena_points_ledger_page_sections.dart` | 1 | 1 | 0 | 0 | 0 | 0 | 0 | 0 |
| trade | `flutter_app/lib/features/trade/presentation/widgets/trade_module_layout.dart` | 1 | 0 | 0 | 0 | 0 | 1 | 0 | 0 |
| trade | `flutter_app/lib/features/trade/presentation/widgets/vit_trade_product_tabs.dart` | 1 | 0 | 1 | 0 | 0 | 0 | 0 | 0 |
| trade | `flutter_app/lib/features/trade/presentation/pages/complaint_tracking_page.dart` | 1 | 0 | 1 | 0 | 0 | 0 | 0 | 0 |
| arena | `flutter_app/lib/features/arena/presentation/widgets/arena_points_ledger_page_sections.dart` | 1 | 1 | 0 | 0 | 0 | 0 | 0 | 0 |
| wallet | `flutter_app/lib/features/wallet/presentation/widgets/transaction_detail_page_sections.dart` | 1 | 0 | 1 | 0 | 0 | 0 | 0 | 0 |
| wallet | `flutter_app/lib/features/wallet/presentation/widgets/transaction_detail_page_sections.dart` | 1 | 0 | 1 | 0 | 0 | 0 | 0 | 0 |
| arena | `flutter_app/lib/features/arena/presentation/widgets/arena_mode_detail_hero.dart` | 1 | 1 | 0 | 0 | 0 | 0 | 0 | 0 |
| arena | `flutter_app/lib/features/arena/presentation/pages/arena_points_page_part_01.dart` | 1 | 1 | 0 | 0 | 0 | 0 | 0 | 0 |
| wallet | `flutter_app/lib/features/wallet/presentation/widgets/wallet_page_balance_sections.dart` | 1 | 1 | 0 | 0 | 0 | 0 | 0 | 0 |
| arena | `flutter_app/lib/features/arena/presentation/pages/arena_home_page_part_01.dart` | 1 | 1 | 0 | 0 | 0 | 0 | 0 | 0 |
| p2p | `flutter_app/lib/features/p2p/presentation/widgets/p2p_insurance_score_page_sections.dart` | 1 | 0 | 1 | 0 | 0 | 0 | 0 | 0 |

## Verification Commands
```bash
cd flutter_app
dart run tool/home_reference_consistency_audit.dart
dart run tool/home_reference_consistency_audit.dart --check
```
