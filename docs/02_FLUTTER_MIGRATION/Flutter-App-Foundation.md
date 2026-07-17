# Flutter App Foundation

This file defines the active Flutter-only app foundation.

## Project Location

- The app lives in `flutter_app/`.
- The former React/Vite reference app and generated web baseline were removed on
  2026-05-26.
- New generated artifacts should go under `flutter_app/run-artifacts/`.

## Required Flutter Defaults

| Area | Decision |
| --- | --- |
| Routing | `go_router` |
| State management | `flutter_riverpod` |
| Network layer | Repository interfaces first; mock implementations before real BE |
| Theme | Dark baseline first |
| Runtime mode | `ShellRenderMode.native` is the default for emulator, APK, and devices |
| App shell | `VitAppShell` owns native runtime shell behavior |
| UI source | Current Flutter source, shared tokens, shared widgets, and product docs |

## Runtime Shell Modes

| Mode | Purpose | Required behavior |
| --- | --- | --- |
| `ShellRenderMode.native` | Default user/runtime mode | Uses OS status bar, safe areas, native bottom chrome, and user-space optimizations. |
| `ShellRenderMode.visualQa` | Optional fixed-frame Flutter inspection mode | Uses the Flutter phone frame utilities for consistent local review. It no longer targets deleted web screenshots. |

## App Structure

```text
flutter_app/lib/
├── main.dart
├── app/
│   ├── vit_trade_app.dart
│   ├── router/
│   └── theme/
├── core/
├── features/
└── shared/
    ├── layout/
    └── widgets/
```

## Build And Verification

Run from `flutter_app/`:

```bash
flutter pub get
flutter analyze
flutter test
flutter run
```

## God-Family Mock Chấp Nhận Được (DEBT-87)

Một số họ mock repository rất lớn (earn 26 file/~11k dòng fixtures, p2p 26 file,
arena 10, launchpad 9, trade_compliance 8). Đây là **nợ có chủ đích, chấp nhận
được** ở giai đoạn mock-UI:

- Chúng là DATA TĨNH thay thế backend chưa tồn tại — sẽ bị thay nguyên khối
  bằng repository backend thật sau DEC-backend; refactor cấu trúc chúng bây giờ
  là công sức đổ vào lớp sắp bị vứt.
- Quy ước bắt buộc: KHÔNG thêm logic hiển thị vào mock (logic thuộc
  presentation/controller); KHÔNG tách/gộp part-file của family.
- Kích thước 5 họ lớn bị đóng băng bởi
  `flutter_app/test/quality/mock_fixture_baseline_guardrail_test.dart`
  (dung sai +10%) — phình vượt dung sai là tín hiệu logic đang chảy nhầm tầng,
  không phải lý do nới baseline.

## Hard Rules

- Do not reintroduce root npm/Vite tooling.
- Do not recreate deleted web capture artifacts.
- Do not add per-module active bottom-nav colors; use the shared Home brand
  token unless product docs are updated.
- Keep Arena and Prediction domains separate.
- Do not mark a screen complete without route behavior, repository/mock state,
  and relevant tests.
