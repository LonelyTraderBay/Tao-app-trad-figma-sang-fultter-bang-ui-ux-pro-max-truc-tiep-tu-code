import 'dart:math' as math;

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
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';

part '../widgets/portfolio_risk_analysis_page_sections.dart';
part '../widgets/portfolio_risk_analysis_page_common.dart';

const _riskPrimary = AppColors.primary;
const _riskPanel = AppColors.surface2;
const _riskTabBackground = AppColors.surface;
const _riskCard = AppColors.surface;
const _riskWarningBackground = AppColors.warningBg;
const _riskWarningBorder = AppColors.warningBorderStrong;
const _riskWarningText = AppColors.caution;

class PortfolioRiskAnalysisPage extends ConsumerStatefulWidget {
  const PortfolioRiskAnalysisPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc078_portfolio_risk_content');
  static Key tabKey(String id) => Key('sc078_tab_$id');

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
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomChrome = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final bottomInset =
        bottomChrome +
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame ? 146 : 30);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-078 PortfolioRiskAnalysisPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: 'Phân tích rủi ro',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.tradeCopyTrading),
            ),
            Expanded(
              child: SingleChildScrollView(
                key: PortfolioRiskAnalysisPage.contentKey,
                padding: EdgeInsets.fromLTRB(20, 13, 20, bottomInset),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _RiskSummaryGrid(snapshot: snapshot),
                    const SizedBox(height: 24),
                    _RiskWarningPanel(alerts: snapshot.riskAlerts),
                    const SizedBox(height: 24),
                    _RiskTabs(
                      tabs: snapshot.tabs,
                      activeId: _activeTab,
                      onChanged: (id) => setState(() => _activeTab = id),
                    ),
                    const SizedBox(height: 25),
                    if (_activeTab == 'exposure')
                      _ExposureTab(snapshot: snapshot)
                    else if (_activeTab == 'correlation')
                      const _PlaceholderPanel(
                        title: 'Provider Correlation Matrix',
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
            ),
          ],
        ),
      ),
    );
  }
}
