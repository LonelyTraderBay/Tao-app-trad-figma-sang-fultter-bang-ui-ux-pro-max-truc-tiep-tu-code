# Flutter Enterprise Grade Codebase Upgrade Tracker

Generated: 2026-06-01

Use this tracker after the E900 and Post-E900 refactor waves. Its goal is not
another redesign pass. Its goal is to keep raising the whole Flutter codebase to
enterprise maintainability standards without missing large, risky, or
architecture-sensitive files.

## Scope

Source of truth:

- Flutter package: `flutter_app/`
- App source: `flutter_app/lib/`
- Tests: `flutter_app/test/`
- Public router facade: `flutter_app/lib/app/router/app_router.dart`
- Active refactor guide:
  `docs/02_FLUTTER_MIGRATION/Flutter-Enterprise-Post-E900-Refactor-Execution-Guide.md`
- E900 tracker:
  `docs/02_FLUTTER_MIGRATION/Flutter-Enterprise-900-Line-Refactor-Tracking.md`

Preserve product behavior, route behavior, existing UI intent, provider
contracts, tests, financial safety copy, and module boundaries.

## Required Reading Order

Read these before any source edit:

1. `AGENTS.md`
2. `docs/00_START_HERE.md`
3. `docs/01_AI_RULES/AI_EXECUTION_CONTRACT.md`
4. `docs/01_AI_RULES/DOCUMENT_PRECEDENCE.md`
5. `docs/02_FLUTTER_MIGRATION/Flutter-Enterprise-Post-E900-Refactor-Execution-Guide.md`
6. `docs/03_DESIGN_SYSTEM/Guidelines.md` when UI, layout, or copy is touched.

## Current Snapshot

Snapshot command results from 2026-06-01:

| Check | Result |
| --- | ---: |
| Dart files above 900 lines | 0 |
| Presentation pages at or above 500 lines | 95 |
| Presentation pages at or above 600 lines | 0 |
| Presentation widgets at or above 600 lines | 0 |
| Presentation widgets at or above 400 lines | 37 |
| Painter/chart files at or above 400 lines | 8 |
| Domain entity files at or above 500 lines | 49 |
| Router files at or above 500 lines | 3 |
| Data repositories at or above 500 lines | 1 |
| Data repositories at or above 400 lines | 4 |
| Controller files at or above 350 lines | 1 |
| Test files at or above 900 lines | 0 |
| Test files at or above 700 lines | 1 |
| Presentation/shared imports from `features/*/data` | 0 |
| Runtime `Colors.*` matches in `lib/` | 0 |

This snapshot is guidance only. Regenerate the inventory before each packet
because the working tree may have changed.

## Enterprise Targets

| File type | Ideal target | Soft review | Hard target | Notes |
| --- | ---: | ---: | ---: | --- |
| Presentation pages | 300-500 | 500+ | 600 | Page owns state, provider reads, navigation, and top-level composition only. |
| Presentation widgets | 100-350 | 400+ | 600 | Extract cohesive sections, cards, lists, rows, sheets, tabs, and painters. |
| Controllers | 100-300 | 350+ | 500 | Keep provider/controller public contracts stable. |
| Data repositories | 200-500 | 500+ | 900 | Keep public repository APIs stable; split fixtures before logic when possible. |
| Domain entities | 100-500 | 500+ | 800 | Split only by bounded context or cohesive value-object families. |
| Router files | 100-450 | 500+ | 700 | Preserve public router facade and route names. |
| Tests | 100-600 | 700+ | 900 | Split by behavior group while preserving coverage and names. |
| Painter/chart files | 100-350 | 400+ | 600 | Preserve rendering behavior and semantics. |

## Status Legend

- `[ ]` Not started.
- `[~]` In progress. Resume this before any new packet.
- `[x]` Complete and verified.
- `[!]` Blocked or intentionally excepted with reason and resume point.

## Non-Negotiable Rules

1. Resume the first `[~]` packet before starting any `[ ]` packet.
2. Mark a packet `[~]` before edits.
3. Complete one packet before starting the next.
4. Do not redesign screens or rewrite flows.
5. Do not change public route names, route paths, providers, repository
   contracts, or test keys unless the packet explicitly requires it.
6. Do not merge Prediction Markets and Open Arena concepts.
7. Do not introduce presentation imports from `features/*/data`.
8. Do not introduce runtime `Colors.*`; use theme tokens.
9. Prefer `package:vit_trade_flutter/...` imports across modules.
10. Format every touched Dart file.
11. Run focused tests plus required guardrails before marking `[x]`.
12. Record before/after line counts, new files, commands, results, and
    exceptions in this tracker.

## Required Work Loop

Run this loop for every packet.

1. From repo root, inspect the worktree:

   ```powershell
   git status --short
   ```

2. Pick the next packet:

   - Resume the first `[~]`.
   - If none, start the first `[ ]`.
   - Mark the packet `[~]` before edits.

3. From `flutter_app/`, regenerate the whole inventory:

   ```powershell
   $root=(Resolve-Path .).Path
   Get-ChildItem lib -Recurse -Filter *.dart |
     ForEach-Object {
       $rel=$_.FullName.Substring($root.Length+1)
       $lines=(Get-Content $_.FullName).Count
       [pscustomobject]@{ Lines=$lines; File=$rel }
     } |
     Sort-Object Lines -Descending |
     Select-Object -First 120 |
     Format-Table -AutoSize
   ```

4. Regenerate packet-specific inventories using the commands in
   `Scan Commands`.

5. Inspect symbol boundaries before extraction:

   ```powershell
   rg -n "^class |^enum |^extension |^mixin |^typedef |^final class " <target-files>
   ```

6. Identify behavior that must remain stable:

   - Route paths and route names.
   - `GoRouter` navigation calls.
   - Riverpod reads, watches, controllers, and providers.
   - Keys and text relied on by tests.
   - Loading, empty, error, offline, submitting, and success states.
   - Financial previews, fees, limits, warnings, and next steps.
   - Prediction Markets wallet/PnL wording.
   - Open Arena points-only wording.

7. Apply the smallest cohesive extraction:

   - Keep page state, controllers, provider reads, and navigation in the page.
   - Move visual sections to `features/<feature>/presentation/widgets/`.
   - Move repository fixtures to `features/<feature>/data/repositories/`
     fixture files or parts.
   - Keep contracts and value objects under `features/<feature>/domain/`.
   - Use `part` files only when preserving private boundaries is cleaner than
     public widget imports.

