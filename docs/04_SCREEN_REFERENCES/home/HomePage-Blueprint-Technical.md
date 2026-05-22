# VitTrade HomePage - Technical Blueprint

> Historical React/visual-QA note: this file documents the old React Home pixel blueprint and may mention legacy blue tokens such as `#3B82F6` or fake device-frame dimensions. For Flutter native migration, use it only for structure/reference context. The current global Flutter native color and size standard is `docs/02_FLUTTER_MIGRATION/Flutter-Native-Design-Standard.md` and `docs/04_SCREEN_REFERENCES/home/HomePage-Flutter-Native-Standard.md`.

## Sơ đồ kỹ thuật chi tiết từng pixel

---

## 📐 VIEWPORT & GRID SYSTEM

```
┌─────────────────────────────────────────┐
│           iPhone 14 Pro                 │
│         390 × 844 (logical)             │
│         780 × 1688 (@2x)                │
├─────────────────────────────────────────┤
│  Safe Top: 59px (Dynamic Island)        │
│  Content: 390 × 713 (usable)            │
│  Side Padding: 20px                     │
│  Content Width: 350px                   │
│  Safe Bottom: 72px (Tab Bar + Home)     │
└─────────────────────────────────────────┘
```

**4pt Grid System:** Tất cả kích thước là bội số của 4px

---

## 🎯 TỔNG THỂ TRANG CHỦ (Full Page Layout)

```
┌─────────────────────────────────────────┐ ◄── 0px
│            STATUS BAR                   │
│              (59px)                     │
├─────────────────────────────────────────┤ ◄── 59px
│ HEADER                                  │
│ ┌───────────────────────────────────┐   │
│ │ VitTrade          [🔍] [🔔]       │   │ ◄── 52px total
│ │ px-5 pt-2 pb-3                    │   │     (8+12=20px vertical)
│ └───────────────────────────────────┘   │
├─────────────────────────────────────────┤ ◄── 111px (59+52)
│                                         │
│  PageContent (padding="compact")        │
│  ┌─────────────────────────────────┐    │
│  │  gap: 16px (default)            │    │
│  │                                 │    │
│  │  ┌───────────────────────────┐  │    │
│  │  │  AnnouncementBanner       │  │    │ ◄── ~70px
│  │  │  padding: 10px 14px       │  │    │
│  │  │  radius: 13px             │  │    │
│  │  └───────────────────────────┘  │    │
│  │                                 │    │
│  │  ┌───────────────────────────┐  │    │
│  │  │   PORTFOLIO CARD          │  │    │ ◄── ~200px
│  │  │   padding: 22px 20px 20px │  │    │
│  │  │   radius: 21px            │  │    │
│  │  └───────────────────────────┘  │    │
│  │                                 │    │
│  │  SectionHeader "Dịch vụ"        │    │ ◄── 33px
│  │                                 │    │
│  │  ┌───┬───┬───┐                  │    │
│  │  │ ◯ │ ◯ │ ◯ │ Quick Actions │    │ ◄── ~260px
│  │  ├───┼───┼───┤  5 rows × 3 cols │    │     (5 × 52px)
│  │  │ ◯ │ ◯ │ ◯ │  gap: 8px     │    │
│  │  ├───┼───┼───┤                  │    │
│  │  │ ◯ │ ◯ │ ◯ │               │    │
│  │  ├───┼───┼───┤                  │    │
│  │  │ ◯ │ ◯ │ ◯ │               │    │
│  │  ├───┼───┼───┤                  │    │
│  │  │ ◯ │   │   │ (13 items)      │    │
│  │  └───┴───┴───┘                  │    │
│  │                                 │    │
│  │  [Discovery Section]            │    │ ◄── variable
│  │                                 │    │
│  │  SectionHeader "Thị trường"     │    │ ◄── 33px
│  │  + "Xem tất cả"                 │    │
│  │                                 │    │
│  │  ┌───────────────────────────┐  │    │
│  │  │ [Hot][Tăng][Giảm][Mới]    │  │    │ ◄── 38px
│  │  └───────────────────────────┘  │    │
│  │                                 │    │
│  │  ┌───────────────────────────┐  │    │
│  │  │ Market List (5 items)     │  │    │ ◄── ~310px
│  │  │ each: 62px height         │  │    │     (5 × 62px)
│  │  └───────────────────────────┘  │    │
│  │                                 │    │
│  │  SectionHeader "Xu hướng"       │    │ ◄── 33px
│  │                                 │    │
│  │  ┌────┬────┬────┬────┬────┐     │    │ ◄── 88px
│  │  │    │    │    │    │    │     │    │     cards: 148×88px
│  │  └────┴────┴────┴────┴────┘     │    │
│  │  horizontal scroll              │    │
│  │                                 │    │
│  │  SectionHeader "Top tăng giá"   │    │
│  │  ┌───────────────────────────┐  │    │
│  │  │ 3 items                   │  │    │ ◄── ~186px
│  │  └───────────────────────────┘  │    │     (3 × 62px)
│  │                                 │    │
│  │  SectionHeader "Top giảm giá"   │    │
│  │  ┌───────────────────────────┐  │    │
│  │  │ 3 items                   │  │    │ ◄── ~186px
│  │  └───────────────────────────┘  │    │     (3 × 62px)
│  │                                 │    │
│  │  [Last Updated Timestamp]       │    │
│  │                                 │    │
│  └─────────────────────────────────┘    │
│                                         │
├─────────────────────────────────────────┤
│           TAB BAR (72px)                │
│  ┌─────┬─────┬─────┬─────┬─────┐       │
│  │Home │Mkt  │Trade│Earn │Menu │       │
│  └─────┴─────┴─────┴─────┴─────┘       │
└─────────────────────────────────────────┘ ◄── 844px
```

