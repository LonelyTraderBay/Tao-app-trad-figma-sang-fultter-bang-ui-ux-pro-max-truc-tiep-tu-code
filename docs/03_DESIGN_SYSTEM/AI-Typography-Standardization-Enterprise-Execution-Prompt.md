# AI Typography Standardization Enterprise Execution Prompt

Copy the prompt below into AI/Codex when you want the agent to execute the
typography standardization work from:

- `docs/03_DESIGN_SYSTEM/VitTrade-Typography-Standardization-Plan.md`
- `docs/03_DESIGN_SYSTEM/VitTrade-Flutter-Enterprise-Tokenization-Plan.md`

This prompt is not a request to create another plan. It is a request to execute
the existing typography plan in strict order, without skipping phases, without
jumping into random screen edits, and without making the UI visually messy.

Use this prompt when the goal is:

- Dark professional typography.
- Crypto exchange visual hierarchy.
- Trading super-app information density.
- Consistent font size, weight, line-height, numeric text, and font family.
- Phone-first readability at 360 px and up.
- Less hardcoded `fontSize`, `fontFamily`, `FontWeight`, and local `TextStyle`.
- No product behavior regression.
- No financial-safety regression.

````text
You are working in the VitTrade Flutter repository:

C:\Users\C-PC\Documents\Tao-app-trad-figma-sang-fultter-bang-ui-ux-pro-max-truc-tiep-tu-code

PRIMARY OBJECTIVE:
Execute the typography standardization plan from:

docs/03_DESIGN_SYSTEM/VitTrade-Typography-Standardization-Plan.md

The target is a Dark professional / crypto exchange / trading super-app
typography system:

- one semantic typography scale
- consistent title/body/caption/control/numeric hierarchy
- consistent font weight and line-height
- tabular numeric text for trading/financial data
- no random hardcoded font sizes in feature screens
- no local font-family drift
- no tiny unreadable text used to cram content
- no oversized text inside compact cards
- no messy redesigns
- no weakened financial safety copy

THIS IS AN EXECUTION PROMPT, NOT A PLANNING PROMPT:

- Do not create a new plan instead of doing the work.
- Do not only analyze and stop.
- Do not skip directly to random feature UI cleanup.
- Follow the active plan in exact phase order: T0, T1, T2, T3, T4, T5.
- If a phase is already complete, verify it from source/docs/artifacts, then
  continue to the next incomplete phase.
- If a phase is incomplete, finish it before starting a later phase.
- Do not mark a phase complete until its acceptance gate passes.
- Work in small batches and update the tracking document after each completed
  batch.

MANDATORY READ BEFORE EDITING:

Read enough of each file to follow the current rules:

1. `AGENTS.md`
2. `docs/00_START_HERE.md`
3. `docs/01_AI_RULES/AI_EXECUTION_CONTRACT.md`
4. `docs/01_AI_RULES/DOCUMENT_PRECEDENCE.md`
5. `docs/03_DESIGN_SYSTEM/Guidelines.md`
6. `docs/03_DESIGN_SYSTEM/VitTrade-Typography-Standardization-Plan.md`
7. `docs/03_DESIGN_SYSTEM/VitTrade-Flutter-Enterprise-Tokenization-Plan.md`
8. `docs/02_FLUTTER_MIGRATION/Flutter-App-Foundation.md`
9. `docs/02_FLUTTER_MIGRATION/Flutter-Native-Design-Standard.md`
10. `docs/02_FLUTTER_MIGRATION/Flutter-Module-Identity-Standard.md`
11. `docs/02_FLUTTER_MIGRATION/Enterprise-PR-Review-Checklist.md`
12. `docs/02_FLUTTER_MIGRATION/Future-Feature-Onboarding-Checklist.md`
13. Existing source files and tests for the active phase/module.

If documents conflict, follow this order:

1. Current user request
2. `AGENTS.md`
3. Typography standardization plan
4. Flutter enterprise tokenization plan
5. Flutter native design standard
6. Design system guidelines
7. Current Flutter source and tests

SOURCE OF TRUTH:

- Flutter package: `flutter_app/`
- App source: `flutter_app/lib/`
- Theme tokens: `flutter_app/lib/app/theme/`
- Typography source: `flutter_app/lib/app/theme/app_text_styles.dart`
- App theme mapping: `flutter_app/lib/app/vit_trade_app.dart`
- Shared layout: `flutter_app/lib/shared/layout/`
- Shared widgets: `flutter_app/lib/shared/widgets/`
- Screen pages: `flutter_app/lib/features/<feature>/presentation/pages/`
- Feature widgets: `flutter_app/lib/features/<feature>/presentation/widgets/`
- Tests: `flutter_app/test/`
- Typography plan:
  `docs/03_DESIGN_SYSTEM/VitTrade-Typography-Standardization-Plan.md`

CURRENT BASELINE TO REDUCE:

Use the latest plan baseline unless a newer audit proves different:

- Total `fontSize:` in `flutter_app/lib`: 382
- `fontSize:` outside `app/theme`: 361
- Direct numeric `fontSize` outside theme: 167
- `copyWith(fontSize: ...)` outside theme: 16
- Direct `TextStyle(...)` outside theme: 58
- Unique numeric font sizes outside theme: 22
- `fontFamily:` outside theme: 39
- `fontFamily: 'monospace'`: 32
- `fontFamily: 'Roboto'`: 3

Current direct numeric `fontSize` modules:

- `features/trade`: 146
- `features/p2p`: 13
- `features/profile`: 5
- `features/markets`: 3
- `features/auth`: 0
- `features/news`: 0
- `features/onboarding`: 0
- `features/support`: 0
- `features/wallet`: 0
- `features/discovery`: 0

Current resume point:

- R0 done.
- T3.1-T3.3 done.
- T4.1-T4.4 done.
- T5.1-T5.4 done.
- T5.5 is the prompt sync item. After it is complete, future work should start
  from the first unchecked row in
  `docs/03_DESIGN_SYSTEM/VitTrade-Typography-Standardization-Plan.md`.

NON-NEGOTIABLE UI RULES:

- Keep the dark professional baseline.
- Preserve existing product behavior, routes, widget keys, providers,
  controllers, semantics, and tests.
- Preserve financial safety: preview, confirmation, fee/risk/limit, masking,
  submitting, success, error, offline, and next-step states.
- Prediction Markets and Open Arena must remain separate.
- Arena must remain points-only. Do not introduce wallet, payout, PnL, profit,
  or stake-return language into Arena.
- Do not add decorative blobs, random gradients, marketing hero sections,
  unrelated animations, or visual noise.
- Do not make UI denser by making text tiny.
- Do not remove important labels, risk copy, disclosures, or confirmation
  states to save space.
- Use shared VitTrade primitives and `AppTextStyles` before creating local UI.
- Do not use display-scale typography inside compact cards, settings rows,
  order forms, P2P dispute screens, security screens, or compliance screens.

NON-NEGOTIABLE CODE RULES:

- Use `apply_patch` for manual file edits.
- Do not revert unrelated dirty worktree changes.
- Do not create React/Vite/npm/Tailwind/web screenshot tooling.
- Prefer `rg`/`rg --files` for search.
- Work in small, verifiable batches.
- For typography cleanup, prefer batches of 2 to 5 related files.
- Finish and verify the current batch before starting the next one.
- If a change touches shared typography tokens/components, run broader checks.
- If a change touches a high-risk financial flow, run focused flow tests.

TYPOGRAPHY SCALE CONTRACT:

Use these tokens by default:

- `AppTextStyles.micro`: helper, timestamp, small metadata.
- `AppTextStyles.numericMicro`: order book, compact numeric rows.
- `AppTextStyles.badge`: status pill, small risk badge.
- `AppTextStyles.navLabel`: bottom nav and compact nav labels.
- `AppTextStyles.caption`: secondary text, card descriptions.
- `AppTextStyles.body`: main readable card/list text.
- `AppTextStyles.control`: buttons, tabs, inputs, segmented controls.
- `AppTextStyles.base`: prominent body text.
- `AppTextStyles.baseMedium`: row title, card title, form label emphasis.
- `AppTextStyles.amountSm`: small amount in metric cards.
- `AppTextStyles.sectionTitle`: section heading.
- `AppTextStyles.pageTitle`: route/page heading.
- `AppTextStyles.amountMd`: amount input and secondary hero numbers.
- `AppTextStyles.heroNumber`: balance hero and key trading number.
- `AppTextStyles.amountLg`: large financial amount.
- `AppTextStyles.display`: rare display moment only.
- `AppTextStyles.jumbo`: rare onboarding/special moment only.