8. Format touched Dart files:

   ```powershell
   dart format <touched-dart-files>
   ```

9. Run verification from `flutter_app/`:

   ```powershell
   flutter analyze
   flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact
   ```

   Add feature tests, product copy tests, and accessibility tests according to
   the verification matrix below.

10. Run direct architecture grep on touched Dart files:

    ```powershell
    rg -n "features/.*/data|\bColors\." <touched-dart-files>
    ```

    Expected result: no new presentation-to-data imports and no new runtime
    `Colors.*` usage.

11. Re-count touched files and update the packet notes:

    - Before line counts.
    - After line counts.
    - New files.
    - Commands and results.
    - GitNexus result or fallback reason.
    - Any documented exception.

12. Mark the packet:

    - `[x]` only when complete and verified.
    - `[!]` only for a concrete blocker or intentional exception.

## GitNexus Requirement

Before each packet, check whether GitNexus MCP tools are available. If they are
available, use repo context, clusters, `query`, `context`, `impact`, and
`detect_changes` before and after the edit.

If MCP tools are unavailable, run from repo root:

```powershell
npx -y gitnexus@latest analyze . --skip-agents-md --embeddings --worker-timeout 60
npx -y gitnexus@latest status
```

If embeddings or install are too slow, retry:

```powershell
npx -y gitnexus@latest analyze . --skip-agents-md --skip-embeddings --worker-timeout 60
```

Do not set `GITNEXUS_SKIP_OPTIONAL_GRAMMARS=1`, because that skips Dart
parsing. If GitNexus cannot run, continue with `rg`, analyzer, and tests, then
record the failure in the packet notes.

## Verification Matrix

| Area touched | Required verification from `flutter_app/` |
| --- | --- |
| Any Dart source | `flutter analyze`; architecture guardrail |
| Pages/widgets | Matching feature tests; product copy guardrail if copy, risk, fees, limits, or confirmations moved |
| P2P | `flutter test test/features/p2p --reporter=compact`; product copy guardrail; accessibility semantics guardrail |
| Wallet | `flutter test test/features/wallet --reporter=compact`; product copy guardrail for high-risk flows; accessibility semantics guardrail |
| Auth/profile security | Matching feature tests; accessibility semantics guardrail |
| Trade/copy/bot/leverage | `flutter test test/features/trade --reporter=compact`; product copy guardrail for risk/financial copy |
| Earn/staking/savings | `flutter test test/features/earn --reporter=compact`; product copy guardrail for safety/yield copy |
| Predictions | `flutter test test/features/predictions --reporter=compact`; product copy guardrail |
| Arena | `flutter test test/features/arena --reporter=compact`; product copy guardrail to protect points-only wording |
| Router | `flutter test test/app/router --reporter=compact`; full analyzer; architecture guardrail |
| Shared widgets/theme | Relevant feature tests plus broad widget/quality tests |
| Tests | Run the changed test file and any suite it supports |

Guardrail commands:

```powershell
flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact
flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact
flutter test test/quality/accessibility_semantics_critical_flows_test.dart --reporter=compact
```

## Packet Board

### EG-00 - Inventory Refresh

Status: `[x]`

Priority: P0

Goal: Refresh the full enterprise inventory and replace stale snapshot counts
before editing source.

Required actions:

- Run all commands in `Scan Commands`.
- Confirm hard-target status for pages, widgets, repositories, controllers,
  domain entities, router, tests, and painter/chart files.
- Record any new files above soft or hard thresholds.
- Confirm `presentation/shared` has no `features/*/data` imports.
- Confirm `lib/` has no runtime `Colors.*`.

Completion notes:

- Before counts:
  - Snapshot table already showed no Dart files above `900`, no presentation
    pages/widgets above hard targets, `37` widgets at or above `400`, `49`
    domain entity files at or above `500`, `3` router files at or above `500`,
    `4` repositories at or above `400`, `1` controller at or above `350`, and
    `2` tests at or above `700`.
- After counts:
  - `AllDartOver900`: `0`
  - `PagesAtOrAbove600`: `0`
  - `PagesAtOrAbove500`: `95`
  - `WidgetsAtOrAbove600`: `0`
  - `WidgetsAtOrAbove400`: `37`
  - `PainterChartAtOrAbove400`: `8`
  - `ControllersAtOrAbove500`: `0`
  - `ControllersAtOrAbove350`: `1`
  - `RepositoriesAtOrAbove500`: `1`
  - `RepositoriesAtOrAbove400`: `4`
  - `DomainEntitiesAtOrAbove800`: `0`
  - `DomainEntitiesAtOrAbove500`: `49`
  - `RouterAtOrAbove700`: `0`
  - `RouterAtOrAbove500`: `3`
  - `TestFilesAtOrAbove900`: `1`
  - `TestFilesAtOrAbove700`: `2`
  - `Presentation/shared direct data imports`: `0`
  - `Runtime Colors.*`: `0`
- Commands/results:
  - `git status --short` showed a dirty worktree from prior refactor work; no
    files were reverted.
  - Ran every scan category from `Scan Commands`.
  - `flutter analyze` passed: `No issues found!`.
  - `flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact` passed: `10` tests.
  - No source edit required; only tracker inventory notes were updated.
- GitNexus/fallback:
  - GitNexus MCP tools were unavailable via tool discovery.
  - `npx -y gitnexus@latest analyze . --skip-agents-md --embeddings --worker-timeout 60` failed with `Cannot destructure property 'package' of 'node.target' as it is null`.
  - `npx -y gitnexus@latest status` failed with the same npm error.
  - Retry `npx -y gitnexus@latest analyze . --skip-agents-md --skip-embeddings --worker-timeout 60` failed with the same npm error.
  - Continued with `rg`, PowerShell inventory scans, analyzer, and architecture guardrail.

### EG-01 - Hard Guardrail Closure

Status: `[x]`

Priority: P0

Goal: Keep all current hard limits closed. If a hard breach appears, fix it
before any soft cleanup.

Hard gates:

- No Dart file above 900 lines.
- No presentation page at or above 600 lines.
- No presentation widget at or above 600 lines.
- No controller at or above 500 lines.
- No domain entity file at or above 800 lines.
- No router file at or above 700 lines.
- No test file at or above 900 lines unless documented as a deliberate suite
  root.

Completion notes:

- Breaches found:
  - No Dart source hard breaches:
    - `AllDartOver900`: `0`
    - `PagesAtOrAbove600`: `0`
    - `WidgetsAtOrAbove600`: `0`
    - `ControllersAtOrAbove500`: `0`
    - `DomainEntitiesAtOrAbove800`: `0`
    - `RouterAtOrAbove700`: `0`
  - One test suite is at or above the test hard target:
    - `test/app/router/app_router_test.dart`: `962` lines.
- Files fixed:
  - None. No source edit required.
- Exceptions:
  - `test/app/router/app_router_test.dart` is documented as the current
    deliberate router stability suite root because it verifies app shell
    navigation plus stable route names/paths across the app. It remains covered
    by `EG-09 - Test Suite Decomposition Audit`, where it must be split or
    re-justified with focused evidence.
- Commands/results:
  - Hard gate scan passed for source files.
  - `flutter analyze` passed during `EG-00`: `No issues found!`.
  - `flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact` passed during `EG-00`: `10` tests.
  - `flutter test test/app/router --reporter=compact` passed.
- GitNexus/fallback:
  - Reused same-run GitNexus preflight result from `EG-00`: MCP unavailable and
    CLI failed with `Cannot destructure property 'package' of 'node.target' as it is null`.
  - Continued with PowerShell hard gate scans, router test, analyzer, and
    architecture guardrail.

### EG-02 - Page Composition Audit

Status: `[x]`

Priority: P1

Goal: Review pages from 550 to 599 lines and split only when they still own
visual sections instead of state/navigation/composition.

Current priority inventory:

| Lines | File |
| ---: | --- |
| 597 | `lib/features/trade/presentation/pages/ex_post_costs_report_page.dart` |
| 588 | `lib/features/support/presentation/pages/help_center_page.dart` |
| 587 | `lib/features/p2p/presentation/pages/p2p_payment_method_verification_page.dart` |
| 584 | `lib/features/auth/presentation/pages/otp_page.dart` |
| 579 | `lib/features/launchpad/presentation/pages/launchpad_receipt_page.dart` |
| 577 | `lib/features/trade/presentation/pages/bot_faq_page.dart` |
| 574 | `lib/features/predictions/presentation/pages/prediction_event_detail_page_part_02.dart` |
| 568 | `lib/features/trade/presentation/pages/margin_trading_page_part_03.dart` |
| 565 | `lib/features/trade/presentation/pages/cass_reconciliation_page.dart` |
| 564 | `lib/features/predictions/presentation/pages/prediction_event_detail_page_part_01.dart` |
| 561 | `lib/features/p2p/presentation/pages/p2p_report_merchant_page.dart` |
| 560 | `lib/features/predictions/presentation/pages/prediction_event_detail_page_part_04.dart` |
| 560 | `lib/features/dca/presentation/pages/dca_portfolio_optimizer_page_part_02.dart` |
| 559 | `lib/features/earn/presentation/pages/savings_what_if_page_part_03.dart` |
| 558 | `lib/features/trade/presentation/pages/risk_indicator_explainer_page.dart` |
| 556 | `lib/features/arena/presentation/pages/arena_governance_gate_page_part_03.dart` |
| 556 | `lib/features/admin/presentation/pages/admin_home.dart` |
| 555 | `lib/features/earn/presentation/pages/savings_ladder_page_part_02.dart` |
| 554 | `lib/features/profile/presentation/pages/kyc_page.dart` |
| 551 | `lib/features/dca/presentation/pages/dca_portfolio_optimizer_page_part_01.dart` |
| 550 | `lib/features/trade/presentation/pages/margin_trading_hub_page.dart` |

Extraction rule:

- Split only cohesive sections such as headers, summaries, rows, filters,
  sheets, tab bodies, charts, and confirmation panels.
- Leave part files alone when further splitting would create nested `part`
  complexity with no behavior benefit.

Completion notes:

- Files reviewed:
  - Reviewed all `21` current pages from `550` to `599` lines.
  - Current count: `PagesAtOrAbove600 = 0`; all reviewed files are below the
    page hard target.
  - `12` reviewed files are normal page files with private local widget
    sections.
  - `9` reviewed files are already `part of` files:
    - `prediction_event_detail_page_part_02.dart`
    - `margin_trading_page_part_03.dart`
    - `prediction_event_detail_page_part_01.dart`
    - `prediction_event_detail_page_part_04.dart`
    - `dca_portfolio_optimizer_page_part_02.dart`
    - `savings_what_if_page_part_03.dart`
    - `arena_governance_gate_page_part_03.dart`
    - `savings_ladder_page_part_02.dart`
    - `dca_portfolio_optimizer_page_part_01.dart`
- Files split:
  - None. No source edit required.
- Exceptions:
  - No new page `part` files were created because the architecture guardrail
    tracks presentation page part-file debt. Further splitting the existing
    `part of` files would also create nested-part pressure that Dart does not
    support cleanly.
  - The `12` normal page files remain below the hard target. Extracting their
    private local widgets into public widget imports would be higher churn than
    justified for this soft audit packet and should be done only inside a
    feature-specific behavior change or design-system cleanup where focused
    tests are already in scope.
- Commands/results:
  - Symbol-boundary scan reviewed classes and `part of` status for all `21`
    files.
  - Direct grep `rg -n "features/.*/data|\bColors\." <21 reviewed files>`
    returned no matches.
  - `flutter analyze` passed during `EG-00`: `No issues found!`.
  - `flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact` passed during `EG-00`: `10` tests.
- GitNexus/fallback:
  - Reused same-run GitNexus fallback from `EG-00`; continued with symbol
    scans, direct grep, analyzer, and architecture guardrail.

### EG-03 - Widget Soft Cleanup

Status: `[x]`

Priority: P1

Goal: Review every presentation widget at or above 400 lines. Split widgets
that contain multiple independent visual sections. Document exceptions for
cohesive `part of` files or dense chart widgets.

Current priority inventory:

| Lines | File |
| ---: | --- |
| 560 | `lib/features/profile/presentation/widgets/profile_sub_account_cards.dart` |
| 538 | `lib/features/launchpad/presentation/widgets/launchpad_home_tool_widgets.dart` |
| 499 | `lib/features/earn/presentation/widgets/staking_insurance_fund_overview.dart` |
| 494 | `lib/features/launchpad/presentation/widgets/launchpad_limit_orders_create_widgets.dart` |
| 490 | `lib/features/discovery/presentation/widgets/unified_search_results.dart` |
| 489 | `lib/features/dca/presentation/widgets/dca_performance_compare_analysis.dart` |
| 489 | `lib/features/trade/presentation/widgets/live_market_interest_cards.dart` |
| 486 | `lib/features/trade/presentation/widgets/regulatory_disclosures_common.dart` |
| 479 | `lib/features/p2p/presentation/widgets/p2p_ad_detail_amount_terms.dart` |
| 479 | `lib/features/markets/presentation/widgets/pair_detail_chart_widgets.dart` |
| 474 | `lib/features/profile/presentation/widgets/profile_api_key_create_form.dart` |
| 473 | `lib/features/trade/presentation/widgets/copy_trading_card_demo_widgets.dart` |
| 470 | `lib/features/earn/presentation/widgets/staking_transaction_reporting_summary_widgets.dart` |
| 459 | `lib/features/predictions/presentation/widgets/prediction_portfolio_analyzer_risk.dart` |
| 458 | `lib/features/markets/presentation/widgets/market_depth_chart.dart` |
| 457 | `lib/features/markets/presentation/widgets/market_derivatives_overview.dart` |
| 454 | `lib/features/wallet/presentation/widgets/wallet_gas_optimizer_current.dart` |
| 453 | `lib/features/p2p/presentation/widgets/p2p_device_management_cards.dart` |
| 443 | `lib/features/launchpad/presentation/widgets/launchpad_abi_diff_summary.dart` |
| 440 | `lib/features/trade/presentation/widgets/copy_trading_v2_variant_hero.dart` |
| 439 | `lib/features/markets/presentation/widgets/market_screener_filters.dart` |
| 437 | `lib/features/earn/presentation/widgets/savings_comparison_table_widgets.dart` |
| 435 | `lib/features/launchpad/presentation/widgets/launchpad_home_project_widgets.dart` |
| 431 | `lib/features/earn/presentation/widgets/savings_export_summary_widgets.dart` |
| 431 | `lib/features/trade/presentation/widgets/arm_integration_providers.dart` |
| 431 | `lib/features/wallet/presentation/widgets/wallet_manager_all_wallets_tab.dart` |
| 425 | `lib/features/trade/presentation/widgets/copy_performance_common.dart` |
| 424 | `lib/features/trade/presentation/widgets/transaction_reporting_reports.dart` |
| 419 | `lib/features/p2p/presentation/widgets/p2p_settings_trade_security.dart` |
| 418 | `lib/features/markets/presentation/widgets/token_info_tabs_widgets.dart` |
| 416 | `lib/features/wallet/presentation/widgets/wallet_page_asset_sections.dart` |
| 409 | `lib/features/trade/presentation/widgets/dispute_resolution_form.dart` |
| 407 | `lib/features/launchpad/presentation/widgets/launchpad_swap_aggregator_quotes.dart` |
| 406 | `lib/features/profile/presentation/widgets/profile_vip_overview.dart` |
| 405 | `lib/features/trade/presentation/widgets/advanced_chart_header_toolbar.dart` |
| 402 | `lib/features/p2p/presentation/widgets/p2p_trading_level_cards.dart` |
| 401 | `lib/features/earn/presentation/widgets/savings_guide_tutorials.dart` |

Completion notes:

- Files reviewed:
  - Reviewed all `37` presentation widgets at or above `400` lines.
  - Current count: `WidgetsAtOrAbove600 = 0`; all reviewed widgets are below
    the widget hard target.
  - `29` reviewed widgets are `part of` files already extracted from larger
    pages/widgets.
  - `8` reviewed widgets are normal files:
    - `staking_insurance_fund_overview.dart`
    - `live_market_interest_cards.dart`
    - `copy_trading_card_demo_widgets.dart`
    - `market_depth_chart.dart`
    - `market_derivatives_overview.dart`
    - `wallet_manager_all_wallets_tab.dart`
    - `transaction_reporting_reports.dart`
    - `savings_guide_tutorials.dart`
- Files split:
  - None. No source edit required.
- Exceptions:
  - The `29` `part of` widgets were left intact because splitting further would
    require changing private page/widget boundaries or introducing nested-part
    pressure.
  - The `8` normal widgets remain below hard target and represent cohesive
    widget families such as chart, table, report, manager tab, or guide blocks.
    Chart-specific files are reviewed again in `EG-04`.
- Commands/results:
  - Symbol/count audit found `37` widgets at or above `400`, `0` widgets at or
    above `600`, `29` `part of` widgets, and `8` normal widgets.
  - Direct grep `rg -n "features/.*/data|\bColors\." <37 reviewed widgets>`
    returned no matches.
  - `flutter analyze` passed during `EG-00`: `No issues found!`.
  - `flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact` passed during `EG-00`: `10` tests.
- GitNexus/fallback:
  - Reused same-run GitNexus fallback from `EG-00`; continued with symbol/count
    scans, direct grep, analyzer, and architecture guardrail.

### EG-04 - Painter And Chart Cleanup

Status: `[x]`

Priority: P1

Goal: Review painter/chart files at or above 400 lines. Split calculation,
legend, toolbar, model, and painter responsibilities when they are mixed.

Current priority inventory:

| Lines | File |
| ---: | --- |
| 509 | `lib/features/predictions/presentation/pages/prediction_advanced_chart_page_part_03.dart` |
| 505 | `lib/features/predictions/presentation/pages/prediction_advanced_chart_page_part_02.dart` |
| 485 | `lib/features/predictions/presentation/pages/prediction_advanced_chart_page_part_01.dart` |
| 479 | `lib/features/markets/presentation/widgets/pair_detail_chart_widgets.dart` |
| 460 | `lib/features/markets/presentation/pages/advanced_charts_page_part_02.dart` |
| 458 | `lib/features/markets/presentation/widgets/market_depth_chart.dart` |
| 458 | `lib/features/markets/presentation/pages/advanced_charts_page_part_01.dart` |
| 405 | `lib/features/trade/presentation/widgets/advanced_chart_header_toolbar.dart` |

Completion notes:

- Files reviewed:
  - Reviewed all `8` painter/chart files at or above `400` lines.
  - Current count: `ChartPainterAtOrAbove600 = 0`; all reviewed chart/painter
    files are below hard target.
  - `7` reviewed files are `part of` files.
  - `2` reviewed files contain `CustomPainter` implementations.
- Files split:
  - None. No source edit required.
- Exceptions:
  - Rendering files were left intact because they are under hard target and
    splitting chart calculation, painter, and visual composition without a
    visual regression pass would add risk. Revisit only with chart-specific
    tests or screenshot/device validation.
  - Existing `part of` chart files were not split further to avoid increasing
    nested private-boundary complexity.
