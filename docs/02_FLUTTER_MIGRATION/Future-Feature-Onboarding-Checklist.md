# Future Feature Onboarding Checklist

Use this checklist before adding any new VitTrade Flutter feature, route,
high-risk flow, or large test surface. The goal is to keep the codebase at the
enterprise baseline already established in the clean-codebase master plan.

## Required Feature Shape

```text
flutter_app/lib/features/<feature>/
|-- domain/
|   |-- entities/
|   `-- repositories/
|-- data/
|   |-- fixtures/
|   |-- providers/
|   `-- repositories/
`-- presentation/
    |-- controllers/
    |-- pages/
    `-- widgets/
```

## Implementation Order

- [ ] Define `AppRoutePaths` and `AppRouteNames` entries.
- [ ] Add or update route group wiring under `flutter_app/lib/app/router/`.
- [ ] Add domain entities or value objects under `domain/entities/`.
- [ ] Add repository contracts under `domain/repositories/`.
- [ ] Add mock, local, or fail-closed data implementations under `data/`.
- [ ] Add Riverpod providers under `data/providers/` or the established app
      provider facade when the feature pattern already requires it.
- [ ] Add presentation controller for stateful, async, or high-risk flows.
- [ ] Build the page under `presentation/pages/` using shared layout primitives.
- [ ] Extract repeated or high-volume UI into focused files under
      `presentation/widgets/` before the page reaches `500` lines.
- [ ] Add focused tests under `flutter_app/test/`.
- [ ] Add or update router contract tests when routes change.
- [ ] Update the file action manifest when cleanup work adds or splits Dart
      files.

## Architecture Gates

- [ ] `presentation/pages` and `presentation/widgets` do not import
      `features/*/data`.
- [ ] Presentation controllers do not depend on mock or remote repositories
      directly unless an existing provider boundary explicitly allows it.
- [ ] Domain files do not import UI, Flutter widgets, fixtures, or providers.
- [ ] Cross-module imports use `package:vit_trade_flutter/...`.
- [ ] Shared UI primitives are used before local equivalents:
      `VitAppShell`, `VitPageLayout`, `VitPageContent`, `VitHeader`,
      `VitBottomNav`, `VitCard`, `VitCtaButton`, `VitInput`, and `VitTabBar`.
- [ ] New pages include loading, empty, error, offline, submitting, and success
      states where the flow requires them.
- [ ] New feature/screen edits use existing design tokens from
      `flutter_app/lib/app/theme/` and `shared/*` components (no local hardcoded
      `fontSize`, `EdgeInsets`, fixed `radius`, or container-box decoration
      duplicates without exception).
- [ ] New feature/screen edits pass the changed-file token guardrail and do not
      increase the P0 module design-token baseline when they touch Wallet,
      Trade, P2P, Markets, Profile, security, or KYC surfaces.

## Typography Gates

- [ ] Text uses semantic `AppTextStyles` tokens (`pageTitle`, `sectionTitle`,
      `body`, `caption`, `captionSm`, `micro`, `badge`, `control`, `navLabel`)
      instead of local `TextStyle(fontSize: ...)`.
- [ ] Color changes use `.copyWith(color: ...)`; local
      `copyWith(fontSize: ...)` is not added unless a chart/canvas or code-like
      exception is documented.
- [ ] Amount, price, P/L, percentage, order id, address, hash, and API-key text
      uses `amount*`, `numeric*`, or `monoCode` tokens with tabular figures
      where appropriate.
- [ ] Local `fontFamily` is limited to approved code/hash/address/API or
      chart/canvas exceptions; normal financial values use numeric tokens, not
      ad hoc monospace.
- [ ] `FontWeight.w800/w900` is expressed through `AppTextStyles.extraBold`,
      `AppTextStyles.heavy`, or an existing semantic text token.
- [ ] The design-token audit `Typography Debt By Module` section is reviewed
      for the touched module before handoff.

## Size Gates

- [ ] Page files stay within `200-500` lines.
- [ ] Widget files stay within `80-350` lines.
- [ ] Controller files stay within `80-300` lines.
- [ ] Test files stay below `400` lines by splitting by behavior group.
- [ ] Data fixture files above `500` lines have a documented reason and are not
      growing because of mixed responsibilities.

## Product Safety Gates

- [ ] Withdrawals, escrow release, security changes, 2FA disablement, address
      additions, and P2P payment-method changes have preview and confirmation.
- [ ] Fees, risk, limits, and next steps are shown before high-risk
      confirmation.
- [ ] Sensitive account, wallet, email, phone, and address data is masked.
- [ ] Arena copy is points-only and avoids wallet, payout, profit, and
      stake-return language.
- [ ] Prediction Markets copy remains separate from Arena copy.
- [ ] Trade, futures, margin, and copy-trading flows avoid hype, casino, FOMO,
      and hidden-risk language.

## Required Verification

Run from `flutter_app/`:

```bash
flutter pub get
dart format --output=none --set-exit-if-changed .
dart run tool/route_coverage_audit.dart --check
flutter analyze
flutter test test/app/router --reporter=compact
flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact
flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact
flutter test --reporter=compact
```

Design token compliance:

```bash
cd flutter_app
dart run tool/design_token_consistency_audit.dart --check
flutter test test/quality/design_token_consistency_guardrail_test.dart --reporter=compact
```

Run additional focused suites for the touched feature:

```bash
flutter test test/features/<feature> --reporter=compact
```

Use emulator or device validation when the change affects navigation, layout,
platform behavior, visual QA, or high-risk user flows.

## Stop Conditions

Stop and refactor before merge when any of these are true:

- A page exceeds `500` lines because it owns visual sections directly.
- A test exceeds `400` lines because unrelated behavior groups are mixed.
- A presentation page or widget imports `features/*/data`.
- A financial or P2P flow lacks preview and confirmation.
- Arena and Prediction Markets copy or reward semantics are mixed.
- Router contracts or route coverage are not updated with new routes.
- Design-token audit or guardrail tests fail without a documented and reviewed
  exception.
