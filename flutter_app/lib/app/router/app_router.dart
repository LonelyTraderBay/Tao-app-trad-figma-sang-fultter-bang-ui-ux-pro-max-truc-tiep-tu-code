import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/login_page.dart';
import '../../features/home/data/home_mock_data.dart';
import '../../features/home/presentation/home_page.dart';
import '../../app/theme/app_colors.dart';
import '../../shared/layout/vit_app_shell.dart';
import '../../shared/layout/vit_bottom_nav.dart';
import '../../shared/layout/vit_header.dart';
import '../../shared/layout/vit_page_content.dart';
import '../../shared/layout/vit_page_layout.dart';
import '../../shared/layout/shell_render_mode.dart';
import '../../shared/layout/vit_phone_frame.dart';
import '../../shared/layout/vit_status_bar.dart';

final class AppRouteNames {
  const AppRouteNames._();

  static const String sc001Login = 'sc001Login';
  static const String sc007Home = 'sc007Home';
}

final class AppRoutePaths {
  const AppRoutePaths._();

  static const String root = '/';
  static const String authLogin = '/auth/login';
  static const String authRegister = '/auth/register';
  static const String authForgotPassword = '/auth/forgot-password';
  static const String home = '/home';
  static const String markets = '/markets';
  static const String trade = '/trade';
  static const String wallet = '/wallet';
  static const String profile = '/profile';
}

GoRouter createAppRouter({
  String initialLocation = AppRoutePaths.home,
  ShellRenderMode shellRenderMode = ShellRenderMode.native,
}) {
  return GoRouter(
    initialLocation: initialLocation,
    routes: [
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
        builder: (_, _) => _AuthRouteShell(
          renderMode: shellRenderMode,
          child: const _AuthRoutePlaceholder(title: 'Register'),
        ),
      ),
      GoRoute(
        path: AppRoutePaths.authForgotPassword,
        builder: (_, _) => _AuthRouteShell(
          renderMode: shellRenderMode,
          child: const _AuthRoutePlaceholder(title: 'Forgot Password'),
        ),
      ),
      ShellRoute(
        builder: (context, state, child) {
          final activeDestination = _activeDestinationForPath(state.uri.path);
          final appShell = VitAppShell(
            renderMode: shellRenderMode,
            currentPath: state.uri.path,
            activeDestination: activeDestination,
            homeBadgeCount: HomeMockData.homeBadge,
            statusBarTime: shellRenderMode.usesVisualQaFrame ? '23:27' : null,
            onDestinationSelected: (destination) {
              context.go(destination.routePath);
            },
            child: child,
          );

          if (!shellRenderMode.usesVisualQaFrame) return appShell;
          return VitPhoneFrame(child: appShell);
        },
        routes: [
          GoRoute(
            path: AppRoutePaths.home,
            name: AppRouteNames.sc007Home,
            builder: (_, _) => HomePage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.markets,
            builder: (_, _) => const _BottomNavRouteSkeleton(title: 'Markets'),
          ),
          GoRoute(
            path: AppRoutePaths.trade,
            builder: (_, _) => const _BottomNavRouteSkeleton(title: 'Trade'),
          ),
          GoRoute(
            path: AppRoutePaths.wallet,
            builder: (_, _) => const _BottomNavRouteSkeleton(title: 'Wallet'),
          ),
          GoRoute(
            path: AppRoutePaths.profile,
            builder: (_, _) => const _BottomNavRouteSkeleton(title: 'Profile'),
          ),
          ..._homeOutgoingPlaceholders,
        ],
      ),
    ],
  );
}

class _AuthRouteShell extends StatelessWidget {
  const _AuthRouteShell({required this.child, required this.renderMode});

  final Widget child;
  final ShellRenderMode renderMode;

  @override
  Widget build(BuildContext context) {
    final body = Material(
      color: AppColors.bg,
      child: SizedBox.expand(child: child),
    );

    if (!renderMode.usesVisualQaFrame) {
      return SafeArea(top: true, bottom: false, child: body);
    }

    return Material(
      color: AppColors.bg,
      child: Column(
        children: [
          const VitStatusBar(time: '23:27'),
          Expanded(child: body),
        ],
      ),
    );
  }
}

class _AuthRoutePlaceholder extends StatelessWidget {
  const _AuthRoutePlaceholder({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return VitPageLayout(
      child: Column(
        children: [
          VitHeader(
            title: title,
            showBack: true,
            onBack: () => context.go(AppRoutePaths.authLogin),
          ),
          const VitPageContent(children: [SizedBox.shrink()]),
        ],
      ),
    );
  }
}

final GoRouter appRouter = createAppRouter();

VitBottomNavDestination _activeDestinationForPath(String path) {
  if (path.startsWith(AppRoutePaths.markets)) {
    return VitBottomNavDestination.markets;
  }
  if (path.startsWith(AppRoutePaths.trade)) {
    return VitBottomNavDestination.trade;
  }
  if (path.startsWith(AppRoutePaths.wallet)) {
    return VitBottomNavDestination.wallet;
  }
  if (path.startsWith(AppRoutePaths.profile)) {
    return VitBottomNavDestination.profile;
  }
  return VitBottomNavDestination.home;
}

final List<GoRoute> _homeOutgoingPlaceholders = [
  _placeholderRoute('/search', 'Search'),
  _placeholderRoute('/notifications', 'Notifications'),
  _placeholderRoute('/wallet/deposit/:asset', 'Deposit'),
  _placeholderRoute('/wallet/withdraw/:asset', 'Withdraw'),
  _placeholderRoute('/topics', 'Topics'),
  _placeholderRoute('/trade/convert', 'Convert'),
  _placeholderRoute('/trade/bots', 'Trading Bots'),
  _placeholderRoute('/trade/copy-trading', 'Copy Trading'),
  _placeholderRoute('/trade/margin', 'Margin'),
  _placeholderRoute('/trade/:pairId', 'Trade'),
  _placeholderRoute('/p2p', 'P2P'),
  _placeholderRoute('/launchpad', 'Launchpad'),
  _placeholderRoute('/earn/staking', 'Staking'),
  _placeholderRoute('/earn/savings', 'Savings'),
  _placeholderRoute('/dca', 'DCA'),
  _placeholderRoute('/rewards', 'Rewards'),
  _placeholderRoute('/referral', 'Referral'),
  _placeholderRoute('/markets/predictions', 'Prediction Markets'),
  _placeholderRoute('/arena', 'Open Arena'),
  _placeholderRoute('/pair/:pairId', 'Pair Detail'),
];

GoRoute _placeholderRoute(String path, String title) {
  return GoRoute(
    path: path,
    builder: (_, _) => _UnportedRoutePlaceholder(title: title),
  );
}

class _BottomNavRouteSkeleton extends StatelessWidget {
  const _BottomNavRouteSkeleton({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return VitPageLayout(
      child: Column(
        children: [
          VitHeader(title: title),
          const VitPageContent(children: []),
        ],
      ),
    );
  }
}

class _UnportedRoutePlaceholder extends StatelessWidget {
  const _UnportedRoutePlaceholder({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return VitPageLayout(
      child: Column(
        children: [
          VitHeader(
            title: title,
            showBack: true,
            onBack: () => context.go(AppRoutePaths.home),
          ),
          const VitPageContent(children: [SizedBox.shrink()]),
        ],
      ),
    );
  }
}
