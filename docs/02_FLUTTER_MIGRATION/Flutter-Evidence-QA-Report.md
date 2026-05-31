# Flutter Enterprise Evidence QA Report

Generated: 2026-05-31
Scope: full-repo enterprise readiness line audit, local remediation validation,
repository-wide security scan, S7 emulator smoke evidence sync, UI-05
responsive widget-matrix evidence, UI-06 admin dashboard hardening evidence,
UI-07 accessibility semantics evidence, UI-08 product-copy consistency, and
UI-09 route/navigation back-behavior evidence, plus UI-10 final UI-only
readiness closeout for the Flutter-only VitTrade app.

## Executive Verdict

VitTrade's local Flutter remediation is healthier after the latest S7 smoke
pass: security findings SEC-01 and SEC-02 remain fixed, all known route
placeholder/skeleton entries in the static router inventory are removed,
guardrails now prevent route placeholder regressions, copy boundary drift,
architecture baseline increases, release signing bypasses, and OTP-in-URL
regressions, and the required local verification commands pass. UI-05 adds a
responsive visual widget matrix for 25 priority routes across `360x800`,
`440x956`, and `480x1040`; UI-06 adds state-aware admin dashboard hardening;
UI-07 adds focused accessibility semantics coverage for critical controls;
UI-08 tightens product copy guardrails; UI-09 adds critical back-navigation
coverage; UI-10 closes the UI-only readiness report.

Verdict: **local remediation scope completed; production enterprise-grade is
still blocked externally**. The repo now passes format, analyze, full tests,
route audit, debug Android build, emulator preconditions, and core navigation
smoke, plus the UI-05 through UI-10 responsive, admin, accessibility, copy,
navigation, final closeout, and focused guardrail sets. High-risk emulator
smoke is partially passed as device evidence:
Prediction, Arena, Withdraw, and Token Approval evidence is current. Address
Add and P2P Payment Add completion now have UI-only Flutter `enterText`
widget-harness evidence. UI-05 responsive evidence is also Flutter widget
harness only; no new manual/emulator screenshot evidence is claimed.
The app must not be called production enterprise-grade until real remote
repositories and backend contracts exist for critical features, secure release
signing/CI secrets are provisioned, and release-target device evidence is
completed.

Top blockers:

- P0 external backend: Auth, Wallet, Trade, P2P, Predictions, and Arena still
  fail closed in production because remote repositories are not implemented.
- P0 external release ops: Android release signing secrets and observed release
  CI/store artifact validation are still missing.
- P1 enterprise acceptance: remaining non-controller feature-data imports and
  large stateful pages remain guarded but not fully refactored.
- P1 QA: S7 core navigation smoke passed, UI-01 closes Address Add/P2P
  text-entry completion, UI-05 covers responsive rendering, UI-07 covers
  critical semantics, UI-08 covers copy consistency, UI-09 covers critical
  header back behavior, and UI-10 closes the readiness report with Flutter
  widget/static harnesses. Manual device retakes remain useful for release
  evidence.

## Evidence Snapshot

