import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/dca_controller_providers.dart';

enum _BacktesterTab { setup, results, analysis }

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
  _BacktesterTab _activeTab = _BacktesterTab.setup;
  String _asset = 'BTC';
  DcaBacktestFrequency _frequency = DcaBacktestFrequency.monthly;
  DcaBacktestStrategy _strategy = DcaBacktestStrategy.fixed;
  bool _hasResults = false;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(dcaBacktesterProvider);

    return VitPageLayout(
      semanticLabel: 'SC-176 DCABacktesterPage',
      child: Column(
        children: [
          VitHeader(title: 'DCA Backtester', showBack: true, onBack: _close),
          _TopTabs(
            activeTab: _activeTab,
            onChanged: (tab) => setState(() => _activeTab = tab),
          ),
          Expanded(
            child: SingleChildScrollView(
              key: DCABacktesterPage.contentKey,
              physics: const BouncingScrollPhysics(),
              child: VitPageContent(
                customGap: AppSpacing.x5,
                children: [
                  if (_activeTab == _BacktesterTab.setup)
                    ..._buildSetup(snapshot),
                  if (_activeTab == _BacktesterTab.results)
                    if (_hasResults)
                      ..._buildResults(snapshot)
                    else
                      const _NoResultsCard(),
                  if (_activeTab == _BacktesterTab.analysis)
                    if (_hasResults)
                      ..._buildAnalysis(snapshot)
                    else
                      const _NoResultsCard(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildSetup(DcaBacktesterSnapshot snapshot) {
    return [
      _AssetCard(
        assets: snapshot.assets,
        selected: _asset,
        onChanged: (asset) => setState(() => _asset = asset),
      ),
      _DateRangeCard(startDate: snapshot.startDate, endDate: snapshot.endDate),
      _InvestmentCard(
        amountUsd: snapshot.investmentAmountUsd,
        frequencies: snapshot.frequencies,
        selected: _frequency,
        onChanged: (frequency) => setState(() => _frequency = frequency),
      ),
      _SectionLabel(label: 'Chiến lược'),
      _StrategyCards(
        strategies: snapshot.strategies,
        selected: _strategy,
        onChanged: (strategy) => setState(() => _strategy = strategy),
      ),
      if (_strategy == DcaBacktestStrategy.buyDips) const _DipThresholdCard(),
      VitCtaButton(
        key: DCABacktesterPage.runKey,
        onPressed: () {
          setState(() {
            _hasResults = true;
            _activeTab = _BacktesterTab.results;
          });
        },
        leading: const Icon(
          Icons.play_arrow_rounded,
          color: AppColors.onAccent,
          size: AppSpacing.iconMd,
        ),
        child: const Text('Run Backtest'),
      ),
      const _BacktestDisclaimer(),
    ];
  }

  List<Widget> _buildResults(DcaBacktesterSnapshot snapshot) {
    return [
      _ResultSummary(result: snapshot.result),
      _GrowthChartCard(points: snapshot.historicalData),
      _MetricsCard(result: snapshot.result),
      _DcaAdvantageCard(result: snapshot.result),
    ];
  }

  List<Widget> _buildAnalysis(DcaBacktesterSnapshot snapshot) {
    return [
      _DrawdownCard(points: snapshot.drawdowns),
      _RiskMetricCard(result: snapshot.result),
      VitCtaButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Backtest report ready')),
          );
        },
        variant: VitCtaButtonVariant.ghost,
        leading: const Icon(
          Icons.download_rounded,
          color: AppColors.text1,
          size: AppSpacing.iconMd,
        ),
        child: const Text('Download Report'),
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

class _TopTabs extends StatelessWidget {
  const _TopTabs({required this.activeTab, required this.onChanged});

  final _BacktesterTab activeTab;
  final ValueChanged<_BacktesterTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          _TopTab(
            label: 'Cài đặt',
            tab: _BacktesterTab.setup,
            active: activeTab == _BacktesterTab.setup,
            onChanged: onChanged,
          ),
          _TopTab(
            label: 'Kết quả',
            tab: _BacktesterTab.results,
            active: activeTab == _BacktesterTab.results,
            onChanged: onChanged,
          ),
          _TopTab(
            label: 'Phân tích',
            tab: _BacktesterTab.analysis,
            active: activeTab == _BacktesterTab.analysis,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _TopTab extends StatelessWidget {
  const _TopTab({
    required this.label,
    required this.tab,
    required this.active,
    required this.onChanged,
  });

  final String label;
  final _BacktesterTab tab;
  final bool active;
  final ValueChanged<_BacktesterTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        key: DCABacktesterPage.tabKey(tab.name),
        onTap: () => onChanged(tab),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.x4),
              child: Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: active ? AppColors.primary : AppColors.text3,
                  fontWeight: active
                      ? AppTextStyles.bold
                      : AppTextStyles.medium,
                ),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              height: AppSpacing.x1,
              width: double.infinity,
              color: active ? AppColors.primary : AppColors.transparent,
            ),
          ],
        ),
      ),
    );
  }
}

class _AssetCard extends StatelessWidget {
  const _AssetCard({
    required this.assets,
    required this.selected,
    required this.onChanged,
  });

  final List<String> assets;
  final String selected;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CardTitle('Chọn tài sản'),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              for (final asset in assets) ...[
                Expanded(
                  child: _SelectionButton(
                    label: asset,
                    selected: asset == selected,
                    onTap: () => onChanged(asset),
                  ),
                ),
                if (asset != assets.last) const SizedBox(width: AppSpacing.x3),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _DateRangeCard extends StatelessWidget {
  const _DateRangeCard({required this.startDate, required this.endDate});

  final String startDate;
  final String endDate;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CardTitle('Khung thời gian'),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              Expanded(
                child: _ReadOnlyField(
                  label: 'Start Date',
                  value: startDate,
                  icon: Icons.calendar_today_outlined,
                ),
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: _ReadOnlyField(
                  label: 'End Date',
                  value: endDate,
                  icon: Icons.calendar_today_outlined,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InvestmentCard extends StatelessWidget {
  const _InvestmentCard({
    required this.amountUsd,
    required this.frequencies,
    required this.selected,
    required this.onChanged,
  });

  final int amountUsd;
  final List<DcaBacktestFrequencyOption> frequencies;
  final DcaBacktestFrequency selected;
  final ValueChanged<DcaBacktestFrequency> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ReadOnlyField(
            label: 'Investment Amount per Period (USD)',
            value: amountUsd.toString(),
          ),
          const SizedBox(height: AppSpacing.x5),
          Text(
            'Frequency',
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: AppSpacing.x3),
          LayoutBuilder(
            builder: (context, constraints) {
              final width = (constraints.maxWidth - AppSpacing.x3) / 2;
              return Wrap(
                spacing: AppSpacing.x3,
                runSpacing: AppSpacing.x3,
                children: [
                  for (final frequency in frequencies)
                    SizedBox(
                      width: width,
                      child: _SelectionButton(
                        label: frequency.label,
                        selected: frequency.frequency == selected,
                        onTap: () => onChanged(frequency.frequency),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ReadOnlyField extends StatelessWidget {
  const _ReadOnlyField({required this.label, required this.value, this.icon});

  final String label;
  final String value;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: AppColors.text2),
        ),
        const SizedBox(height: AppSpacing.x2),
        DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.surface2,
            borderRadius: AppRadii.inputRadius,
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.x4,
              vertical: AppSpacing.x3,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value,
                    style: AppTextStyles.baseMedium.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
                if (icon != null)
                  Icon(icon, color: AppColors.text3, size: AppSpacing.iconSm),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SelectionButton extends StatelessWidget {
  const _SelectionButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        height: AppSpacing.ctaHeight - AppSpacing.x4,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.surface2,
          borderRadius: AppRadii.inputRadius,
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.cardBorder,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: selected ? AppColors.onAccent : AppColors.text1,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}

class _StrategyCards extends StatelessWidget {
  const _StrategyCards({
    required this.strategies,
    required this.selected,
    required this.onChanged,
  });

  final List<DcaBacktestStrategyOption> strategies;
  final DcaBacktestStrategy selected;
  final ValueChanged<DcaBacktestStrategy> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final strategy in strategies) ...[
          _StrategyCard(
            option: strategy,
            selected: strategy.strategy == selected,
            onTap: () => onChanged(strategy.strategy),
          ),
          if (strategy != strategies.last)
            const SizedBox(height: AppSpacing.x3),
        ],
      ],
    );
  }
}

class _StrategyCard extends StatelessWidget {
  const _StrategyCard({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final DcaBacktestStrategyOption option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: DCABacktesterPage.strategyKey(option.strategy),
      variant: VitCardVariant.ghost,
      width: double.infinity,
      borderColor: selected ? AppColors.primary : AppColors.cardBorder,
      padding: const EdgeInsets.all(AppSpacing.x4),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            option.title,
            style: AppTextStyles.baseMedium.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            option.subtitle,
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _DipThresholdCard extends StatelessWidget {
  const _DipThresholdCard();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: const _ReadOnlyField(label: 'Dip Threshold (%)', value: '5'),
    );
  }
}

class _BacktestDisclaimer extends StatelessWidget {
  const _BacktestDisclaimer();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.warn08,
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: AppColors.warn15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.info_outline_rounded,
              color: AppColors.warn,
              size: AppSpacing.iconSm,
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: Text(
                'Backtest dựa trên dữ liệu lịch sử. Hiệu suất quá khứ không đảm bảo kết quả tương lai. Chỉ mang tính tham khảo.',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  height: 1.45,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultSummary extends StatelessWidget {
  const _ResultSummary({required this.result});

  final DcaBacktestResult result;

  @override
  Widget build(BuildContext context) {
    final items = [
      ('Total Invested', _formatUsd(result.totalInvestedUsd), AppColors.text1),
      ('Final Value', _formatUsd(result.finalValueUsd), AppColors.buy),
      ('Total Return', '+${_formatUsd(result.totalReturnUsd)}', AppColors.buy),
      (
        'Return %',
        '+${result.returnPercent.toStringAsFixed(2)}%',
        AppColors.buy,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = (constraints.maxWidth - AppSpacing.x3) / 2;
        return Wrap(
          spacing: AppSpacing.x3,
          runSpacing: AppSpacing.x3,
          children: [
            for (final item in items)
              SizedBox(
                width: width,
                child: VitCard(
                  padding: const EdgeInsets.all(AppSpacing.x4),
                  borderColor: item.$3 == AppColors.buy
                      ? AppColors.buy20
                      : AppColors.cardBorder,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.$1,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x2),
                      Text(
                        item.$2,
                        style: AppTextStyles.sectionTitle.copyWith(
                          color: item.$3,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _GrowthChartCard extends StatelessWidget {
  const _GrowthChartCard({required this.points});

  final List<DcaBacktestPoint> points;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CardTitle('Portfolio Growth (DCA vs Lump Sum)'),
          const SizedBox(height: AppSpacing.x4),
          SizedBox(
            height: AppSpacing.buttonHero * 2 + AppSpacing.x6,
            child: CustomPaint(
              painter: _BacktestGrowthPainter(points: points),
              child: const SizedBox.expand(),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricsCard extends StatelessWidget {
  const _MetricsCard({required this.result});

  final DcaBacktestResult result;

  @override
  Widget build(BuildContext context) {
    final metrics = [
      ('Avg Buy Price', _formatUsd(result.avgBuyPriceUsd), Icons.attach_money),
      ('Total Shares', result.totalShares.toStringAsFixed(4), Icons.bar_chart),
      ('Number of Buys', result.numberOfBuys.toString(), Icons.event_rounded),
      (
        'Max Drawdown',
        '${result.maxDrawdownPercent}%',
        Icons.trending_down_rounded,
      ),
      (
        'Sharpe Ratio',
        result.sharpeRatio.toStringAsFixed(2),
        Icons.track_changes,
      ),
      ('Volatility', '${result.volatilityPercent}%', Icons.show_chart),
      ('Win Rate', '${result.winRatePercent}%', Icons.percent_rounded),
    ];

    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionLabel(label: 'Performance Metrics'),
          const SizedBox(height: AppSpacing.x3),
          for (final metric in metrics) ...[
            Row(
              children: [
                Icon(
                  metric.$3,
                  color: AppColors.text3,
                  size: AppSpacing.iconSm,
                ),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: Text(
                    metric.$1,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                    ),
                  ),
                ),
                Text(
                  metric.$2,
                  style: AppTextStyles.caption.copyWith(
                    color: metric.$1 == 'Max Drawdown'
                        ? AppColors.sell
                        : AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ],
            ),
            if (metric != metrics.last) const SizedBox(height: AppSpacing.x3),
          ],
        ],
      ),
    );
  }
}

class _DcaAdvantageCard extends StatelessWidget {
  const _DcaAdvantageCard({required this.result});

  final DcaBacktestResult result;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: AppColors.buy20,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.trending_up_rounded,
            color: AppColors.buy,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              'DCA strategy outperformed lump sum by +${(result.returnPercent - 54.76).toStringAsFixed(2)}%',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawdownCard extends StatelessWidget {
  const _DrawdownCard({required this.points});

  final List<DcaDrawdownPoint> points;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CardTitle('Drawdown Analysis'),
          const SizedBox(height: AppSpacing.x4),
          SizedBox(
            height: AppSpacing.buttonHero * 2,
            child: CustomPaint(
              painter: _DrawdownPainter(points: points),
              child: const SizedBox.expand(),
            ),
          ),
        ],
      ),
    );
  }
}

class _RiskMetricCard extends StatelessWidget {
  const _RiskMetricCard({required this.result});

  final DcaBacktestResult result;

  @override
  Widget build(BuildContext context) {
    final metrics = [
      (
        'Max Drawdown',
        '${result.maxDrawdownPercent}%',
        'Largest peak-to-trough decline',
        AppColors.buy,
        'GOOD',
      ),
      (
        'Volatility',
        '${result.volatilityPercent}%',
        'Standard deviation of returns',
        AppColors.buy,
        'GOOD',
      ),
      (
        'Sharpe Ratio',
        result.sharpeRatio.toStringAsFixed(2),
        'Risk-adjusted return',
        AppColors.buy,
        'GOOD',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionLabel(label: 'Risk Analysis'),
        const SizedBox(height: AppSpacing.x3),
        for (final metric in metrics) ...[
          VitCard(
            padding: const EdgeInsets.all(AppSpacing.x4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        metric.$1,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x1),
                      Text(
                        metric.$3,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x2),
                      Text(
                        metric.$2,
                        style: AppTextStyles.baseMedium.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                _StatusBadge(label: metric.$5, color: metric.$4),
              ],
            ),
          ),
          if (metric != metrics.last) const SizedBox(height: AppSpacing.x3),
        ],
      ],
    );
  }
}

class _NoResultsCard extends StatelessWidget {
  const _NoResultsCard();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x6),
      child: Column(
        children: [
          const Icon(
            Icons.bar_chart_rounded,
            color: AppColors.text3,
            size: AppSpacing.iconLg,
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            'Chưa có kết quả backtest',
            style: AppTextStyles.base.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            'Vào tab "Cài đặt" để chạy backtest',
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: AppRadii.smRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x3,
          vertical: AppSpacing.x1,
        ),
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: AppSpacing.x1,
          height: AppSpacing.x4,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: AppRadii.xsRadius,
          ),
        ),
        const SizedBox(width: AppSpacing.x2),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}

class _CardTitle extends StatelessWidget {
  const _CardTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.baseMedium.copyWith(
        color: AppColors.text1,
        fontWeight: AppTextStyles.bold,
      ),
    );
  }
}

class _BacktestGrowthPainter extends CustomPainter {
  const _BacktestGrowthPainter({required this.points});

  final List<DcaBacktestPoint> points;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;
    final maxValue = points
        .map((point) => math.max(point.dcaValueUsd, point.lumpValueUsd))
        .reduce(math.max)
        .toDouble();
    _drawGrid(canvas, size, maxValue);
    _drawValueLine(
      canvas,
      size,
      points.map((point) => point.dcaValueUsd / maxValue).toList(),
      AppColors.buy,
      fill: true,
    );
    _drawValueLine(
      canvas,
      size,
      points.map((point) => point.lumpValueUsd / maxValue).toList(),
      AppColors.primary,
    );
  }

  @override
  bool shouldRepaint(covariant _BacktestGrowthPainter oldDelegate) {
    return oldDelegate.points != points;
  }
}

class _DrawdownPainter extends CustomPainter {
  const _DrawdownPainter({required this.points});

  final List<DcaDrawdownPoint> points;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;
    _drawGrid(canvas, size, 10);
    _drawValueLine(
      canvas,
      size,
      points
          .map(
            (point) =>
                1.0 -
                (point.drawdownPercent.abs() / 12).clamp(0.0, 1.0).toDouble(),
          )
          .toList(),
      AppColors.sell,
      fill: true,
    );
  }

  @override
  bool shouldRepaint(covariant _DrawdownPainter oldDelegate) {
    return oldDelegate.points != points;
  }
}

void _drawGrid(Canvas canvas, Size size, double maxValue) {
  final rect = Rect.fromLTWH(
    AppSpacing.x6,
    AppSpacing.x2,
    size.width - AppSpacing.x7,
    size.height - AppSpacing.x6,
  );
  final grid = Paint()
    ..color = AppColors.borderSolid.withValues(alpha: .45)
    ..strokeWidth = 1;
  final style = AppTextStyles.micro.copyWith(color: AppColors.text3);
  for (var i = 0; i <= 4; i++) {
    final y = rect.top + rect.height * i / 4;
    canvas.drawLine(Offset(rect.left, y), Offset(rect.right, y), grid);
    _paintText(
      canvas,
      _formatCompact((maxValue * (1 - i / 4)).round()),
      Offset(AppSpacing.x2, y - AppSpacing.x3),
      style,
    );
  }
  for (var i = 0; i <= 5; i++) {
    final x = rect.left + rect.width * i / 5;
    canvas.drawLine(Offset(x, rect.top), Offset(x, rect.bottom), grid);
  }
}

void _drawValueLine(
  Canvas canvas,
  Size size,
  List<double> values,
  Color color, {
  bool fill = false,
}) {
  final rect = Rect.fromLTWH(
    AppSpacing.x6,
    AppSpacing.x2,
    size.width - AppSpacing.x7,
    size.height - AppSpacing.x6,
  );
  final path = Path();
  for (var i = 0; i < values.length; i++) {
    final x = rect.left + rect.width * i / (values.length - 1);
    final y = rect.bottom - rect.height * values[i].clamp(0, 1);
    if (i == 0) {
      path.moveTo(x, y);
    } else {
      path.lineTo(x, y);
    }
  }
  if (fill) {
    final fillPath = Path.from(path)
      ..lineTo(rect.right, rect.bottom)
      ..lineTo(rect.left, rect.bottom)
      ..close();
    canvas.drawPath(
      fillPath,
      Paint()
        ..color = color.withValues(alpha: .12)
        ..style = PaintingStyle.fill,
    );
  }
  canvas.drawPath(
    path,
    Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2,
  );
}

void _paintText(Canvas canvas, String text, Offset offset, TextStyle style) {
  final painter = TextPainter(
    text: TextSpan(text: text, style: style),
    textDirection: TextDirection.ltr,
  )..layout();
  painter.paint(canvas, offset);
}

String _formatUsd(int value) {
  return '\$${value.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (match) => '${match[1]},')}';
}

String _formatCompact(int value) {
  if (value >= 1000000) return '${(value / 1000000).toStringAsFixed(1)}M';
  if (value >= 1000) return '${(value / 1000).toStringAsFixed(0)}K';
  return value.toString();
}
