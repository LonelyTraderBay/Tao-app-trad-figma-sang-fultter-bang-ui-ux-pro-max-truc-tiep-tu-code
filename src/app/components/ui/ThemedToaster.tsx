import React from 'react';
import { Toaster } from 'sonner';
import { useThemeColors } from '../../hooks/useThemeColors';

/**
 * ══════════════════════════════════════════════════════════
 *  ThemedToaster — Sonner Toaster locked to dark theme
 * ══════════════════════════════════════════════════════════
 *  Reads CSS variables via useThemeColors() and applies them
 *  as inline styles on the Toaster. Replaces hardcoded dark
 *  colors previously in RootLayout.
 */
export function ThemedToaster() {
  const c = useThemeColors();

  return (
    <Toaster
      position="top-center"
      theme="dark"
      toastOptions={{
        style: {
          background: c.surface,
          border: `1px solid ${c.cardBorder}`,
          color: c.text1,
          fontSize: 13,
          borderRadius: 14,
          maxWidth: 340,
          padding: '10px 16px',
          boxShadow: c.cardShadow,
          zIndex: 99999,
        },
        classNames: {
          success: 'themed-toast-success',
          error: 'themed-toast-error',
          warning: 'themed-toast-warning',
        },
      }}
      richColors
      offset={16}
      style={{ zIndex: 99999 }}
      containerAriaLabel="Thông báo"
    />
  );
}
