/**
 * ══════════════════════════════════════════════════════════════
 *  TrCard — Enterprise Trading Card Component
 * ══════════════════════════════════════════════════════════════
 *
 *  Enforces the 4 ONLY card patterns allowed in the design system:
 *
 *  | Variant    | Bg               | Border             | Shadow             |
 *  |------------|------------------|--------------------|--------------------|
 *  | standard   | c.surface        | c.cardBorder       | c.cardShadow       |
 *  | hero       | c.portfolioBg    | c.portfolioBorder  | c.portfolioShadow  |
 *  | inner      | c.surface2       | none               | none               |
 *  | ghost      | transparent      | none               | none               |
 *
 *  Usage:
 *    <TrCard>Content</TrCard>                          // standard
 *    <TrCard variant="hero">Balance</TrCard>           // hero/portfolio
 *    <TrCard variant="inner">Sub-section</TrCard>      // nested element
 *    <TrCard hover>Clickable card</TrCard>              // standard + hover effect
 *    <TrCard rounded="lg">Featured</TrCard>             // rounded-3xl
 *    <TrCard accentBorder="rgba(16,185,129,0.2)">...</TrCard>  // custom border
 *    <TrCard as="button" onClick={...}>Tap me</TrCard>  // renders <button>
 */

import React from 'react';
import { useThemeColors, type ThemeColors } from '../../hooks/useThemeColors';

/* ─── Variant Config ────────────────────────────── */

type CardVariant = 'standard' | 'hero' | 'inner' | 'ghost';

const VARIANT_STYLES = (c: ThemeColors) => ({
  standard: {
    background: c.surface,
    border: `1px solid ${c.cardBorder}`,
    boxShadow: c.cardShadow,
  },
  hero: {
    background: c.portfolioBg,
    border: `1px solid ${c.portfolioBorder}`,
    boxShadow: c.portfolioShadow,
  },
  inner: {
    background: c.surface2,
    border: 'none',
    boxShadow: 'none',
  },
  ghost: {
    background: 'transparent',
    border: 'none',
    boxShadow: 'none',
  },
} as const);

/* ─── Props ─────────────────────────────────────── */

type BaseElement = 'div' | 'button' | 'section' | 'article';

interface TrCardProps {
  /** Card pattern variant (default: 'standard') */
  variant?: CardVariant;
  /** Border radius: 'md' = rounded-2xl (16px), 'lg' = rounded-3xl (24px), 'sm' = rounded-xl (12px) */
  rounded?: 'sm' | 'md' | 'lg';
  /** Add hover-card interaction class */
  hover?: boolean;
  /** Clip overflow (e.g. for cards with header images) */
  overflow?: boolean;
  /** Override border color (e.g. contextual green/red for position cards) */
  accentBorder?: string;
  /** HTML element to render */
  as?: BaseElement;
  /** Additional inline styles (merged after variant tokens) */
  style?: React.CSSProperties;
  /** Additional CSS classes */
  className?: string;
  /** Content */
  children?: React.ReactNode;
  /** Pass-through props */
  onClick?: React.MouseEventHandler;
  onMouseEnter?: React.MouseEventHandler;
  onMouseLeave?: React.MouseEventHandler;
  id?: string;
  role?: string;
  'aria-label'?: string;
  'data-testid'?: string;
}

/* ─── Radius Map ────────────────────────────────── */

const RADIUS_MAP = {
  sm: 'rounded-xl',
  md: 'rounded-2xl',
  lg: 'rounded-3xl',
} as const;

/* ─── Component ─────────────────────────────────── */

export function TrCard({
  variant = 'standard',
  rounded = 'md',
  hover = false,
  overflow = false,
  accentBorder,
  as: Component = 'div',
  style,
  className = '',
  children,
  ...rest
}: TrCardProps) {
  const c = useThemeColors();
  const variantStyle = VARIANT_STYLES(c)[variant];

  const mergedStyle: React.CSSProperties = {
    ...variantStyle,
    ...(accentBorder ? { border: `1px solid ${accentBorder}` } : {}),
    ...style,
  };

  const classes = [
    RADIUS_MAP[rounded],
    overflow ? 'overflow-hidden' : '',
    hover ? 'hover-card' : '',
    className,
  ].filter(Boolean).join(' ');

  return (
    <Component
      className={classes}
      style={mergedStyle}
      {...rest}
    >
      {children}
    </Component>
  );
}

/* ─── Sub-component: Inner stat box (for hero cards) ─── */

interface TrCardStatProps {
  children?: React.ReactNode;
  className?: string;
  style?: React.CSSProperties;
}

export function TrCardStat({ children, className = '', style }: TrCardStatProps) {
  const c = useThemeColors();
  return (
    <div
      className={`rounded-xl p-2.5 ${className}`}
      style={{ background: c.portfolioBtnGhost, ...style }}
    >
      {children}
    </div>
  );
}
