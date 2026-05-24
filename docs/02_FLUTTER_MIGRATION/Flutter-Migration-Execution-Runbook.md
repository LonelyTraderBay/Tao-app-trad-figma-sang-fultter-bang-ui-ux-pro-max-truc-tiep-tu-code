# Flutter Migration Execution Runbook

This is the single execution-order file for AI agents working on the Flutter migration. Read it before creating or editing Flutter code.

## How To Prompt AI Later

Use this prompt when assigning Flutter migration work:

```text
Read AGENTS.md, docs/00_START_HERE.md, and docs/02_FLUTTER_MIGRATION/Flutter-Migration-Execution-Runbook.md before editing code.

Vai trò của bạn: senior Flutter migration engineer cho VitTrade. Khi gặp lỗi cơ bản trong migration, tự chọn hướng xử lý chuyên nghiệp nhất dựa trên bằng chứng từ repo, docs, screenshot, React source, Flutter pattern hiện có, audit report và test output. Không hỏi lại những quyết định có thể suy ra an toàn.

Mục tiêu: triển khai tuần tự target SC range do người dùng giao theo đúng thứ tự trong docs/02_FLUTTER_MIGRATION/Flutter-Port-Master-Plan.md.

Trước khi implement bất kỳ màn hình nào:
1. Đọc docs/00_START_HERE.md để tuân thủ đúng thứ tự tài liệu.
2. Đọc AI execution rules, runbook, Native Design Standard, Module Identity Standard, Design Tokens, Component Mapping, Navigation Routing và Visual QA.
3. Đọc audit mới nhất trong output/flutter-ui-reference/flutter-candidates/audits/.
4. Nếu một màn hình trước đó đã được implement nhưng audit/test/capture fail, sửa màn hình fail đó trước; không bắt đầu màn hình kế tiếp.
5. Nếu master plan đã tick nhưng audit/test/capture mới nhất fail, coi gate mới nhất là nguồn sự thật hiện tại; sửa fail và chỉ tick lại sau khi pass đầy đủ.

Source-of-truth order:
AGENTS.md -> docs/00_START_HERE.md -> AI execution rules -> Flutter Migration Runbook -> Native Design Standard -> Module Identity Standard -> master plan row -> React baseline screenshots -> React source -> existing Flutter implementation.

Với từng màn hình SC-xxx:
1. Đọc row tương ứng trong Flutter-Port-Master-Plan.md.
2. Mở viewport và fullpage React baseline screenshots.
3. Đọc React source được liệt kê trong Source File Index.
4. Kiểm navigation graph và BE draft của đúng màn hình.
5. Kiểm Flutter screen/shared component/repository/test pattern liên quan.
6. Implement Flutter UI bằng mock data trước.
7. Wire đúng navigation edge cần thiết; edge chưa tới lượt thì dùng placeholder an toàn nếu không ảnh hưởng trực tiếp.
8. Add/update mock repository và BE contract draft cho đúng màn hình.
9. Add/update tests cho render, state cơ bản, navigation edge và BE draft nếu có.
10. Chạy dart format cho file đã sửa.
11. Chạy flutter analyze --no-pub.
12. Chạy flutter test --no-pub.
13. Chạy node scripts/audit-flutter-home-standard.mjs.
14. Tự sửa lỗi analyze/test/audit/capture trong phạm vi nhỏ nhất, rerun gate liên quan, và không chuyển sang SC tiếp theo khi gate hiện tại chưa pass.
15. Capture Flutter candidates viewport/fullpage vào output/flutter-ui-reference/flutter-candidates/.
16. So sánh visual với React baseline về structure/content/scroll parity.
17. So sánh native runtime với SC-007 Home foundation và Module Identity checklist.
18. Chỉ tick master plan row khi Flutter UI, navigation, BE draft, test, audit, capture và visual QA đều pass.
19. Sau khi tick, rerun audit một lần nữa. Nếu audit fail, đưa QA của row về chưa checked, sửa nguyên nhân, rerun gate.

Auto-repair policy:
- Nếu flutter analyze fail: đọc lỗi, sửa trong scope nhỏ nhất, rerun.
- Nếu flutter test fail: sửa implementation hoặc test theo bằng chứng đúng nhất, rerun.
- Nếu audit fail: đọc sample line, sửa nguyên nhân nhỏ nhất, rerun audit.
- Nếu capture fail: kiểm route, runtime, widget tree, viewport, capture script rồi rerun.
- Nếu visual lệch nhẹ: chỉnh spacing, typography, token, hierarchy, scroll/content parity theo baseline và Home foundation.
- Nếu BE draft thiếu chi tiết nhỏ nhưng có thể suy ra từ React source, mock repo, route graph hoặc pattern hiện có: tự draft theo pattern và ghi rõ trong contract/test.

Design rules:
- SC-007 HomePage là foundation toàn app.
- Dùng AppColors, AppSpacing, AppRadii, AppTextStyles, DeviceMetrics, AppModuleAccents và shared widgets trước.
- Không tạo local alias cho background/surface/card/input như _xxxBg, _xxxSurface, _xxxPanel, _xxxInput.
- Không dùng legacy blue/local dark surface/local gradient ngoài token.
- Module identity chỉ dùng ở accent layer: icon, badge, pill, chart marker, hero border/glow nhẹ, empty state illustration.
- Không dùng emoji string làm icon UI chính.
- Không tạo abstraction/helper mới nếu chỉ phục vụ một màn hình.

Chỉ dừng khi gặp hard blocker sau khi đã tự kiểm tra fallback:
- Không tìm thấy screenshot sau khi đã kiểm manifest, output folders và naming variants.
- Không tìm thấy React source sau khi đã kiểm Source File Index, routeConfig, routes và rg.
- NEEDS_MANUAL_CONFIRM ảnh hưởng trực tiếp đến screen đang port.
- Navigation graph mâu thuẫn và không có placeholder an toàn.
- BE draft mâu thuẫn với React/source/route/repository đến mức không thể suy ra contract đúng.
- Runtime/capture không thể chạy sau khi đã tự sửa lỗi cơ bản.
- Có nguy cơ phải sửa ngoài phạm vi target SC range mà không thể tránh.

Follow the current stage only. Do not skip gates. Do not port more than one SC-xxx screen unless the user explicitly assigns a bounded sequential range.
```

