part of '../app_router.dart';

List<RouteBase> _topLevelRoutes(ShellRenderMode shellRenderMode) {
  return [
    GoRoute(path: AppRoutePaths.root, redirect: (_, _) => AppRoutePaths.home),
    GoRoute(
      path: AppRoutePaths.authLogin,
      name: AppRouteNames.sc001Login,
      builder: (_, _) => _AuthRouteShell(
        renderMode: shellRenderMode,
        child: const LoginPage(),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.authRegister,
      name: AppRouteNames.sc002Register,
      builder: (_, _) => _AuthRouteShell(
        renderMode: shellRenderMode,
        child: const RegisterPage(),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.authOtp,
      name: AppRouteNames.sc003Otp,
      builder: (_, state) => _AuthRouteShell(
        renderMode: shellRenderMode,
        child: _buildOtpPage(state),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.auth2faSetup,
      name: AppRouteNames.sc004TwoFaSetup,
      builder: (_, _) => _AuthRouteShell(
        renderMode: shellRenderMode,
        child: const TwoFASetupPage(),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.authForgotPassword,
      name: AppRouteNames.sc005ForgotPassword,
      builder: (_, _) => _AuthRouteShell(
        renderMode: shellRenderMode,
        child: const ForgotPasswordPage(),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.authResetPassword,
      name: AppRouteNames.sc006ResetPassword,
      builder: (_, _) => _AuthRouteShell(
        renderMode: shellRenderMode,
        child: const ResetPasswordPage(),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.onboarding,
      name: AppRouteNames.sc397Onboarding,
      builder: (_, _) => const OnboardingFlow(),
    ),
  ];
}
