# Flutter Enterprise 900-Line Refactor Tracking

Date: 2026-05-31
Scope: `flutter_app/lib`
Purpose: track the next enterprise-grade refactor wave after all Dart files
over 1000 lines were removed.

This file is a work tracker. Update it after every batch with real line counts,
commands, and notes.

## 1. Current Scan

Latest scan from `flutter_app/`:

```text
total_dart_files=1400
files_over_1000=0
files_over_900=41
files_over_800=80
files_over_700=121
files_over_600=167
feature_files_over_600=167
```

Enterprise target used by the project:

| File type | Ideal | Hard target | Reason |
| --- | ---: | ---: | --- |
| `presentation/pages/*_page.dart` | `300-600` lines | `<900` lines | Page should own route, state, provider read, navigation, and layout composition only. |
| `presentation/widgets/*.dart` | `100-400` lines | `<600` lines | Widgets should map to a clear section, card group, list, painter, or sheet. |
| `data/repositories/mock_*` | `200-500` lines | `<900` lines | Fixtures should be split by domain area, keeping repository API stable. |
| Painter/chart file | `100-400` lines | `<600` lines | Painters should be isolated and easy to review. |

## 2. Status Legend

| Status | Meaning |
| --- | --- |
| `[ ]` | Not started. |
| `[~]` | In progress. |
| `[x]` | Complete and verified. |
| `[!]` | Blocked or exception documented. |

## 3. Required Workflow Per Batch

Use this exact order.

1. Confirm current line counts:
   ```powershell
   $root=(Resolve-Path .).Path
   Get-ChildItem lib -Recurse -Filter *.dart |
     ForEach-Object {
       $rel=$_.FullName.Substring($root.Length+1)
       $lines=(Get-Content $_.FullName).Count
       if ($lines -gt 900) { "$lines $rel" }
     }
   ```
2. Read the target files and class boundaries:
   ```powershell
   rg -n "^class |^enum |^extension |^mixin |^typedef |^final class " <files>
   ```
3. Decide extraction boundaries:
   - Keep page state, provider reads, keys, route navigation, and top-level composition in the page.
   - Move visual sections, cards, rows, lists, sheets, and painters to `features/<feature>/presentation/widgets/`.
   - For private widgets, use `part` files only when that keeps local private API stable and does not increase architecture debt unexpectedly.
   - Prefer public widget files when the widget will be reused or imported by another file.
4. Edit files.
5. Run `dart format` on touched Dart files.
6. Run focused tests for the touched feature.
7. Run required guardrails:
   - `flutter analyze`
   - `flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact`
   - `flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact` for Trade, Prediction, Arena, Wallet, P2P, Earn financial copy.
   - `flutter test test/quality/accessibility_semantics_critical_flows_test.dart --reporter=compact` for Wallet/P2P/Auth high-risk flows.
8. Run direct grep on touched files:
   ```powershell
   rg -n "features/.*/data|\bColors\." <touched-files>
   ```
   Expected result: no direct data imports and no runtime `Colors.*`.
9. Update this tracker:
   - Status.
   - Before/after line counts.
   - New files.
   - Tests and command results.
   - Any exception.

## 4. Top-Level Priority

Process in this order:

1. High-risk user/account/security flows: Auth, Wallet, P2P.
2. Trade regulatory/copy/bot risk pages.
3. Prediction/Arena product-boundary-sensitive pages.
4. Markets, Launchpad, Earn, DCA, Cross-module, Profile.
5. Fixture repository and remaining `>800` follow-up.

## 5. Packet Overview

| Packet | Priority | Status | Files | Main split goal | Required tests |
| --- | --- | --- | --- | --- | --- |
| E900-01 | P0 | `[x]` | Auth 2FA | Split setup, QR, verify, backup code steps | Auth focused test + semantics + analyze |
| E900-02 | P0 | `[x]` | Wallet transfer/address/dust | Split high-risk wallet flows and transfer section barrel | Wallet tests + semantics + product copy + analyze |
| E900-03 | P0 | `[x]` | P2P wallet/blacklist/login/fraud | Split wallet, blacklist, fraud, login history | P2P tests + semantics + product copy + analyze |
| E900-04 | P1 | `[x]` | Trade risk/security/tax/audit | Split bot risk, security, tax, audit, attribution | Trade tests + product copy + analyze |
| E900-05 | P1 | `[x]` | Trade copy/provider/guide/disclosure | Split copy trading, provider application, guide, disclosure | Trade tests + product copy + analyze |
| E900-06 | P1 | `[x]` | Prediction market-maker/tournaments/calendar | Split liquidity, tournament, calendar widgets | Prediction tests + product copy + analyze |
| E900-07 | P1 | `[x]` | Arena studio | Split stepper, fee banner, templates, footer | Arena tests + product copy + analyze |
| E900-08 | P2 | `[x]` | Launchpad risk/performance/address/batch | Split risk analytics and launchpad operational pages | Launchpad tests + analyze |
| E900-09 | P2 | `[x]` | Earn savings/staking pages | Split savings/staking lists, calendars, history | Earn tests + product copy + analyze |
| E900-10 | P2 | `[x]` | Markets movers/screener | Split filters, result list, rows, painters | Markets tests + analyze |
| E900-11 | P2 | `[x]` | Profile page | Split hero, VIP, prediction, arena, menu/activity | Profile tests + analyze |
| E900-12 | P2 | `[x]` | Cross-module analytics | Split tabs, summary, metric cards, painters | Cross-module tests + product copy + analyze |
| E900-13 | P3 | `[x]` | DCA smart rules | Split tabs, rule/template/history cards | DCA tests + analyze |
| E900-14 | P3 | `[x]` | Referral mock repo | Split mock fixtures by referral area | Referral tests + analyze |

## 6. Detailed Packet Plans

### E900-01 - Auth 2FA setup

Status: `[x]`

Files:

| File | Current lines | Target |
| --- | ---: | ---: |
| `flutter_app/lib/features/auth/presentation/pages/two_fa_setup_page.dart` | `958` | `<500` |

Keep in page:

- `TwoFASetupPage`
- `_TwoFASetupPageState`
- step state, code controller, backup confirmation state
- provider reads and navigation

Extract to widgets:

| Target file | Move classes/sections |
| --- | --- |
| `two_fa_setup_steps.dart` | `_TwoFaStepper`, `_StepDot`, step labels |
| `two_fa_setup_qr.dart` | `_QrStep`, `_ShieldHero`, `_QrPreview`, `_QrPainter`, `_SecretKeyCard` |
| `two_fa_setup_verify.dart` | `_VerifyStep`, `_CodeDigitBox`, `_ErrorBanner`, `_WarningBanner` |
| `two_fa_setup_backup.dart` | `_BackupCodesStep`, `_BackupCodeList`, `_BackupSavedRow` |

Verification:

```bash
dart format lib/features/auth/presentation/pages/two_fa_setup_page.dart lib/features/auth/presentation/widgets
flutter test test/features/auth --reporter=compact
flutter test test/quality/accessibility_semantics_critical_flows_test.dart --reporter=compact
flutter analyze
flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact
```

Verification log:

- 2026-05-31: GitNexus MCP tools were not available via tool discovery. CLI
  preflight `npx -y gitnexus@latest analyze . --skip-agents-md --embeddings --worker-timeout 60`
  indexed the repo but reported `tree-sitter-dart` unavailable and skipped Dart
  parsing; later `gitnexus status` and `analyze --skip-embeddings` failed with
  `Cannot destructure property 'package' of 'node.target' as it is null`.
  Continued with `rg`, focused tests, guardrails, and analyzer fallback.
- 2026-05-31: Current large-file scan before E900-01 found `41` Dart files
  over `900` lines, including `two_fa_setup_page.dart` at `958` lines.
- 2026-05-31: Split `two_fa_setup_page.dart` from `958` to `262` lines.
  New widget part files: `two_fa_setup_steps.dart` (`64` lines),
  `two_fa_setup_qr.dart` (`284` lines), `two_fa_setup_verify.dart`
  (`191` lines), and `two_fa_setup_backup.dart` (`170` lines). Part files
  preserve existing private widget/key boundaries while moving visual sections
  under `features/auth/presentation/widgets/`.
