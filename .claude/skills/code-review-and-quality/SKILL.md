---
name: code-review-and-quality
description: >
  When reviewing VitTrade code before merge — correctness, readability,
  architecture, security, and performance axes. Use before opening a PR,
  after a batch lands, or when asked to review changes. Prefer /vt-review
  as the entry point.
---

# Code review (VitTrade)

Approve when the change improves overall code health and follows project
conventions — not only when it is “how you would have written it.”

## Five axes (brief)

1. **Correctness** — matches task; edge/error paths; tests assert the right thing.
2. **Readability** — clear names; fewer lines when equivalent; no clever traps.
3. **Architecture** — `features/<f>/{domain,data,presentation}`; providers in
   composition root; no dual-source-of-truth `setState` vs Riverpod.
4. **Security / financial** — preview+confirm on high-risk; mask PII; no
   secrets in diffs.
5. **Performance** — no rebuild bombs on hot lists; no expensive filters in
   scroll paths without cause.

## VitTrade must-check

- Prediction Markets ≠ Open Arena copy/currency mix.
- vi-VN user-facing strings (đủ dấu); no new English product copy.
- Design domains touched have audit/guardrail evidence or `/vt-audit`.
- Notice ack uses `showVitNoticeSheet` for success/error must-ack.
- Blast radius: tokensave `impact` / `detect_changes` (or GitNexus on Cursor)
  before claiming “safe.”

## Output shape

- Blocking issues first (must fix).
- Then non-blocking nits.
- End with **Approve** / **Approve with nits** / **Request changes**.

## Gotchas

- Do not re-litigate an approved batch plan’s required scope as “too large.”
- CRLF on Windows can fake format/guardrail failures — check EOL before FAIL.
- Diff-trimmer owns bloat; this skill owns correctness/safety.
