# Flutter Enterprise Post-E900 Refactor Execution Guide

Generated: 2026-06-01

This guide is the post-E900 execution file for the VitTrade Flutter repository.
Use it when continuing large-file cleanup after all E900 packets are complete.
It is intentionally explicit so the next AI pass can scan, select, refactor,
verify, and log without missing files.

## Scope

Source of truth:

- Flutter package: `flutter_app/`
- App source: `flutter_app/lib/`
- Tests: `flutter_app/test/`
- Public router facade: `flutter_app/lib/app/router/app_router.dart`
- E900 tracker: `docs/02_FLUTTER_MIGRATION/Flutter-Enterprise-900-Line-Refactor-Tracking.md`
- Legacy large-file tracker: `docs/02_FLUTTER_MIGRATION/Flutter-Large-File-Enterprise-Refactor-Tracking.md`

This is a maintainability refactor only. Preserve routing, UI intent, product
copy, financial safety language, tests, provider boundaries, and module
boundaries.

## Enterprise Targets

| File type | Ideal target | Hard target | Notes |
| --- | ---: | ---: | --- |
| Presentation pages | 300-600 lines | below 900 lines | Page keeps state, providers, navigation, and top-level composition only. |
| Presentation widgets | 100-400 lines | below 600 lines | Extract visual sections, rows, cards, sheets, lists, tabs, and painters. |
| Data repositories | 200-500 lines | below 900 lines | Keep public repository APIs stable. |
| Controllers | 150-500 lines | below 800 lines | Keep public provider/controller contracts stable. |
| Domain entities | 100-500 lines | below 800 lines | Prefer cohesive entity files, not arbitrary splitting. |
| Painters/chart files | 100-400 lines | below 600 lines | Keep rendering behavior unchanged. |

## Status Legend

- `[ ]` Not started.
- `[~]` In progress. Must be resumed before starting another packet.
- `[x]` Complete and verified.
- `[!]` Blocked or intentionally excepted with documented reason.

## Non-Negotiable Rules

1. Resume the first `[~]` packet before starting any `[ ]` packet.
2. Mark a packet `[~]` before edits.
3. Finish one packet completely before moving to the next.
4. Do not redesign screens or rewrite flows.
5. Do not merge Prediction Markets and Open Arena language or concepts.
6. Do not introduce presentation imports from `features/*/data`.
7. Do not introduce runtime `Colors.*`; use theme tokens.
8. Prefer `package:vit_trade_flutter/...` imports.
9. Format every touched Dart file.
10. Run focused tests plus required guardrails before marking `[x]`.
11. Update this guide or the active tracker with before/after line counts,
    new files, commands, results, and exceptions.

## Required Work Loop

Run this loop for every packet.

1. From repo root, inspect worktree:

   ```powershell
   git status --short
   ```

2. Read this guide and pick the next packet:

   - Resume first `[~]`.
   - Otherwise start first `[ ]`.
   - Mark selected packet `[~]` before edits.

3. From `flutter_app/`, regenerate line-count inventory:

   ```powershell
   $root=(Resolve-Path .).Path
   Get-ChildItem lib -Recurse -Filter *.dart |
     Where-Object { $_.FullName -match '\\presentation\\pages\\' } |
     ForEach-Object {
       $rel=$_.FullName.Substring($root.Length+1)
       $lines=(Get-Content $_.FullName).Count
       if ($lines -gt 900) { "$lines $rel" }
     } | Sort-Object {[int](($_ -split ' ')[0])} -Descending
   ```

4. Check symbol boundaries before extraction:

   ```powershell
   rg -n "^class |^enum |^extension |^mixin |^typedef |^final class " <target-files>
   ```

5. Identify stable behavior to preserve:

   - Route names and `GoRouter` calls.
   - Riverpod reads, watches, controllers, and providers.
   - Keys used by tests.
   - Loading, empty, error, offline, submitting, and success states.
   - Financial previews, fees, limits, warnings, next steps.
   - Prediction Markets vs Open Arena wording boundaries.

6. Extract only cohesive UI or data sections:

   - Move visual sections to `features/<feature>/presentation/widgets/`.
   - Keep page-level state and navigation inside `presentation/pages/`.
   - Keep repositories under `features/<feature>/data/repositories/`.
   - Keep contracts and value objects under `features/<feature>/domain/`.
   - Use `part` files only when preserving private boundaries is cleaner than
     public widget imports.

7. Format touched Dart files:

   ```powershell
   dart format <touched-dart-files>
   ```

8. Run verification from `flutter_app/`:

   ```powershell
   flutter analyze
   flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact
   ```

   Add feature and copy/semantics tests from the packet verification matrix.

9. Run direct grep on touched files:

   ```powershell
   rg -n "features/.*/data|\bColors\." <touched-dart-files>
   ```

   Expected result: no new presentation-to-data imports and no new runtime
   `Colors.*` usage.

10. Re-count touched files and update packet notes:

    - Before line counts.
    - After line counts.
    - New files.
    - Commands and results.
    - GitNexus result or fallback reason.

11. Mark packet:

    - `[x]` only when complete and verified.
    - `[!]` only with a concrete blocker, exception, and resume instruction.

12. Continue immediately to the next `[ ]` or `[~]` packet.

## GitNexus Requirement

Before each packet, check for GitNexus MCP tools. If available, use:

- `gitnexus://repos`
- repo context and clusters
- `query`
- `context`
- `impact`
- `detect_changes`

If MCP tools are not available, run from repo root:

```powershell
npx -y gitnexus@latest analyze . --skip-agents-md --embeddings --worker-timeout 60
npx -y gitnexus@latest status
```

If embeddings or install are too slow, retry:

```powershell
npx -y gitnexus@latest analyze . --skip-agents-md --skip-embeddings --worker-timeout 60
```

Do not set `GITNEXUS_SKIP_OPTIONAL_GRAMMARS=1`, because that skips Dart
parsing. If GitNexus cannot run, continue with `rg`, Dart analyzer, and focused
tests, then log the failure in the packet notes.

## Verification Matrix

| Area touched | Required commands from `flutter_app/` |
| --- | --- |
| Any packet | `flutter analyze`; `flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact` |
| P2P | `flutter test test/features/p2p --reporter=compact`; product copy guardrail; accessibility semantics guardrail |
| Wallet | `flutter test test/features/wallet --reporter=compact`; product copy guardrail; accessibility semantics guardrail for high-risk flows |
| Auth/profile security | relevant feature test; accessibility semantics guardrail |
| Trade/copy/bot/leverage | `flutter test test/features/trade --reporter=compact`; product copy guardrail when financial copy or risk copy changes |
| Earn/staking/savings | `flutter test test/features/earn --reporter=compact`; product copy guardrail when safety copy changes |
| Predictions | `flutter test test/features/predictions --reporter=compact`; product copy guardrail |
| Arena | `flutter test test/features/arena --reporter=compact`; product copy guardrail to protect points-only wording |
| Launchpad | `flutter test test/features/launchpad --reporter=compact`; product copy guardrail if order or bridge copy changes |
| Markets | `flutter test test/features/markets --reporter=compact` |
| DCA/referral/cross-module | matching feature suite plus architecture guardrail |

Product copy guardrail:

```powershell
flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact
```

Accessibility semantics guardrail:

```powershell
flutter test test/quality/accessibility_semantics_critical_flows_test.dart --reporter=compact
```

## Packet Board

### PE900F-01 - P2P Hard Page Wave

Status: `[x]`

Priority: P0

Goal: Bring every remaining P2P presentation page above 900 lines below the
hard target while preserving payment, escrow, merchant, order-book, and guide
behavior.

Targets:

| Current lines | File | Suggested extraction direction |
| ---: | --- | --- |
| 959 | `flutter_app/lib/features/p2p/presentation/pages/p2p_guide_page.dart` | Guide header, guide steps, topic sections, FAQ/common helpers. |
| 950 | `flutter_app/lib/features/p2p/presentation/pages/p2p_ad_detail_page.dart` | Ad header, terms, stats/safety, action/footer widgets. |
| 909 | `flutter_app/lib/features/p2p/presentation/pages/p2p_order_book_page.dart` | Filters, summaries, order rows, order-book common widgets. |
| 909 | `flutter_app/lib/features/p2p/presentation/pages/p2p_settings_page.dart` | Security, trade/payment settings, notifications, settings common widgets. |
| 901 | `flutter_app/lib/features/p2p/presentation/pages/p2p_merchant_profile_page.dart` | Merchant header, stats, ads/feedback, profile common widgets. |

Suggested new files:

- `flutter_app/lib/features/p2p/presentation/widgets/p2p_guide_sections.dart`
- `flutter_app/lib/features/p2p/presentation/widgets/p2p_ad_detail_sections.dart`
- `flutter_app/lib/features/p2p/presentation/widgets/p2p_order_book_sections.dart`
- `flutter_app/lib/features/p2p/presentation/widgets/p2p_settings_sections.dart`
- `flutter_app/lib/features/p2p/presentation/widgets/p2p_merchant_profile_sections.dart`

Adjust names after reading symbol boundaries. Prefer one cohesive section file
per page unless the extracted widgets are independently reusable.

Required verification:

```powershell
flutter analyze
flutter test test/features/p2p --reporter=compact
flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact
flutter test test/quality/accessibility_semantics_critical_flows_test.dart --reporter=compact
flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact
```

Completion notes:

- Before counts:
  - `p2p_guide_page.dart`: `959`
  - `p2p_ad_detail_page.dart`: `950`
  - `p2p_order_book_page.dart`: `909`
  - `p2p_settings_page.dart`: `909`
  - `p2p_merchant_profile_page.dart`: `901`
