# AI Large File Enterprise Refactor Execution Prompt

Copy prompt ben duoi vao AI/Codex khi muon AI tu dong thuc hien toan bo
cong viec trong:

- `docs/02_FLUTTER_MIGRATION/Flutter-Large-File-Enterprise-Refactor-Tracking.md`

Muc tieu cua prompt nay la buoc AI chay tuan tu, khong dung sau 1 packet, khong
chi lap ke hoach, va tiep tuc cho den khi tat ca packet duoc `[x]` hoac `[!]`
voi blocker that.

```text
Ban dang lam trong repo VitTrade Flutter tai:

C:\Users\C-PC\Documents\Tao-app-trad-figma-sang-fultter-bang-ui-ux-pro-max-truc-tiep-tu-code

MUC TIEU CHINH:
Tu dong thuc hien lan luot toan bo cong viec refactor file lon trong:

- docs/02_FLUTTER_MIGRATION/Flutter-Large-File-Enterprise-Refactor-Tracking.md

Day la cong viec Enterprise-grade maintainability refactor cho Flutter UI:
- Giam file page/widget/domain qua lon.
- Giu page chi lam route/layout composition, provider watch, state handoff.
- Tach section/card/chart/form/sheet sang `presentation/widgets/`.
- Tach state/filter/calculation/action orchestration sang `presentation/controllers/`
  hoac helper gan feature neu can.
- Giu domain/data/presentation boundary dung theo AGENTS.md.
- Khong doi UI/product behavior neu khong duoc yeu cau trong packet.
- Khong claim app production enterprise-grade khi backend/release ops chua xong.

BAT BUOC DOC TRUOC KHI SUA:
1. AGENTS.md
2. docs/00_START_HERE.md
3. docs/01_AI_RULES/AI_EXECUTION_CONTRACT.md
4. docs/02_FLUTTER_MIGRATION/Flutter-Large-File-Enterprise-Refactor-Tracking.md
5. docs/02_FLUTTER_MIGRATION/Flutter-UI-Only-Enterprise-Tracking-Plan.md
6. docs/02_FLUTTER_MIGRATION/Flutter-Evidence-QA-Report.md neu can evidence
7. docs/02_FLUTTER_MIGRATION/Flutter-Manual-Smoke-Checklist.md neu cham QA/smoke

LENH VA QUY TAC LAM VIEC:
- Khong chi tra loi bang plan. Phai sua code/docs/test that.
- Lam lien tuc qua nhieu packet nhat co the trong mot luot.
- Khong gui final chi vi vua xong 1 packet.
- Khong dung khi gap test fail dau tien; phai doc loi, sua, va chay lai.
- Chi dung khi:
  1. Khong con packet `[ ]` hoac `[~]` trong tracking file, hoac
  2. Cac packet con lai deu `[!]` voi blocker that, owner va unblock condition,
     hoac
  3. Tool/runtime/context bat buoc phai dung.

NEU BAT BUOC PHAI DUNG GIUA CHUNG:
- Khong de trang thai mo ho.
- Neu packet pass day du thi doi `Status: [x]`.
- Neu packet chua xong nhung tiep tuc duoc, giu `Status: [~]` va ghi next exact
  step trong packet log.
- Neu blocked that, doi `Status: [!]` va ghi:
  - Blocker
  - Owner
  - Ly do
  - Unblock condition
  - Viec da lam truoc khi bi chan
- Final response bat buoc co dong cuoi:
  RESUME FROM: <LG-id> - <title>

VONG LAP THUC THI BAT BUOC:
1. Chay `git status --short`.
2. Doc tracking file:
   `docs/02_FLUTTER_MIGRATION/Flutter-Large-File-Enterprise-Refactor-Tracking.md`.
3. Tim packet dau tien co `Status: [~]`; neu co, tiep tuc packet do truoc.
4. Neu khong co `[~]`, tim packet dau tien co `Status: [ ]`.
5. Doi packet `[ ]` sang `[~]` trong section chi tiet va tracking board truoc
   khi sua file.
6. Doc ky packet: source file, target files, implementation steps, acceptance,
   required verification.
7. Inspect source file va tests hien co truoc khi sua.
8. Sua code bang cach tach nho dung layer:
   - page widgets -> `features/<feature>/presentation/widgets/`
   - presentation state/controller -> `features/<feature>/presentation/controllers/`
   - entities/value objects -> `features/<feature>/domain/`
   - fixtures/mock data -> `features/<feature>/data/fixtures/`
9. Chay `dart format .` hoac focused `dart format <paths>` sau khi sua Dart.
10. Chay focused tests cua packet.
11. Chay guardrails lien quan.
12. Chay `flutter analyze`.
13. Neu packet cham router, chay route audit.
14. Do lai line count/source metric lien quan.
15. Neu pass acceptance, doi packet sang `[x]` trong section chi tiet va tracking
    board.
16. Ghi packet log bang command that va ket qua that.
17. Tiep tuc packet tiep theo; khong gui final neu van con `[ ]` hoac `[~]`.

QUY TAC AN TOAN GIT/WORKTREE:
- Co the dang co dirty worktree; khong revert thay doi khong phai do ban tao.
- Tranh sua file ngoai scope packet.
- Khong dung `git reset --hard`, `git checkout --`, hoac lenh destructive.
- Khong stage/commit/push neu user khong yeu cau.
- Neu file co thay doi san cua user, doc ky va lam chen vao, khong ghi de.
- Dung `apply_patch` cho edit thu cong.

QUY TAC KIEN TRUC:
- Treat `flutter_app/` as source of truth.
- Khong tao lai React/Vite/Tailwind/root npm/web screenshot tooling cu.
- Giu public router facade:
  - `createAppRouter`
  - `appRouter`
  - `AppRoutePaths`
  - `AppRouteNames`
- Khong doi route path/name neu packet khong yeu cau.
- Khong tao placeholder/skeleton route moi.
- Khong tao `presentation/pages/*_part_*.dart` moi.
- Khong de page/widget import truc tiep `features/*/data`.
- Presentation controller khong import mock/remote repository truc tiep.
- Neu tach private widget `_Foo` sang file khac, doi thanh public/internal name
  khong co underscore neu can import tu file khac.
- Khong them abstraction neu no khong giam complexity hoac khong theo pattern
  hien co.

QUY TAC UI/THEME:
- Dung shared primitives truoc khi tao local scaffold:
  `VitAppShell`, `VitPageLayout`, `VitPageContent`, `VitHeader`,
  `VitBottomNav`, `VitCard`, `VitCtaButton`, `VitInput`, `VitTabBar`.
- Dark theme la baseline.
- Khong them runtime `Colors.*` trong `flutter_app/lib/`.
- Khong them hardcoded `Color(0x...)` ngoai `flutter_app/lib/app/theme/`.
- Ho tro phone-first tu width 360 px.
- Sau khi tach widget, khong de primary CTA/table/text overflow.
- Giữ semantic labels/roles hien co; high-risk controls phai accessible.

QUY TAC PRODUCT/FINANCIAL SAFETY:
- Wallet/P2P/Trade/Prediction high-risk actions phai giu preview/confirm,
  fee/risk/limit/next-step copy.
- Chua co backend that thi khong them action side-effect that.
- Arena phai points-only:
  - Khong dung wallet, payout, profit, stake-return language cho Arena.
- Prediction Markets duoc dung positions, probability, receipt, rewards, P/L.
- Tranh hype/casino language.
- Cross-module surfaces phai tach ro Wallet/Prediction/Earn/Arena context.

THU TU PACKET BAT BUOC:
Lam dung thu tu trong tracking board:

LG-01 - Wallet Token Approval page split
LG-02 - Predictions Portfolio page split
LG-03 - Withdraw page split
LG-04 - Transaction Reporting page split
LG-05 - Market Depth page split
LG-06 - Market Sectors page split
LG-07 - Execution Quality demo page split
LG-08 - Live Market Data Analytics widget split
LG-09 - Wallet Multi Manager sections split
LG-10 - Wallet Address Add sections split
LG-11 - Launchpad Rebalance page split
LG-12 - Launchpad DCA Builder page split
LG-13 - Design System dev page split
LG-14 - Earn Staking dashboard split
LG-15 - DCA Backtester page split
LG-16 - P2P Dispute Detail page split
LG-17 - Unified Portfolio Dashboard split
LG-18 - Arena Mode Detail page split
LG-19 - DCA domain entities split
LG-20 - Remaining `>1000` batch

KHONG DUOC NHAY QUA PACKET:
- Chi duoc nhay qua neu packet bi `[!]` that.
- Neu packet P0/P1 fail test, phai debug va sua truoc khi sang packet tiep theo.
- Neu packet qua lon, chia thanh sub-step nhung van giu packet `[~]` cho den
  khi acceptance pass.

CHI TIET KIEM CHUNG THEO LOAI THAY DOI:

Any Dart edit:
```bash
dart format .
flutter analyze
```

Wallet/P2P high-risk UI:
```bash
flutter test test/features/wallet --reporter=compact
flutter test test/features/p2p --reporter=compact
flutter test test/quality/accessibility_semantics_critical_flows_test.dart --reporter=compact
flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact
```

Prediction/Arena UI:
```bash
flutter test test/features/predictions --reporter=compact
flutter test test/features/arena --reporter=compact
flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact
```

Markets/Trade/Earn/DCA/Launchpad/Profile:
```bash
flutter test test/features/<feature> --reporter=compact
flutter analyze
```

Router/navigation touched:
```bash
flutter test test/app/router --reporter=compact
dart run tool/route_coverage_audit.dart --check
```

Architecture/file split guard:
```bash
flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact
```

Broad/shared/domain/router change final verification:
```bash
dart format .
flutter analyze
flutter test --reporter=compact
dart run tool/route_coverage_audit.dart --check
```

METRICS CAN DO LAI SAU MOI PACKET:
Chay tu repo root hoac PowerShell tu root:

```powershell
$files = rg --files flutter_app/lib -g "*.dart"
$over1000 = 0
$featureOver600 = 0
$featureOver1200 = 0
foreach ($file in $files) {
  $lines = (Get-Content -Path $file).Count
  if ($lines -gt 1000) { $over1000++ }
  if ($file -like "flutter_app/lib/features/*") {
    if ($lines -gt 600) { $featureOver600++ }
    if ($lines -gt 1200) { $featureOver1200++ }
  }
}
"Files >1000: $over1000"
"Feature files >600: $featureOver600"
"Feature files >1200: $featureOver1200"
```

PACKET LOG BAT BUOC CAP NHAT:
Trong `Flutter-Large-File-Enterprise-Refactor-Tracking.md`, sau moi packet:

- Cap nhat `Status` trong section chi tiet.
- Cap nhat row trong `Tracking board`.
- Them dong vao `Packet log`:
  - Date
  - Packet
  - Result
  - Commands/evidence
- Ghi line count truoc/sau cho source file chinh.
- Ghi new files da tao.
- Ghi tests da chay va ket qua.
- Neu co test khong chay duoc, ghi ly do that.

DINH NGHIA DONE TOAN BO:
Chi gui final khi:

1. Tracking board khong con `[ ]` hoac `[~]`, va
2. Tat ca section packet LG-01 den LG-20 la `[x]` hoac `[!]`, va
3. LG-20 da scan lai remaining `>1000` files, va
4. Final verification hop ly da pass hoac blocker that da duoc ghi, va
5. Docs packet log da cap nhat.

FINAL RESPONSE KHI HOAN TAT:
- Tom tat so packet `[x]`, `[!]`.
- Tom tat files lon da giam duoc bao nhieu.
- Tom tat commands pass.
- Noi ro blocker con lai neu co.
- Khong them `RESUME FROM` neu tat ca da hoan tat.

FINAL RESPONSE NEU BAT BUOC DUNG SOM:
- Tom tat packet dang lam.
- Tom tat viec da lam.
- Tom tat command da chay va loi/blocker.
- Dong cuoi bat buoc:
  RESUME FROM: <LG-id> - <title>
```

