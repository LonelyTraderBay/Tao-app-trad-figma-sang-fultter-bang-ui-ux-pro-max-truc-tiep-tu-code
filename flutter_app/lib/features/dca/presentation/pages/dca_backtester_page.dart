import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/dca_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/features/dca/presentation/widgets/dca_backtester_analysis.dart';
import 'package:vit_trade_flutter/features/dca/presentation/widgets/dca_backtester_common.dart';
import 'package:vit_trade_flutter/features/dca/presentation/widgets/dca_backtester_results.dart';
import 'package:vit_trade_flutter/features/dca/presentation/widgets/dca_backtester_setup.dart';
import 'package:vit_trade_flutter/features/dca/presentation/widgets/dca_backtester_tabs.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';

class DCABacktesterPage extends ConsumerStatefulWidget {
  const DCABacktesterPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc176_backtester_content');
  static const runKey = Key('sc176_run_backtest');

  static Key tabKey(String tabName) => Key('sc176_tab_$tabName');
  static Key strategyKey(DcaBacktestStrategy strategy) {
    return Key('sc176_strategy_${strategy.name}');
  }

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<DCABacktesterPage> createState() => _DCABacktesterPageState();
}

class _DCABacktesterPageState extends ConsumerState<DCABacktesterPage> {
  DcaBacktesterTab _activeTab = DcaBacktesterTab.setup;
  String _asset = 'BTC';
  DcaBacktestFrequency _frequency = DcaBacktestFrequency.monthly;
  DcaBacktestStrategy _strategy = DcaBacktestStrategy.fixed;
  bool _hasResults = false;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(dcaBacktesterProvider);

    return VitPageLayout(
      semanticLabel: 'SC-176 DCABacktesterPage',
      child: VitAutoHideHeaderScaffold(
        header: VitHeader(
          title: 'DCA Backtester',
          showBack: true,
          onBack: _close,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DcaBacktesterTopTabs(
              activeTab: _activeTab,
              tabKey: DCABacktesterPage.tabKey,
              onChanged: (tab) => setState(() => _activeTab = tab),
            ),
            Expanded(
              child: SingleChildScrollView(
                key: DCABacktesterPage.contentKey,
                physics: const BouncingScrollPhysics(),
                child: VitPageContent(
                  customGap: AppSpacing.x5,
                  children: [
                    if (_activeTab == DcaBacktesterTab.setup)
                      DcaBacktesterSetup(
                        snapshot: snapshot,
                        asset: _asset,
                        frequency: _frequency,
                        strategy: _strategy,
                        runKey: DCABacktesterPage.runKey,
                        strategyKey: DCABacktesterPage.strategyKey,
                        onAssetChanged: (asset) =>
                            setState(() => _asset = asset),
                        onFrequencyChanged: (frequency) =>
                            setState(() => _frequency = frequency),
                        onStrategyChanged: (strategy) =>
                            setState(() => _strategy = strategy),
                        onRun: _runBacktest,
                      ),
                    if (_activeTab == DcaBacktesterTab.results)
                      if (_hasResults)
                        DcaBacktesterResults(snapshot: snapshot)
                      else
                        const DcaNoResultsCard(),
                    if (_activeTab == DcaBacktesterTab.analysis)
                      if (_hasResults)
                        DcaBacktesterAnalysis(
                          snapshot: snapshot,
                          onDownloadReport: _downloadReport,
                        )
                      else
                        const DcaNoResultsCard(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _runBacktest() {
    setState(() {
      _hasResults = true;
      _activeTab = DcaBacktesterTab.results;
    });
  }

  void _downloadReport() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Backtest report ready')));
  }

  void _close() {
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(AppRoutePaths.dca);
  }
}
