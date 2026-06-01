# AI Enterprise 900-Line Refactor Execution Prompt

Copy the prompt below into AI/Codex when you want the agent to execute all work
from:

- `docs/02_FLUTTER_MIGRATION/Flutter-Enterprise-900-Line-Refactor-Tracking.md`

Goal: force the agent to work packet-by-packet in the correct order, update the
tracking file, run verification, and continue automatically until every packet
is complete or a real blocker is documented.

```text
You are working in the VitTrade Flutter repository:

C:\Users\C-PC\Documents\Tao-app-trad-figma-sang-fultter-bang-ui-ux-pro-max-truc-tiep-tu-code

PRIMARY OBJECTIVE:
Automatically execute all Enterprise 900-line refactor packets in this tracking
file, in order, until the work is complete:

- docs/02_FLUTTER_MIGRATION/Flutter-Enterprise-900-Line-Refactor-Tracking.md

This is an Enterprise-grade Flutter maintainability refactor. The goal is not
to redesign behavior. The goal is to reduce large page/widget/repository files
while preserving product behavior, navigation, tests, safety copy, and module
boundaries.

NON-NEGOTIABLE OUTCOME:
- All packets E900-01 through E900-14 must end as `[x]` or `[!]`.
- Do not stop after completing only one packet.
- Do not only create a plan.
- Keep working through the next packet while there is still any `[ ]` or `[~]`
  packet in the tracking file.
- If context/tooling forces a stop before all packets are complete, the final
  response must end with:
  RESUME FROM: <packet-id> - <packet title>

READ BEFORE EDITING:
1. AGENTS.md
2. docs/00_START_HERE.md
3. docs/01_AI_RULES/AI_EXECUTION_CONTRACT.md
4. docs/01_AI_RULES/DOCUMENT_PRECEDENCE.md
5. docs/02_FLUTTER_MIGRATION/Flutter-Enterprise-900-Line-Refactor-Tracking.md
6. docs/02_FLUTTER_MIGRATION/Flutter-Large-File-Enterprise-Refactor-Tracking.md
7. docs/03_DESIGN_SYSTEM/Guidelines.md when UI/layout decisions are involved

SOURCE OF TRUTH:
- Flutter app package: flutter_app/
- App source: flutter_app/lib/
- Public router facade: flutter_app/lib/app/router/app_router.dart
- Tests: flutter_app/test/
- Tracking file to update:
  docs/02_FLUTTER_MIGRATION/Flutter-Enterprise-900-Line-Refactor-Tracking.md

CURRENT ENTERPRISE TARGETS:
- presentation/pages/*_page.dart:
  ideal 300-600 lines, hard target below 900 lines.
- presentation/widgets/*.dart:
  ideal 100-400 lines, hard target below 600 lines.
- data/repositories/mock_*:
  ideal 200-500 lines, hard target below 900 lines.
- painter/chart files:
  ideal 100-400 lines, hard target below 600 lines.

WORK LOOP:
Repeat this loop until all E900 packets are complete:

1. Run:
   git status --short
2. Read the tracking file:
   docs/02_FLUTTER_MIGRATION/Flutter-Enterprise-900-Line-Refactor-Tracking.md
3. Find the first packet with status `[~]`.
   - If one exists, resume it before starting any new packet.
4. If no `[~]` packet exists, find the first packet with status `[ ]`.
5. Mark that packet `[~]` in both the packet section and overview table before
   making code edits.
6. Confirm current line counts from flutter_app/:
   ```powershell
   $root=(Resolve-Path .).Path
   Get-ChildItem lib -Recurse -Filter *.dart |
     ForEach-Object {
       $rel=$_.FullName.Substring($root.Length+1)
       $lines=(Get-Content $_.FullName).Count
       if ($lines -gt 900) { "$lines $rel" }
     }
   ```
7. Read the target files and class boundaries:
   ```powershell
   rg -n "^class |^enum |^extension |^mixin |^typedef |^final class " <target-files>
   ```
8. Inspect existing tests for the touched feature before editing:
   ```powershell
   rg -n "<PageName>|<SC-id>|<route-name>" test/features test/app test/quality
   ```
9. Refactor with minimal behavior change:
   - Keep page route, state, provider reads, keys, navigation, and top-level
     composition in the page.
   - Move visual sections/cards/rows/lists/sheets/painters to:
     features/<feature>/presentation/widgets/
   - Move controllers only if the packet genuinely extracts state orchestration.
   - Keep mock repository public APIs unchanged.
   - Use `part` files only when preserving private local widget APIs is the
     safest path and architecture guardrails allow it.
   - Prefer public widget files when widgets are reused or imported directly.
10. Format touched Dart files:
    dart format <touched-files>
11. Run focused tests required by the packet.
12. Run required guardrails.
13. Re-run current line-count scan and confirm target files are below target.
14. Run direct grep on touched files:
    ```powershell
    rg -n "features/.*/data|\bColors\." <touched-files>
    ```
    Expected result: no matches unless the tracking file documents an approved
    exception.
15. If all checks pass:
    - Mark packet `[x]` in the overview table and detail section.
    - Append a Batch Log entry with real command results.
    - Include before/after line counts and new files.
16. If checks fail:
    - Do not move to the next packet.
    - Read the error.
    - Fix the cause.
    - Re-run the failed command.
17. Continue to the next packet. Do not send final while any packet remains
    `[ ]` or `[~]`.

PACKET ORDER:
Process exactly in this order:

E900-01 - Auth 2FA setup
E900-02 - Wallet high-risk pages
E900-03 - P2P safety and wallet
E900-04 - Trade risk, security, tax, audit
E900-05 - Trade copy/provider/guide/disclosure
E900-06 - Predictions tournaments, market maker, calendar
E900-07 - Arena studio
E900-08 - Launchpad operational pages
E900-09 - Earn savings and staking pages
E900-10 - Markets movers and screener
E900-11 - Profile page
E900-12 - Cross-module analytics
E900-13 - DCA smart rules
E900-14 - Referral mock repository fixtures

DO NOT SKIP A PACKET:
- Only skip a packet if it is marked `[!]` with a real blocker, owner, and
  unblock condition.
- If a P0/P1 packet fails tests, debug and fix it before moving on.
- If a packet is too large for one edit, split it into smaller implementation
  steps but keep the packet `[~]` until all acceptance checks pass.

REQUIRED VERIFICATION BY CHANGE TYPE:

Any Dart edit:
```bash
dart format <touched-files>
flutter analyze
flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact
```

Auth high-risk UI:
```bash
flutter test test/features/auth --reporter=compact
flutter test test/quality/accessibility_semantics_critical_flows_test.dart --reporter=compact
flutter analyze
```

Wallet/P2P high-risk UI:
```bash
flutter test test/features/wallet --reporter=compact
flutter test test/features/p2p --reporter=compact
flutter test test/quality/accessibility_semantics_critical_flows_test.dart --reporter=compact
flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact
flutter analyze
```

Trade UI, copy, bot, tax, regulatory, audit:
```bash
flutter test test/features/trade --reporter=compact
flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact
flutter analyze
```

Predictions:
```bash
flutter test test/features/predictions --reporter=compact
flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact
flutter analyze
```

Arena:
```bash
flutter test test/features/arena --reporter=compact
flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact
flutter analyze
```

Earn:
```bash
flutter test test/features/earn --reporter=compact
flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact
flutter analyze
```

Markets:
```bash
flutter test test/features/markets --reporter=compact
flutter analyze
```

Launchpad:
```bash
flutter test test/features/launchpad --reporter=compact
flutter analyze
```

Profile:
```bash
flutter test test/features/profile --reporter=compact
flutter analyze
```

Cross-module:
```bash
flutter test test/features/cross_module --reporter=compact
flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact
flutter analyze
```

DCA:
```bash
flutter test test/features/dca --reporter=compact
flutter analyze
```

Referral repository:
```bash
flutter test test/features/referral --reporter=compact
flutter analyze
flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact
```

Router/navigation touched:
```bash
flutter test test/app/router --reporter=compact
dart run tool/route_coverage_audit.dart --check
flutter analyze
```

Final broad verification after E900-14:
```bash
dart format .
flutter analyze
flutter test --reporter=compact
dart run tool/route_coverage_audit.dart --check
```

ARCHITECTURE RULES:
- Treat flutter_app/ as the app package and source of truth.
- Do not recreate old React/Vite/Tailwind/root npm tooling.
- Do not create placeholder routes or web screenshot tooling.
- Keep app bootstrap, theme, router facade, and shell composition in app/.
- Keep non-UI cross-cutting boundaries in core/.
- Keep reusable UI primitives in shared/.
- Keep screen widgets under features/<feature>/presentation/pages/.
- Keep extracted UI under features/<feature>/presentation/widgets/.
- Keep repository contracts/value objects under domain/.
- Keep mock/remote implementations and Riverpod providers under data/.
- Prefer package:vit_trade_flutter/... imports across modules.
- No presentation page/widget direct import from features/*/data.
- No presentation controller direct import from mock/remote repositories.
- Do not add runtime Colors.* in flutter_app/lib/.
- Do not add hardcoded Color(0x...) outside flutter_app/lib/app/theme/.
- Keep dark theme baseline.
- Support phone-first layouts at 360 px and up.

PRODUCT SAFETY RULES:
- Wallet, P2P, Trade, Auth, and high-risk security flows must preserve preview,
  confirmation, fee/risk/limit/next-step copy, and accessibility semantics.
- Do not remove masking of sensitive account, wallet, email, phone, address, or
  security data.
- Arena must stay points-only. Do not use payout, wallet, profit, or
  stake-return language for Arena.
- Prediction Markets can use positions, probability, receipt, rewards, and P/L.
- Avoid hype, casino, or guaranteed-return language.
- Cross-module pages must keep Prediction Markets and Open Arena separated.

GIT/WORKTREE SAFETY:
- The worktree may already be dirty.
- Do not revert or overwrite changes you did not make.
- Do not run git reset --hard.
- Do not run git checkout -- to discard files.
- Do not stage, commit, or push unless explicitly requested.
- Use apply_patch for manual edits.
- Avoid broad unrelated formatting churn unless the packet requires it.

TRACKING UPDATE FORMAT:
After each packet, update the tracking file with:
- Status `[x]`, `[~]`, or `[!]`.
- Before/after line counts.
- New files created.
- Tests run and exact pass/fail result.
- Current metrics:
  - files_over_1000
  - files_over_900
  - files_over_800
  - feature_files_over_600
- Notes for any exception.

BLOCKER RULE:
Only mark `[!]` if the packet cannot continue without external user input or
external state. A test failure is not a blocker by itself. A compile failure is
not a blocker by itself. Debug and fix local failures.

FINAL RESPONSE WHEN ALL PACKETS COMPLETE:
When E900-01 through E900-14 are all `[x]` or `[!]`, run final broad
verification and report:
- packets completed
- remaining files >900 and >1000
- final verification commands
- any documented exceptions
- path to the updated tracking file

If all packets are complete, do not include a RESUME FROM line.
```

