# VitTrade Docs Index

Load docs **on demand** — do not paste large audit output into chat. Shared rules:
[AI_PROMPT_SHELL.md](01_AI_RULES/AI_PROMPT_SHELL.md).

## Always-on (short)

| File | When |
| --- | --- |
| [AGENTS.md](../AGENTS.md) | Every session (workspace rule) |
| [DESIGN.md](../DESIGN.md) | UI work — tokens + component ladder |
| [00_START_HERE.md](00_START_HERE.md) | First time / architecture |
| [AI_EXECUTION_CONTRACT.md](01_AI_RULES/AI_EXECUTION_CONTRACT.md) | Execution gate |
| [DOCUMENT_PRECEDENCE.md](01_AI_RULES/DOCUMENT_PRECEDENCE.md) | Doc conflicts |

## Status and remaining work

| File | When |
| --- | --- |
| [ke-hoac-tong-the.md](02_FLUTTER_MIGRATION/ke-hoac-tong-the.md) | Project dashboard + completed migration summary |
| [ke-hoach-san-sang-production.md](02_FLUTTER_MIGRATION/ke-hoach-san-sang-production.md) | Production readiness — what is done vs blocked |

## Flutter standards

| File | When |
| --- | --- |
| [Flutter-Design-System-Reference.md](02_FLUTTER_MIGRATION/Flutter-Design-System-Reference.md) | **Required entry point for all UI/UX work** — routes to every domain's `*-Standard.md`, what enforces it, and the command to check it locally |
| [Flutter-App-Foundation.md](02_FLUTTER_MIGRATION/Flutter-App-Foundation.md) | App bootstrap, layers |
| [Flutter-Native-Design-Standard.md](02_FLUTTER_MIGRATION/standards/Flutter-Native-Design-Standard.md) | Native UI rules |
| [Flutter-Module-Identity-Standard.md](02_FLUTTER_MIGRATION/standards/Flutter-Module-Identity-Standard.md) | Module accents |
| [Flutter-Page-Archetype-Standard.md](02_FLUTTER_MIGRATION/standards/Flutter-Page-Archetype-Standard.md) | Tabbed-detail / form-wizard page patterns |
| [Flutter-Port-Master-Plan.md](02_FLUTTER_MIGRATION/Flutter-Port-Master-Plan.md) | Screen coverage tracker |
| [Flutter-Migration-Execution-Runbook.md](02_FLUTTER_MIGRATION/checklists/Flutter-Migration-Execution-Runbook.md) | Standard workflow |
| [Flutter-Design-Tokens.md](02_FLUTTER_MIGRATION/Flutter-Design-Tokens.md) | Token file map |
| [Flutter-Component-Mapping.md](02_FLUTTER_MIGRATION/Flutter-Component-Mapping.md) | Vit* widget ladder |
| [Page-Rhythm-Standard.md](02_FLUTTER_MIGRATION/standards/Page-Rhythm-Standard.md) | Mandatory page spacing / rhythm |
| [Page-Rhythm-Visual-QA-Checklist.md](02_FLUTTER_MIGRATION/checklists/Page-Rhythm-Visual-QA-Checklist.md) | 360px visual QA flows (Phase 6 — 12 flows) |
| [Card-Tile-Standard.md](02_FLUTTER_MIGRATION/standards/Card-Tile-Standard.md) | Mandatory fixed-height card tiles |
| [Service-Tile-Badge-Standard.md](02_FLUTTER_MIGRATION/standards/Service-Tile-Badge-Standard.md) | Mandatory Tier B corner badge safe inset |
| [Task-Card-Standard.md](02_FLUTTER_MIGRATION/standards/Task-Card-Standard.md) | Mandatory Tier E mission task rows (`VitTaskCard`) |
| [Accent-Icon-Box-Standard.md](02_FLUTTER_MIGRATION/standards/Accent-Icon-Box-Standard.md) | Mandatory module accent icon boxes (`VitAccentIconBox`) |
| [Segment-Pill-Standard.md](02_FLUTTER_MIGRATION/standards/Segment-Pill-Standard.md) | Mandatory segment/tab/filter pill tiers (S1–S4) |
| [Segment-Pill-Migration-Execution-Plan.md](02_FLUTTER_MIGRATION/checklists/Segment-Pill-Migration-Execution-Plan.md) | Segment pill migration status (0 locals, 0 warn) |
| [Card-Tile-Compliance-Report.md](02_FLUTTER_MIGRATION/audits/Card-Tile-Compliance-Report.md) | Card tile audit status (993/993 pass) |
| [Top-Header-Standard.md](02_FLUTTER_MIGRATION/standards/Top-Header-Standard.md) | Mandatory header behavior/actions/global-access/visual-archetype (4 sub-domains) |
| [Back-Navigation-Standard.md](02_FLUTTER_MIGRATION/standards/Back-Navigation-Standard.md) | Mandatory back-control safe fallback + Home-entry contract |
| [Bottom-Sheet-Standard.md](02_FLUTTER_MIGRATION/standards/Bottom-Sheet-Standard.md) | Mandatory `showVitBottomSheet` usage |
| [Scroll-Physics-Standard.md](02_FLUTTER_MIGRATION/standards/Scroll-Physics-Standard.md) | Mandatory `ClampingScrollPhysics` everywhere |
| [Scroll-Auto-Hide-Standard.md](02_FLUTTER_MIGRATION/standards/Scroll-Auto-Hide-Standard.md) | Mandatory collapse-budget gate for scroll-to-hide headers (no short-list snap-back) |
| [High-Risk-State-Standard.md](02_FLUTTER_MIGRATION/standards/High-Risk-State-Standard.md) | Mandatory `VitHighRiskStatePanel` for the 8 named high-risk pages |
| [Body-Component-Standard.md](02_FLUTTER_MIGRATION/standards/Body-Component-Standard.md) | Body layout/surface/controls/state grading (audit-only, not yet CI-enforced) |
| [UI-Density-Standard.md](02_FLUTTER_MIGRATION/standards/UI-Density-Standard.md) | `VitDensity` tiers + visual density risk (audit-only, not yet CI-enforced) |
| [Spacing-Token-Duplication-Standard.md](02_FLUTTER_MIGRATION/standards/Spacing-Token-Duplication-Standard.md) | Per-module literals that duplicate a core `AppSpacing.x1..x7` scale step |
| [Guidelines.md](03_DESIGN_SYSTEM/Guidelines.md) | Product + design rules |

