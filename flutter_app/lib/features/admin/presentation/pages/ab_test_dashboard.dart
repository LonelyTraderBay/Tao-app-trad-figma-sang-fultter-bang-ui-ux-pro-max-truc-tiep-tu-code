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
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/admin_controller_providers.dart';
import 'package:vit_trade_flutter/features/admin/presentation/widgets/admin_dashboard_state_content.dart';

part '../widgets/ab_test_dashboard_sections.dart';
part '../widgets/ab_test_dashboard_common.dart';

class ABTestDashboard extends ConsumerStatefulWidget {
  const ABTestDashboard({super.key, this.shellRenderMode});

  static const contentKey = Key('sc182_abtests_content');

  static Key testKey(String id) => Key('sc182_abtest_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<ABTestDashboard> createState() => _ABTestDashboardState();
}

class _ABTestDashboardState extends ConsumerState<ABTestDashboard> {
  String? _selectedTestId;

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(adminAbTestsControllerProvider);
    final snapshot = controller.state.snapshot;
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollBottom =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome
            : DeviceMetrics.nativeBottomChrome) +
        AppSpacing.x6 +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      semanticLabel: 'SC-182 ABTestDashboard',
      child: VitAutoHideHeaderScaffold(
        header: VitHeader(
          title: 'A/B Test Dashboard',
          subtitle: 'Test Results & Analysis',
          showBack: true,
          onBack: () => context.go(AppRoutePaths.admin),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                key: ABTestDashboard.contentKey,
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(bottom: scrollBottom),
                child: VitPageContent(
                  customGap: AppSpacing.x4,
                  children: [
                    AdminDashboardStateContent(
                      status: controller.state.status,
                      title: 'A/B test dashboard',
                      message: controller.state.message,
                      gap: AppSpacing.x4,
                      children: [
                        _SummaryGrid(snapshot: snapshot),
                        const _SectionTitle(title: 'Tất cả A/B Tests'),
                        if (snapshot.tests.isEmpty)
                          const _EmptyTestsCard()
                        else
                          for (final test in snapshot.tests) ...[
                            _ABTestCard(
                              test: test,
                              selected: test.id == _selectedTestId,
                              onTap: () {
                                setState(() {
                                  _selectedTestId = test.id == _selectedTestId
                                      ? null
                                      : test.id;
                                });
                              },
                            ),
                          ],
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
