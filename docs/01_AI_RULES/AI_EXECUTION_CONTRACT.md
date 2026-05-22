# AI Execution Contract

These rules are mandatory for Flutter migration work.

## Flutter Migration Rules

- The migration must use a screen-by-screen workflow.
- Implement exactly one `SC-xxx` screen per task unless the user explicitly instructs otherwise.
- Do not implement a whole module in one pass.
- Do not batch unrelated screens only because they share a module.
- A screen is not done until Flutter UI, navigation, BE contract, and visual QA are checked.
- Phases in the master plan define order only; each phase is still executed one screen at a time.
- When doing Flutter migration work, use `docs/02_FLUTTER_MIGRATION/Flutter-Migration-Execution-Runbook.md` as the execution order.
- If the runbook and another Flutter foundation doc both describe order, the runbook controls order and the foundation doc provides technical detail.
- Before implementing a Flutter screen, check the Flutter foundation docs for app structure, native design standard, tokens, component mapping, routing, and visual QA.
- Do not invent new Flutter styling if `Flutter-Design-Tokens.md` or `Flutter-Component-Mapping.md` already defines the token or shared widget.
- `SC-007 HomePage` is the required Flutter native standard for color, sizing, chrome, card treatment, and shared component scale.
- React screenshots may define `ShellRenderMode.visualQa` parity; they must not reintroduce legacy blue brand styling or screen-local palettes into `ShellRenderMode.native`.

## Required Workflow For One Screen

1. Open the target `SC-xxx` row in `docs/02_FLUTTER_MIGRATION/Flutter-Port-Master-Plan.md`.
2. Open its viewport and full-page screenshots under `output/flutter-ui-reference/screenshots/`.
3. Read the React source from the `Source File Index` in the master plan.
4. Check `Flutter-Native-Design-Standard.md`, `Flutter-Design-Tokens.md`, `Flutter-Component-Mapping.md`, and `Flutter-Navigation-Routing.md`.
5. Build the Flutter screen with mock data first.
6. Wire only the navigation edges needed for that screen.
7. Add or update only the BE contract needed for that screen.
8. Capture/compare the Flutter result against both reference screenshots in visual-QA mode.
9. Re-check native runtime color, spacing, card, CTA, and bottom-nav treatment against the Home standard.
10. Tick Flutter, BE, and QA status only after the screen passes acceptance checks.

## Domain Boundary Rules

- Prediction Markets are wallet/value-based.
- Open Arena is Arena Points only.
- Do not merge Prediction wallet/PnL/history with Arena points/pool/ledger.
- Safe bridge surfaces are discovery, topic/category, event context, creator discovery, and profile sections, but the BE domains remain separate.

## Completion Rule

If any required source, screenshot, navigation edge, BE state, or QA result is missing, mark the screen as incomplete and record the gap instead of silently skipping it.
