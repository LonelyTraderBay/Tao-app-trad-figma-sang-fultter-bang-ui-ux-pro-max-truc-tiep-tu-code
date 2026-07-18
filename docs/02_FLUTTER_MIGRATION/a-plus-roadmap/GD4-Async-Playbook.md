# GD4 — Async Contract Playbook (khuôn máy móc cho fan-out)

> Nguồn: Cụm F2 (pilot) — async-hoá `wallet` (19 method) + `notifications`
> (1 method). Khuôn này được chốt lại tại đây và các cụm fan-out (F3–F6,
> ~370 method còn lại trên ~29 file domain/repositories/) PHẢI sao chép
> nguyên khuôn — không tự sáng tác biến thể mới trừ khi mục 9 (bẫy) không
> đủ để xử lý tình huống gặp phải, và khi đó phải bổ sung mục 9 luôn.
>
> Tài liệu liên quan: `docs/05_ARCHITECTURE/decisions/ADR-001-async-error-idiom.md`
> (idiom lỗi async cho đường ghi tài chính — bài này chỉ làm đường ĐỌC),
> `test/quality/async_contract_guardrail_test.dart` (ratchet CHỈ GIẢM).

## 0. Đo trước khi làm

1. Đếm method trong `lib/features/<feature>/domain/repositories/*.dart`:
   `dart test/quality/async_contract_guardrail_test.dart` không lọc theo
   feature — dùng script một lần (xem `_syncRepositoryMethods()` trong
   guardrail) hoặc grep thủ công `ReturnType methodName(` (loại `Future<`/
   `Stream<` ở đầu dòng, loại getter không có `(`).
2. Liệt kê MỌI page/widget trong `presentation/pages/**` và
   `presentation/widgets/**` đang gọi provider snapshot của feature này
   (`grep -rn "ref\.watch(<tên provider>"`). Với mỗi provider raw, xác định
   nó có "controller wrapper" (đối tượng pure logic bọc snapshot, ví dụ
   `WithdrawController`) hay không — quyết định khuôn ở bước 4.
3. Xác định trang nào gọi repo TRỰC TIẾP trong `build()` (không qua
   provider trung gian) — các trang này cần 2 bước riêng (mục 3 dưới).
4. Xác định provider nào là "controller GHI" (Notifier có mutation cục bộ,
   seed dữ liệu ban đầu từ snapshot — ví dụ `AddressBookStateController`,
   `NotificationsStateController`) — các provider này áp khuôn mục 6, KHÔNG
   áp khuôn mục 4/5.

## 1. Contract: `Future<T>`

Trong `domain/repositories/<feature>_repository.dart`, đổi mọi method đọc
`ReturnType methodName(...)` → `Future<ReturnType> methodName(...)`. Giữ
nguyên tên/tham số/optional-params. Method đã `Future<T>` (đã làm ở giai
đoạn trước) giữ nguyên.

`FailClosedXRepository`: đa số method chỉ throw qua `noSuchMethod` —
**không cần sửa gì** (chữ ký `Never noSuchMethod(Invocation)` tương thích
mọi kiểu trả về, kể cả `Future<T>`, vì nó throw đồng bộ TRƯỚC khi trả giá
trị — Riverpod's `FutureProvider`/hàm `async` bắt throw đồng bộ này thành
`AsyncError` tự động, xem mục 4). NGOẠI LỆ: nếu `FailClosedXRepository` có
override CỤ THỂ (không phải qua `noSuchMethod`) cho 1-2 method để dựng UI
"service unavailable" nhúng trong `data:` (kiểu wallet's `getWallet()` +
`getPendingDeposits()` phục vụ golden test) — đổi các override đó thành
`Future<T> methodName() async { ... }` không cần `await`/delay (trả ngay,
đây không phải mock, là fail-closed).

## 2. Mock repo: `loadDelay` + `simulateError`

Khuôn `MockHomeRepository` (delay mặc định 300ms — KHÔNG phải 250ms, đó là
`MockAuthRepository`, feature khác):

```dart
abstract class _MockXRepositoryBase implements XRepository {
  const _MockXRepositoryBase({
    this.simulateError = false,
    this.loadDelay = const Duration(milliseconds: 300),
  });
  final bool simulateError;
  final Duration loadDelay;
}
```

