# AGENTS.md — VitTrade Mobile Trading App

**Project:** VitTrade — Enterprise Crypto Trading App  
**Tech Stack:** React 18 + TypeScript + Vite + Tailwind CSS v4  
**Package Manager:** npm (with pnpm overrides configured)  
**Test Framework:** Vitest + React Testing Library  
**Last Updated:** 2026-05-19

**AI docs entrypoint:** Read `docs/00_START_HERE.md` before using any long-form migration or design guidance. For Flutter migration coverage, the current source of truth is `output/flutter-ui-reference/manifest.json` plus `docs/02_FLUTTER_MIGRATION/Flutter-Port-Master-Plan.md`.

---

## 1. Project Overview

VitTrade is a comprehensive mobile-first cryptocurrency trading application. The current Flutter reference baseline is **401 phone screens** from `output/flutter-ui-reference/manifest.json`; historical route counts in older docs must not override that baseline. The app includes multiple financial modules:

| Module | Description | Key Pages |
|--------|-------------|-----------|
| **Core Trading** | Spot trading, margin trading, order management | TradePage, OrdersHistoryPage |
| **Wallet** | Deposits, withdrawals, transfers, portfolio analytics | WalletPage, DepositPage, WithdrawPage |
| **P2P Trading** | Peer-to-peer crypto marketplace with escrow | 73 captured phone screens covering marketplace, orders, disputes, KYC |
| **Prediction Markets** | Event-based prediction trading (value-based) | PredictionsHomePage, PredictionEventDetailPage |
| **Open Arena** | Creator-driven, points-only social gaming module | ArenaHomePage, ArenaStudioPage (26 pages) |
| **Copy Trading** | Follow and copy professional traders | CopyTradingPage, CopyProviderDetailPage |
| **Trading Bots** | Automated trading strategies | TradingBotsPage + compliance & analytics sub-pages |
| **Earn/Staking** | Savings, staking, and yield products | 70 captured earn/staking screens |
| **Launchpad** | IDO and token sale platform | LaunchpadPage, LaunchpadDetailPage |
| **DCA** | Dollar-cost averaging investment tool | DCAPage, DCARebalanceConfig |

### Key Design Principles (from Guidelines)

1. **Trust-first** — UI must convey trustworthiness, control, and clear disclosures
2. **Boundary Clarity** — Users must always understand if they're on trading/value surfaces vs. points-only/social surfaces
3. **Clarity over Density** — Prioritize quick scanning and correct decisions
4. **Beginner-first, Pro-available** — New users can complete tasks without getting lost
5. **Safety-by-design** — Risky actions have preview, confirm, and state indicators
6. **No Dark Patterns** — No FOMO, hype, hidden fees, or casino-like experiences

### Module Boundaries (CRITICAL)

**Prediction Markets** (value-based) and **Open Arena** (points-only) must **NEVER** merge:

| ❌ NEVER Merge | Prediction Markets | Open Arena |
|----------------|-------------------|------------|
| Currency | Wallet balance | Arena Points |
| Performance | PnL | Points pool |
| History | Order receipts | Ledger entries |
| Leaderboard | Trading volume | Fair play / Completion |

**Safe Bridge Points** (allowed): Topic/category, event context, creator discovery, search/discovery, profile surface (separate sections)

---

## 2. Technology Stack

### Core Dependencies

| Category | Libraries |
|----------|-----------|
| **Framework** | React 18.3.1, React DOM 18.3.1 |
| **Routing** | React Router 7.1.1 |
| **Build Tool** | Vite 6.3.5 with @vitejs/plugin-react |
| **Styling** | Tailwind CSS 4.1.12, @tailwindcss/vite |
| **UI Components** | Radix UI primitives (30+ components), shadcn/ui |
| **Animation** | motion (Framer Motion successor) 12.23.24 |
| **Charts** | Recharts 2.15.2, lightweight-charts 5.1.0 |
| **State/Forms** | React Hook Form 7.55.0 |
| **PDF/Export** | html2canvas 1.4.1, jspdf 4.2.0 |
| **Testing** | Vitest 4.0.18, @testing-library/react, jsdom |

### Important Technical Constraints

- **NO lazy loading** — All components are eagerly loaded for Figma iframe compatibility
- **Module type: ES Modules** (`"type": "module"` in package.json)
- **Path alias: `@`** — Always use `@/` for imports from `src/`
- **Dedupe configuration** — Critical for preventing "Invalid hook call" errors (see vite.config.ts)

---

## 3. Project Structure

