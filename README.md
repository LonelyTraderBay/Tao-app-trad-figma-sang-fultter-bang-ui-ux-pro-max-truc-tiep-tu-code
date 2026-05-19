# VitTrade Mobile Trading App

React 18 + TypeScript + Vite reference app used as the source UI for a screen-by-screen Flutter migration.

## Start Here

- AI/coding agents: read `AGENTS.md`, then `docs/00_START_HERE.md`.
- Flutter migration plan: `docs/02_FLUTTER_MIGRATION/Flutter-Port-Master-Plan.md`.
- Screenshot capture reference: `docs/02_FLUTTER_MIGRATION/Flutter-UI-Reference.md`.
- Design/product rules: `docs/03_DESIGN_SYSTEM/Guidelines.md`.
- Legal attribution: `docs/99_LEGAL/ATTRIBUTIONS.md`.

## Current Flutter Reference Baseline

- `401` screens from `output/flutter-ui-reference/manifest.json`.
- `802` screenshots in `output/flutter-ui-reference/screenshots/`.
- Standard viewport: `440x956`, dark theme.

## Run The App

```bash
npm install
npm run dev
```

## Build And Test

```bash
npm run build
npm run test:run
```

## Capture Flutter UI Reference

```bash
npm run capture:ui -- --smoke
npm run capture:ui
```

Generated capture artifacts live in `output/flutter-ui-reference/`.
