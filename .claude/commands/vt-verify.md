---
description: Run the canonical VitTrade verification block (pub get, format, route/nav audits, analyze, tests)
allowed-tools: Bash(cd flutter_app && *)
context: fork
---

Run these steps in order, stopping to report the first failure (but still
running the rest if the user asked for a full report). Run each step as its
own `cd flutter_app && <command>` invocation — that is the exact shape the
`allowed-tools` grant covers:

```bash
cd flutter_app && flutter pub get
cd flutter_app && dart format --output=none --set-exit-if-changed .
cd flutter_app && dart run tool/route_coverage_audit.dart --check
cd flutter_app && dart run tool/navigation_edge_audit.dart --check
cd flutter_app && flutter analyze
cd flutter_app && flutter test --reporter=compact
```

This is the "Default Verification" block from `docs/00_START_HERE.md` /
`docs/01_AI_RULES/AI_PROMPT_SHELL.md` — the minimum bar before considering
any change done. It is **not** the same as the built-in `/run` skill,
which drives the running app end-to-end; this command only runs static
checks and the test suite.

Report each step's pass/fail status. If `dart format` reports changed
files, list them. If any audit or test fails, show the relevant failure
output, not just "failed."

You run in a forked context (`context: fork`): raw command logs stay here
and are discarded — only your final report returns to the caller. So the
final report must be self-contained and compact: one PASS/FAIL line per
step, then ONLY the failing excerpts (file paths, failing test names,
reason codes, counts). Never paste full passing logs back.
