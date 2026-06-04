part of '../app_router.dart';

List<RouteBase> _supportRoutes(ShellRenderMode shellRenderMode) {
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
