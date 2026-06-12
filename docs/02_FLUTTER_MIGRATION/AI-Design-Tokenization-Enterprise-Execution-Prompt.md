# AI Design Tokenization Enterprise Execution Prompt

Copy the prompt below into AI/Codex when you want the agent to execute the
design tokenization and UI consistency work from:

- `docs/03_DESIGN_SYSTEM/VitTrade-Flutter-Enterprise-Tokenization-Plan.md`

This prompt is not a request to create another plan. It is a request to execute
the existing tokenization plan in strict order, without skipping phases,
without jumping directly into random screen edits, and without making the UI
visually messy.

Use this prompt when the goal is:

- Flutter enterprise-grade UI consistency
- Tokenized typography, spacing, radius, sizing, color, surface, and density
- Phone-first mobile layout at 360 px and up
- Dark professional crypto trading app
- Less local hardcoding
- More shared VitTrade primitives
- No product behavior regression
- No financial-safety regression

````text
You are working in the VitTrade Flutter repository:

C:\Users\C-PC\Documents\Tao-app-trad-figma-sang-fultter-bang-ui-ux-pro-max-truc-tiep-tu-code

PRIMARY OBJECTIVE:
Execute the design tokenization and UI consistency plan from:

docs/03_DESIGN_SYSTEM/VitTrade-Flutter-Enterprise-Tokenization-Plan.md

The target is Flutter enterprise-grade consistency across the whole app:
- one design-token foundation
- one typography rhythm
- one spacing rhythm
- one radius system
- one sizing/density system
- one shared card/surface treatment
- consistent phone-first layout
- no random hardcoded UI values in feature screens
- no messy redesigns
- no weakening of financial safety

THIS IS AN EXECUTION PROMPT, NOT A PLANNING PROMPT:
- Do not create a new plan instead of doing the work.
- Do not only analyze and stop.
- Do not skip directly to random feature UI cleanup.
- Follow the active plan in exact phase order: P0, P1, P2, P3, P4, P5.
- If a phase is already complete, verify it from code/artifacts, then continue
  to the next incomplete phase.
- If a phase is incomplete, finish it before starting a later phase.
- Do not mark a phase complete until acceptance gates pass.

MANDATORY READ BEFORE EDITING:
Read enough of each file to follow current rules:

1. `AGENTS.md`
2. `docs/00_START_HERE.md`
3. `docs/01_AI_RULES/AI_EXECUTION_CONTRACT.md`
4. `docs/01_AI_RULES/DOCUMENT_PRECEDENCE.md`
5. `docs/03_DESIGN_SYSTEM/Guidelines.md`
6. `docs/03_DESIGN_SYSTEM/VitTrade-Flutter-Enterprise-Tokenization-Plan.md`
7. `docs/02_FLUTTER_MIGRATION/Flutter-App-Foundation.md`
8. `docs/02_FLUTTER_MIGRATION/Flutter-Native-Design-Standard.md`
9. `docs/02_FLUTTER_MIGRATION/Flutter-Module-Identity-Standard.md`
10. `docs/02_FLUTTER_MIGRATION/Enterprise-PR-Review-Checklist.md`
11. `docs/02_FLUTTER_MIGRATION/Future-Feature-Onboarding-Checklist.md`
12. Existing source files and tests for the active phase/module.

If documents conflict, follow this order:
1. Current user request
2. `AGENTS.md`
3. Tokenization plan
4. Flutter native design standard
5. Design system guidelines
6. Current Flutter source and tests

SOURCE OF TRUTH:
- Flutter package: `flutter_app/`
- App source: `flutter_app/lib/`
- Theme tokens: `flutter_app/lib/app/theme/`
- Shared layout: `flutter_app/lib/shared/layout/`
- Shared widgets: `flutter_app/lib/shared/widgets/`
- Screen pages: `flutter_app/lib/features/<feature>/presentation/pages/`
- Feature widgets: `flutter_app/lib/features/<feature>/presentation/widgets/`
- Tests: `flutter_app/test/`
- Public router import: `flutter_app/lib/app/router/app_router.dart`
- Tokenization plan:
  `docs/03_DESIGN_SYSTEM/VitTrade-Flutter-Enterprise-Tokenization-Plan.md`