- After counts:
  - `p2p_guide_page.dart`: `126`
  - `p2p_ad_detail_page.dart`: `143`
  - `p2p_order_book_page.dart`: `124`
  - `p2p_settings_page.dart`: `198`
  - `p2p_merchant_profile_page.dart`: `196`
  - Current presentation page scan found no files above `900` lines.
- New files:
  - `flutter_app/lib/features/p2p/presentation/widgets/p2p_guide_tabs_faq.dart` (`183` lines)
  - `flutter_app/lib/features/p2p/presentation/widgets/p2p_guide_steps_safety.dart` (`329` lines)
  - `flutter_app/lib/features/p2p/presentation/widgets/p2p_guide_video_common.dart` (`328` lines)
  - `flutter_app/lib/features/p2p/presentation/widgets/p2p_ad_detail_merchant_info.dart` (`333` lines)
  - `flutter_app/lib/features/p2p/presentation/widgets/p2p_ad_detail_amount_terms.dart` (`479` lines)
  - `flutter_app/lib/features/p2p/presentation/widgets/p2p_order_book_selector_ticker.dart` (`300` lines)
  - `flutter_app/lib/features/p2p/presentation/widgets/p2p_order_book_cards_lists.dart` (`328` lines)
  - `flutter_app/lib/features/p2p/presentation/widgets/p2p_order_book_painter.dart` (`164` lines)
  - `flutter_app/lib/features/p2p/presentation/widgets/p2p_settings_trade_security.dart` (`419` lines)
  - `flutter_app/lib/features/p2p/presentation/widgets/p2p_settings_hours_common.dart` (`297` lines)
  - `flutter_app/lib/features/p2p/presentation/widgets/p2p_merchant_profile_header_stats.dart` (`397` lines)
  - `flutter_app/lib/features/p2p/presentation/widgets/p2p_merchant_profile_ads_reviews.dart` (`313` lines)
- Commands/results:
  - `dart format` on `17` touched P2P page/widget files passed.
  - `flutter analyze` passed (`No issues found!`).
  - Direct grep `rg -n "features/.*/data|\bColors\."` over touched Dart files returned no matches.
  - `flutter test test/features/p2p --reporter=compact` passed (`311` tests).
  - `flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact` passed (`10` tests).
  - `flutter test test/quality/accessibility_semantics_critical_flows_test.dart --reporter=compact` passed (`6` tests).
  - `flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact` passed (`13` tests).
- GitNexus/fallback:
  - GitNexus MCP tools were unavailable via tool discovery.
  - `npx -y gitnexus@latest analyze . --skip-agents-md --embeddings --worker-timeout 60`,
    `npx -y gitnexus@latest status`, and retry
    `npx -y gitnexus@latest analyze . --skip-agents-md --skip-embeddings --worker-timeout 60`
    all failed with `Cannot destructure property 'package' of 'node.target' as it is null`.
  - Continued with `rg`, symbol-boundary scan, analyzer, focused feature tests,
    and quality guardrails.

### PE900F-02 - P2P Create-Ad Widget Hard Breach

Status: `[x]`

Priority: P0

Goal: Bring `p2p_create_ad_sections.dart` below the widget hard target.

Targets:

| Current lines | File | Suggested extraction direction |
| ---: | --- | --- |
| 607 | `flutter_app/lib/features/p2p/presentation/widgets/p2p_create_ad_sections.dart` | Payment method section, pricing section, limit section, safety/confirmation common widgets. |

Required verification:

```powershell
flutter analyze
flutter test test/features/p2p --reporter=compact
flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact
flutter test test/quality/accessibility_semantics_critical_flows_test.dart --reporter=compact
flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact
```

Completion notes:

- Before counts:
  - `p2p_create_ad_sections.dart`: `607`
- After counts:
  - `p2p_create_ad_sections.dart`: `584`
  - `p2p_create_ad_preview_badge.dart`: `32`
  - Current presentation widget scan found no files above `600` lines.
- New files:
  - `flutter_app/lib/features/p2p/presentation/widgets/p2p_create_ad_preview_badge.dart`
- Commands/results:
  - `dart format lib/features/p2p/presentation/widgets/p2p_create_ad_sections.dart lib/features/p2p/presentation/widgets/p2p_create_ad_preview_badge.dart` passed.
  - `flutter analyze` passed (`No issues found!`).
  - Direct grep `rg -n "features/.*/data|\bColors\."` over touched Dart files returned no matches.
  - `flutter test test/features/p2p --reporter=compact` passed (`311` tests).
  - `flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact` passed (`10` tests).
  - `flutter test test/quality/accessibility_semantics_critical_flows_test.dart --reporter=compact` passed (`6` tests).
  - `flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact` passed (`13` tests).
- GitNexus/fallback:
  - Reused PE900F-01 GitNexus preflight result for this consecutive P2P widget packet:
    MCP tools unavailable and CLI failed with
    `Cannot destructure property 'package' of 'node.target' as it is null`.
  - Continued with `rg`, analyzer, focused P2P tests, and quality guardrails.

### PE800-01 - P2P Near-Hard Page Wave

Status: `[x]`

Priority: P1

Goal: Bring the largest P2P 800-900 line pages closer to the page ideal target
before they cross the hard threshold again.

Targets:

| Current lines | File |
| ---: | --- |
| 881 | `flutter_app/lib/features/p2p/presentation/pages/p2p_device_management_page.dart` |
| 864 | `flutter_app/lib/features/p2p/presentation/pages/p2p_security_center_page.dart` |
| 836 | `flutter_app/lib/features/p2p/presentation/pages/p2p_chat_page.dart` |
| 829 | `flutter_app/lib/features/p2p/presentation/pages/p2p_escrow_detail_page.dart` |
| 805 | `flutter_app/lib/features/p2p/presentation/pages/p2p_my_ads_page.dart` |
| 803 | `flutter_app/lib/features/p2p/presentation/pages/p2p_trading_level_page.dart` |

Required verification:

```powershell
flutter analyze
flutter test test/features/p2p --reporter=compact
flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact
flutter test test/quality/accessibility_semantics_critical_flows_test.dart --reporter=compact
flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact
```

Completion notes:

- Before counts:
  - `p2p_device_management_page.dart`: `881`
  - `p2p_security_center_page.dart`: `864`
  - `p2p_chat_page.dart`: `836`
  - `p2p_escrow_detail_page.dart`: `829`
  - `p2p_my_ads_page.dart`: `805`
  - `p2p_trading_level_page.dart`: `803`
- After counts:
  - `p2p_device_management_page.dart`: `194`
  - `p2p_security_center_page.dart`: `265`
  - `p2p_chat_page.dart`: `161`
  - `p2p_escrow_detail_page.dart`: `142`
  - `p2p_my_ads_page.dart`: `228`
  - `p2p_trading_level_page.dart`: `98`
  - Current 800-900 page scan found no P2P pages.
- New files:
  - `flutter_app/lib/features/p2p/presentation/widgets/p2p_device_management_overview.dart` (`151` lines)
  - `flutter_app/lib/features/p2p/presentation/widgets/p2p_device_management_cards.dart` (`453` lines)
  - `flutter_app/lib/features/p2p/presentation/widgets/p2p_device_management_tips.dart` (`90` lines)
  - `flutter_app/lib/features/p2p/presentation/widgets/p2p_security_center_score_features.dart` (`303` lines)
  - `flutter_app/lib/features/p2p/presentation/widgets/p2p_security_center_actions_events.dart` (`301` lines)
  - `flutter_app/lib/features/p2p/presentation/widgets/p2p_chat_header_banners.dart` (`257` lines)
  - `flutter_app/lib/features/p2p/presentation/widgets/p2p_chat_messages.dart` (`159` lines)
  - `flutter_app/lib/features/p2p/presentation/widgets/p2p_chat_composer_actions.dart` (`266` lines)
  - `flutter_app/lib/features/p2p/presentation/widgets/p2p_escrow_detail_status_address.dart` (`175` lines)
  - `flutter_app/lib/features/p2p/presentation/widgets/p2p_escrow_detail_multisig_order.dart` (`258` lines)
  - `flutter_app/lib/features/p2p/presentation/widgets/p2p_escrow_detail_timeline_actions.dart` (`261` lines)
  - `flutter_app/lib/features/p2p/presentation/widgets/p2p_my_ads_stats_cards.dart` (`394` lines)
  - `flutter_app/lib/features/p2p/presentation/widgets/p2p_my_ads_empty_links.dart` (`188` lines)
  - `flutter_app/lib/features/p2p/presentation/widgets/p2p_trading_level_hero_progress.dart` (`308` lines)
  - `flutter_app/lib/features/p2p/presentation/widgets/p2p_trading_level_cards.dart` (`402` lines)
- Commands/results:
  - `dart format` on `21` touched P2P page/widget files passed.
  - `flutter analyze` passed (`No issues found!`).
  - Direct grep `rg -n "features/.*/data|\bColors\."` over touched Dart files returned no matches.
  - `flutter test test/features/p2p --reporter=compact` passed (`311` tests).
  - `flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact` passed (`10` tests).
  - `flutter test test/quality/accessibility_semantics_critical_flows_test.dart --reporter=compact` passed (`6` tests).
  - Initial product copy guardrail caught that `p2p_escrow_detail_page.dart`
    moved release safety copy into new widget files while the guardrail only
    scanned the page file. Updated
    `flutter_app/test/quality/product_copy_guardrails_test.dart` to include the
    three new escrow detail widget files for that target.
  - `flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact` passed (`13` tests).