Nếu mock repo tách mixin theo part-file (như wallet), thêm một helper dùng
chung trong mixin đầu tiên thay vì lặp lại ở mỗi method:

```dart
Future<void> _simulateNetwork() async {
  // BẮT BUỘC guard delay 0 — xem bẫy 9.10 (zero-delay vẫn là timer).
  if (loadDelay > Duration.zero) {
    await Future<void>.delayed(loadDelay);
  }
  if (simulateError) throw StateError('<feature>_mock_fetch_failed');
}
```

Mỗi method: `Future<ReturnType> methodName() async { await
_simulateNetwork(); return const XSnapshot(...); }` (giữ nguyên phần thân
trả fixture — chỉ thêm `async`/`await`). Test luôn truyền
`loadDelay: Duration.zero`.

⚠️ **Mock của provider bị SHELL watch** (badge, chrome dùng chung): mặc định
`loadDelay` phải là `Duration.zero` chứ KHÔNG phải 300ms — provider đó dựng
trong MỌI widget test đi qua router; delay khác 0 để lại pending timer giết
hàng trăm test `'!timersPending'` (bẫy 9.11). Hiện chỉ notifications thuộc
nhóm này.

## 3. Provider trung gian (nếu thiếu) — 2 bước riêng

Nếu một trang/provider gọi `ref.watch(xRepositoryProvider).getY(...)` TRỰC
TIẾP (không qua provider snapshot riêng), tách thành 2 bước NGAY CẢ TRONG
CÙNG MỘT DIFF (không cần 2 PR, nhưng ghi rõ trong PR description là 2 bước
logic riêng để review dễ theo dõi):

- **Bước A**: tạo `final xYSnapshotProvider = Provider<YSnapshot>((ref) =>
  ref.watch(xRepositoryProvider).getY(...));` (vẫn sync, chưa đổi gì khác).
- **Bước B**: đổi `Provider` → `FutureProvider` (mục 4) sau khi contract đã
  `Future<T>` (mục 1).

Trong Cụm F2, `notificationsStateProvider`/`NotificationsStateController`
gọi repo trực tiếp trong `build()` → đã tách ra
`notificationsSnapshotProvider` (bước A+B gộp vì contract đã đổi cùng
lúc). `withdrawControllerProvider`/`addressAddControllerProvider`/
`tokenApprovalControllerProvider` cũng gọi repo trực tiếp bên trong khai
báo — tách ra `walletWithdrawSnapshotProvider` /
`walletAddressAddSnapshotProvider` / `walletTokenApprovalsSnapshotProvider`
(FutureProvider trung gian) rồi mới bọc AsyncValue (mục 5).

## 4. FutureProvider hoá (đọc thuần)

Mọi provider "đọc thuần" (không mutation, không controller wrapper) đổi
trực tiếp:

```dart
// Trước
final xSnapshotProvider = Provider<XSnapshot>(
  (ref) => ref.watch(xRepositoryProvider).getX(),
);
// Sau
final xSnapshotProvider = FutureProvider<XSnapshot>(
  (ref) => ref.watch(xRepositoryProvider).getX(),
);
```

**KHÔNG thêm `async`/`await`** trong callback nếu `getX()` đã trả về
`Future<T>` trực tiếp — chỉ forward. Nếu callback throw đồng bộ (trường
hợp fail-closed `noSuchMethod`), Riverpod bắt throw đó thành `AsyncError`
tự động — khuôn đã có sẵn ở `homeSnapshotProvider`/`newsSnapshotProvider`,
không phải phát minh gì mới.

**autoDispose**: GIỮ NGUYÊN semantics hiện tại của provider đó (nếu trước
là `Provider<T>` không autoDispose → sau là `FutureProvider<T>` không
autoDispose; nếu trước là `.family` không autoDispose → sau vẫn vậy). Đổi
autoDispose là việc khác (PERF-HN1/STATE-S22), không phải phạm vi GD4.

**Controller wrapper thuần đọc** (ví dụ `WithdrawController`,
`AddressAddController`, `TokenApprovalController` — class pure-logic dựng
lại mỗi lần watch từ 1 snapshot, KHÔNG có method mutation nội bộ): áp khuôn
STATE-S25 đã có sẵn ở `home_controller_providers.dart`:

