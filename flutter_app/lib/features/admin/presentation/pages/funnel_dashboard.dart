import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/admin_controller_providers.dart';
import 'package:vit_trade_flutter/features/admin/presentation/widgets/admin_dashboard_state_content.dart';

part '../widgets/funnel_dashboard_selector_metrics.dart';
part '../widgets/funnel_dashboard_waterfall_details.dart';
part '../widgets/funnel_dashboard_common_painter.dart';

class FunnelDashboard extends ConsumerStatefulWidget {
  const FunnelDashboard({super.key, this.shellRenderMode});

  static const contentKey = Key('sc183_funnel_content');

  static Key selectorKey(String id) => Key('sc183_funnel_selector_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<FunnelDashboard> createState() => _FunnelDashboardState();
}

class _FunnelDashboardState extends ConsumerState<FunnelDashboard> {
  late String _selectedFunnelId;

  @override
  void initState() {
    super.initState();
    _selectedFunnelId = ref
        .read(adminFunnelsControllerProvider)
        .state
        .snapshot
        .selectedFunnelId;
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(adminFunnelsControllerProvider);
    final snapshot = controller.state.snapshot;
    final selectedFunnel = controller.selectedFunnel(_selectedFunnelId);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollBottom =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome
            : DeviceMetrics.nativeBottomChrome) +
        AppSpacing.x6 +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      semanticLabel: 'SC-183 FunnelDashboard',
      child: Column(
        children: [
          VitHeader(
            title: 'Funnel Analytics',
            subtitle: 'Conversion Funnel Tracking',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.admin),
          ),
          Expanded(
            child: SingleChildScrollView(
              key: FunnelDashboard.contentKey,
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.only(bottom: scrollBottom),
              child: VitPageContent(
                customGap: AppSpacing.x4,
                children: [
                  AdminDashboardStateContent(
                    status: controller.state.status,
                    title: 'Funnel dashboard',
                    message: controller.state.message,
                    gap: AppSpacing.x4,
                    children: [
                      _FunnelSelector(
                        funnels: snapshot.funnels,
                        selectedFunnelId: _selectedFunnelId,
                        onChanged: (id) =>
                            setState(() => _selectedFunnelId = id),
                      ),
                      _MetricsGrid(snapshot: snapshot),
                      _WaterfallCard(funnel: selectedFunnel),
                      _DropoutChartCard(funnel: selectedFunnel),
                      _StepDetailsCard(funnel: selectedFunnel),
                      if (snapshot.totalSessions == 0) const _EmptyFunnelCard(),
                    ],
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
