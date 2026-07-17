import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/core/product_flow/contextual_support_contract.dart';
import 'package:vit_trade_flutter/features/support/presentation/pages/announcements_page.dart';
import 'package:vit_trade_flutter/features/support/presentation/pages/help_center_page.dart';
import 'package:vit_trade_flutter/features/support/presentation/pages/support_page.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';

List<RouteBase> supportRoutes(ShellRenderMode shellRenderMode) {
  return [
    GoRoute(
      path: AppRoutePaths.support,
      name: AppRouteNames.sc294Support,
      builder: (_, state) => SupportPage(
        shellRenderMode: shellRenderMode,
        supportContext: ProductSupportContext.fromQuery(
          state.uri.queryParameters,
        ),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.supportHelp,
      name: AppRouteNames.sc292HelpCenter,
      builder: (_, _) => HelpCenterPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.supportAnnouncements,
      name: AppRouteNames.sc293Announcements,
      builder: (_, _) => AnnouncementsPage(shellRenderMode: shellRenderMode),
    ),
  ];
}
