import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/dca_controller_providers.dart';

part 'dca_portfolio_optimizer_page_part_01.dart';
part 'dca_portfolio_optimizer_page_part_02.dart';
part 'dca_portfolio_optimizer_page_part_03.dart';
part 'dca_portfolio_optimizer_page_part_04.dart';
part '../widgets/dca_portfolio_optimizer_header_drift.dart';
part '../widgets/dca_portfolio_optimizer_comparison_hero.dart';
part '../widgets/dca_portfolio_optimizer_tabs.dart';
part '../widgets/dca_portfolio_optimizer_frontier.dart';
part '../widgets/dca_portfolio_optimizer_tab_panels.dart';
part '../widgets/dca_portfolio_optimizer_floating_actions.dart';
part '../widgets/dca_portfolio_optimizer_common_widgets.dart';
part '../widgets/dca_portfolio_optimizer_allocation_widgets.dart';
part '../widgets/dca_portfolio_optimizer_stat_widgets.dart';
part '../widgets/dca_portfolio_optimizer_frontier_painter.dart';

enum _OptimizerTab { frontier, correlation, backtest, risk }

const double _dcaPortfolioVisualNavClearance = 112;
const double _dcaPortfolioNativeNavClearance = 88;
const double _dcaPortfolioBodyLineHeight = 1.35;
const double _dcaPortfolioTightLineHeight = 1.0;
const double _dcaPortfolioFrontierChartHeight = 180;
const double _dcaPortfolioFrontierChipListHeight = AppSpacing.inputHeight;
const double _dcaPortfolioFrontierChipWidth =
    AppSpacing.buttonStandard + AppSpacing.x7;
const double _dcaPortfolioBacktestChartHeight = 180;
const double _dcaPortfolioDividerWidth = AppSpacing.hairlineStroke;
const int _dcaPortfolioRiskGridColumns = 2;
const double _dcaPortfolioRiskGridAspect = 1.35;
const double _dcaPortfolioHeroIconExtent = AppSpacing.inputHeight;
const double _dcaPortfolioIconBubbleExtent = AppSpacing.x6;
const EdgeInsetsDirectional _dcaPortfolioCardPadding =
    EdgeInsetsDirectional.all(AppSpacing.x3);
const EdgeInsetsDirectional _dcaPortfolioHeroPadding =
    EdgeInsetsDirectional.all(AppSpacing.x4);

class DCAPortfolioOptimizer extends ConsumerStatefulWidget {
  const DCAPortfolioOptimizer({super.key, this.shellRenderMode});

  static const contentKey = Key('sc174_portfolio_optimizer_content');
  static const applyKey = Key('sc174_apply_allocation');
  static const driftSettingsKey = Key('sc174_drift_settings');

  static Key tabKey(String tabName) => Key('sc174_tab_$tabName');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<DCAPortfolioOptimizer> createState() =>
      _DCAPortfolioOptimizerState();
}

class _DCAPortfolioOptimizerState extends ConsumerState<DCAPortfolioOptimizer> {
  _OptimizerTab _activeTab = _OptimizerTab.frontier;
  bool _showSuggestions = true;
  bool _showDriftBanner = true;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(dcaPortfolioOptimizerProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final navClearance = mode.usesVisualQaFrame
        ? _dcaPortfolioVisualNavClearance
        : _dcaPortfolioNativeNavClearance;
    final scrollEndPadding =
        navClearance + MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      semanticLabel: 'SC-174 DCAPortfolioOptimizer',
      child: VitAutoHideHeaderScaffold(
        header: VitHeader(
          title: 'Portfolio Optimizer',
          subtitle: 'Tối ưu · DCA',
          showBack: true,
          onBack: _close,
          actions: [
            VitHeaderActionItem(
              type: VitHeaderActionType.share,
              onPressed: _showExportNotice,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  key: DCAPortfolioOptimizer.contentKey,
                  physics: const ClampingScrollPhysics(),
                  padding: EdgeInsetsDirectional.fromSTEB(
                    AppSpacing.contentPad,
                    AppSpacing.x3,
                    AppSpacing.contentPad,
                    scrollEndPadding,
                  ),
                  child: VitPageContent(
                    padding: VitContentPadding.compact,
                    density: VitDensity.compact,
                    children: [
                      if (_showDriftBanner)
                        _DriftBanner(
                          snapshot: snapshot,
                          onDismiss: () {
                            setState(() => _showDriftBanner = false);
                          },
                          onSettings: _showDriftSettings,
                        ),
                      _OptimizerTabs(
                        activeTab: _activeTab,
                        onChanged: (tab) {
                          setState(() => _activeTab = tab);
                        },
                      ),
                      _ComparisonHero(snapshot: snapshot),
                      _TabContent(
                        activeTab: _activeTab,
                        snapshot: snapshot,
                        showSuggestions: _showSuggestions,
                        onToggleSuggestions: () {
                          setState(() => _showSuggestions = !_showSuggestions);
                        },
                      ),
                      _OptimizerApplyAction(
                        onApply: () =>
                            context.go(AppRoutePaths.dcaRebalanceConfig),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _close() {
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(AppRoutePaths.dca);
  }

  void _showExportNotice() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Portfolio report ready to share')),
    );
  }

  void _showDriftSettings() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Drift threshold: 5%')));
  }
}