Use `fontFeatures: AppTextStyles.tabularFigures` for:

- balances
- prices
- P/L
- percentages
- quantities
- order-book values
- fees
- limits
- risk scores
- numeric trading stats

TYPOGRAPHY RULES:

Font size:

- Do not add `fontSize: <number>` in feature code.
- Do not add `copyWith(fontSize: <number>)` when a semantic token exists.
- Do not add direct `TextStyle(fontSize: ...)` in feature screens/widgets.
- If a missing style repeats in 3 or more places, add a semantic token to
  `AppTextStyles` instead of repeating numbers.

Font weight:

- Use `AppTextStyles.normal`, `medium`, `bold`, `extraBold`, `heavy`.
- Do not use `FontWeight.w800` or `FontWeight.w900` directly in feature code.
- Do not make secondary helper/caption text too bold.

Font family:

- Do not use `fontFamily: 'Roboto'` in feature code.
- Do not use monospace for amount/price/P/L when tabular figures are enough.
- Monospace is allowed only for address, hash, API key, code, and technical
  identifiers, preferably through a semantic helper/token.

Line height:

- Do not spread `height: 1` across body/description text.
- Body/caption text should remain readable on dark UI.
- Tight line-height is allowed for short labels, controls, and numeric text
  only when glyphs are not clipped on Android.

Mobile density:

- 360 px phone width is the baseline.
- Text in rows/cards with dynamic content must use `maxLines` and `overflow`
  where needed.
- CTA/risk/confirmation text must not be hidden by bottom nav or sticky footer.
- Do not reduce readable body content to size 8 or 9 to fit more content.

DRIFT MAPPING:

When replacing hardcoded sizes, use this mapping:

- `7`: chart/canvas exception only.
- `8`: `numericMicro` or chart exception.
- `9`: `micro` or a justified `microTight` token if repeated.
- `10`: `micro` / `numericMicro`.
- `11`: `badge` / `navLabel`.
- `12`: usually `caption`; create `captionSm` only if compact labels repeat.
- `13`: `caption`.
- `14`: `body` / `control`.
- `15`: `body` or `baseMedium` by role.
- `16`: `base` / `baseMedium`.
- `17`: `amountSm` or `sectionTitle` by role.
- `18`: `amountSm`.
- `19/20`: `sectionTitle` or justified `sectionTitleSm`.
- `21/22`: `sectionTitle`.
- `24/25/26`: `pageTitle` or `sectionTitle` by context.
- `27/28/29/30`: `amountMd` or `pageTitle` by context.
- `32/33/34/36`: `heroNumber` / `amountLg`.
- `42/43`: `display`, rare hero/display only.
- `55/56`: `jumbo`, rare exception only.

STRICT PHASE ORDER:

PHASE T0 - TYPOGRAPHY CONTRACT

Do not edit broad feature typography before T0 is complete.

Tasks:

1. Verify `VitTrade-Typography-Standardization-Plan.md` exists.
2. Verify the current `AppTextStyles` scale matches the plan or document gaps.
3. Confirm which drift sizes need real tokens versus exceptions.
4. Confirm exception categories:
   - chart/canvas labels
   - heatmap/correlation cells
   - address/hash/API key/code
   - dev/internal tools
5. Confirm PR rule: no new hardcoded `fontSize` in feature code.
6. Update docs only if the rule source is missing or unclear.

T0 acceptance gate:

- Semantic scale is clear.
- Exceptions are clear.
- AI/developer has a single source to follow.
- No feature screen cleanup was done before the contract was understood.

PHASE T1 - FOUNDATION CLEANUP

Do not start visual hotspot cleanup until feature code has enough tokens/helpers
to avoid replacing one local style with another local style.

Tasks:

1. Add missing semantic typography tokens only if needed:
   - `captionSm`
   - `sectionTitleSm`
   - `monoCode`
   - `numericCode`
   - any other repeated style with a clear semantic name
2. Add helper/style for address/hash/API/code text if needed.
3. Ensure numeric/amount tokens use tabular figures.
4. Review `ThemeData.textTheme` mapping in `vit_trade_app.dart`.
5. Update shared components that currently override font size locally:
   - shared buttons
   - input/search controls
   - status pills
   - tabs
   - bottom nav
   - top/header labels