```dart
final xControllerProvider = Provider<AsyncValue<XController>>((ref) {
  return ref
      .watch(xSnapshotProvider)
      .whenData((snapshot) => XController(state: XViewState(snapshot: snapshot)));
});
```

Lý do dùng `Provider<AsyncValue<XController>>` thay vì
`FutureProvider<XController>`: `.whenData()` map đồng bộ, không tạo thêm
1 tầng Future/microtask; và consumer vẫn gọi `.when()` giống hệt các
snapshot provider khác — một khuôn duy nhất cho cả 2 trường hợp
(snapshot trần và snapshot-bọc-controller).

## 5. Trang `.when()`

Mọi `ref.watch(xProvider)` đồng bộ trong `build()` của page/widget →
`AsyncValue`, bọc bằng `.when(loading:, error:, data:)`. **Diff tối
thiểu**: phần `data:` giữ nguyên code cũ (chỉ thụt lề thêm 1 cấp), KHÔNG
viết lại logic.

- **Loading**: dùng primitive có sẵn — `VitSkeletonList()` (danh sách) là
  lựa chọn mặc định generic cho pilot này (không dựng skeleton mô phỏng
  từng block như `home_status_content.dart` — việc đó tốn diff không cần
  thiết cho quy mô fan-out 370 method). Nếu trang không có scroll list rõ
  ràng, `VitSkeletonList()` vẫn chấp nhận được làm placeholder chờ.
- **Error**: `VitErrorState(title:, message:, actionLabel: 'Thử lại',
  onAction: () => ref.invalidate(xProvider))`.
- **Data**: `(snapshot) => <cây widget cũ, nguyên vẹn>`.

**Vị trí bọc — 2 biến thể, chọn theo header có phụ thuộc dữ liệu hay
không**:

1. **Header KHÔNG phụ thuộc snapshot** (đa số trang — tiêu đề tĩnh hoặc chỉ
   phụ thuộc local state): giữ `header:`/`title:` NGOÀI `.when()`, chỉ bọc
   phần `children:` bên trong `VitPageContent`/`VitWalletDetailScaffold`:
   ```dart
   children: [
     ...xAsync.when(
       loading: () => const [VitSkeletonList()],
       error: (error, stackTrace) => [VitErrorState(...)],
       data: (snapshot) => [ /* cây widget cũ */ ],
     ),
   ],
   ```
   (Với `VitWalletDetailScaffold`/`VitWalletDetailScaffold`-kiểu nhận
   `children: List<Widget>` trực tiếp — không cần `...` spread, gán thẳng
   `children: xAsync.when(...)`.)
2. **Header PHỤ THUỘC snapshot** (vd tiêu đề = `snapshot.symbol` — chỉ 1
   trong 17 trang wallet rơi vào ca này): bọc TOÀN BỘ `return` trong
   `.when()`, mỗi nhánh trả về scaffold đầy đủ riêng (title fallback hợp lý
   cho loading/error — dùng tham số route/id đã biết thay vì chờ dữ liệu).
   Trước khi làm vậy, kiểm tra xem giá trị hiển thị trên header có suy ra
   được TỪ THAM SỐ TRANG (khỏi cần đợi async) không — ví dụ tiêu đề
   `'Nạp ${snapshot.asset}'` thực chất luôn bằng
   `widget.asset.toUpperCase()` (mock chuẩn hoá y hệt) → dùng thẳng
   `widget.asset.toUpperCase()`, KHÔNG cần bọc cả scaffold.

**2 async song song trên 1 trang** (ví dụ `wallet_page.dart` cần cả
`walletSnapshotProvider` lẫn `walletPendingDepositsProvider`): xác định
provider nào là CHÍNH (chặn toàn trang) và provider nào là PHỤ (banner/chi
tiết bổ sung, không chặn). Chỉ `.when()` provider chính; đọc provider phụ
qua `.value` (xem mục "bẫy" — Riverpod 3.x không còn `.valueOrNull`, `.value`
đã nullable) và tự xử lý `null` (ẩn banner khi chưa có dữ liệu) thay vì
lồng `.when()` thứ hai (tránh 2 lớp skeleton chồng nhau).

## 6. Controller GHI (Notifier có mutation) — khuôn đã chọn