- 2026-05-31: `dart format lib/features/auth/presentation/pages/two_fa_setup_page.dart lib/features/auth/presentation/widgets/two_fa_setup_steps.dart lib/features/auth/presentation/widgets/two_fa_setup_qr.dart lib/features/auth/presentation/widgets/two_fa_setup_verify.dart lib/features/auth/presentation/widgets/two_fa_setup_backup.dart`
  passed (`5` files, `4` changed).
- 2026-05-31: Direct grep
  `rg -n "features/.*/data|\bColors\."` over touched Auth source returned no
  matches.
- 2026-05-31: `flutter test test/features/auth --reporter=compact` passed
  (`46` tests).
- 2026-05-31: `flutter test test/quality/accessibility_semantics_critical_flows_test.dart --reporter=compact`
  passed (`6` tests).
- 2026-05-31: `flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact`
  passed (`10` tests).
- 2026-05-31: `flutter analyze` passed (`No issues found!`).

### E900-02 - Wallet high-risk pages

Status: `[x]`

Files:

| File | Current lines | Target |
| --- | ---: | ---: |
| `flutter_app/lib/features/wallet/presentation/widgets/wallet_transfer_sections.dart` | `944` | barrel or `<500` |
| `flutter_app/lib/features/wallet/presentation/pages/dust_converter_page.dart` | `942` | `<500` |
| `flutter_app/lib/features/wallet/presentation/pages/address_book_page.dart` | `940` | `<500` |

Split `wallet_transfer_sections.dart`:

| Target file | Move classes/sections |
| --- | --- |
| `wallet_transfer_confirm_sheet.dart` | `TransferConfirmSheet`, `_ConfirmRow`, `_ConfirmNote`, `_SheetButton` |
| `wallet_transfer_wallet_cards.dart` | `TransferWalletCard`, `_WalletIcon`, `TransferSwapButton` |
| `wallet_transfer_asset_amount.dart` | `TransferAssetCard`, `_AssetLogo`, `TransferAmountCard`, `TransferInfoNotice`, `TransferButton` |
| `wallet_transfer_history_picker.dart` | `RecentTransfersList`, `_RecentTransferRow`, `TransferWalletPickerRow`, `TransferAssetPickerRow`, `TransferSuccessBanner` |

Split `dust_converter_page.dart`:

| Target file | Move classes/sections |
| --- | --- |
| `wallet_dust_converter_hero.dart` | `_DustHero`, `_HeroStat` |
| `wallet_dust_converter_targets.dart` | `_TargetSelector`, `_TargetCard`, `_SelectAllRow` |
| `wallet_dust_converter_assets.dart` | `_DustAssetRow`, `_TokenLogo` |
| `wallet_dust_converter_confirm.dart` | `_ConvertFooter`, `_PrimaryButton`, `_PreviewRow`, `_ConvertedBanner`, `_SectionLabel` |

Split `address_book_page.dart`:

| Target file | Move classes/sections |
| --- | --- |
| `wallet_address_book_controls.dart` | `_AddAddressButton`, `_SearchBox`, `_NetworkFilterBar`, `_AddressStats` |
| `wallet_address_book_security.dart` | `_WhitelistModeCard`, `_SwitchPill`, `_SecurityTip` |
| `wallet_address_book_list.dart` | `_AddressCard`, `_ShieldBadge`, `_WhitelistBadge`, `_MiniTag`, `_CopyButton`, `_RoundActionButton`, `_EmptyAddressState` |

Verification:

```bash
flutter test test/features/wallet --reporter=compact
flutter test test/quality/accessibility_semantics_critical_flows_test.dart --reporter=compact
flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact
flutter analyze
```

Verification log:

- 2026-05-31: GitNexus Dart analysis remained unavailable from the E900
  preflight (`tree-sitter-dart` skipped, later CLI commands failed with
  `Cannot destructure property 'package' of 'node.target' as it is null`).
  Used `rg` for imports/symbols/blast radius plus Flutter tests and analyzer.
- 2026-05-31: Large-file scan before E900-02 showed Wallet targets at
  `wallet_transfer_sections.dart` (`944` lines), `dust_converter_page.dart`
  (`942` lines), and `address_book_page.dart` (`940` lines).
- 2026-05-31: Split `wallet_transfer_sections.dart` to a `46` line part
  facade. New files: `wallet_transfer_confirm_sheet.dart` (`225` lines),
  `wallet_transfer_wallet_cards.dart` (`148` lines),
  `wallet_transfer_asset_amount.dart` (`289` lines), and
  `wallet_transfer_history_picker.dart` (`249` lines).
- 2026-05-31: Split `dust_converter_page.dart` from `942` to `284` lines.
  New files: `wallet_dust_converter_hero.dart` (`157` lines),
  `wallet_dust_converter_targets.dart` (`160` lines),
  `wallet_dust_converter_assets.dart` (`140` lines), and
  `wallet_dust_converter_confirm.dart` (`214` lines).
- 2026-05-31: Split `address_book_page.dart` from `940` to `235` lines.
  New files: `wallet_address_book_controls.dart` (`217` lines),
  `wallet_address_book_security.dart` (`154` lines), and
  `wallet_address_book_list.dart` (`344` lines).
- 2026-05-31: `dart format` over the `14` touched Wallet Dart files passed
  (`11` changed).
- 2026-05-31: Direct grep
  `rg -n "features/.*/data|\bColors\."` over touched Wallet source returned no
  matches.
- 2026-05-31: `flutter test test/features/wallet --reporter=compact` passed
  (`66` tests).
- 2026-05-31: `flutter test test/quality/accessibility_semantics_critical_flows_test.dart --reporter=compact`
  passed (`6` tests).
- 2026-05-31: `flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact`
  passed (`13` tests).
- 2026-05-31: `flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact`
  passed (`10` tests).
- 2026-05-31: `flutter analyze` passed (`No issues found!`).

### E900-03 - P2P safety and wallet

Status: `[x]`

Files:

| File | Current lines | Target |
| --- | ---: | ---: |
| `flutter_app/lib/features/p2p/presentation/pages/p2p_blacklist_page.dart` | `993` | `<500` |
| `flutter_app/lib/features/p2p/presentation/pages/p2p_wallet_page.dart` | `991` | `<500` |
| `flutter_app/lib/features/p2p/presentation/pages/p2p_fraud_prevention_page.dart` | `921` | `<500` |
| `flutter_app/lib/features/p2p/presentation/pages/p2p_login_history_page.dart` | `905` | `<500` |

Split `p2p_blacklist_page.dart`:

| Target file | Move classes/sections |
| --- | --- |
| `p2p_blacklist_summary_filters.dart` | `_AddButton`, `_SummaryCard`, `_FilterRail`, `_FilterChip` |
| `p2p_blacklist_entries.dart` | `_EntryList`, `_EntryCard`, `_ExpandedEntry`, `_Avatar`, `_OrderLink` |
| `p2p_blacklist_common.dart` | `_InfoNote`, `_ReasonCountPill`, `_SmallReasonPill`, `_ReasonIconBubble`, `_TinyStat` |

Split `p2p_wallet_page.dart`:

| Target file | Move classes/sections |
| --- | --- |
| `p2p_wallet_hero.dart` | `_HeaderHistoryButton`, `_WalletHero`, `_HeroActionButton`, `_WalletInfoBanner` |
| `p2p_wallet_balances.dart` | `_BalanceSection`, `_BalanceCard`, `_AssetMark`, `_BalanceBreakdown`, `_BreakdownItem` |
| `p2p_wallet_actions_history.dart` | `_InlineActionButton`, `_EscrowDetailButton`, `_RecentTransactions`, `_TransactionRow` |

Split `p2p_fraud_prevention_page.dart`:

| Target file | Move classes/sections |
| --- | --- |
| `p2p_fraud_score_patterns.dart` | `_SafetyScoreCard`, `_PatternSection`, `_PatternCard`, `_ExpandedPattern`, `_DetailList` |
| `p2p_fraud_checklist_actions.dart` | `_ChecklistCard`, `_CategoryTab`, `_ChecklistItem`, `_EmergencyActions`, `_EmergencyButton` |
| `p2p_fraud_common.dart` | `_Disclosure`, `_SeverityBadge` |

Split `p2p_login_history_page.dart`:

| Target file | Move classes/sections |
| --- | --- |
| `p2p_login_history_summary_filters.dart` | `_DownloadButton`, `_LoginStats`, `_StatTile`, `_FilterTabs`, `_FilterPill`, `_RiskWarning` |
| `p2p_login_history_events.dart` | `_LoginEventList`, `_LoginEventCard`, `_EventIcon`, `_EventMainInfo`, `_EventTrailing`, `_ExpandedDetails` |
| `p2p_login_history_common.dart` | `_StatusBadge`, `_DetailValue`, `_InlineMeta`, `_SmallBadge`, `_SecurityInfo`, `_EmptyState` |

Verification:

```bash
flutter test test/features/p2p --reporter=compact
flutter test test/quality/accessibility_semantics_critical_flows_test.dart --reporter=compact
flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact
flutter analyze
```

Verification log:

- 2026-05-31: GitNexus Dart analysis remained unavailable from the E900
  preflight (`tree-sitter-dart` skipped, later CLI commands failed with
  `Cannot destructure property 'package' of 'node.target' as it is null`).
  Used `rg` for imports/symbols/blast radius plus Flutter tests and analyzer.
- 2026-05-31: Large-file scan before E900-03 showed P2P targets at
  `p2p_blacklist_page.dart` (`993` lines), `p2p_wallet_page.dart`
  (`991` lines), `p2p_fraud_prevention_page.dart` (`921` lines), and
  `p2p_login_history_page.dart` (`905` lines).
- 2026-05-31: Split `p2p_blacklist_page.dart` from `993` to `200` lines.
  New files: `p2p_blacklist_summary_filters.dart` (`198` lines),
  `p2p_blacklist_entries.dart` (`357` lines), and
  `p2p_blacklist_common.dart` (`248` lines).
- 2026-05-31: Split `p2p_wallet_page.dart` from `991` to `138` lines.
  New files: `p2p_wallet_hero.dart` (`217` lines),
  `p2p_wallet_balances.dart` (`290` lines), and
  `p2p_wallet_actions_history.dart` (`356` lines).
- 2026-05-31: Split `p2p_fraud_prevention_page.dart` from `921` to `153`
  lines. New files: `p2p_fraud_score_patterns.dart` (`355` lines),
  `p2p_fraud_checklist_actions.dart` (`293` lines), and
  `p2p_fraud_common.dart` (`130` lines).
- 2026-05-31: Split `p2p_login_history_page.dart` from `905` to `154`
  lines. New files: `p2p_login_history_summary_filters.dart` (`247` lines),
  `p2p_login_history_events.dart` (`274` lines), and
  `p2p_login_history_common.dart` (`240` lines).
- 2026-05-31: `dart format` over the `16` touched P2P Dart files passed
  (`12` changed).
- 2026-05-31: Direct grep
  `rg -n "features/.*/data|\bColors\."` over touched P2P source returned no
  matches.
- 2026-05-31: `flutter test test/features/p2p --reporter=compact` passed
  (`311` tests).
- 2026-05-31: `flutter test test/quality/accessibility_semantics_critical_flows_test.dart --reporter=compact`
  passed (`6` tests).
- 2026-05-31: `flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact`
  initially failed because the guardrail only scanned `p2p_wallet_page.dart`
  after locked safety copy moved to widget parts. Updated the guardrail to scan
  `p2p_wallet_hero.dart`, `p2p_wallet_balances.dart`, and
  `p2p_wallet_actions_history.dart`; rerun passed (`13` tests).
- 2026-05-31: `flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact`
  passed (`10` tests).
- 2026-05-31: `flutter analyze` passed (`No issues found!`).

### E900-04 - Trade risk, security, tax, audit

Status: `[x]`

Files:

| File | Current lines | Target |
| --- | ---: | ---: |
| `flutter_app/lib/features/trade/presentation/pages/bot_risk_dashboard_page.dart` | `992` | `<500` |
| `flutter_app/lib/features/trade/presentation/pages/performance_attribution_page.dart` | `991` | `<500` |
| `flutter_app/lib/features/trade/presentation/pages/copy_audit_log_page.dart` | `985` | `<500` |
| `flutter_app/lib/features/trade/presentation/pages/bot_tax_reporting_page.dart` | `985` | `<500` |
| `flutter_app/lib/features/trade/presentation/pages/bot_security_settings_page.dart` | `907` | `<500` |

Split `bot_risk_dashboard_page.dart`:

| Target file | Move classes/sections |
| --- | --- |
| `bot_risk_dashboard_score.dart` | `_HeaderEmergencyButton`, `_RiskScoreCard`, `_RiskRingPainter` |
| `bot_risk_dashboard_metrics.dart` | `_CriticalMetricsGrid`, `_MetricData`, `_MetricCard`, `_ExposureCard`, `_ProgressTrack` |
| `bot_risk_dashboard_charts.dart` | `_DrawdownChartCard`, `_VarChartCard`, `_DrawdownChartPainter`, `_VarChartPainter` |
| `bot_risk_dashboard_controls.dart` | `_SafetyControlsCard`, `_EmergencyActionCard`, `_RiskExplanationCard`, `_SectionLabel`, `_Card` |

Split `performance_attribution_page.dart`:

| Target file | Move classes/sections |
| --- | --- |
| `performance_attribution_summary_tabs.dart` | `_SummaryGrid`, `_MetricTile`, `_AttributionTabs`, `_AttributionTab` |
| `performance_attribution_tabs.dart` | `_DrawdownTab`, `_ProjectionTab`, `_CorrelationTab`, `_InfoPanel`, `_ContributionBar`, `_ProjectionTile`, `_KeyValueRow` |
| `performance_attribution_painters.dart` | `_ReturnDecompositionPainter`, `_DrawdownPainter`, `_ProjectionPainter`, `_CorrelationPainter`, `_LegendItem`, `_LegendRow` |
| `performance_attribution_common.dart` | `_SectionLabel`, `_NoticePanel` |

Split `copy_audit_log_page.dart`:

| Target file | Move classes/sections |
| --- | --- |
| `copy_audit_log_controls.dart` | `_ExportHeaderButton`, `_ComplianceNotice`, `_AuditSearchField`, `_AuditFilterTabs`, `_AuditFilterPill` |
| `copy_audit_log_events.dart` | `_AuditEventCard`, `_EventMetaRow`, `_TypeBadge`, `_EventMetadataPanel`, `_MetadataValue`, `_EmptyAuditState` |
| `copy_audit_log_summary.dart` | `_SummarySection`, `_SummaryCard`, `_ExportFormatButton` |

Split `bot_tax_reporting_page.dart`:

| Target file | Move classes/sections |
| --- | --- |
| `bot_tax_reporting_notice_year.dart` | `_TaxNotice`, `_YearPicker` |
| `bot_tax_reporting_summary.dart` | `_SummaryCard`, `_SummaryStat`, `_CostBasisPicker` |
| `bot_tax_reporting_reports.dart` | `_ReportTypeCard`, `_BreakdownCard`, `_BreakdownRow`, `_TaxNotesCard`, `_GenerateFooter` |
| `bot_tax_reporting_common.dart` | `_RadioDot`, `_CheckBox`, `_Pill`, `_Card`, `_SectionLabel` |

Split `bot_security_settings_page.dart`:

| Target file | Move classes/sections |
| --- | --- |
| `bot_security_settings_cards.dart` | `_TwoFaCard`, `_ApiKeyCard`, `_IpCard`, `_ActivityCard`, `_SecurityTipsCard` |
| `bot_security_settings_common.dart` | `_DashedActionButton`, `_Switch`, `_Card`, `_SectionLabel`, `_DashedBorderPainter` |
| `bot_security_settings_sheets.dart` | `_ApiKeySheet`, `_ApiKeySheetState`, `_IpSheet`, `_SheetInput`, `_PermissionChip` |