## Non-Negotiable Rules

- Follow this runbook for what to do first, next, and last.
- Use `docs/02_FLUTTER_MIGRATION/Flutter-Port-Master-Plan.md` for the exact screen list and checklist status.
- Use `output/flutter-ui-reference/manifest.json` for exact route coverage.
- Use `output/flutter-ui-reference/screenshots/` for visual truth.
- Implement one `SC-xxx` screen per task unless the user explicitly overrides that rule.
- Do not port a whole module in one pass.
- Do not treat P0/P1/P2/P3 as module batching. Phases define order only.
- Do not overwrite the React screenshot baseline.
- Treat `SC-007 HomePage` as the Flutter native runtime standard for global brand colors, neutral surfaces, native chrome, and shared card treatment.
- Do not introduce repeated screen-local legacy palettes for Flutter native runtime. Use `AppColors` tokens directly for background, surface, card, input, border, and shared brand treatment.
- Read `Flutter-Native-Design-Standard.md` before every new or converted Flutter screen.
- Read `Flutter-Module-Identity-Standard.md` before adding module-specific accent, hero, icon, badge, pill, or chart treatment.

## Current Stage Checklist

- [ ] Stage 0 docs checked
- [ ] Stage 1 `flutter_app/` created
- [ ] Stage 2 tokens created
- [ ] Stage 3 shell created
- [ ] Stage 4 routing created
- [ ] Stage 5 shared widgets created
- [ ] Stage 6 `SC-007 HomePage` visual QA passed
- [ ] Stage 7 screen-by-screen loop started

## Execution Stages