Với Notifier có method mutation cục bộ (không gọi lại repo khi mutate —
`toggleFavorite`/`deleteAddress`/`markRead`/`markAllRead`/...) nhưng cần
seed dữ liệu ban đầu từ một snapshot giờ đã async: **GIỮ Notifier SYNC**
(không đổi sang `AsyncNotifier`). Lý do: đổi sang `AsyncNotifier` buộc mọi
call-site `ref.read(controllerProvider.notifier).mutate(...)` phải xử lý
`state` dạng `AsyncValue<ViewState>` (unwrap trước khi mutate), lan ra
nhiều nơi trong UI chỉ vì SEED ban đầu là async — không tương xứng lợi ích.

Khuôn cụ thể — 2 biến thể tuỳ UI đã có sẵn trục trạng thái riêng hay chưa:

**Biến thể A — UI CHƯA có trục trạng thái riêng** (đa số, ví dụ
`AddressBookStateController`): `build()` map AsyncValue → giá trị đồng bộ
qua `.value` + fallback rỗng tường minh:

```dart
final class XStateController extends Notifier<XViewState> {
  @override
  XViewState build() {
    final snapshot = ref.watch(xSnapshotProvider).value ?? _emptyXSnapshot;
    return XViewState.fromSnapshot(snapshot);
  }
  // mutation method giữ nguyên, không đổi
}
const _emptyXSnapshot = XSnapshot(/* rỗng, hợp lệ về kiểu */);
```

Trang PHẢI gate qua `xSnapshotProvider.when()` trước khi đọc Notifier này
(xem mục 5) — nghĩa là khi `data:` branch của trang chạy, `xSnapshotProvider`
ĐÃ resolve, nên `.value` bên trong Notifier không bao giờ null trong luồng
UI thật. Fallback rỗng chỉ chạm tới khi test đọc Notifier trực tiếp trước
khi provider async resolve (an toàn, không phải bug).

**Biến thể B — UI ĐÃ có trục trạng thái riêng trong entity** (ví dụ
`NotificationsSnapshot.screenState` + `NotificationsScreenState` enum —
trang đã switch theo `screenState` để vẽ loading/error/empty/offline/ready
TỪ TRƯỚC, không phải làm mới): **KHÔNG cần bọc `.when()` ở trang** — chỉ
cần `build()` của Notifier map `AsyncValue` sang `screenState` tương ứng
qua `.when()`:

```dart
@override
XViewState build() {
  final async = ref.watch(xSnapshotProvider);
  return async.when(
    data: XViewState.fromSnapshot,
    loading: () => XViewState.fromSnapshot(_placeholder(XScreenState.loading)),
    error: (e, st) => XViewState.fromSnapshot(_placeholder(XScreenState.error)),
  );
}
```

Nút "Thử lại" gọi method Notifier (`resetFromRepository()`) đổi từ gán lại
state trực tiếp sang `ref.invalidate(xSnapshotProvider);` — kích hoạt lại
`build()` khi Future mới resolve (không tự gán `state =` bằng tay).

**Chọn biến thể nào**: nếu entity snapshot của feature đã có field kiểu
`screenState`/currentState riêng (không chỉ `supportedStates` khai báo khả
năng) → biến thể B (diff nhỏ hơn nhiều, không đụng trang). Nếu chỉ có
`supportedStates` (khai báo, không phải giá trị hiện tại — như toàn bộ các
snapshot của wallet) → biến thể A + trang bọc `.when()` theo mục 5.

## 7. Test: await + settle

- **Repo/mock trực tiếp** (`test/features/<feature>/data/mock_*_test.dart`
  và mọi `test('...', () { final snapshot = const MockXRepository().getY();
  ... })`): đổi `test(name, () { ... })` → `test(name, () async { ... })`,
  `MockXRepository()` → `MockXRepository(loadDelay: Duration.zero)`,
  `snapshot = repo.getY()` → `snapshot = await repo.getY()`.
