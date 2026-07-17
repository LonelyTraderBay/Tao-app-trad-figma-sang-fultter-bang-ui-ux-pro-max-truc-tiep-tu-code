/// UI state a Dev-tools screen snapshot supports rendering.
enum DevScreenState { loading, empty, error, offline }

/// Color-coded quality tone for a performance metric/tip.
enum PerformanceScoreTone { good, warning, poor }

/// Data for the dev route-checker tool: all known [routes] grouped by
/// migration phase.
final class RouteCheckerSnapshot {
  const RouteCheckerSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.subtitle,
    required this.backRoute,
    required this.routes,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String subtitle;
  final String backRoute;
  final List<DevRouteDraft> routes;
  final String contractNotes;
  final Set<DevScreenState> supportedStates;

  int get totalRoutes => routes.length;

  List<int> get phases {
    final set = routes.map((route) => route.phase).toSet().toList()..sort();
    return set;
  }

  int phaseTotal(int phase) =>
      routes.where((route) => route.phase == phase).length;
}

/// One known app route (path, name, migration phase) on the route-checker
/// tool.
final class DevRouteDraft {
  const DevRouteDraft({
    required this.path,
    required this.name,
    required this.phase,
    this.featured = false,
  });

  final String path;
  final String name;
  final int phase;
  final bool featured;
}

/// Data for the dev performance monitor tool: summary/vital metrics,
/// memory usage, resource timings, and optimization tips.
final class PerformanceMonitorSnapshot {
  const PerformanceMonitorSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.subtitle,
    required this.backRoute,
    required this.summaryMetrics,
    required this.vitals,
    required this.memory,
    required this.lazyChunks,
    required this.resources,
    required this.tips,
    required this.targets,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String subtitle;
  final String backRoute;
  final List<PerformanceSummaryMetric> summaryMetrics;
  final List<PerformanceVitalMetric> vitals;
  final PerformanceMemoryUsage memory;
  final List<String> lazyChunks;
  final List<PerformanceResourceTiming> resources;
  final List<PerformanceOptimizationTip> tips;
  final List<String> targets;
  final String contractNotes;
  final Set<DevScreenState> supportedStates;
}

/// One labeled summary metric (with quality tone) on the performance
/// monitor tool.
final class PerformanceSummaryMetric {
  const PerformanceSummaryMetric({
    required this.label,
    required this.value,
    required this.tone,
  });

  final String label;
  final String value;
  final PerformanceScoreTone tone;
}

/// One web-vital-style metric (value, progress, tone) on the performance
/// monitor tool.
final class PerformanceVitalMetric {
  const PerformanceVitalMetric({
    required this.label,
    required this.value,
    required this.progress,
    required this.tone,
  });

  final String label;
  final String value;
  final double progress;
  final PerformanceScoreTone tone;
}

/// Current memory usage snapshot (used/limit/percent) on the performance
/// monitor tool.
final class PerformanceMemoryUsage {
  const PerformanceMemoryUsage({
    required this.usedLabel,
    required this.limitLabel,
    required this.percentLabel,
    required this.progress,
  });

  final String usedLabel;
  final String limitLabel;
  final String percentLabel;
  final double progress;
}

/// One loaded resource's size/duration timing on the performance monitor
/// tool.
final class PerformanceResourceTiming {
  const PerformanceResourceTiming({
    required this.name,
    required this.type,
    required this.size,
    required this.duration,
  });

  final String name;
  final String type;
  final String size;
  final String duration;
}

/// One suggested optimization tip on the performance monitor tool.
final class PerformanceOptimizationTip {
  const PerformanceOptimizationTip({
    required this.title,
    required this.body,
    required this.tone,
  });

  final String title;
  final String body;
  final PerformanceScoreTone tone;
}

/// Data for the dev "missing screens" showcase tool: new-screen and
/// v2-page listings plus their flow connections.
final class MissingScreensShowcaseSnapshot {
  const MissingScreensShowcaseSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.subtitle,
    required this.backRoute,
    required this.tabs,
    required this.newScreensIntro,
    required this.newScreens,
    required this.v2Intro,
    required this.v2Pages,
    required this.flowConnections,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String subtitle;
  final String backRoute;
  final List<DevShowcaseTabDraft> tabs;
  final String newScreensIntro;
  final List<DevShowcaseScreenDraft> newScreens;
  final String v2Intro;
  final List<DevShowcaseV2PageDraft> v2Pages;
  final List<DevShowcaseFlowDraft> flowConnections;
  final String contractNotes;
  final Set<DevScreenState> supportedStates;
}