- Commands/results:
  - Chart/painter count audit found `8` files at or above `400`, `0` files at
    or above `600`, `7` `part of` files, and `2` `CustomPainter` files.
  - Direct grep `rg -n "features/.*/data|\bColors\." <8 reviewed files>`
    returned no matches.
  - `flutter analyze` passed during `EG-00`: `No issues found!`.
  - `flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact` passed during `EG-00`: `10` tests.
- GitNexus/fallback:
  - Reused same-run GitNexus fallback from `EG-00`; continued with chart/painter
    scans, direct grep, analyzer, and architecture guardrail.

### EG-05 - Controller And Provider Responsibility Audit

Status: `[x]`

Priority: P2

Goal: Keep controllers focused on presentation state transitions. Move reusable
formatting, mapping, and fixture-heavy helpers out of controllers when found.

Current priority inventory:

| Lines | File |
| ---: | --- |
| 377 | `lib/features/predictions/presentation/controllers/predictions_controller.dart` |

Completion notes:

- Files reviewed:
  - `lib/features/predictions/presentation/controllers/predictions_controller.dart`
    (`377` lines).
  - Public boundaries include `PredictionsReadModelController`,
    `PredictionHighRiskFlowStatus`, event detail, portfolio, risk calculator,
    and order receipt view-state/controller types.
- Files split:
  - None. No source edit required.
- Exceptions:
  - The file is below the controller hard target and acts as the cohesive
    prediction high-risk presentation contract used by
    `lib/app/providers/predictions_controller_providers.dart` and multiple
    prediction pages/widgets. Splitting would increase import/provider churn
    without isolating a fixture-heavy or reusable helper boundary.
- Commands/results:
  - Symbol-boundary scan reviewed controller classes and public typedef/enum.
  - Reference scan found provider and presentation call sites for
    `predictionsReadModelControllerProvider` and related controllers.
  - Direct grep `rg -n "features/.*/data|\bColors\." predictions_controller.dart`
    returned no matches.
  - `flutter analyze` passed during `EG-00`: `No issues found!`.
  - `flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact` passed during `EG-00`: `10` tests.
- GitNexus/fallback:
  - Reused same-run GitNexus fallback from `EG-00`; continued with symbol scan,
    reference scan, direct grep, analyzer, and architecture guardrail.

### EG-06 - Repository And Fixture Audit

Status: `[x]`

Priority: P2

Goal: Keep repository public APIs stable while moving large static fixtures into
cohesive fixture files. Do not split fail-closed behavior unless there is a
clear isolated policy/helper boundary.

Current priority inventory:

| Lines | File |
| ---: | --- |
| 504 | `lib/features/wallet/data/repositories/fail_closed_wallet_repository.dart` |
| 447 | `lib/features/profile/data/repositories/mock_profile_repository_core_fixtures.dart` |
| 446 | `lib/features/admin/data/repositories/mock_admin_repository.dart` |
| 424 | `lib/features/rewards/data/repositories/mock_rewards_repository.dart` |

Completion notes:

- Files reviewed:
  - `fail_closed_wallet_repository.dart` (`504` lines)
  - `mock_profile_repository_core_fixtures.dart` (`447` lines)
  - `mock_admin_repository.dart` (`446` lines)
  - `mock_rewards_repository.dart` (`424` lines)
- Files split:
  - None. No source edit required.
- Exceptions:
  - `fail_closed_wallet_repository.dart` remains a cohesive fail-closed
    `WalletRepository` implementation; splitting would obscure the policy
    boundary and it is far below the repository hard target.
  - Profile/admin/rewards mock repositories and fixture files are below the
    500-line ideal ceiling and have no clear lower-risk fixture split remaining.
- Commands/results:
  - Symbol-boundary scan reviewed repository classes and `implements`
    boundaries.
  - Reference scan confirmed call sites in wallet provider/environment tests and
    rewards tests/providers.
  - `flutter analyze` passed during `EG-00`: `No issues found!`.
  - `flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact` passed during `EG-00`: `10` tests.
- GitNexus/fallback:
  - Reused same-run GitNexus fallback from `EG-00`; continued with symbol scan,
    reference scan, analyzer, and architecture guardrail.

### EG-07 - Domain Entity Cohesion Audit

Status: `[x]`

Priority: P2

Goal: Review domain entity files at or above 500 lines. Split only by bounded
context, value-object family, or public API clarity. Do not create arbitrary
tiny files just to reduce line counts.

Current priority inventory:

