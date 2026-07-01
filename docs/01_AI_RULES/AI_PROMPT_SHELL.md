# AI Prompt Shell (shared contract)

Use this file for all VitTrade autonomous execution prompts. Task-specific prompts
must reference this shell instead of duplicating boilerplate.

## Repository

- Root: VitTrade Flutter mono-repo (relative paths only — no hardcoded drive letters).
- App: `flutter_app/`
- Router: `flutter_app/lib/app/router/app_router.dart`
- Tests: `flutter_app/test/`
- Artifacts: `flutter_app/run-artifacts/`

## Precedence

1. User instruction in the current conversation.
2. `AGENTS.md`
3. `.cursor/rules/*.mdc`
4. `docs/00_START_HERE.md`, `docs/01_AI_RULES/AI_EXECUTION_CONTRACT.md`
5. Active task execution prompt (scope only — does not override product boundaries).
6. Flutter source and tests.

See `docs/01_AI_RULES/DOCUMENT_PRECEDENCE.md`.

## Non-stop execution

Continue automatically until:

1. Task acceptance gates pass, or
2. A real blocker after ≥3 recovery attempts, or
3. Context limit forces handoff (`RESUME FROM: <phase> - <batch>`), or
4. User explicitly stops.

Invalid stop reasons: one batch done, one module done, analysis only, asking user
what's next when the plan defines the next step.

Completion line (when done): task-specific gate string from the active prompt.

Handoff line (when blocked): `RESUME FROM: <phase> - <batch/page>`

Do not write anything after the handoff line.

## GitNexus (MCP)

Before editing any symbol: `impact({target, direction: "upstream"})`.

Explore with `query()` / `context()` instead of repo-wide grep.

Before commit: `detect_changes()`.

Rename with GitNexus `rename`, not find-and-replace.

If index stale: `.\scripts\gitnexus\Refresh-Index.ps1`

## Headroom (MCP, Cursor-only)

Daily: `.\scripts\headroom\Start-VitTradeHeadroom.ps1`

Compress tool output >500 lines with `headroom_compress`; retrieve details with
`headroom_retrieve` when needed.

## Product boundaries

- Open Arena: points-only (no wallet/payout/profit/stake-return language).
- Prediction Markets: positions, probability, receipts, rewards, P/L.
- Financial flows: preview/confirm before high-risk actions.

## UI defaults

Shared primitives and theme tokens from `flutter_app/lib/shared/` and
`flutter_app/lib/app/theme/`. See `AGENTS.md` UI Rules and radius tiers.

## Verification (from `flutter_app/`)

```bash
flutter pub get
dart format --output=none --set-exit-if-changed .
dart run tool/route_coverage_audit.dart --check
dart run tool/navigation_edge_audit.dart --check
flutter analyze
flutter test --reporter=compact
```

Add task-specific audits/tests from the active plan. Run focused tests for touched
modules before marking a batch complete.

## Batch discipline

- 5–10 files per turn for migration work.
- New Cursor chat after each completed batch.
- Load one execution prompt + one plan per task — see `docs/INDEX.md`.
- Do not load backlog + full plan + full audit in one turn.

## Doc loading

Pick artifacts via `docs/INDEX.md`. For files >1000 lines, read section headers
and checklists only unless a specific section is required.

## Skills (selective)

| Task | Skill |
| --- | --- |
| UI review/polish | `.codex/skills/vittrade-ui-checklists/SKILL.md` |
| Pre-merge review | `.codex/skills/code-review-and-quality/SKILL.md` |
| GitNexus workflows | `.codex/skills/gitnexus-impact-analysis/SKILL.md` |