/// One selectable tab entry on the missing-screens showcase tool.
final class DevShowcaseTabDraft {
  const DevShowcaseTabDraft({required this.id, required this.label});

  final String id;
  final String label;
}

/// One newly built screen entry (route, description, supported states)
/// on the missing-screens showcase tool.
final class DevShowcaseScreenDraft {
  const DevShowcaseScreenDraft({
    required this.id,
    required this.title,
    required this.route,
    required this.description,
    required this.states,
  });

  final String id;
  final String title;
  final String route;
  final String description;
  final List<String> states;
}

/// One v2-redesigned page entry (route, changelog) on the missing-screens
/// showcase tool.
final class DevShowcaseV2PageDraft {
  const DevShowcaseV2PageDraft({
    required this.id,
    required this.title,
    required this.route,
    required this.changes,
  });

  final String id;
  final String title;
  final String route;
  final List<String> changes;
}

/// One from-to screen navigation flow entry on the missing-screens
/// showcase tool.
final class DevShowcaseFlowDraft {
  const DevShowcaseFlowDraft({
    required this.id,
    required this.from,
    required this.fromRoute,
    required this.to,
    required this.toRoute,
    required this.trigger,
  });

  final String id;
  final String from;
  final String fromRoute;
  final String to;
  final String toRoute;
  final String trigger;
}

/// Data for the dev design-system showcase tool: theme tokens/swatches and
/// live CTA/input/section component demos.
final class DesignSystemSnapshot {
  const DesignSystemSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.subtitle,
    required this.backRoute,
    required this.heroEyebrow,
    required this.heroTitle,
    required this.heroDescription,
    required this.tokens,
    required this.swatches,
    required this.ctaDemos,
    required this.inputDemos,
    required this.sectionDemos,
    required this.playgroundControls,
    required this.footerTitle,
    required this.footerSubtitle,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String subtitle;
  final String backRoute;
  final String heroEyebrow;
  final String heroTitle;
  final String heroDescription;
  final List<DesignTokenDraft> tokens;
  final List<DesignSwatchDraft> swatches;
  final List<DesignCtaDemoDraft> ctaDemos;
  final List<DesignInputDemoDraft> inputDemos;
  final List<DesignSectionDemoDraft> sectionDemos;
  final List<String> playgroundControls;
  final String footerTitle;
  final String footerSubtitle;
  final String contractNotes;
  final Set<DevScreenState> supportedStates;
}

/// One label/value theme token entry on the design-system showcase tool.
final class DesignTokenDraft {
  const DesignTokenDraft({required this.label, required this.value});

  final String label;
  final String value;
}

/// One named color swatch entry on the design-system showcase tool.
final class DesignSwatchDraft {
  const DesignSwatchDraft({
    required this.id,
    required this.label,
    required this.value,
  });

  final String id;
  final String label;
  final String value;
}

/// One live [VitCtaButton]-style demo config on the design-system showcase
/// tool.
final class DesignCtaDemoDraft {
  const DesignCtaDemoDraft({
    required this.id,
    required this.label,
    required this.variant,
    this.loading = false,
    this.disabled = false,
  });

  final String id;
  final String label;
  final String variant;
  final bool loading;
  final bool disabled;
}

/// One live [VitInput]-style demo config on the design-system showcase
/// tool.
final class DesignInputDemoDraft {
  const DesignInputDemoDraft({
    required this.id,
    required this.caption,
    required this.label,
    required this.placeholder,
    this.value = '',
    this.error,
    this.prefix = false,
    this.suffix = false,
    this.obscure = false,
  });

  final String id;
  final String caption;
  final String label;
  final String placeholder;
  final String value;
  final String? error;
  final bool prefix;
  final bool suffix;
  final bool obscure;
}

/// One section-header demo config (title/subtitle/badge) on the
/// design-system showcase tool.
final class DesignSectionDemoDraft {
  const DesignSectionDemoDraft({
    required this.title,
    this.subtitle,
    this.badge,
  });

  final String title;
  final String? subtitle;
  final String? badge;
}