| Lines | File |
| ---: | --- |
| 560 | `lib/features/earn/domain/entities/earn_entities_part_03.dart` |
| 560 | `lib/features/earn/domain/entities/earn_entities_part_05.dart` |
| 560 | `lib/features/arena/domain/entities/arena_entities_part_01.dart` |
| 558 | `lib/features/trade/domain/entities/trade_entities_part_01.dart` |
| 558 | `lib/features/arena/domain/entities/arena_entities_part_03.dart` |
| 558 | `lib/features/trade/domain/entities/trade_entities_part_07.dart` |
| 557 | `lib/features/trade/domain/entities/trade_entities_part_04.dart` |
| 556 | `lib/features/earn/domain/entities/earn_entities_part_07.dart` |
| 556 | `lib/features/trade/domain/entities/trade_entities_part_08.dart` |
| 556 | `lib/features/trade/domain/entities/trade_entities_part_13.dart` |
| 555 | `lib/features/trade/domain/entities/trade_entities_part_11.dart` |
| 554 | `lib/features/trade/domain/entities/trade_entities_part_05.dart` |
| 554 | `lib/features/earn/domain/entities/earn_entities_part_11.dart` |
| 553 | `lib/features/earn/domain/entities/earn_entities_part_10.dart` |
| 553 | `lib/features/p2p/domain/entities/p2p_entities_part_02.dart` |
| 552 | `lib/features/launchpad/domain/entities/launchpad_entities_part_03.dart` |
| 552 | `lib/features/launchpad/domain/entities/launchpad_entities_part_04.dart` |
| 552 | `lib/features/referral/domain/entities/referral_entities.dart` |
| 550 | `lib/features/trade/domain/entities/trade_entities_part_09.dart` |
| 550 | `lib/features/trade/domain/entities/trade_entities_part_12.dart` |
| 549 | `lib/features/earn/domain/entities/earn_entities_part_08.dart` |
| 548 | `lib/features/p2p/domain/entities/p2p_entities_part_01.dart` |
| 547 | `lib/features/trade/domain/entities/trade_entities_part_06.dart` |
| 547 | `lib/features/earn/domain/entities/earn_entities_part_06.dart` |
| 546 | `lib/features/p2p/domain/entities/p2p_entities_part_08.dart` |
| 546 | `lib/features/trade/domain/entities/trade_entities_part_02.dart` |
| 546 | `lib/features/earn/domain/entities/earn_entities_part_01.dart` |
| 546 | `lib/features/earn/domain/entities/earn_entities_part_04.dart` |
| 546 | `lib/features/arena/domain/entities/arena_entities_part_02.dart` |
| 542 | `lib/features/p2p/domain/entities/p2p_entities_part_05.dart` |
| 540 | `lib/features/earn/domain/entities/earn_entities_part_02.dart` |
| 540 | `lib/features/arena/domain/entities/arena_entities_part_04.dart` |
| 540 | `lib/features/launchpad/domain/entities/launchpad_entities_part_02.dart` |
| 540 | `lib/features/p2p/domain/entities/p2p_entities_part_03.dart` |
| 539 | `lib/features/trade/domain/entities/trade_entities_part_03.dart` |
| 537 | `lib/features/trade/domain/entities/trade_entities_part_10.dart` |
| 536 | `lib/features/p2p/domain/entities/p2p_entities_part_06.dart` |
| 527 | `lib/features/earn/domain/entities/earn_entities_part_09.dart` |
| 525 | `lib/features/earn/domain/entities/earn_entities_part_12.dart` |
| 517 | `lib/features/markets/domain/entities/market_entities_part_02.dart` |
| 516 | `lib/features/p2p/domain/entities/p2p_entities_part_04.dart` |
| 514 | `lib/features/launchpad/domain/entities/launchpad_entities_part_01.dart` |
| 514 | `lib/features/predictions/domain/entities/predictions_entities_part_03.dart` |
| 512 | `lib/features/p2p/domain/entities/p2p_entities_part_07.dart` |
| 511 | `lib/features/p2p/domain/entities/p2p_entities_part_09.dart` |
| 507 | `lib/features/markets/domain/entities/market_entities_part_03.dart` |
| 506 | `lib/features/p2p/domain/entities/p2p_entities_part_10.dart` |
| 504 | `lib/features/predictions/domain/entities/predictions_entities_part_01.dart` |
| 502 | `lib/features/markets/domain/entities/market_entities_part_01.dart` |

Completion notes:

- Files reviewed:
  - Reviewed all `49` domain entity files at or above `500` lines.
  - Feature distribution: trade `13`, earn `12`, P2P `10`, launchpad `4`,
    arena `4`, markets `3`, predictions `2`, referral `1`.
  - Current count: `DomainEntitiesAtOrAbove800 = 0`; all reviewed files are
    below the domain hard target.
  - `48` reviewed files are generated-style `part of` entity partitions.
  - `1` reviewed file is a normal domain file:
    `lib/features/referral/domain/entities/referral_entities.dart`.
- Files split:
  - None. No source edit required.
- Exceptions:
  - Generated-style domain `part` files were left intact because additional
    arbitrary splits would make domain imports harder to follow without a clear
    bounded-context gain.
  - `referral_entities.dart` remains a cohesive referral domain bundle under
    hard target; split only if referral contracts grow into distinct bounded
    contexts.
- Commands/results:
  - Domain entity audit found `49` files at or above `500`, `0` files at or
    above `800`, `48` `part of` files, and `1` normal file.
  - `flutter analyze` passed during `EG-00`: `No issues found!`.
  - `flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact` passed during `EG-00`: `10` tests.
- GitNexus/fallback:
  - Reused same-run GitNexus fallback from `EG-00`; continued with domain
    entity scans, analyzer, and architecture guardrail.

### EG-08 - Router Facade And Route Group Audit

Status: `[x]`

Priority: P2

Goal: Keep route groups readable while preserving the public router facade API:
`createAppRouter`, `appRouter`, `AppRoutePaths`, and `AppRouteNames`.

Current priority inventory:

| Lines | File |
| ---: | --- |
| 567 | `lib/app/router/route_groups/trade_routes.dart` |
| 550 | `lib/app/router/app_route_paths.dart` |
| 515 | `lib/app/router/route_groups/p2p_routes.dart` |

Rules:

- Do not change existing paths or names.
- Do not import pages through non-public data boundaries.
- Split only by route domain or cohesive sub-group.
- Run router tests before marking complete.

Completion notes:

- Files reviewed:
  - `lib/app/router/route_groups/trade_routes.dart` (`567` lines)
  - `lib/app/router/app_route_paths.dart` (`550` lines)
  - `lib/app/router/route_groups/p2p_routes.dart` (`515` lines)
- Files split:
  - None. No source edit required.
- Exceptions:
  - All reviewed router files are below the `700` hard target.
  - `trade_routes.dart` and `p2p_routes.dart` are cohesive route declaration
    groups; splitting would increase router indirection while risking route
    name/path regressions.
  - `app_route_paths.dart` is the public route-path facade and must remain
    stable for tests and call sites.
- Commands/results:
  - Router count audit found `3` router files at or above `500` and `0` router
    files at or above `700`.
  - Route/facade scan reviewed `GoRoute`, `path:`, `name:`, `AppRoutePaths`,
    and `AppRouteNames` usage.
  - Direct grep `rg -n "features/.*/data|\bColors\." <3 reviewed router files>`
    returned no matches.
  - `flutter test test/app/router --reporter=compact` passed during `EG-01`.
  - `flutter analyze` passed during `EG-00`: `No issues found!`.
- GitNexus/fallback:
  - Reused same-run GitNexus fallback from `EG-00`; continued with route scans,
    direct grep, router tests, and analyzer.

### EG-09 - Test Suite Decomposition Audit

Status: `[x]`

Priority: P2

Goal: Keep tests readable and targeted. Split very large tests by route group,
behavior group, or fixture setup only when it improves diagnosis.

Current priority inventory:

| Lines | File |
| ---: | --- |
| 962 | `test/app/router/app_router_test.dart` |
| 794 | `test/features/trade/trade_history_export_page_test.dart` |

Completion notes:

- Files reviewed:
  - `test/app/router/app_router_test.dart` (`962` -> `60` lines)
  - `test/app/router/app_route_names_contract_test.dart` (new, `368` lines)
  - `test/app/router/app_route_paths_contract_test.dart` (new, `545` lines)
  - `test/features/trade/trade_history_export_page_test.dart` (`794` lines)
