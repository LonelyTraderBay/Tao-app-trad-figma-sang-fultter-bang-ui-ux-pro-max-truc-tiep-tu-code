sealed class NavigationIntent {
  const NavigationIntent();

  String resolve();
}

final class AppRouteIntent extends NavigationIntent {
  const AppRouteIntent(this.path);

  final String path;

  @override
  String resolve() => path;
}

final class AppRouteBuilderIntent extends NavigationIntent {
  const AppRouteBuilderIntent(this.buildPath);

  final String Function() buildPath;

  @override
  String resolve() => buildPath();
}
