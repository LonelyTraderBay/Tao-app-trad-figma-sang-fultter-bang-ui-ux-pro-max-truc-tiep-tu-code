# Flutter UI Reference

This React/Vite bundle is the phone UI reference for the future Flutter app.

## Entry Points

- App entry: `src/main.tsx`
- Router: `src/app/routes.ts`
- Route catalog: `src/app/routeConfig.ts`
- Mobile shell/layout: `src/app/components/layout`
- Global styles/theme: `src/styles`

## Mobile Modules To Port

- Auth and onboarding
- Market and markets
- Trade, copy trading, margin trading, and bots
- Wallet and profile
- P2P
- Predictions
- Arena
- Earn, savings, and staking
- Launchpad
- DCA
- Referral, rewards, support, notifications, and news
- Admin, dev, demo, and design-system reference screens

## Screenshot Sources

- Current canonical screenshot set: `output/flutter-ui-reference/screenshots/`
- Current route manifest: `output/flutter-ui-reference/manifest.json`
- Visual gallery: `output/flutter-ui-reference/gallery.html`
- Migration tracker: `docs/02_FLUTTER_MIGRATION/Flutter-Port-Master-Plan.md`
- Screen references: `docs/04_SCREEN_REFERENCES/`

## Automated Capture Pipeline

Generate the Flutter handoff screenshot set with:

```bash
npm run capture:ui
```

Run a representative smoke set first with:

```bash
npm run capture:ui -- --smoke
```

The generated handoff lives in `output/flutter-ui-reference`:

- `manifest.json` and `manifest.csv` map every captured route to its screenshots.
- `gallery.html` provides a local visual browser grouped by module.
- `logs/capture-report.json` records capture status, warnings, and route errors.
- `screenshots/{module}/` stores both `__viewport.png` and `__fullpage.png` images for each route.

Capture runs with coachmarks disabled in browser storage so onboarding tips do not cover the baseline UI used for Flutter comparison.

## Notes For Flutter Port

- Treat the React app as visual and interaction reference, not as production architecture.
- Keep the `401` phone-screen baseline in `output/flutter-ui-reference/manifest.json` as the route coverage source of truth.
- Capture tooling lives in `scripts/capture-flutter-ui-reference.mjs`; it is part of the Flutter reference pipeline.
- Shared visual primitives live mostly in `src/app/components/ui`, `src/app/components/layout`, `src/app/components/states`, and module-specific component folders.
