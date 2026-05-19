import React, { useContext, useCallback } from 'react';
import { useNavigate, useLocation } from 'react-router';
import { Home, BarChart2, ArrowLeftRight, Wallet, User } from 'lucide-react';
import { useHaptic } from '../../hooks/useHaptic';
import { DEVICE } from './MobileFrame';
import { useThemeColors } from '../../hooks/useThemeColors';
import { useRoutePrefix } from '../../hooks/useRoutePrefix';
import { UIContext } from '../../contexts/UIContext';
import { CountBadge } from './Header';

/**
 * ══════════════════════════════════════════════════════════
 *  BOTTOM NAV — iPhone 16 Pro Max Enterprise Standard
 * ══════════════════════════════════════════════════════════
 *
 *  Home indicator safe area: 34pt
 *  Tab bar height: 56pt (content area)
 *  Total bottom chrome: 90pt
 *  Center CTA: 52×52 raised button with gradient + glow
 *  Touch targets: ≥ 48×48pt (Apple HIG ≥ 44pt)
 *  Labels: 10px, icons: 21px
 *  Active state: icon glow + dot indicator + label highlight
 *
 *  Accessibility:
 *  - Keyboard navigation: Arrow Left/Right to navigate tabs
 *  - Enter/Space to activate tab
 *  - ARIA labels and current page indicator
 */

const TABS = [
  { key: 'home', icon: Home, label: 'Trang chủ' },
  { key: 'markets', icon: BarChart2, label: 'Thị trường' },
  { key: 'trade/btcusdt', icon: ArrowLeftRight, label: 'Giao dịch', isCenter: true },
  { key: 'wallet', icon: Wallet, label: 'Ví' },
  { key: 'profile', icon: User, label: 'Tôi' },
];

export function BottomNav() {
  const navigate = useNavigate();
  const location = useLocation();
  const { hapticSelection } = useHaptic();
  const c = useThemeColors();
  const prefix = useRoutePrefix();
  const uiCtx = useContext(UIContext);
  const pendingRewards = uiCtx?.pendingRewards ?? 0;

  const getIsActive = (tabKey: string) => {
    const base = tabKey.split('/')[0];
    const currentPath = location.pathname;
    return currentPath.startsWith(`/${base}`);
  };

  // Keyboard navigation: Arrow keys to move between tabs
  const handleKeyDown = useCallback((e: React.KeyboardEvent, currentTabKey: string) => {
    if (e.key === 'ArrowLeft' || e.key === 'ArrowRight') {
      e.preventDefault();
      const currentIndex = TABS.findIndex(t => t.key === currentTabKey);
      const nextIndex = e.key === 'ArrowRight'
        ? (currentIndex + 1) % TABS.length
        : (currentIndex - 1 + TABS.length) % TABS.length;
      const nextTab = TABS[nextIndex];
      hapticSelection();
      navigate(`${prefix}/${nextTab.key}`);
    }
  }, [navigate, prefix, hapticSelection]);

  return (
    <div
      className="absolute bottom-0 left-0 right-0 z-40"
      role="navigation"
      aria-label="Main navigation"
      style={{
        paddingBottom: DEVICE.HOME_INDICATOR,
        background: c.navBg,
        backdropFilter: 'saturate(180%) blur(24px)',
        WebkitBackdropFilter: 'saturate(180%) blur(24px)',
        transition: 'background 0.3s ease',
      }}
    >
      {/* Gradient fade above tab bar */}
      <div
        className="absolute -top-6 left-0 right-0 h-6 pointer-events-none"
        style={{
          background: `linear-gradient(to bottom, ${c.navGradientFrom} 0%, ${c.navGradientMid} 50%, ${c.navGradientTo} 100%)`,
        }}
      />

      <div
        className="flex items-center justify-around relative"
        style={{
          height: DEVICE.TAB_BAR,
          paddingLeft: 8,
          paddingRight: 8,
          borderTop: `1px solid ${c.navBorder}`,
        }}
      >
        {TABS.map((tab) => {
          const isActive = getIsActive(tab.key);
          const tabPath = `${prefix}/${tab.key}`;
          const Icon = tab.icon;

          if (tab.isCenter) {
            return (
              <button
                key={tab.key}
                onClick={() => {
                  hapticSelection();
                  navigate(tabPath);
                }}
                onKeyDown={(e) => handleKeyDown(e, tab.key)}
                className="flex flex-col items-center -mt-4"
                style={{ gap: 2 }}
                aria-label={tab.label}
                aria-current={isActive ? 'page' : undefined}
              >
                {/* Raised CTA button */}
                <div
                  className="flex items-center justify-center"
                  style={{
                    width: 52,
                    height: 52,
                    borderRadius: 16,
                    background: c.navCenterBg,
                    boxShadow: [
                      '0 4px 16px rgba(59,130,246,0.4)',
                      '0 8px 32px rgba(59,130,246,0.2)',
                      'inset 0 1px 0 rgba(255,255,255,0.2)',
                      'inset 0 -1px 0 rgba(0,0,0,0.1)',
                    ].join(', '),
                    transition: 'transform 0.15s cubic-bezier(0.4, 0, 0.2, 1), box-shadow 0.15s ease',
                  }}
                >
                  <Icon size={22} color={c.navCenterIcon} strokeWidth={2.2} />
                </div>
                <span
                  style={{
                    fontSize: 10,
                    fontWeight: 600,
                    color: c.navActive,
                    letterSpacing: 0.1,
                  }}
                >
                  {tab.label}
                </span>
              </button>
            );
          }

          return (
            <button
              key={tab.key}
              onClick={() => {
                hapticSelection();
                navigate(tabPath);
              }}
              className="flex flex-col items-center justify-center"
              style={{
                gap: 2,
                minWidth: 60,
                minHeight: 48,
                paddingTop: 6,
                paddingBottom: 2,
                transition: 'all 0.2s ease',
              }}
              aria-label={tab.label}
              aria-current={isActive ? 'page' : undefined}
              onKeyDown={(e) => handleKeyDown(e, tab.key)}
            >
              <div className="relative">
                <Icon
                  size={22}
                  strokeWidth={isActive ? 2.2 : 1.7}
                  color={isActive ? c.navActive : c.navInactive}
                  style={{
                    transition: 'color 0.2s ease, filter 0.2s ease',
                    filter: isActive ? 'drop-shadow(0 0 6px rgba(59,130,246,0.35))' : 'none',
                  }}
                />
                {/* Active indicator dot */}
                {isActive && (
                  <div
                    className="absolute -bottom-1 left-1/2 -translate-x-1/2 rounded-full"
                    style={{
                      width: 4,
                      height: 4,
                      background: c.navActive,
                      boxShadow: '0 0 8px rgba(59,130,246,0.6)',
                    }}
                  />
                )}
                {/* Pending rewards badge on Home tab */}
                {tab.key === 'home' && pendingRewards > 0 && (
                  <span className="absolute -top-1 -right-2.5">
                    <CountBadge count={pendingRewards} />
                  </span>
                )}
              </div>
              <span
                style={{
                  fontSize: 10,
                  fontWeight: isActive ? 600 : 400,
                  color: isActive ? c.navActive : c.navInactive,
                  letterSpacing: 0.1,
                  transition: 'color 0.2s ease',
                }}
              >
                {tab.label}
              </span>
            </button>
          );
        })}
      </div>
    </div>
  );
}