## Ponytail audit (over-engineering)

| File | When |
| --- | --- |
| [ke-hoach-ponytail-audit-toan-module.md](02_FLUTTER_MIGRATION/checklists/ke-hoach-ponytail-audit-toan-module.md) | Audit từng module v2.1 — khối HANDOFF Section 1.2 + bảng prompt Section 13 |
| `.codex/skills/ponytail-audit/SKILL.md` | Skill ledger-only (không fix trong audit turn) |
| `.codex/skills/vittrade-minimal-review/SKILL.md` | Fix batch sau audit |

## Claude Code subagents (.claude/agents/)

Claude Code sessions only — dispatched via the Agent tool, not directly
usable from Cursor/Codex (different runtime). Each file is a self-contained
runbook; readable and followable by any AI even without the dispatch
mechanism.

| File | When |
| --- | --- |
| `.claude/agents/flutter-batch-planner.md` | Split a large migration/rollout into 5-10 file batches |
| `.claude/agents/flutter-batch-builder.md` | Implement one pre-scoped batch |
| `.claude/agents/flutter-screen-designer.md` | Design/build a new screen or deliberate redesign |
| `.claude/agents/flutter-domain-auditor.md` | Check one or more design-consistency domains |
| `.claude/agents/flutter-diff-trimmer.md` | Trim over-engineering in the current diff |
| `.claude/agents/flutter-architecture-sweep.md` | Whole-module debt sweep (dead code/circular/god-class) — Claude Code counterpart to ponytail-audit above |
| `.claude/agents/flutter-button-wiring-auditor.md` | Check button/data-flow wiring — dead `onPressed`/`onTap` handlers, gap route/navigation-edge audits don't cover |
| `.claude/agents/flutter-test-writer.md` | Write unit/controller/widget tests |
| `.claude/agents/flutter-test-coverage-auditor.md` | Check structural test-coverage gaps |
| `.claude/agents/flutter-pr-gate.md` | Full PR merge-readiness gate |

## Checklists