- GitNexus/fallback:
  - GitNexus MCP tools unavailable via tool discovery for this packet.
  - Reused CLI failure from the same run:
    `Cannot destructure property 'package' of 'node.target' as it is null`.
  - Continued with `rg`, analyzer, focused P2P tests, and guardrails.

### PE800-02 - Earn Near-Hard Page Wave

Status: `[x]`

Priority: P1

Goal: Extract visual sections from Earn, staking, and savings pages in the
800-900 line range while preserving safety, yield, suitability, risk, and
notification copy.

Targets:

| Current lines | File |
| ---: | --- |
| 889 | `flutter_app/lib/features/launchpad/presentation/pages/launchpad_bridge_order_page.dart` |
| 889 | `flutter_app/lib/features/earn/presentation/pages/staking_regulatory_framework_page.dart` |
| 880 | `flutter_app/lib/features/earn/presentation/pages/staking_institutional_page.dart` |
| 858 | `flutter_app/lib/features/earn/presentation/pages/staking_audit_reports_page.dart` |
| 857 | `flutter_app/lib/features/earn/presentation/pages/staking_risk_score_calculator_page.dart` |
| 853 | `flutter_app/lib/features/earn/presentation/pages/savings_notifications_page.dart` |
| 846 | `flutter_app/lib/features/earn/presentation/pages/savings_analytics_page.dart` |
| 845 | `flutter_app/lib/features/earn/presentation/pages/staking_advanced_orders_page.dart` |
| 829 | `flutter_app/lib/features/earn/presentation/pages/savings_risk_assessment_page.dart` |
| 820 | `flutter_app/lib/features/earn/presentation/pages/staking_risk_disclosure_page.dart` |

Note: `launchpad_bridge_order_page.dart` is included here because it contains
financial bridge/order copy and should follow the same safety verification
pattern.

Required verification:

```powershell
flutter analyze
flutter test test/features/earn --reporter=compact
flutter test test/features/launchpad --reporter=compact
flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact
flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact
```

Completion notes:

- Before counts:
  - `launchpad_bridge_order_page.dart`: `889`
  - `staking_regulatory_framework_page.dart`: `889`
  - `staking_institutional_page.dart`: `880`
  - `staking_audit_reports_page.dart`: `858`
  - `staking_risk_score_calculator_page.dart`: `857`
  - `savings_notifications_page.dart`: `853`
  - `savings_analytics_page.dart`: `846`
  - `staking_advanced_orders_page.dart`: `845`
  - `savings_risk_assessment_page.dart`: `829`
  - `staking_risk_disclosure_page.dart`: `820`
- After counts:
  - `launchpad_bridge_order_page.dart`: `104`
  - `staking_regulatory_framework_page.dart`: `146`
  - `staking_institutional_page.dart`: `133`
  - `staking_audit_reports_page.dart`: `143`
  - `staking_risk_score_calculator_page.dart`: `234`
  - `savings_notifications_page.dart`: `160`
  - `savings_analytics_page.dart`: `132`
  - `staking_advanced_orders_page.dart`: `134`
  - `savings_risk_assessment_page.dart`: `155`
  - `staking_risk_disclosure_page.dart`: `114`
  - Current 800-900 page scan found no Earn pages and no `launchpad_bridge_order_page.dart`.
- New files:
  - `flutter_app/lib/features/launchpad/presentation/widgets/launchpad_bridge_order_hero.dart` (`145` lines)
  - `flutter_app/lib/features/launchpad/presentation/widgets/launchpad_bridge_order_timeline.dart` (`195` lines)
  - `flutter_app/lib/features/launchpad/presentation/widgets/launchpad_bridge_order_events.dart` (`213` lines)
  - `flutter_app/lib/features/launchpad/presentation/widgets/launchpad_bridge_order_details.dart` (`244` lines)
  - `flutter_app/lib/features/earn/presentation/widgets/staking_regulatory_framework_hero_licenses.dart` (`180` lines)
  - `flutter_app/lib/features/earn/presentation/widgets/staking_regulatory_framework_protection_complaints.dart` (`266` lines)
  - `flutter_app/lib/features/earn/presentation/widgets/staking_regulatory_framework_sheet_common.dart` (`306` lines)
  - `flutter_app/lib/features/earn/presentation/widgets/staking_institutional_overview_batches.dart` (`341` lines)
  - `flutter_app/lib/features/earn/presentation/widgets/staking_institutional_signers_features.dart` (`178` lines)
  - `flutter_app/lib/features/earn/presentation/widgets/staking_institutional_sheet_painter.dart` (`237` lines)
  - `flutter_app/lib/features/earn/presentation/widgets/staking_audit_reports_hero_tabs.dart` (`165` lines)
  - `flutter_app/lib/features/earn/presentation/widgets/staking_audit_reports_reports_findings.dart` (`277` lines)
  - `flutter_app/lib/features/earn/presentation/widgets/staking_audit_reports_bounty_common.dart` (`282` lines)
  - `flutter_app/lib/features/earn/presentation/widgets/staking_risk_score_inputs.dart` (`290` lines)
  - `flutter_app/lib/features/earn/presentation/widgets/staking_risk_score_results.dart` (`175` lines)
  - `flutter_app/lib/features/earn/presentation/widgets/staking_risk_score_radar.dart` (`167` lines)
  - `flutter_app/lib/features/earn/presentation/widgets/savings_notifications_history.dart` (`255` lines)
  - `flutter_app/lib/features/earn/presentation/widgets/savings_notifications_settings.dart` (`230` lines)
  - `flutter_app/lib/features/earn/presentation/widgets/savings_notifications_common.dart` (`217` lines)
  - `flutter_app/lib/features/earn/presentation/widgets/savings_analytics_summary_range.dart` (`160` lines)
  - `flutter_app/lib/features/earn/presentation/widgets/savings_analytics_charts_metrics.dart` (`251` lines)
  - `flutter_app/lib/features/earn/presentation/widgets/savings_analytics_secondary_painters.dart` (`312` lines)
  - `flutter_app/lib/features/earn/presentation/widgets/staking_advanced_orders_overview_orders.dart` (`283` lines)
  - `flutter_app/lib/features/earn/presentation/widgets/staking_advanced_orders_guidance.dart` (`80` lines)
  - `flutter_app/lib/features/earn/presentation/widgets/staking_advanced_orders_sheet_fields.dart` (`357` lines)
  - `flutter_app/lib/features/earn/presentation/widgets/savings_risk_assessment_questions.dart` (`285` lines)
  - `flutter_app/lib/features/earn/presentation/widgets/savings_risk_assessment_result.dart` (`198` lines)
  - `flutter_app/lib/features/earn/presentation/widgets/savings_risk_assessment_products_common.dart` (`200` lines)
  - `flutter_app/lib/features/earn/presentation/widgets/staking_risk_disclosure_overview.dart` (`270` lines)
  - `flutter_app/lib/features/earn/presentation/widgets/staking_risk_disclosure_categories.dart` (`226` lines)
  - `flutter_app/lib/features/earn/presentation/widgets/staking_risk_disclosure_assessment_common.dart` (`219` lines)
- Commands/results:
  - `dart format` on `41` touched Earn/Launchpad page/widget files passed.
  - `flutter analyze` passed (`No issues found!`).
  - Direct grep `rg -n "features/.*/data|\bColors\."` over touched Dart files returned no matches.
  - `flutter test test/features/earn --reporter=compact` passed (`354` tests).
  - `flutter test test/features/launchpad --reporter=compact` passed (`121` tests).
  - `flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact` passed (`10` tests).
  - `flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact` passed (`13` tests).
- GitNexus/fallback:
  - GitNexus MCP tools unavailable via tool discovery for this packet.
  - Reused CLI failure from the same run:
    `Cannot destructure property 'package' of 'node.target' as it is null`.
  - Continued with `rg`, analyzer, Earn/Launchpad focused tests, and guardrails.

### PE800-03 - Trade Near-Hard Page Wave

Status: `[x]`

Priority: P1

Goal: Extract visual sections from trade, bot, copy, leverage, complaints, and
governance pages in the 800-900 line range.

Targets:

| Current lines | File |
| ---: | --- |
| 880 | `flutter_app/lib/features/trade/presentation/pages/bot_api_documentation_page.dart` |
| 879 | `flutter_app/lib/features/trade/presentation/pages/complaints_handling_page.dart` |
| 866 | `flutter_app/lib/features/trade/presentation/pages/trade_history_export_page.dart` |
| 846 | `flutter_app/lib/features/trade/presentation/pages/bot_suitability_assessment_page.dart` |
| 844 | `flutter_app/lib/features/trade/presentation/pages/leverage_page.dart` |
| 842 | `flutter_app/lib/features/trade/presentation/pages/copy_configuration_page.dart` |
| 834 | `flutter_app/lib/features/trade/presentation/pages/provider_leaderboard_page.dart` |
| 828 | `flutter_app/lib/features/trade/presentation/pages/product_governance_page.dart` |
| 804 | `flutter_app/lib/features/trade/presentation/pages/bot_equity_curve_page.dart` |

Required verification:

```powershell
flutter analyze
flutter test test/features/trade --reporter=compact
flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact
flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact
```

Completion notes:

- Before counts:
  - `bot_api_documentation_page.dart`: `880`
  - `complaints_handling_page.dart`: `879`
  - `trade_history_export_page.dart`: `866`
  - `bot_suitability_assessment_page.dart`: `846`
  - `leverage_page.dart`: `844`
  - `copy_configuration_page.dart`: `842`
  - `provider_leaderboard_page.dart`: `834`
  - `product_governance_page.dart`: `828`
  - `bot_equity_curve_page.dart`: `804`