| Check | Result |
| --- | --- |
| Flutter toolchain | Flutter `3.41.9` stable, Dart `3.11.5`. |
| Source size | `1094` Dart files in `flutter_app/lib`, `462871` Dart lines, average `423.1` lines/file after UI-10 final verification. |
| Test inventory | `428` test files; `1524` Dart files across `lib + test + tool` after UI-10 final verification. |
| `flutter pub get` | Passed during S7-01; pub reported 8 packages with newer incompatible versions. |
| `dart format --output=none --set-exit-if-changed .` | Passed during S8-02: `1512 files`, `0 changed`, after cleaning generated `flutter_app/build/` output. UI-10 final `dart format .` also passed: `1524` files, `0` changed. |
| `flutter analyze` | Passed during S8-02, UI-05, UI-06, UI-07, and UI-10: no issues found. |
| `flutter test --reporter=compact` | Passed during S8-02: `1841` tests. |
| `dart run tool/route_coverage_audit.dart --check` | Passed during S8-02: route coverage artifact is current. |
| `flutter build apk --debug` | Passed: built `build/app/outputs/flutter-apk/app-debug.apk`. |
| S7-01 smoke preconditions | Passed on `emulator-5554` Android 17 API 37; `adb devices` reported `emulator-5554 device`, and `flutter devices` reported the emulator plus desktop/web targets. |
| S7-02 core navigation smoke | Passed; artifacts are under `flutter_app/run-artifacts/core-smoke-20260530T202735/`. Confirmed Home, Markets, pair detail, Trade, Wallet, Deposit, Profile, Profile settings/device entry, and KYC with back navigation; crash buffers were empty. |
| S7-03 high-risk smoke | Partially passed as emulator evidence; artifacts are under `flutter_app/run-artifacts/high-risk-smoke-20260530T204000/`. Prediction, Arena, Withdraw retake, and Token Approval revoke passed. Address Add and P2P Payment Add emulator completion were blocked by ADB text-entry, then UI-01 added Flutter `enterText` harness coverage for the confirmation paths. |
| UI-01 text-entry harness | Passed; `test/quality/high_risk_text_entry_harness_test.dart` covers Address Add `SC-143` label/address entry, preview sheet, confirm tap, and saved state, plus P2P Payment Add `SC-232` account/owner entry, preview, confirm tap, and navigation away from the add form. |
| UI-02 large-file split | Passed; the four tracked feature page files are now below `1200` lines, feature files `>1200 = 0`, feature files `>600 = 239`, and page part-files remain `218`. |
| UI-03 first part-file batch | Passed; Trade `convert_page_part_03.dart` moved to `features/trade/presentation/widgets/convert_page_widgets.dart`, page part-files are now `217`, and Trade page part-files are now `33`. |
| UI-04 high-risk state depth | Passed; Wallet/P2P/Trade/Predictions/Arena high-risk controllers now expose deeper draft, validation, preview, confirming/submitting, submitted/success, error, and offline state helpers plus focused validation/review methods. `p2p_flow_status.dart` keeps large-file debt flat: feature files `>1200 = 0`, feature files `>600 = 239`, page part-files remain `217`. |
| UI-05 responsive visual QA matrix | Passed; `test/quality/responsive_visual_qa_matrix_test.dart` renders 25 priority routes through `VitTradeApp` at `360x800`, `440x956`, and `480x1040`, asserts no Flutter layout errors, and checks active shell navigation visibility. Focused feature tests, product copy guardrail, architecture guardrail, and analyze also passed. |
| UI-06 admin dashboard hardening | Passed; Admin Home, Analytics, A/B Tests, and Funnel dashboards now have state-aware loading/empty/error/offline rendering, KPI delta/timeframe metadata, selected semantics, chart summaries, and empty fallbacks. `admin_settings_page.dart` split keeps Admin Home under 600 lines; admin tests, architecture guardrail, admin responsive slice, and analyze passed. |
| UI-07 accessibility semantics pass | Passed; `test/quality/accessibility_semantics_critical_flows_test.dart` covers semantic labels/roles for Withdraw, Address Add, P2P Payment Add, Token Approval Revoke, Prediction Risk Calculator tabs/scenarios, and Admin KPI/chart summaries. Focused Wallet/P2P/Predictions/Admin tests, product copy guardrail, architecture guardrail, format, and analyze passed. |
| UI-08 copy consistency pass | Passed; Prediction Risk Calculator no longer uses payout copy and `product_copy_guardrails_test.dart` prevents that term from returning there. Arena stayed points-only, high-risk copy guardrails passed, and focused Prediction/semantics tests passed. |
| UI-09 route/navigation UX polish | Passed; `test/app/router/critical_navigation_back_behavior_test.dart` guards header back behavior for Withdraw, Address Add, Token Approval, P2P Payment Add, Prediction Risk Calculator, and Admin dashboards. Router tests, route guardrail, and route audit passed. |
| UI-10 final UI-only readiness report | Passed; this report now separates UI done, UI remaining, and out-of-scope backend/release blockers. Final focused verification passed: `dart format .`, `flutter analyze`, `46` focused UI/router/guardrail tests, and route coverage audit. |
| Route inventory | `417` static route entries: `414` real pages, `3` redirect aliases, `0` placeholders, `0` skeleton routes. |
| Router static count | `417` `GoRoute(...)` calls and `400` named route declarations in route groups. |
| Placeholder/skeleton guard | `0` `_placeholderRoute(` calls and `0` `_BottomNavRouteSkeleton` / `UnportedRoutePlaceholder` refs in router groups. |
| Shared primitive usage | `VitPageLayout` `403`, `VitPageContent` `215`, `VitHeader` `388`, `VitCard` `1623`, state widgets `48`. |
| Controllers | `23` feature `presentation/controllers/` directories exist after controller extraction. |
| Layering scan | `0` page/widget direct feature-data imports; `27` non-controller feature-data imports remain under guardrail. |
| Design-token scan | `210` `Color(0x...)` matches across `lib/test`; `186` in `lib`, all under `lib/app/theme/`; `0` runtime `Colors.*` in `lib`. |
| TODO/debug scan | `0` TODO/FIXME/HACK, `0` UnimplementedError/UnsupportedError, `0` print/debugPrint/console.log matches in `lib/test`. |
| Secret scan | No high-confidence matches for private-key headers, `sk-*`, `ghp_*`, Slack tokens, or AWS AKIA keys. |
| Security scan bundle | `/tmp/codex-security-scans/Tao-app-trad-figma-sang-fultter-bang-ui-ux-pro-max-truc-tiep-tu-code/b4ad920_20260526T150028/report.md`. |

