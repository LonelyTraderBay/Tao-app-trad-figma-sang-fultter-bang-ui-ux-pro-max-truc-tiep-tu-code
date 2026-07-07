import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/layout/vit_top_chrome.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/dca_controller_providers.dart';

const double _dcaScheduleAnalyticsVisualNavClearance = 112;
const double _dcaScheduleAnalyticsNativeNavClearance = 88;

class DCAScheduleAnalytics extends ConsumerWidget {
  const DCAScheduleAnalytics({
    super.key,
    required this.configId,
    this.shellRenderMode,
  });

  static const contentKey = Key('sc173_schedule_analytics_content');
  static const missingConfigKey = Key('sc173_missing_config');
  static const configureKey = Key('sc173_configure_schedule');

  final String configId;
  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(dcaScheduleAnalyticsProvider(configId));
    final mode = shellRenderMode ?? defaultShellRenderMode();
    final navClearance = mode.usesVisualQaFrame
        ? _dcaScheduleAnalyticsVisualNavClearance
        : _dcaScheduleAnalyticsNativeNavClearance;
    final scrollEndPadding =
        navClearance + MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-173 DCAScheduleAnalytics',
      child: VitAutoHideHeaderScaffold(
        header: VitTopChrome(
          type: VitTopChromeType.detail,
          title: 'Schedule Analytics',
          subtitle: 'Đầu tư có kỷ luật · lịch mua',
          showBack: true,
          onBack: () => _close(context),
        ),
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: VitInsetScrollView(
            key: contentKey,
            physics: const ClampingScrollPhysics(),
            bottomInset: scrollEndPadding,
            child: VitPageContent(
              rhythm: VitPageRhythm.standard,
              padding: VitContentPadding.compact,
              density: VitDensity.compact,
              children: [
                if (!snapshot.configFound)
                  _MissingConfigPanel(
                    message: snapshot.message,
                    onConfigure: () =>
                        context.go(AppRoutePaths.dcaScheduleConfig),
                  )
                else
                  VitPageSection(
                    label: 'Hiệu suất lịch mua',
                    accentColor: AppModuleAccents.dca,
                    children: [
                      VitCard(
                        density: VitDensity.compact,
                        child: Text(
                          snapshot.message,
                          style: AppTextStyles.base.copyWith(
                            color: AppColors.text1,
                            fontWeight: AppTextStyles.medium,
                          ),
                        ),
                      ),
                    ],
                  ),
                const VitHighRiskStatePanel(
                  state: VitHighRiskUiState.riskReview,
                  title: 'Phân tích chỉ đọc',
                  message:
                      'Analytics giữ vai trò theo dõi; mọi thay đổi lịch mua vẫn qua luồng cấu hình và xem lại.',
                  contractId: 'SC-173',
                ),
              ],
            ),
          ),
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

class _MissingConfigPanel extends StatelessWidget {
  const _MissingConfigPanel({required this.message, required this.onConfigure});

  final String message;
  final VoidCallback onConfigure;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox.square(
                dimension: AppSpacing.buttonCompact,
                child: DecoratedBox(
                  decoration: ShapeDecoration(
                    color: AppModuleAccents.dca.withValues(alpha: .12),
                    shape: const CircleBorder(),
                  ),
                  child: Icon(
                    Icons.event_busy_outlined,
                    color: AppModuleAccents.dca,
                    size: AppSpacing.iconMd,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      message,
                      key: DCAScheduleAnalytics.missingConfigKey,
                      style: AppTextStyles.base.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(
                      height: AppSpacing.pageRhythmCompactInnerGap,
                    ),
                    Text(
                      'Chưa có cấu hình lịch mua để phân tích. Thiết lập lịch trình trước khi xem cadence và chất lượng thực thi.',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          VitCtaButton(
            key: DCAScheduleAnalytics.configureKey,
            onPressed: onConfigure,
            leading: const Icon(Icons.schedule_outlined),
            child: const Text('Thiết lập lịch mua'),
          ),
        ],
      ),
    );
  }
}