```
src/
├── app/
│   ├── components/               # Reusable components
│   │   ├── ui/                   # Base UI components (shadcn + custom)
│   │   ├── layout/               # Layout components (PageLayout, Header, etc.)
│   │   ├── trading/              # Trading-specific components
│   │   ├── p2p/                  # P2P-specific components
│   │   ├── arena/                # Arena-specific components
│   │   ├── dca/                  # DCA-specific components
│   │   ├── mobile/               # Mobile-specific UX components
│   │   └── web/                  # Web/desktop-specific components
│   ├── pages/                    # Page components (route targets)
│   │   ├── auth/                 # Authentication pages
│   │   ├── market/               # Market/Home pages
│   │   ├── markets/              # Markets module pages
│   │   ├── trade/                # Trading pages (87 captured phone screens)
│   │   ├── wallet/               # Wallet pages
│   │   ├── profile/              # Profile pages
│   │   ├── p2p/                  # P2P pages (73 captured phone screens)
│   │   ├── arena/                # Arena pages (26 pages)
│   │   ├── predictions/          # Prediction markets pages
│   │   ├── earn/                 # Earn/Staking pages
│   │   ├── launchpad/            # Launchpad pages
│   │   ├── dca/                  # DCA pages
│   │   ├── web/                  # Web-specific pages
│   │   └── responsive/           # Responsive/shared pages
│   ├── hooks/                    # Custom React hooks
│   ├── contexts/                 # React contexts (Auth, Theme, UI, DCA)
│   ├── types/                    # TypeScript type definitions
│   ├── utils/                    # Utility functions
│   ├── data/                     # Mock data and formatters
│   ├── constants/                # App constants (config, colors, routes)
│   ├── services/                 # Business logic services
│   ├── providers/                # Context providers
│   ├── routes.ts                 # Main router with shell definitions
│   └── routeConfig.ts            # Route builders (createPublicRoutes, etc.)
├── components/                   # Additional components (outside app/)
├── styles/                       # Global styles
│   ├── index.css                 # Main CSS entry
│   ├── tailwind.css              # Tailwind directives
│   ├── theme.css                 # Theme variables
│   └── fonts.css                 # Font definitions
├── test/                         # Test utilities and setup
│   ├── setup.ts                  # Vitest global setup
│   └── mocks/                    # Mock data for tests
└── main.tsx                      # Application entry point
```

---

## 4. Build & Development Commands

```bash
# Install dependencies
npm install

# Start development server
npm run dev
# or
vite

# Build for production
npm run build
# or
vite build

# Run tests (watch mode)
npm test
# or
vitest

# Run tests once (CI)
npm run test:run
# or
vitest run

# Run tests with UI
npm run test:ui
# or
vitest --ui

# Run tests with coverage
npm run test:coverage
# or
vitest run --coverage
```

### Important Build Notes

- **Do NOT add `.css`, `.tsx`, or `.ts` to `assetsInclude`** in vite.config.ts
- React and Tailwind plugins are required even if Tailwind is not actively used
- The `@` alias points to `./src` directory

---

## 5. Routing Architecture (3-Shell System)

The app uses a **3-Shell Architecture**:

| Shell | Path Prefix | Characteristics |
|-------|-------------|-----------------|
| **Phone** | `/` (default) | Touch-first, single-column, gesture-heavy |
| **Tablet** | `/t/` | Split-view, floating sidebar, 2-column grids |
| **Web** | `/w/` | Multi-panel, full sidebar, command bar, keyboard shortcuts |
| **Responsive (Legacy)** | `/r/` | Backward compatibility shell |

### Route Configuration Files

- **`src/app/routes.ts`** — Main router with shell definitions
- **`src/app/routeConfig.ts`** — Route builders (createPublicRoutes, createProtectedRoutes, createAuthBlock)
- **`src/app/routes/stakingRoutes.lazy.ts`** — Lazy-loaded staking routes (exception to eager loading)

### Key Routing Patterns

```typescript
// Phone shell uses direct page components
const phoneOverrides: ShellOverrides = {
  HomePage, MarketListPage, PairDetailPage, TradePage, // ...
};

// Tablet shell uses responsive variants
const tabletOverrides: ShellOverrides = {
  HomePage: ResponsiveHomePage,
  // ...
};

// Web shell uses desktop-optimized pages
const webOverrides: ShellOverrides = {
  HomePage: WebHomePage,
  // ...
};
```

---

## 6. Layout System (MUST USE)

**CRITICAL:** All new pages MUST use the layout template system. Do NOT create custom layout divs.

### Required Imports

