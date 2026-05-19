import React from 'react';
import { Outlet, useLocation } from 'react-router';
import { AppProvider } from '../../contexts/AppContext';
import { DCAProvider } from '../../contexts/DCAContext';
import { MobileFrame } from './MobileFrame';
import { ErrorBoundary } from '../mobile/ErrorBoundary';
import { ThemedToaster } from '../ui/ThemedToaster';

export function RootLayout() {
  const location = useLocation();
  const isStandaloneRoute =
    location.pathname.startsWith('/auth') ||
    location.pathname.startsWith('/onboarding');

  return (
    <ErrorBoundary section="VitTrade App">
      <AppProvider>
        <DCAProvider>
          <React.Suspense fallback={null}>
            {isStandaloneRoute ? (
              <Outlet />
            ) : (
              <MobileFrame>
                <Outlet />
              </MobileFrame>
            )}
          </React.Suspense>
          <ThemedToaster />
        </DCAProvider>
      </AppProvider>
    </ErrorBoundary>
  );
}