| File | When |
| --- | --- |
| [Future-Feature-Onboarding-Checklist.md](02_FLUTTER_MIGRATION/checklists/Future-Feature-Onboarding-Checklist.md) | New feature / route |
| [Enterprise-PR-Review-Checklist.md](02_FLUTTER_MIGRATION/checklists/Enterprise-PR-Review-Checklist.md) | Pre-merge review |
| [Flutter-Manual-Smoke-Checklist.md](02_FLUTTER_MIGRATION/checklists/Flutter-Manual-Smoke-Checklist.md) | Manual QA |
| [Flutter-Visual-QA.md](02_FLUTTER_MIGRATION/checklists/Flutter-Visual-QA.md) | Visual QA notes |

## Backend handoff

| File | When |
| --- | --- |
| `docs/02_FLUTTER_MIGRATION/*-Backend-Contract-Skeleton.md` | Remote API integration per module |

## Architecture

| File | When |
| --- | --- |
| [VitTrade-Enterprise-Architecture-Report.md](05_ARCHITECTURE/VitTrade-Enterprise-Architecture-Report.md) | Architecture reference |

## Screen references (on demand)

| File | When |
| --- | --- |
| [HomePage-Flutter-Native-Standard.md](04_SCREEN_REFERENCES/home/HomePage-Flutter-Native-Standard.md) | Home module work |
| [ke-hoach-redesign-theo-module.md](02_FLUTTER_MIGRATION/redesign/ke-hoach-redesign-theo-module.md) | **Redesign v2.5** — routing; entry → EXECUTION-PLAYBOOK |
| [prompt-redesign/EXECUTION-PLAYBOOK.md](02_FLUTTER_MIGRATION/prompt-redesign/EXECUTION-PLAYBOOK.md) | **66 bước** copy-paste tuần tự — 66/66 done, không còn batch pending |
| [prompt-redesign/REDESIGN-CONTRACT.md](02_FLUTTER_MIGRATION/prompt-redesign/REDESIGN-CONTRACT.md) | Contract chung mọi batch |
| [ke-hoach-redesign-batches.csv](02_FLUTTER_MIGRATION/redesign/ke-hoach-redesign-batches.csv) | 66 batch — `status` · `tier` · prompts |
| [VitTrade-Screen-Redesign-Checklist.csv](02_FLUTTER_MIGRATION/redesign/VitTrade-Screen-Redesign-Checklist.csv) | 416 màn — lọc theo batch |
| [prompt-redesign/README.md](02_FLUTTER_MIGRATION/prompt-redesign/README.md) | 11 hub Tier A + Trade sub-hubs |
| [prompt-redesign/trading-bots-hub.md](02_FLUTTER_MIGRATION/prompt-redesign/trading-bots-hub.md) | SC-059 — batch `RD-T02` (Trade sub-hub) |

## Audit tools (run from `flutter_app/`)

Prefer tools over static markdown dumps:

```bash
dart run tool/design_token_consistency_audit.dart --check
dart run tool/body_component_consistency_audit.dart --check
dart run tool/route_coverage_audit.dart --check
dart run tool/navigation_edge_audit.dart --check
```

Generated CSV artifacts live under `docs/02_FLUTTER_MIGRATION/` when tools emit them.

## Cursor AI setup

| Resource | Purpose |
| --- | --- |
| `~/.cursor/mcp.json` (Home) | `gitnexus`, `dart` |
| [.cursor/mcp.json](../.cursor/mcp.json) (Workspace) | `headroom` only |
| [.cursor/rules/](../.cursor/rules/) | Cursor agent rules |
| [scripts/Start-CursorSession.ps1](../scripts/Start-CursorSession.ps1) | Daily startup |

Policy: use **Cursor Auto**; optimize via batch/GitNexus/Headroom.

## Removed docs (2026-07-02)

Completed migration plans, AI execution prompts, and audit markdown dumps were
removed. Summary preserved in
[ke-hoac-tong-the.md](02_FLUTTER_MIGRATION/ke-hoac-tong-the.md) § Completed
migrations. Full history: git log on `docs/`.

## Removed docs (2026-07-10)

Orphaned/superseded artifacts with zero repo references removed: Card Tile
execution-plan/checklist (993/993 closed), the VitTrade UI Redesign v2.5
pending-batch trackers (66/66 closed), 4 stale/abandoned CSV dumps in
`02_FLUTTER_MIGRATION/`, and `03_DESIGN_SYSTEM/VitTrade-Whole-App-P2-P3-Assignment-Ledger.csv`.
Summary preserved in
[ke-hoac-tong-the.md](02_FLUTTER_MIGRATION/ke-hoac-tong-the.md) § Completed
migrations. Full history: git log on `docs/`.