---

## 🔘 CHI TIẾT TỪNG NÚT (Pixel by Pixel)

### 1. HEADER BUTTONS

```
┌────────────────────────────────────────────────────────────┐
│  HEADER CONTAINER                                          │
│  Width: 390px | Height: 52px                               │
│  Padding: 20px horizontal, 8px top, 12px bottom            │
├────────────────────────────────────────────────────────────┤
│                                                            │
│  "VitTrade"                           ┌────────┐┌────────┐ │
│  26px, weight 700                     │ Search ││  Bell  │ │
│                                       │ Button ││ Button │ │
│                                       └────────┘└────────┘ │
│                                                            │
└────────────────────────────────────────────────────────────┘

SEARCH BUTTON:
┌─────────────────┐
│  ┌───────────┐  │
│  │           │  │
│  │   🔍      │  │ ◄── Icon: 21px
│  │  (Lucide) │  │     Color: #8B95B3
│  │           │  │
│  └───────────┘  │
│      10px       │
│   padding       │
└─────────────────┘
     40 × 40px
     radius: 8px
     bg: #1C2235

BELL BUTTON:
┌─────────────────┐
│  ┌───────────┐  │
│  │     ┌───┐ │  │ ◄── Badge: 16×16px
│  │     │ 3 │ │  │     Position: -2px, -2px
│  │   🔔└───┘ │  │     Color: #EF4444
│  │  (Lucide) │  │     Text: 9px, weight 700
│  │           │  │
│  └───────────┘  │
│      10px       │
│   padding       │
└─────────────────┘
     40 × 40px
     radius: 8px
     bg: #1C2235
```

**Header Button Specs:**
| Property | Value |
|----------|-------|
| Container Width | 390px |
| Container Height | 52px |
| Horizontal Padding | 20px (px-5) |
| Top Padding | 8px (pt-2) |
| Bottom Padding | 12px (pb-3) |
| Button Size | 40 × 40px |
| Button Padding | 10px (p-2.5) |
| Button Radius | 8px |
| Button Background | #1C2235 (--tr-search-bg) |
| Icon Size | 21px (φIcon.md) |
| Icon Color | #8B95B3 (--tr-text-2) |
| Badge Size | 16 × 16px (min) |
| Badge Padding | 0 4px |
| Badge Radius | 9999px (full) |
| Badge Background | #EF4444 (--tr-sell) |
| Badge Text | 9px, weight 700 |
| Badge Shadow | 0 2px 6px rgba(239,68,68,0.4) |
| Badge Border | 1.5px solid parent bg |

---

### 2. ANNOUNCEMENT BANNER

```
┌──────────────────────────────────────────────────────────┐
│ BANNER CONTAINER                                         │
│ Width: 350px | Padding: 10px 14px                        │
│ Radius: 13px                                             │
├──────────────────────────────────────────────────────────┤
│                                                          │
│  ┌────┬──────────────────────────────┬────┐             │
│  │ 🎁 │ Text here...                 │ ❯  │             │
│  │18px│ 13px, #8B95B3                │13px│             │
│  └────┴──────────────────────────────┴────┘             │
│   6px              flex-1                6px            │
│   gap                          gap                      │
│                                                          │
└──────────────────────────────────────────────────────────┘

DOT PAGINATION:
┌─────────────────────────────┐
│  ●────  ●  ●  ●  ●         │
│ 16×5   5×5                │
│ active  inactive          │
│ #3B82F6 #4A5568           │
│ opacity:1 opacity:0.35    │
└─────────────────────────────┘
```

