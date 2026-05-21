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
import '../../../shared/layout/vit_page_content.dart';
import '../../../shared/layout/vit_page_layout.dart';
import '../../../shared/widgets/widgets.dart';
import '../data/predictions_repository.dart';

const _predictionBlue = Color(0xFF3B82F6);
const _purple = Color(0xFF8B5CF6);

enum _ChartTab { chart, indicators, analysis }

class PredictionAdvancedChartPage extends ConsumerStatefulWidget {
  const PredictionAdvancedChartPage({
    super.key,
    required this.eventId,
    this.shellRenderMode,
  });

  static const contentKey = Key('sc041_advanced_chart_content');
  static const chartTabKey = Key('sc041_tab_chart');
  static const indicatorsTabKey = Key('sc041_tab_indicators');
  static const analysisTabKey = Key('sc041_tab_analysis');
  static const timeframe4hKey = Key('sc041_timeframe_4h');
  static const ma7ToggleKey = Key('sc041_toggle_ma7');
  static const ma25ToggleKey = Key('sc041_toggle_ma25');
  static const bbToggleKey = Key('sc041_toggle_bb');
  static const volumeToggleKey = Key('sc041_toggle_volume');

  final String eventId;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<PredictionAdvancedChartPage> createState() =>
      _PredictionAdvancedChartPageState();
}