- After counts:
  - `bot_api_documentation_page.dart`: `142`
  - `complaints_handling_page.dart`: `109`
  - `trade_history_export_page.dart`: `199`
  - `bot_suitability_assessment_page.dart`: `133`
  - `leverage_page.dart`: `157`
  - `copy_configuration_page.dart`: `206`
  - `provider_leaderboard_page.dart`: `177`
  - `product_governance_page.dart`: `104`
  - `bot_equity_curve_page.dart`: `111`
  - Current 800-900 page scan found no Trade pages.
- New files:
  - `flutter_app/lib/features/trade/presentation/widgets/bot_api_documentation_intro_tabs.dart` (`115` lines)
  - `flutter_app/lib/features/trade/presentation/widgets/bot_api_documentation_endpoints.dart` (`206` lines)
  - `flutter_app/lib/features/trade/presentation/widgets/bot_api_documentation_websocket_examples.dart` (`210` lines)
  - `flutter_app/lib/features/trade/presentation/widgets/bot_api_documentation_support_common.dart` (`219` lines)
  - `flutter_app/lib/features/trade/presentation/widgets/complaints_handling_overview_header_tabs.dart` (`281` lines)
  - `flutter_app/lib/features/trade/presentation/widgets/complaints_handling_overview_complaints.dart` (`252` lines)
  - `flutter_app/lib/features/trade/presentation/widgets/complaints_handling_process_common.dart` (`246` lines)
  - `flutter_app/lib/features/trade/presentation/widgets/trade_history_export_summary_sections.dart` (`152` lines)
  - `flutter_app/lib/features/trade/presentation/widgets/trade_history_export_selectors_includes.dart` (`289` lines)
  - `flutter_app/lib/features/trade/presentation/widgets/trade_history_export_footer.dart` (`235` lines)
  - `flutter_app/lib/features/trade/presentation/widgets/bot_suitability_questions_info.dart` (`279` lines)
  - `flutter_app/lib/features/trade/presentation/widgets/bot_suitability_result_score.dart` (`173` lines)
  - `flutter_app/lib/features/trade/presentation/widgets/bot_suitability_breakdown_common.dart` (`270` lines)
  - `flutter_app/lib/features/trade/presentation/widgets/leverage_header_hero_risk.dart` (`192` lines)
  - `flutter_app/lib/features/trade/presentation/widgets/leverage_controls_presets.dart` (`213` lines)
  - `flutter_app/lib/features/trade/presentation/widgets/leverage_impact_confirm.dart` (`291` lines)
  - `flutter_app/lib/features/trade/presentation/widgets/copy_configuration_provider_capital_mode.dart` (`237` lines)
  - `flutter_app/lib/features/trade/presentation/widgets/copy_configuration_risk_summary.dart` (`204` lines)
  - `flutter_app/lib/features/trade/presentation/widgets/copy_configuration_validation_common.dart` (`204` lines)
  - `flutter_app/lib/features/trade/presentation/widgets/provider_leaderboard_controls.dart` (`282` lines)
  - `flutter_app/lib/features/trade/presentation/widgets/provider_leaderboard_cards.dart` (`306` lines)
  - `flutter_app/lib/features/trade/presentation/widgets/provider_leaderboard_disclaimer.dart` (`78` lines)
  - `flutter_app/lib/features/trade/presentation/widgets/product_governance_overview_tabs.dart` (`207` lines)
  - `flutter_app/lib/features/trade/presentation/widgets/product_governance_products.dart` (`249` lines)
  - `flutter_app/lib/features/trade/presentation/widgets/product_governance_reviews_distribution.dart` (`277` lines)
  - `flutter_app/lib/features/trade/presentation/widgets/bot_equity_curve_summary_tabs.dart` (`126` lines)
  - `flutter_app/lib/features/trade/presentation/widgets/bot_equity_curve_charts_cards.dart` (`293` lines)
  - `flutter_app/lib/features/trade/presentation/widgets/bot_equity_curve_analysis_painters.dart` (`283` lines)
- Commands/results:
  - `dart format` on `37` touched Trade page/widget files passed after moving
    part directives before top-level const declarations.
  - `flutter analyze` passed (`No issues found!`).
  - Direct grep `rg -n "features/.*/data|\bColors\."` over touched Dart files returned no matches.
  - `flutter test test/features/trade --reporter=compact` passed (`343` tests).
  - `flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact` passed (`10` tests).
  - `flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact` passed (`13` tests).
- GitNexus/fallback:
  - GitNexus MCP tools unavailable via tool discovery for this packet.
  - Reused CLI failure from the same run:
    `Cannot destructure property 'package' of 'node.target' as it is null`.
  - Continued with `rg`, analyzer, Trade focused tests, and guardrails.

### PE800-04 - Mixed Near-Hard Page Wave

Status: `[x]`

Priority: P1

Goal: Reduce remaining 800-900 line pages outside the P2P, Earn, and Trade
waves.

Targets:

| Current lines | File |
| ---: | --- |
| 888 | `flutter_app/lib/features/predictions/presentation/pages/predictions_rewards_page.dart` |
| 880 | `flutter_app/lib/features/arena/presentation/pages/arena_leaderboard_page.dart` |
| 879 | `flutter_app/lib/features/wallet/presentation/pages/portfolio_analytics_page.dart` |
| 857 | `flutter_app/lib/features/arena/presentation/pages/arena_report_case_page.dart` |
| 853 | `flutter_app/lib/features/enterprise_states/presentation/pages/enterprise_states_page.dart` |
| 852 | `flutter_app/lib/features/support/presentation/pages/support_page.dart` |
| 843 | `flutter_app/lib/features/wallet/presentation/pages/network_status_page.dart` |
| 838 | `flutter_app/lib/features/launchpad/presentation/pages/launchpad_portfolio_page.dart` |
| 830 | `flutter_app/lib/features/arena/presentation/pages/arena_creator_page.dart` |
| 827 | `flutter_app/lib/features/admin/presentation/pages/funnel_dashboard.dart` |
| 825 | `flutter_app/lib/features/markets/presentation/pages/watchlist_page.dart` |
| 820 | `flutter_app/lib/features/predictions/presentation/pages/predictions_leaderboard_page.dart` |
| 812 | `flutter_app/lib/features/profile/presentation/pages/api_management_page.dart` |
| 807 | `flutter_app/lib/features/dca/presentation/pages/dca_schedule_config_page.dart` |

Required verification:

```powershell
flutter analyze
flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact
flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact
```

Run focused feature tests for each touched module:

- `flutter test test/features/predictions --reporter=compact`
- `flutter test test/features/arena --reporter=compact`
- `flutter test test/features/wallet --reporter=compact`
- `flutter test test/features/launchpad --reporter=compact`
- `flutter test test/features/markets --reporter=compact`
- `flutter test test/features/dca --reporter=compact`

Completion notes:

- Before counts:
  - `predictions_rewards_page.dart`: 888
  - `arena_leaderboard_page.dart`: 880
  - `portfolio_analytics_page.dart`: 879
  - `arena_report_case_page.dart`: 857
  - `enterprise_states_page.dart`: 853
  - `support_page.dart`: 852
  - `network_status_page.dart`: 843
  - `launchpad_portfolio_page.dart`: 838
  - `arena_creator_page.dart`: 830
  - `funnel_dashboard.dart`: 827
  - `watchlist_page.dart`: 825
  - `predictions_leaderboard_page.dart`: 820
  - `api_management_page.dart`: 812
  - `dca_schedule_config_page.dart`: 807
- After counts:
  - `predictions_rewards_page.dart`: 174
  - `arena_leaderboard_page.dart`: 141
  - `portfolio_analytics_page.dart`: 110
  - `arena_report_case_page.dart`: 210
  - `enterprise_states_page.dart`: 116
  - `support_page.dart`: 152
  - `network_status_page.dart`: 90
  - `launchpad_portfolio_page.dart`: 111
  - `arena_creator_page.dart`: 157
  - `funnel_dashboard.dart`: 110
  - `watchlist_page.dart`: 224
  - `predictions_leaderboard_page.dart`: 136
  - `api_management_page.dart`: 186
  - `dca_schedule_config_page.dart`: 219
  - New widget parts range from 74 to 362 lines; all remain below the
    600-line widget hard target.
