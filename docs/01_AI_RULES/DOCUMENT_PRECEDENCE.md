# Document Precedence

Use this order when documents disagree.

## Precedence Order

1. User instruction in the current conversation.
2. Root `AGENTS.md` for coding and repository constraints.
3. `docs/00_START_HERE.md` for the docs reading order.
4. `output/flutter-ui-reference/manifest.json` for exact route coverage.
5. `docs/02_FLUTTER_MIGRATION/Flutter-Port-Master-Plan.md` for migration execution, checklist status, navigation draft, and BE draft.
6. `docs/02_FLUTTER_MIGRATION/Flutter-Native-Design-Standard.md` and `docs/04_SCREEN_REFERENCES/home/HomePage-Flutter-Native-Standard.md` for Flutter native runtime color, sizing, chrome, and shared component treatment.
7. `output/flutter-ui-reference/screenshots/` for `ShellRenderMode.visualQa` visual parity.
8. `docs/02_FLUTTER_MIGRATION/Flutter-Migration-Execution-Runbook.md` for what to do before/after each Flutter migration stage.
9. Flutter foundation docs under `docs/02_FLUTTER_MIGRATION/` for Flutter app structure, tokens, components, routing, and QA workflow.
10. `docs/03_DESIGN_SYSTEM/Guidelines.md` for product and design rules.
11. Screen-specific references under `docs/04_SCREEN_REFERENCES/`.
12. Architecture reports under `docs/05_ARCHITECTURE/`.

## Conflict Rules

- If a route count conflicts with the manifest, the manifest wins.
- If a visual description conflicts with a screenshot in `ShellRenderMode.visualQa`, the screenshot wins for structure, content, scroll position, and reference parity.
- If a React screenshot or historical reference conflicts with the Home native standard for Flutter native color, sizing, shared chrome, CTAs, or card treatment, the Home native standard wins.
- If an architecture report conflicts with the master plan, the master plan wins for migration execution.
- If the runbook conflicts with the master plan or manifest on coverage, the master plan or manifest wins.
- If the runbook conflicts with Flutter foundation docs on execution order, the runbook wins; the foundation docs provide technical detail.
- If Flutter foundation docs conflict with screenshots for visual-QA parity, the screenshots win and the foundation docs should be updated.
- If Flutter foundation docs conflict with `Flutter-Native-Design-Standard.md` on native color/size/chrome, `Flutter-Native-Design-Standard.md` wins and the foundation docs should be updated.
- If Flutter foundation docs conflict with the master plan or manifest, the master plan or manifest wins.
- If a screen-specific reference conflicts with global design rules, follow the global rule unless the screen reference explains a deliberate exception and the exception process in `Flutter-Native-Design-Standard.md` is satisfied.
- If a legacy or historical estimate is useful, label it as historical and do not use it as the current baseline.

## Output Directory Rule

`output/` is for generated artifacts and temporary analysis output. Long-term AI guidance belongs under `docs/`.
