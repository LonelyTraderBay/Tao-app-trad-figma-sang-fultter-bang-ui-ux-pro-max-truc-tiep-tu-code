---
name: vittrade-design-domain
description: >
  When choosing or verifying a VitTrade design-consistency domain (page
  rhythm, card tile, segment pill, scroll auto-hide, notice acknowledgement,
  content width, etc.) — look up the exact audit command and guardrail test
  from Flutter-Design-System-Reference.md. Use before implementing a batch
  that names a domain, or when /vt-audit needs the right command.
---

# Design-domain lookup

## Always

1. Open `docs/02_FLUTTER_MIGRATION/Flutter-Design-System-Reference.md` § audit
   domain table.
2. Match the domain name the task or user gave (or infer from changed files).
3. Use **exactly** the regenerate/check command and flags from the table
   (often `--strict-full` or `--strict` — do not invent flags).
4. Run the listed `flutter test test/quality/<guardrail>.dart` when present.

## Prefer slash command

For multi-domain checks from the main thread: `/vt-audit <domain>…` or
`/vt-audit all`.

## Common domains (reminder only — table wins)

| Touching | Likely domain |
| --- | --- |
| Page scroll / section rhythm | page-rhythm, page-content-width |
| Horizontal strip tiles | card-tile |
| Tabs / MUA-BÁN / presets | segment-pill |
| Success/error after action | notice-acknowledgement |
| Header collapse on scroll | scroll-auto-hide |
| Routes / `context.go` | route-coverage, navigation-edges |

## Gotchas

- CI status in the table tells you whether FAIL blocks merge or is advisory.
- Path-scoped rules under `.claude/rules/` lazy-load; still read the Standard
  doc named in the batch plan.
- Auditor agents are read-only — they report; builders fix.
