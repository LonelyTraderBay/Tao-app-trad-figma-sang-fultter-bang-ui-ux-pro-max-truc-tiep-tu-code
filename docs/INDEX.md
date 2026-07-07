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
| [Flutter-App-Foundation.md](02_FLUTTER_MIGRATION/Flutter-App-Foundation.md) | App bootstrap, layers |
| [Flutter-Native-Design-Standard.md](02_FLUTTER_MIGRATION/Flutter-Native-Design-Standard.md) | Native UI rules |
| [Flutter-Module-Identity-Standard.md](02_FLUTTER_MIGRATION/Flutter-Module-Identity-Standard.md) | Module accents |
| [Flutter-Port-Master-Plan.md](02_FLUTTER_MIGRATION/Flutter-Port-Master-Plan.md) | Screen coverage tracker |
| [Flutter-Migration-Execution-Runbook.md](02_FLUTTER_MIGRATION/Flutter-Migration-Execution-Runbook.md) | Standard workflow |
| [Flutter-Design-Tokens.md](02_FLUTTER_MIGRATION/Flutter-Design-Tokens.md) | Token file map |
| [Flutter-Component-Mapping.md](02_FLUTTER_MIGRATION/Flutter-Component-Mapping.md) | Vit* widget ladder |
| [Page-Rhythm-Standard.md](02_FLUTTER_MIGRATION/Page-Rhythm-Standard.md) | Mandatory page spacing / rhythm |
| [Page-Rhythm-Visual-QA-Checklist.md](02_FLUTTER_MIGRATION/Page-Rhythm-Visual-QA-Checklist.md) | 360px visual QA flows (Phase 6 — 12 flows) |
| [Card-Tile-Standard.md](02_FLUTTER_MIGRATION/Card-Tile-Standard.md) | Mandatory fixed-height card tiles |
| [Service-Tile-Badge-Standard.md](02_FLUTTER_MIGRATION/Service-Tile-Badge-Standard.md) | Mandatory Tier B corner badge safe inset |
| [Task-Card-Standard.md](02_FLUTTER_MIGRATION/Task-Card-Standard.md) | Mandatory Tier E mission task rows (`VitTaskCard`) |
| [Accent-Icon-Box-Standard.md](02_FLUTTER_MIGRATION/Accent-Icon-Box-Standard.md) | Mandatory module accent icon boxes (`VitAccentIconBox`) |
| [Segment-Pill-Standard.md](02_FLUTTER_MIGRATION/Segment-Pill-Standard.md) | Mandatory segment/tab/filter pill tiers (S1–S4) |
| [Segment-Pill-Migration-Execution-Plan.md](02_FLUTTER_MIGRATION/Segment-Pill-Migration-Execution-Plan.md) | Segment pill migration status (0 locals, 0 warn) |
| [Card-Tile-Migration-Execution-Plan.md](02_FLUTTER_MIGRATION/Card-Tile-Migration-Execution-Plan.md) | Card tile audit status (993/993 pass) |
| [Guidelines.md](03_DESIGN_SYSTEM/Guidelines.md) | Product + design rules |

## Ponytail audit (over-engineering)

| File | When |
| --- | --- |
| [ke-hoach-ponytail-audit-toan-module.md](02_FLUTTER_MIGRATION/ke-hoach-ponytail-audit-toan-module.md) | Audit từng module v2.1 — khối HANDOFF Section 1.2 + bảng prompt Section 13 |
| `.codex/skills/ponytail-audit/SKILL.md` | Skill ledger-only (không fix trong audit turn) |
| `.codex/skills/vittrade-minimal-review/SKILL.md` | Fix batch sau audit |

## Checklists

| File | When |
| --- | --- |
| [Future-Feature-Onboarding-Checklist.md](02_FLUTTER_MIGRATION/Future-Feature-Onboarding-Checklist.md) | New feature / route |
| [Enterprise-PR-Review-Checklist.md](02_FLUTTER_MIGRATION/Enterprise-PR-Review-Checklist.md) | Pre-merge review |
| [Flutter-Manual-Smoke-Checklist.md](02_FLUTTER_MIGRATION/Flutter-Manual-Smoke-Checklist.md) | Manual QA |
| [Flutter-Visual-QA.md](02_FLUTTER_MIGRATION/Flutter-Visual-QA.md) | Visual QA notes |

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
| [ke-hoach-redesign-theo-module.md](02_FLUTTER_MIGRATION/ke-hoach-redesign-theo-module.md) | **Redesign v2.5** — routing; entry → EXECUTION-PLAYBOOK |
| [prompt-redesign/EXECUTION-PLAYBOOK.md](02_FLUTTER_MIGRATION/prompt-redesign/EXECUTION-PLAYBOOK.md) | **66 bước** copy-paste tuần tự |
| [prompt-redesign/CHECKLIST-26-PENDING-BATCHES.md](02_FLUTTER_MIGRATION/prompt-redesign/CHECKLIST-26-PENDING-BATCHES.md) | **26 batch còn lại** — số màn thiếu / file cụ thể |
| [prompt-redesign/EXECUTION-PENDING-4-LAST.md](02_FLUTTER_MIGRATION/prompt-redesign/EXECUTION-PENDING-4-LAST.md) | **5 chat cuối** — 4 batch · 11 màn · final gate |
| [prompt-redesign/EXECUTION-PENDING-FINAL.md](02_FLUTTER_MIGRATION/prompt-redesign/EXECUTION-PENDING-FINAL.md) | Alias — cùng nội dung pending hiện tại |
| [prompt-redesign/REDESIGN-CONTRACT.md](02_FLUTTER_MIGRATION/prompt-redesign/REDESIGN-CONTRACT.md) | Contract chung mọi batch |
| [ke-hoach-redesign-batches.csv](02_FLUTTER_MIGRATION/ke-hoach-redesign-batches.csv) | 66 batch — `status` · `tier` · prompts |
| [VitTrade-Screen-Redesign-Checklist.csv](02_FLUTTER_MIGRATION/VitTrade-Screen-Redesign-Checklist.csv) | 416 màn — lọc theo batch |
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
