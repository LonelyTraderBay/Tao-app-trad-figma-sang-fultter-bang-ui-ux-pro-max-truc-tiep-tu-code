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
import 'package:vit_trade_flutter/shared/widgets/vit_card.dart';
import 'package:vit_trade_flutter/app/providers/dca_controller_providers.dart';

class DCAScheduleAnalytics extends ConsumerWidget {
  const DCAScheduleAnalytics({
    super.key,
    required this.configId,
    this.shellRenderMode,
  });

  static const contentKey = Key('sc173_schedule_analytics_content');
  static const missingConfigKey = Key('sc173_missing_config');

  final String configId;
  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(dcaScheduleAnalyticsProvider(configId));

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-173 DCAScheduleAnalytics',
      child: VitAutoHideHeaderScaffold(
        header: VitTopChrome(
          type: VitTopChromeType.detail,
          title: 'Schedule Analytics',
          subtitle: 'DCA',
          showBack: true,
          onBack: () => _close(context),
        ),
        child: VitPageContent(
          key: contentKey,
          padding: VitContentPadding.none,
          children: [
            VitCard(
              padding: EdgeInsets.zero,
              child: Center(
                child: Text(
                  snapshot.message,
                  key: missingConfigKey,
                  style: AppTextStyles.base.copyWith(color: AppColors.text2),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            VitCard(
              padding: EdgeInsets.zero,
              child: Text(
                'Select a schedule to inspect cadence, completion quality, and missed-run context.',
                style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                textAlign: TextAlign.center,
              ),
            ),
            VitCard(
              padding: EdgeInsets.zero,
              child: Text(
                'Analytics stay read-only here; execution changes remain in the schedule configuration flow.',
                style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                textAlign: TextAlign.center,
              ),
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