**Announcement Specs:**
| Property | Value |
|----------|-------|
| Container Width | 350px (100% - 40px padding) |
| Padding | 10px 14px |
| Border Radius | 13px (φRadius.md) |
| Background | rgba(59,130,246,0.08) |
| Border | 1px solid rgba(59,130,246,0.12) |
| Icon Size | 18px |
| Icon Color | #3B82F6 |
| Text Font | 13px (φ.sm) |
| Text Color | #8B95B3 (--tr-text-2) |
| Chevron Size | 13px (φIcon.sm) |
| Chevron Color | #4A5568 (--tr-text-3) |
| Dot Active | 16 × 5px, #3B82F6, opacity 1 |
| Dot Inactive | 5 × 5px, #4A5568, opacity 0.35 |
| Dot Gap | 6px (gap-1.5) |
| Dot Radius | 9999px (full) |

---

### 3. PORTFOLIO CARD

```
┌───────────────────────────────────────────────────────────────┐
│ PORTFOLIO CARD                                                │
│ Width: 350px | Padding: 22px 20px 20px                        │
│ Radius: 21px                                                  │
│                                                               │
│  Background: linear-gradient(145deg, #162040, #0e1833,        │
│                               #0a1228)                        │
│  Border: 1px solid rgba(59,130,246,0.10)                      │
│  Shadow: 0 2px 16px rgba(0,0,0,0.3)                           │
├───────────────────────────────────────────────────────────────┤
│  GLOW LAYER (z-0)                                             │
│  ┌──────────────────────────────────────────────────────┐    │
│  │  ╭──────────────────╮                                │    │
│  │  │  blue glow 20%   │ ←── radial at 85% 15%          │    │
│  │  ╰──────────────────╯                                │    │
│  │           ╭──────────────╮                           │    │
│  │           │ blue glow 12%│ ←── radial at 15% 85%     │    │
│  │           ╰──────────────╯                           │    │
│  └──────────────────────────────────────────────────────┘    │
├───────────────────────────────────────────────────────────────┤
│  CONTENT (z-10)                                               │
│                                                               │
│  ┌──────────────────────────────────────┬────────────────┐   │
│  │ Tổng tài sản (USDT)                  │   ┌────────┐   │   │
│  │ 13px, rgba(255,255,255,0.7)          │   │ 👁 / 🚫 │   │   │
│  │                                      │   │18px    │   │   │
│  │                                      │   │pad: 6px│   │   │
│  │                                      │   │32×32px │   │   │
│  │                                      │   └────────┘   │   │
│  └──────────────────────────────────────┴────────────────┘   │
│                                                               │
│  $54,276.79                                                   │
│  34px, weight 700, letter-spacing: -1px                      │
│  font: SF Mono, color: #FFFFFF                               │
│                                                               │
│  ┌────────────────────┐  ┌────────────────┐                  │
│  │  📈 +$1,842 (3.52%)│  │ hôm nay        │                  │
│  │  12px, weight 600  │  │ 10px, #4A5568  │                  │
│  │  bg: rgba(16,185,129,0.15)            │                  │
│  │  border: rgba(16,185,129,0.20)        │                  │
│  │  padding: 4px 10px                    │                  │
│  │  radius: 8px                          │                  │
│  └────────────────────┘  └────────────────┘                  │
│                                                               │
│  ┌─────────────────┬─────────────────┬─────────────────┐     │
│  │   ┌───────┐     │   ┌───────┐     │   ┌───────┐     │     │
│  │   │   ⬇️   │     │   │   ⬆️   │     │   │   👛   │     │     │
│  │   │  Nạp  │     │   │  Rút  │     │   │  Ví   │     │     │
│  │   └───────┘     │   └───────┘     │   └───────┘     │     │
│  │                 │                 │                 │     │
│  │ 44px height     │ 44px height     │ 44px height     │     │
│  │ 14px radius     │ 14px radius     │ 14px radius     │     │
│  │ flex-1          │ flex-1          │ flex-1          │     │
│  │                 │                 │                 │     │
│  │ gradient        │ glass           │ glass           │     │
│  │ #3B82F6 → 60%   │ bg: 10% white   │ bg: 10% white   │     │
│  │ shadow: glow    │ border: 18%     │ border: 18%     │     │
│  │                 │ blur: 8px       │ blur: 8px       │     │
│  └─────────────────┴─────────────────┴─────────────────┘     │
│              10px gap (gap-2.5)                               │
│                                                               │
└───────────────────────────────────────────────────────────────┘
```

