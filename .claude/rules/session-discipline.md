# Session discipline (always on)

Harness habits from Claude Code best practice, tuned for VitTrade. Authority
for product/financial rules remains root `AGENTS.md`.

## Context

- Treat ~40% context as the soft ceiling for intelligence-sensitive work
  (statusline already nudges past 40%). Past ~60% only for trivial follow-ups.
- Prefer `/compact focus on <topic>` with an explicit hint over waiting for
  autocompact.
- Offload exploration to subagents when the parent only needs the conclusion
  (file reads + greps stay in the child).

## Session boundaries

- New task or new migration batch ⇒ new session (`/clear`) unless the next
  step truly needs the prior transcript (e.g. applying findings just produced).
- After a failed attempt: `/rewind` (or double-Esc) and re-prompt with what
  you learned — do not leave dead-end tool noise in context.
- Mid-task fuzzy continuity → `/compact`. High-stakes next step → `/clear` +
  a short handoff brief you control.

## Batch & PR size

- One implementation chat = one batch (5–10 files) unless the user scoped
  otherwise. After the batch verifies, stop and start a fresh chat for the
  next batch.
- Prefer small PRs (one feature / one domain rollout slice). Squash-merge is
  the project default on `main` (branch protection).

## Challenge before ship

Before calling a batch or PR done, either:

- Run `/vt-verify` (or focused analyze + tests the plan names), and
- Ask (or self-ask): “prove this works” — cite passing commands, not vibes.

## Parallel work

- Parallel migration batches use **git worktrees** (Claude `--worktree` /
  agent `isolation: worktree`, or manual worktrees). Never two writers on the
  same working tree for overlapping files.
- Do not run Ralph-style overnight autonomous loops on financial or
  high-risk UI without an explicit human gate.

## Dual runtime

- Cursor sessions: GitNexus MCP + Cursor Auto policy.
- Claude Code sessions: tokensave MCP + `/vt-*` commands + `.claude/skills`.
- Map GitNexus → tokensave as in root `CLAUDE.md`; never invent a third
  navigation stack.
