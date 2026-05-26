part of '../app_router.dart';

List<RouteBase> _homeRoutes(ShellRenderMode shellRenderMode) {
  return [
    GoRoute(
      path: AppRoutePaths.home,
      name: AppRouteNames.sc007Home,
      builder: (_, _) => HomePage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.news,
      name: AppRouteNames.sc047News,
      builder: (_, _) => NewsPage(shellRenderMode: shellRenderMode),
    ),
  ];
}
