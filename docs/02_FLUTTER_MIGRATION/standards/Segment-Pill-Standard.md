# Segment-Pill Standard (Mandatory)

**Status:** Mandatory — CI enforced  
**Authority:** [DESIGN.md](../../../DESIGN.md) Layout · [AGENTS.md](../../../AGENTS.md) UI rules  
**Enforcement:** `flutter test test/quality/segment_pill_guardrail_test.dart`  
**Audit:** `dart run tool/segment_pill_audit.dart --check --strict-full` → [VitTrade-Segment-Pill-Audit.csv](../audits/VitTrade-Segment-Pill-Audit.csv)  
**Migration manifest:** `dart run tool/segment_pill_manifest.dart --check` → [VitTrade-Segment-Pill-Migration-Manifest.csv](../audits/VitTrade-Segment-Pill-Migration-Manifest.csv)  
**Execution plan (archived):** [Segment-Pill-Migration-Execution-Plan.md](../../_archive/2026-migrations-closed/Segment-Pill-Migration-Execution-Plan.md) — program complete (2026-07-07)  
**Reference screenshots:** Wallet `Danh sách` / `Phân bổ`, Savings `Sản phẩm` / `Đăng ký (N)` — both use **Tier S1**.

VitTrade uses five shared pill/segment families (`VitTabBar`, `VitSegmentedChoice`, `VitChoicePill`, `VitPresetChipRow`, `VitFilterChip`). Pick the canonical widget by **role + height tier**; P0 local duplicates (`_FilterButton`, `_FilterTabs`, `_SegmentedTabs`, …) are banned — see guardrail test.

---

## Decision tree (pick one)

```
Page-level 2–4 equal tabs (view switch)?
  → Tier S1: VitTabBar.segment or VitSegmentedTabBar

Binary / semantic 2–4 option (MUA/BÁN, Long/Short)?
  → Tier S2: VitSegmentedChoice (or .buySell)

Preset amount / % shortcuts in one full-width row?
  → Tier S3: VitPresetChipRow

Optional filters, categories, sort chips (scroll or hug)?
  → Tier S4: VitFilterChip or VitChoicePill

Screen nav with underline indicator?
  → Tier U: VitTabBar.underline (NOT segment tier)

Wrap tag filters (many labels, multi-line)?
  → Tier P: VitTabBar.pill (wrap, hug width)

Display-only status / meta label?
  → Out of scope — keep local _StatusPill / _MetaChip (non-interactive)
```

---

## Tiers (mandatory when adopted)

### Tier S1 — View segment tabs (~28px intrinsic)

| Element | Source | Rule |
| --- | --- | --- |
| Widget | `VitTabBar` · `variant: VitTabBarVariant.segment` or `VitSegmentedTabBar` | Alias OK |
| Height | `tabBarPillVertical` (7×2) + `control` text (~28px) | Do not force 44px |
| Width | `Expanded` equal split per tab | 2–4 tabs only |
| Selected fill | `AppColors.primary12` | |
| Selected border | `AppColors.primary20` | |
| Unselected fill | `AppColors.transparent` | |
| Unselected border | `AppColors.portfolioBtnGhostBorder` | |
| Radius | `AppRadii.inputRadius` (14px) | |
| Typography | `AppTextStyles.control` | Active: primary + medium |
| Icons | Optional `VitTabItem.icon` | `iconSm` + `x2` gap |

**Use for:** Wallet asset list/allocation, Savings products/subscriptions, in-page section switches.  
**Do not:** wrap in `VitCard` with border; use `VitChoicePill` at 44px for the same job.

**Reference:** `wallet_page_asset_sections.dart` → `WalletSegmentedTabs`; `savings_home_products.dart` → `_SavingsTabs`.

```dart
VitTabBar(
  variant: VitTabBarVariant.segment,
  tabs: const [
    VitTabItem(key: 'list', label: 'Danh sách'),
    VitTabItem(key: 'alloc', label: 'Phân bổ'),
  ],
  activeKey: active,
  onChanged: onChanged,
)
```

---

### Tier S2 — Binary / semantic segmented choice (44px)

| Element | Source | Rule |
| --- | --- | --- |
| Widget | `VitSegmentedChoice` · `.buySell()` factory for MUA/BÁN | |
| Height | `VitDensity.compact.controlHeight` (44px) | No custom height |
| Width | Equal `Expanded` per option | 2–4 options |
| Layout | `borderless: true` (default) | Independent pills, no outer track |
| Unselected | Transparent fill + `cardBorder` | |
| Selected | Tone fill (`buy20` / `sell20` or accent 14%) | |