Verification:

```bash
flutter test test/features/trade --reporter=compact
flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact
flutter analyze
```

Verification log:

- 2026-05-31: GitNexus Dart analysis remained unavailable from the E900
  preflight (`tree-sitter-dart` skipped, later CLI commands failed with
  `Cannot destructure property 'package' of 'node.target' as it is null`).
  Used `rg` for imports/symbols/blast radius plus Flutter tests and analyzer.
- 2026-05-31: Large-file scan before E900-04 showed Trade targets at
  `bot_risk_dashboard_page.dart` (`992` lines),
  `performance_attribution_page.dart` (`991` lines),
  `copy_audit_log_page.dart` (`985` lines),
  `bot_tax_reporting_page.dart` (`985` lines), and
  `bot_security_settings_page.dart` (`907` lines).
- 2026-05-31: Split `bot_risk_dashboard_page.dart` from `992` to `116`
  lines. New files: `bot_risk_dashboard_score.dart` (`163` lines),
  `bot_risk_dashboard_metrics.dart` (`239` lines),
  `bot_risk_dashboard_charts.dart` (`197` lines), and
  `bot_risk_dashboard_controls.dart` (`290` lines).
- 2026-05-31: Split `performance_attribution_page.dart` from `991` to `111`
  lines. New files: `performance_attribution_summary_tabs.dart` (`207`
  lines), `performance_attribution_tabs.dart` (`339` lines),
  `performance_attribution_painters.dart` (`291` lines), and
  `performance_attribution_common.dart` (`56` lines).
- 2026-05-31: Split `copy_audit_log_page.dart` from `985` to `240` lines.
  New files: `copy_audit_log_controls.dart` (`216` lines),
  `copy_audit_log_events.dart` (`292` lines), and
  `copy_audit_log_summary.dart` (`247` lines).
- 2026-05-31: Split `bot_tax_reporting_page.dart` from `985` to `187`
  lines. New files: `bot_tax_reporting_notice_year.dart` (`115` lines),
  `bot_tax_reporting_summary.dart` (`206` lines),
  `bot_tax_reporting_reports.dart` (`325` lines), and
  `bot_tax_reporting_common.dart` (`165` lines).
- 2026-05-31: Split `bot_security_settings_page.dart` from `907` to `175`
  lines. New files: `bot_security_settings_cards.dart` (`317` lines),
  `bot_security_settings_common.dart` (`164` lines), and
  `bot_security_settings_sheets.dart` (`261` lines).
- 2026-05-31: `dart format` over the `23` touched Trade Dart files passed
  (`18` changed).
- 2026-05-31: Direct grep
  `rg -n "features/.*/data|\bColors\."` over touched Trade source returned no
  matches.
- 2026-05-31: `flutter test test/features/trade --reporter=compact` passed
  (`343` tests).
- 2026-05-31: `flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact`
  passed (`13` tests).
- 2026-05-31: `flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact`
  passed (`10` tests).
- 2026-05-31: `flutter analyze` passed (`No issues found!`).

### E900-05 - Trade copy/provider/guide/disclosure

Status: `[x]`

Files:

| File | Current lines | Target |
| --- | ---: | ---: |
| `flutter_app/lib/features/trade/presentation/pages/bot_guide_page.dart` | `983` | `<500` |
| `flutter_app/lib/features/trade/presentation/pages/copy_trading_page.dart` | `934` | `<500` |
| `flutter_app/lib/features/trade/presentation/pages/provider_application_page.dart` | `932` | `<500` |
| `flutter_app/lib/features/trade/presentation/pages/regulatory_disclosures_page.dart` | `909` | `<500` |

Split `bot_guide_page.dart`:

| Target file | Move classes/sections |
| --- | --- |
| `bot_guide_intro_tabs.dart` | `_IntroBanner`, `_Tabs` |
| `bot_guide_strategies.dart` | `_StrategiesView`, `_StrategyCard`, `_DifficultyBadge`, `_StrategyDetails` |
| `bot_guide_blocks.dart` | `_StepsBlock`, `_BulletsBlock`, `_BestForBlock`, `_ExampleBlock` |
| `bot_guide_practices_videos.dart` | `_BestPracticesView`, `_MistakesView`, `_InfoCard`, `_MistakeCard`, `_VideoTutorialsCard` |
| `bot_guide_common.dart` | `_SectionLabel`, `_Card` |

Split `copy_trading_page.dart`:

| Target file | Move classes/sections |
| --- | --- |
| `copy_trading_hero.dart` | `_CopyHeroCard`, `_HeroMetric`, `_TrendPill`, `_RiskWarningCard` |
| `copy_trading_list.dart` | `_SortChips`, `_SortChip`, `_TraderCard`, `_AvatarBadge`, `_RoiBlock`, `_DetailsButton` |
| `copy_trading_metrics_common.dart` | `_MetricsGrid`, `_MetricCell`, `_WeeklyChart`, `_MiniBadge`, `_Disclaimer`, `_Panel`, `_TierStyle`, `_RiskStyle` |

Split `provider_application_page.dart`:

| Target file | Move classes/sections |
| --- | --- |
| `provider_application_progress_intro.dart` | `_ProgressBars`, `_IntroStep`, `_BenefitCard`, `_ResponsibilitiesCard`, `_RequirementPreview` |
| `provider_application_steps.dart` | `_RequirementsStep`, `_DisclosureStep`, `_FeesStep`, `_ReviewStep`, `_FooterButton` |
| `provider_application_common.dart` | `_SectionLabel`, `_StepTitle`, `_TogglePanel`, `_NumberPanel`, `_ConsentTile`, `_InfoPanel`, `_Panel`, `_PanelHeader` |

Split `regulatory_disclosures_page.dart`:

| Target file | Move classes/sections |
| --- | --- |
| `regulatory_disclosures_hero_tabs.dart` | `_LegalHero`, `_LegalTabs`, `_LegalTabBody` |
| `regulatory_disclosures_tabs.dart` | `_MifidTab`, `_ProtectionTab`, `_RestrictionsTab`, `_LiabilityTab`, `_ContactTab` |
| `regulatory_disclosures_common.dart` | `_SectionLabel`, `_DisclosureCard`, `_CommitmentCard`, `_WarningList`, `_LeverageRules`, `_ActionTile`, `_ContactTile`, `_DocumentTile`, `_RegulatoryNoticePanel` |

Verification:

```bash
flutter test test/features/trade --reporter=compact
flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact
flutter analyze
```

Verification log:

- 2026-05-31: GitNexus Dart analysis remained unavailable from the E900
  preflight (`tree-sitter-dart` skipped, later CLI commands failed with
  `Cannot destructure property 'package' of 'node.target' as it is null`).
  Used `rg` for imports/symbols/blast radius plus Flutter tests and analyzer.
- 2026-05-31: Large-file scan before E900-05 showed targets at
  `bot_guide_page.dart` (`983` lines), `copy_trading_page.dart` (`934`
  lines), `provider_application_page.dart` (`932` lines), and
  `regulatory_disclosures_page.dart` (`909` lines).
- 2026-05-31: Split `bot_guide_page.dart` from `983` to `119` lines. New
  files: `bot_guide_intro_tabs.dart` (`110` lines),
  `bot_guide_strategies.dart` (`212` lines), `bot_guide_blocks.dart` (`233`
  lines), `bot_guide_practices_videos.dart` (`256` lines), and
  `bot_guide_common.dart` (`69` lines).
- 2026-05-31: Split `copy_trading_page.dart` from `934` to `121` lines. New
  files: `copy_trading_hero.dart` (`242` lines), `copy_trading_list.dart`
  (`308` lines), and `copy_trading_metrics_common.dart` (`273` lines).
