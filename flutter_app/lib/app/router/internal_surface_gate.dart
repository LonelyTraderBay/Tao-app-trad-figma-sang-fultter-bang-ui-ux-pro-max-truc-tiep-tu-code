part of 'app_router.dart';

enum InternalSurfaceKind { admin, developer, qaDemo }

final class InternalSurfaceAccessPolicy {
  const InternalSurfaceAccessPolicy._();

  static const bool explicitBuildEnable = bool.fromEnvironment(
    'VIT_INTERNAL_SURFACES_ENABLED',
    defaultValue: false,
  );

  static bool get isAllowedForCurrentBuild =>
      allows(releaseMode: kReleaseMode, explicitEnable: explicitBuildEnable);

  static bool allows({
    required bool releaseMode,
    required bool explicitEnable,
  }) {
    return !releaseMode || explicitEnable;
  }

  static bool isInternalPath(String path) => kindForPath(path) != null;

  static InternalSurfaceKind? kindForPath(String path) {
    final normalized = _normalizePath(path);
    if (normalized == AppRoutePaths.admin ||
        normalized.startsWith('${AppRoutePaths.admin}/')) {
      return InternalSurfaceKind.admin;
    }
    if (_developerPaths.contains(normalized)) {
      return InternalSurfaceKind.developer;
    }
    if (_qaDemoPaths.contains(normalized)) {
      return InternalSurfaceKind.qaDemo;
    }
    return null;
  }

  static String _normalizePath(String path) {
    final uri = Uri.tryParse(path);
    final parsedPath = uri?.path;
    if (parsedPath == null || parsedPath.isEmpty) return path;
    return parsedPath;
  }

  static const Set<String> _developerPaths = {
    AppRoutePaths.routeChecker,
    AppRoutePaths.performanceMonitor,
    AppRoutePaths.devShowcase,
    AppRoutePaths.devDesignSystem,
    AppRoutePaths.devDcaOverview,
  };

  static const Set<String> _qaDemoPaths = {AppRoutePaths.demoCopyCard};
}

class InternalSurfaceGate extends StatelessWidget {
  const InternalSurfaceGate({
    super.key,
    required this.kind,
    required this.routePath,
    required this.child,
  });

  final InternalSurfaceKind kind;
  final String routePath;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (InternalSurfaceAccessPolicy.isAllowedForCurrentBuild) return child;
    return _InternalSurfaceRestrictedPage(kind: kind, routePath: routePath);
  }
}

class _InternalSurfaceRestrictedPage extends StatelessWidget {
  const _InternalSurfaceRestrictedPage({
    required this.kind,
    required this.routePath,
  });

  final InternalSurfaceKind kind;
  final String routePath;

  @override
  Widget build(BuildContext context) {
    return VitPageLayout(
      semanticLabel: 'Internal surface restricted',
      child: Column(
        children: [
          VitHeader(
            title: 'Restricted surface',
            subtitle: kind.label,
            showBack: true,
            onBack: () => context.go(AppRoutePaths.home),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: VitPageContent(
                rhythm: VitPageRhythm.standard,
                padding: VitContentPadding.relaxed,
                children: [
                  VitCard(
                    padding: const EdgeInsets.all(AppSpacing.x5),
                    borderColor: AppColors.sell20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.admin_panel_settings_outlined,
                          color: AppColors.sell,
                          size: AppSpacing.iconLg,
                        ),
                        const SizedBox(height: AppSpacing.x4),
                        Text(
                          'Internal route is disabled for customer builds.',
                          style: AppTextStyles.baseMedium.copyWith(
                            color: AppColors.text1,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.x2),
                        Text(
                          'Route: $routePath\n'
                          'Enable only through an explicit internal build flag.',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text3,
                            height: 1.45,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

extension InternalSurfaceKindCopy on InternalSurfaceKind {
  String get label {
    switch (this) {
      case InternalSurfaceKind.admin:
        return 'Admin operations';
      case InternalSurfaceKind.developer:
        return 'Developer diagnostics';
      case InternalSurfaceKind.qaDemo:
        return 'QA demo surface';
    }
  }
}
