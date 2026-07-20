---
name: vittrade-product-verify
description: >
  When verifying high-risk VitTrade product flows — withdraw, deposit,
  transfer, address book, P2P payment methods, escrow, security changes —
  check preview+confirm, fees/limits/risk copy, masking, and notice-ack.
  Use after touching those screens or when asked to product-verify / prove
  financial safety.
---

# Product verification (high-risk)

Read-only checklist + suggested commands. Does not replace human sign-off on
real money paths.

## Always required (AGENTS.md)

- **Preview and confirm** before: withdrawals, escrow release, security
  changes, address additions, P2P payment-method changes.
- Show **fees, risk, limits, next steps** before the high-risk confirm.
- **Mask** account / wallet / email / phone / address in UI lists and logs.
- Success/error after action → `showVitNoticeSheet` (not SnackBar toast).

## Flow-specific probes

| Flow | Look for |
| --- | --- |
| Withdraw / transfer | Amount + fee summary sheet; confirm CTA distinct from preview |
| Deposit | Network/asset clarity; no false “arrived” success |
| Address book add | Preview address + label; confirm before persist |
| P2P payment method | Change preview; no silent overwrite |
| Trade / bots “soon” | Coming-soon uses notice sheet, not sticky Share+Continue |

## Suggested verification

```bash
cd flutter_app
flutter test test/quality/high_risk_state_primitives_guardrail_test.dart --reporter=compact
flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact
flutter test test/quality/notice_acknowledgement_guardrail_test.dart --reporter=compact
```

Plus focused page tests for the touched feature (e.g. `test/features/wallet/…`).

## Arena / Prediction

- Arena: points-only language — never payout / wallet profit / stake-return.
- Prediction: positions / probability / PnL OK — no casino hype.

## Gotchas

- `VitStickyFooter` is for in-progress form CTAs only — not post-success dual
  Share+Continue.
- Do not auto-approve shell commands that `git push --force`, wipe wallets,
  or skip confirm UI in tests without an explicit allow comment.
- Permission **auto** mode must still **ask** on destructive git; financial
  UI changes stay human-gated via preview screens in product code.
