import React, { createContext, useContext, useCallback, useEffect, useMemo } from 'react';

type ThemeMode = 'dark' | 'light';

interface ThemeContextType {
  theme: ThemeMode;
  setTheme: (theme: ThemeMode) => void;
}

const ThemeContext = createContext<ThemeContextType | null>(null);

const LOCKED_THEME: ThemeMode = 'dark';

function applyLockedTheme() {
  document.documentElement.classList.remove('dark', 'light');
  document.documentElement.classList.add(LOCKED_THEME);
}

export function ThemeProvider({ children }: { children: React.ReactNode }) {
  const setTheme = useCallback((_theme: ThemeMode) => {
    applyLockedTheme();
  }, []);

  // Apply locked dark theme on mount.
  useEffect(() => {
    applyLockedTheme();
  }, []);

  // Memoize context value to prevent unnecessary re-renders
  const value = useMemo(() => ({ theme: LOCKED_THEME, setTheme }), [setTheme]);

  return (
    <ThemeContext.Provider value={value}>
      {children}
    </ThemeContext.Provider>
  );
}

export function useTheme() {
  const ctx = useContext(ThemeContext);
  if (!ctx) throw new Error('useTheme must be used inside ThemeProvider');
  return ctx;
}