- 2026-05-31: Split `provider_application_page.dart` from `932` to `195`
  lines. New files: `provider_application_progress_intro.dart` (`235` lines),
  `provider_application_steps.dart` (`203` lines), and
  `provider_application_common.dart` (`309` lines).
- 2026-05-31: Split `regulatory_disclosures_page.dart` from `909` to `112`
  lines. New files: `regulatory_disclosures_hero_tabs.dart` (`155` lines),
  `regulatory_disclosures_tabs.dart` (`166` lines), and
  `regulatory_disclosures_common.dart` (`486` lines).
- 2026-05-31: Updated `product_copy_guardrails_test.dart` so Trade copy
  safety scanning includes the new `copy_trading_*` widget parts.
- 2026-05-31: `dart format` over touched E900-05 Dart files and the product
  copy guardrail passed (`19` files, `14` changed).
- 2026-05-31: Direct grep
  `rg -n "features/.*/data|\bColors\."` over touched Trade source returned no
  matches.
- 2026-05-31: `flutter test test/features/trade --reporter=compact` passed
  (`343` tests).
- 2026-05-31: `flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact`
  passed (`13` tests).
- 2026-05-31: `flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact`
  passed (`10` tests).
- 2026-05-31: `flutter analyze` passed (`No issues found!`).

### E900-06 - Predictions tournaments, market maker, calendar

Status: `[x]`

Files:

| File | Current lines | Target |
| --- | ---: | ---: |
| `flutter_app/lib/features/predictions/presentation/pages/prediction_tournaments_page.dart` | `978` | `<500` |
| `flutter_app/lib/features/predictions/presentation/pages/prediction_market_maker_page.dart` | `967` | `<500` |
| `flutter_app/lib/features/predictions/presentation/pages/prediction_event_calendar_page.dart` | `911` | `<500` |

Split `prediction_tournaments_page.dart`:

| Target file | Move classes/sections |
| --- | --- |
| `prediction_tournaments_detail.dart` | `PredictionTournamentDetailPage`, `_TournamentDetailHero` |
| `prediction_tournaments_list.dart` | `_TournamentTabBar`, `_FeaturedTournamentBlock`, `_TournamentSection`, `_TournamentCard` |
| `prediction_tournaments_stats.dart` | `_TournamentStatsGrid`, `_StatCell`, `_StatusPill`, `_CategoryChip`, `_TournamentInfoCard`, `_MyTournamentStats`, `_CenteredMetric` |
| `prediction_tournaments_empty_leaderboard.dart` | `_EmptyTournamentsCard`, `_NoPastTournamentsCard`, `_EmptyStateCard`, `_FinalLeaderboard`, `_LeaderboardEntryCard` |

Split `prediction_market_maker_page.dart`:

| Target file | Move classes/sections |
| --- | --- |
| `prediction_market_maker_provide.dart` | `_MarketMakerTabBar`, `_LiquidityOverview`, `_AddLiquidityForm`, `_MarketInput`, `_SpreadSelector`, `_SpreadButton` |
| `prediction_market_maker_returns.dart` | `_EstimatedReturns`, `_AddLiquidityButton`, `_LiquidityWarning` |
| `prediction_market_maker_positions.dart` | `_PositionsTab`, `_PositionSummary`, `_PositionCard` |
| `prediction_market_maker_earnings.dart` | `_EarningsTab`, `_FeeBar`, `_OverviewMetric`, `_AnalysisRow` |

Split `prediction_event_calendar_page.dart`:

| Target file | Move classes/sections |
| --- | --- |
| `prediction_event_calendar_controls.dart` | `_FilterButton`, `_EventCalendarTabBar`, `_CategoryFilters`, `_CategoryChip` |
| `prediction_event_calendar_events.dart` | `_StatsCard`, `_MonthSection`, `_CalendarEventCard`, `_UpcomingSection` |
| `prediction_event_calendar_notifications.dart` | `_NotificationSettings`, `_WatchingSection`, `_NotificationInfo`, `_NotificationSettingRow`, `_TogglePill`, `_StatCell`, `_EventMetric` |

Verification:

```bash
flutter test test/features/predictions --reporter=compact
flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact
flutter analyze
```

Verification log:

- 2026-05-31: GitNexus Dart analysis remained unavailable from the E900
  preflight (`tree-sitter-dart` skipped, later CLI commands failed with
  `Cannot destructure property 'package' of 'node.target' as it is null`).
  Used `rg` for imports/symbols/blast radius plus Flutter tests and analyzer.
- 2026-05-31: Large-file scan before E900-06 showed targets at
  `prediction_tournaments_page.dart` (`978` lines),
  `prediction_market_maker_page.dart` (`967` lines), and
  `prediction_event_calendar_page.dart` (`911` lines).
- 2026-05-31: Split `prediction_tournaments_page.dart` from `978` to `136`
  lines while keeping `PredictionTournamentDetailPage` public through the same
  library facade. New files: `prediction_tournaments_detail.dart` (`160`
  lines), `prediction_tournaments_list.dart` (`268` lines),
  `prediction_tournaments_stats.dart` (`250` lines), and
  `prediction_tournaments_empty_leaderboard.dart` (`177` lines).
- 2026-05-31: Split `prediction_market_maker_page.dart` from `967` to `154`
  lines. New files: `prediction_market_maker_provide.dart` (`381` lines),
  `prediction_market_maker_returns.dart` (`112` lines),
  `prediction_market_maker_positions.dart` (`135` lines), and
  `prediction_market_maker_earnings.dart` (`198` lines).
- 2026-05-31: Split `prediction_event_calendar_page.dart` from `911` to `130`
  lines. New files: `prediction_event_calendar_controls.dart` (`190` lines),
  `prediction_event_calendar_events.dart` (`219` lines), and
  `prediction_event_calendar_notifications.dart` (`382` lines).
- 2026-05-31: `dart format` over the `14` touched Prediction Dart files
  passed (`11` changed).
- 2026-05-31: Direct grep
  `rg -n "features/.*/data|\bColors\."` over touched Prediction source
  returned no matches.
- 2026-05-31: `flutter test test/features/predictions --reporter=compact`
  passed (`85` tests).
- 2026-05-31: `flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact`
  passed (`13` tests).
- 2026-05-31: `flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact`
  passed (`10` tests).
- 2026-05-31: `flutter analyze` passed (`No issues found!`).

### E900-07 - Arena studio

Status: `[x]`

Files:

| File | Current lines | Target |
| --- | ---: | ---: |
| `flutter_app/lib/features/arena/presentation/pages/arena_studio_page.dart` | `961` | `<500` |

Extract to widgets:

| Target file | Move classes/sections |
| --- | --- |
| `arena_studio_stepper.dart` | `_StudioStepper`, `_StepMarker` |
| `arena_studio_fee_banner.dart` | `_PlatformFeeBanner`, `_PlatformFeeBannerState`, `_FeeDetailRow` |
| `arena_studio_steps.dart` | `_StepBody`, `_TemplateStep`, `_TemplateCard`, `_CommunityRulesFooter` |
| `arena_studio_footer.dart` | `_StickyStudioFooter`, `_FooterToolButton` |

Verification:

```bash
flutter test test/features/arena --reporter=compact
flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact
flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact
flutter analyze
```

Verification log:

- 2026-06-01: GitNexus Dart analysis remained unavailable from the E900
  preflight (`tree-sitter-dart` skipped, later CLI commands failed with
  `Cannot destructure property 'package' of 'node.target' as it is null`).
  Used `rg` for imports/symbols/blast radius plus Flutter tests and analyzer.
- 2026-06-01: Large-file scan before E900-07 showed
  `arena_studio_page.dart` at `961` lines.
- 2026-06-01: Split `arena_studio_page.dart` from `961` to `182` lines.
  New files: `arena_studio_stepper.dart` (`103` lines),
  `arena_studio_fee_banner.dart` (`179` lines), `arena_studio_steps.dart`
  (`345` lines), and `arena_studio_footer.dart` (`161` lines).
- 2026-06-01: `dart format` over the `5` touched Arena Dart files passed
  (`4` changed).
