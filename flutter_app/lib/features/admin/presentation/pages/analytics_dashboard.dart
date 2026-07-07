import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
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
import 'package:vit_trade_flutter/app/providers/admin_controller_providers.dart';
import 'package:vit_trade_flutter/features/admin/presentation/widgets/admin_dashboard_state_content.dart';
import 'package:vit_trade_flutter/app/theme/spacing/admin_spacing_tokens.dart';

part '../widgets/analytics_dashboard_sections.dart';
part '../widgets/analytics_dashboard_common.dart';

class AnalyticsDashboard extends ConsumerStatefulWidget {
  const AnalyticsDashboard({super.key, this.shellRenderMode});

  static const contentKey = Key('sc181_analytics_content');
  static const refreshKey = Key('sc181_refresh');
  static const exportKey = Key('sc181_export');

  static Key rangeKey(AdminAnalyticsRange range) =>
      Key('sc181_range_${range.name}');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<AnalyticsDashboard> createState() => _AnalyticsDashboardState();
}

class _AnalyticsDashboardState extends ConsumerState<AnalyticsDashboard> {
  AdminAnalyticsRange _activeRange = AdminAnalyticsRange.sevenDays;

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(adminAnalyticsControllerProvider);
    final snapshot = controller.state.snapshot;
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollBottom =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome
            : DeviceMetrics.nativeBottomChrome) +
        AppSpacing.x6 +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      semanticLabel: 'SC-181 AnalyticsDashboard',
      child: VitAutoHideHeaderScaffold(
        header: VitHeader(
          title: 'Analytics Dashboard',
          subtitle: 'DCA Event Analytics',
          showBack: true,
          onBack: () => context.go(AppRoutePaths.admin),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                key: AnalyticsDashboard.contentKey,
                physics: const ClampingScrollPhysics(),
                padding: AdminSpacingTokens.adminScrollPadding(scrollBottom),
                child: VitPageContent(
                  rhythm: VitPageRhythm.standard,
                  children: [
                    AdminDashboardStateContent(
                      status: controller.state.status,
                      title: 'Analytics dashboard',
                      message: controller.state.message,
                      children: [
                        _Controls(
                          ranges: snapshot.ranges,
                          activeRange: _activeRange,
                          onRangeChanged: (range) {
                            setState(() => _activeRange = range);
                          },
                        ),
                        _KeyMetrics(snapshot: snapshot),
                        _EventVolumeCard(stats: snapshot.dailyStats),
                        _TopEventsCard(events: snapshot.topEvents),
                        _DistributionCard(events: snapshot.topEvents),
                        _RecentEventsCard(events: snapshot.recentEvents),
                        _QueueSummaryCard(text: snapshot.queueSummary),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