**Portfolio Card Specs:**
| Property | Value |
|----------|-------|
| Container Width | 350px |
| Padding Top | 22px |
| Padding Horizontal | 20px |
| Padding Bottom | 20px |
| Border Radius | 21px (φRadius.lg) |
| Background | linear-gradient(145deg, #162040 0%, #0e1833 50%, #0a1228 100%) |
| Border | 1px solid rgba(59,130,246,0.10) |
| Box Shadow | 0 2px 16px rgba(0,0,0,0.3), 0 0 1px rgba(59,130,246,0.1) |

**Eye Toggle Button:**
| Property | Value |
|----------|-------|
| Size | 32 × 32px |
| Padding | 6px (p-1.5) |
| Border Radius | 8px |
| Icon Size | 18px |
| Icon Open | rgba(255,255,255,0.7) |
| Icon Closed | rgba(255,255,255,0.45) |

**Balance Text:**
| Property | Value |
|----------|-------|
| Font Size | 34px (φ.xl) |
| Font Weight | 700 |
| Font Family | SF Mono / -apple-system monospace |
| Letter Spacing | -1px |
| Line Height | 1.1 |
| Color | #FFFFFF |

**PnL Badge:**
| Property | Value |
|----------|-------|
| Padding | 4px 10px (py-1 px-2.5) |
| Border Radius | 8px |
| Background | rgba(16,185,129,0.15) |
| Border | 1px solid rgba(16,185,129,0.20) |
| Icon | TrendingUp 12px |
| Text | 12px, weight 600, #10B981 |

**Action Buttons Row:**
| Property | Value |
|----------|-------|
| Layout | flex |
| Gap | 10px (gap-2.5) |
| Button Height | 44px |
| Button Width | flex-1 (equal, ~103px each) |
| Border Radius | 14px |

**Primary Button (Nạp):**
| Property | Value |
|----------|-------|
| Background | linear-gradient(135deg, #3B82F6 0%, rgba(59,130,246,0.60) 100%) |
| Box Shadow | 0 4px 14px rgba(59,130,246,0.40), inset 0 1px 0 rgba(255,255,255,0.15) |
| Text Color | #FFFFFF |
| Font Size | 13px (φ.sm) |
| Font Weight | 600 |
| Icon | ArrowDownToLine 15px |
| Icon Stroke | 2.2 |
| Icon-Text Gap | 6px (gap-1.5) |

**Secondary Button (Rút/Ví):**
| Property | Value |
|----------|-------|
| Background | rgba(255,255,255,0.10) |
| Border | 1px solid rgba(255,255,255,0.18) |
| Backdrop Filter | blur(8px) |
| Text Color | #FFFFFF |
| Font Size | 13px (φ.sm) |
| Font Weight | 600 |
| Icon | ArrowUpFromLine/Wallet 15px |
| Icon Stroke | 2.2 |
| Icon-Text Gap | 6px (gap-1.5) |

---

### 4. QUICK ACTIONS GRID

```
┌─────────────────────────────────────────────────────────────┐
│ QUICK ACTIONS GRID                                          │
│ 3 columns | 5 rows | 13 items                               │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌─────────┐ ┌─────────┐ ┌─────────┐                       │
│  │   🔍    │ │   ⚡    │ │   🔄    │                       │
│  │  18px   │ │  18px   │ │  18px   │                       │
│  │         │ │         │ │         │                       │
│  │ Khám ph│ │ Mua nhan│ │ Convert │                       │
│  │  13px   │ │  13px   │ │  13px   │                       │
│  │  600w   │ │  600w   │ │  600w   │                       │
│  └─────────┘ └─────────┘ └─────────┘                       │
│       8px gap                                                │
│  ┌─────────┐ ┌─────────┐ ┌─────────┐                       │
│  │   📊    │ │   🚀    │ │   🏦    │                       │
│  │   P2P   │ │Launchpad│ │ Staking │                       │
│  └─────────┘ └─────────┘ └─────────┘                       │
│       8px gap                                                │
│  ┌─────────┐ ┌─────────┐ ┌─────────┐                       │
│  │   📅    │ │   🤖    │ │   📋    │                       │
│  │Mua định │ │   Bot   │ │Copy Trad│                       │
│  │   kỳ    │ │         │ │         │                       │
│  └─────────┘ └─────────┘ └─────────┘                       │
│       8px gap                                                │
│  ┌─────────┐ ┌─────────┐ ┌─────────┐                       │
│  │   💰    │ │   🎁    │ │   📈    │                       │
│  │ Tiết ki │ │Phần thư│ │ Margin  │                       │
│  │   ệm    │ │   ởng   │ │         │                       │
│  └─────────┘ └─────────┘ └─────────┘                       │
│       8px gap                                                │
│  ┌─────────┐                                               │
│  │   🎉    │                                               │
│  │ Giới thi│                                               │
│  │   ệu    │                                               │
│  └─────────┘                                               │
│                                                             │
└─────────────────────────────────────────────────────────────┘

EACH CARD:
┌───────────────────┐
│                   │
│      🔍           │ ◄── 18px emoji
│     icon          │
│                   │
│    Khám phá       │ ◄── 13px, weight 600
│     label         │
│                   │
└───────────────────┘
    auto width
    padding: 12px 0 (py-3)
    radius: 12px
```

**Quick Actions Specs:**
| Property | Value |
|----------|-------|
| Grid | 3 columns |
| Gap | 8px (gap-2) |
| Total Items | 13 |
| Card Padding | 12px vertical (py-3) |
| Card Border Radius | 12px (rounded-sm) |
| Icon Size | 18px (emoji) |
| Label Font | 13px (φ.sm) |
| Label Weight | 600 |
| Label Color | #F0F4FF (--tr-text-1) |
| Layout | flex flex-col items-center gap-1 |
| Hover | hover-card class |

---

### 5. SECTION HEADER

```
┌─────────────────────────────────────────────────────────────┐
│ SECTION HEADER                                              │
│ Height: ~33px | Margin Bottom: 12px                        │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌───────────────────────────────┬──────────────────────┐  │
│  │  ⚡ Xu hướng                  │  Xem tất cả ❯        │  │
│  │  21px, weight 700             │  13px, #3B82F6       │  │
│  │  #F0F4FF                      │  gap: 4px            │  │
│  │  gap: 6px (icon-text)         │  pad: 4px 8px        │  │
│  │                               │  radius: 8px         │  │
│  │  Icon: 21px                   │  Chevron: 13px       │  │
│  └───────────────────────────────┴──────────────────────┘  │
│                    flex justify-between                       │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

**Section Header Specs:**
| Property | Value |
|----------|-------|
| Layout | flex items-center justify-between |
| Margin Bottom | 12px (mb-3) |
| Title Font | 21px (φ.md) |
| Title Weight | 700 |
| Title Color | #F0F4FF (--tr-text-1) |
| Icon Size | 21px (φIcon.md) |
| Icon-Text Gap | 6px (mr-1.5) |
| Action Text | "Xem tất cả" |
| Action Font | 13px (φ.sm) |
| Action Color | #3B82F6 (--tr-primary) |
| Action Padding | 4px 8px (px-2 py-1) |
| Action Radius | 8px (rounded-lg) |
| Chevron Size | 13px (φIcon.sm) |
| Chevron Color | #3B82F6 |

---

### 6. MARKET TABS

```
┌─────────────────────────────────────────────────────────────┐
│ MARKET TABS                                                 │
│ Height: ~38px | Margin Bottom: 12px                        │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐           │
│  │  🔥 Hot │ │ 📈 Tăng │ │ 📉 Giảm │ │  🆕 Mới │           │
│  │         │ │         │ │         │ │         │           │
│  │ Active  │ │Inactive │ │Inactive │ │Inactive │           │
│  │ #3B82F6 │ │#8B95B3  │ │#8B95B3  │ │#8B95B3  │           │
│  │ 600w    │ │400w     │ │400w     │ │400w     │           │
│  └─────────┘ └─────────┘ └─────────┘ └─────────┘           │
│      8px gap                                                 │
│   6px 14px    6px 14px    6px 14px    6px 14px              │
│   padding     padding     padding     padding               │
│   8px radius  8px radius  8px radius  8px radius            │
│                                                             │
│   ACTIVE:                        INACTIVE:                  │
│   bg: rgba(59,130,246,0.12)      bg: transparent            │
│   border: rgba(59,130,246,0.25)  border: transparent        │
│   text: #3B82F6                  text: #8B95B3              │
│   weight: 600                    weight: 400                │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

**Market Tab Specs:**
| Property | Active | Inactive |
|----------|--------|----------|
| Padding | 6px 14px (py-1.5 px-3.5) | 6px 14px |
| Border Radius | 8px (φRadius.sm) | 8px |
| Background | rgba(59,130,246,0.12) | transparent |
| Border | 1px solid rgba(59,130,246,0.25) | 1px solid transparent |
| Text Color | #3B82F6 | #8B95B3 |
| Font Size | 13px (φ.sm) | 13px |
| Font Weight | 600 | 400 |
| Container Gap | 8px (gap-2) | - |
| Container Margin Bottom | 12px (mb-3) | - |

---

### 7. MARKET LIST ITEM

```
┌─────────────────────────────────────────────────────────────────────┐
│ MARKET LIST ITEM                                                    │
│ Height: 62px | Padding: 16px horizontal, 14px vertical             │
│ Border Bottom: 1px rgba(255,255,255,0.04) (except last)            │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  ┌────┬──────────────────┬──────────────┬─────────────────────┐    │
│  │    │  BTC/USDT        │   ╭────╮     │                     │    │
│  │    │  14px, 600w      │   │    │     │                     │    │
│  │ BTC│  #F0F4FF         │   │Chart│     │   $43,250.00        │    │
│  │ 34px│                  │   │64×30│     │   14px, 600w, mono  │    │
│  │    │  Vol $24.56B     │   ╰────╯     │   #F0F4FF           │    │
│  │ 🟠│  10px, #4A5568   │   gradient   │                     │    │
│  │    │                  │   fill       │   +2.45%            │    │
│  │    │                  │              │   10px, 600w        │    │
│  │    │                  │              │   #10B981 (green)   │    │
│  └────┴──────────────────┴──────────────┴─────────────────────┘    │
│    12px         flex-1                  12px         85px min       │
│    gap                                               right aligned  │
│                                                                     │
│  Crypto Icon: 34×34px, radius 8px                                   │
│  Background: {logoColor}18 (hex + 18 alpha)                        │
│  Text: First char, 13px, 700w, {logoColor}                         │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

**Market List Item Specs:**
| Property | Value |
|----------|-------|
| Layout | flex items-center gap-3 (12px) |
| Padding | 16px horizontal (px-4), 14px vertical (py-3.5) |
| Width | 100% |
| Border Bottom | 1px solid rgba(255,255,255,0.04) (c.divider) |
| Hover | background c.border, left border 2px c.primary |

**Crypto Icon:**
| Property | Value |
|----------|-------|
| Size | 34 × 34px (φAvatar.sm) |
| Border Radius | 8px (φRadius.sm) |
| Background | {logoColor}18 (hex + 18% alpha) |
| Text | First character of symbol |
| Text Size | 13px (φ.sm) |
| Text Weight | 700 |
| Text Color | logoColor |

**Pair Info:**
| Property | Value |
|----------|-------|
| Symbol Font | 14px (φ.body) |
| Symbol Weight | 600 |
| Symbol Color | #F0F4FF (--tr-text-1) |
| Volume Font | 10px (φ.xs) |
| Volume Color | #4A5568 (--tr-text-3) |

**Sparkline Chart:**
| Property | Value |
|----------|-------|
| Width | 64px |
| Height | 30px |
| Stroke Color | #10B981 (green) or #EF4444 (red) |
| Stroke Width | 1.5px |
| Fill | Gradient (30% → 0% opacity) |

**Price Section:**
| Property | Value |
|----------|-------|
| Min Width | 85px |
| Price Font | 14px (φ.body) |
| Price Weight | 600 |
| Price Family | monospace |
| Price Color | #F0F4FF (--tr-text-1) |
| Change Font | 10px (φ.xs) |
| Change Weight | 600 |
| Change Color | #10B981 (buy) or #EF4444 (sell) |

---

### 8. TRENDING CARD

```
┌─────────────────────────────────────────────────────────────┐
│ TRENDING CARD                                               │
│ Width: 148px | Height: ~88px | Padding: 16px               │
│ Radius: 16px                                                │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌────┬─────────────────────────────┐                      │
│  │ 🟠 │ BTC                         │                      │
│  │28px│ 14px, 600w                  │                      │
│  │    │ #F0F4FF                     │                      │
│  │ 5px│                             │                      │
│  │ rad│                             │                      │
│  └────┴─────────────────────────────┘                      │
│       8px gap                                                 │
│  $43,250.00                                                 │
│  16px, 700w, monospace                                      │
│  #F0F4FF                                                    │
│                                                             │
│  +2.45%                                                     │
│  10px, 600w                                                 │
│  #10B981                                                    │
│  margin-top: 3px                                            │
│                                                             │
└─────────────────────────────────────────────────────────────┘

HORIZONTAL SCROLL CONTAINER:
┌────────────────────────────────────────────────────────────────┐
│ flex gap-3 (12px)                                              │
│ overflow-x-auto                                                │
│ padding-bottom: 8px                                            │
│ negative-margin: -20px horizontal                              │
│ padding: 20px horizontal                                       │
│                                                                │
│ ┌──────┐ ┌──────┐ ┌──────┐ ┌──────┐ ┌──────┐                  │
│ │ 148px│ │ 148px│ │ 148px│ │ 148px│ │ 148px│                  │
│ │ card │ │ card │ │ card │ │ card │ │ card │                  │
│ └──────┘ └──────┘ └──────┘ └──────┘ └──────┘                  │
│      12px gap                                                  │
└────────────────────────────────────────────────────────────────┘
```

**Trending Card Specs:**
| Property | Value |
|----------|-------|
| Width | 148px |
| Padding | 16px (p-4) |
| Border Radius | 16px (default md) |
| Flex Shrink | 0 (shrink-0) |
| Text Align | left |

**Trending Icon:**
| Property | Value |
|----------|-------|
| Size | 28 × 28px |
| Border Radius | 5px (φRadius.xs) |
| Background | {logoColor}18 |
| Text | First char, 10px (φ.xs), 700w |

**Trending Text:**
| Property | Value |
|----------|-------|
| Symbol Font | 14px (φ.body), 600w |
| Price Font | 16px (φ.base), 700w, monospace |
| Change Font | 10px (φ.xs), 600w |
| Change Margin Top | 3px |

---

### 9. TOP GAINERS/LOSERS LIST

```
┌─────────────────────────────────────────────────────────────┐
│ TOP GAINERS LIST ITEM                                       │
│ Height: 62px | Padding: 16px horizontal, 14px vertical     │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌────┬────┬──────────────────┬─────────────────────┐      │
│  │ 1  │ 🟠 │ ETH/USDT         │      +8.42%         │      │
│  │    │    │                  │                     │      │
│  │ 20px│34px│ 14px, 600w       │  13px, 700w         │      │
│  │ wide│    │ #F0F4FF          │  #10B981            │      │
│  │center│    │                  │  rgba bg 10%        │      │
│  │ gold│    │                  │  pad: 4px 12px      │      │
│  │ #F59│    │                  │  radius: 5px        │      │
│  │ E0B │    │                  │                     │      │
│  └────┴────┴──────────────────┴─────────────────────┘      │
│    12px  12px       flex-1                                            │
│    gap   gap                                                          │
│                                                             │
│  Rank 2,3: color #4A5568 (gray)                             │
│  Rank 1: color #F59E0B (gold)                               │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

**Top Gainers/Losers Specs:**
| Property | Value |
|----------|-------|
| Layout | flex items-center gap-3 (12px) |
| Padding | 16px horizontal, 14px vertical |
| Border Bottom | 1px c.divider (except last) |

**Rank Badge:**
| Property | Value |
|----------|-------|
| Width | 20px |
| Text Align | center |
| Font Size | 13px (φ.sm) |
| Font Weight | 700 |
| Color #1 | #F59E0B (--tr-warn, gold) |
| Color #2,3 | #4A5568 (--tr-text-3) |

**Change Badge:**
| Property | Gainers | Losers |
|----------|---------|--------|
| Padding | 4px 12px | 4px 12px |
| Border Radius | 5px (φRadius.xs) | 5px |
| Background | rgba(16,185,129,0.10) | rgba(239,68,68,0.10) |
| Text Color | #10B981 | #EF4444 |
| Font Size | 13px (φ.sm) |
| Font Weight | 700 |

---

## 📐 SPACING & LAYOUT SUMMARY

### Page Structure
| Element | Height/Size | Margin/Padding |
|---------|-------------|----------------|
| Status Bar | 59px | - |
| Header | 52px | px-5, pt-2, pb-3 |
| PageContent | auto | px-5, pt-2 (compact) |
| PageContent Gap | - | 16px (default) |
| Tab Bar | 72px | - |

### Component Heights
| Component | Height | Notes |
|-----------|--------|-------|
| AnnouncementBanner | ~70px | incl. dots |
| PortfolioCard | ~200px | auto based on content |
| SectionHeader | 33px | mb-3 |
| QuickAction Card | ~52px | auto based on content |
| MarketTab | ~38px | mb-3 |
| MarketList Item | 62px | px-4 py-3.5 |
| TrendingCard | ~88px | fixed width 148px |
| TopGainer/Loser Item | 62px | px-4 py-3.5 |

### Gaps & Spacing
| Context | Gap Value |
|---------|-----------|
| PageContent sections | 16px |
| Header buttons | 6px (gap-1.5) |
| Portfolio action buttons | 10px (gap-2.5) |
| QuickActions grid | 8px (gap-2) |
| Market tabs | 8px (gap-2) |
| Market list items | 0 (border separated) |
| Trending cards | 12px (gap-3) |
| SectionHeader icon-text | 6px (mr-1.5) |
| SectionHeader action gap | 4px |

---

## 🎨 COLOR VALUES (Exact)

### Dark Mode (Default)
| Token | Hex | RGBA |
|-------|-----|------|
| --tr-bg | #0B0E17 | rgba(11,14,23,1) |
| --tr-surface | #141822 | rgba(20,24,34,1) |
| --tr-surface-2 | #1C2235 | rgba(28,34,53,1) |
| --tr-primary | #3B82F6 | rgba(59,130,246,1) |
| --tr-buy | #10B981 | rgba(16,185,129,1) |
| --tr-sell | #EF4444 | rgba(239,68,68,1) |
| --tr-warn | #F59E0B | rgba(245,158,11,1) |
| --tr-text-1 | #F0F4FF | rgba(240,244,255,1) |
| --tr-text-2 | #8B95B3 | rgba(139,149,179,1) |
| --tr-text-3 | #4A5568 | rgba(74,85,104,1) |

### Alpha Variants
| Token | Value |
|-------|-------|
| primaryAlpha08 | rgba(59,130,246,0.08) |
| primaryAlpha12 | rgba(59,130,246,0.12) |
| primaryAlpha20 | rgba(59,130,246,0.20) |
| primaryAlpha40 | rgba(59,130,246,0.40) |
| primaryAlpha60 | rgba(59,130,246,0.60) |
| buyAlpha10 | rgba(16,185,129,0.10) |
| buyAlpha15 | rgba(16,185,129,0.15) |
| buyAlpha20 | rgba(16,185,129,0.20) |
| sellAlpha10 | rgba(239,68,68,0.10) |
| sellAlpha15 | rgba(239,68,68,0.15) |

---

## ⚡ ANIMATION SPECIFICATIONS

| Animation | Duration | Easing | Properties |
|-----------|----------|--------|------------|
| Button Hover | 0.15s | cubic-bezier(0.4, 0, 0.2, 1) | all |
| Button Active/Press | instant | - | transform: scale(0.97) |
| Card Hover | 0.2s | ease | border, shadow, transform |
| Tab Switch | 0.2s | ease | background, border, color |
| Dot Pagination | 0.2s | ease | width, background, opacity |
| Ghost Hover | 0.15s | ease | background-color |
| Fade In Up | 0.3s | ease-out | opacity, transform |
| Press Ripple | 0.4s | ease-out | opacity, transform |
| Skeleton Pulse | 2s | ease-in-out | opacity |

---

## 🧮 GOLDEN RATIO (φ = 1.618)

### Typography Scale (√φ = 1.272)
| Token | Size | Calculation |
|-------|------|-------------|
| φ.xs | 10px | base |
| φ.sm | 13px | 10 × 1.272 ≈ 13 |
| φ.body | 14px | bridge |
| φ.base | 16px | bridge |
| φ.md | 21px | 16 × 1.272 ≈ 21 |
| φ.lg | 26px | 21 × 1.272 ≈ 27 (rounded) |
| φ.xl | 34px | 26 × 1.272 ≈ 33 (rounded) |

### Fibonacci Spacing
| Token | Value | Sequence |
|-------|-------|----------|
| φSpace.1 | 3px | - |
| φSpace.2 | 5px | 3+2 |
| φSpace.3 | 8px | 5+3 |
| φSpace.4 | 13px | 8+5 |
| φSpace.5 | 21px | 13+8 |
| φSpace.6 | 34px | 21+13 |
| φSpace.7 | 55px | 34+21 |

### Fibonacci Border Radius
| Token | Value |
|-------|-------|
| φRadius.xs | 5px |
| φRadius.sm | 8px |
| φRadius.md | 13px |
| φRadius.lg | 21px |
| φRadius.xl | 34px |

---

## 📱 DEVICE SPECIFICATIONS

### iPhone 14 Pro
| Property | Value |
|----------|-------|
| Logical Resolution | 390 × 844px |
| Physical Resolution | 1170 × 2532px (@3x) |
| Scale Factor | 3x |
| Safe Area Top | 59px (Dynamic Island) |
| Safe Area Bottom | 34px (Home Indicator) |
| Tab Bar Height | 52px |
| Total Bottom Chrome | 72px |
| Status Bar | 59px (incl. in safe top) |

### Content Area
| Property | Value |
|----------|-------|
| Width | 390px |
| Usable Width | 350px (with 20px padding) |
| Usable Height | 713px (844 - 59 - 72) |

---

*Blueprint generated for exact pixel implementation*
*All measurements in logical pixels (CSS pixels)*
*For iPhone 14 Pro viewport (390×844)*