- New files:
  - `flutter_app/lib/features/predictions/presentation/widgets/predictions_rewards_hero_filters.dart`
  - `flutter_app/lib/features/predictions/presentation/widgets/predictions_rewards_table.dart`
  - `flutter_app/lib/features/predictions/presentation/widgets/predictions_rewards_arena_common.dart`
  - `flutter_app/lib/features/arena/presentation/widgets/arena_leaderboard_controls.dart`
  - `flutter_app/lib/features/arena/presentation/widgets/arena_leaderboard_body.dart`
  - `flutter_app/lib/features/arena/presentation/widgets/arena_leaderboard_rows_footer.dart`
  - `flutter_app/lib/features/wallet/presentation/widgets/portfolio_analytics_summary_switcher.dart`
  - `flutter_app/lib/features/wallet/presentation/widgets/portfolio_analytics_overview_chart.dart`
  - `flutter_app/lib/features/wallet/presentation/widgets/portfolio_analytics_metrics_assets.dart`
  - `flutter_app/lib/features/wallet/presentation/widgets/portfolio_analytics_common.dart`
  - `flutter_app/lib/features/arena/presentation/widgets/arena_report_case_summary_timeline.dart`
  - `flutter_app/lib/features/arena/presentation/widgets/arena_report_case_system_appeal.dart`
  - `flutter_app/lib/features/arena/presentation/widgets/arena_report_case_related_common.dart`
  - `flutter_app/lib/features/enterprise_states/presentation/widgets/enterprise_states_hero_tabs.dart`
  - `flutter_app/lib/features/enterprise_states/presentation/widgets/enterprise_states_preview_kit.dart`
  - `flutter_app/lib/features/enterprise_states/presentation/widgets/enterprise_states_references.dart`
  - `flutter_app/lib/features/support/presentation/widgets/support_quick_contacts_tabs.dart`
  - `flutter_app/lib/features/support/presentation/widgets/support_tickets.dart`
  - `flutter_app/lib/features/support/presentation/widgets/support_faq_common.dart`
  - `flutter_app/lib/features/wallet/presentation/widgets/network_status_summary.dart`
  - `flutter_app/lib/features/wallet/presentation/widgets/network_status_cards_stats.dart`
  - `flutter_app/lib/features/wallet/presentation/widgets/network_status_legend_common.dart`
  - `flutter_app/lib/features/launchpad/presentation/widgets/launchpad_portfolio_hero_tabs.dart`
  - `flutter_app/lib/features/launchpad/presentation/widgets/launchpad_portfolio_subscription.dart`
  - `flutter_app/lib/features/launchpad/presentation/widgets/launchpad_portfolio_empty_disclaimer_common.dart`
  - `flutter_app/lib/features/arena/presentation/widgets/arena_creator_hero_trust.dart`
  - `flutter_app/lib/features/arena/presentation/widgets/arena_creator_tabs.dart`
  - `flutter_app/lib/features/arena/presentation/widgets/arena_creator_common.dart`
  - `flutter_app/lib/features/admin/presentation/widgets/funnel_dashboard_selector_metrics.dart`
  - `flutter_app/lib/features/admin/presentation/widgets/funnel_dashboard_waterfall_details.dart`
  - `flutter_app/lib/features/admin/presentation/widgets/funnel_dashboard_common_painter.dart`
  - `flutter_app/lib/features/markets/presentation/widgets/watchlist_toolbar.dart`
  - `flutter_app/lib/features/markets/presentation/widgets/watchlist_cards.dart`
  - `flutter_app/lib/features/markets/presentation/widgets/watchlist_common_painter.dart`
  - `flutter_app/lib/features/predictions/presentation/widgets/predictions_leaderboard_filters_tabs.dart`
  - `flutter_app/lib/features/predictions/presentation/widgets/predictions_leaderboard_podium_rankings.dart`
  - `flutter_app/lib/features/predictions/presentation/widgets/predictions_leaderboard_rows_wins.dart`
  - `flutter_app/lib/features/profile/presentation/widgets/api_management_keys.dart`
  - `flutter_app/lib/features/profile/presentation/widgets/api_management_key_controls.dart`
  - `flutter_app/lib/features/profile/presentation/widgets/api_management_docs.dart`
  - `flutter_app/lib/features/dca/presentation/widgets/dca_schedule_strategy_time.dart`
  - `flutter_app/lib/features/dca/presentation/widgets/dca_schedule_limits_enable.dart`
  - `flutter_app/lib/features/dca/presentation/widgets/dca_schedule_common.dart`
- Commands/results:
  - `dart format <57 touched Dart files>` passed.
  - `flutter analyze` passed (`No issues found!`).
  - Direct grep `rg -n "features/.*/data|\bColors\."` over touched Dart
    files returned no matches.
  - `flutter test test/features/predictions --reporter=compact` passed.
  - `flutter test test/features/arena --reporter=compact` passed.
  - `flutter test test/features/wallet --reporter=compact` passed.
  - `flutter test test/features/launchpad --reporter=compact` passed.
  - `flutter test test/features/markets --reporter=compact` passed.
  - `flutter test test/features/dca --reporter=compact` passed.
  - Additional touched-module suites passed:
    `test/features/admin`, `test/features/profile`, `test/features/support`,
    and `test/features/enterprise_states`.
  - `flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact` passed (`10` tests).
  - `flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact` passed (`13` tests).
  - `flutter test test/quality/accessibility_semantics_critical_flows_test.dart --reporter=compact` passed (`6` tests).
- GitNexus/fallback:
  - GitNexus MCP tools unavailable via tool discovery for this packet.
  - `npx -y gitnexus@latest status` failed with:
    `Cannot destructure property 'package' of 'node.target' as it is null`.
  - Continued with `rg`, symbol-boundary review, analyzer, focused feature
    tests, direct grep, and quality guardrails.

### PE600-01 - Soft Page Cleanup Wave

Status: `[x]`

Priority: P2

Goal: Process presentation pages from 600-799 lines after all P0 and P1 packets
are complete. These files are below the E900 hard gate but above the enterprise
ideal target, so split only when cohesive sections are obvious.

Recommended order:

1. P2P high-risk payment, identity, escrow, tax, and limits pages.
2. Wallet high-risk deposit, withdrawal, asset, transaction, and history pages.
3. Trade high-risk order, copy, bot, risk, compliance, and education pages.
4. Earn/staking/savings risk, governance, notifications, and history pages.
5. Predictions and Arena pages, keeping product boundaries strict.
6. Profile, referral, notifications, support, dev, and admin pages.

Use Appendix C as the source inventory for this packet. Regenerate counts before
starting because line counts may change after earlier packets.

Required verification:

```powershell
flutter analyze
flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact
```

Add feature tests and copy/semantics guardrails according to the verification
matrix.

Completion notes:

- Before/after counts:

  ```text
  632->102 lib/features/admin/presentation/pages/ab_test_dashboard.dart
  649->101 lib/features/admin/presentation/pages/analytics_dashboard.dart
  688->168 lib/features/arena/presentation/pages/arena_join_page.dart
  610->145 lib/features/arena/presentation/pages/arena_points_entry_detail_page.dart
  609->160 lib/features/arena/presentation/pages/arena_points_ledger_page.dart
  633->155 lib/features/arena/presentation/pages/arena_safety_center_page.dart
  630->156 lib/features/arena/presentation/pages/my_arena_reports_page.dart
  659->320 lib/features/auth/presentation/pages/forgot_password_page.dart
  620->349 lib/features/auth/presentation/pages/register_page.dart
  642->108 lib/features/dev/presentation/pages/missing_screens_showcase_page.dart
  637->91 lib/features/dev/presentation/pages/performance_monitor.dart
  689->117 lib/features/dev/presentation/pages/route_checker_page.dart
  681->134 lib/features/earn/presentation/pages/savings_faq_page.dart
  683->119 lib/features/earn/presentation/pages/savings_history_page.dart
  624->93 lib/features/earn/presentation/pages/staking_community_governance_page.dart
  793->226 lib/features/earn/presentation/pages/staking_guide_page.dart
  775->90 lib/features/earn/presentation/pages/staking_multi_chain_page.dart
  707->169 lib/features/earn/presentation/pages/staking_notifications_page.dart
  733->154 lib/features/earn/presentation/pages/staking_risk_assessment_page.dart
  709->110 lib/features/earn/presentation/pages/staking_risk_dashboard_page.dart
  628->98 lib/features/earn/presentation/pages/staking_social_feed_page.dart
  727->219 lib/features/earn/presentation/pages/staking_suitability_assessment_page.dart
  766->108 lib/features/earn/presentation/pages/staking_validator_health_monitor_page.dart
  799->141 lib/features/markets/presentation/pages/market_news_page.dart
  788->186 lib/features/markets/presentation/pages/price_alerts_page.dart
  668->149 lib/features/news/presentation/pages/news_page.dart
  602->171 lib/features/notifications/presentation/pages/notifications_page.dart
  668->165 lib/features/p2p/presentation/pages/p2p_2fa_settings_page.dart
  602->93 lib/features/p2p/presentation/pages/p2p_achievements_page.dart
  713->161 lib/features/p2p/presentation/pages/p2p_address_proof_page.dart
  751->287 lib/features/p2p/presentation/pages/p2p_anti_phishing_code_page.dart
  724->474 lib/features/p2p/presentation/pages/p2p_create_ad_page.dart
  641->131 lib/features/p2p/presentation/pages/p2p_escrow_balance_page.dart
  615->155 lib/features/p2p/presentation/pages/p2p_identity_verification_page.dart
  627->103 lib/features/p2p/presentation/pages/p2p_insurance_certificate_page.dart
  736->88 lib/features/p2p/presentation/pages/p2p_insurance_score_page.dart
  694->102 lib/features/p2p/presentation/pages/p2p_kyc_requirements_page.dart
  602->104 lib/features/p2p/presentation/pages/p2p_kyc_status_page.dart
  643->189 lib/features/p2p/presentation/pages/p2p_my_orders_page.dart
  705->297 lib/features/p2p/presentation/pages/p2p_payment_method_add_page.dart
  708->207 lib/features/p2p/presentation/pages/p2p_payment_methods_page.dart
  787->155 lib/features/p2p/presentation/pages/p2p_selfie_verification_page.dart
  747->146 lib/features/p2p/presentation/pages/p2p_tax_reporting_page.dart
  734->97 lib/features/p2p/presentation/pages/p2p_transaction_limits_page.dart
  707->81 lib/features/predictions/presentation/pages/prediction_order_receipt_page.dart
  723->141 lib/features/predictions/presentation/pages/predictions_breaking_page.dart
  782->174 lib/features/predictions/presentation/pages/predictions_search_page.dart
  682->141 lib/features/profile/presentation/pages/activity_log_page.dart
  747->196 lib/features/profile/presentation/pages/device_management_page.dart
  639->141 lib/features/profile/presentation/pages/security_page.dart
  604->162 lib/features/profile/presentation/pages/settings_page.dart
  707->160 lib/features/referral/presentation/pages/referral_history_page.dart
  676->136 lib/features/referral/presentation/pages/referral_rules_page.dart
  722->118 lib/features/trade/presentation/pages/advanced_trading_demo_page.dart
  650->130 lib/features/trade/presentation/pages/audit_trail_page.dart
  726->92 lib/features/trade/presentation/pages/bot_drawdown_analyzer_page.dart
  706->168 lib/features/trade/presentation/pages/bot_emergency_stop_page.dart
  733->142 lib/features/trade/presentation/pages/bot_history_page.dart
  610->156 lib/features/trade/presentation/pages/bot_optimization_page.dart
  727->91 lib/features/trade/presentation/pages/bot_portfolio_dashboard_page.dart
  733->124 lib/features/trade/presentation/pages/bot_risk_disclosure_page.dart
  621->146 lib/features/trade/presentation/pages/bot_terms_of_service_page.dart
  769->99 lib/features/trade/presentation/pages/client_money_protection_page.dart
  635->166 lib/features/trade/presentation/pages/complaint_submission_page.dart
  751->187 lib/features/trade/presentation/pages/copy_confirmation_page.dart
  684->104 lib/features/trade/presentation/pages/copy_education_page.dart
  640->209 lib/features/trade/presentation/pages/copy_notifications_page.dart
  676->89 lib/features/trade/presentation/pages/copy_trading_card_demo.dart
  788->103 lib/features/trade/presentation/pages/investor_compensation_page.dart
  612->90 lib/features/trade/presentation/pages/order_receipt_page.dart
  655->133 lib/features/trade/presentation/pages/orders_history_page.dart
  634->108 lib/features/trade/presentation/pages/portfolio_risk_analysis_page.dart
  713->113 lib/features/trade/presentation/pages/position_dashboard_page.dart
  765->126 lib/features/trade/presentation/pages/provider_governance_page.dart
  707->104 lib/features/trade/presentation/pages/regulatory_inspection_ready_page.dart
  656->162 lib/features/trade/presentation/pages/riy_calculator_page.dart
  783->119 lib/features/trade/presentation/pages/safety_education_page.dart
  715->141 lib/features/trade/presentation/pages/trade_settings_page.dart
  675->104 lib/features/wallet/presentation/pages/asset_detail_page.dart
  716->177 lib/features/wallet/presentation/pages/deposit_page.dart
  784->138 lib/features/wallet/presentation/pages/pending_deposits_page.dart
  749->97 lib/features/wallet/presentation/pages/transaction_detail_page.dart
  714->147 lib/features/wallet/presentation/pages/transaction_history_page.dart
  653->97 lib/features/wallet/presentation/pages/withdraw_limits_page.dart
  ```