- Files split:
  - Split `test/app/router/app_router_test.dart` into focused shell/router
    widget coverage plus route-name and route-path contract suites.
- Exceptions:
  - `test/features/trade/trade_history_export_page_test.dart` remains `794`
    lines. It is below the `900` hard target and remains a cohesive SC-054
    export behavior suite; split only if this flow grows or starts hiding
    unrelated setup.
- Commands/results:
  - Test inventory after split found `0` test files at or above `900`; only
    `test/features/trade/trade_history_export_page_test.dart` remains at or
    above `700`.
  - `dart format test/app/router/app_router_test.dart
    test/app/router/app_route_names_contract_test.dart
    test/app/router/app_route_paths_contract_test.dart` passed.
  - Initial `flutter test test/app/router --reporter=compact` exposed a
    double-encoded market-label assertion after the mechanical split.
  - Fixed the assertion with Unicode escapes and reran
    `flutter test test/app/router --reporter=compact`; passed.
  - `flutter test test/features/trade/trade_history_export_page_test.dart
    --reporter=compact` passed.
  - `flutter analyze` passed: `No issues found!`.
  - `flutter test test/quality/architecture_baseline_guardrails_test.dart
    --reporter=compact` passed.
- GitNexus/fallback:
  - Reused same-run GitNexus fallback from `EG-00`; continued with line-count
    inventory, focused test execution, analyzer, and architecture guardrail.

### EG-10 - Architecture Boundary Audit

Status: `[x]`

Priority: P1

Goal: Protect the enterprise module boundaries after all extraction waves.

Required checks:

- Presentation and shared UI must not import `features/*/data`.
- Cross-module feature references must use public domain/shared/app surfaces.
- App-level provider aggregation may import feature data providers when it is
  intentionally acting as composition root.
- No runtime `Colors.*` in `lib/`.
- No new repeated local scaffolds where shared primitives exist.

Completion notes:

- Violations found:
  - `lib/features/rewards/presentation/pages/rewards_hub_page.dart` imported
    `features/arena/presentation/controllers/arena_controller.dart` and
    `features/arena/presentation/pages/arena_points_page.dart` directly.
    This reused the Arena points surface correctly for behavior, but it crossed
    feature presentation boundaries from the Rewards feature.
- Files fixed:
  - Added
    `lib/app/feature_bridges/rewards_arena_points_bridge.dart` (`156` lines)
    as the app-level composition bridge for RewardsHub -> ArenaPoints UI reuse.
  - Reduced `lib/features/rewards/presentation/pages/rewards_hub_page.dart`
    from `156` to `31` lines; it now keeps provider read and page composition
    only.
- Exceptions:
  - App-level bridge imports Arena presentation and Rewards domain intentionally
    because `app/` is the composition/root integration layer. Rewards
    presentation no longer imports Arena presentation directly.
- Commands/results:
  - Direct presentation/shared data import scan returned no matches.
  - Direct cross-feature import scan under `lib/features/` returned no matches
    after the bridge move.
  - `rg -n "\bColors\." lib` returned no matches.
  - `rg -n "features/.*/data|\bColors\." <touched files>` returned no
    matches.
  - `dart format lib/app/feature_bridges/rewards_arena_points_bridge.dart
    lib/features/rewards/presentation/pages/rewards_hub_page.dart` passed.
  - `flutter test test/features/rewards/rewards_hub_page_test.dart
    --reporter=compact` passed.
  - `flutter test test/quality/architecture_baseline_guardrails_test.dart
    --reporter=compact` passed.
  - `flutter analyze` passed: `No issues found!`.
- GitNexus/fallback:
  - Reused same-run GitNexus fallback from `EG-00`; continued with boundary
    grep scans, focused RewardsHub tests, analyzer, and architecture guardrail.

### EG-11 - Product Boundary And Financial Safety Audit

Status: `[x]`

Priority: P1

Goal: Make sure refactors did not weaken financial safety or product language.

Required checks:

- Withdrawals, escrow release, security changes, address additions, P2P payment
  method changes, and high-risk trading actions still show preview/confirm.
- Fees, risk, limits, and next steps remain visible before confirmation.
- Sensitive wallet, account, email, phone, and address data remains masked.
- Arena copy remains points-only.
- Prediction Markets copy remains wallet/positions/probability/receipt/PnL
  oriented and avoids hype or casino language.
- Product copy guardrail scans all files where safety copy was moved.

Completion notes:

- Files reviewed:
  - `lib/features/arena/presentation/pages/`
  - `lib/features/rewards/presentation/pages/rewards_hub_page.dart`
  - `lib/app/feature_bridges/rewards_arena_points_bridge.dart`
  - Guardrail-covered high-risk Wallet, P2P, Prediction, Trade, Futures,
    Margin, Auth, and Admin surfaces.
- Guardrail updates:
  - None required. EG-10 moved composition into an app bridge without changing
    visible financial-safety or product-boundary copy.
- Exceptions:
  - None.
- Commands/results:
  - `flutter test test/quality/product_copy_guardrails_test.dart
    --reporter=compact` passed.
  - `flutter test test/quality/accessibility_semantics_critical_flows_test.dart
    --reporter=compact` passed.
  - Direct grep for prohibited financial terms across Arena/Rewards pages and
    the Rewards/Arena bridge returned no matches.
- GitNexus/fallback:
  - Reused same-run GitNexus fallback from `EG-00`; continued with product copy
    guardrail, accessibility semantics guardrail, and direct copy grep.

### EG-12 - Final Enterprise Verification

Status: `[x]`

Priority: P0

Goal: Close the tracker only after all packets are `[x]` or `[!]` and the repo
passes the required enterprise checks.

Required final commands from `flutter_app/`:

```powershell
flutter analyze
flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact
flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact
flutter test test/quality/accessibility_semantics_critical_flows_test.dart --reporter=compact
```

Run full or broad tests when router, shared widgets, or many feature modules
were touched:

```powershell
flutter test --reporter=compact
```

Final done criteria:

- No packet remains `[ ]` or `[~]`.
- No hard line-count breaches remain.
- Soft-target exceptions are documented.
- `flutter analyze` passes.
- Required guardrails pass.
- Focused feature tests for touched areas pass.
- Direct grep finds no new `features/*/data` presentation imports and no new
  runtime `Colors.*`.
- GitNexus findings are handled or fallback is documented.

Completion notes:

