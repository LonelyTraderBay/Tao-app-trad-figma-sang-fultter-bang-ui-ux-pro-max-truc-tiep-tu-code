import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/dca_controller_providers.dart';

part '../widgets/dca_performance_compare_tabs.dart';
part '../widgets/dca_performance_compare_charts.dart';
part '../widgets/dca_performance_compare_analysis.dart';

enum _CompareTab { compare, scenarios, analysis }

class DCAPerformanceComparePage extends ConsumerStatefulWidget {
  const DCAPerformanceComparePage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc178_performance_compare_content');

  static Key tabKey(String tabName) => Key('sc178_tab_$tabName');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<DCAPerformanceComparePage> createState() =>
      _DCAPerformanceComparePageState();
}

class _DCAPerformanceComparePageState
    extends ConsumerState<DCAPerformanceComparePage> {
  _CompareTab _activeTab = _CompareTab.compare;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(dcaPerformanceCompareProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollBottom =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome
            : DeviceMetrics.nativeBottomChrome) +
        AppSpacing.x6 +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      semanticLabel: 'SC-178 DCAPerformanceComparePage',
      child: Column(
        children: [
          VitHeader(title: 'DCA vs Lump Sum', showBack: true, onBack: _close),
          _TopTabs(
            activeTab: _activeTab,
            onChanged: (tab) => setState(() => _activeTab = tab),
          ),
          Expanded(
            child: SingleChildScrollView(
              key: DCAPerformanceComparePage.contentKey,
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.only(bottom: scrollBottom),
              child: VitPageContent(
                customGap: AppSpacing.x5,
                children: [
                  if (_activeTab == _CompareTab.compare)
                    ..._buildCompare(snapshot),
                  if (_activeTab == _CompareTab.scenarios)
                    ..._buildScenarios(snapshot),
                  if (_activeTab == _CompareTab.analysis)
                    ..._buildAnalysis(snapshot),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildCompare(DcaPerformanceCompareSnapshot snapshot) {
    return [
      Row(
        children: [
          Expanded(
            child: _StrategyCard(
              title: 'DCA Strategy',
              value: _formatUsd(snapshot.dcaFinalValueUsd),
              invested: _formatUsd(snapshot.investedUsd),
              returnPercent: snapshot.dcaReturnPercent,
              color: AppColors.buy,
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: _StrategyCard(
              title: 'Lump Sum',
              value: _formatUsd(snapshot.lumpSumFinalValueUsd),
              invested: _formatUsd(snapshot.investedUsd),
              returnPercent: snapshot.lumpSumReturnPercent,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
      _WinnerBanner(snapshot: snapshot),
      _ComparisonChartCard(points: snapshot.comparison),
      VitPageSection(
        label: 'Key Metrics',
        children: [
          for (final metric in snapshot.metrics) _MetricCompareCard(metric),
        ],
      ),
    ];
  }

  List<Widget> _buildScenarios(DcaPerformanceCompareSnapshot snapshot) {
    return [
      VitPageSection(
        label: 'Scenarios Analysis',
        children: [
          for (final scenario in snapshot.scenarios)
            _ScenarioCard(scenario: scenario),
        ],
      ),
      const _InfoCard(
        icon: Icons.info_outline_rounded,
        title: 'Recommendation',
        text:
            'DCA is optimal for volatile markets and when you want to reduce timing risk. Lump sum can win in steady bull markets with low volatility.',
      ),
    ];
  }

  List<Widget> _buildAnalysis(DcaPerformanceCompareSnapshot snapshot) {
    return [
      _RadarCard(metrics: snapshot.radar),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Expanded(child: _ProsConsCard.dca()),
          SizedBox(width: AppSpacing.x3),
          Expanded(child: _ProsConsCard.lumpSum()),
        ],
      ),
      const _WarningCard(
        text:
            'So sanh dua tren du lieu lich su cu the. Ket qua co the khac trong dieu kien thi truong khac. Khong dam bao hieu suat tuong lai.',
      ),
    ];
  }

  void _close() {
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(AppRoutePaths.dca);
  }
}
