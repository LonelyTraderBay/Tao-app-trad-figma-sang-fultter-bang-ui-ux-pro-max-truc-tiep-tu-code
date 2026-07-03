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
    final scrollEndClearance =
        (mode.usesVisualQaFrame
            ? AppSpacing.x7 + AppSpacing.x6
            : AppSpacing.x7) +
        MediaQuery.paddingOf(context).bottom;

    return CrossModuleTabbedPageShell(
      semanticLabel: 'SC-322 CrossModuleAnalytics',
      contentKey: CrossModuleAnalytics.contentKey,
      title: snapshot.title,
      onBack: () => context.go(snapshot.backRoute),
      scrollEndClearance: scrollEndClearance,
      tabs: _AnalyticsTabs(
        tabs: snapshot.tabs,
        active: _activeTab,
        onChanged: (tab) {
          HapticFeedback.selectionClick();
          setState(() => _activeTab = tab);
        },
      ),
      body: VitPageContent(
        gap: VitContentGap.tight,
        children: [
          if (_activeTab == CrossModuleAnalyticsTab.performance)
            _PerformanceTab(snapshot: snapshot)
          else if (_activeTab == CrossModuleAnalyticsTab.metrics)
            _MetricsTab(snapshot: snapshot)
          else
            _ComparisonTab(snapshot: snapshot),
        ],
      ),
    );
  }
}

class CrossModuleTabbedPageShell extends StatelessWidget {
  const CrossModuleTabbedPageShell({
    super.key,
    required this.semanticLabel,
    required this.contentKey,
    required this.title,
    required this.onBack,
    required this.scrollEndClearance,
    required this.tabs,
    required this.body,
  });

  final String semanticLabel;
  final Key contentKey;
  final String title;
  final VoidCallback onBack;
  final double scrollEndClearance;
  final Widget tabs;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: semanticLabel,
      child: Material(
        color: AppColors.bg,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: title,
            showBack: true,
            onBack: onBack,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              tabs,
              Expanded(
                child: SingleChildScrollView(
                  key: contentKey,
                  physics: const ClampingScrollPhysics(),
                  padding: AppSpacing.crossModuleScrollPadding(
                    scrollEndClearance,
                  ),
                  child: body,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
