import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/trade_module_layout.dart';

part '../widgets/risk_indicator_scale_intro.dart';
part '../widgets/risk_indicator_details_common.dart';

const _riskBackground = AppColors.bg;
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
    final bottomInset = copyTradingScrollBottomInset(
      context,
      shellRenderMode: mode,
    );

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
                  padding: AppSpacing.zeroInsets.copyWith(
                    left: AppSpacing.contentPad,
                    top: AppSpacing.x2,
                    right: AppSpacing.contentPad,
                    bottom: bottomInset,
                  ),
                  child: VitPageContent(
                    padding: VitContentPadding.none,
                    density: VitDensity.compact,
                    fullBleed: true,
                    children: [
                      _ProductSriCard(snapshot: snapshot),
                      const VitSectionHeader(
                        title: 'What is the Summary Risk Indicator?',
                        variant: VitSectionHeaderVariant.accentBar,
                        accentColor: _riskPrimary,
                      ),
                      _SriExplanationCard(
                        holdingPeriodYears: snapshot.holdingPeriodYears,
                      ),
                      const VitSectionHeader(
                        title: 'Understanding the 1-7 Scale',
                        variant: VitSectionHeaderVariant.accentBar,
                        accentColor: _riskPrimary,
                      ),
                      VitPageSection(
                        density: VitDensity.compact,
                        children: [
                          for (final level in snapshot.levels)
                            _RiskLevelCard(
                              level: level,
                              isProductLevel:
                                  level.level == snapshot.productSri,
                            ),
                        ],
                      ),
                      const VitSectionHeader(
                        title: 'Additional Risks Not Captured by SRI',
                        variant: VitSectionHeaderVariant.accentBar,
                        accentColor: _riskPrimary,
                      ),
                      _AdditionalRisksCard(risks: snapshot.additionalRisks),
                      const VitHighRiskStatePanel(
                        state: VitHighRiskUiState.riskReview,
                        title: 'Risk indicator review',
                        message:
                            'SRI level, holding period, additional risks, liquidity limits and next steps are reviewed before product action.',
                        contractId: 'risk-indicator-review',
                        density: VitDensity.compact,
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
