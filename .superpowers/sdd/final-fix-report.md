# Final fix report — SC-152 refresh failure notice

**Status:** DONE
**Branch:** `fix/sc152-pending-deposits-enterprise-complete`

## Change

- `_refreshDeposits` now shows `Không làm mới được` and returns when the
  provider refresh throws, so it cannot fall through to the success notice.
- Added a provider-override regression test that succeeds on initial load and
  throws on refresh; it asserts the error notice is shown and `Đã làm mới` is
  absent.

## Evidence

```text
GitNexus impact(_refreshDeposits, upstream)
  LOW — 0 direct callers, 0 affected processes, 0 affected modules

flutter test ... --plain-name "SC-152 refresh lỗi chỉ hiện notice thất bại"
  RED — expected "Không làm mới được", found 0

flutter test test/features/wallet/pending_deposits_page_test.dart --reporter=compact
  PASS — 12/12 tests

flutter analyze lib/features/wallet/presentation/pages/transfer/pending_deposits_page.dart test/features/wallet/pending_deposits_page_test.dart
  PASS — No issues found
```

## Minimal-diff review

Lean already. No new dependency, abstraction, or duplicated `Vit*` primitive.
