import React from 'react';

/**
 * ══════════════════════════════════════════════════════════════
 *  PageContent — Enterprise Standard Content Area
 * ══════════════════════════════════════════════════════════════
 *
 *  Standardizes the content area between Header and StickyFooter.
 *  Enforces consistent horizontal padding and vertical spacing
 *  across all pages.
 *
 *  SPACING SYSTEM (Guidelines §2.3 — 4pt base grid, 8pt rhythm):
 *  ─────────────────────────────────────────────────────────────
 *  Horizontal padding: 20px (device standard, matching Header px-5)
 *  Vertical padding presets:
 *    "compact" — pt-2 pb-0 (12px top) — lists, dense content
 *    "default" — pt-3 pb-0 (12px top) — standard pages
 *    "relaxed" — pt-4 pb-0 (16px top) — forms, settings
 *    "none"    — no padding          — custom hero/gradient
 *
 *  Gap presets (between child sections):
 *    "tight"   — 8px  — compact lists, dense cards
 *    "default" — 16px — standard sections
 *    "relaxed" — 24px — form groups, settings sections
 *    "loose"   — 32px — major page sections
 *    number    — custom px value
 *
 *  USAGE:
 *  ─────────────────────────────────────────────────────────────
 *  // Standard page
 *  <PageContent>
 *    <SectionHeader title="..." />
 *    <CardList />
 *  </PageContent>
 *
 *  // Form page with extra spacing
 *  <PageContent padding="relaxed" gap="relaxed">
 *    <InputField />
 *    <InputField />
 *  </PageContent>
 *
 *  // Page with flush-to-edge hero section
 *  <PageContent padding="none">
 *    <HeroBanner />  // full width
 *  </PageContent>
 *  <PageContent>     // back to standard padding
 *    <SectionHeader title="..." />
 *  </PageContent>
 *
 *  // Flex-grow for flush layout (pushes StickyFooter to bottom)
 *  <PageContent grow>
 *    <ShortContent />
 *  </PageContent>
 *
 *  ANTI-PATTERN GUARD:
 *  ─────────────────────────────────────────────────────────────
 *  Do NOT add mt, mb, or my margin classes to direct children.
 *  These margins stack with `gap` and produce non-standard spacing.
 *  Use the `gap` prop instead: tight(8) | default(16) | relaxed(24) | loose(32)
 *  Lint guard: see layout-lint.test.ts
 */

type PaddingPreset = 'compact' | 'default' | 'relaxed' | 'none';
type GapPreset = 'tight' | 'default' | 'relaxed' | 'loose';

interface PageContentProps {
  /** Vertical padding preset */
  padding?: PaddingPreset;
  /** Gap between child elements */
  gap?: GapPreset | number;
  /** flex-grow: 1 to fill remaining space (for flush layouts) */
  grow?: boolean;
  /** Remove horizontal padding (full-bleed sections) */
  fullBleed?: boolean;
  /** Additional className */
  className?: string;
  /** Additional inline styles */
  style?: React.CSSProperties;
  /** Content */
  children: React.ReactNode;
}

/* ─── Preset Mappings ─── */

const PADDING_MAP: Record<PaddingPreset, string> = {
  compact: 'pt-2',
  default: 'pt-3',
  relaxed: 'pt-4',
  none:    '',
};

const GAP_MAP: Record<GapPreset, number> = {
  tight:   8,
  default: 16,
  relaxed: 24,
  loose:   32,
};

export function PageContent({
  padding = 'default',
  gap = 'default',
  grow = false,
  fullBleed = false,
  className = '',
  style,
  children,
}: PageContentProps) {
  const gapValue = typeof gap === 'number' ? gap : GAP_MAP[gap];
  const paddingClass = PADDING_MAP[padding];
  const hPadding = fullBleed ? '' : 'px-5';

  return (
    <div
      className={[
        'flex flex-col',
        hPadding,
        paddingClass,
        grow ? 'flex-1' : '',
        className,
      ].filter(Boolean).join(' ')}
      style={{
        gap: gapValue,
        minHeight: grow ? 0 : undefined,
        ...style,
      }}
    >
      {children}
    </div>
  );
}

/**
 * ══════════════════════════════════════════════════════════════
 *  PageSection — Logical content grouping within PageContent
 * ══════════════════════════════════════════════════════════════
 *
 *  Groups related content with consistent internal spacing.
 *  Optionally shows a labeled divider or accent bar.
 *
 *  USAGE:
 *  <PageContent>
 *    <PageSection label="Giao dịch" accentColor="#3B82F6">
 *      <Card /><Card /><Card />
 *    </PageSection>
 *    <PageSection label="An toàn" accentColor="#10B981">
 *      <Card /><Card />
 *    </PageSection>
 *  </PageContent>
 */

interface PageSectionProps {
  /** Section label (optional, shows accent bar) */
  label?: string;
  /** Accent bar color (default: #3B82F6) */
  accentColor?: string;
  /** Internal gap between items */
  gap?: GapPreset | number;
  /** Additional className */
  className?: string;
  /** Content */
  children: React.ReactNode;
}

export function PageSection({
  label,
  accentColor = '#3B82F6',
  gap = 'tight',
  className = '',
  children,
}: PageSectionProps) {
  const gapValue = typeof gap === 'number' ? gap : GAP_MAP[gap];

  return (
    <div className={className}>
      {label && (
        <div className="flex items-center gap-1.5 mb-2">
          <div
            className="w-1 rounded-full shrink-0"
            style={{
              height: 14,
              background: `linear-gradient(180deg, ${accentColor}, ${accentColor}80)`,
            }}
          />
          <span style={{
            color: 'var(--tr-text-2)',
            fontSize: 11,
            fontWeight: 700,
            letterSpacing: 0.3,
          }}>
            {label}
          </span>
        </div>
      )}
      <div
        className="flex flex-col"
        style={{ gap: gapValue }}
      >
        {children}
      </div>
    </div>
  );
}