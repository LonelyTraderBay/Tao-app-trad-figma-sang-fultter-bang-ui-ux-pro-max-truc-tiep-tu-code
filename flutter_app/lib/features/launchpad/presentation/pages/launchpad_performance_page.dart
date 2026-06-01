import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/launchpad_controller_providers.dart';
part '../widgets/launchpad_performance_overview.dart';
part '../widgets/launchpad_performance_projects.dart';
part '../widgets/launchpad_performance_chart_common.dart';

class LaunchpadPerformancePage extends ConsumerStatefulWidget {
  const LaunchpadPerformancePage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc297_launchpad_performance_content');
  static const heroKey = Key('sc297_launchpad_performance_hero');
  static const tabsKey = Key('sc297_launchpad_performance_tabs');
  static const bestWorstKey = Key('sc297_launchpad_performance_best_worst');
  static const distributionKey = Key(
    'sc297_launchpad_performance_distribution',
  );
  static const disclaimerKey = Key('sc297_launchpad_performance_disclaimer');

  static Key tabKey(String id) => Key('sc297_launchpad_performance_tab_$id');
  static Key projectKey(String id) =>
      Key('sc297_launchpad_performance_project_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<LaunchpadPerformancePage> createState() =>
      _LaunchpadPerformancePageState();
}

class _LaunchpadPerformancePageState
    extends ConsumerState<LaunchpadPerformancePage> {
  var _activeTab = _PerformanceTab.overview;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(launchpadControllerProvider).getPerformance();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x6
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-297 LaunchpadPerformancePage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: snapshot.title,
              subtitle: snapshot.subtitle,
              showBack: true,
              onBack: () => context.go(snapshot.backRoute),
            ),
            _PerformanceTabs(
              activeTab: _activeTab,
              onChanged: (tab) => setState(() => _activeTab = tab),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  key: LaunchpadPerformancePage.contentKey,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(bottom: bottomInset),
                  child: VitPageContent(
                    padding: VitContentPadding.defaultPadding,
                    customGap: AppSpacing.x4,
                    children: [
                      switch (_activeTab) {
                        _PerformanceTab.overview => _OverviewTab(
                          snapshot: snapshot,
                        ),
                        _PerformanceTab.projects => _ProjectsTab(
                          projects: snapshot.projects,
                        ),
                        _PerformanceTab.chart => _ChartTab(
                          points: snapshot.chartPoints,
                        ),
                      },
                      const _PerformanceDisclaimer(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
