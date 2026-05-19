import React from 'react';
import { useThemeColors } from '../../hooks/useThemeColors';

/**
 * InputField — Enterprise Input Component
 * Centralized design tokens: height 52px, borderRadius 14px
 * Supports label, error state, prefix/suffix icons, and wrapper mode
 */

export interface InputFieldProps extends Omit<React.InputHTMLAttributes<HTMLInputElement>, 'prefix'> {
  /** Optional label above input */
  label?: string;
  /** Error message (turns border red) */
  error?: string;
  /** Prefix element (icon, text) */
  prefix?: React.ReactNode;
  /** Suffix element (icon, button) */
  suffix?: React.ReactNode;
  /** Container className override */
  containerClassName?: string;
  /** Container style override */
  containerStyle?: React.CSSProperties;
}

export function InputField({
  label,
  error,
  prefix,
  suffix,
  containerClassName = '',
  containerStyle,
  className = '',
  style,
  id,
  ...inputProps
}: InputFieldProps) {
  const c = useThemeColors();
  const borderColor = error ? '#EF4444' : c.borderSolid;
  const inputId = id || (label ? `input-${label.replace(/\s+/g, '-').toLowerCase()}` : undefined);

  return (
    <div className={containerClassName}>
      {label && (
        <label
          htmlFor={inputId}
          style={{
            color: c.text2,
            fontSize: 13,
            display: 'block',
            marginBottom: 6,
          }}
        >
          {label}
        </label>
      )}
      <div
        className="flex items-center gap-3 px-4"
        style={{
          background: c.surface2,
          border: `1.5px solid ${borderColor}`,
          height: 52,
          borderRadius: 14,
          transition: 'border-color 0.2s ease',
          ...containerStyle,
        }}
      >
        {prefix}
        <input
          id={inputId}
          className={`flex-1 min-w-0 ${className}`}
          style={{
            background: 'transparent',
            border: 'none',
            outline: 'none',
            color: c.text1,
            fontSize: 15,
            ...style,
          }}
          aria-invalid={!!error}
          aria-describedby={error && inputId ? `${inputId}-error` : undefined}
          {...inputProps}
        />
        {suffix}
      </div>
      {error && (
        <p id={inputId ? `${inputId}-error` : undefined} role="alert" style={{ color: '#EF4444', fontSize: 12, marginTop: 4 }}>{error}</p>
      )}
    </div>
  );
}

/**
 * InputWrapper — For custom content inside input-styled container
 * Uses same design tokens as InputField
 */
export interface InputWrapperProps {
  label?: string;
  error?: string;
  children: React.ReactNode;
  className?: string;
  style?: React.CSSProperties;
  onClick?: () => void;
}

export function InputWrapper({
  label,
  error,
  children,
  className = '',
  style,
  onClick,
}: InputWrapperProps) {
  const c = useThemeColors();
  const borderColor = error ? '#EF4444' : c.borderSolid;

  return (
    <div>
      {label && (
        <label
          style={{
            color: c.text2,
            fontSize: 13,
            display: 'block',
            marginBottom: 6,
          }}
        >
          {label}
        </label>
      )}
      <div
        className={`flex items-center gap-3 px-4 ${className}`}
        style={{
          background: c.surface2,
          border: `1.5px solid ${borderColor}`,
          height: 52,
          borderRadius: 14,
          transition: 'border-color 0.2s ease',
          cursor: onClick ? 'pointer' : undefined,
          ...style,
        }}
        onClick={onClick}
      >
        {children}
      </div>
      {error && (
        <p style={{ color: '#EF4444', fontSize: 12, marginTop: 4 }}>{error}</p>
      )}
    </div>
  );
}