```tsx
import {
  PageLayout,
  StickyFooter,
} from "../../components/layout/PageLayout";
import {
  PageContent,
  PageSection,
} from "../../components/layout/PageContent";
import { Header } from "../../components/layout/Header";
import { TabBar } from "../../components/layout/TabBar";
```

### PageLayout Variants

| Variant | Background | Bottom Pad | Use Case |
|---------|------------|------------|----------|
| `default` | c.bg | pb-8 (32px) | Standard scrollable content (~90%) |
| `surface` | c.surface | pb-8 (32px) | Settings, forms, modal-like pages |
| `flush` | c.bg | 0 | Pages with StickyFooter |
| `immersive` | none | pb-8 (32px) | Custom gradient/chart backgrounds |

### Approved Page Patterns

**Pattern A — Standard Page:**
```tsx
<PageLayout>
  <Header title="Tiêu đề" back />
  <PageContent>{/* content */}</PageContent>
</PageLayout>
```

**Pattern B — Page with Tabs:**
```tsx
<PageLayout>
  <Header title="Tiêu đề" back />
  <TabBar tabs={TABS} active={tab} onChange={setTab} />
  <PageContent>{/* tab content */}</PageContent>
</PageLayout>
```

**Pattern C — Form/Wizard with Bottom CTA:**
```tsx
<PageLayout variant="flush">
  <Header title="Step 1" back />
  <PageContent grow>{/* form fields */}</PageContent>
  <StickyFooter>
    <CTAButton>Xác nhận</CTAButton>
  </StickyFooter>
</PageLayout>
```

### Header Gold Standard

```tsx
// ✅ GOLD STANDARD — Breadcrumb auto-enabled with back=true
<Header title="Trading Bots" back />

// With right-side action
<Header
  title="Security Center"
  back
  action={{ icon: Settings, onClick: () => navigate('/settings') }}
/>
```

---

## 7. Component Guidelines

### UI Components

Base UI components are in `src/app/components/ui/`. These include:

- **Custom components:** TrCard, CTAButton, IconButton, StatCard, BottomSheetV2
- **Shadcn/ui components:** Button, Input, Dialog, Sheet, Tabs, etc.

**Export Pattern:**
```typescript
// Import from central index
import { TrCard, CTAButton, StatCard } from '@/components/ui';
```

### Component Naming Conventions

- **Pages:** `{Feature}{Action}Page.tsx` (e.g., `P2POrderPage.tsx`)
- **Components:** PascalCase, descriptive (e.g., `BottomSheetV2.tsx`)
- **Hooks:** `use{Feature}` camelCase (e.g., `useThemeColors.ts`)
- **Utilities:** camelCase, descriptive (e.g., `formatNumber.ts`)
- **Types:** PascalCase, often with suffix (e.g., `PredictionEvent.ts`)

### Performance Rules

- **DO NOT** import `motion` in page components unless complex animation is needed
- **DO NOT** use `useFadeInTab` for tab content — let PageTransition handle it
- TabBar uses pure CSS transitions (not `layoutId`)
- Accordion uses `grid-template-rows: 0fr → 1fr` (not `useEffect` + `scrollHeight`)
- `useThemeColors()` is safe to call multiple times (zero re-renders)

---

## 8. Testing Strategy

### Test Configuration

- **Framework:** Vitest 4.x with jsdom environment
- **Setup:** `src/test/setup.ts`
- **Global Matchers:** `@testing-library/jest-dom`

### Test File Locations

```
src/app/__tests__/          # Component tests
src/app/hooks/__tests__/    # Hook tests  
src/app/pages/**/__tests__/ # Page-specific tests
tests/                      # Dedicated test suites
```

### Coverage Configuration

```typescript
thresholds: {
  lines: 90,
  functions: 85,
  branches: 80,
  statements: 90,
}
```

### Running Tests

```bash
# Watch mode
npm test

# Single run
npm run test:run

# With UI
npm run test:ui

# Coverage report
npm run test:coverage
```

### Mock Setup

The test setup provides mocks for:
- `window.matchMedia`
- `IntersectionObserver`
- `ResizeObserver`
- `HTMLCanvasElement.getContext`
- `localStorage` / `sessionStorage`

---

## 9. Styling & Theming

### Tailwind CSS v4

Tailwind v4 uses a new configuration approach:

```css
/* src/styles/tailwind.css */
@import 'tailwindcss' source(none);
@source '../**/*.{js,ts,jsx,tsx}';
@import 'tw-animate-css';
```

### Spacing System