- **Controller test qua `ProviderContainer`** (khuôn
  `test/features/home/home_controller_test.dart`): override repository
  provider bằng `MockXRepository(loadDelay: Duration.zero)`, sau đó
  `await container.read(xSnapshotProvider.future);` TRƯỚC KHI đọc giá trị
  đồng bộ; đọc controller/AsyncValue qua `.requireValue` (không phải
  `.value`/`.valueOrNull` — sau `await` đảm bảo đã có data, `.requireValue`
  ném lỗi rõ ràng nếu giả định sai thay vì âm thầm null).
- **Widget/page test** (`testWidgets`): hầu hết ĐÃ dùng
  `await tester.pumpAndSettle()` sau `pumpWidget` — pattern này tự động
  chạy qua state loading (kể cả `loadDelay` 300ms mặc định của mock, nhờ
  `TestWidgetsFlutterBinding` fast-forward timer ảo) tới `data:` — **không
  cần sửa gì thêm** trừ khi test đọc field/gọi method trực tiếp trên kết
  quả `getX()` (xem điểm trên).
- **Golden test**: PHẢI chạy thật trên Windows (goldens `skip:
  !Platform.isWindows`), pump `pumpAndSettle()` đã đủ để settle qua
  skeleton frame về `data:` — KHÔNG regen PNG. Nếu pixel lệch, nghĩa là
  `data:` branch không còn render nguyên vẹn cây widget cũ — sửa code
  (không sửa baseline).

## 8. Tự kiểm trước khi báo cáo xong

```bash
cd flutter_app
dart format --output=none --set-exit-if-changed <mọi file đã chạm>
flutter analyze
flutter test test/features/<feature>          # + test/quality nếu chạm provider/entity dùng chung
flutter test test/quality/async_contract_guardrail_test.dart
flutter test test/quality/state_management_guardrail_test.dart
flutter test test/quality/i18n_vi_only_guardrail_test.dart
flutter test test/features/wallet/golden      # chỉ nếu cụm chạm wallet/feature có golden
```

Sau khi async-hoá xong 1 cụm, HẠ `_baseline` trong
`async_contract_guardrail_test.dart` xuống đúng số thật đo được (không hạ
thấp hơn) — không được để nguyên baseline cũ (ratchet không tự siết).

## 9. Bẫy đã gặp ở Cụm F2 (pilot) — đọc trước khi làm cụm sau

1. **`AsyncValue.valueOrNull` không tồn tại ở Riverpod 3.x trong repo
   này** (`flutter_riverpod: ^3.3.1`, riverpod core 3.2.1 resolved). API đã
   đổi: `.value` giờ CHÍNH LÀ getter nullable (thay thế `valueOrNull` cũ),
   `.requireValue` là bản throw. Dùng `.value` khắp nơi, không dùng
   `.valueOrNull` — trình biên dịch báo lỗi `undefined_getter` ngay nếu
   dùng nhầm, dễ sửa nhưng tốn 1 vòng analyze nếu không biết trước.
2. **Golden "error" state có thể không đi qua nhánh `AsyncValue.error` của
   `.when()`** — nếu `FailClosedXRepository` có override CỤ THỂ (không
   qua `noSuchMethod`) cho method đó để dựng banner lỗi NHÚNG TRONG `data:`
   (như wallet's `getWallet()`/`getPendingDeposits()` phục vụ
   `wallet_page_error.png`), golden vẫn đi qua nhánh `data:` bình thường —
   chỉ cần đổi override đó thành `async`, KHÔNG cần thêm gì cho `.when()`.
   Đọc kỹ `FailClosedXRepository` trước khi giả định "mọi method fail-closed
   đều throw".
3. **`Edit` tool và ký tự Unicode có dấu trong file `\uXXXX`-escape**: nhiều
   file cũ trong repo lưu chuỗi tiếng Việt dưới dạng escape
   (`'Ví'` thay vì `'Ví'`) — khi `old_string` chứa cả 2 dạng trộn lẫn
   trong cùng khối lớn, match có thể fail dù nội dung "giống hệt" về mặt
   hiển thị. Cách xử lý: chia nhỏ `old_string` xuống đoạn KHÔNG chứa chuỗi
   có dấu (dùng biên là dòng code thuần ASCII ở đầu/cuối khối), làm nhiều
   edit nhỏ thay vì 1 edit lớn.
4. **Trang có 2 provider async song song** (chính + phụ) — đừng lồng 2
   tầng `.when()` (tạo 2 skeleton chồng nhau khi cả 2 đang loading). Dùng
   `.value` cho provider phụ + fallback null-safe trong nhánh `data:` của
   provider chính (xem mục 5).
