---
description: Pre-merge VitTrade review — five-axis quality + product/financial gates
argument-hint: "[optional path or PR focus]"
allowed-tools: Agent, Skill, Read, Bash(cd flutter_app && *), Bash(git status *), Bash(git diff *), Bash(git log *), Bash(git status), Bash(git diff), Bash(git log *)
context: fork
---

# /vt-review

Focus (optional): $ARGUMENTS

Run a pre-merge review of the current branch diff vs the integration base
(usually `main`), or the paths in `$ARGUMENTS` if given.

1. `git status` + `git diff` (and `git log` / range vs main when useful).
2. Invoke Skill `code-review-and-quality` for the five axes.
3. If wallet / P2P / withdraw / security / address files appear in the diff,
   invoke Skill `vittrade-product-verify`.
4. Optionally invoke Agent `flutter-pr-gate` when the user asked for full
   merge-readiness (format, route/nav, analyze, guardrails, suite).
5. Optionally invoke Skill `vittrade-minimal-review` for bloat — do not
   duplicate the trimmer’s entire report if already run in `/vt-batch`.

## Output

- **Blocking** / **Nits** / **Verdict** (`Approve` | `Approve with nits` |
  `Request changes`)
- Cite commands you ran. Keep the final message self-contained (forked
  context).

Prefer this over pasting a generic review prompt. Built-in `/code-review`
remains available for Anthropic’s multi-agent review when desired.
