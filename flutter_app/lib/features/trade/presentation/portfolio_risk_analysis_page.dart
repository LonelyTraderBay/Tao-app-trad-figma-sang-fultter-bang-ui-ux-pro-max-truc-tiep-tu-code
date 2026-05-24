import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radii.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/device_metrics.dart';
import '../../../shared/layout/shell_render_mode.dart';
import '../../../shared/layout/vit_header.dart';
import '../../../shared/layout/vit_page_layout.dart';
import '../data/trade_repository.dart';

const _riskPrimary = AppColors.primary;
const _riskPanel = AppColors.surface2;
const _riskTabBackground = AppColors.surface;
const _riskCard = AppColors.surface;
const _riskWarningBackground = AppColors.warningBg;
const _riskWarningBorder = Color(0x665A3A00);
const _riskWarningText = Color(0xFFF59E0B);

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
    final snapshot = ref
        .watch(tradeRepositoryProvider)
        .getPortfolioRiskAnalysis();
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

class _RiskSummaryGrid extends StatelessWidget {
  const _RiskSummaryGrid({required this.snapshot});

  final TradePortfolioRiskAnalysisSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _RiskSummaryCard(
                label: 'Total Exposure',
                value: _formatUsd(snapshot.totalExposure),
                caption: 'Across ${snapshot.assetExposures.length} assets',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _RiskSummaryCard(
                label: 'VaR (95%, 1-day)',
                value: _formatUsd(snapshot.var95.abs()),
                valueColor: AppColors.sell,
                caption: 'Max loss @ 95%',
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _RiskSummaryCard(
                label: 'Diversification',
                value: '${snapshot.diversificationScore}/100',
                valueColor: AppColors.buy,
                caption: 'Good',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _RiskSummaryCard(
                label: 'Risk Alerts',
                value: '${snapshot.riskAlerts.length}',
                valueColor: AppColors.sell,
                caption: 'Active warnings',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _RiskSummaryCard extends StatelessWidget {
  const _RiskSummaryCard({
    required this.label,
    required this.value,
    required this.caption,
    this.valueColor = AppColors.text1,
  });

  final String label;
  final String value;
  final String caption;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 88,
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 11),
      decoration: BoxDecoration(
        color: _riskCard,
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 10,
              height: 1,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: AppTextStyles.sectionTitle.copyWith(
              color: valueColor,
              fontSize: 18,
              fontWeight: AppTextStyles.bold,
              height: 1,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            caption,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 9,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _RiskWarningPanel extends StatelessWidget {
  const _RiskWarningPanel({required this.alerts});

  final List<String> alerts;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 13, 12, 13),
      decoration: BoxDecoration(
        color: _riskWarningBackground,
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: _riskWarningBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: _riskWarningText,
                size: 14,
              ),
              const SizedBox(width: 8),
              Text(
                'Cảnh báo rủi ro',
                style: AppTextStyles.caption.copyWith(
                  color: _riskWarningText,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  height: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 11),
          for (final alert in alerts) ...[
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Text(
                '• $alert',
                style: AppTextStyles.micro.copyWith(
                  color: _riskWarningText,
                  fontSize: 10,
                  fontWeight: AppTextStyles.bold,
                  height: 1.45,
                ),
              ),
            ),
            if (alert != alerts.last) const SizedBox(height: 3),
          ],
        ],
      ),
    );
  }
}

class _RiskTabs extends StatelessWidget {
  const _RiskTabs({
    required this.tabs,
    required this.activeId,
    required this.onChanged,
  });

  final List<TradePortfolioRiskTab> tabs;
  final String activeId;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 53,
      color: _riskTabBackground,
      child: Row(
        children: [
          for (final tab in tabs)
            Expanded(
              child: InkWell(
                key: PortfolioRiskAnalysisPage.tabKey(tab.id),
                onTap: () => onChanged(tab.id),
                child: Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          tab.label,
                          style: AppTextStyles.caption.copyWith(
                            color: tab.id == activeId
                                ? _riskPrimary
                                : AppColors.text3,
                            fontSize: 12,
                            fontWeight: AppTextStyles.bold,
                            height: 1,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: tab.id == activeId ? 64 : 0,
                      height: 2,
                      color: _riskPrimary,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ExposureTab extends StatelessWidget {
  const _ExposureTab({required this.snapshot});

  final TradePortfolioRiskAnalysisSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            'Asset Allocation',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text2,
              fontSize: 12,
              fontWeight: AppTextStyles.bold,
              height: 1,
            ),
          ),
        ),
        const SizedBox(height: 22),
        SizedBox(
          height: 220,
          child: Center(
            child: CustomPaint(
              size: const Size(170, 170),
              painter: _ExposurePiePainter(snapshot.assetExposures),
            ),
          ),
        ),
        const SizedBox(height: 25),
        for (final asset in snapshot.assetExposures) ...[
          _AssetExposureRow(asset: asset),
          if (asset != snapshot.assetExposures.last) const SizedBox(height: 8),
        ],
        const SizedBox(height: 18),
        _DiversificationNote(score: snapshot.diversificationScore),
      ],
    );
  }
}

class _AssetExposureRow extends StatelessWidget {
  const _AssetExposureRow({required this.asset});

  final TradeAssetExposure asset;

  @override
  Widget build(BuildContext context) {
    final color = Color(asset.colorHex);
    return Container(
      height: 47,
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
      decoration: BoxDecoration(
        color: _riskPanel,
        borderRadius: AppRadii.inputRadius,
      ),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(
            asset.asset,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontSize: 11,
              fontWeight: AppTextStyles.medium,
              height: 1,
            ),
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _formatUsd(asset.value),
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontSize: 12,
                  fontWeight: AppTextStyles.bold,
                  height: 1,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                '${_formatPercent(asset.percent)}%',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  fontSize: 9,
                  height: 1,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DiversificationNote extends StatelessWidget {
  const _DiversificationNote({required this.score});

  final int score;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 13, 12, 13),
      decoration: BoxDecoration(
        color: _riskPrimary.withValues(alpha: .08),
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: _riskPrimary),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline_rounded, color: _riskPrimary, size: 15),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              'Diversification score $score/100. Khuyến nghị không để asset nào chiếm >30% portfolio.',
              style: AppTextStyles.micro.copyWith(
                color: _riskPrimary,
                fontSize: 10,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlaceholderPanel extends StatelessWidget {
  const _PlaceholderPanel({required this.title, required this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _riskCard,
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontSize: 13,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class _VarPanel extends StatelessWidget {
  const _VarPanel({required this.snapshot});

  final TradePortfolioRiskAnalysisSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return _PlaceholderPanel(
      title: 'Value at Risk',
      description:
          'VaR 95% ${_formatUsd(snapshot.var95.abs())}; VaR 99% ${_formatUsd(snapshot.var99.abs())}.',
    );
  }
}

class _StressScenarioPanel extends StatelessWidget {
  const _StressScenarioPanel({required this.scenarios});

  final List<TradeStressScenario> scenarios;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final scenario in scenarios) ...[
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _riskPanel,
              borderRadius: AppRadii.inputRadius,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    scenario.name,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontSize: 12,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
                Text(
                  _formatSignedUsd(scenario.impact),
                  style: AppTextStyles.caption.copyWith(
                    color: scenario.impact >= 0
                        ? AppColors.buy
                        : AppColors.sell,
                    fontSize: 14,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ],
            ),
          ),
          if (scenario != scenarios.last) const SizedBox(height: 8),
        ],
      ],
    );
  }
}

class _ExposurePiePainter extends CustomPainter {
  const _ExposurePiePainter(this.assets);

  final List<TradeAssetExposure> assets;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    var start = 0.0;
    for (final asset in assets) {
      final sweep = -asset.percent / 100 * math.pi * 2;
      final fill = Paint()
        ..color = Color(asset.colorHex)
        ..style = PaintingStyle.fill;
      canvas.drawArc(rect, start, sweep, true, fill);
      final stroke = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1;
      canvas.drawArc(rect, start, sweep, true, stroke);
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _ExposurePiePainter oldDelegate) {
    return oldDelegate.assets != assets;
  }
}

String _formatUsd(double value) {
  return '\$${_formatNumber(value.round())}';
}

String _formatSignedUsd(double value) {
  final sign = value >= 0 ? '+' : '-';
  return '$sign\$${_formatNumber(value.abs().round())}';
}

String _formatNumber(int value) {
  final chars = value.toString().split('').reversed.toList();
  final groups = <String>[];
  for (var i = 0; i < chars.length; i += 3) {
    groups.add(chars.skip(i).take(3).toList().reversed.join());
  }
  return groups.reversed.join(',');
}

String _formatPercent(double value) {
  if (value == value.roundToDouble()) return value.toStringAsFixed(0);
  return value.toStringAsFixed(1);
}
