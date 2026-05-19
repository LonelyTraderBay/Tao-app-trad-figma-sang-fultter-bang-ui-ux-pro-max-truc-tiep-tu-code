import React from 'react';
import { useThemeColors } from '../../hooks/useThemeColors';

/**
 * CTAButton — Enterprise CTA Button Component
 * Centralized design tokens: height 52px, borderRadius 14px
 * Supports gradient backgrounds, disabled states, loading states
 */

export interface CTAButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: 'primary' | 'success' | 'danger' | 'warning' | 'ghost';
  loading?: boolean;
  fullWidth?: boolean;
  bg?: string;
  textColor?: string;
  children: React.ReactNode;
}

const GRADIENTS: Record<string, string> = {
  primary: 'linear-gradient(135deg, #3B82F6 0%, #1d4ed8 100%)',
  success: 'linear-gradient(135deg, #10B981 0%, #059669 100%)',
  danger: 'linear-gradient(135deg, #EF4444 0%, #dc2626 100%)',
  warning: 'linear-gradient(135deg, #F59E0B 0%, #d97706 100%)',
  ghost: 'transparent',
};

const SHADOWS: Record<string, string> = {
  primary: '0 4px 16px rgba(59,130,246,0.3)',
  success: '0 4px 16px rgba(16,185,129,0.3)',
  danger: '0 4px 16px rgba(239,68,68,0.3)',
  warning: '0 4px 16px rgba(245,158,11,0.3)',
  ghost: 'none',
};

export function CTAButton({
  variant = 'primary',
  loading = false,
  fullWidth = true,
  bg,
  textColor,
  disabled,
  className = '',
  style,
  children,
  ...rest
}: CTAButtonProps) {
  const c = useThemeColors();
  const isDisabled = disabled || loading;

  return (
    <button
      disabled={isDisabled}
      aria-disabled={isDisabled}
      aria-busy={loading}
      className={`${fullWidth ? 'w-full' : ''} rounded-2xl flex items-center justify-center gap-2 font-semibold text-white ripple ${className}`}
      style={{
        height: 52,
        borderRadius: 14,
        fontSize: 16,
        background: isDisabled ? c.surface2 : (bg ?? GRADIENTS[variant]),
        color: isDisabled ? c.text3 : (textColor ?? '#fff'),
        boxShadow: isDisabled ? 'none' : SHADOWS[variant],
        transition: 'all 0.2s ease',
        ...style,
      }}
      {...rest}
    >
      {loading ? (
        <div className="contents">
          <span className="inline-block w-5 h-5 rounded-full border-2 border-white/30 border-t-white animate-spin" />
          <span>{children}</span>
        </div>
      ) : (
        children
      )}
    </button>
  );
}