- 2026-06-01: Direct grep
  `rg -n "features/.*/data|\bColors\."` over touched Arena source returned no
  matches.
- 2026-06-01: `flutter test test/features/arena --reporter=compact` passed
  (`111` tests).
- 2026-06-01: `flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact`
  passed (`13` tests).
- 2026-06-01: `flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact`
  passed (`10` tests).
- 2026-06-01: `flutter analyze` passed (`No issues found!`).

### E900-08 - Launchpad operational pages

Status: `[x]`

Files:

| File | Current lines | Target |
| --- | ---: | ---: |
| `flutter_app/lib/features/launchpad/presentation/pages/launchpad_risk_analytics_page.dart` | `999` | `<500` |
| `flutter_app/lib/features/launchpad/presentation/pages/launchpad_batch_claim_page.dart` | `919` | `<500` |
| `flutter_app/lib/features/launchpad/presentation/pages/launchpad_performance_page.dart` | `916` | `<500` |
| `flutter_app/lib/features/launchpad/presentation/pages/launchpad_address_book_page.dart` | `909` | `<500` |

Suggested splits:

| Source file | Target files |
| --- | --- |
| `launchpad_risk_analytics_page.dart` | `launchpad_risk_tabs_overview.dart`, `launchpad_risk_due_diligence.dart`, `launchpad_risk_report_common.dart`, `launchpad_risk_painter.dart` |
| `launchpad_batch_claim_page.dart` | `launchpad_batch_claim_summary.dart`, `launchpad_batch_claim_selection.dart`, `launchpad_batch_claim_review_success.dart` |
| `launchpad_performance_page.dart` | `launchpad_performance_overview.dart`, `launchpad_performance_projects.dart`, `launchpad_performance_chart_common.dart` |
| `launchpad_address_book_page.dart` | `launchpad_address_book_controls.dart`, `launchpad_address_book_cards.dart`, `launchpad_address_book_sheet_common.dart` |

Verification:

```bash
flutter test test/features/launchpad --reporter=compact
flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact
flutter analyze
```

Verification log:

- 2026-06-01: GitNexus Dart analysis remained unavailable from the E900
  preflight (`tree-sitter-dart` skipped, later CLI commands failed with
  `Cannot destructure property 'package' of 'node.target' as it is null`).
  Used `rg` for imports/symbols/blast radius plus Flutter tests and analyzer.
- 2026-06-01: Large-file scan before E900-08 showed
  `launchpad_risk_analytics_page.dart` (`999` lines),
  `launchpad_batch_claim_page.dart` (`919` lines),
  `launchpad_performance_page.dart` (`916` lines), and
  `launchpad_address_book_page.dart` (`909` lines).
- 2026-06-01: Split `launchpad_risk_analytics_page.dart` from `999` to
  `120` lines. New files: `launchpad_risk_tabs_overview.dart` (`298`
  lines), `launchpad_risk_painter.dart` (`102` lines),
  `launchpad_risk_due_diligence.dart` (`158` lines), and
  `launchpad_risk_report_common.dart` (`329` lines).
- 2026-06-01: Split `launchpad_batch_claim_page.dart` from `919` to `186`
  lines. New files: `launchpad_batch_claim_summary.dart` (`178` lines),
  `launchpad_batch_claim_selection.dart` (`318` lines), and
  `launchpad_batch_claim_review_success.dart` (`243` lines).
- 2026-06-01: Split `launchpad_performance_page.dart` from `916` to `110`
  lines. New files: `launchpad_performance_overview.dart` (`374` lines),
  `launchpad_performance_projects.dart` (`209` lines), and
  `launchpad_performance_chart_common.dart` (`229` lines).
- 2026-06-01: Split `launchpad_address_book_page.dart` from `909` to `254`
  lines. New files: `launchpad_address_book_controls.dart` (`153` lines),
  `launchpad_address_book_cards.dart` (`211` lines), and
  `launchpad_address_book_sheet_common.dart` (`297` lines).
- 2026-06-01: `dart format` over the `17` touched Launchpad Dart files
  passed after completing the mechanical split.
- 2026-06-01: Direct grep
  `rg -n "features/.*/data|\bColors\."` over touched Launchpad source
  returned no matches.
- 2026-06-01: `flutter test test/features/launchpad --reporter=compact`
  passed (`121` tests).
- 2026-06-01: `flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact`
  passed (`10` tests).
- 2026-06-01: `flutter analyze` passed (`No issues found!`).

### E900-09 - Earn savings and staking pages

Status: `[x]`

Files:

| File | Current lines | Target |
| --- | ---: | ---: |
| `flutter_app/lib/features/earn/presentation/pages/savings_dca_page.dart` | `973` | `<500` |
| `flutter_app/lib/features/earn/presentation/pages/savings_page.dart` | `971` | `<500` |
| `flutter_app/lib/features/earn/presentation/pages/staking_earnings_calendar_page.dart` | `954` | `<500` |
| `flutter_app/lib/features/earn/presentation/pages/staking_history_page.dart` | `924` | `<500` |
| `flutter_app/lib/features/earn/presentation/pages/staking_earn_page.dart` | `916` | `<500` |

Suggested splits:

| Source file | Target files |
| --- | --- |
| `savings_dca_page.dart` | `savings_dca_summary.dart`, `savings_dca_plans.dart`, `savings_dca_history_sheet.dart`, `savings_dca_common.dart` |
| `savings_page.dart` | `savings_home_hero.dart`, `savings_home_products.dart`, `savings_home_positions.dart`, `savings_home_common.dart` |
| `staking_earnings_calendar_page.dart` | `staking_earnings_summary_tabs.dart`, `staking_earnings_calendar_grid.dart`, `staking_earnings_events_common.dart` |
| `staking_history_page.dart` | `staking_history_summary_filters.dart`, `staking_history_detail_list.dart`, `staking_history_common.dart` |
| `staking_earn_page.dart` | `staking_earn_hero_tabs.dart`, `staking_earn_products.dart`, `staking_earn_positions_common.dart` |

Verification:

```bash
flutter test test/features/earn --reporter=compact
flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact
flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact
flutter analyze
```

Verification log:

- 2026-06-01: GitNexus Dart analysis remained unavailable from the E900
  preflight (`tree-sitter-dart` skipped, later CLI commands failed with
  `Cannot destructure property 'package' of 'node.target' as it is null`).
  Used `rg` for imports/symbols/blast radius plus Flutter tests and analyzer.
- 2026-06-01: Large-file scan before E900-09 showed
  `savings_dca_page.dart` (`973` lines), `savings_page.dart` (`971` lines),
  `staking_earnings_calendar_page.dart` (`954` lines),
  `staking_history_page.dart` (`924` lines), and `staking_earn_page.dart`
  (`916` lines).
- 2026-06-01: Split `savings_dca_page.dart` from `973` to `134` lines.
  New files: `savings_dca_summary.dart` (`326` lines),
  `savings_dca_plans.dart` (`248` lines), `savings_dca_history_sheet.dart`
  (`180` lines), and `savings_dca_common.dart` (`93` lines).
- 2026-06-01: Split `savings_page.dart` from `971` to `126` lines. New
  files: `savings_home_hero.dart` (`287` lines),
  `savings_home_products.dart` (`285` lines), `savings_home_positions.dart`
  (`209` lines), and `savings_home_common.dart` (`72` lines).
- 2026-06-01: Split `staking_earnings_calendar_page.dart` from `954` to
  `160` lines. New files: `staking_earnings_summary_tabs.dart` (`166`
  lines), `staking_earnings_calendar_grid.dart` (`284` lines), and
  `staking_earnings_events_common.dart` (`350` lines).
- 2026-06-01: Split `staking_history_page.dart` from `924` to `188` lines.
  New files: `staking_history_summary_filters.dart` (`372` lines),
  `staking_history_detail_list.dart` (`288` lines), and
  `staking_history_common.dart` (`82` lines).
