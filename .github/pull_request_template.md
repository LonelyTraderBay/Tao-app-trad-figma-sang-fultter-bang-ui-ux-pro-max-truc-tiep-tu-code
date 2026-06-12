## Summary

- 

## Scope

- [ ] App source
- [ ] Router or navigation
- [ ] Feature module
- [ ] Shared UI or theme
- [ ] Tests or guardrails
- [ ] Docs or workflow only

## Enterprise Architecture Checklist

- [ ] Feature changes follow `domain/data/presentation`.
- [ ] Pages and widgets do not import `features/*/data`.
- [ ] Controllers own stateful or high-risk flow decisions.
- [ ] Shared layout primitives are reused before local variants.
- [ ] New or changed routes have route contract coverage.
- [ ] New or split Dart files are reflected in the file action manifest when
      cleanup work requires it.

## Design Token Drift Checklist

- [ ] UI changes reuse `app/theme`, `shared/layout`, and `shared/widgets`
      tokens/primitives before local variants.
- [ ] Changed files do not add local hardcoded `fontSize`, `EdgeInsets`,
      numeric radius, near-1 text height, fixed grid sizing, or duplicate
      `Container` + `BoxDecoration` patterns without a documented exception.
- [ ] `dart run tool/design_token_consistency_audit.dart --check` passes,
      including P0 financial module baseline gates.
- [ ] CI design-token report artifact was reviewed when UI or theme files
      changed.

## Product Safety Checklist

- [ ] High-risk financial or P2P flows include preview and confirmation.
- [ ] Fees, limits, risks, and next steps are visible before confirmation.
- [ ] Sensitive account, wallet, email, phone, and address data is masked.
- [ ] Arena copy remains points-only.
- [ ] Prediction Markets and Arena semantics remain separate.
- [ ] Trade, futures, margin, and copy-trading copy avoids hype or hidden-risk
      language.
- [ ] Not applicable.

## Verification

Run from `flutter_app/` and paste results:

```bash
flutter pub get
dart format --output=none --set-exit-if-changed .
dart run tool/route_coverage_audit.dart --check
dart run tool/design_token_consistency_audit.dart --check
flutter analyze
flutter test test/app/router --reporter=compact
flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact
flutter test test/quality/design_token_consistency_guardrail_test.dart --reporter=compact
flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact
flutter test --reporter=compact
```

Focused suites:

```bash
flutter test test/features/<feature> --reporter=compact
```

## UI Evidence

- [ ] Screenshots or emulator evidence attached for visible UI changes.
- [ ] Not applicable.

## Notes For Reviewers

- 