**Use for:** Order side, Long/Short, register account type, analytics metric toggles.  
**Do not:** `VitCard` + `Row` + full-width `VitChoicePill` (AGENTS.md already bans this).

---

### Tier S3 — Preset chip row (34px)

| Element | Source | Rule |
| --- | --- | --- |
| Widget | `VitPresetChipRow` | |
| Height | `AppSpacing.vitPresetChipRowHeight` (34px) | |
| Width | Equal full row (`fullWidth: true`) | |
| Gap | `AppSpacing.vitPresetChipRowGap` | |

**Use for:** Balance % shortcuts, leverage presets, DCA amount steps.

---

### Tier S4 — Filter / category chips (44px default)

| Element | Source | Rule |
| --- | --- | --- |
| Widget | `VitFilterChip` (accent + count) or `VitChoicePill` | |
| Height | 44px default; markets legacy 36px → migrate to token | `height:` override = audit **warn** |
| Width | Hug + horizontal scroll for 3+ filters | Not equal-expanded |
| Tone | Module accent via `accentColor` / `VitFilterChip.color` | |

**Use for:** Leaderboard filters, history type chips, P2P status filters.  
**Prefer** `VitFilterChip` when label includes `(count)` or module accent color is required.

---

### Tier U — Underline screen tabs (54px) — separate family

`VitTabBarVariant.underline` — full-width nav with bottom indicator. **Not interchangeable** with S1. Audit marks these `review` (different tier, not a violation if used correctly).

---

### Tier P — Wrap pill tags (~28px hug)

`VitTabBarVariant.pill` — `Wrap` layout, hug width. For dense filter tag clouds (Launchpad, dev tools).

---

## Out of scope (display-only)

Local classes that are **labels, not controls** — exclude from segment-pill migration:

`_StatusPill`, `_MetaChip`, `_TagPill`, `_HeroPill`, `_TinyPill`, `_VestingPill`, `_MaturityPill`, `_ProtocolPill`, …

Audit script marks these non-interactive when they lack `onTap` / `onChanged` / `onSelected`.

---

## Anti-patterns

| Anti-pattern | Why | Target |
| --- | --- | --- |
| `class _FilterButton` / `_FilterTabs` | Duplicates S1/S4 styling | Shared widget per tier |
| `VitChoicePill` at 44px for 2-tab page switch | Too tall vs Wallet/Savings reference | **S1** segment |
| `VitCard` + bordered row of pills | Double chrome | Direct `VitTabBar.segment` |
| `height:` override on `VitChoicePill` / `VitFilterChip` | Drift (36px markets vs 44px) | Tokenized tier height |
| `_SegmentButton` / `_ChipButton` | Legacy duplicates | S2 or S4 |
| Equal-expanded `VitChoicePill` for filters | Wrong width mode | S4 hug + scroll |

---

## Audit columns (CSV)

| Column | Meaning |
| --- | --- |
| `call_site_family` | Shared widget used |
| `variant` | segment / underline / chip / buySell / preset_row / … |
| `height_tier_px` | ~28, 34, 44, 54, custom |
| `width_mode` | equal_expanded, equal_full, hug, hug_scroll, wrap_hug |
| `local_duplicate_classes` | Interactive `_Filter*` / `_Pill*` in same file |
| `compliance` | pass / warn / review |

---

## Verify (mandatory)

```bash
cd flutter_app
dart run tool/segment_pill_audit.dart --check --strict-full
dart run tool/segment_pill_manifest.dart --check
flutter test test/quality/segment_pill_guardrail_test.dart --reporter=compact
flutter analyze
```

`--strict-full` implies `--strict-p0` + `--strict-p1` and additionally fails when:

- Any audit row has `compliance=warn` (custom `height:` on S4 chips)
- Any interactive local pill/filter class remains in `features/`
- Any file still lists interactive locals in `local_duplicate_classes`

`compliance=review` (underline nav tabs, wrap pill tags) is informational — not a CI failure.

Guardrail fails on:

- P0 banned class patterns in `features/` (`_FilterButton`, `_FilterTabs`, `_SegmentedTabs`, …)
- Stale audit CSV or migration manifest
- New local interactive pill/filter classes in changed presentation files

---

## Related

- Existing AGENTS.md: binary toggles → `VitSegmentedChoice`; preset rows → `VitPresetChipRow`
- Card tile (different concern): [Card-Tile-Standard.md](./Card-Tile-Standard.md)
- Compliance snapshot: [Segment-Pill-Compliance-Report.md](../audits/Segment-Pill-Compliance-Report.md)