| Stage | Goal | Required files to read | Allowed work | Done gate | Next stage |
| --- | --- | --- | --- | --- | --- |
| 0 | Confirm baseline and rules before code | `AGENTS.md`, `docs/00_START_HERE.md`, `docs/01_AI_RULES/AI_EXECUTION_CONTRACT.md`, `docs/01_AI_RULES/DOCUMENT_PRECEDENCE.md`, this runbook | Read docs, verify manifest/screenshots exist, confirm current target stage | Manifest has 401 routes, screenshot set has 802 PNGs, no source-of-truth conflict | Stage 1 |
| 1 | Create Flutter project container | `Flutter-App-Foundation.md` | Create `flutter_app/`, add Flutter dependencies, keep generated Flutter app isolated from React runtime | `flutter_app/` runs a default app without changing React app behavior | Stage 2 |
| 2 | Create Flutter design tokens | `Flutter-Native-Design-Standard.md`, `Flutter-Design-Tokens.md`, `src/styles/theme.css`, `src/app/hooks/useThemeColors.ts` | Implement `AppColors`, `AppGradients`, `AppSpacing`, `AppRadii`, `AppTextStyles`, `DeviceMetrics` | Tokens match the Home native standard and are used by sample app shell | Stage 3 |
| 3 | Create app shell and layout primitives | `Flutter-App-Foundation.md`, `Flutter-Component-Mapping.md`, React `MobileFrame`, `StatusBar`, `PageLayout`, `PageContent`, `Header`, `BottomNav` source | Implement `VitTradeApp`, `VitPhoneFrame`, `VitStatusBar`, `VitPageLayout`, `VitPageContent`, `VitHeader`, `VitBottomNav` | Empty shell visually matches the 440x956 baseline frame, safe areas, and bottom chrome | Stage 4 |
| 4 | Create routing and bottom nav skeleton | `Flutter-Navigation-Routing.md`, master plan `Navigation Graph` | Add `go_router`, `/home`, bottom nav destinations, typed route names for the first target screen | `/home` opens inside shell and bottom nav active state works | Stage 5 |
| 5 | Create shared widgets needed by Home proof | `Flutter-Component-Mapping.md`, `Flutter-Design-Tokens.md` | Implement only shared widgets needed for `SC-007`: cards, CTA buttons, icon buttons, search/action buttons, status pills, skeleton/error primitives if needed | Home can be built without screen-local copies of shared primitives | Stage 6 |
| 6 | Port `SC-007 HomePage` as shell proof | `Flutter-Port-Master-Plan.md` row `SC-007`, Home screenshots, Home React source, Home screen references under `docs/04_SCREEN_REFERENCES/home/` | Implement only `SC-007 HomePage`, mock data first, route `/home`, no unrelated screens | Home viewport/full-page captures pass visual QA and native captures establish the global Home standard | Stage 7 |
| 7 | Start screen-by-screen migration loop | `Flutter-Native-Design-Standard.md`, `Flutter-Port-Master-Plan.md`, `Flutter-Visual-QA.md`, target screen React source | Pick the next `SC-xxx` by master plan phase/order, implement one screen, wire only needed navigation, add mock repository contract | One target screen has Flutter UI, route, BE draft, React-parity QA, and Home-native design check | Stage 8 |
| 8 | Close the target screen task | Target `SC-xxx` checklist row, `Flutter-Visual-QA.md` | Update screen status only after acceptance; document unresolved navigation or BE gaps | Flutter, BE, and QA status accurately reflect reality | Repeat Stage 7 for next screen |

## Stage 0 Gate

Before any Flutter code work, verify:

- `output/flutter-ui-reference/manifest.json` exists.
- `output/flutter-ui-reference/screenshots/` exists.
- The manifest has `401` routes.
- The screenshot baseline has `802` PNG files.
- `docs/02_FLUTTER_MIGRATION/Flutter-Port-Master-Plan.md` has `401` Flutter status rows, `401` BE status rows, and `401` QA status rows.

If any check fails, stop and repair the baseline before coding Flutter.

## First Screen Rule

`SC-007 HomePage` must be the first real Flutter UI proof screen because it validates:

- phone frame,
- dark theme,
- status bar,
- bottom nav,
- core spacing,
- shared cards/buttons,
- Home entry navigation.
- global native color and size standard for the rest of the app.

After `SC-007` passes visual QA, return to the master plan and continue by phase/order. Do not keep building Home-related screens unless the next task explicitly selects one.

## Home Native Standard Gate

For every Flutter screen, the Home native standard is mandatory:

- Use `AppColors.primary = 0xFFE58A00`, `primaryDark = 0xFFB96000`, and `primarySoft/warn = 0xFFF5A524` for brand, selected state, primary CTA, focus, and active nav.
- Use neutral dark surfaces: `AppColors.bg`, `surface`, `surface2`, `surface3`, `cardBorder`, `divider`, and `borderSolid`.
- Use Home-native sizing: `contentPad = 20`, standard section gap `20`, compact Home rhythm `12` where the shared layout calls for it, input/CTA height `52`, standard card radius `16`, large/hero card radius `24`, native bottom chrome `56`.
- Do not use legacy React blue (`#3B82F6`) as Flutter native brand color.
- Do not use per-module bottom-nav active colors. Bottom nav active color is the Home brand color across all five tabs.
- Module identity may appear only in controlled accents: icons, badges, pills, chart markers, hero borders, or subtle glow. It must not change page backgrounds, ordinary card surfaces, inputs, CTA height, typography scale, radius scale, or bottom nav active color.
- Screen-local constants may alias `AppColors` or `AppSpacing`, but repeated local `Color(0x...)`, radius, spacing, or shadow palettes are not accepted.

## Screen-By-Screen Loop

For every screen after Home:

1. Select exactly one `SC-xxx` row from the master plan.
2. Open its viewport and full-page screenshots.
3. Read the React source from the master plan `Source File Index`.
4. Check `Flutter-Native-Design-Standard.md`, `Flutter-Module-Identity-Standard.md`, plus shared tokens/components/routing docs.
5. Implement Flutter UI with mock data first.
6. Wire only navigation needed by that screen.
7. Add or update the draft repository/BE contract for that screen.
8. Normalize Flutter native colors and shared treatment to the Home native standard unless the screen-specific reference documents an exception.
9. Run `dart format` for edited Dart files.
10. Run `flutter analyze --no-pub` and `flutter test --no-pub`.
11. Run `node scripts/audit-flutter-home-standard.mjs`.
12. Repair basic analyze, test, audit, or capture failures within the smallest safe scope and rerun the failed gate.
13. Capture Flutter viewport and full-page screenshots.
14. Compare against the React baseline for structure and against Home native for runtime brand consistency.
15. Tick status only when Flutter UI, navigation, BE draft, tests, audit, capture, and visual QA are actually complete.
16. Rerun the audit after ticking the master plan row. If it fails, move the QA status back to unchecked, repair, and rerun gates.

## Auto-Repair Policy

Before reporting a blocker, repair basic failures that have clear evidence:

- `flutter analyze` failures,
- `flutter test` failures,
- static audit failures,
- missing route wiring for the current screen,
- candidate capture failures caused by runtime, route, viewport, or script issues,
- small visual drift in spacing, typography, token usage, hierarchy, or scroll parity,
- small BE draft gaps that can be safely inferred from the screen row, React source, route graph, mock repository, or existing contract pattern.

All auto-repair must stay inside the current screen, its required route/repository/test infrastructure, or a shared primitive that is already part of the screen's dependency path.

## Hard Stop Conditions

Stop and report only after the relevant fallback checks have failed:

- a screenshot path is still missing after checking the manifest, output folders, and naming variants,
- React source is still missing after checking the `Source File Index`, route config, routes, and `rg`,
- route behavior conflicts with the Navigation Graph and no safe placeholder exists,
- a `NEEDS_MANUAL_CONFIRM` edge affects the current screen directly,
- a BE draft contradicts React source, route graph, or repository pattern and cannot be safely resolved,
- a screen appears to mix Prediction wallet/value with Arena Points and the correct boundary cannot be inferred,
- visual QA still cannot be run or cannot produce a nonblank screenshot after route/runtime/capture repair,
- the fix would require out-of-range screen work that the user did not authorize.

## File Roles

| File | Role |
| --- | --- |
| This runbook | Decides execution order. |
| `Flutter-Port-Master-Plan.md` | Decides screen coverage, checklist status, phase/order, source lookup, navigation draft, BE draft. |
| `Flutter-App-Foundation.md` | Explains Flutter app structure and defaults. |
| `Flutter-Design-Tokens.md` | Explains token values. |
| `Flutter-Module-Identity-Standard.md` | Explains controlled module accents and what must remain globally fixed. |
| `Flutter-Component-Mapping.md` | Explains shared widget mapping. |
| `Flutter-Navigation-Routing.md` | Explains routing and bottom nav rules. |
| `Flutter-Visual-QA.md` | Explains screenshot comparison and visual acceptance. |