5. **`unread badge` trên shell** (`root_routes.dart` watch
   `notificationUnreadCountProvider`) — provider này giữ nguyên kiểu trả về
   (`Provider<int>`), KHÔNG cần sửa `root_routes.dart` dù notifications đổi
   sang async bên dưới — chỉ sửa nếu kiểu trả về của provider badge thật sự
   đổi.
6. **`test('...', () { final s = repo.getX(); ...})` không async** ở
   ~20 file `test/features/<feature>/*_page_test.dart` (mỗi trang có 1 test
   độc lập gọi thẳng `const MockXRepository().getX()` để pin BE draft
   contract) — đây là surface LỚN NHẤT bị vỡ biên dịch khi đổi contract,
   không phải widget test. Rà bằng
   `grep -rn "const Mock.*Repository().get" test/features/<feature>` trước
   khi bắt đầu để biết trước quy mô.
7. **File ngoài phạm vi feature nhưng vỡ biên dịch trực tiếp vì đổi
   contract** (ví dụ `test/core/config/app_environment_test.dart` gọi
   `walletRepositoryProvider` để test fail-closed,
   `test/core/product_flow/high_risk_flow_binding_test.dart` gọi
   `wallet.getWithdraw(...).highRiskContractId` trong 1 test dùng chung với
   nhiều feature khác): đây KHÔNG phải "vấn đề ngoài phạm vi phát hiện
   được" — là hệ quả trực tiếp bắt buộc phải sửa (thêm `await`/`async`,
   không sửa logic) để giữ `flutter analyze` = 0. Sửa tối thiểu 1-2 dòng,
   không viết lại test.
8. **`_contentForTab`/method helper nhận snapshot làm tham số** (ví dụ
   `wallet_gas_optimizer_page.dart._contentForTab(WalletGasOptimizerSnapshot
   snapshot)`) có thể tear-off trực tiếp làm callback `data:` của `.when()`
   nếu chữ ký khớp (`(T) => Widget`) — không cần viết lambda bọc thêm:
   `data: _contentForTab` thay vì `data: (snapshot) =>
   _contentForTab(snapshot)`.
9. **`dart format` sau khi ghép nhiều đoạn `Edit` nhỏ** luôn để lại thụt lề
   lệch (đoạn giữa `.when()`/`data: (snapshot) {` mới chèn giữ nguyên thụt
   lề cũ của code bên trong) — đây là bình thường, không phải lỗi cần sửa
   tay; chạy `dart format` MỘT LẦN cho tất cả file đã chạm ở cuối, không
   format từng file giữa chừng (tốn lượt gọi tool không cần thiết).
10. **`Future.delayed(Duration.zero)` VẪN là timer** (phát hiện SAU pilot,
    khi chạy full suite): `tester.pump()` không-duration chỉ flush
    microtask + dựng frame, KHÔNG đẩy fake clock, nên timer 0ms không bao
    giờ nổ → provider async không bao giờ resolve trong test không
    `pumpAndSettle` có duration. Mock PHẢI guard: `if (loadDelay >
    Duration.zero) await Future<void>.delayed(loadDelay);` — delay 0 đi
    đường microtask thuần. Đã áp vào mock wallet + notifications; MỌI mock
    async-hóa ở F3-F6 phải theo khuôn này (đã sửa mẫu ở mục 2).
11. **Provider bị shell watch phá vỡ focused-test** (badge notifications):
    mock mặc định 300ms để lại pending timer trong MỌI widget test đi qua
    router (656 fail toàn suite dù focused test của feature xanh 100%) —
    và golden home ghim pixel badge nên badge resolve muộn = lệch 500px.
    Bài học kép: (a) mock của provider shell-scoped mặc định
    `Duration.zero`; (b) focused test KHÔNG đủ cho thay đổi chạm shell —
    bắt buộc full suite trước khi tuyên bố xong (trùng bài học
    shared-widget blast radius).
