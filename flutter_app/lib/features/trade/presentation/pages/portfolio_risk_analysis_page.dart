import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/trade_formatters.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/vit_trade_compliance_section.dart';
import 'package:vit_trade_flutter/app/theme/spacing/trade_spacing_tokens.dart';

part '../widgets/portfolio_risk_analysis_page_sections.dart';
part '../widgets/portfolio_risk_analysis_page_common.dart';

const _riskPrimary = AppColors.primary;
const _riskWarningBorder = AppColors.warningBorderStrong;
const _riskWarningText = AppColors.caution;
const double _riskSectionSpace = AppSpacing.x2;
const double _riskTinySpace = AppSpacing.x1;
const double _riskSummaryExtent = 82;
const double _riskChartExtent = 128;
const double _riskRingExtent = 78;
const double _riskAssetRowExtent = 46;
const double _riskSwatchExtent = 14;
const double _riskBodyLineHeight = 1.24;
const double _riskCaptionLineHeight = 1.1;

class PortfolioRiskAnalysisPage extends ConsumerStatefulWidget {
  const PortfolioRiskAnalysisPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc078_portfolio_risk_content');
  static Key tabKey(String id) => Key('sc078_tab_$id');
  static Key assetKey(String asset) => Key('sc078_asset_$asset');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<PortfolioRiskAnalysisPage> createState() =>
      _PortfolioRiskAnalysisPageState();
}

class _PortfolioRiskAnalysisPageState
    extends ConsumerState<PortfolioRiskAnalysisPage> {
  String _activeTab = 'exposure';

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(tradePortfolioRiskAnalysisProvider);
    return VitTradeHubScaffold(
      title: 'Phân tích rủi ro',
      semanticLabel: 'SC-078 PortfolioRiskAnalysisPage',
      contentKey: PortfolioRiskAnalysisPage.contentKey,
      shellRenderMode: widget.shellRenderMode,
      onBack: () => context.go(AppRoutePaths.tradeCopyTrading),
      children: [
        VitTradeSection(
          title: 'Tóm tắt',
          child: _RiskSummaryGrid(snapshot: snapshot),
        ),
        VitTradeSection(
          title: 'Phân tích',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const VitHighRiskStatePanel(
                state: VitHighRiskUiState.riskReview,
                title: 'Xem trước rủi ro danh mục',
                message:
                    'Xem lại mức phơi nhiễm, VaR, tương quan, kịch bản stress, giới hạn và bước tái cân bằng trước khi thay đổi phân bổ copy.',
                contractId: 'SC-078 risk analysis review',
                density: VitDensity.compact,
              ),
              _RiskWarningPanel(alerts: snapshot.riskAlerts),
              _RiskTabs(
                tabs: snapshot.tabs,
                activeId: _activeTab,
                onChanged: (id) => setState(() => _activeTab = id),
              ),
              if (_activeTab == 'exposure')
                _ExposureTab(snapshot: snapshot)
              else if (_activeTab == 'correlation')
                const _PlaceholderPanel(
                  title: 'Ma trận tương quan provider',
                  description:
                      'Correlation >0.8 nghĩa là 2 providers có xu hướng giống nhau.',
                )
              else if (_activeTab == 'var')
                _VarPanel(snapshot: snapshot)
              else
                _StressScenarioPanel(scenarios: snapshot.scenarios),
            ],
          ),
        ),
        VitTradeComplianceSection(
          title: 'Đánh giá rủi ro',
          statusPill: VitStatusPill(
            label: '${snapshot.riskAlerts.length} cảnh báo',
            status: VitStatusPillStatus.warning,
            size: VitStatusPillSize.sm,
          ),
          items: const [
            VitTradeComplianceItem(
              label: 'Khung',
              value: 'Đánh giá rủi ro danh mục copy',
            ),
            VitTradeComplianceItem(
              label: 'Hành động',
              value: 'Xem lại trước khi thay đổi phân bổ',
            ),
          ],
        ),
      ],
    );
  }
}
