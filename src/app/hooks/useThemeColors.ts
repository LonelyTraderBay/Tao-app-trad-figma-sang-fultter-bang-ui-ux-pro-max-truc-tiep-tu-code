/**
 * ══════════════════════════════════════════════════════════
 *  useThemeColors — Semantic color tokens for inline styles
 * ══════════════════════════════════════════════════════════
 *
 *  UNIFIED: All values now reference CSS custom properties
 *  from theme.css (single source of truth). The `.dark` / `.light`
 *  class on <html> handles theme switching automatically.
 *
 *  Components use: `const c = useThemeColors()` then
 *  `style={{ color: c.text1 }}` — works because React inline
 *  styles accept CSS var() references as string values.
 */

const TOKENS = {
  bg: 'var(--tr-bg)',
  surface: 'var(--tr-surface)',
  surface2: 'var(--tr-surface-2)',
  surface3: 'var(--tr-surface-3)',
  border: 'var(--tr-border)',
  borderSolid: 'var(--tr-border-solid)',
  primary: 'var(--tr-primary)',
  buy: 'var(--tr-buy)',
  sell: 'var(--tr-sell)',
  warn: 'var(--tr-warn)',
  accent: 'var(--tr-accent)',

  // Semantic aliases (map to existing CSS variables)
  success: 'var(--tr-buy)',      // #10B981 — green
  error: 'var(--tr-sell)',       // #EF4444 — red
  warning: 'var(--tr-warn)',     // #F59E0B — yellow

  text1: 'var(--tr-text-1)',
  text2: 'var(--tr-text-2)',
  text3: 'var(--tr-text-3)',

  // Chips/Tabs
  chipActiveBg: 'var(--tr-chip-active-bg)',
  chipActiveText: 'var(--tr-chip-active-text)',
  chipActiveBorder: 'var(--tr-chip-active-border)',
  chipBg: 'var(--tr-chip-bg)',
  chipText: 'var(--tr-chip-text)',
  chipBorder: 'var(--tr-chip-border)',

  // StatusBar
  statusBarText: 'var(--tr-status-bar-text)',
  statusBarIcon: 'var(--tr-status-bar-icon)',
  statusBarIconDim: 'var(--tr-status-bar-icon-dim)',
  statusBarBattery: 'var(--tr-status-bar-battery)',

  // BottomNav
  navBg: 'var(--tr-nav-bg)',
  navBorder: 'var(--tr-nav-border)',
  navInactive: 'var(--tr-nav-inactive)',
  navActive: 'var(--tr-nav-active)',
  navCenterBg: 'var(--tr-nav-center-bg)',
  navCenterIcon: 'var(--tr-nav-center-icon)',
  navGradientFrom: 'var(--tr-nav-gradient-from)',
  navGradientMid: 'var(--tr-nav-gradient-mid)',
  navGradientTo: 'var(--tr-nav-gradient-to)',

  // MobileFrame
  frameBg: 'var(--tr-frame-bg)',
  frameOuter: 'var(--tr-frame-outer)',

  // Dynamic Island
  diBackground: 'var(--tr-di-bg)',

  // Home indicator
  homeBar: 'var(--tr-home-bar)',

  // Cards
  cardBg: 'var(--tr-card-bg)',
  cardBorder: 'var(--tr-card-border)',
  cardShadow: 'var(--tr-card-shadow)',

  // Hover
  hoverBg: 'var(--tr-hover-bg)',

  // Search bar
  searchBg: 'var(--tr-search-bg)',
  searchBorder: 'var(--tr-search-border)',
  searchPlaceholder: 'var(--tr-search-placeholder)',

  // Divider
  divider: 'var(--tr-divider)',

  // Portfolio card
  portfolioBg: 'var(--tr-portfolio-bg)',
  portfolioBorder: 'var(--tr-portfolio-border)',
  portfolioShadow: 'var(--tr-portfolio-shadow)',
  portfolioTextDim: 'var(--tr-portfolio-text-dim)',
  portfolioTextMuted: 'var(--tr-portfolio-text-muted)',
  portfolioBtnGhost: 'var(--tr-portfolio-btn-ghost)',
  portfolioBtnGhostBorder: 'var(--tr-portfolio-btn-ghost-border)',
  portfolioBtnGhostText: 'var(--tr-portfolio-btn-ghost-text)',

  // Section
  sectionLabelColor: 'var(--tr-section-label-color)',

  // Toggle
  toggleTrackOff: 'var(--tr-toggle-track-off)',

  // Warning/Alert
  warningBg: 'var(--tr-warning-bg)',
  warningBorder: 'var(--tr-warning-border)',
  warningText: 'var(--tr-warning-text)',

  // ─── Alpha variants (for decorative/overlay uses where CSS var + hex is invalid) ───
  // Primary alpha
  primaryAlpha08: 'rgba(59,130,246,0.08)',
  primaryAlpha12: 'rgba(59,130,246,0.12)',
  primaryAlpha15: 'rgba(59,130,246,0.15)',
  primaryAlpha20: 'rgba(59,130,246,0.20)',
  primaryAlpha30: 'rgba(59,130,246,0.30)',
  primaryAlpha40: 'rgba(59,130,246,0.40)',
  primaryAlpha60: 'rgba(59,130,246,0.60)',
  // Buy (green) alpha
  buyAlpha10: 'rgba(16,185,129,0.10)',
  buyAlpha15: 'rgba(16,185,129,0.15)',
  buyAlpha20: 'rgba(16,185,129,0.20)',
  // Sell (red) alpha
  sellAlpha10: 'rgba(239,68,68,0.10)',
  sellAlpha15: 'rgba(239,68,68,0.15)',
  sellAlpha20: 'rgba(239,68,68,0.20)',
  // Warn alpha
  warnAlpha10: 'rgba(245,158,11,0.10)',
  warnAlpha15: 'rgba(245,158,11,0.15)',
  // Accent (purple) alpha
  accentAlpha06: 'rgba(139,92,246,0.06)',
  accentAlpha08: 'rgba(139,92,246,0.08)',
  accentAlpha10: 'rgba(139,92,246,0.10)',
  accentAlpha12: 'rgba(139,92,246,0.12)',
  accentAlpha15: 'rgba(139,92,246,0.15)',
  accentAlpha20: 'rgba(139,92,246,0.20)',
  accentAlpha30: 'rgba(139,92,246,0.30)',

  // ─── Deprecated aliases (backward compat for Gen 2.5 pages) ───
  // These map phantom token names to real CSS vars.
  // New code should use the canonical names above.

  /** @deprecated Use `text1` */
  text: 'var(--tr-text-1)',
  /** @deprecated Use `text1` */
  textPrimary: 'var(--tr-text-1)',
  /** @deprecated Use `text3` */
  textSecondary: 'var(--tr-text-3)',
  /** @deprecated Use `text3` */
  textTertiary: 'var(--tr-text-3)',
  /** @deprecated Use `bg` */
  background: 'var(--tr-bg)',
  /** @deprecated Use `hoverBg` */
  surfaceHover: 'var(--tr-hover-bg)',
  /** @deprecated Use `primary` */
  primaryHover: 'var(--tr-primary)',
} as const;

export type ThemeColors = typeof TOKENS;

/**
 * Returns semantic color tokens backed by CSS custom properties.
 * No theme dependency needed — CSS handles dark/light switching
 * via `.dark` / `.light` class on <html>.
 */
export function useThemeColors(): ThemeColors {
  return TOKENS;
}