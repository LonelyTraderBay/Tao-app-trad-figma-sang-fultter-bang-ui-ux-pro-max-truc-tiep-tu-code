/**
 * WalletDCAShortcut - Quick Access to DCA from Wallet
 * 
 * Displays DCA summary and provides quick navigation to DCA page.
 * Shows active plans count, total invested, and next execution.
 * 
 * Integrated with:
 * - Analytics tracking (impressions, clicks)
 * - Feature flags (show/hide based on rollout)
 * - A/B testing (full vs compact variant)
 * - Funnel tracking (wallet to creation journey)
 * 
 * @module components/dca/WalletDCAShortcut
 * @version 2.0 (Phase 2 - Sprint 2)
 */

import { useEffect, type CSSProperties } from 'react';
import { useNavigate } from 'react-router';
import { useRoutePrefix } from '../../hooks/useRoutePrefix';
import { useThemeColors, type ThemeColors } from '../../hooks/useThemeColors';
import { useHaptic } from '../../hooks/useHaptic';
import { useDCA } from '../../contexts/DCAContext';
import { TrCard } from '../ui/TrCard';
import { φ, φIcon, φAvatar } from '../../utils/golden';
import { fmtVnd } from '../../data/formatNumber';
import { Repeat, ChevronRight, Clock, TrendingUp, Sparkles } from 'lucide-react';
import { ALPHA, withAlpha } from '../../constants/colors';

// Analytics & Feature Flags
import { useDCAAnalytics } from '../../hooks/useDCAAnalytics';
import { useDCAWalletShortcut } from '../../hooks/useFeatureFlag';
import { useWalletShortcutTest } from '../../hooks/useABTest';
import { useWalletToCreationFunnel } from '../../hooks/useFunnelTracking';

const DCA_CARD_SHADOW = '0 16px 32px rgba(15,23,42,0.05), inset 0 1px 0 rgba(255,255,255,0.6)';
const DCA_CONTROL_SHADOW = '0 8px 18px rgba(15,23,42,0.04)';

function getShortcutCardStyle(c: ThemeColors): CSSProperties {
  return {
    background: `linear-gradient(160deg, ${withAlpha('#FFFFFF', ALPHA.hover)} 0%, ${withAlpha(c.accent, ALPHA.ghost)} 15%, ${c.surface} 52%, ${c.surface2} 100%)`,
    border: `1px solid ${withAlpha(c.accent, ALPHA.ghost)}`,
    boxShadow: DCA_CARD_SHADOW,
  };
}

function getIconTileStyle(c: ThemeColors, accent: string): CSSProperties {
  return {
    background: `linear-gradient(180deg, ${withAlpha('#FFFFFF', ALPHA.hover)} 0%, ${withAlpha(accent, ALPHA.ghost)} 100%)`,
    border: `1px solid ${withAlpha(accent, ALPHA.ghost)}`,
    boxShadow: DCA_CONTROL_SHADOW,
  };
}

function getMetricSurfaceStyle(c: ThemeColors, accent: string): CSSProperties {
  return {
    background: `linear-gradient(180deg, ${withAlpha('#FFFFFF', ALPHA.hover)} 0%, ${withAlpha(accent, ALPHA.ghost)} 14%, ${c.surface2} 100%)`,
    border: `1px solid ${withAlpha(accent, ALPHA.ghost)}`,
    boxShadow: 'inset 0 1px 0 rgba(255,255,255,0.45)',
  };
}

function getPillStyle(accent: string): CSSProperties {
  return {
    background: `linear-gradient(180deg, ${withAlpha('#FFFFFF', ALPHA.hover)} 0%, ${withAlpha(accent, ALPHA.ghost)} 100%)`,
    border: `1px solid ${withAlpha(accent, ALPHA.ghost)}`,
  };
}

function getChevronStyle(c: ThemeColors): CSSProperties {
  return getIconTileStyle(c, c.accent);
}

/* ═══════════════════════════════════════════
   COMPONENT
   ═══════════════════════════════════════════ */

export interface WalletDCAShortcutProps {
  /**
   * Display variant
   * - 'full': Full info card (default)
   * - 'compact': Minimal single-line
   */
  variant?: 'full' | 'compact';
}

/**
 * WalletDCAShortcut Component
 */
