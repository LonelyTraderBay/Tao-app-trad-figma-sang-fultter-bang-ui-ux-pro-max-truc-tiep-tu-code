# VitTrade HomePage - Design Analysis Report

> Historical React/visual-QA note: this file documents the old React Home analysis and may mention legacy blue tokens such as `#3B82F6`. For Flutter native migration, do not use those historical colors or sizes as the app standard. The current global Flutter native standard is `docs/02_FLUTTER_MIGRATION/Flutter-Native-Design-Standard.md` and `docs/04_SCREEN_REFERENCES/home/HomePage-Flutter-Native-Standard.md`.

## Chi tiết thiết kế UI/UX cho đối tác tham khảo

---

## 1. TỔNG QUAN KIẾN TRÚC

### 1.1 Design System Foundation
- **Grid System**: 4pt base grid
- **Golden Ratio (φ)**: 1.618 - áp dụng cho typography, spacing, sizing
- **Viewport**: iPhone 14 Pro (390×844px logical, 780×1688px @2x)
- **Safe Areas**: Top 59px (Dynamic Island), Bottom 72px (Tab Bar + Home Indicator)
- **Content Width**: 350px (với padding 20px hai bên)

### 1.2 Layer Structure (Z-Index Hierarchy)
```
Layer 0: Background (--tr-bg)
Layer 1: Page Content
Layer 2: Cards/Components
Layer 3: Navigation elements
Layer 4: Modals/Overlays
Layer 5: Coachmarks/Tooltips
```

---

## 2. HEADER SECTION

### 2.1 Layout Specs
| Property | Value |
|----------|-------|
| Container | `flex items-center justify-between` |
| Padding | `px-5 pt-2 pb-3` (20px left/right, 8px top, 12px bottom) |
| Total Height | ~52px |
| Background | Transparent (sử dụng bg của page) |

### 2.2 Title Typography
| Property | Value |
|----------|-------|
| Text | "VitTrade" |
| Font Size | 26px (φ.lg) |
| Font Weight | 700 (Bold) |
| Letter Spacing | -0.5px |
| Color | `--tr-text-1` |
| Font Family | System default (-apple-system, BlinkMacSystemFont) |

### 2.3 Action Buttons (Right Side)
| Property | Value |
|----------|-------|
| Layout | `flex items-center gap-1.5` (6px gap) |
| Button Size | 40×40px (padding 10px) |
| Border Radius | 8px (φRadius.sm) |
| Background | `--tr-search-bg` |
| Icon Size | 21px (φIcon.md) |
| Icon Color | `--tr-text-2` |

#### Notification Badge
| Property | Value |
|----------|-------|
| Size | 16×16px |
| Background | `--tr-sell` (red) |
| Text Color | White |
| Font Size | 9px |
| Font Weight | 700 |
| Position | absolute, top -2px, right -2px |
| Border | 1.5px solid background color |

---

## 3. ANNOUNCEMENT BANNER

### 3.1 Container Specs
| Property | Value |
|----------|-------|
| Layout | `flex flex-col gap-2` |
| Padding | 10px 14px |
| Border Radius | 13px (φRadius.md) |
| Background | `linear-gradient(135deg, rgba(59,130,246,0.08) 0%, rgba(59,130,246,0.08) 100%)` |
| Border | 1px solid `rgba(59,130,246,0.12)` |

### 3.2 Content Layout
| Property | Value |
|----------|-------|
| Inner Layout | `flex items-center gap-3` |
| Icon Size | 18px |
| Icon Color | `--tr-primary` (blue) |
| Text Font Size | 13px (φ.sm) |
| Text Color | `--tr-text-2` |
| Chevron Size | 13px (φIcon.sm) |
| Chevron Color | `--tr-text-3` |

### 3.3 Dot Pagination
| Property | Value |
|----------|-------|
| Container | `flex items-center justify-center gap-1.5` |
| Active Dot | 16×5px, `--tr-primary`, opacity 1 |
| Inactive Dot | 5×5px, `--tr-text-3`, opacity 0.35 |
| Transition | all 0.2s ease |