class _PredictionAdvancedChartPageState
    extends ConsumerState<PredictionAdvancedChartPage> {
  _ChartTab _activeTab = _ChartTab.chart;
  String _timeframe = '1H';
  bool _showMA7 = true;
  bool _showMA25 = true;
  bool _showBB = true;
  bool _showVolume = true;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(predictionsRepositoryProvider)
        .getAdvancedChart(widget.eventId);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomChrome = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final bottomInset =
        bottomChrome +
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame ? 54 : 20);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-041 PredictionAdvancedChartPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: 'Advanced Chart',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.marketsPredictions),
            ),
            _AdvancedChartTabBar(
              activeTab: _activeTab,
              onChanged: (tab) => setState(() => _activeTab = tab),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  key: PredictionAdvancedChartPage.contentKey,
                  padding: EdgeInsets.only(bottom: bottomInset),
                  child: VitPageContent(
                    padding: VitContentPadding.relaxed,
                    customGap: 16,
                    children: switch (_activeTab) {
                      _ChartTab.chart => [
                        _TimeframeSelector(
                          active: _timeframe,
                          onChanged: (value) =>
                              setState(() => _timeframe = value),
                        ),
                        _ProbabilitySummaryCard(snapshot: snapshot),
                        _ProbabilityChartCard(
                          snapshot: snapshot,
                          showMA7: _showMA7,
                          showMA25: _showMA25,
                          showBB: _showBB,
                        ),
                        if (_showVolume) _VolumeChartCard(snapshot: snapshot),
                        _ChartLayerControls(
                          showMA7: _showMA7,
                          showMA25: _showMA25,
                          showBB: _showBB,
                          showVolume: _showVolume,
                          onMA7: () => setState(() => _showMA7 = !_showMA7),
                          onMA25: () => setState(() => _showMA25 = !_showMA25),
                          onBB: () => setState(() => _showBB = !_showBB),
                          onVolume: () =>
                              setState(() => _showVolume = !_showVolume),
                        ),
                      ],
                      _ChartTab.indicators => [
                        _RsiCard(snapshot: snapshot),
                        _IndicatorSummarySection(snapshot: snapshot),
                        const _OverallSignalCard(),
                      ],
                      _ChartTab.analysis => [
                        _OrderFlowCard(snapshot: snapshot),
                        _SupportResistanceSection(snapshot: snapshot),
                        _PatternRecognitionCard(snapshot: snapshot),
                        const _AnalysisDisclaimer(),
                      ],
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AdvancedChartTabBar extends StatelessWidget {
  const _AdvancedChartTabBar({
    required this.activeTab,
    required this.onChanged,
  });

  final _ChartTab activeTab;
  final ValueChanged<_ChartTab> onChanged;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      (
        key: PredictionAdvancedChartPage.chartTabKey,
        tab: _ChartTab.chart,
        label: 'Bieu do',
      ),
      (
        key: PredictionAdvancedChartPage.indicatorsTabKey,
        tab: _ChartTab.indicators,
        label: 'Chi bao',
      ),
      (
        key: PredictionAdvancedChartPage.analysisTabKey,
        tab: _ChartTab.analysis,
        label: 'Phan tich',
      ),
    ];

    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: SizedBox(
        height: 54,
        child: Row(
          children: [
            for (final item in tabs)
              Expanded(
                child: InkWell(
                  key: item.key,
                  onTap: () => onChanged(item.tab),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(
                            item.label,
                            style: AppTextStyles.caption.copyWith(
                              color: activeTab == item.tab
                                  ? _predictionBlue
                                  : AppColors.text3,
                              fontWeight: AppTextStyles.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 160),
                        height: 2,
                        width: activeTab == item.tab ? 116 : 0,
                        decoration: BoxDecoration(
                          color: _predictionBlue,
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
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

class _TimeframeSelector extends StatelessWidget {
  const _TimeframeSelector({required this.active, required this.onChanged});

  final String active;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    const timeframes = ['1H', '4H', '1D', '1W'];
    return Row(
      children: [
        for (var index = 0; index < timeframes.length; index += 1) ...[
          Expanded(
            child: _TimeframeButton(
              key: timeframes[index] == '4H'
                  ? PredictionAdvancedChartPage.timeframe4hKey
                  : null,
              label: timeframes[index],
              active: active == timeframes[index],
              onTap: () => onChanged(timeframes[index]),
            ),
          ),
          if (index != timeframes.length - 1) const SizedBox(width: 10),
        ],
      ],
    );
  }
}

class _TimeframeButton extends StatelessWidget {
  const _TimeframeButton({
    super.key,
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: Material(
        color: active ? _predictionBlue : AppColors.bg,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(
                color: active ? Colors.transparent : AppColors.border,
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: active ? Colors.white : AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ProbabilitySummaryCard extends StatelessWidget {
  const _ProbabilitySummaryCard({required this.snapshot});

  final PredictionAdvancedChartSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Current Probability',
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: 7),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${(snapshot.currentProbability * 100).toStringAsFixed(1)}%',
                style: AppTextStyles.heroNumber.copyWith(fontSize: 28),
              ),
              const SizedBox(width: 9),
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Row(
                  children: [
                    const Icon(
                      Icons.north_east_rounded,
                      color: AppColors.buy,
                      size: 16,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      '+${snapshot.priceChangePercent.toStringAsFixed(2)}%',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.buy,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProbabilityChartCard extends StatelessWidget {
  const _ProbabilityChartCard({
    required this.snapshot,
    required this.showMA7,
    required this.showMA25,
    required this.showBB,
  });

  final PredictionAdvancedChartSnapshot snapshot;
  final bool showMA7;
  final bool showMA25;
  final bool showBB;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Probability Chart',
            style: AppTextStyles.caption.copyWith(
              fontWeight: AppTextStyles.bold,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 286,
            child: CustomPaint(
              painter: _ProbabilityPainter(
                points: snapshot.priceHistory,
                support: snapshot.supportLevel,
                resistance: snapshot.resistanceLevel,
                showMA7: showMA7,
                showMA25: showMA25,
                showBB: showBB,
              ),
              child: const SizedBox.expand(),
            ),
          ),
        ],
      ),
    );
  }
}

class _VolumeChartCard extends StatelessWidget {
  const _VolumeChartCard({required this.snapshot});

  final PredictionAdvancedChartSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Trading Volume',
            style: AppTextStyles.caption.copyWith(
              fontWeight: AppTextStyles.bold,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 122,
            child: CustomPaint(
              painter: _VolumePainter(points: snapshot.priceHistory),
              child: const SizedBox.expand(),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChartLayerControls extends StatelessWidget {
  const _ChartLayerControls({
    required this.showMA7,
    required this.showMA25,
    required this.showBB,
    required this.showVolume,
    required this.onMA7,
    required this.onMA25,
    required this.onBB,
    required this.onVolume,
  });

  final bool showMA7;
  final bool showMA25;
  final bool showBB;
  final bool showVolume;
  final VoidCallback onMA7;
  final VoidCallback onMA25;
  final VoidCallback onBB;
  final VoidCallback onVolume;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Lop hien thi',
      accentColor: _predictionBlue,
      children: [
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 3.9,
          children: [
            _LayerButton(
              key: PredictionAdvancedChartPage.ma7ToggleKey,
              label: 'MA(7)',
              color: AppColors.buy,
              active: showMA7,
              onTap: onMA7,
            ),
            _LayerButton(
              key: PredictionAdvancedChartPage.ma25ToggleKey,
              label: 'MA(25)',
              color: _purple,
              active: showMA25,
              onTap: onMA25,
            ),
            _LayerButton(
              key: PredictionAdvancedChartPage.bbToggleKey,
              label: 'Bollinger Bands',
              color: AppColors.warn,
              active: showBB,
              onTap: onBB,
            ),
            _LayerButton(
              key: PredictionAdvancedChartPage.volumeToggleKey,
              label: 'Volume',
              color: _predictionBlue,
              active: showVolume,
              onTap: onVolume,
            ),
          ],
        ),
      ],
    );
  }
}

class _LayerButton extends StatelessWidget {
  const _LayerButton({
    super.key,
    required this.label,
    required this.color,
    required this.active,
    required this.onTap,
  });

  final String label;
  final Color color;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: active ? color.withValues(alpha: .08) : AppColors.bg,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 13),
          decoration: BoxDecoration(
            border: Border.all(color: active ? color : AppColors.border),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: active ? color : AppColors.text2,
                    fontWeight: AppTextStyles.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              Icon(
                active
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                size: 14,
                color: active ? color : AppColors.text3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RsiCard extends StatelessWidget {
  const _RsiCard({required this.snapshot});

  final PredictionAdvancedChartSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'RSI (Relative Strength Index)',
                  style: AppTextStyles.caption.copyWith(
                    fontWeight: AppTextStyles.bold,
                    fontSize: 13,
                  ),
                ),
              ),
              Text(
                '${snapshot.currentRsi}',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.warn,
                  fontWeight: AppTextStyles.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 124,
            child: CustomPaint(
              painter: _RsiPainter(points: snapshot.priceHistory),
              child: const SizedBox.expand(),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                Icons.info_outline_rounded,
                size: 12,
                color: AppColors.text3,
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  'RSI > 70: Overbought - RSI < 30: Oversold',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _IndicatorSummarySection extends StatelessWidget {
  const _IndicatorSummarySection({required this.snapshot});

  final PredictionAdvancedChartSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Technical Indicators',
      accentColor: _predictionBlue,
      children: [
        for (final indicator in snapshot.indicators)
          _IndicatorCard(indicator: indicator),
      ],
    );
  }
}

class _IndicatorCard extends StatelessWidget {
  const _IndicatorCard({required this.indicator});

  final PredictionIndicatorSignalDraft indicator;

  @override
  Widget build(BuildContext context) {
    final widthFactor = switch (indicator.strength) {
      'Strong' => .80,
      'Moderate' => .50,
      _ => .25,
    };
    return VitCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      indicator.name,
                      style: AppTextStyles.caption.copyWith(
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      indicator.description,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              _SignalBadge(label: indicator.signal, color: indicator.color),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: AppRadii.xsRadius,
                  child: SizedBox(
                    height: 4,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: FractionallySizedBox(
                        widthFactor: widthFactor,
                        child: ColoredBox(color: indicator.color),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                indicator.strength,
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OverallSignalCard extends StatelessWidget {
  const _OverallSignalCard();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: AppColors.buy20,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Overall Signal',
                  style: AppTextStyles.caption.copyWith(
                    fontWeight: AppTextStyles.bold,
                    fontSize: 13,
                  ),
                ),
              ),
              const Icon(
                Icons.trending_up_rounded,
                color: AppColors.buy,
                size: 18,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'BULLISH',
            style: AppTextStyles.sectionTitle.copyWith(color: AppColors.buy),
          ),
          const SizedBox(height: 4),
          Text(
            '3/4 indicators show buy signal. Momentum is positive.',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text2,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderFlowCard extends StatelessWidget {
  const _OrderFlowCard({required this.snapshot});

  final PredictionAdvancedChartSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Flow (Buy vs Sell Pressure)',
            style: AppTextStyles.caption.copyWith(
              fontWeight: AppTextStyles.bold,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 202,
            child: CustomPaint(
              painter: _OrderFlowPainter(points: snapshot.orderFlow),
              child: const SizedBox.expand(),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: const [
              Expanded(
                child: _LegendItem(label: 'Buy Volume', color: AppColors.buy),
              ),
              Expanded(
                child: _LegendItem(label: 'Sell Volume', color: AppColors.sell),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SupportResistanceSection extends StatelessWidget {
  const _SupportResistanceSection({required this.snapshot});

  final PredictionAdvancedChartSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Support & Resistance',
      accentColor: _predictionBlue,
      children: [
        _LevelCard(
          label: 'Resistance',
          value: snapshot.resistanceLevel,
          helper:
              '${((snapshot.currentProbability - snapshot.resistanceLevel) * 100).toStringAsFixed(1)}% to reach',
          color: AppColors.sell,
        ),
        _LevelCard(
          label: 'Support',
          value: snapshot.supportLevel,
          helper:
              '${((snapshot.currentProbability - snapshot.supportLevel) * 100).toStringAsFixed(1)}% above support',
          color: AppColors.buy,
        ),
      ],
    );
  }
}

class _LevelCard extends StatelessWidget {
  const _LevelCard({
    required this.label,
    required this.value,
    required this.helper,
    required this.color,
  });

  final String label;
  final double value;
  final String helper;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: color.withValues(alpha: .18),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.caption.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '${(value * 100).toStringAsFixed(1)}%',
                  style: AppTextStyles.sectionTitle.copyWith(color: color),
                ),
                const SizedBox(height: 2),
                Text(
                  helper,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          Icon(Icons.track_changes_rounded, color: color, size: 18),
        ],
      ),
    );
  }
}

class _PatternRecognitionCard extends StatelessWidget {
  const _PatternRecognitionCard({required this.snapshot});

  final PredictionAdvancedChartSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pattern Recognition',
            style: AppTextStyles.caption.copyWith(
              fontWeight: AppTextStyles.bold,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 14),
          for (final pattern in snapshot.patterns) ...[
            _PatternRow(pattern: pattern),
            if (pattern != snapshot.patterns.last) const SizedBox(height: 14),
          ],
        ],
      ),
    );
  }
}

class _PatternRow extends StatelessWidget {
  const _PatternRow({required this.pattern});

  final PredictionPatternDraft pattern;

  @override
  Widget build(BuildContext context) {
    final color = pattern.bullish ? AppColors.buy : AppColors.sell;
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    pattern.name,
                    style: AppTextStyles.caption.copyWith(
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(width: 7),
                  Icon(Icons.trending_up_rounded, color: color, size: 12),
                ],
              ),
              const SizedBox(height: 7),
              ClipRRect(
                borderRadius: AppRadii.xsRadius,
                child: SizedBox(
                  height: 4,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: FractionallySizedBox(
                      widthFactor: pattern.confidence / 100,
                      child: ColoredBox(color: color),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Text(
          '${pattern.confidence}%',
          style: AppTextStyles.body.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}

class _AnalysisDisclaimer extends StatelessWidget {
  const _AnalysisDisclaimer();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: AppColors.warn.withValues(alpha: .20),
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.warn,
            size: 14,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Phan tich ky thuat chi mang tinh tham khao. Khong dam bao ket qua tuong lai. Ket hop voi nghien cuu co ban de quyet dinh.',
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text2,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SignalBadge extends StatelessWidget {
  const _SignalBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .15),
        borderRadius: AppRadii.smRadius,
      ),
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text2),
        ),
      ],
    );
  }
}

class _ProbabilityPainter extends CustomPainter {
  const _ProbabilityPainter({
    required this.points,
    required this.support,
    required this.resistance,
    required this.showMA7,
    required this.showMA25,
    required this.showBB,
  });

  final List<PredictionChartPointDraft> points;
  final double support;
  final double resistance;
  final bool showMA7;
  final bool showMA25;
  final bool showBB;

  @override
  void paint(Canvas canvas, Size size) {
    const minValue = .50;
    const maxValue = .75;
    const left = 66.0;
    const top = 6.0;
    const right = 6.0;
    const bottom = 34.0;
    final chart = Rect.fromLTWH(
      left,
      top,
      size.width - left - right,
      size.height - top - bottom,
    );
    final axisPaint = Paint()
      ..color = AppColors.border
      ..strokeWidth = 1;
    canvas.drawLine(chart.bottomLeft, chart.bottomRight, axisPaint);
    canvas.drawLine(chart.bottomLeft, chart.topLeft, axisPaint);

    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    for (final value in [.75, .63, .565, .50]) {
      final y = _scaleY(value, chart, minValue, maxValue);
      textPainter.text = TextSpan(
        text: value == .50
            ? '0.5'
            : value.toStringAsFixed(value == .565 ? 3 : 2),
        style: AppTextStyles.micro.copyWith(
          color: AppColors.text3,
          fontSize: 9,
        ),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(left - textPainter.width - 8, y - 6));
    }
    for (final index in [1, 3, 5, 7, 9]) {
      final x = _scaleX(index, points.length, chart);
      textPainter.text = TextSpan(
        text: points[index].time,
        style: AppTextStyles.micro.copyWith(
          color: AppColors.text3,
          fontSize: 9,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, chart.bottom + 8),
      );
    }

    _drawDashedHorizontal(
      canvas,
      chart,
      _scaleY(resistance, chart, minValue, maxValue),
      AppColors.sell,
    );
    _drawDashedHorizontal(
      canvas,
      chart,
      _scaleY(support, chart, minValue, maxValue),
      AppColors.buy,
    );
    _paintLabel(
      canvas,
      'Resistance',
      Offset(
        chart.left + 124,
        _scaleY(resistance, chart, minValue, maxValue) - 7,
      ),
      AppColors.sell,
    );
    _paintLabel(
      canvas,
      'Support',
      Offset(chart.left + 126, _scaleY(support, chart, minValue, maxValue) - 7),
      AppColors.buy,
    );

    if (showBB) {
      _drawSeries(
        canvas,
        chart,
        points.map((point) => point.bbUpper).toList(),
        minValue,
        maxValue,
        AppColors.warn,
        width: 1,
        dashed: true,
      );
      _drawSeries(
        canvas,
        chart,
        points.map((point) => point.bbLower).toList(),
        minValue,
        maxValue,
        AppColors.warn,
        width: 1,
        dashed: true,
      );
    }
    if (showMA7) {
      _drawSeries(
        canvas,
        chart,
        points.map((point) => point.ma7).toList(),
        minValue,
        maxValue,
        AppColors.buy,
        width: 1.6,
      );
    }
    if (showMA25) {
      _drawSeries(
        canvas,
        chart,
        points.map((point) => point.ma25).toList(),
        minValue,
        maxValue,
        _purple,
        width: 1.6,
      );
    }
    _drawPriceArea(canvas, chart, minValue, maxValue);
  }

  void _drawPriceArea(
    Canvas canvas,
    Rect chart,
    double minValue,
    double maxValue,
  ) {
    final values = points.map((point) => point.price).toList();
    final path = _seriesPath(chart, values, minValue, maxValue);
    final fillPath = Path.from(path)
      ..lineTo(chart.right, chart.bottom)
      ..lineTo(chart.left, chart.bottom)
      ..close();
    final fillPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0x4D3B82F6), Color(0x003B82F6)],
      ).createShader(chart);
    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(
      path,
      Paint()
        ..color = _predictionBlue
        ..strokeWidth = 2.4
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant _ProbabilityPainter oldDelegate) {
    return oldDelegate.points != points ||
        oldDelegate.showMA7 != showMA7 ||
        oldDelegate.showMA25 != showMA25 ||
        oldDelegate.showBB != showBB;
  }
}

class _VolumePainter extends CustomPainter {
  const _VolumePainter({required this.points});

  final List<PredictionChartPointDraft> points;

  @override
  void paint(Canvas canvas, Size size) {
    const left = 66.0;
    const top = 4.0;
    const bottom = 28.0;
    final chart = Rect.fromLTWH(
      left,
      top,
      size.width - left - 6,
      size.height - top - bottom,
    );
    final axisPaint = Paint()
      ..color = AppColors.border
      ..strokeWidth = 1;
    canvas.drawLine(chart.bottomLeft, chart.bottomRight, axisPaint);
    canvas.drawLine(chart.bottomLeft, chart.topLeft, axisPaint);
    final maxVolume = points
        .map((point) => point.volume)
        .reduce(math.max)
        .toDouble();
    final barWidth = chart.width / points.length * .68;
    for (var i = 0; i < points.length; i += 1) {
      final height = chart.height * points[i].volume / maxVolume;
      final x =
          chart.left +
          chart.width * i / points.length +
          (chart.width / points.length - barWidth) / 2;
      final rect = RRect.fromRectAndCorners(
        Rect.fromLTWH(x, chart.bottom - height, barWidth, height),
        topLeft: const Radius.circular(4),
        topRight: const Radius.circular(4),
      );
      canvas.drawRRect(rect, Paint()..color = _predictionBlue);
    }
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    for (final value in [0, 16000, 32000]) {
      final y = chart.bottom - chart.height * value / 32000;
      textPainter.text = TextSpan(
        text: '$value',
        style: AppTextStyles.micro.copyWith(
          color: AppColors.text3,
          fontSize: 9,
        ),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(left - textPainter.width - 8, y - 6));
    }
    for (final index in [1, 3, 5, 7, 9]) {
      final x = chart.left + chart.width * (index + .5) / points.length;
      textPainter.text = TextSpan(
        text: points[index].time,
        style: AppTextStyles.micro.copyWith(
          color: AppColors.text3,
          fontSize: 9,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, chart.bottom + 8),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _VolumePainter oldDelegate) {
    return oldDelegate.points != points;
  }
}

class _RsiPainter extends CustomPainter {
  const _RsiPainter({required this.points});

  final List<PredictionChartPointDraft> points;

  @override
  void paint(Canvas canvas, Size size) {
    final chart = Rect.fromLTWH(38, 4, size.width - 44, size.height - 26);
    final axisPaint = Paint()
      ..color = AppColors.border
      ..strokeWidth = 1;
    canvas.drawLine(chart.bottomLeft, chart.bottomRight, axisPaint);
    canvas.drawLine(chart.bottomLeft, chart.topLeft, axisPaint);
    _drawDashedHorizontal(
      canvas,
      chart,
      chart.bottom - chart.height * .70,
      AppColors.sell,
    );
    _drawDashedHorizontal(
      canvas,
      chart,
      chart.bottom - chart.height * .30,
      AppColors.buy,
    );
    _drawSeries(
      canvas,
      chart,
      points.map((point) => point.rsi / 100).toList(),
      0,
      1,
      _purple,
      width: 2.2,
    );
  }

  @override
  bool shouldRepaint(covariant _RsiPainter oldDelegate) {
    return oldDelegate.points != points;
  }
}

class _OrderFlowPainter extends CustomPainter {
  const _OrderFlowPainter({required this.points});

  final List<PredictionOrderFlowDraft> points;

  @override
  void paint(Canvas canvas, Size size) {
    final chart = Rect.fromLTWH(36, 6, size.width - 42, size.height - 18);
    final maxValue = points
        .map((point) => point.buyVolume + point.sellVolume)
        .reduce(math.max)
        .toDouble();
    final rowHeight = chart.height / points.length;
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    for (var i = 0; i < points.length; i += 1) {
      final point = points[i];
      final y = chart.top + i * rowHeight + 7;
      textPainter.text = TextSpan(
        text: point.price.toStringAsFixed(2),
        style: AppTextStyles.micro.copyWith(
          color: AppColors.text3,
          fontSize: 9,
        ),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(0, y + 5));
      final buyWidth = chart.width * point.buyVolume / maxValue;
      final sellWidth = chart.width * point.sellVolume / maxValue;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(chart.left, y, buyWidth, 11),
          const Radius.circular(4),
        ),
        Paint()..color = AppColors.buy,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(chart.left + buyWidth, y, sellWidth, 11),
          const Radius.circular(4),
        ),
        Paint()..color = AppColors.sell,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _OrderFlowPainter oldDelegate) {
    return oldDelegate.points != points;
  }
}

Path _seriesPath(
  Rect chart,
  List<double> values,
  double minValue,
  double maxValue,
) {
  final path = Path();
  for (var i = 0; i < values.length; i += 1) {
    final x = _scaleX(i, values.length, chart);
    final y = _scaleY(values[i], chart, minValue, maxValue);
    if (i == 0) {
      path.moveTo(x, y);
    } else {
      path.lineTo(x, y);
    }
  }
  return path;
}

void _drawSeries(
  Canvas canvas,
  Rect chart,
  List<double> values,
  double minValue,
  double maxValue,
  Color color, {
  double width = 2,
  bool dashed = false,
}) {
  final path = _seriesPath(chart, values, minValue, maxValue);
  final paint = Paint()
    ..color = color
    ..strokeWidth = width
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round;
  if (!dashed) {
    canvas.drawPath(path, paint);
    return;
  }
  for (var i = 0; i < values.length - 1; i += 1) {
    _drawDashedLine(
      canvas,
      Offset(
        _scaleX(i, values.length, chart),
        _scaleY(values[i], chart, minValue, maxValue),
      ),
      Offset(
        _scaleX(i + 1, values.length, chart),
        _scaleY(values[i + 1], chart, minValue, maxValue),
      ),
      paint,
    );
  }
}

double _scaleX(int index, int count, Rect chart) {
  if (count <= 1) return chart.left;
  return chart.left + chart.width * index / (count - 1);
}

double _scaleY(double value, Rect chart, double minValue, double maxValue) {
  final ratio = ((value - minValue) / (maxValue - minValue)).clamp(0.0, 1.0);
  return chart.bottom - chart.height * ratio;
}

void _drawDashedHorizontal(Canvas canvas, Rect chart, double y, Color color) {
  _drawDashedLine(
    canvas,
    Offset(chart.left, y),
    Offset(chart.right, y),
    Paint()
      ..color = color
      ..strokeWidth = 1,
  );
}

void _drawDashedLine(Canvas canvas, Offset start, Offset end, Paint paint) {
  const dash = 3.0;
  const gap = 3.0;
  final vector = end - start;
  final distance = vector.distance;
  if (distance == 0) return;
  final direction = vector / distance;
  var current = 0.0;
  while (current < distance) {
    final next = math.min(current + dash, distance);
    canvas.drawLine(
      start + direction * current,
      start + direction * next,
      paint,
    );
    current += dash + gap;
  }
}

void _paintLabel(Canvas canvas, String label, Offset offset, Color color) {
  final textPainter = TextPainter(
    text: TextSpan(
      text: label,
      style: AppTextStyles.micro.copyWith(color: color, fontSize: 9),
    ),
    textDirection: TextDirection.ltr,
  )..layout();
  textPainter.paint(canvas, offset);
}
