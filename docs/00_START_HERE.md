# Start Here

This repository has many historical guidance files. This file is the required reading order for AI agents so migration work follows one path.

## Required AI Reading Order

1. Read root `AGENTS.md` for repo coding constraints.
2. Read this file.
3. Read `docs/01_AI_RULES/AI_EXECUTION_CONTRACT.md`.
4. Read `docs/01_AI_RULES/DOCUMENT_PRECEDENCE.md`.
5. Read `docs/02_FLUTTER_MIGRATION/Flutter-Migration-Execution-Runbook.md`.
6. Read `docs/02_FLUTTER_MIGRATION/Flutter-Port-Master-Plan.md`.
7. Read the Flutter foundation docs in `docs/02_FLUTTER_MIGRATION/`.
8. Read `docs/03_DESIGN_SYSTEM/Guidelines.md`.
9. Read screen-specific references only when working on that screen.

## Source Of Truth

- Migration coverage: `output/flutter-ui-reference/manifest.json` and `docs/02_FLUTTER_MIGRATION/Flutter-Port-Master-Plan.md`.
- Visual parity: `output/flutter-ui-reference/screenshots/`.
- Product and design rules: `docs/03_DESIGN_SYSTEM/Guidelines.md`.
- Coding constraints for this React repo: root `AGENTS.md`.
- Generated capture artifacts: `output/flutter-ui-reference/`.

## Current Baseline

- Total Flutter migration screens: `401`.
- Screenshot set: `802` PNG files, with one viewport and one full-page image per screen.
- Viewport: `440x956`.
- Theme: dark.
- Capture behavior: authenticated baseline with coachmarks disabled.

## Current Module Counts

| Module | Screens |
| --- | ---: |
| trade | 87 |
| p2p | 73 |
| earn | 70 |
| arena | 26 |
| launchpad | 24 |
| markets | 22 |
| wallet | 21 |
| predictions | 17 |
| profile | 13 |
| dca | 11 |
| auth | 6 |
| referral | 5 |
| dev | 5 |
| admin | 4 |
| cross-module | 4 |
| discovery | 3 |
| support | 3 |
| home | 1 |
| news | 1 |
| notifications | 1 |
| rewards | 1 |
| enterprise-states | 1 |
| onboarding | 1 |
| demo | 1 |

## Docs Map

| Path | Purpose |
| --- | --- |
| `docs/01_AI_RULES/AI_EXECUTION_CONTRACT.md` | Hard migration rules for AI execution. |
| `docs/01_AI_RULES/DOCUMENT_PRECEDENCE.md` | Conflict resolution when docs disagree. |
| `docs/02_FLUTTER_MIGRATION/Flutter-Migration-Execution-Runbook.md` | Single execution order for Flutter migration stages. |
| `docs/02_FLUTTER_MIGRATION/Flutter-Port-Master-Plan.md` | Screen-by-screen migration tracker and BE draft. |
| `docs/02_FLUTTER_MIGRATION/Flutter-UI-Reference.md` | Screenshot capture pipeline and visual baseline notes. |
| `docs/02_FLUTTER_MIGRATION/Flutter-App-Foundation.md` | Flutter project location, stack defaults, and app foundation rules. |
| `docs/02_FLUTTER_MIGRATION/Flutter-Design-Tokens.md` | Token mapping from React CSS to Flutter theme constants. |
| `docs/02_FLUTTER_MIGRATION/Flutter-Component-Mapping.md` | React-to-Flutter shared widget mapping. |
| `docs/02_FLUTTER_MIGRATION/Flutter-Navigation-Routing.md` | Route, bottom nav, and dynamic param rules for Flutter. |
| `docs/02_FLUTTER_MIGRATION/Flutter-Visual-QA.md` | Screenshot comparison workflow and visual acceptance criteria. |
| `docs/03_DESIGN_SYSTEM/Guidelines.md` | Product/design rules. |
| `docs/04_SCREEN_REFERENCES/home/` | Home screen pixel, design, and navigation references. |
| `docs/04_SCREEN_REFERENCES/home/HomePage-Flutter-Native-Standard.md` | Approved Flutter native UX standard for `SC-007 HomePage`; does not replace the React baseline. |
| `docs/05_ARCHITECTURE/VitTrade-Enterprise-Architecture-Report.md` | Architecture reference. It must not override the manifest or master plan. |
| `docs/99_LEGAL/ATTRIBUTIONS.md` | Third-party attribution and legal notices. |
| `.codex/skills/ui-ux-pro-max/SKILL.md` | Optional local Codex design-assist skill. It is not a source of truth. |

## Future Guidance Files

Add new long-term guidance under `docs/` and register it in this file. Do not add competing migration instructions under `output/`; `output/` is reserved for generated artifacts.