6. Do not add more tokens than necessary.

T1 acceptance gate:

- Shared components do not create unnecessary typography drift.
- Feature code has enough semantic tokens for common replacements.
- New tokens have semantic names, not size names.
- `dart format .` and focused checks pass after code edits.

PHASE T2 - P0 VISUAL HOTSPOTS

Process these in order:

1. Wallet buy crypto typography pass.
2. Trade ombudsman/compliance typography pass.
3. Trade portfolio risk typography pass.
4. Trade copy education typography pass.

Target files:

- `flutter_app/lib/features/wallet/presentation/widgets/wallet_buy_crypto_input_sections.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/wallet_buy_crypto_payment_sections.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/wallet_buy_crypto_result_sections.dart`
- `flutter_app/lib/features/trade/presentation/pages/ombudsman_referral_page.dart`
- `flutter_app/lib/features/trade/presentation/widgets/portfolio_risk_analysis_page_sections.dart`
- `flutter_app/lib/features/trade/presentation/widgets/copy_education_page_sections.dart`

For each batch:

1. Identify every text role before editing.
2. Replace direct `fontSize` with `AppTextStyles`.
3. Replace direct `FontWeight` with `AppTextStyles` constants.
4. Replace numeric/amount text with amount/numeric tokens.
5. Remove local `Roboto`.
6. Keep monospace only for real code/hash/address if present.
7. Add `maxLines`/`overflow` where card text can be long.
8. Preserve all financial risk/fee/limit/copy.
9. Update the typography plan with before/after debt.

T2 acceptance gate:

- Most visible font imbalance is improved.
- Compact cards do not use oversized text.
- Financial amounts align and read like exchange/trading data.
- 360 px phone view does not overflow or hide CTA/risk text.

PHASE T3 - TRADING AND MARKETS PASS

Process these in order:

1. Remaining top `features/trade` typography debt.
2. Markets social/alerts/screener typography.
3. Chart label exception review.

Trade priority examples:

- `features/trade/presentation/widgets/advanced_trading_demo_page_sections.dart`
- `features/trade/presentation/widgets/execution_quality_overview.dart`
- `features/trade/presentation/widgets/complaint_submission_page_sections.dart`
- `features/trade/presentation/pages/trading_bots_page_part_02.dart`
- `features/trade/presentation/pages/complaint_tracking_page.dart`
- `features/trade/presentation/pages/trading_bots_page_part_03.dart`
- `features/trade/presentation/widgets/transaction_reporting_reports.dart`

Markets priority examples:

- `features/markets/presentation/pages/social_signals_page_part_02.dart`
- `features/markets/presentation/widgets/price_alerts_page_details.dart`
- `features/markets/presentation/widgets/comparison_tool_tokens.dart`
- `features/markets/presentation/widgets/market_movers_row_common.dart`
- `features/markets/presentation/widgets/market_screener_filters.dart`

T3 acceptance gate:

- `features/trade` local font-size debt drops significantly.
- `features/markets` local font-size debt drops significantly.
- Chart/canvas exceptions are documented and do not leak into normal UI.
- Dense trading data remains readable.

PHASE T4 - P2P, PROFILE, AUTH, SECONDARY MODULES

Process these in order:

1. P2P security/compliance typography.
2. Profile/Auth residual typography.
3. News/onboarding/support cleanup.
4. Wallet/discovery final crumbs.

P2P priority examples:

- `features/p2p/presentation/widgets/p2p_transaction_limits_page_common.dart`
- `features/p2p/presentation/pages/p2p_blacklist_add_page.dart`
- `features/p2p/presentation/pages/p2p_aml_screening_page.dart`
- `features/p2p/presentation/pages/p2p_limit_tracker_page.dart`

Profile/Auth priority examples:

- `features/profile/presentation/widgets/activity_log_page_sections.dart`
- `features/profile/presentation/widgets/settings_page_sections.dart`
- `features/auth/presentation/widgets/reset_password_page_sections.dart`
- `features/auth/presentation/widgets/forgot_password_page_sections.dart`

T4 acceptance gate:

- Security/account/auth flows use consistent hierarchy.
- Form labels and helper text are readable and aligned.
- Auth headings are not oversized inside compact screens.
- No risk/security copy is removed to save space.

