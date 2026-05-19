import React from 'react';
import { useThemeColors } from '../../hooks/useThemeColors';

/**
 * SectionHeader — Enterprise Section Heading Component
 * Standardizes section titles across all pages.
 *
 * Design tokens:
 *   Title: 14px / fw700 / #F0F4FF
 *   Subtitle: 12px / fw400 / #4A5568
 *   Accent bar: 3px wide, 16px tall, borderRadius 2px
 */

export interface SectionHeaderProps {
  /** Section title */
  title: string;
  /** Optional subtitle/description */
  subtitle?: string;
  /** Right-side action element (button, link, badge) */
  right?: React.ReactNode;
  /** Show accent color bar on the left (default: false) */
  accent?: boolean;
  /** Accent bar color (default: #3B82F6) */
  accentColor?: string;
  /** Title font size override */
  titleSize?: number;
  /** Container className */
  className?: string;
  /** Bottom margin in px (default: 12) */
  mb?: number;
}

export function SectionHeader({
  title,
  subtitle,
  right,
  accent = false,
  accentColor = '#3B82F6',
  titleSize = 14,
  className = '',
  mb = 12,
}: SectionHeaderProps) {
  const c = useThemeColors();
  return (
    <div
      className={`flex items-center gap-2 ${className}`}
      style={{ marginBottom: mb }}
    >
      {accent && (
        <div
          className="shrink-0"
          style={{
            width: 3,
            height: 16,
            borderRadius: 2,
            background: accentColor,
          }}
        />
      )}
      <div className="flex-1 min-w-0">
        <h3
          className="text-truncate"
          style={{
            color: c.text1,
            fontSize: titleSize,
            fontWeight: 700,
            lineHeight: 1.3,
            margin: 0,
          }}
        >
          {title}
        </h3>
        {subtitle && (
          <p
            style={{
              color: c.text3,
              fontSize: 12,
              marginTop: 2,
              lineHeight: 1.4,
            }}
          >
            {subtitle}
          </p>
        )}
      </div>
      {right && <div className="shrink-0">{right}</div>}
    </div>
  );
}