## S7 Manual Smoke Status

| Flow group | Status | Evidence |
| --- | --- | --- |
| Preconditions | Passed | S7-01 run log in `Flutter-Manual-Smoke-Checklist.md`; format/analyze/full tests/build passed. |
| Core navigation | Passed | `flutter_app/run-artifacts/core-smoke-20260530T202735/`; Home, Markets, pair detail, Trade, Wallet, Deposit, Profile, settings/device entry, and KYC back navigation captured. |
| Prediction Markets | Passed for smoke scope | `flutter_app/run-artifacts/high-risk-smoke-20260530T204000/`; Prediction home/event/risk calculator/portfolio/valid receipt captured, with order preview amount and risk/fee copy. |
| Open Arena | Passed for smoke scope | Arena home/challenge/join captured with Arena Points-only copy and no wallet/payout/profit/stake-return language. |
| Withdraw | Passed after fix | Initial preview lacked explicit confirmation actions; `withdraw_page.dart` was fixed, APK rebuilt/reinstalled, and `withdraw-preview-sheet-retake.*` captured `Cancel` and `Confirm withdraw`. |
| Token Approval Revoke | Passed | Revoke sheet captured spender/token/allowance/gas/impact review copy plus `Cancel` and `Confirm`. |
| Address Add | Passed in UI harness | `SC-143` initial emulator screen rendered with risk/agreement copy. UI-01 added Flutter `enterText` evidence for label/address entry, preview sheet, confirm tap, and saved state. No new manual/emulator screenshot evidence is claimed. |
| P2P Payment Add | Passed in UI harness | `SC-232` initial emulator screen rendered and bank/account entry partially worked. UI-01 added Flutter `enterText` evidence for account/owner entry, preview, confirm tap, and navigation away from the add form. No new manual/emulator screenshot evidence is claimed. |

## Final Queue Status

