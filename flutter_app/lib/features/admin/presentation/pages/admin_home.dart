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

export 'admin_settings_page.dart';

part '../widgets/admin_home_metrics_realtime.dart';
part '../widgets/admin_home_dashboards_footer.dart';

class AdminHome extends ConsumerStatefulWidget {
  const AdminHome({super.key, this.shellRenderMode});

  static const contentKey = Key('sc180_admin_home_content');
  static const settingsKey = Key('sc180_admin_settings');
  static const pauseKey = Key('sc180_admin_pause_live');

  static Key dashboardKey(String id) => Key('sc180_admin_dashboard_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends ConsumerState<AdminHome> {
  bool _isLive = true;

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(adminHomeControllerProvider);
    final snapshot = controller.state.snapshot;
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollBottom =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome
            : DeviceMetrics.nativeBottomChrome) +
        AppSpacing.x6 +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      semanticLabel: 'SC-180 AdminHome',
      child: Column(
        children: [
          VitHeader(
            title: 'Admin Dashboard',
            subtitle: 'DCA Analytics & Monitoring',
            trailing: _SettingsButton(
              onPressed: () => context.go(AppRoutePaths.adminSettings),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              key: AdminHome.contentKey,
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.only(bottom: scrollBottom),
              child: VitPageContent(
                customGap: AppSpacing.x5,
                children: [
                  AdminDashboardStateContent(
                    status: controller.state.status,
                    title: 'Admin dashboard',
                    message: controller.state.message,
                    children: [
                      _MetricGrid(metrics: snapshot.quickStats),
                      _RealTimeMetricsSection(
                        snapshot: snapshot,
                        isLive: _isLive,
                        onToggleLive: () => setState(() => _isLive = !_isLive),
                      ),
                      _DashboardsSection(dashboards: snapshot.dashboards),
                      _FooterCard(snapshot: snapshot),
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
