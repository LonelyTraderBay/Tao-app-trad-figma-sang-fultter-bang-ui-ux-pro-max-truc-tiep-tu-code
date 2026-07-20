# Claude Code harness (VitTrade)

Maps P0–P2 adoption from
[claude-code-best-practice](https://github.com/shanraisshan/claude-code-best-practice)
onto this repo. Product rules stay in root `AGENTS.md`.

## Commands

| Command | Role |
| --- | --- |
| `/vt-verify` | Canonical format + route/nav + analyze + tests |
| `/vt-audit <domains\|all>` | Named design-domain audits |
| `/vt-batch [scope]` | Plan → Build → Trim → Verify (one batch) |
| `/vt-review [focus]` | Pre-merge five-axis + product-verify |

## Skills (`.claude/skills/`)

| Skill | Trigger |
| --- | --- |
| `vittrade-minimal-review` | Batch bloat / ponytail review |
| `vittrade-ui-checklists` | UI build/polish |
| `vittrade-design-domain` | Domain → audit command lookup |
| `vittrade-batch-gate` | End-of-batch verify evidence |
| `vittrade-product-verify` | High-risk financial flows |
| `code-review-and-quality` | Pre-merge axes |

Cursor/Codex continues to use `.codex/skills/` — discovery is not shared.

## Agents with skill preload

- `flutter-batch-builder` ← minimal-review, design-domain, batch-gate, ui-checklists
- `flutter-domain-auditor` ← design-domain
- `flutter-diff-trimmer` ← minimal-review
- `flutter-batch-planner` ← design-domain
- `flutter-pr-gate` ← code-review, product-verify, design-domain
- `flutter-screen-designer` ← ui-checklists, product-verify, design-domain

## Parallel batches

Use git worktrees (`git worktree add` / Claude `--worktree` /
`isolation: worktree`). One writer per overlapping file set.

## Explicitly out of scope

- Ralph / overnight autonomous loops on financial UI
- Dumping mega agent/skill packs (ECC, agency-agents)
- gstack plan/design skills (conflict with VitTrade prompts)