| Area | Status |
| --- | --- |
| Sequential backlog | Historical S8 queue is complete. UI-only extension UI-01 through UI-10 is closed. |
| Remaining historical `[!]` packets | `S2-06 - Wallet smoke evidence` and `S7-03 - Execute high-risk smoke` record the earlier emulator/manual ADB text-entry limitation. UI-01 closes the current UI-only blocker with Flutter widget-harness evidence, without claiming new manual screenshots. |
| Backend blockers | Auth, Wallet, Trade, P2P, Predictions, and Arena production remote repositories/backend contracts remain external. |
| Release blockers | Android release signing secrets and observed hosted CI/store release artifact validation remain external. |
| Latest full local verification | S8-02 passed format, analyze, full tests, and route coverage audit. UI-10 final verification passed `dart format .`, `flutter analyze`, `46` focused UI/router/guardrail tests, and route coverage audit. |

## UI-Only Readiness Closeout

| Group | Status |
| --- | --- |
| UI done | UI-01 through UI-10 are closed: text-entry harness, large-file cleanup, part-file reduction, high-risk state depth, responsive matrix, admin dashboard hardening, accessibility semantics, copy consistency, route/back navigation guardrails, and the final UI-only readiness report. |
| UI remaining | No open UI-only implementation or docs packet remains. Residual UI maintenance debt is guarded rather than blocking: files over 600 lines, page part-file debt, and optional manual device retakes for richer release evidence. |
| Out-of-scope blockers | Production backend remote repositories, real backend contracts, Android release signing secrets, hosted CI/store release artifacts, and production credentials remain external blockers. Do not call the app production enterprise-grade until those are complete. |

## Enterprise Scorecard

| Area | Score | Evidence | Gap |
| --- | ---: | --- | --- |
| Architecture/layering | 4.2/5 | `app/`, `core`, `features`, `shared`, domain/data/presentation feature layers, and `23` feature controller directories exist; page/widget data imports are at `0`; UI-02 reduced feature files `>1200` to `0`. | `27` guarded non-controller feature-data imports and `239` files over 600 lines remain. |
| Routing coverage | 4.8/5 | `docs/02_FLUTTER_MIGRATION/Flutter-Route-Coverage-Truth-Table.md:11` to `13` shows `414` real pages, `3` redirects, `417` total, no placeholder class; route audit passes. | Manual smoke covered core/high-risk samples, not every route. |
| State/data/backend readiness | 2.6/5 | Production ignores mock-enable flags and repository providers fail closed without remote implementations. | Critical remote repositories and contract tests are still missing. |
| Security | 3.9/5 | SEC-01/SEC-02 fixed; network baseline hardened; no secret scan hits; route/copy/security guardrails pass. | Backend auth/session, real remote validation, and release secret operations remain open. |
| UI/design-system consistency | 4.2/5 | Shared layout/card/header usage is broad; `0` runtime `Colors.*` and `0` hardcoded colors outside `lib/app/theme/` remain in `lib`; UI-05 fixed responsive overflow, UI-06 hardened admin KPI/state/chart surfaces, UI-07 adds semantic labels/roles for critical custom controls, UI-08 removes payout-style Prediction risk copy, and UI-09 guards critical back navigation. | Large-page simplification remains ongoing but guarded. |
| Financial safety | 4.2/5 | High-risk copy guardrails pass; Withdraw preview has explicit cancel/confirm actions; Token Approval revoke review passed smoke; Address Add and P2P Payment Add confirmation paths pass the UI-01 Flutter harness. | Backend side-effect enforcement and manual release retakes remain required. |
| Prediction/Arena boundary | 4.5/5 | Product-copy guardrails pass; S7 smoke verified Prediction order preview/receipt language and Arena Points-only join copy; UI-08 blocks payout copy in the Prediction Risk Calculator. | Manual compliance review remains required for all bridge surfaces. |
| Testing/QA | 4.8/5 | S8-02 full local checks passed; `1841` full-suite tests passed at S8-02; route, copy, ops, network, config, layout, widget, core navigation smoke, high-risk partial smoke, UI-01 text-entry harness, UI-05 responsive matrix, UI-06 admin state tests, UI-07 accessibility semantics tests, UI-09 critical back-navigation tests, and UI-10 final focused verification exist. | Device-level manual retakes for Address Add and P2P Payment Add remain useful release evidence. |
| Platform/release | 3.3/5 | Debug APK builds; release signing fails fast without signing config and has metadata guardrail coverage. | Store signing secrets and observed release CI remain external blockers. |
| Docs/ops | 4.5/5 | Active Flutter docs, route artifact, security scan bundle, CI workflow, smoke checklist, QA report, sequential backlog, and UI-only tracking plan are synced through UI-10. | First hosted CI/release run and manual device retakes remain pending. |