- New files:
  - Added 167 `presentation/widgets/` part files, all below 600 lines.
  - Feature distribution: admin 4, arena 10, auth 2, dev 6, earn 22,
    markets 5, news 2, notifications 2, p2p 33, predictions 6, profile 8,
    referral 4, trade 51, wallet 12.
- Commands/results:
  - PE600 split processed 84 pages; skipped 0.
  - `dart format` initially hit Windows command-length limits, then passed in
    40-file batches across dirty Dart files under `flutter_app/lib`.
  - `flutter analyze` passed (`No issues found!`).
  - Regenerated page inventory found no `presentation/pages/*.dart` files
    at or above 600 lines.
  - Regenerated widget inventory found no `presentation/widgets/*.dart` files
    at or above 600 lines.
  - Regenerated hard inventory found no Dart files above 900 lines.
  - Direct grep `rg -n "features/.*/data|\bColors\."` over dirty Dart files
    under `flutter_app/lib` returned no matches.
  - Focused feature suites passed:
    `test/features/admin`, `test/features/arena`, `test/features/auth`,
    `test/features/dev`, `test/features/earn`, `test/features/markets`,
    `test/features/news`, `test/features/notifications`, `test/features/p2p`,
    `test/features/predictions`, `test/features/profile`,
    `test/features/referral`, `test/features/trade`, and
    `test/features/wallet`.
  - `flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact` passed (`10` tests).
  - `flutter test test/quality/accessibility_semantics_critical_flows_test.dart --reporter=compact` passed (`6` tests).
  - `flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact`
    initially failed because source-scan guardrails still targeted old page
    paths after copy moved into part files. Updated the guardrail target paths
    for `copy_confirmation_page` and `p2p_escrow_balance_page`, then reran and
    passed (`13` tests).
- GitNexus/fallback:
  - GitNexus MCP tools unavailable via tool discovery for this packet.
  - `npx -y gitnexus@latest status` failed with:
    `Cannot destructure property 'package' of 'node.target' as it is null`.
  - Continued with `rg`, symbol-boundary review, analyzer, focused feature
    tests, direct grep, and quality guardrails.

### PE500-01 - Widget, Repository, Controller, and Domain Soft Cleanup

Status: `[x]`

Priority: P2

Goal: Review files at or above 500 lines outside presentation pages. Split only
when the file contains clear cohesive groups and public APIs can stay stable.

Targets:

| Current lines | File | Area |
| ---: | --- | --- |
| 607 | `flutter_app/lib/features/p2p/presentation/widgets/p2p_create_ad_sections.dart` | Widget, also covered by PE900F-02 if still open. |
| 574 | `flutter_app/lib/features/earn/presentation/widgets/staking_custody_common.dart` | Widget |
| 573 | `flutter_app/lib/features/wallet/presentation/widgets/wallet_token_active_approvals_tab.dart` | Widget |
| 560 | `flutter_app/lib/features/profile/presentation/widgets/profile_sub_account_cards.dart` | Widget |
| 544 | `flutter_app/lib/features/wallet/presentation/widgets/withdraw_form_sections.dart` | Widget |
| 538 | `flutter_app/lib/features/launchpad/presentation/widgets/launchpad_home_tool_widgets.dart` | Widget |
| 671 | `flutter_app/lib/features/dev/data/repositories/mock_dev_tools_repository.dart` | Repository |
| 504 | `flutter_app/lib/features/wallet/data/repositories/fail_closed_wallet_repository.dart` | Repository |
| 501 | `flutter_app/lib/features/discovery/data/repositories/mock_discovery_repository.dart` | Repository |
| 640 | `flutter_app/lib/features/profile/domain/entities/profile_entities.dart` | Domain entities |
| 586 | `flutter_app/lib/features/p2p/presentation/controllers/p2p_controller.dart` | Controller |

Domain entity part files around 500-560 lines should be reviewed after widgets,
repositories, and controllers. Do not split generated-style entity bundles unless
there is a stable naming pattern and no public import churn.

Required verification:

```powershell
flutter analyze
flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact
```

Add focused tests for each touched module.

Completion notes:

- Before/after counts:
  - `p2p_create_ad_sections.dart`: 584 -> 337
  - `staking_custody_common.dart`: 574 -> 337
  - `wallet_token_active_approvals_tab.dart`: 573 -> 250
  - `withdraw_form_sections.dart`: 544 -> 258
  - `mock_dev_tools_repository.dart`: 671 -> 6
  - `mock_discovery_repository.dart`: 501 -> 130
  - `profile_entities.dart`: 640 -> 225
  - `p2p_controller.dart`: 586 -> 156
- New files:
  - `flutter_app/lib/features/p2p/presentation/widgets/p2p_create_ad_preview_confirm.dart` (`150` lines)
  - `flutter_app/lib/features/p2p/presentation/widgets/p2p_create_ad_choice_chips.dart` (`102` lines)
  - `flutter_app/lib/features/earn/presentation/widgets/staking_custody_actions_common.dart` (`124` lines)
  - `flutter_app/lib/features/earn/presentation/widgets/staking_custody_pie_chart.dart` (`118` lines)
  - `flutter_app/lib/features/wallet/presentation/widgets/wallet_token_approval_cards.dart` (`210` lines)
  - `flutter_app/lib/features/wallet/presentation/widgets/wallet_token_approval_badges.dart` (`118` lines)
  - `flutter_app/lib/features/wallet/presentation/widgets/withdraw_amount_actions.dart` (`289` lines)
  - `flutter_app/lib/features/dev/data/repositories/mock_dev_tools_route_checker_repository.dart` (`192` lines)
  - `flutter_app/lib/features/dev/data/repositories/mock_dev_tools_missing_screens_repository.dart` (`171` lines)
  - `flutter_app/lib/features/dev/data/repositories/mock_dev_tools_design_performance_repository.dart` (`309` lines)
  - `flutter_app/lib/features/discovery/data/repositories/mock_discovery_repository_fixtures.dart` (`374` lines)
  - `flutter_app/lib/features/profile/domain/entities/profile_api_vip_entities.dart` (`235` lines)
  - `flutter_app/lib/features/profile/domain/entities/profile_home_menu_entities.dart` (`185` lines)
  - `flutter_app/lib/features/p2p/presentation/controllers/p2p_payment_method_controllers.dart` (`191` lines)
  - `flutter_app/lib/features/p2p/presentation/controllers/p2p_order_dispute_controllers.dart` (`244` lines)
- Reviewed soft exceptions:
  - `profile_sub_account_cards.dart` remains `560` lines because it is already
    a `part of` page file; splitting further would require changing private
    page boundaries or creating nested parts, which Dart does not support
    cleanly.
  - `launchpad_home_tool_widgets.dart` remains `538` lines for the same
    `part of` page-file reason.
  - `fail_closed_wallet_repository.dart` remains `504` lines as one cohesive
    fail-closed implementation below repository hard targets.
  - Existing router files and generated-style fixture/entity part files in the
    500-567 range were reviewed and left intact because they are already
    cohesive route declarations or generated-style split bundles with no clear
    lower-risk second split.