export function WalletDCAShortcut({ variant = 'full' }: WalletDCAShortcutProps) {
  const navigate = useNavigate();
  const routePrefix = useRoutePrefix();
  const c = useThemeColors();
  const { hapticSelection } = useHaptic();
  const { overview, plans } = useDCA();

  // Feature Flag: Check if wallet shortcut should be shown
  const isShortcutEnabled = useDCAWalletShortcut();

  // A/B Test: Get variant configuration
  const {
    variant: abTestVariant,
    showStats,
    showChart,
    ctaText,
    onShortcutClick: trackABTestClick,
  } = useWalletShortcutTest();

  // Analytics: Track events
  const { trackWalletShortcut } = useDCAAnalytics();

  // Funnel: Track wallet to creation journey
  const {
    trackShortcutImpression,
    trackShortcutClick,
  } = useWalletToCreationFunnel();

  // Track impression on mount
  useEffect(() => {
    if (plans.length > 0 && isShortcutEnabled) {
      trackShortcutImpression();
      trackWalletShortcut('impression', abTestVariant);
    }
  }, [plans.length, isShortcutEnabled, trackShortcutImpression, trackWalletShortcut, abTestVariant]);

  const handleClick = () => {
    hapticSelection();
    
    // Track click in all systems
    trackShortcutClick();
    trackABTestClick();
    trackWalletShortcut('click', abTestVariant);
    
    navigate(`${routePrefix}/dca`);
  };

  // Feature flag gate
  if (!isShortcutEnabled) {
    return null;
  }

  // Don't show if no plans
  if (plans.length === 0) {
    return null;
  }

  // Use A/B test variant if not explicitly overridden
  const displayVariant = variant || abTestVariant;
  const cardStyle = getShortcutCardStyle(c);
  const headerIconStyle = getIconTileStyle(c, c.accent);
  const chevronStyle = getChevronStyle(c);
  const activeMetricStyle = getMetricSurfaceStyle(c, c.accent);
  const investedMetricStyle = getMetricSurfaceStyle(c, c.primary);
  const nextMetricStyle = getMetricSurfaceStyle(c, c.warning);
  const profitBadgeStyle = getPillStyle(c.success);
  const profitPct = overview.totalInvested > 0
    ? ((overview.profitLoss / overview.totalInvested) * 100).toFixed(1)
    : '0.0';

  /* ─────────────────────────────────────────
     COMPACT VARIANT
     ───────────────────────────────────────── */
  if (displayVariant === 'compact') {
    return (
      <TrCard
        hover
        as="button"
        onClick={handleClick}
        className="w-full px-4 py-3"
        style={cardStyle}
      >
        <div className="flex items-center gap-3">
          {/* Icon */}
          <div
            className="rounded-xl flex items-center justify-center shrink-0"
            style={{
              width: φAvatar.sm,
              height: φAvatar.sm,
              ...headerIconStyle,
            }}
          >
            <Repeat size={φIcon.md} color={c.accent} />
          </div>

          {/* Content */}
          <div className="flex-1 text-left">
            <p style={{ color: c.text1, fontSize: φ.sm, fontWeight: 600 }}>
              Mua định kỳ (DCA)
            </p>
            <p style={{ color: c.text3, fontSize: φ.xs }}>
              {overview.activePlans} kế hoạch • {fmtVnd(overview.totalInvested)} đã đầu tư
            </p>
          </div>

          {/* Chevron */}
          <div
            className="rounded-lg flex items-center justify-center shrink-0"
            style={{
              width: 28,
              height: 28,
              ...chevronStyle,
            }}
          >
            <ChevronRight size={φIcon.sm} color={c.text2} />
          </div>
        </div>
      </TrCard>
    );
  }

  /* ─────────────────────────────────────────
     FULL VARIANT
     ───────────────────────────────────────── */
  return (
    <TrCard
      hover
      as="button"
      onClick={handleClick}
      className="w-full p-4"
      style={cardStyle}
    >
      {/* Header */}
      <div className="flex items-center gap-3 mb-4">
        <div
          className="rounded-xl flex items-center justify-center shrink-0"
          style={{
            width: 40,
            height: 40,
            ...headerIconStyle,
          }}
        >
          <Repeat size={20} color={c.accent} />
        </div>

        <div className="flex-1 text-left">
          <div className="flex items-center gap-2">
            <p style={{ color: c.text1, fontSize: φ.base, fontWeight: 600 }}>
              Mua định kỳ (DCA)
            </p>
            {overview.profitLoss > 0 && (
              <div
                className="px-2.5 py-1 rounded-full"
                style={profitBadgeStyle}
              >
                <span style={{ color: c.success, fontSize: 10.5, fontWeight: 700 }}>
                  +{profitPct}%
                </span>
              </div>
            )}
          </div>
          <p style={{ color: c.text3, fontSize: φ.xs }}>
            Tự động mua crypto theo lịch trình
          </p>
        </div>

        <div
          className="rounded-xl flex items-center justify-center shrink-0"
          style={{
            width: 32,
            height: 32,
            ...chevronStyle,
          }}
        >
          <ChevronRight size={φIcon.sm} color={c.text2} />
        </div>
      </div>

      {/* Divider */}
      <div style={{ height: 1, background: withAlpha(c.accent, ALPHA.ghost), marginBottom: 12 }} />

      {/* Stats Grid */}
      <div className="grid grid-cols-2 gap-3">
        {/* Active Plans */}
        <div className="flex items-start gap-2 rounded-2xl p-3" style={activeMetricStyle}>
          <div
            className="rounded-lg flex items-center justify-center shrink-0"
            style={{
              width: 32,
              height: 32,
              ...getIconTileStyle(c, c.accent),
            }}
          >
            <Repeat size={16} color={c.accent} />
          </div>
          <div className="flex-1">
            <p style={{ color: c.text3, fontSize: 11, marginBottom: 2 }}>
              Kế hoạch đang chạy
            </p>
            <p style={{ color: c.text1, fontSize: φ.base, fontWeight: 700 }}>
              {overview.activePlans}
            </p>
          </div>
        </div>

        {/* Total Invested */}
        <div className="flex items-start gap-2 rounded-2xl p-3" style={investedMetricStyle}>
          <div
            className="rounded-lg flex items-center justify-center shrink-0"
            style={{
              width: 32,
              height: 32,
              ...getIconTileStyle(c, c.primary),
            }}
          >
            <TrendingUp size={16} color={c.primary} />
          </div>
          <div className="flex-1">
            <p style={{ color: c.text3, fontSize: 11, marginBottom: 2 }}>
              Đã đầu tư
            </p>
            <p style={{ color: c.text1, fontSize: φ.base, fontWeight: 700, fontFamily: 'monospace' }}>
              {fmtVnd(overview.totalInvested)}
            </p>
          </div>
        </div>

        {/* Next Execution */}
        {overview.nextExecution && (
          <div className="flex items-start gap-2 col-span-2 rounded-2xl p-3" style={nextMetricStyle}>
            <div
              className="rounded-lg flex items-center justify-center shrink-0"
              style={{
                width: 32,
                height: 32,
                ...getIconTileStyle(c, c.warning),
              }}
            >
              <Clock size={16} color={c.warning} />
            </div>
            <div className="flex-1">
              <p style={{ color: c.text3, fontSize: 11, marginBottom: 2 }}>
                Giao dịch tiếp theo
              </p>
              <div className="flex items-center gap-2">
                <p style={{ color: c.text1, fontSize: φ.sm, fontWeight: 600 }}>
                  {overview.nextExecution.relativeTime}
                </p>
                <span style={{ color: c.text3, fontSize: 11 }}>•</span>
                <p style={{ color: c.text2, fontSize: φ.xs, fontFamily: 'monospace' }}>
                  {fmtVnd(overview.nextExecution.amount)}
                </p>
              </div>
            </div>
          </div>
        )}
      </div>

      {/* New User Hint (if no active plans) */}
      {overview.activePlans === 0 && plans.length > 0 && (
        <div
          className="mt-3 px-3 py-2 rounded-lg"
          style={getMetricSurfaceStyle(c, c.warning)}
        >
          <div className="flex items-center gap-2">
            <Sparkles size={14} color={c.warning} />
            <p style={{ color: c.warning, fontSize: 11 }}>
              Bạn có kế hoạch đã tạm dừng. Nhấn để kích hoạt lại.
            </p>
          </div>
        </div>
      )}
    </TrCard>
  );
}