## Line Inventory Metrics

Largest runtime files:

| Lines | File |
| ---: | --- |
| `1198` | `flutter_app/lib/features/wallet/presentation/pages/wallet_token_approval_page.dart` |
| `1197` | `flutter_app/lib/features/trade/presentation/pages/execution_quality_demo_page.dart` |
| `1196` | `flutter_app/lib/features/trade/presentation/pages/transaction_reporting_page.dart` |
| `1194` | `flutter_app/lib/features/markets/presentation/pages/market_sectors_page.dart` |
| `1194` | `flutter_app/lib/features/trade/presentation/widgets/live_market_data_analytics_widgets.dart` |
| `1186` | `flutter_app/lib/features/predictions/presentation/pages/predictions_portfolio_page.dart` |
| `1186` | `flutter_app/lib/features/launchpad/presentation/pages/launchpad_rebalance_page.dart` |
| `1184` | `flutter_app/lib/features/launchpad/presentation/pages/launchpad_dca_builder_page.dart` |
| `1184` | `flutter_app/lib/features/markets/presentation/pages/market_depth_page.dart` |
| `1181` | `flutter_app/lib/features/dev/presentation/pages/design_system_page.dart` |
| `1171` | `flutter_app/lib/features/markets/presentation/pages/derivatives_overview_page.dart` |
| `1168` | `flutter_app/lib/features/wallet/presentation/widgets/wallet_multi_manager_sections.dart` |
| `1167` | `flutter_app/lib/features/markets/presentation/pages/market_list_page.dart` |
| `1167` | `flutter_app/lib/features/earn/presentation/pages/staking_dashboard_page.dart` |
| `1156` | `flutter_app/lib/features/earn/presentation/pages/staking_api_documentation_page.dart` |

Largest feature modules by runtime lines:

| Feature | Files | Lines |
| --- | ---: | ---: |
| trade | `174` | `96327` |
| earn | `170` | `82271` |
| p2p | `131` | `64669` |
| arena | `86` | `35919` |
| launchpad | `76` | `31645` |
| markets | `73` | `30869` |
| wallet | `44` | `23409` |
| predictions | `47` | `23241` |
| dca | `39` | `15977` |
| profile | `20` | `10625` |
| referral | `18` | `6507` |
| cross_module | `31` | `5816` |

## P0 Findings