NON-NEGOTIABLE UI RULES:
- Keep the dark professional baseline.
- Preserve the existing product behavior, routes, widget keys, providers,
  controllers, semantics, and tests.
- Preserve financial safety: preview, confirmation, fee/risk/limit, masking,
  submitting, success, error, offline, and next-step states.
- Prediction Markets and Open Arena must remain separate.
- Arena must remain points-only. Do not introduce wallet, payout, PnL, profit,
  or stake-return language into Arena.
- Do not add decorative blobs, random gradients, marketing hero sections,
  unrelated animations, or visual noise.
- Do not introduce new local color palettes, spacing systems, radius systems,
  button systems, or card treatments.
- Do not make UI denser by cramming text. Optimize hierarchy and space, not by
  making everything tiny.
- Do not remove important labels, risk copy, disclosures, or confirmation
  states to save space.
- Do not put cards inside cards unless it is a repeated item, modal, or framed
  tool with a clear reason.
- Use shared VitTrade primitives before creating local UI.

NON-NEGOTIABLE CODE RULES:
- Use `apply_patch` for manual file edits.
- Do not revert unrelated dirty worktree changes.
- Do not create React/Vite/npm/Tailwind/web screenshot tooling.
- Prefer `rg`/`rg --files` for search.
- Work in small, verifiable batches.
- For broad modules, prefer batches of 3 to 6 related screens/widgets.
- Finish and verify the current batch before starting the next one.
- If a change touches shared tokens/components, run broader tests.
- If a change touches a high-risk financial flow, run focused flow tests.

STRICT PHASE ORDER:

PHASE P0 - AUDIT AND GOVERNANCE FIRST
Do not edit feature UI before P0 is complete.

Tasks:
1. Verify the tokenization plan exists and is linked from
   `docs/03_DESIGN_SYSTEM/Guidelines.md`.
2. Create or update `flutter_app/tool/design_token_consistency_audit.dart`.
3. The audit must scan:
   - root page bundles: root page + declared `part` files
   - feature widgets
   - shared widgets
   - allowed exceptions
4. The audit must count:
   - `fontSize: <number>`
   - `fontFamily:`
   - `FontWeight.w800` and `FontWeight.w900`
   - text `height: 1` or near-1 overrides
   - numeric `EdgeInsets.*(...)`
   - numeric `SizedBox(width/height: ...)`
   - numeric `BorderRadius.circular(...)`
   - numeric `Radius.circular(...)`
   - `Container(` + `BoxDecoration(`
   - fixed card/list/grid `width` and `height`
   - hardcoded grid `crossAxisCount`, `childAspectRatio`, `mainAxisExtent`
5. Create Markdown and CSV reports:
   - `docs/02_FLUTTER_MIGRATION/VitTrade-Design-Token-Consistency-Audit.md`
   - `docs/02_FLUTTER_MIGRATION/VitTrade-Design-Token-Consistency-Audit.csv`
6. Create or update guardrail test:
   - `flutter_app/test/quality/design_token_consistency_guardrail_test.dart`
7. Start in baseline/warning mode if current debt is large. Do not fail the
   entire existing app immediately unless the plan already says to do so.
8. The guardrail must prevent new debt in touched/new files where possible.

P0 acceptance gate:
- Audit runs from `flutter_app/`.
- Reports are generated.
- Guardrail test exists.
- Existing broad tests are not broken.
- Current baseline is documented.
- No random UI screen edits were made before the audit foundation.

PHASE P1 - TOKEN FOUNDATION
Do not start P2/P3/P4 before P1 has enough tokens for common replacements.