---

## 4. PORTFOLIO CARD (Hero Section)

### 4.1 Card Container
| Property | Value |
|----------|-------|
| Padding | 22px 20px 20px |
| Border Radius | 21px (φRadius.lg) |
| Background | `--tr-portfolio-bg` (gradient) |
| Border | 1px solid `--tr-portfolio-border` |
| Box Shadow | `--tr-portfolio-shadow` |
| Position | relative (cho decorative elements) |

### 4.2 Decorative Glow Effect
```css
background: radial-gradient(ellipse 80% 60% at 85% 15%, rgba(59,130,246,0.20) 0%, transparent 65%),
            radial-gradient(ellipse 60% 50% at 15% 85%, rgba(59,130,246,0.12) 0%, transparent 65%);
```

### 4.3 Label Text
| Property | Value |
|----------|-------|
| Text | "Tổng tài sản (USDT)" |
| Font Size | 13px (φ.sm) |
| Color | `--tr-portfolio-text-dim` |
| Layout | `flex items-center justify-between` với eye button |

### 4.4 Eye Toggle Button
| Property | Value |
|----------|-------|
| Padding | 6px |
| Border Radius | 8px |
| Icon Size | 18px |
| Icon Color (Open) | `--tr-portfolio-text-dim` |
| Icon Color (Closed) | `--tr-portfolio-text-muted` |

### 4.5 Balance Display
| Property | Value |
|----------|-------|
| Font Size | 34px (φ.xl) |
| Font Weight | 700 |
| Font Family | Monospace (-apple-system, BlinkMacSystemFont, "SF Mono") |
| Letter Spacing | -1px |
| Line Height | 1.1 |
| Color | `--tr-portfolio-btn-ghost-text` (white) |

### 4.6 PnL Badge
| Property | Value |
|----------|-------|
| Layout | `flex items-center gap-1` |
| Padding | 4px 10px (px-2.5 py-1) |
| Border Radius | 8px |
| Background | `rgba(16,185,129,0.15)` (green alpha) |
| Border | 1px solid `rgba(16,185,129,0.20)` |
| Icon Size | 12px |
| Icon Color | `--tr-buy` (green) |
| Text Font Size | 12px |
| Text Font Weight | 600 |
| Text Color | `--tr-buy` |

### 4.7 Action Buttons Row
| Property | Value |
|----------|-------|
| Layout | `flex gap-2.5` (10px gap) |
| Button Height | 44px |
| Button Width | flex-1 (equal distribution) |
| Border Radius | 14px |