| ID | Severity | File:line evidence | Impact | Recommended fix | Owner |
| --- | --- | --- | --- | --- | --- |
| F-01 | P0 / Security High - remediated local | `flutter_app/lib/core/config/app_environment.dart:57` returns `false` for production before parsing `ENABLE_MOCK_DATA`; `flutter_app/test/core/config/app_environment_test.dart:37` covers explicit production mock enablement; `flutter_app/lib/core/data/repository_guard.dart:22` fails closed when mocks are disabled. | The previous production mock override path is closed in local config. Production still cannot run critical features until remote repos exist. | Keep this invariant in CI/release checks and add remote repositories before production. | Core/Auth/Release |
| F-02 | P0 / External backend blocker | `flutter_app/lib/features/auth/data/providers/auth_repository_provider.dart:8`, `flutter_app/lib/features/wallet/data/providers/wallet_repository_provider.dart:7`, `flutter_app/lib/features/trade/data/providers/trade_repository_provider.dart:7`, `flutter_app/lib/features/p2p/data/providers/p2p_repository_provider.dart:7`, `flutter_app/lib/features/predictions/data/providers/predictions_repository_provider.dart:7`, and `flutter_app/lib/features/arena/data/providers/arena_repository_provider.dart:7` all use `guardedRepository` without a `remote:` implementation. | Production correctly fails closed, but Auth, Wallet, Trade, P2P, Predictions, and Arena are not production-usable. | Implement remote repositories with contract tests, auth headers, timeout/error/offline mapping, staging config, and backend threat-model validation. | Backend/Data |
| F-03 | P0 / Release Ops external blocker | `flutter_app/android/app/build.gradle.kts:23` reads `VITTRADE_KEYSTORE_PATH`; `flutter_app/android/app/build.gradle.kts:30` computes `hasReleaseSigning`; `flutter_app/android/app/build.gradle.kts:87` to `91` throws when release signing is absent; `flutter_app/test/quality/ops_metadata_guardrails_test.dart:62` to `68` protects this invariant. | Secure signed release artifacts cannot be produced until CI/store secrets are provisioned and observed. | Add secure CI signing secrets, document release signing, and verify a signed release artifact in CI/staging. | Platform/Ops |

## P1 Findings

