import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/vit_trade_compliance_section.dart';

part '../widgets/risk_indicator_scale_intro.dart';
part '../widgets/risk_indicator_details_common.dart';

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
    return VitTradeHubScaffold(
      title: 'Risk Indicator',
      subtitle: 'Summary Risk Indicator (SRI)',
      semanticLabel: 'SC-110 RiskIndicatorExplainerPage',
      contentKey: RiskIndicatorExplainerPage.contentKey,
      shellRenderMode: shellRenderMode,
      useCopyTradingInset: true,
      onBack: () => context.go(AppRoutePaths.tradeCopyTrading),
      children: [
        VitTradeSection(
          title: 'Review',
          child: const VitHighRiskStatePanel(
            state: VitHighRiskUiState.riskReview,
            title: 'Risk indicator review',
            message:
                'SRI level, holding period, additional risks, liquidity limits and next steps are reviewed before product action.',
            contractId: 'risk-indicator-review',
            density: VitDensity.compact,
          ),
        ),
        VitTradeComplianceSection(
          title: 'Risk review',
          statusPill: VitStatusPill(
            label: 'SRI ${snapshot.productSri}/7',
            status: VitStatusPillStatus.warning,
            size: VitStatusPillSize.sm,
          ),
          items: [
            VitTradeComplianceItem(
              label: 'Holding period',
              value: '${snapshot.holdingPeriodYears} years',
            ),
            VitTradeComplianceItem(
              label: 'Risk levels',
              value: '${snapshot.levels.length} defined',
            ),
          ],
        ),
        VitTradeSection(
          title: 'Product SRI',
          child: _ProductSriCard(snapshot: snapshot),
        ),
        VitTradeSection(
          title: 'What is the Summary Risk Indicator?',
          child: _SriExplanationCard(
            holdingPeriodYears: snapshot.holdingPeriodYears,
          ),
        ),
        VitTradeSection(
          title: 'Understanding the 1-7 Scale',
          child: VitPageSection(
            density: VitDensity.compact,
            children: [
              for (final level in snapshot.levels)
                _RiskLevelCard(
                  level: level,
                  isProductLevel: level.level == snapshot.productSri,
                ),
            ],
          ),
        ),
        VitTradeSection(
          title: 'Additional Risks Not Captured by SRI',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _AdditionalRisksCard(risks: snapshot.additionalRisks),
            ],
          ),
        ),
      ],
    );
  }
}