- Commands/results:
  - `dart format <23 PE500 files>` passed after moving
    `p2p_controller.dart` export directives before part directives.
  - `flutter analyze` passed (`No issues found!`).
  - Direct grep `rg -n "features/.*/data|\bColors\."` over touched
    presentation/controller files returned no matches.
  - Focused feature suites passed: `test/features/p2p`, `test/features/earn`,
    `test/features/wallet`, `test/features/dev`, `test/features/discovery`,
    and `test/features/profile`.
  - `flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact` passed (`10` tests).
  - `flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact` passed (`13` tests).
  - `flutter test test/quality/accessibility_semantics_critical_flows_test.dart --reporter=compact` passed (`6` tests).
- GitNexus/fallback:
  - GitNexus MCP tools unavailable via tool discovery for this packet.
  - `npx -y gitnexus@latest status` failed with:
    `Cannot destructure property 'package' of 'node.target' as it is null`.
  - Continued with `rg`, symbol-boundary review, analyzer, focused feature
    tests, direct grep, and quality guardrails.

## Scan Commands

Run from `flutter_app/`.

Pages above 900:

```powershell
$root=(Resolve-Path .).Path
Get-ChildItem lib -Recurse -Filter *.dart |
  Where-Object { $_.FullName -match '\\presentation\\pages\\' } |
  ForEach-Object {
    $rel=$_.FullName.Substring($root.Length+1)
    $lines=(Get-Content $_.FullName).Count
    if ($lines -gt 900) { "$lines $rel" }
  } | Sort-Object {[int](($_ -split ' ')[0])} -Descending
```

Pages from 800 to 900:

```powershell
$root=(Resolve-Path .).Path
Get-ChildItem lib -Recurse -Filter *.dart |
  Where-Object { $_.FullName -match '\\presentation\\pages\\' } |
  ForEach-Object {
    $rel=$_.FullName.Substring($root.Length+1)
    $lines=(Get-Content $_.FullName).Count
    if ($lines -ge 800 -and $lines -le 900) { "$lines $rel" }
  } | Sort-Object {[int](($_ -split ' ')[0])} -Descending
```

Pages from 600 to 799:

```powershell
$root=(Resolve-Path .).Path
Get-ChildItem lib -Recurse -Filter *.dart |
  Where-Object { $_.FullName -match '\\presentation\\pages\\' } |
  ForEach-Object {
    $rel=$_.FullName.Substring($root.Length+1)
    $lines=(Get-Content $_.FullName).Count
    if ($lines -ge 600 -and $lines -lt 800) { "$lines $rel" }
  } | Sort-Object {[int](($_ -split ' ')[0])} -Descending
```

Widgets at or above 500:

```powershell
$root=(Resolve-Path .).Path
Get-ChildItem lib -Recurse -Filter *.dart |
  Where-Object { $_.FullName -match '\\presentation\\widgets\\' } |
  ForEach-Object {
    $rel=$_.FullName.Substring($root.Length+1)
    $lines=(Get-Content $_.FullName).Count
    if ($lines -ge 500) { "$lines $rel" }
  } | Sort-Object {[int](($_ -split ' ')[0])} -Descending
```

Repositories at or above 500:

```powershell
$root=(Resolve-Path .).Path
Get-ChildItem lib -Recurse -Filter *.dart |
  Where-Object { $_.FullName -match '\\data\\repositories\\' } |
  ForEach-Object {
    $rel=$_.FullName.Substring($root.Length+1)
    $lines=(Get-Content $_.FullName).Count
    if ($lines -ge 500) { "$lines $rel" }
  } | Sort-Object {[int](($_ -split ' ')[0])} -Descending
```

Controllers and domain entity files at or above 500:

```powershell
$root=(Resolve-Path .).Path
Get-ChildItem lib -Recurse -Filter *.dart |
  Where-Object { $_.FullName -match '\\presentation\\controllers\\|\\domain\\entities\\' } |
  ForEach-Object {
    $rel=$_.FullName.Substring($root.Length+1)
    $lines=(Get-Content $_.FullName).Count
    if ($lines -ge 500) { "$lines $rel" }
  } | Sort-Object {[int](($_ -split ' ')[0])} -Descending
```

Architecture grep for touched files:

```powershell
rg -n "features/.*/data|\bColors\." <touched-dart-files>
```

## Appendix A - Current Hard Page Inventory Above 900

Snapshot from 2026-06-01:

```text
959 lib\features\p2p\presentation\pages\p2p_guide_page.dart
950 lib\features\p2p\presentation\pages\p2p_ad_detail_page.dart
909 lib\features\p2p\presentation\pages\p2p_order_book_page.dart
909 lib\features\p2p\presentation\pages\p2p_settings_page.dart
901 lib\features\p2p\presentation\pages\p2p_merchant_profile_page.dart
```

## Appendix B - Current Near-Hard Page Inventory 800-900

Snapshot from 2026-06-01:

```text
889 lib\features\launchpad\presentation\pages\launchpad_bridge_order_page.dart
889 lib\features\earn\presentation\pages\staking_regulatory_framework_page.dart
888 lib\features\predictions\presentation\pages\predictions_rewards_page.dart
881 lib\features\p2p\presentation\pages\p2p_device_management_page.dart
880 lib\features\arena\presentation\pages\arena_leaderboard_page.dart
880 lib\features\earn\presentation\pages\staking_institutional_page.dart
880 lib\features\trade\presentation\pages\bot_api_documentation_page.dart
879 lib\features\wallet\presentation\pages\portfolio_analytics_page.dart
879 lib\features\trade\presentation\pages\complaints_handling_page.dart
866 lib\features\trade\presentation\pages\trade_history_export_page.dart
864 lib\features\p2p\presentation\pages\p2p_security_center_page.dart
858 lib\features\earn\presentation\pages\staking_audit_reports_page.dart
857 lib\features\earn\presentation\pages\staking_risk_score_calculator_page.dart
857 lib\features\arena\presentation\pages\arena_report_case_page.dart
853 lib\features\earn\presentation\pages\savings_notifications_page.dart
853 lib\features\enterprise_states\presentation\pages\enterprise_states_page.dart
852 lib\features\support\presentation\pages\support_page.dart
846 lib\features\earn\presentation\pages\savings_analytics_page.dart
846 lib\features\trade\presentation\pages\bot_suitability_assessment_page.dart
845 lib\features\earn\presentation\pages\staking_advanced_orders_page.dart
844 lib\features\trade\presentation\pages\leverage_page.dart
843 lib\features\wallet\presentation\pages\network_status_page.dart
842 lib\features\trade\presentation\pages\copy_configuration_page.dart
838 lib\features\launchpad\presentation\pages\launchpad_portfolio_page.dart
836 lib\features\p2p\presentation\pages\p2p_chat_page.dart
834 lib\features\trade\presentation\pages\provider_leaderboard_page.dart
830 lib\features\arena\presentation\pages\arena_creator_page.dart
829 lib\features\earn\presentation\pages\savings_risk_assessment_page.dart
829 lib\features\p2p\presentation\pages\p2p_escrow_detail_page.dart
828 lib\features\trade\presentation\pages\product_governance_page.dart
827 lib\features\admin\presentation\pages\funnel_dashboard.dart
825 lib\features\markets\presentation\pages\watchlist_page.dart
820 lib\features\predictions\presentation\pages\predictions_leaderboard_page.dart
820 lib\features\earn\presentation\pages\staking_risk_disclosure_page.dart
812 lib\features\profile\presentation\pages\api_management_page.dart
807 lib\features\dca\presentation\pages\dca_schedule_config_page.dart
805 lib\features\p2p\presentation\pages\p2p_my_ads_page.dart
804 lib\features\trade\presentation\pages\bot_equity_curve_page.dart
803 lib\features\p2p\presentation\pages\p2p_trading_level_page.dart
```

## Appendix C - Current Soft Page Inventory 600-799

Snapshot from 2026-06-01:

```text
799 lib\features\markets\presentation\pages\market_news_page.dart
793 lib\features\earn\presentation\pages\staking_guide_page.dart
788 lib\features\trade\presentation\pages\investor_compensation_page.dart
788 lib\features\markets\presentation\pages\price_alerts_page.dart
787 lib\features\p2p\presentation\pages\p2p_selfie_verification_page.dart
784 lib\features\wallet\presentation\pages\pending_deposits_page.dart
783 lib\features\trade\presentation\pages\safety_education_page.dart
782 lib\features\predictions\presentation\pages\predictions_search_page.dart
775 lib\features\earn\presentation\pages\staking_multi_chain_page.dart
769 lib\features\trade\presentation\pages\client_money_protection_page.dart
766 lib\features\earn\presentation\pages\staking_validator_health_monitor_page.dart
765 lib\features\trade\presentation\pages\provider_governance_page.dart
751 lib\features\trade\presentation\pages\copy_confirmation_page.dart
751 lib\features\p2p\presentation\pages\p2p_anti_phishing_code_page.dart
749 lib\features\wallet\presentation\pages\transaction_detail_page.dart
747 lib\features\p2p\presentation\pages\p2p_tax_reporting_page.dart
747 lib\features\profile\presentation\pages\device_management_page.dart
736 lib\features\p2p\presentation\pages\p2p_insurance_score_page.dart
734 lib\features\p2p\presentation\pages\p2p_transaction_limits_page.dart
733 lib\features\earn\presentation\pages\staking_risk_assessment_page.dart
733 lib\features\trade\presentation\pages\bot_risk_disclosure_page.dart
733 lib\features\trade\presentation\pages\bot_history_page.dart
727 lib\features\trade\presentation\pages\bot_portfolio_dashboard_page.dart
727 lib\features\earn\presentation\pages\staking_suitability_assessment_page.dart
726 lib\features\trade\presentation\pages\bot_drawdown_analyzer_page.dart
724 lib\features\p2p\presentation\pages\p2p_create_ad_page.dart
723 lib\features\predictions\presentation\pages\predictions_breaking_page.dart
722 lib\features\trade\presentation\pages\advanced_trading_demo_page.dart
716 lib\features\wallet\presentation\pages\deposit_page.dart
715 lib\features\trade\presentation\pages\trade_settings_page.dart
714 lib\features\wallet\presentation\pages\transaction_history_page.dart
713 lib\features\trade\presentation\pages\position_dashboard_page.dart
713 lib\features\p2p\presentation\pages\p2p_address_proof_page.dart
709 lib\features\earn\presentation\pages\staking_risk_dashboard_page.dart
708 lib\features\p2p\presentation\pages\p2p_payment_methods_page.dart
707 lib\features\referral\presentation\pages\referral_history_page.dart
707 lib\features\earn\presentation\pages\staking_notifications_page.dart
707 lib\features\trade\presentation\pages\regulatory_inspection_ready_page.dart
707 lib\features\predictions\presentation\pages\prediction_order_receipt_page.dart
706 lib\features\trade\presentation\pages\bot_emergency_stop_page.dart
705 lib\features\p2p\presentation\pages\p2p_payment_method_add_page.dart
694 lib\features\p2p\presentation\pages\p2p_kyc_requirements_page.dart
689 lib\features\dev\presentation\pages\route_checker_page.dart
688 lib\features\arena\presentation\pages\arena_join_page.dart
684 lib\features\trade\presentation\pages\copy_education_page.dart
683 lib\features\earn\presentation\pages\savings_history_page.dart
682 lib\features\profile\presentation\pages\activity_log_page.dart
681 lib\features\earn\presentation\pages\savings_faq_page.dart
676 lib\features\trade\presentation\pages\copy_trading_card_demo.dart
676 lib\features\referral\presentation\pages\referral_rules_page.dart
675 lib\features\wallet\presentation\pages\asset_detail_page.dart
668 lib\features\p2p\presentation\pages\p2p_2fa_settings_page.dart
668 lib\features\news\presentation\pages\news_page.dart
659 lib\features\auth\presentation\pages\forgot_password_page.dart
656 lib\features\trade\presentation\pages\riy_calculator_page.dart
655 lib\features\trade\presentation\pages\orders_history_page.dart
653 lib\features\wallet\presentation\pages\withdraw_limits_page.dart
650 lib\features\trade\presentation\pages\audit_trail_page.dart
649 lib\features\admin\presentation\pages\analytics_dashboard.dart
643 lib\features\p2p\presentation\pages\p2p_my_orders_page.dart
642 lib\features\dev\presentation\pages\missing_screens_showcase_page.dart
641 lib\features\p2p\presentation\pages\p2p_escrow_balance_page.dart
640 lib\features\trade\presentation\pages\copy_notifications_page.dart
639 lib\features\profile\presentation\pages\security_page.dart
637 lib\features\dev\presentation\pages\performance_monitor.dart
635 lib\features\trade\presentation\pages\complaint_submission_page.dart
634 lib\features\trade\presentation\pages\portfolio_risk_analysis_page.dart
633 lib\features\arena\presentation\pages\arena_safety_center_page.dart
632 lib\features\admin\presentation\pages\ab_test_dashboard.dart
630 lib\features\arena\presentation\pages\my_arena_reports_page.dart
628 lib\features\earn\presentation\pages\staking_social_feed_page.dart
627 lib\features\p2p\presentation\pages\p2p_insurance_certificate_page.dart
624 lib\features\earn\presentation\pages\staking_community_governance_page.dart
621 lib\features\trade\presentation\pages\bot_terms_of_service_page.dart
620 lib\features\auth\presentation\pages\register_page.dart
615 lib\features\p2p\presentation\pages\p2p_identity_verification_page.dart
612 lib\features\trade\presentation\pages\order_receipt_page.dart
610 lib\features\arena\presentation\pages\arena_points_entry_detail_page.dart
610 lib\features\trade\presentation\pages\bot_optimization_page.dart
609 lib\features\arena\presentation\pages\arena_points_ledger_page.dart
604 lib\features\profile\presentation\pages\settings_page.dart
602 lib\features\p2p\presentation\pages\p2p_achievements_page.dart
602 lib\features\notifications\presentation\pages\notifications_page.dart
602 lib\features\p2p\presentation\pages\p2p_kyc_status_page.dart
```

## Appendix D - Current Non-Page Inventory At Or Above 500

Snapshot from 2026-06-01:

```text
607 lib\features\p2p\presentation\widgets\p2p_create_ad_sections.dart
574 lib\features\earn\presentation\widgets\staking_custody_common.dart
573 lib\features\wallet\presentation\widgets\wallet_token_active_approvals_tab.dart
560 lib\features\profile\presentation\widgets\profile_sub_account_cards.dart
544 lib\features\wallet\presentation\widgets\withdraw_form_sections.dart
538 lib\features\launchpad\presentation\widgets\launchpad_home_tool_widgets.dart
671 lib\features\dev\data\repositories\mock_dev_tools_repository.dart
504 lib\features\wallet\data\repositories\fail_closed_wallet_repository.dart
501 lib\features\discovery\data\repositories\mock_discovery_repository.dart
640 lib\features\profile\domain\entities\profile_entities.dart
586 lib\features\p2p\presentation\controllers\p2p_controller.dart
560 lib\features\earn\domain\entities\earn_entities_part_03.dart
560 lib\features\arena\domain\entities\arena_entities_part_01.dart
560 lib\features\earn\domain\entities\earn_entities_part_05.dart
558 lib\features\trade\domain\entities\trade_entities_part_01.dart
558 lib\features\trade\domain\entities\trade_entities_part_07.dart
558 lib\features\arena\domain\entities\arena_entities_part_03.dart
557 lib\features\trade\domain\entities\trade_entities_part_04.dart
556 lib\features\trade\domain\entities\trade_entities_part_13.dart
556 lib\features\trade\domain\entities\trade_entities_part_08.dart
556 lib\features\earn\domain\entities\earn_entities_part_07.dart
555 lib\features\trade\domain\entities\trade_entities_part_11.dart
554 lib\features\earn\domain\entities\earn_entities_part_11.dart
554 lib\features\trade\domain\entities\trade_entities_part_05.dart
553 lib\features\p2p\domain\entities\p2p_entities_part_02.dart
553 lib\features\earn\domain\entities\earn_entities_part_10.dart
552 lib\features\launchpad\domain\entities\launchpad_entities_part_04.dart
552 lib\features\referral\domain\entities\referral_entities.dart
552 lib\features\launchpad\domain\entities\launchpad_entities_part_03.dart
550 lib\features\trade\domain\entities\trade_entities_part_09.dart
550 lib\features\trade\domain\entities\trade_entities_part_12.dart
549 lib\features\earn\domain\entities\earn_entities_part_08.dart
548 lib\features\p2p\domain\entities\p2p_entities_part_01.dart
547 lib\features\earn\domain\entities\earn_entities_part_06.dart
547 lib\features\trade\domain\entities\trade_entities_part_06.dart
546 lib\features\earn\domain\entities\earn_entities_part_04.dart
546 lib\features\arena\domain\entities\arena_entities_part_02.dart
546 lib\features\trade\domain\entities\trade_entities_part_02.dart
546 lib\features\earn\domain\entities\earn_entities_part_01.dart
546 lib\features\p2p\domain\entities\p2p_entities_part_08.dart
542 lib\features\p2p\domain\entities\p2p_entities_part_05.dart
540 lib\features\earn\domain\entities\earn_entities_part_02.dart
540 lib\features\p2p\domain\entities\p2p_entities_part_03.dart
540 lib\features\launchpad\domain\entities\launchpad_entities_part_02.dart
540 lib\features\arena\domain\entities\arena_entities_part_04.dart
539 lib\features\trade\domain\entities\trade_entities_part_03.dart
537 lib\features\trade\domain\entities\trade_entities_part_10.dart
536 lib\features\p2p\domain\entities\p2p_entities_part_06.dart
527 lib\features\earn\domain\entities\earn_entities_part_09.dart
525 lib\features\earn\domain\entities\earn_entities_part_12.dart
517 lib\features\markets\domain\entities\market_entities_part_02.dart
516 lib\features\p2p\domain\entities\p2p_entities_part_04.dart
514 lib\features\launchpad\domain\entities\launchpad_entities_part_01.dart
514 lib\features\predictions\domain\entities\predictions_entities_part_03.dart
512 lib\features\p2p\domain\entities\p2p_entities_part_07.dart
511 lib\features\p2p\domain\entities\p2p_entities_part_09.dart
507 lib\features\markets\domain\entities\market_entities_part_03.dart
506 lib\features\p2p\domain\entities\p2p_entities_part_10.dart
504 lib\features\predictions\domain\entities\predictions_entities_part_01.dart
502 lib\features\markets\domain\entities\market_entities_part_01.dart
```

## Final Done Criteria

The post-E900 cleanup is complete when:

1. No packet in this guide remains `[ ]` or `[~]`.
2. No presentation page is above 900 lines.
3. No presentation widget is above 600 lines unless marked `[!]`.
4. High-risk pages above the ideal target have documented exceptions or are
   split into cohesive sections.
5. Repository, controller, and domain files above soft limits have documented
   review outcomes.
6. All touched files are formatted.
7. `flutter analyze` passes.
8. `architecture_baseline_guardrails_test.dart` passes.
9. Feature, product copy, and semantics tests required by touched areas pass.
10. Direct grep finds no new `features/*/data` imports in presentation and no
    new runtime `Colors.*`.
11. GitNexus findings are handled or the fallback reason is recorded.
