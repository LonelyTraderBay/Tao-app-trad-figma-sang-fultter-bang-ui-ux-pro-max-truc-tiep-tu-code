import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/layout/vit_top_chrome.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/dca_controller_providers.dart';

class DCARebalanceDashboard extends ConsumerWidget {
  const DCARebalanceDashboard({
    super.key,
    required this.configId,
    this.shellRenderMode,
  });

  static const contentKey = Key('sc171_rebalance_dashboard_content');
  static const missingConfigKey = Key('sc171_missing_config');

  final String configId;
  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(dcaRebalanceDashboardProvider(configId));

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-171 DCARebalanceDashboard',
      child: VitAutoHideHeaderScaffold(
        header: VitTopChrome(
          type: VitTopChromeType.detail,
          title: 'Rebalance Dashboard',
          subtitle: 'DCA',
          showBack: true,
          onBack: () => _close(context),
        ),
        child: VitPageContent(
          key: contentKey,
          padding: VitContentPadding.none,
          children: [
            Center(
              child: Text(
                snapshot.message,
                key: missingConfigKey,
                style: AppTextStyles.base.copyWith(color: AppColors.text2),
                textAlign: TextAlign.center,
              ),
            ),
            const VitHighRiskStatePanel(
              state: VitHighRiskUiState.riskReview,
              title: 'Rebalance review required',
              message:
                  'Rebalance changes can move funds between assets. Show allocation delta, fees, limits, and confirmation before execution.',
              contractId: 'SC-171',
            ),
          ],
        ),
      ),
    );
  }

  void _close(BuildContext context) {
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(AppRoutePaths.dca);
  }
}