- Final inventory:
  - Dart files above `900`: `0`.
  - Presentation pages at or above hard `600`: `0`.
  - Presentation widgets at or above hard `600`: `0`.
  - Controllers at or above hard `500`: `0`.
  - Data repositories at or above hard `900`: `0`.
  - Domain entities at or above hard `800`: `0`.
  - Router files at or above hard `700`: `0`.
  - Test files at or above hard `900`: `0`.
  - Test files at or above soft `700`: `1`
    (`test/features/trade/trade_history_export_page_test.dart`, `794` lines).
  - Presentation/shared imports from `features/*/data`: `0`.
  - Runtime `Colors.*` matches in `lib/`: `0`.
- Commands/results:
  - `flutter analyze` passed: `No issues found!`.
  - `flutter test test/quality/architecture_baseline_guardrails_test.dart
    --reporter=compact` passed.
  - `flutter test test/quality/product_copy_guardrails_test.dart
    --reporter=compact` passed.
  - `flutter test test/quality/accessibility_semantics_critical_flows_test.dart
    --reporter=compact` passed.
  - `flutter test --reporter=compact` passed (`1867` tests).
- Exceptions:
  - `test/features/trade/trade_history_export_page_test.dart` remains `794`
    lines and below the `900` hard target as a cohesive SC-054 export flow
    suite; documented in `EG-09`.
- GitNexus/fallback:
  - Reused same-run GitNexus fallback from `EG-00`. GitNexus MCP tools were
    unavailable and CLI analysis/status failed with
    `Cannot destructure property 'package' of 'node.target' as it is null`, so
    final verification used inventory scans, grep, analyzer, guardrails, and
    the full Flutter test suite.

## Scan Commands

Run from `flutter_app/`.

All Dart files above 900:

```powershell
$root=(Resolve-Path .).Path
Get-ChildItem lib -Recurse -Filter *.dart |
  ForEach-Object {
    $rel=$_.FullName.Substring($root.Length+1)
    $lines=(Get-Content $_.FullName).Count
    if ($lines -gt 900) { "$lines $rel" }
  } | Sort-Object {[int](($_ -split ' ')[0])} -Descending
```

Presentation pages at or above 500:

```powershell
$root=(Resolve-Path .).Path
Get-ChildItem lib -Recurse -Filter *.dart |
  Where-Object { $_.FullName -match '\\presentation\\pages\\' } |
  ForEach-Object {
    $rel=$_.FullName.Substring($root.Length+1)
    $lines=(Get-Content $_.FullName).Count
    if ($lines -ge 500) { "$lines $rel" }
  } | Sort-Object {[int](($_ -split ' ')[0])} -Descending
```

Presentation widgets at or above 400:

```powershell
$root=(Resolve-Path .).Path
Get-ChildItem lib -Recurse -Filter *.dart |
  Where-Object { $_.FullName -match '\\presentation\\widgets\\' } |
  ForEach-Object {
    $rel=$_.FullName.Substring($root.Length+1)
    $lines=(Get-Content $_.FullName).Count
    if ($lines -ge 400) { "$lines $rel" }
  } | Sort-Object {[int](($_ -split ' ')[0])} -Descending
```

Painter/chart files at or above 400:

```powershell
$root=(Resolve-Path .).Path
Get-ChildItem lib -Recurse -Filter *.dart |
  Where-Object { $_.FullName -match '(chart|painter)' } |
  ForEach-Object {
    $rel=$_.FullName.Substring($root.Length+1)
    $lines=(Get-Content $_.FullName).Count
    if ($lines -ge 400) { "$lines $rel" }
  } | Sort-Object {[int](($_ -split ' ')[0])} -Descending
```

Controllers at or above 350:

```powershell
$root=(Resolve-Path .).Path
Get-ChildItem lib -Recurse -Filter *.dart |
  Where-Object { $_.FullName -match '\\presentation\\controllers\\' } |
  ForEach-Object {
    $rel=$_.FullName.Substring($root.Length+1)
    $lines=(Get-Content $_.FullName).Count
    if ($lines -ge 350) { "$lines $rel" }
  } | Sort-Object {[int](($_ -split ' ')[0])} -Descending
```

Data repositories at or above 400:

```powershell
$root=(Resolve-Path .).Path
Get-ChildItem lib -Recurse -Filter *.dart |
  Where-Object { $_.FullName -match '\\data\\repositories\\' } |
  ForEach-Object {
    $rel=$_.FullName.Substring($root.Length+1)
    $lines=(Get-Content $_.FullName).Count
    if ($lines -ge 400) { "$lines $rel" }
  } | Sort-Object {[int](($_ -split ' ')[0])} -Descending
```

Domain entities at or above 500:

```powershell
$root=(Resolve-Path .).Path
Get-ChildItem lib -Recurse -Filter *.dart |
  Where-Object { $_.FullName -match '\\domain\\entities\\' } |
  ForEach-Object {
    $rel=$_.FullName.Substring($root.Length+1)
    $lines=(Get-Content $_.FullName).Count
    if ($lines -ge 500) { "$lines $rel" }
  } | Sort-Object {[int](($_ -split ' ')[0])} -Descending
```

Router files at or above 500:

```powershell
$root=(Resolve-Path .).Path
Get-ChildItem lib/app/router -Recurse -Filter *.dart |
  ForEach-Object {
    $rel=$_.FullName.Substring($root.Length+1)
    $lines=(Get-Content $_.FullName).Count
    if ($lines -ge 500) { "$lines $rel" }
  } | Sort-Object {[int](($_ -split ' ')[0])} -Descending
```

Test files at or above 700:

```powershell
$root=(Resolve-Path .).Path
Get-ChildItem test -Recurse -Filter *.dart |
  ForEach-Object {
    $rel=$_.FullName.Substring($root.Length+1)
    $lines=(Get-Content $_.FullName).Count
    if ($lines -ge 700) { "$lines $rel" }
  } | Sort-Object {[int](($_ -split ' ')[0])} -Descending
```

Presentation/shared direct data imports:

```powershell
Get-ChildItem lib/features,lib/shared -Recurse -Filter *.dart |
  Where-Object { $_.FullName -match '\\presentation\\' -or $_.FullName -match '\\shared\\' } |
  Select-String -Pattern 'features/.*/data'
```

Runtime `Colors.*`:

```powershell
rg -n "\bColors\." lib
```

Touched-file architecture grep:

```powershell
rg -n "features/.*/data|\bColors\." <touched-dart-files>
```
