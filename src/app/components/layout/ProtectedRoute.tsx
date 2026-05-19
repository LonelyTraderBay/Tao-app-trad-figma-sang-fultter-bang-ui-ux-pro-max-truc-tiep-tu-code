import React from 'react';
import { Navigate, Outlet, useLocation } from 'react-router';
import { useAuth } from '../../contexts/AuthContext';

/**
 * ProtectedRoute — Gate for authenticated-only routes
 * Redirects to /auth/login if not authenticated.
 * Preserves the intended destination in location state for redirect-after-login.
 */
export function ProtectedRoute() {
  const { isAuthenticated } = useAuth();
  const location = useLocation();

  if (!isAuthenticated) {
    return (
      <Navigate
        to="/auth/login"
        state={{ from: location.pathname }}
        replace
      />
    );
  }

  return <Outlet />;
}
