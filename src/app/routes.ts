import React from 'react';
import { createBrowserRouter, Navigate } from 'react-router';
import { RootLayout } from './components/layout/RootLayout';
import { AppLayout } from './components/layout/AppLayout';
import { ProtectedRoute } from './components/layout/ProtectedRoute';

import {
  createAuthBlock,
  createPublicRoutes,
  createProtectedRoutes,
  type ShellOverrides,
} from './routeConfig';

import { HomePage } from './pages/market/HomePage';
import { MarketListPage } from './pages/market/MarketListPage';
import { PairDetailPage } from './pages/market/PairDetailPage';
import { TradePage } from './pages/trade/TradePage';
import { WalletPage } from './pages/wallet/WalletPage';
import { TransactionHistoryPage } from './pages/wallet/TransactionHistoryPage';
import { ProfilePage } from './pages/profile/ProfilePage';
import { P2PHomePage } from './pages/p2p/P2PHomePage';

import CopyTradingCardDemo from './pages/demo/CopyTradingCardDemo';
import { MissingScreensShowcasePage } from './pages/v2/MissingScreensShowcasePage';
import { DesignSystemPage } from './pages/v2/DesignSystemPage';
import DCAOverviewDemo from './pages/dca/DCAOverviewDemo';
import OnboardingFlow from './pages/onboarding/OnboardingFlow';

const phoneOverrides: ShellOverrides = {
  HomePage,
  MarketListPage,
  PairDetailPage,
  TradePage,
  WalletPage,
  TxHistoryPage: TransactionHistoryPage,
  ProfilePage,
  P2PHomePage,
};

console.log('[Router] Initializing phone-only Flutter UI reference @', new Date().toISOString());

export const router = createBrowserRouter([
  {
    path: '/',
    Component: RootLayout,
    children: [
      { index: true, element: React.createElement(Navigate, { to: '/home', replace: true }) },
      createAuthBlock(),
      { path: 'onboarding', Component: OnboardingFlow },
      {
        Component: AppLayout,
        children: [
          ...createPublicRoutes(phoneOverrides),
          { path: 'dev/showcase', Component: MissingScreensShowcasePage },
          { path: 'dev/design-system', Component: DesignSystemPage },
          { path: 'dev/dca-overview', Component: DCAOverviewDemo },
          { path: 'demo/copy-card', Component: CopyTradingCardDemo },
          {
            Component: ProtectedRoute,
            children: createProtectedRoutes(phoneOverrides),
          },
        ],
      },
    ],
  },
]);
