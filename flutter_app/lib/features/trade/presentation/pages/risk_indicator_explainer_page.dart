import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';

part '../widgets/risk_indicator_scale_intro.dart';
part '../widgets/risk_indicator_details_common.dart';

const _riskBackground = AppColors.bg;
const _riskPanel = AppColors.surface;
const _riskPanel2 = AppColors.surface2;
const _riskBorder = AppColors.borderSolid;
const _riskPrimary = AppColors.primary;
const _riskGreen = AppColors.buy;
const _riskAmber = AppColors.caution;
const _riskRed = AppColors.sell;

class RiskIndicatorExplainerPage extends ConsumerWidget {
  const RiskIndicatorExplainerPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc110_risk_indicator_content');
  static Key levelKey(int level) => Key('sc110_risk_level_$level');
  static Key additionalRiskKey(String title) =>
      Key('sc110_additional_${title.toLowerCase().replaceAll(' ', '_')}');

  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(tradeRiskIndicatorExplainerProvider);
    final mode = shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 70
            : DeviceMetrics.nativeBottomChrome + 28) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-110 RiskIndicatorExplainerPage',
      child: Material(
        color: _riskBackground,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Risk Indicator',
            subtitle: 'Summary Risk Indicator (SRI)',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.tradeCopyTrading),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  key: RiskIndicatorExplainerPage.contentKey,
                  padding: EdgeInsets.fromLTRB(20, 14, 20, bottomInset),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _ProductSriCard(snapshot: snapshot),
                      const SizedBox(height: 26),
                      const _SectionLabel(
                        'What is the Summary Risk Indicator?',
                      ),
                      const SizedBox(height: 10),
                      _SriExplanationCard(
                        holdingPeriodYears: snapshot.holdingPeriodYears,
                      ),
                      const SizedBox(height: 25),
                      const _SectionLabel('Understanding the 1-7 Scale'),
                      const SizedBox(height: 10),
                      for (final level in snapshot.levels) ...[
                        _RiskLevelCard(
                          level: level,
                          isProductLevel: level.level == snapshot.productSri,
                        ),
                        if (level != snapshot.levels.last)
                          const SizedBox(height: 10),
                      ],
                      const SizedBox(height: 25),
                      const _SectionLabel(
                        'Additional Risks Not Captured by SRI',
                      ),
                      const SizedBox(height: 10),
                      _AdditionalRisksCard(risks: snapshot.additionalRisks),
                      const SizedBox(height: 12),
                      const VitCard(
                        variant: VitCardVariant.inner,
                        padding: EdgeInsets.all(12),
                        child: VitHighRiskStatePanel(
                          state: VitHighRiskUiState.riskReview,
                          title: 'Risk indicator review',
                          message:
                              'SRI level, holding period, additional risks, liquidity limits and next steps are reviewed before product action.',
                          contractId: 'risk-indicator-review',
                        ),
                      ),
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