| ID | Severity | File:line evidence | Impact | Recommended fix | Owner |
| --- | --- | --- | --- | --- | --- |
| F-04 | P1 / Security Medium - remediated local | `flutter_app/lib/features/auth/presentation/controllers/password_reset_flow_controller.dart:3` defines provider-backed reset challenge state; `flutter_app/lib/features/auth/presentation/pages/otp_page.dart:172` and `:175` navigate to `/auth/reset-password` without query params; `flutter_app/lib/app/router/route_groups/auth_routes.dart:51` builds `const ResetPasswordPage()`; `flutter_app/lib/features/auth/presentation/pages/reset_password_page.dart:150` clears challenge after successful reset; `flutter_app/test/features/auth/reset_password_page_test.dart:90` and `flutter_app/test/quality/product_copy_guardrails_test.dart:97` cover query leakage. | Reset OTP no longer persists in URL/router state. Direct or query-param reset links show an expired challenge state. | Keep no-secret-route guardrails; when backend reset APIs exist, use opaque one-time challenge IDs instead of raw OTP transfer. | Auth/Security |
| F-05 | P1 / Architecture debt - guarded | Static scan found `0` page/widget direct feature-data imports and `27` guarded non-controller feature-data imports; baseline guard is `flutter_app/test/quality/architecture_baseline_guardrails_test.dart:28` to `73`. | Page/widget layering is clean, but some non-controller feature-data imports still need owner-by-owner cleanup before the baseline can be lowered again. | Continue moving non-controller feature dependencies behind controllers/domain-facing facades and lower the guardrail ceiling incrementally. | Architecture |
| F-06 | P1 / Controller extraction debt - guarded | `23` feature `presentation/controllers/` directories now exist; UI-02 moved self-contained widgets/painters from `predictions_portfolio_page.dart`, `prediction_social_page.dart`, `trader_profile_page.dart`, and `vip_page.dart`; large-file guard is `flutter_app/test/quality/architecture_baseline_guardrails_test.dart:175` to `180`. | Feature files over `1200` lines are now `0`; several page/widgets remain over `600` lines and should be split only where it reduces real UI/state complexity. | Continue targeted extraction for part-file debt and lower large-file guardrails after each cleanup batch. | Architecture/UI |
| F-07 | P1 / Design-token drift - guarded | Static scan found `210` `Color(0x...)` matches in `lib/test`, `186` in `lib`, `0` hardcoded colors outside `lib/app/theme/`, and `0` runtime `Colors.*` in `lib`; guard thresholds are in `flutter_app/test/quality/architecture_baseline_guardrails_test.dart:164` to `172`. | Runtime color-token drift is closed locally; future regressions should be caught by the guardrail. | Keep new colors inside `lib/app/theme/` and lower aggregate test allowances only after intentional theme consolidation. | Design System |
| F-08 | P1 / Routing completion - remediated local | Route artifact summary at `docs/02_FLUTTER_MIGRATION/Flutter-Route-Coverage-Truth-Table.md:11` to `13` shows `414` real pages and `417` total entries; former P2P placeholders now map to pages at `flutter_app/lib/app/router/route_groups/p2p_routes.dart:178`, `:193`, `:243`, and `:499`; outgoing route helpers now build real pages at `flutter_app/lib/app/router/route_groups/placeholder_routes.dart:11`, `:28`, `:41`, and `:49`; tournament detail maps to `flutter_app/lib/app/router/route_groups/predictions_routes.dart:106` to `108`; route placeholder guard is `flutter_app/test/quality/route_coverage_guardrails_test.dart:18`. | Static route count can no longer hide known placeholder/skeleton entries. | Keep route audit and placeholder guardrails in CI; future routes must ship real pages or explicit product acceptance. | Product/Routing |
| F-09 | P1 / Network baseline - partially remediated | `flutter_app/lib/core/network/api_client.dart:13` defines default timeouts; `flutter_app/lib/core/network/api_client.dart:22` to `31` sets `BaseOptions`, JSON response defaults, Accept header, and strict 2xx validation; `flutter_app/test/core/network/api_client_test.dart:20` to `28` validates the defaults. | Remote repos now have safer client defaults, but auth/session injection, redacted logging, retry/offline classification, telemetry, and typed errors remain deferred. | Add auth/session and error taxonomy when real remote repositories are implemented. | Core/Network |
| F-10 | P1 / Manual QA evidence - partially complete | S7-01/S7-02/S7-03 smoke runs are recorded in `docs/02_FLUTTER_MIGRATION/Flutter-Manual-Smoke-Checklist.md`; artifacts are under `flutter_app/run-artifacts/core-smoke-20260530T202735/` and `flutter_app/run-artifacts/high-risk-smoke-20260530T204000/`; UI-01 adds `flutter_app/test/quality/high_risk_text_entry_harness_test.dart`. | Core navigation and most high-risk smoke paths have current emulator evidence. Address Add and P2P Payment Add completion are covered by Flutter widget harness, while device-level manual screenshots have not been retaken. | Retake those two flows manually on emulator/device when release evidence is required. | QA |
| F-11 | P1 / Product copy boundary - partially remediated | Arena user-facing page guard is `flutter_app/test/quality/product_copy_guardrails_test.dart:54`; bridge boundary checks are `flutter_app/test/quality/product_copy_guardrails_test.dart:90` to `93`; S7 smoke captured Arena join points-only copy and Prediction order preview/receipt copy. | Static and sampled manual evidence are stronger, but not a complete compliance proof for every Arena/Prediction bridge surface. | Keep manual compliance review and extend static rules when new bridge copy patterns appear. | Product/Compliance |

## P2 Findings

| ID | Severity | File:line evidence | Impact | Recommended fix | Owner |
| --- | --- | --- | --- | --- | --- |
| F-12 | P2 / Dependency drift monitoring | `.github/workflows/flutter-ci.yml:31` pins Flutter `3.41.9`; `flutter pub outdated` reports direct/dev dependencies up to date while analyzer/test transitive packages have newer latest versions outside current resolution. | No direct dependency issue today, but analyzer/test transitive drift should be reviewed during SDK upgrades. | Re-check after Flutter upgrades and review any CVE/GHSA advisory that affects transitive packages. | Ops |
| F-13 | P2 / Router compile-time coupling | `flutter_app/lib/app/router/app_router.dart:4` starts centralized feature imports; `flutter_app/lib/app/router/route_groups/root_routes.dart:37` composes all route lists. | The structure works, but compile-time coupling grows with route count. | Keep route groups split; consider feature-owned route exports only after backend and broad architecture work stabilize. | Architecture |