PHASE T5 - ENFORCEMENT

Only start T5 after T0-T4 create a stable baseline.

Tasks:

1. Keep token audit reporting typography debt separately by module/file.
2. Keep changed-file guardrails blocking new hardcoded `fontSize`,
   `fontFamily`, near-1 text height, and direct `FontWeight.w800/w900`.
3. Keep PR checklist typography section aligned with the plan.
4. Keep future feature onboarding typography gates aligned with the plan.
5. Update this execution prompt whenever the plan resume point or phase status
   changes.

T5 acceptance gate:

- New PRs cannot silently increase typography debt.
- Audit reports typography debt by module/file.
- Exceptions are explicit and justified.
- Documentation points future AI/developers to the same contract.

WORKFLOW FOR EVERY BATCH:

Use this exact sequence:

1. Read active phase and acceptance gate.
2. Inspect current source/audit for the specific batch.
3. Pick the highest-priority incomplete item in the current phase.
4. State the batch scope in one short progress update.
5. Edit only files needed for that batch.
6. Format changed Dart files.
7. Run focused tests for touched modules.
8. Run `flutter analyze` when code changes are non-trivial or touch shared
   components.
9. Re-run typography/token audit if the batch changes debt.
10. Update `VitTrade-Typography-Standardization-Plan.md` with before/after
    status.
11. Confirm the phase checklist item is complete or still pending.
12. Continue to the next item in the same phase.

DO NOT SKIP CHECKLIST ITEMS:

- If an item looks already done, verify it from source/tests/reports.
- If an item is not applicable, document why.
- If an item is blocked, attempt a concrete fix before declaring it blocked.
- Do not move to a later phase because the current phase is tedious.
- Do not declare completion because only one visible screen improved.

ANTI-MESSY-UI CHECKLIST:

Before finishing any UI batch, verify:

- Page title, section title, body, caption, control, badge, amount, and numeric
  roles are clear.
- Text is not too small to read on 360 px.
- Text does not overlap icons/buttons/cards.
- Amount/price/P/L values use tabular numeric styling.
- Card text hierarchy matches nearby cards.
- Buttons have stable height and icon/text alignment.
- There is no new random font family.
- There is no local `Roboto` except theme-level decision.
- There is no new decorative visual noise.
- The screen shows more useful content through better hierarchy, not tiny text.
- Financial risk/disclosure text is still visible.
- Bottom nav and sticky footers do not hide important content.

ALLOWED EXCEPTIONS:

Exceptions are allowed only when documented:

- Custom chart painters.
- Order book/canvas-like dense market widgets.
- Mini heatmap/correlation cells.
- Dev/internal route checker tools.
- Fullscreen chart/trading tools.
- Address/hash/API key/code text that genuinely benefits from monospace.
- Highly specialized visual QA frames.

Even for exceptions:

- Keep text readable.
- Keep product copy boundaries.
- Prefer local helper or semantic token if the pattern repeats.
- Record the reason in the plan/audit.

COMMANDS:

Run from `flutter_app/` unless stated otherwise:

```powershell
flutter pub get
dart format .
dart run tool/design_token_consistency_audit.dart
flutter analyze
flutter test --reporter=compact
```

Use focused tests for touched modules first. Use full tests when changing shared
tokens, shared layout, shared widgets, router behavior, or high-risk financial
flows.

FINAL SUCCESS CRITERIA:

The job is complete only when all of these are true:

1. T0-T5 are complete or documented with accepted exceptions.
2. Typography plan is updated with current batch status.
3. Typography debt is below target thresholds or has a documented migration
   baseline with no new debt.
4. No touched feature adds new hardcoded `fontSize`.
5. No touched feature adds local `Roboto`.
6. Numeric trading/financial text uses tabular figures.
7. Visible P0 hotspots no longer feel like mixed font systems.
8. 360 px phone layout has no text overlap or hidden financial-safety copy.
9. `flutter analyze` passes.
10. Focused tests for touched modules pass.

FINAL RESPONSE RULE:

If everything is complete, the final response must include:

TYPOGRAPHY STANDARDIZATION COMPLETE

If forced to stop before completion, the final line of the response must be:

RESUME FROM: T<phase number> - <specific checklist item or module batch>

Do not write anything after the `RESUME FROM:` line.
````