/* ═══════════════════════════════════════════
   EMPTY STATE VARIANT (for new users)
   ═══════════════════════════════════════════ */

export function WalletDCAEmptyState() {
  const navigate = useNavigate();
  const routePrefix = useRoutePrefix();
  const c = useThemeColors();
  const { hapticSelection } = useHaptic();

  // Analytics: Track empty state
  const { trackEmptyState } = useDCAAnalytics();

  // Funnel: Track first-time user journey
  const { useFirstTimeUserFunnel } = require('../../hooks/useFunnelTracking');
  const {
    trackEmptyStateImpression,
    trackEmptyStateClick,
  } = useFirstTimeUserFunnel();

  // Track impression on mount
  useEffect(() => {
    trackEmptyStateImpression();
    trackEmptyState('impression');
  }, [trackEmptyStateImpression, trackEmptyState]);

  const handleClick = () => {
    hapticSelection();
    
    // Track click
    trackEmptyStateClick();
    trackEmptyState('click');
    
    navigate(`${routePrefix}/dca`);
  };

  return (
    <TrCard
      hover
      as="button"
      onClick={handleClick}
      className="w-full p-4"
      style={getShortcutCardStyle(c)}
    >
      <div className="flex items-center gap-3">
        {/* Icon */}
        <div
          className="rounded-xl flex items-center justify-center shrink-0"
          style={{
            width: 40,
            height: 40,
            ...getIconTileStyle(c, c.accent),
          }}
        >
          <Repeat size={20} color={c.accent} />
        </div>

        {/* Content */}
        <div className="flex-1 text-left">
          <p style={{ color: c.text1, fontSize: φ.base, fontWeight: 600 }}>
            Thử tính năng Tự động đầu tư (DCA)
          </p>
          <p style={{ color: c.text3, fontSize: φ.xs }}>
            Mua crypto định kỳ, giảm rủi ro biến động giá
          </p>
        </div>

        {/* Badge */}
        <div
          className="px-2.5 py-1 rounded-full"
          style={getPillStyle(c.accent)}
        >
          <span style={{ color: c.accent, fontSize: 10.5, fontWeight: 700 }}>
            Mới
          </span>
        </div>

        {/* Chevron */}
        <div
          className="rounded-xl flex items-center justify-center shrink-0"
          style={{
            width: 32,
            height: 32,
            ...getChevronStyle(c),
          }}
        >
          <ChevronRight size={φIcon.sm} color={c.text2} />
        </div>
      </div>
    </TrCard>
  );
}
