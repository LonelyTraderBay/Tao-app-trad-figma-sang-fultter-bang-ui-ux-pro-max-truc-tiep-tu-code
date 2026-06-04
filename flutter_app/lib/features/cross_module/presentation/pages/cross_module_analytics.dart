import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/cross_module_controller_providers.dart';
part '../widgets/cross_module_analytics_tabs.dart';
part '../widgets/cross_module_analytics_cards.dart';
part '../widgets/cross_module_analytics_common.dart';
part '../widgets/cross_module_analytics_painters.dart';

class CrossModuleAnalytics extends ConsumerStatefulWidget {
  const CrossModuleAnalytics({super.key, this.shellRenderMode});

  static const contentKey = Key('sc322_cross_module_analytics_content');
  static Key tabKey(CrossModuleAnalyticsTab tab) =>
      Key('sc322_tab_${tab.name}');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<CrossModuleAnalytics> createState() =>
      _CrossModuleAnalyticsState();
}

class _CrossModuleAnalyticsState extends ConsumerState<CrossModuleAnalytics> {
  CrossModuleAnalyticsTab _activeTab = CrossModuleAnalyticsTab.performance;

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(crossModuleAnalyticsControllerProvider);
    final snapshot = controller.state.snapshot;
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-322 CrossModuleAnalytics',
      child: Material(
        color: AppColors.bg,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: snapshot.title,
            showBack: true,
            onBack: () => context.go(snapshot.backRoute),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _AnalyticsTabs(
                tabs: snapshot.tabs,
                active: _activeTab,
                onChanged: (tab) {
                  HapticFeedback.selectionClick();
                  setState(() => _activeTab = tab);
                },
              ),
              Expanded(
                child: SingleChildScrollView(
                  key: CrossModuleAnalytics.contentKey,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(bottom: bottomInset),
                  child: VitPageContent(
                    gap: VitContentGap.defaultGap,
                    children: [
                      if (_activeTab == CrossModuleAnalyticsTab.performance)
                        _PerformanceTab(snapshot: snapshot)
                      else if (_activeTab == CrossModuleAnalyticsTab.metrics)
                        _MetricsTab(snapshot: snapshot)
                      else
                        _ComparisonTab(snapshot: snapshot),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