12. **Mock nhiều mixin thật sự** (compliance 4, bots 2, copy 3 — khác wallet
    1 mixin): `_simulateNetwork()` phải đặt trên `abstract class` BASE,
    không phải "mixin đầu tiên" — mixin `on Base` chỉ thấy member của Base,
    không thấy mixin anh em. Mock chưa có base (markets) thì dựng
    `_MockXRepositoryBase` + đổi `with` → `extends ... with`.
13. **Family key phải có value equality**: class query/request dùng làm key
    `FutureProvider.family` (MarketCalendarQuery, TradeConvertRequest...)
    bắt buộc override `==`/`hashCode` (khuôn TradeOrderDraft PERF-HN1) —
    thiếu thì mỗi setState tạo instance mới → UI nhấp nháy loading vô hạn.
14. **`initState()`/constructor seed từ getter giờ-đã-async**: xóa
    initState, dùng field nullable + `_field ??= snapshot.x` TRONG nhánh
    `data:` (seed 1 lần, không ghi đè khi user đã chỉnh).
15. **Repo gọi trong event handler** (không phải build): chỉ cần `await`
    thẳng tại chỗ, KHÔNG cần provider trung gian. Header/footer ngoài
    `.when()` cần snapshot lúc tap: đọc `provider.value` lười trong
    callback, đừng bắt snapshot lúc build.
16. **autoDispose family preview + mock delay > 0 = orphaned timer**: mỗi
    keystroke tạo family member mới, member cũ dispose khi timer còn bay →
    `!timersPending` dù đã pumpAndSettle. MỌI widget test chạm trang
    preview-family phải override repo `loadDelay: Duration.zero` (mở rộng
    phạm vi bẫy 11 — không chỉ provider shell-watch).
17. **`simulateError: true` giờ đánh cả đường đọc**: test "trang load ok,
    chỉ submit fail" phải dùng test-double hẹp (khuôn
    _OfflineSubmitTradeRepository) thay vì cờ blanket.
18. **Mock gọi chuỗi mock khác** (getOrdersHistory → getTrade,
    submitConvert → previewConvert): bỏ `_simulateNetwork()` ở lớp ngoài —
    delay/error chỉ mô phỏng MỘT lần.
19. **Mutation cần dữ liệu async**: method controller GHI phải thành
    `Future<void>`, giữ preview cũ hiển thị trong lúc await + guard
    out-of-order `if (state.request == request)` trước khi áp kết quả.
20. **Mock N-class độc lập (không mixin, kiểu earn 68 class)**: dựng
    `_MockXRepositoryBase` trong file thư viện chính; mọi directive
    `part` phải đứng TRƯỚC mọi declaration — chèn class base xen giữa các
    dòng `part` là lỗi biên dịch.
21. **Biến thể A vẫn cần trang gate `.when()`**: trang chỉ watch Notifier
    (không watch provider async trực tiếp) sẽ render fallback RỖNG suốt
    cửa sổ loading nếu không tự bọc `.when()` trên snapshot provider gốc —
    bọc ở trang, giữ nguyên Notifier.
22. **Stack overlay dùng biến suy từ snapshot**: chuyển CẢ Stack vào nhánh
    `data:`, không chỉ scaffold. Trang import widget lẻ (không qua barrel)
    phải grep bổ sung import vit_error_state/vit_skeleton khi thêm nhánh.
23. **Quét call-site phải bắt cả biến thể xuống dòng** (`ref.read(\n
    provider\n)`) — regex một dòng bỏ sót initState-seed/event-handler.
24. **Test `expect(() => x = repo.getY(), returnsNormally)`** không giữ
    được với Future — thay bằng `await` trực tiếp (exception tự fail
    test, cùng mục đích). Trang demo/admin có backRoute literal cố định
    trong fixture: hardcode literal đó làm fallback loading/error thay vì
    import AppRoutePaths cho một chuỗi.
25. **Fallback backRoute/onAction trong nhánh loading/error KHÔNG được
    hardcode literal route** (`context.go('/home')`) — guardrail
    navigation_route đếm mọi `context.go('/...')` literal trong
    presentation (ngưỡng nợ cũ 28, không tăng). Luôn dùng
    `AppRoutePaths.*`/helper hàm; bài học F4: 110 site fallback literal
    làm nợ nhảy 28→138, phải sửa lại toàn bộ. (Sửa lại chỉ dẫn sai ở
    bẫy 24 về hardcode backRoute.)