Tasks:
1. Extend `AppTextStyles` with semantic styles only when needed:
   - `badge`
   - `control`
   - `amountSm`
   - `amountMd`
   - `amountLg`
   - `numericMicro`
   - `navLabel`
2. Extend `AppSpacing` with semantic spacing/insets only when needed:
   - card compact padding
   - standard card padding
   - hero card padding
   - page horizontal padding
   - grid gap
   - row gap
   - section gap variants
   - bottom content inset
3. Extend `AppRadii` only when needed:
   - pill radius
   - sheet top radius
   - avatar/circle radius
   - chart radius
4. Add a density concept if useful:
   - `compact`
   - `standard`
   - `relaxed`
5. Update shared primitives to consume tokens:
   - `VitCard`
   - `VitServiceTile`
   - `VitCtaButton`
   - `VitInput`
   - `VitSearchBar`
   - `VitTabBar`
   - `VitStatusPill`
   - `VitBottomNav`
6. Do not invent too many tokens. Promote a token only when it has a clear
   semantic use or repeated pattern.

P1 acceptance gate:
- Shared components do not rely on unnecessary local magic numbers.
- Feature code has enough semantic tokens for common cleanup.
- `dart format .` passes.
- `flutter analyze` passes.
- Focused shared widget tests pass where applicable.

PHASE P2 - HOME AND GLOBAL CHROME DENSITY
Do not start broad module cleanup before Home/global shared patterns are stable.

Tasks:
1. Optimize Home first viewport without making the UI cramped.
2. Reduce visual waste in balance hero, shortcut/service grid, and section
   rhythm.
3. Add compact/standard variants to `VitServiceTile` if needed.
4. Keep Home as global source of truth for app chrome, card treatment, CTA,
   spacing, and primary brand behavior.
5. Keep bottom nav stable and ensure it does not hide important first-load
   content or primary CTAs.
6. Verify at 360 px, 440 px, and 480 px.

P2 acceptance gate:
- Home still feels premium and dark professional.
- First viewport shows more useful content without visual clutter.
- No text overlaps.
- No horizontal scroll.
- Bottom nav does not block important content.
- Existing Home route tests pass.

PHASE P3 - P0 FINANCIAL MODULES
Process modules in this exact order unless the user explicitly changes scope:

1. Wallet overview/assets/history
2. Deposit/Withdraw/Transfer
3. Address Book/Add Address
4. Token Approval/Revoke
5. Trade basic order/history/receipt
6. P2P home/order/payment method/dispute
7. Markets list/pair detail
8. Profile/security/KYC

For each module:
1. Run/read token audit for the module.
2. Select a small batch of related screens/widgets.
3. Replace local `fontSize`, `fontFamily`, `FontWeight.w800/w900`,
   `height: 1`, numeric `EdgeInsets`, numeric radius, and repeated
   `Container + BoxDecoration` patterns with tokens/shared primitives.
4. Preserve all product states and financial-safety copy.
5. Run focused tests.
6. Re-run token audit and confirm debt decreased or document justified
   exceptions.
7. Only then move to the next batch.

P3 acceptance gate:
- High-risk flows preserve preview/confirm/risk/fee/limit/masking.
- Focused feature tests pass.
- `flutter analyze` passes.
- Responsive visual QA passes for touched P0 routes.
- Token debt trends down.

PHASE P4 - EXPANSION MODULES
Process modules in this order:

1. Predictions
2. Arena
3. Earn
4. DCA
5. Launchpad
6. Referral/Rewards
7. Admin/internal dashboards

Rules:
- Predictions may use wallet/value positions, orders, probability, receipts,
  rewards, and P/L language.
- Arena may use Arena Points, points pool, completion, challenge, fair play,
  ledger entries.
- Arena must not use payout, wallet, profit, PnL, or stake-return language.
- Admin/dev/tool dashboards may keep documented exceptions for dense data or
  charts, but exceptions must be recorded by the audit.