## Security Scan Summary

Security artifacts were written under:

`/tmp/codex-security-scans/Tao-app-trad-figma-sang-fultter-bang-ui-ux-pro-max-truc-tiep-tu-code/b4ad920_20260526T150028/`

| Phase | Artifact |
| --- | --- |
| Threat model | `artifacts/threat_model.md` |
| Finding discovery | `artifacts/finding_discovery_report.md` |
| Validation | `artifacts/validation_report.md` |
| Attack-path analysis | `artifacts/attack_path_analysis_report.md` |
| Final security summary | `report.md` |
| Fix validation | `artifacts/fix_validation_report.md` |

Validated security findings and remediation status:

| ID | Severity | Finding | Status |
| --- | --- | --- | --- |
| SEC-01 | High / P0 | Production mock override could ship mock auth/fixed challenge behavior. | Fixed locally; production now ignores mock-enable flags. Backend remote repos are still required. |
| SEC-02 | Medium / P1 | Password reset OTP was propagated through URL query state. | Fixed locally; reset challenge is provider-backed and reset route ignores query params. |

Security scan conclusions:

- Android release signing remains fail-closed when signing material is absent.
- High-confidence secret scan found no private key/API token matches.
- Route placeholders were not validated as standalone security findings, but
  the completion gap is now closed and guarded.
- API client baseline hardening is present, but auth/session, retry/offline,
  telemetry, redacted logging, and typed network errors depend on real remote
  repositories.

## Hardening Roadmap

### P0 Before Any Production Release

- Implement remote repositories for Auth, Wallet, Trade, P2P, Predictions, and
  Arena, including contract tests and network/auth/error controls.
- Provision secure Android release signing in CI/store workflows and verify a
  signed release artifact.

### P1 Before Enterprise Acceptance

- Maintain no-production-mocks, no-secret-route, route-placeholder, product
  copy, architecture baseline, and release signing guardrails.
- Extract controllers/view models for the largest and highest-risk screens.
- Reduce direct presentation-to-data imports behind stable feature facades.
- Normalize repeated local colors into theme/module tokens and lower baseline
  guardrail ceilings.
- Retake Address Add and P2P Payment Add manually on emulator/device when
  release evidence is required; UI-01 already covers the UI-only text-entry
  confirmation paths with Flutter `enterText`.
- Extend manual compliance review for Arena/Prediction bridge surfaces.

### P2 Cleanup

- Monitor transitive dependency drift during Flutter SDK upgrades.
- Keep router group ownership clear as route count grows.
- Observe the first GitHub-hosted CI/release run and tune caching/build time.

## Public API / Interface Changes

No backend API contract was introduced. Public route paths remain stable; this
pass changed internal route builders so former placeholder/skeleton destinations
now render real Flutter pages. `ResetPasswordPage` no longer accepts route
email/OTP material; reset challenge state flows through an auth presentation
controller/provider.

## Assumptions And Limits

- "100% complete" means complete for the agreed local remediation scope, not
  production enterprise-grade status.
- "Line inventory" means file:line evidence for promoted findings and metrics,
  not a verbatim dump of all Dart lines.
- Existing uncommitted source changes were preserved.
- S7 emulator smoke was executed on `emulator-5554`; core navigation passed.
  Address Add and P2P Payment Add emulator completion was blocked by ADB text
  entry, then UI-01 added Flutter widget-harness evidence for those
  confirmation paths. This does not claim new manual screenshots.
- Full remote API security validation is deferred because critical remote
  repositories and backend contracts are not implemented yet.