- 2026-06-01: Split `staking_earn_page.dart` from `916` to `114` lines.
  New files: `staking_earn_hero_tabs.dart` (`274` lines),
  `staking_earn_products.dart` (`149` lines), and
  `staking_earn_positions_common.dart` (`385` lines).
- 2026-06-01: `dart format` over the `22` touched Earn Dart files passed
  (`5` changed).
- 2026-06-01: Direct grep
  `rg -n "features/.*/data|\bColors\."` over touched Earn source returned no
  matches.
- 2026-06-01: `flutter test test/features/earn --reporter=compact` passed
  (`354` tests).
- 2026-06-01: `flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact`
  passed (`13` tests).
- 2026-06-01: `flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact`
  passed (`10` tests).
- 2026-06-01: `flutter analyze` passed (`No issues found!`).

### E900-10 - Markets movers and screener

Status: `[x]`

Files:

| File | Current lines | Target |
| --- | ---: | ---: |
| `flutter_app/lib/features/markets/presentation/pages/market_movers_page.dart` | `987` | `<500` |
| `flutter_app/lib/features/markets/presentation/pages/market_screener_page.dart` | `970` | `<500` |

Suggested splits:

| Source file | Target files |
| --- | --- |
| `market_movers_page.dart` | `market_movers_filters.dart`, `market_movers_results.dart`, `market_movers_row_common.dart`, `market_movers_sparkline.dart` |
| `market_screener_page.dart` | `market_screener_filters.dart`, `market_screener_results.dart`, `market_screener_row_common.dart`, `market_screener_sparkline.dart` |

Verification:

```bash
flutter test test/features/markets --reporter=compact
flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact
flutter analyze
```

Verification log:

- 2026-06-01: GitNexus Dart analysis remained unavailable from the E900
  preflight (`tree-sitter-dart` skipped, later CLI commands failed with
  `Cannot destructure property 'package' of 'node.target' as it is null`).
  Used `rg` for imports/symbols/blast radius plus Flutter tests and analyzer.
- 2026-06-01: Large-file scan before E900-10 showed
  `market_movers_page.dart` (`987` lines) and `market_screener_page.dart`
  (`970` lines).
- 2026-06-01: Split `market_movers_page.dart` from `987` to `244` lines.
  New files: `market_movers_filters.dart` (`331` lines),
  `market_movers_results.dart` (`37` lines),
  `market_movers_row_common.dart` (`281` lines), and
  `market_movers_sparkline.dart` (`102` lines).
- 2026-06-01: Split `market_screener_page.dart` from `970` to `233` lines.
  New files: `market_screener_filters.dart` (`439` lines),
  `market_screener_results.dart` (`191` lines),
  `market_screener_row_common.dart` (`66` lines), and
  `market_screener_sparkline.dart` (`49` lines).
- 2026-06-01: `dart format` over the `10` touched Markets Dart files passed
  (`3` changed).
- 2026-06-01: Direct grep
  `rg -n "features/.*/data|\bColors\."` over touched Markets source returned
  no matches.
- 2026-06-01: `flutter test test/features/markets --reporter=compact` passed
  (`124` tests).
- 2026-06-01: `flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact`
  passed (`10` tests).
- 2026-06-01: `flutter analyze` passed (`No issues found!`).

### E900-11 - Profile page

Status: `[x]`

Files:

| File | Current lines | Target |
| --- | ---: | ---: |
| `flutter_app/lib/features/profile/presentation/pages/profile_page.dart` | `1000` | `<500` |

Extract to widgets:

| Target file | Move classes/sections |
| --- | --- |
| `profile_home_hero.dart` | `_ProfileHero`, `_HeroPill`, `_HeroInfoBox` |
| `profile_home_vip_prediction.dart` | `_VipCard`, `_PredictionCard` |
| `profile_home_arena_stats.dart` | `_ArenaCard`, `_ModuleStat`, `_TinyTag` |
| `profile_home_menu_actions.dart` | `_MenuSection`, `_MenuRow`, `_ActivityButton`, `_LogoutButton`, `_SectionLabel` |

Verification:

```bash
flutter test test/features/profile --reporter=compact
flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact
flutter analyze
```

Verification log:

- 2026-06-01: GitNexus Dart analysis remained unavailable from the E900
  preflight (`tree-sitter-dart` skipped, later CLI commands failed with
  `Cannot destructure property 'package' of 'node.target' as it is null`).
  Used `rg` for imports/symbols/blast radius plus Flutter tests and analyzer.
- 2026-06-01: Large-file scan before E900-11 showed `profile_page.dart` at
  `1000` lines.
- 2026-06-01: Split `profile_page.dart` from `1000` to `137` lines. New
  files: `profile_home_hero.dart` (`251` lines),
  `profile_home_vip_prediction.dart` (`194` lines),
  `profile_home_arena_stats.dart` (`193` lines), and
  `profile_home_menu_actions.dart` (`233` lines).
- 2026-06-01: `dart format` over the `5` touched Profile Dart files passed
  (`1` changed).
- 2026-06-01: Direct grep
  `rg -n "features/.*/data|\bColors\."` over touched Profile source returned
  no matches.
- 2026-06-01: `flutter test test/features/profile --reporter=compact` passed
  (`38` tests).
- 2026-06-01: `flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact`
  passed (`10` tests).
- 2026-06-01: `flutter analyze` passed (`No issues found!`).

### E900-12 - Cross-module analytics

Status: `[x]`

Files:

| File | Current lines | Target |
| --- | ---: | ---: |
| `flutter_app/lib/features/cross_module/presentation/pages/cross_module_analytics.dart` | `986` | `<500` |

Extract to widgets:

| Target file | Move classes/sections |
| --- | --- |
| `cross_module_analytics_tabs.dart` | `_AnalyticsTabs`, `_PerformanceTab`, `_MetricsTab`, `_ComparisonTab` |
| `cross_module_analytics_cards.dart` | `_SummaryGrid`, `_SummaryCard`, `_HighlightCards`, `_HighlightCard`, `_MetricDetailCard`, `_MetricValue`, `_EfficiencyRow` |
| `cross_module_analytics_common.dart` | `_ArenaAnalyticsDisclosure`, `_AnalyticsInfoCard` |
| `cross_module_analytics_painters.dart` | `_RoiBarPainter`, `_MonthlyLinePainter`, `_RadarMetricPainter`, `_RiskReturnPainter` |

Verification:

```bash
flutter test test/features/cross_module --reporter=compact
flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact
flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact
flutter analyze
```

Verification log:

- 2026-06-01: GitNexus Dart analysis remained unavailable from the E900
  preflight (`tree-sitter-dart` skipped, later CLI commands failed with
  `Cannot destructure property 'package' of 'node.target' as it is null`).
  Used `rg` for imports/symbols/blast radius plus Flutter tests and analyzer.
- 2026-06-01: Large-file scan before E900-12 showed
  `cross_module_analytics.dart` at `986` lines.
- 2026-06-01: Split `cross_module_analytics.dart` from `986` to `96` lines.
  New files: `cross_module_analytics_tabs.dart` (`164` lines),
  `cross_module_analytics_cards.dart` (`377` lines),
  `cross_module_analytics_common.dart` (`67` lines), and
  `cross_module_analytics_painters.dart` (`290` lines). The Open Arena
  points-only disclosure copy was preserved in the common part.
- 2026-06-01: `dart format` over the `5` touched Cross-module Dart files
  passed (`4` changed).
- 2026-06-01: Direct grep
  `rg -n "features/.*/data|\bColors\."` over touched Cross-module source
  returned no matches.
- 2026-06-01: `flutter test test/features/cross_module --reporter=compact`
  passed (`17` tests).
- 2026-06-01: `flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact`
  passed (`13` tests).
- 2026-06-01: `flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact`
  passed (`10` tests).
- 2026-06-01: `flutter analyze` passed (`No issues found!`).

### E900-13 - DCA smart rules

Status: `[x]`

Files:

| File | Current lines | Target |
| --- | ---: | ---: |
| `flutter_app/lib/features/dca/presentation/pages/dca_smart_rules_page.dart` | `937` | `<500` |

