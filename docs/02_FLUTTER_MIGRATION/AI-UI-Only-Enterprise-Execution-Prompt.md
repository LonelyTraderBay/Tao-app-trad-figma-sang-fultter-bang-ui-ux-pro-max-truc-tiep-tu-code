# AI UI-Only Enterprise Execution Prompt

Copy prompt ben duoi vao AI/Codex khi muon tiep tuc tu dong thuc hien toan bo
cong viec trong `Flutter-UI-Only-Enterprise-Tracking-Plan.md`.

```text
Ban dang lam trong repo VitTrade Flutter tai:

C:\Users\C-PC\Documents\Tao-app-trad-figma-sang-fultter-bang-ui-ux-pro-max-truc-tiep-tu-code

Muc tieu:
Tu dong thuc hien lan luot toan bo cong viec trong:

- docs/02_FLUTTER_MIGRATION/Flutter-UI-Only-Enterprise-Tracking-Plan.md

Pham vi rat quan trong:
- Day la giai doan UI-only enterprise-grade readiness.
- Chua co backend that, staging/production credentials, signing secrets, hosted CI/store release artifact validation.
- Khong duoc bịa backend, remote API, production secret, release pipeline hoac noi app da production enterprise-grade day du.
- Duoc lam UI, mock/fail-closed state, controller/view-state, widget/integration tests, route audit, accessibility, responsive QA, docs evidence.

Truoc khi lam bat ky viec gi, doc theo thu tu:
1. AGENTS.md
2. docs/00_START_HERE.md
3. docs/02_FLUTTER_MIGRATION/Flutter-UI-Only-Enterprise-Tracking-Plan.md
4. docs/02_FLUTTER_MIGRATION/AI-Sequential-Execution-Backlog.md neu can doi chieu guardrail/lich su
5. docs/02_FLUTTER_MIGRATION/Flutter-Manual-Smoke-Checklist.md neu can QA evidence
6. docs/02_FLUTTER_MIGRATION/Flutter-Evidence-QA-Report.md neu can report evidence

QUAN TRONG VE CACH LAM:
- Khong chi lap ke hoach. Phai sua code/docs/test that.
- Trong cung mot luot, tiep tuc lam lien tuc qua nhieu UI work item nhat co the.
- Khong gui final chi vi vua xong 1 UI item.
- Chi gui final khi:
  1. Khong con work item `[ ]` hoac `[~]` trong plan, hoac
  2. Cac work item con lai deu `[!]` voi blocker ro rang, hoac
  3. Bi gioi han runtime/context/tool khien bat buoc phai dung.

Neu bat buoc phai dung giua chung:
- Khong de status mo ho.
- Neu item pass day du thi doi thanh `[x]`.
- Neu item chua xong nhung co the tiep tuc, giu `[~]` va ghi ro progress + next exact step.
- Neu blocked that, doi thanh `[!]` va ghi blocker, owner, ly do, unblock condition.
- Final response phai co dong cuoi:
  RESUME FROM: <UI-id> - <title>

Cach chon work item:
1. Chay `git status --short`.
2. Tim work item dau tien trong `Flutter-UI-Only-Enterprise-Tracking-Plan.md` co `Status: [~]`; neu co, tiep tuc item do truoc.
3. Neu khong co `[~]`, tim work item dau tien co `Status: [ ]`.
4. Doi item `[ ]` sang `[~]` truoc khi bat dau.
5. Lam dung Goal, Scope, Rules, Tests, Acceptance cua item.
6. Cap nhat ca section chi tiet lan tracking board neu co status/evidence thay doi.
7. Khi pass day du, doi `Status: [x]`.
8. Ghi Verification log cho item bang command that da chay va ket qua that.
9. Sau do tiep tuc item tiep theo.

Neu gap blocker:
- Khong dung toan bo queue.
- Doi item bi chan sang `[!]`.
- Ghi ro:
  - Blocker
  - Owner
  - Ly do
  - Dieu kien unblock
  - Viec da lam truoc khi bi chan
- Chuyen sang item tiep theo neu khong bi chan.

Repo safety:
- Khong revert hoac ghi de thay doi khong phai do ban tao.
- Neu file da co thay doi cua user, doc ky va lam chen vao dung cho.
- Khong dung `git reset --hard`, `git checkout --`, hoac lenh destructive.
- Khong tao lai React, Vite, Tailwind, root npm scripts, web screenshot tooling cu.
- Khong noi guardrail de lam test pass.
- Khong them placeholder/skeleton route moi chi de day so luong.

UI architecture rules:
- Giu public router facade:
  - `createAppRouter`
  - `appRouter`
  - `AppRoutePaths`
  - `AppRouteNames`
- Giu public page facade neu router/test dang import.
- Page/widget khong import truc tiep `features/*/data`.
- Presentation controller khong import mock/remote repository truc tiep.
- Khi tach file lon:
  - widget nho vao `presentation/widgets/`
  - state/view model vao `presentation/controllers/`
  - entities/value objects vao `domain/`
  - fixtures/mock data vao `data/fixtures/`
- Khong tao `presentation/pages/*_part_*.dart` moi.
- Giam part-file debt bang cach chuyen section/widget sang `presentation/widgets/`.

Theme/design rules:
- Khong them hardcoded color ngoai `flutter_app/lib/app/theme/`.
- Khong them `Colors.*` runtime trong `flutter_app/lib/`.
- Uu tien shared primitives:
  - `VitAppShell`
  - `VitPageLayout`
  - `VitPageContent`
  - `VitHeader`
  - `VitBottomNav`
  - `VitCard`
  - `VitCtaButton`
  - `VitInput`
  - `VitTabBar`
- Dark theme la baseline.
- UI phone-first, support width tu 360 px tro len.
- Khong de text/CTA/card/table bi overflow o 360/440/480 widths.

Financial/product boundary rules:
- Financial/high-risk flows phai co preview/confirm, fee/risk/limit/next-step copy.
- Wallet/P2P/Trade/Predictions khong duoc lam action that khi chua co backend.
- Mock/fail-closed behavior phai ro rang.
- Arena phai points-only:
  - Khong dung wallet, payout, profit, stake-return language cho Arena.
- Prediction Markets duoc dung positions, probability, receipt, rewards, P/L.
- Tranh hype/casino language.
- Khong goi project/app la production-ready khi backend/release ops chua xong.

Thu tu cong viec theo plan:

UI-01 - Dong QA text-entry blocker
- Uu tien giai quyet bang Flutter widget/integration harness dung `enterText` neu ADB text-entry khong on dinh.
- Neu co emulator/manual interactive hop le, thu thap screenshot/UI dump/logcat.
- Cap nhat `Flutter-Manual-Smoke-Checklist.md` va report neu co evidence.
- Neu khong co cach manual/emulator trong moi truong hien tai nhung co widget/integration coverage dang tin cay, ghi ro day la UI harness evidence, khong bịa manual evidence.

UI-02 - Dua feature files >1200 ve 0
- Bat dau voi:
  1. `flutter_app/lib/features/predictions/presentation/pages/predictions_portfolio_page.dart`
  2. `flutter_app/lib/features/predictions/presentation/pages/prediction_social_page.dart`
  3. `flutter_app/lib/features/trade/presentation/pages/trader_profile_page.dart`
  4. `flutter_app/lib/features/profile/presentation/pages/vip_page.dart`
- Tach widgets sang `presentation/widgets/`.
- Giu page facade public.
- Muc tieu: `>1200 = 0`, `>600` khong tang.

UI-03 - Giam page part-file debt
- Giam dan `presentation/pages/*_part_*.dart`.
- Lam theo batch, khong sua tat ca cung luc.
- Uu tien feature co nhieu part-file va risk cao: Trade, P2P, Earn, Predictions.

UI-04 - High-risk UI state depth
- Lam controller/view-state sau hon cho Wallet, P2P, Trade, Predictions, Arena critical flows.
- Them focused tests cho draft, validation, preview, confirming, success, failure/offline.

UI-05 - Responsive visual QA matrix
- Kiem tra priority routes o width 360, 440, 480.
- Luu evidence vao docs/report/checklist neu co screenshot/UI dump.
- Khong tick pass neu primary CTA bi clipped hoac layout overflow.

UI-06 - Admin dashboard UI hardening
- Scope:
  - `flutter_app/lib/features/admin/presentation/pages/admin_home.dart`
  - `flutter_app/lib/features/admin/presentation/pages/analytics_dashboard.dart`
  - `flutter_app/lib/features/admin/presentation/pages/funnel_dashboard.dart`
  - `flutter_app/lib/features/admin/presentation/pages/ab_test_dashboard.dart`
  - `flutter_app/lib/features/admin/presentation/controllers/admin_controller.dart`
- Dashboard phai dense, scanable, operational.
- Co loading/empty/error/offline states, semantic summary cho chart/kpi.

UI-07 - Accessibility and semantics pass
- Uu tien high-risk buttons, forms, tabs, dashboard KPI/chart.
- Them semantic labels/roles/helper/error context khi can.

UI-08 - Copy and language consistency pass
- Scan Arena/Prediction/high-risk copy.
- Chay product copy guardrail.
- Khong de UI copy mau thuan voi UI-only scope.

UI-09 - Route and navigation UX polish
- Giu route facade.
- Khong tao placeholder route moi.
- Kiem tra back navigation o critical flows.
- Chay router tests va route coverage audit.

UI-10 - Final UI-only readiness report
- Chi lam sau khi UI-01 den UI-09 da `[x]` hoac `[!]` ro rang.
- Cap nhat report thanh 3 nhom:
  - UI done
  - UI remaining
  - Out-of-scope backend/release blockers

Lenh bat buoc khi sua Dart:
- Chay tu `flutter_app/`:
  - `dart format .`
  - focused tests cua module vua cham
  - guardrail lien quan
- Neu cham router:
  - `dart run tool/route_coverage_audit.dart --check`
- Neu cham high-risk copy/Arena/Prediction:
  - `flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact`
- Neu cham architecture/file split:
  - `flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact`

Khi hoan thanh stage lon hoac cham nhieu module, chay:
- Tu `flutter_app/`:
  - `flutter analyze`
  - `flutter test --reporter=compact`
  - `dart run tool/route_coverage_audit.dart --check`

Metric can do va ghi lai khi lien quan:
- So feature Dart files >600 lines.
- So feature Dart files >1200 lines.
- So `presentation/pages/*_part_*.dart`.
- So page/widget import truc tiep `features/*/data`.
- So presentation controller import mock/remote repository.
- So runtime `Colors.*` trong `flutter_app/lib/`.
- So hardcoded `Color(0x...)` ngoai `flutter_app/lib/app/theme/`.

Moi packet sau khi xong phai cap nhat:
- `Status: [x]`, `[~]`, hoac `[!]`.
- Tracking board row tuong ung.
- Verification log gom:
  - command da chay
  - ket qua that
  - metrics neu co
  - files thay doi chinh
  - blocker/owner/unblock condition neu co

Final response chi gui khi dung theo dieu kien ket thuc. Final phai gom:
- UI items da xu ly trong luot.
- Files da sua.
- Tests/commands da chay va ket qua.
- Items con lai.
- Blockers neu co.
- Neu dung giua chung, dong cuoi bat buoc:
  RESUME FROM: <UI-id> - <title>

Bat dau ngay:
1. Chay `git status --short`.
2. Doc `Flutter-UI-Only-Enterprise-Tracking-Plan.md`.
3. Tim item `[~]` dau tien; neu khong co, tim item `[ ]` dau tien.
4. Doi item do sang `[~]`.
5. Thuc hien den khi pass/blocked, cap nhat plan, roi tiep tuc item tiep theo.
```
