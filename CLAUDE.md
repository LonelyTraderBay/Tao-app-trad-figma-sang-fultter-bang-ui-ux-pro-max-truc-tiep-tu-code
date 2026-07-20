# CLAUDE.md — VitTrade (Claude Code entry point)

Claude Code reads this file, NOT `AGENTS.md`. The import below loads the
cross-tool project contract exactly once — do not duplicate its content here.

@AGENTS.md

## Claude Code–specific deltas

These adjust AGENTS.md for what is actually available in Claude Code sessions:

- **GitNexus MCP is unavailable here** (Cursor-only). The GitNexus MUST-rules
  in AGENTS.md map to the `tokensave` MCP server instead:
  `impact` → `tokensave_impact` · `context` → `tokensave_context` /
  `tokensave_callers` · `query` → `tokensave_search` ·
  `detect_changes` → `tokensave_diff_context` / `tokensave_affected`.
  The obligations stand: report blast radius before editing a symbol; warn on
  high-risk impact.
- **RTK shell hook**: Bash commands are rewritten through `rtk` (see global
  RTK.md). A 0-match result from `grep`/`find` via the Bash tool is
  unreliable — verify with the native Grep/Read tools before concluding
  "no matches".
- **Verification**: `/vt-verify` runs the canonical block (pub get → format →
  route/nav audits → analyze → tests). `/vt-audit <domains>` runs named
  design-consistency audits. `/vt-batch` orchestrates Plan → Build → Trim →
  Verify for one scoped batch. `/vt-review` runs the pre-merge quality axes.
  Prefer these over hand-typed command chains.
- **Session discipline (P0)**: keep context under ~40% (statusline warns);
  new task or new batch ⇒ new session (`/clear`) or `/compact` with a hint;
  prefer `/rewind` over stacking failed fixes in the same context; challenge
  before PR (“prove this works” / grill the diff vs `main`); keep PRs small
  (one batch / one feature, ~5–10 files). Details:
  `.claude/rules/session-discipline.md`.
- **Skills**: project skills live in `.claude/skills/*/SKILL.md` (Claude Code).
  Cursor/Codex mirrors remain under `.codex/skills/` — do not assume one
  runtime sees the other. Prefer Skill tool / agent `skills:` preload over
  pasting full skill text into chat.
- **Path-scoped deep rules** live in `.claude/rules/*.md` and lazy-load when
  matching files are touched (UI standards, state/providers, i18n, financial
  safety, testing, audit tools, router, minimal diff). Do not paste their
  content into this file.
- **Auto-format hook**: a PostToolUse hook runs `dart format` on every edited
  `.dart` file (`.claude/hooks/format_dart.py`). Do not run manual formatting
  passes after single-file edits; `dart format --set-exit-if-changed .` stays
  in `/vt-verify` as the CI-parity gate.
- **Other hooks & statusline**: `.claude/hooks/usage_log.py` (PreToolUse)
  counts Agent/Skill invocations into `.claude/data/usage-log.jsonl`;
  `.claude/hooks/verify_nudge.py` (Stop) nudges once toward `/vt-verify` when
  `.dart` files were edited without a later test run — say why if you decline.
  `.claude/statusline.py` shows context % (compact proactively past 40%).
- **Agent memory**: `flutter-domain-auditor`, `flutter-pr-gate`, and
  `flutter-batch-builder` carry `memory: project` — durable gotchas live in
  `.claude/agent-memory/<agent>/MEMORY.md`, seeded from session-memory
  lessons. Route new agent-specific lessons there, not only into auto-memory.
- **Git**: `main` is branch-protected (PR + CI required). Work on feature
  branches; never commit directly to `main`.
- **Known fake failure**: on a fresh Windows worktree (`core.autocrlf=true`,
  repo-wide `eol=lf` fix still unmerged — branch b7b5c0d0), artifact-staleness
  and format guardrails can fail from CRLF alone. Before treating such a FAIL
  as real, check line endings; see `.claude/rules/audit-tools.md`.
- **Harness map**: `.claude/HARNESS.md` (commands, skills, agent preload,
  worktree parallel rules, explicit non-goals).