Extract to widgets:

| Target file | Move classes/sections |
| --- | --- |
| `dca_smart_rules_tabs_stats.dart` | `_TopTabs`, `_TopTab`, `_StatsCard`, `_StatValue` |
| `dca_smart_rules_cards.dart` | `_RuleCard`, `_TemplateGroup`, `_TemplateCard`, `_HistoryCard` |
| `dca_smart_rules_info_common.dart` | `_ImpactCard`, `_InfoCard`, `_SuccessCard`, badges, `_DeleteButton`, `_RuleText`, `_CodeRow` |

Verification:

```bash
flutter test test/features/dca --reporter=compact
flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact
flutter analyze
```

Verification log:

- 2026-06-01: GitNexus Dart analysis remained unavailable from the E900
  preflight (`tree-sitter-dart` skipped, later CLI commands failed with
  `Cannot destructure property 'package' of 'node.target' as it is null`).
  Used `rg` for imports/symbols/blast radius plus Flutter tests and analyzer.
- 2026-06-01: Large-file scan before E900-13 showed
  `dca_smart_rules_page.dart` at `937` lines.
- 2026-06-01: Split `dca_smart_rules_page.dart` from `937` to `164` lines.
  New files: `dca_smart_rules_tabs_stats.dart` (`206` lines),
  `dca_smart_rules_cards.dart` (`261` lines), and
  `dca_smart_rules_info_common.dart` (`312` lines).
- 2026-06-01: `dart format` over the `4` touched DCA Dart files passed
  (`3` changed).
- 2026-06-01: Direct grep
  `rg -n "features/.*/data|\bColors\."` over touched DCA source returned no
  matches.
- 2026-06-01: `flutter test test/features/dca --reporter=compact` passed
  (`44` tests).
- 2026-06-01: `flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact`
  passed (`10` tests).
- 2026-06-01: `flutter analyze` passed (`No issues found!`).

### E900-14 - Referral mock repository fixtures

Status: `[x]`

Files:

| File | Current lines | Target |
| --- | ---: | ---: |
| `flutter_app/lib/features/referral/data/repositories/mock_referral_repository.dart` | `951` | `<500` |

Split approach:

- Keep `MockReferralRepository` public API unchanged.
- Use `part` fixture files under `features/referral/data/repositories/`.
- Move list/map fixture builders by referral area.

Suggested target files:

| Target file | Move data |
| --- | --- |
| `mock_referral_repository_overview_fixtures.dart` | dashboard, overview, summary fixtures |
| `mock_referral_repository_campaign_fixtures.dart` | campaign, channel, link fixtures |
| `mock_referral_repository_reward_fixtures.dart` | reward, payout, ledger fixtures |
| `mock_referral_repository_social_fixtures.dart` | social/referrer/ranking fixtures |

Verification:

```bash
flutter test test/features/referral --reporter=compact
flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact
flutter analyze
```

Verification log:

- 2026-06-01: GitNexus Dart analysis remained unavailable from the E900
  preflight (`tree-sitter-dart` skipped, later CLI commands failed with
  `Cannot destructure property 'package' of 'node.target' as it is null`).
  Used `rg` for imports/symbols/blast radius plus Flutter tests and analyzer.
- 2026-06-01: Large-file scan before E900-14 showed
  `mock_referral_repository.dart` at `951` lines.
- 2026-06-01: Split `mock_referral_repository.dart` from `951` to `327`
  lines while keeping `MockReferralRepository` public APIs unchanged. New
  files: `mock_referral_repository_overview_fixtures.dart` (`103` lines),
  `mock_referral_repository_campaign_fixtures.dart` (`119` lines),
  `mock_referral_repository_reward_fixtures.dart` (`242` lines), and
  `mock_referral_repository_social_fixtures.dart` (`168` lines).
- 2026-06-01: `dart format` over the `5` touched Referral Dart files passed
  (`1` changed).
- 2026-06-01: Direct grep
  `rg -n "features/.*/data|\bColors\."` over touched Referral source
  returned no matches.
- 2026-06-01: `flutter test test/features/referral --reporter=compact`
  passed (`23` tests).
- 2026-06-01: `flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact`
  passed (`10` tests).
- 2026-06-01: `flutter analyze` passed (`No issues found!`).

## 7. Remaining `>800` Follow-Up

After all `>900` packets are complete, scan again and create a second wave for
files between `800` and `900` lines.

Post-E900 packet scan on 2026-06-01 still shows these non-packet files above
`900` lines; treat them as the first follow-up wave before the `800-900` list:

```text
959 p2p_guide_page.dart
950 p2p_ad_detail_page.dart
909 p2p_order_book_page.dart
909 p2p_settings_page.dart
901 p2p_merchant_profile_page.dart
```

Current notable `>800` follow-up candidates include:

```text
880 arena_leaderboard_page.dart
880 bot_api_documentation_page.dart
879 portfolio_analytics_page.dart
879 complaints_handling_page.dart
866 trade_history_export_page.dart
864 p2p_security_center_page.dart
858 staking_audit_reports_page.dart
857 arena_report_case_page.dart
857 staking_risk_score_calculator_page.dart
853 savings_notifications_page.dart
853 enterprise_states_page.dart
852 support_page.dart
846 bot_suitability_assessment_page.dart
846 savings_analytics_page.dart
845 staking_advanced_orders_page.dart
844 leverage_page.dart
843 network_status_page.dart
842 copy_configuration_page.dart
838 launchpad_portfolio_page.dart
836 p2p_chat_page.dart
834 provider_leaderboard_page.dart
830 arena_creator_page.dart
829 savings_risk_assessment_page.dart
829 p2p_escrow_detail_page.dart
828 product_governance_page.dart
827 funnel_dashboard.dart
825 watchlist_page.dart
820 staking_risk_disclosure_page.dart
820 predictions_leaderboard_page.dart
812 api_management_page.dart
807 dca_schedule_config_page.dart
805 p2p_my_ads_page.dart
804 bot_equity_curve_page.dart
803 p2p_trading_level_page.dart
```

## 8. Batch Log

Append real results here.

| Date | Packet | Status | Evidence |
| --- | --- | --- | --- |
| 2026-05-31 | Baseline | Created | Scan found `0` files `>1000`, `41` files `>900`, `80` files `>800`, and `167` files `>600`. |
| 2026-06-01 | E900-07 | Done | `arena_studio_page.dart` split from `961` to `182` lines; Arena tests, product copy, architecture guardrail, and analyzer passed. |
| 2026-06-01 | E900-08 | Done | Four Launchpad operational pages split below target; Launchpad tests, architecture guardrail, and analyzer passed. |
| 2026-06-01 | E900-09 | Done | Five Earn savings/staking pages split below target; Earn tests, product copy, architecture guardrail, and analyzer passed. |
| 2026-06-01 | E900-10 | Done | Markets movers and screener pages split below target; Markets tests, architecture guardrail, and analyzer passed. |
| 2026-06-01 | E900-11 | Done | Profile page split below target; Profile tests, architecture guardrail, and analyzer passed. |
| 2026-06-01 | E900-12 | Done | Cross-module analytics split below target with Arena boundary copy preserved; cross_module tests, product copy, architecture guardrail, and analyzer passed. |
| 2026-06-01 | E900-13 | Done | DCA smart rules page split below target; DCA tests, architecture guardrail, and analyzer passed. |
| 2026-06-01 | E900-14 | Done | Referral mock repository split below target with public API unchanged; Referral tests, architecture guardrail, and analyzer passed. |

## 9. Definition Of Done

A packet is done only when:

- Status changed from `[ ]` or `[~]` to `[x]`.
- Every touched page is below the target or has a documented exception.
- New files are in the correct feature layer.
- Page owns state/provider/navigation/composition only.
- No new direct page/widget imports from `features/*/data`.
- No new runtime `Colors.*`.
- Product boundary is preserved for Prediction Markets and Open Arena.
- High-risk Wallet/P2P/Auth/Trade copy remains explicit and safe.
- Required tests pass and are recorded in the Batch Log.