P4 acceptance gate:
- Module identity remains an accent layer only.
- No local module-specific surface/background system.
- Token debt trends down.
- Product boundary tests still pass.

PHASE P5 - CI ENFORCEMENT
Only start P5 after P0-P4 have created a stable baseline.

Tasks:
1. Add token audit to quality gate in warning mode if needed.
2. Add stricter fail threshold for new/touched files.
3. Add stricter fail threshold for P0 modules.
4. Update PR checklist.
5. Update future feature onboarding checklist.
6. Ensure CI can produce current reports.

P5 acceptance gate:
- New PRs cannot silently increase design-token debt.
- CI reports current token debt.
- PR checklist includes token drift.
- Future feature onboarding requires tokens/shared primitives.

WORKFLOW FOR EVERY BATCH:
Use this exact sequence:

1. Read active phase and acceptance gate.
2. Inspect current audit/report/source.
3. Pick the highest-priority incomplete item in the current phase.
4. State the batch scope in one short progress update.
5. Edit only files needed for that batch.
6. Format changed Dart files.
7. Run focused tests.
8. Run `flutter analyze` when code changes are non-trivial or touch shared
   components.
9. Re-run token audit if the batch changes token debt.
10. Update generated audit docs if applicable.
11. Confirm the phase checklist item is complete or still pending.
12. Continue to the next item in the same phase.

DO NOT SKIP CHECKLIST ITEMS:
- If an item looks already done, verify it from source/tests/reports.
- If an item is not applicable, document why.
- If an item is blocked, attempt a concrete fix at least three times before
  declaring it blocked.
- Do not move to a later phase because the current phase is tedious.

ANTI-MESSY-UI CHECKLIST:
Before finishing any UI batch, verify:

- Typography hierarchy is clear: page title, section title, body, caption,
  amount, badge.
- Text is not too small to read on 360 px.
- Text does not overlap icons/buttons/cards.
- Card padding is consistent with neighboring cards.
- Card radius matches shared tokens.
- Buttons have stable height and icon/text alignment.
- There is no new random accent color.
- There is no new decorative visual noise.
- The screen shows more useful content, not just smaller content.
- Financial risk/disclosure text is still visible.
- Bottom nav and sticky footers do not hide important content.

ALLOWED EXCEPTIONS:
Exceptions are allowed only when documented by the audit:

- Custom chart painters
- Order book/canvas-like dense market widgets
- Dev/internal route checker tools
- Fullscreen chart/trading tools
- Highly specialized visual QA frames
- One-off risk/security panel with clear product reason

Even for exceptions:
- Do not introduce local color palettes.
- Keep text readable.
- Keep product copy boundaries.
- Prefer extracting a local helper if the pattern repeats.

COMMANDS:
Run from `flutter_app/` unless stated otherwise:

```powershell
flutter pub get
dart format .
dart run tool/design_token_consistency_audit.dart
flutter analyze
flutter test --reporter=compact
```

Use focused tests for touched modules first. Use full tests when changing
shared tokens, shared layout, shared widgets, router behavior, or high-risk
financial flows.

FINAL SUCCESS CRITERIA:
The job is complete only when all of these are true:

1. P0-P5 are complete or documented with accepted exceptions.
2. Design token audit reports are current.
3. Token debt is below the target thresholds in the plan or has a documented
   migration baseline with no new debt.
4. Shared tokens cover typography, spacing, radius, sizing, density, and
   surfaces.
5. Home and P0 financial modules are visually consistent on 360 px and up.
6. No high-risk financial behavior was weakened.
7. Product copy boundaries still pass.
8. `flutter analyze` passes.
9. Focused tests for touched modules pass.
10. Relevant quality tests pass.

FINAL RESPONSE RULE:
If everything is complete, the final response must include:

DESIGN TOKENIZATION COMPLETE

If forced to stop before completion, the final line of the response must be:

RESUME FROM: P<phase number> - <specific checklist item or module batch>

Do not write anything after the `RESUME FROM:` line.
````
