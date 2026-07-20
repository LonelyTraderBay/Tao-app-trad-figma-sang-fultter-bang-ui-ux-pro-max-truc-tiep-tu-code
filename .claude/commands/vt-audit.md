---
description: Run one or more named design-consistency domain audits (card-tile, page-rhythm, segment-pill, top-header-behavior, back-navigation, scroll-physics, spacing-token, page-content-width, ...)
argument-hint: <domain-name> [domain-name...] | all
allowed-tools: Read, Bash(cd flutter_app && *)
---

Domain(s) requested: $ARGUMENTS

Read `docs/02_FLUTTER_MIGRATION/Flutter-Design-System-Reference.md` §2 (the
audit-domain table) and find the row(s) whose "Domain" name matches what was
requested above. If `$ARGUMENTS` is `all`, use every row.

For each matched row, run from `flutter_app/`:

1. The exact command in the "Regenerate / check command" column.
2. The matching `flutter test test/quality/<guardrail test>.dart
   --reporter=compact` from the "Guardrail test" column, if one is listed.

Do not invent a command or flag that isn't in the table — several domains
require extra flags beyond a bare `--check` (e.g. `--strict-full` or
`--strict`); use exactly what the table says.

Report one line per domain: `<domain>: PASS|FAIL (<CI status>)`, using the
table's "CI status" column so the reader knows whether a FAIL here would
actually block CI or is audit-only/informational. For any FAIL, include a
short reason summary from the tool's own output.

If no domain name in `$ARGUMENTS` matches any row, list the available
domain names from the table instead of guessing.