- **Base grid:** 4pt
- **Rhythm:** 8pt for layout
- **Common values:** 4 / 8 / 12 / 16 / 20 / 24 / 32 / 40 / 48 / 52

### Breakpoints

| Device | Width |
|--------|-------|
| Mobile (base) | 390px |
| Support | 360 / 375 / 390 / 414 / 428 |
| Tablet | 768 / 834 |
| Desktop | 1280 / 1440 |

### Theme Colors

Access theme colors via the `useThemeColors()` hook:

```tsx
const c = useThemeColors();
// Returns: { bg, surface, text, textSecondary, primary, ... }
```

---

## 10. Type System

### Central Type Exports

All types are exported from `src/app/types/index.ts`:

```typescript
import type { User, Order, ArenaRoom, PredictionEvent } from '@/types';
```

### Type Categories

- **common.ts** — Base entities, UI props, state types, forms
- **trading.ts** — Orders, positions, portfolio, market data
- **arena.ts** — Arena rooms, points, trust & safety
- **prediction.ts** — Events, outcomes, positions
- **p2p.ts** — Ads, orders, disputes, payment methods
- **dca.ts** — DCA plans and schedules

---

## 11. Copy Guidelines (Language)

The codebase contains **Vietnamese content** in UI copy. Follow these guidelines:

### Arena (MUST use)
- "Arena Points"
- "pool điểm"
- "chốt kết quả"
- "thử thách"

### Arena (MUST NOT use)
- "payout USD"
- "profit"
- "wallet value"
- "stake return"

### Prediction Markets
- Can use: positions, open orders, probability, event, rewards, receipt, P/L
- Must NOT use hype/casino language

---

## 12. Security Considerations

### High-Risk Actions Requiring Confirm

- Withdrawals
- Escrow release (P2P)
- Password changes
- Disabling 2FA
- Adding addresses
- Changing P2P payment methods

### Sensitive Data Handling

- Mask addresses (show first/last 4 chars)
- Mask email/phone
- Toast confirmation on copy actions

### Demo Mode

P2P is non-interactive in demo mode with disabled overlay.

---

## 13. Common Pitfalls & Rules

### MUST NOT

- Add Arena/Prediction tabs to bottom navigation
- Merge Arena Points with wallet/PnL
- Use financial copy for Arena
- Use casino/FOMO copy for Prediction/P2P
- Create pages without using `PageLayout`/`Header`
- Use `h-screen` / `calc(100vh)` inside layouts
- Add `.css`, `.tsx`, `.ts` to `assetsInclude`
- Remove React or Tailwind plugins from Vite config
- Use lazy loading for main route components (Figma iframe compatibility)

### MUST

- Use `PageLayout` + `Header` + `PageContent` for all pages
- Include `back` prop on inner/detail pages
- Use semantic color tokens (not hardcoded colors)
- Follow 4pt base grid
- Support 360px+ mobile widths
- Include loading/empty/error/offline states
- Use `CTAButton` for primary actions
- Include fee breakdown before confirm

---

## 14. Development Workflow

### Adding a New Page

1. Create page component in appropriate `src/app/pages/{module}/` directory
2. Import page in `src/app/routeConfig.ts` (eager import)
3. Add route in appropriate route builder function
4. Use `PageLayout` + `Header` + `PageContent` pattern
5. Add `back` prop for detail pages
6. Add tests in `src/app/pages/{module}/__tests__/` if applicable

### Adding a New Component

1. Check if existing component can be extended
2. Place in `src/app/components/{category}/`
3. Export from `src/app/components/ui/index.ts` if it's a shared UI component
4. Follow naming conventions
5. Add tests in `src/app/__tests__/` or adjacent to component

### Adding New Types

1. Define in appropriate `src/app/types/{category}.ts` file
2. Export from `src/app/types/index.ts`
3. Use TypeScript strict mode features

---

## 15. Additional Resources

- **Docs entrypoint:** See `docs/00_START_HERE.md` for the required AI reading order.
- **Guidelines:** See `docs/03_DESIGN_SYSTEM/Guidelines.md` for complete design system documentation (written in Vietnamese/English mix).
- **Flutter migration plan:** See `docs/02_FLUTTER_MIGRATION/Flutter-Port-Master-Plan.md`.
- **Figma:** Original designs at https://www.figma.com/design/ZcOH6oGTyUcPYT7TmGyDIi/Mobile-Trading-App-Design
- **Shadcn/ui:** Components based on https://ui.shadcn.com/

---

*This document is maintained for AI coding agents. When in doubt, follow existing code patterns, then read `docs/00_START_HERE.md` to choose the correct long-form reference.*
