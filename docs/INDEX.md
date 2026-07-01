# VitTrade Docs Index

Pick **one** task prompt + **one** paired plan per session. Do not load multiple
large files in one turn. Shared rules: [AI_PROMPT_SHELL.md](01_AI_RULES/AI_PROMPT_SHELL.md).

## Always-on (short)

| File | Lines | When |
| --- | ---: | --- |
| [AGENTS.md](../AGENTS.md) | ~194 | Every session (workspace rule) |
| [00_START_HERE.md](00_START_HERE.md) | 77 | First time / architecture work |
| [AI_EXECUTION_CONTRACT.md](01_AI_RULES/AI_EXECUTION_CONTRACT.md) | 42 | Execution gate |
| [DOCUMENT_PRECEDENCE.md](01_AI_RULES/DOCUMENT_PRECEDENCE.md) | 34 | Doc conflicts |

## Orchestration

| File | Lines | When |
| --- | ---: | --- |
| [AI-Sequential-Execution-Backlog.md](02_FLUTTER_MIGRATION/AI-Sequential-Execution-Backlog.md) | 2079 | No specific task — read **current packet only** |
| [AI_PROMPT_SHELL.md](01_AI_RULES/AI_PROMPT_SHELL.md) | ~100 | Referenced by all autonomous prompts |

## Top execution prompts (load one)

| File | Lines | Paired plan |
| --- | ---: | --- |
| [AI-A-Grade-Body-Component-Upgrade-Autonomous-Execution-Prompt.md](02_FLUTTER_MIGRATION/AI-A-Grade-Body-Component-Upgrade-Autonomous-Execution-Prompt.md) | ~750 | VitTrade-A-Grade-Body-Component-Upgrade-Plan.md |
| [AI-Button-System-Standardization-Autonomous-Execution-Prompt.md](03_DESIGN_SYSTEM/AI-Button-System-Standardization-Autonomous-Execution-Prompt.md) | ~700 | VitTrade-Button-System-Standardization-Execution-Plan.md |
| [AI-Home-UI-Project-Wide-Standardization-Deep-Autonomous-Execution-Prompt.md](02_FLUTTER_MIGRATION/AI-Home-UI-Project-Wide-Standardization-Deep-Autonomous-Execution-Prompt.md) | ~350 | VitTrade-Home-UI-Project-Wide-Standardization-Deep-Plan.md |
| [AI-Enterprise-UI-UX-Synchronization-Autonomous-Execution-Prompt.md](02_FLUTTER_MIGRATION/AI-Enterprise-UI-UX-Synchronization-Autonomous-Execution-Prompt.md) | 624 | Enterprise UI sync plan |
| [AI-Whole-App-UI-Optimization-Autonomous-Execution-Prompt.md](03_DESIGN_SYSTEM/AI-Whole-App-UI-Optimization-Autonomous-Execution-Prompt.md) | 693 | Whole-App UI Optimization tracking plan |

Full list: `rg --files docs -g 'AI-*Execution-Prompt.md' -g '*Autonomous*Prompt.md'`

## Large plans (section-read only)

| File | Lines | Warning |
| --- | ---: | --- |
| VitTrade-Shared-Components-Home-Standard-Implementation-Plan.md | 12143 | Read checklist sections only |
| VitTrade-Enterprise-Grade-UI-Standardization-Plan.md | 7007 | Section headers + active phase |
| Wallet-UI-Home-Standardization-Plan.md | 3780 | Section headers + active phase |
| Flutter-Enterprise-Clean-Codebase-Master-Plan.md | 1923 | Section headers + active phase |

## Audits (tool output, not chat dump)

| File | Lines | Use |
| --- | ---: | --- |
| VitTrade-Design-Token-Consistency-Audit.md | 2802 | `dart run tool/design_token_consistency_audit.dart --check` |
| VitTrade-Body-Component-Consistency-Audit.md | varies | `dart run tool/body_component_consistency_audit.dart` |

Prefer audit **tools** + Headroom compress over pasting CSV/audit markdown into chat.

## Cursor AI setup

| Resource | Purpose |
| --- | --- |
| [.cursor/mcp.json](../.cursor/mcp.json) | headroom + gitnexus MCP |
| [.cursor/rules/](../.cursor/rules/) | Cursor agent rules |
| [scripts/headroom/README.md](../scripts/headroom/README.md) | Headroom daily start |
| [scripts/Start-CursorSession.ps1](../scripts/Start-CursorSession.ps1) | Morning checklist |
| [vittrade-minimal-diff.mdc](../.cursor/rules/vittrade-minimal-diff.mdc) | Auto when editing `flutter_app/**` — minimal diff, keep quality |
| Policy | Luôn dùng **Cursor Auto**; tối ưu qua batch/GitNexus/Headroom, không chọn model thủ công |

## GitNexus index

Local only (~730MB). Not committed. Refresh: `.\scripts\gitnexus\Refresh-Index.ps1`