#### Primary Button (Nạp)
| Property | Value |
|----------|-------|
| Background | `linear-gradient(135deg, #3B82F6 0%, rgba(59,130,246,0.60) 100%)` |
| Text Color | White (#fff) |
| Font Size | 13px (φ.sm) |
| Font Weight | 600 |
| Box Shadow | `0 4px 14px rgba(59,130,246,0.40), inset 0 1px 0 rgba(255,255,255,0.15)` |
| Icon Size | 15px |
| Icon Stroke Width | 2.2 |

#### Secondary Button (Rút, Ví)
| Property | Value |
|----------|-------|
| Background | `rgba(255,255,255,0.1)` |
| Border | 1px solid `rgba(255,255,255,0.18)` |
| Text Color | White (#FFFFFF) |
| Font Size | 13px (φ.sm) |
| Font Weight | 600 |
| Backdrop Filter | blur(8px) |
| Icon Size | 15px |
| Icon Stroke Width | 2.2 |

---

## 5. QUICK ACTIONS GRID

### 5.1 Section Header
| Property | Value |
|----------|-------|
| Title | "Dịch vụ" |
| Font Size | 21px (φ.md) |
| Font Weight | 700 |
| Color | `--tr-text-1` |
| Margin Bottom | 12px (mb-3) |

### 5.2 Grid Layout
| Property | Value |
|----------|-------|
| Layout | `grid grid-cols-3 gap-2` |
| Columns | 3 |
| Gap | 8px |
| Total Items | 13 actions |

### 5.3 Action Item (TrCard)
| Property | Value |
|----------|-------|
| Layout | `flex flex-col items-center gap-1` |
| Padding | 12px vertical (py-3) |
| Border Radius | 12px (rounded-sm) |
| Icon Size | 18px |
| Label Font Size | 13px (φ.sm) |
| Label Font Weight | 600 |
| Label Color | `--tr-text-1` |

### 5.4 Action Items List
| # | Icon | Label | Route |
|---|------|-------|-------|
| 1 | 🔍 | Khám phá | /topics |
| 2 | ⚡ | Mua nhanh | /trade/btcusdt |
| 3 | 🔄 | Convert | /trade/convert |
| 4 | 📊 | P2P | /p2p |
| 5 | 🚀 | Launchpad | /launchpad |
| 6 | 🏦 | Staking | /earn/staking |
| 7 | 📅 | Mua định kỳ | /dca |
| 8 | 🤖 | Bot | /trade/bots |
| 9 | 📋 | Copy Trade | /trade/copy-trading |
| 10 | 💰 | Tiết kiệm | /earn/savings |
| 11 | 🎁 | Phần thưởng | /rewards |
| 12 | 📈 | Margin | /trade/margin |
| 13 | 🎉 | Giới thiệu | /referral |

---

## 6. MARKET SECTION

### 6.1 Section Header
| Property | Value |
|----------|-------|
| Title | "Thị trường" |
| Font Size | 21px (φ.md) |
| Font Weight | 700 |
| Color | `--tr-text-1` |
| Right Action | "Xem tất cả" + Chevron |
| Action Color | `--tr-primary` |
| Action Font Size | 13px (φ.sm) |

### 6.2 Tab Bar
| Property | Value |
|----------|-------|
| Layout | `flex gap-2` |
| Margin Bottom | 12px (mb-3) |

#### Tab Item
| Property | Active | Inactive |
|----------|--------|----------|
| Padding | 6px 14px | 6px 14px |
| Border Radius | 8px (φRadius.sm) | 8px (φRadius.sm) |
| Background | `--tr-chip-active-bg` | `--tr-chip-bg` |
| Border | 1px `--tr-chip-active-border` | 1px `--tr-chip-border` |
| Text Color | `--tr-chip-active-text` | `--tr-chip-text` |
| Font Size | 13px (φ.sm) | 13px (φ.sm) |
| Font Weight | 600 | 400 |

#### Tab Labels
| Key | Label |
|-----|-------|
| hot | 🔥 Hot |
| gainers | 📈 Tăng |
| losers | 📉 Giảm |
| new | 🆕 Mới |

### 6.3 Market List (TrCard)
| Property | Value |
|----------|-------|
| Variant | standard |
| Overflow | true |
| Items | 5 pairs |

#### List Item Layout
| Property | Value |
|----------|-------|
| Layout | `flex items-center gap-3` |
| Padding | 16px horizontal, 14px vertical (px-4 py-3.5) |
| Border Bottom | 1px `--tr-divider` (trừ item cuối) |

#### Crypto Icon
| Property | Value |
|----------|-------|
| Size | 34×34px (φAvatar.sm) |
| Border Radius | 8px (φRadius.sm) |
| Background | `{logoColor}18` (hex + 18 alpha) |
| Text | First character of baseAsset |
| Text Font Size | 13px (φ.sm) |
| Text Font Weight | 700 |
| Text Color | logoColor |

#### Pair Info (Left)
| Property | Value |
|----------|-------|
| Symbol Font Size | 14px (φ.body) |
| Symbol Font Weight | 600 |
| Symbol Color | `--tr-text-1` |
| Volume Font Size | 10px (φ.xs) |
| Volume Color | `--tr-text-3` |

#### Sparkline Chart (Center)
| Property | Value |
|----------|-------|
| Width | 64px |
| Height | 30px |
| Color | Green if change24h >= 0, Red if < 0 |

#### Price Info (Right)
| Property | Value |
|----------|-------|
| Width | 85px min-width |
| Price Font Size | 14px (φ.body) |
| Price Font Weight | 600 |
| Price Font Family | Monospace |
| Price Color | `--tr-text-1` |
| Change Font Size | 10px (φ.xs) |
| Change Font Weight | 600 |
| Change Color | `--tr-buy` (green) or `--tr-sell` (red) |

---

## 7. TRENDING SECTION

### 7.1 Section Header
| Property | Value |
|----------|-------|
| Title | "Xu hướng" |
| Icon | Zap (lightning) |
| Icon Color | `--tr-warn` (yellow) |
| Icon Size | 21px (φIcon.md) |

### 7.2 Horizontal Scroll Container
| Property | Value |
|----------|-------|
| Layout | `flex gap-3` |
| Overflow | x-auto |
| Padding Bottom | 8px (pb-2) |
| Negative Margin | -20px horizontal (-mx-5) |
| Padding | 20px horizontal (px-5) |

### 7.3 Trending Card (TrCard)
| Property | Value |
|----------|-------|
| Width | 148px |
| Padding | 16px (p-4) |
| Layout | shrink-0 (prevent compression) |
| Text Align | left |

#### Card Content
| Property | Value |
|----------|-------|
| Icon Layout | `flex items-center gap-2` |
| Icon Size | 28×28px |
| Icon Border Radius | 5px (φRadius.xs) |
| Icon Background | `{logoColor}18` |
| Symbol Font Size | 14px (φ.body) |
| Symbol Font Weight | 600 |
| Price Font Size | 16px (φ.base) |
| Price Font Weight | 700 |
| Price Font Family | Monospace |
| Change Margin Top | 3px |
| Change Font Size | 10px (φ.xs) |
| Change Font Weight | 600 |

---

## 8. TOP GAINERS/LOSERS SECTIONS

### 8.1 Section Header
| Property | Gainers | Losers |
|----------|---------|--------|
| Title | "Top tăng giá" | "Top giảm giá" |
| Icon | TrendingUp | TrendingDown |
| Icon Color | `--tr-buy` (green) | `--tr-sell` (red) |

### 8.2 List Item
| Property | Value |
|----------|-------|
| Layout | `flex items-center gap-3` |
| Padding | 16px horizontal, 14px vertical |

#### Rank Badge
| Property | Value |
|----------|-------|
| Width | 20px |
| Text Align | center |
| Font Size | 13px (φ.sm) |
| Font Weight | 700 |
| Color | Gold (#1) `--tr-warn`, others `--tr-text-3` |

#### Change Badge
| Property | Gainers | Losers |
|----------|---------|--------|
| Padding | 4px 12px | 4px 12px |
| Border Radius | 5px (φRadius.xs) | 5px (φRadius.xs) |
| Background | `rgba(16,185,129,0.10)` | `rgba(239,68,68,0.10)` |
| Text Color | `--tr-buy` | `--tr-sell` |
| Font Size | 13px (φ.sm) |
| Font Weight | 700 |

---

## 9. TYPOGRAPHY SCALE

### 9.1 Font Sizes (Golden Ratio based)
| Token | Size | Usage |
|-------|------|-------|
| φ.xs | 10px | Micro labels, timestamps, badges |
| φ.sm | 13px | Captions, secondary text, descriptions |
| φ.body | 14px | Standard body text, list items |
| φ.base | 16px | Labels, primary readable text, inputs |
| φ.md | 21px | Section titles, sub-headings |
| φ.lg | 26px | Page titles, important headings |
| φ.xl | 34px | Hero numbers, prices, balances |
| φ.2xl | 43px | Display, splash headings |
| φ.3xl | 55px | Jumbo, onboarding hero |

### 9.2 Font Weights
| Weight | Usage |
|--------|-------|
| 400 | Normal body text |
| 600 | Semi-bold (buttons, labels, prices) |
| 700 | Bold (headings, balances, important numbers) |

### 9.3 Line Heights
| Token | Value | Usage |
|-------|-------|-------|
| φLineHeight.tight | 1.272 (√φ) | Headings |
| φLineHeight.normal | 1.5 | Body text |
| φLineHeight.relaxed | 1.618 (φ) | Display headings |

---

## 10. COLOR SYSTEM

### 10.1 Semantic Colors
| Token | Light Mode | Dark Mode | Usage |
|-------|------------|-----------|-------|
| --tr-bg | #F8FAFC | #0F172A | Page background |
| --tr-surface | #FFFFFF | #1E293B | Card backgrounds |
| --tr-surface-2 | #F1F5F9 | #334155 | Nested elements |
| --tr-surface-3 | #E2E8F0 | #475569 | Elevated elements |
| --tr-text-1 | #0F172A | #F8FAFC | Primary text |
| --tr-text-2 | #475569 | #94A3B8 | Secondary text |
| --tr-text-3 | #94A3B8 | #64748B | Tertiary text |
| --tr-primary | #3B82F6 | #60A5FA | Brand blue |
| --tr-buy | #10B981 | #34D399 | Success/green |
| --tr-sell | #EF4444 | #F87171 | Error/red |
| --tr-warn | #F59E0B | #FBBF24 | Warning/yellow |
| --tr-border | #E2E8F0 | #334155 | Borders |
| --tr-divider | #F1F5F9 | #334155 | Dividers |

### 10.2 Alpha Variants
| Token | Value |
|-------|-------|
| primaryAlpha08 | rgba(59,130,246,0.08) |
| primaryAlpha12 | rgba(59,130,246,0.12) |
| primaryAlpha20 | rgba(59,130,246,0.20) |
| primaryAlpha40 | rgba(59,130,246,0.40) |
| buyAlpha10 | rgba(16,185,129,0.10) |
| buyAlpha15 | rgba(16,185,129,0.15) |
| sellAlpha10 | rgba(239,68,68,0.10) |
| sellAlpha15 | rgba(239,68,68,0.15) |

---

## 11. SPACING SYSTEM (Fibonacci)

### 11.1 Space Scale
| Token | Value | Usage |
|-------|-------|-------|
| φSpace.1 | 3px | Micro spacing |
| φSpace.2 | 5px | Tight spacing |
| φSpace.3 | 8px | Standard small |
| φSpace.4 | 13px | Standard medium |
| φSpace.5 | 21px | Large spacing |
| φSpace.6 | 34px | Section spacing |
| φSpace.7 | 55px | Major section spacing |

### 11.2 Common Patterns
| Pattern | Value |
|---------|-------|
| Page horizontal padding | 20px (px-5) |
| Card padding | 16-22px |
| Button padding | 10-14px vertical |
| Icon-text gap | 6px (gap-1.5) |
| Section gap | 16-24px |
| Grid gap | 8px (gap-2) |

---

## 12. BORDER RADIUS (Fibonacci)

| Token | Value | Usage |
|-------|-------|-------|
| φRadius.xs | 5px | Small badges, chips |
| φRadius.sm | 8px | Buttons, inputs, list items |
| φRadius.md | 13px | Standard cards, banners |
| φRadius.lg | 21px | Hero cards, portfolio |
| φRadius.xl | 34px | Large modals, sheets |

---

## 13. COMPONENT LIBRARY

### 13.1 TrCard Variants
| Variant | Background | Border | Shadow |
|---------|------------|--------|--------|
| standard | --tr-surface | --tr-card-border | --tr-card-shadow |
| hero | --tr-portfolio-bg | --tr-portfolio-border | --tr-portfolio-shadow |
| inner | --tr-surface-2 | none | none |
| ghost | transparent | none | none |

### 13.2 Border Radius Map
| Size | Value | Tailwind |
|------|-------|----------|
| sm | 12px | rounded-xl |
| md | 16px | rounded-2xl |
| lg | 24px | rounded-3xl |

---

## 14. ICON SIZES

| Token | Value | Usage |
|-------|-------|-------|
| φIcon.sm | 13px | Small inline icons |
| φIcon.md | 21px | Standard icons |
| φIcon.lg | 34px | Large feature icons |

---

## 15. AVATAR SIZES

| Token | Value | Usage |
|-------|-------|-------|
| φAvatar.sm | 34px | List icons, crypto logos |
| φAvatar.md | 55px | User avatars |
| φAvatar.lg | 89px | Profile photos |

---

## 16. BUTTON HEIGHTS

| Token | Value | Usage |
|-------|-------|-------|
| φBtn.compact | 34px | Small buttons |
| φBtn.standard | 55px | Standard buttons |
| φBtn.hero | 89px | CTA buttons |

---

## 17. ANIMATION & TRANSITIONS

### 17.1 Motion Presets
| Token | Value |
|-------|-------|
| φMotion.fast | 0.15s cubic-bezier(0.4, 0, 0.2, 1) |
| φMotion.normal | 0.25s cubic-bezier(0.4, 0, 0.2, 1) |
| φMotion.smooth | 0.35s cubic-bezier(0.16, 1, 0.3, 1) |
| φMotion.spring | 0.5s cubic-bezier(0.34, 1.56, 0.64, 1) |

### 17.2 Common Transitions
| Element | Duration | Easing |
|---------|----------|--------|
| Button hover | 0.15s | ease |
| Card hover | 0.25s | ease |
| Tab switch | 0.2s | ease |
| Page transition | 0.35s | cubic-bezier(0.16, 1, 0.3, 1) |

---

## 18. ELEVATION SYSTEM

| Token | Value |
|-------|-------|
| φElevation.card | `0 1px 3px rgba(0,0,0,0.3), 0 1px 2px rgba(0,0,0,0.2)` |
| φElevation.raised | `0 4px 12px rgba(0,0,0,0.4), 0 2px 4px rgba(0,0,0,0.3)` |
| φElevation.float | `0 8px 32px rgba(0,0,0,0.5), 0 4px 12px rgba(0,0,0,0.3)` |
| φElevation.overlay | `0 16px 64px rgba(0,0,0,0.6), 0 8px 24px rgba(0,0,0,0.4)` |

---

## 19. FILE REFERENCES

### 19.1 Key Files
| File | Purpose |
|------|---------|
| `src/app/pages/market/HomePage.tsx` | Main Home component |
| `src/app/utils/golden.ts` | Golden ratio design system |
| `src/app/hooks/useThemeColors.ts` | Color tokens |
| `src/app/components/ui/TrCard.tsx` | Card component |
| `src/styles/theme.css` | CSS variables |

---

## 20. SUMMARY FOR IMPLEMENTATION

### Critical Design Principles:
1. **4pt Grid**: All spacing must be multiples of 4px
2. **Golden Ratio**: Typography follows √φ (1.272) modular scale
3. **Fibonacci**: Spacing, sizing, radii use Fibonacci sequence
4. **Semantic Colors**: Never hardcode colors, use CSS variables
5. **Full Width Cards**: Cards span full width with 20px side padding
6. **Consistent Padding**: 16px standard, 20-22px for hero sections
7. **Touch Targets**: Minimum 44×44px for buttons
8. **Icon Sizing**: Use φIcon scale (13/21/34px)

### Responsive Considerations:
- Base width: 390px (iPhone 14 Pro)
- Content width: 350px (with 20px padding)
- All measurements are logical pixels (@2x = ×2 for export)

---

*Report generated for design reference and Flutter implementation*
*Date: March 27, 2026*
