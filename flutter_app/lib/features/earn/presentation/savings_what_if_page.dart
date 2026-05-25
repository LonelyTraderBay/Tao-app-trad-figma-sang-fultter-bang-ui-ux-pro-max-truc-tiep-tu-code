import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radii.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/device_metrics.dart';
import '../../../shared/layout/shell_render_mode.dart';
import '../../../shared/layout/vit_header.dart';
import '../../../shared/layout/vit_page_content.dart';
import '../../../shared/layout/vit_page_layout.dart';
import '../../../shared/widgets/widgets.dart';
import '../data/earn_repository.dart';

TextStyle get _captionBold =>
    AppTextStyles.caption.copyWith(fontWeight: AppTextStyles.bold);
TextStyle get _microBold =>
    AppTextStyles.micro.copyWith(fontWeight: AppTextStyles.bold);

class SavingsWhatIfPage extends ConsumerStatefulWidget {
  const SavingsWhatIfPage({super.key, this.shellRenderMode});

  static const summaryKey = Key('sc352_summary');
  static const scenariosKey = Key('sc352_scenarios');
  static const portfolioKey = Key('sc352_portfolio');
  static const runKey = Key('sc352_run');
  static const resultsKey = Key('sc352_results');
  static const stressKey = Key('sc352_stress');
  static const assetImpactKey = Key('sc352_asset_impact');
  static const resetKey = Key('sc352_reset');

  static Key scenarioKey(SavingsWhatIfScenarioId id) =>
      Key('sc352_scenario_${id.name}');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<SavingsWhatIfPage> createState() => _SavingsWhatIfPageState();
}

class _SavingsWhatIfPageState extends ConsumerState<SavingsWhatIfPage> {
  String? _tab;
  SavingsWhatIfScenarioId? _selectedScenario;
  double? _customMultiplier;
  double? _customVolatility;
  bool _hasRun = false;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(savingsWhatIfRepositoryProvider).getWhatIf();
    final activeTab = _tab ?? snapshot.defaultTab;
    final selectedId = _selectedScenario ?? snapshot.defaultScenario;
    final scenario = _scenarioById(snapshot, selectedId);
    final multiplier = _customMultiplier ?? snapshot.defaultCustomMultiplier;
    final volatility = _customVolatility ?? snapshot.defaultCustomVolatility;
    final result = _simulateScenario(
      snapshot.portfolio,
      scenario,
      multiplier,
      volatility,
    );
    final totalValue = _totalPortfolioValue(snapshot.portfolio);
    final weightedApy = _weightedApy(snapshot.portfolio);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-352 SavingsWhatIfPage',
      child: Material(
        color: AppColors.bg,
        child: Column(
          children: [
            VitHeader(
              title: snapshot.title,
              showBack: true,
              onBack: () => context.go(snapshot.backRoute),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(bottom: bottomInset),
                child: VitPageContent(
                  padding: VitContentPadding.compact,
                  gap: VitContentGap.defaultGap,
                  children: [
                    _WhatIfHero(
                      snapshot: snapshot,
                      totalValue: totalValue,
                      weightedApy: weightedApy,
                      selectedScenario: scenario,
                      assetCount: snapshot.portfolio.length,
                    ),
                    _WhatIfTabs(
                      tabs: snapshot.tabs,
                      active: activeTab,
                      onChanged: (tab) {
                        HapticFeedback.selectionClick();
                        setState(() => _tab = tab);
                      },
                    ),
                    if (activeTab == 'scenarios')
                      ..._buildScenariosTab(
                        snapshot,
                        scenario,
                        multiplier,
                        volatility,
                      )
                    else if (activeTab == 'results')
                      _ResultsTab(
                        result: result,
                        scenario: scenario,
                        hasRun: _hasRun,
                        onRun: () => _runScenario(snapshot),
                        onReset: _resetScenario,
                      )
                    else
                      _StressTab(snapshot: snapshot),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildScenariosTab(
    SavingsWhatIfSnapshot snapshot,
    SavingsWhatIfScenarioDraft selectedScenario,
    double multiplier,
    double volatility,
  ) {
    return [
      const _SectionTitle(label: 'Chọn kịch bản'),
      _ScenarioList(
        scenarios: snapshot.scenarios,
        selected: selectedScenario.id,
        customMultiplier: multiplier,
        customVolatility: volatility,
        onScenarioChanged: (id) {
          HapticFeedback.selectionClick();
          setState(() => _selectedScenario = id);
        },
        onCustomMultiplierChanged: (value) {
          HapticFeedback.selectionClick();
          setState(() => _customMultiplier = value);
        },
        onCustomVolatilityChanged: (value) {
          HapticFeedback.selectionClick();
          setState(() => _customVolatility = value);
        },
      ),
      const _SectionTitle(label: 'Danh mục hiện tại'),
      _PortfolioList(positions: snapshot.portfolio),
      _Disclaimer(text: snapshot.disclaimer, tone: AppColors.warn),
      VitCtaButton(
        key: SavingsWhatIfPage.runKey,
        onPressed: () => _runScenario(snapshot),
        leading: const Icon(Icons.play_arrow_rounded),
        child: Text('Chạy mô phỏng · ${selectedScenario.label}'),
      ),
    ];
  }

  void _runScenario(SavingsWhatIfSnapshot snapshot) {
    HapticFeedback.mediumImpact();
    setState(() {
      _hasRun = true;
      _tab = 'results';
      _selectedScenario = _selectedScenario ?? snapshot.defaultScenario;
    });
  }

  void _resetScenario() {
    HapticFeedback.selectionClick();
    setState(() {
      _hasRun = false;
      _tab = 'scenarios';
      _selectedScenario = null;
      _customMultiplier = null;
      _customVolatility = null;
    });
  }
}

class _WhatIfHero extends StatelessWidget {
  const _WhatIfHero({
    required this.snapshot,
    required this.totalValue,
    required this.weightedApy,
    required this.selectedScenario,
    required this.assetCount,
  });

  final SavingsWhatIfSnapshot snapshot;
  final double totalValue;
  final double weightedApy;
  final SavingsWhatIfScenarioDraft selectedScenario;
  final int assetCount;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: SavingsWhatIfPage.summaryKey,
      variant: VitCardVariant.hero,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.show_chart_rounded,
                color: AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                snapshot.heroLabel,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.portfolioTextDim,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Text(
            'Danh mục hiện tại',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.portfolioTextMuted,
            ),
          ),
          Text(
            _money(totalValue),
            style: AppTextStyles.sectionTitle.copyWith(
              color: AppColors.text1,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
          const SizedBox(height: AppSpacing.x5),
          Row(
            children: [
              Expanded(
                child: _HeroStat(
                  label: 'APY hiện tại',
                  value: '${weightedApy.toStringAsFixed(1)}%',
                  valueColor: AppColors.buy,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _HeroStat(label: 'Tài sản', value: '$assetCount'),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _HeroStat(
                  label: 'Kịch bản',
                  value: selectedScenario.label,
                  valueColor: _riskColor(selectedScenario.riskLevel),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroStat extends StatelessWidget {
  const _HeroStat({required this.label, required this.value, this.valueColor});

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return VitCardStat(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x4,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.portfolioTextMuted,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: _captionBold.copyWith(
              color: valueColor ?? AppColors.text1,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class _WhatIfTabs extends StatelessWidget {
  const _WhatIfTabs({
    required this.tabs,
    required this.active,
    required this.onChanged,
  });

  final List<SavingsPreferenceTabDraft> tabs;
  final String active;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.sm,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x3),
      child: VitTabBar(
        variant: VitTabBarVariant.underline,
        activeKey: active,
        onChanged: onChanged,
        tabs: [
          for (final tab in tabs) VitTabItem(key: tab.id, label: tab.label),
        ],
      ),
    );
  }
}

class _ScenarioList extends StatelessWidget {
  const _ScenarioList({
    required this.scenarios,
    required this.selected,
    required this.customMultiplier,
    required this.customVolatility,
    required this.onScenarioChanged,
    required this.onCustomMultiplierChanged,
    required this.onCustomVolatilityChanged,
  });

  final List<SavingsWhatIfScenarioDraft> scenarios;
  final SavingsWhatIfScenarioId selected;
  final double customMultiplier;
  final double customVolatility;
  final ValueChanged<SavingsWhatIfScenarioId> onScenarioChanged;
  final ValueChanged<double> onCustomMultiplierChanged;
  final ValueChanged<double> onCustomVolatilityChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: SavingsWhatIfPage.scenariosKey,
      children: [
        for (final scenario in scenarios) ...[
          _ScenarioCard(
            scenario: scenario,
            selected: selected == scenario.id,
            onTap: () => onScenarioChanged(scenario.id),
          ),
          if (scenario != scenarios.last) const SizedBox(height: AppSpacing.x3),
        ],
        if (selected == SavingsWhatIfScenarioId.custom) ...[
          const SizedBox(height: AppSpacing.x3),
          _CustomScenarioControls(
            multiplier: customMultiplier,
            volatility: customVolatility,
            onMultiplierChanged: onCustomMultiplierChanged,
            onVolatilityChanged: onCustomVolatilityChanged,
          ),
        ],
      ],
    );
  }
}

class _ScenarioCard extends StatelessWidget {
  const _ScenarioCard({
    required this.scenario,
    required this.selected,
    required this.onTap,
  });

  final SavingsWhatIfScenarioDraft scenario;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = _riskColor(scenario.riskLevel);
    return VitCard(
      key: SavingsWhatIfPage.scenarioKey(scenario.id),
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      borderColor: selected ? color.withValues(alpha: .45) : null,
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _RoundIcon(color: color, icon: _scenarioIcon(scenario.iconKey)),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: AppSpacing.x2,
                  runSpacing: AppSpacing.x1,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      scenario.label,
                      style: _captionBold.copyWith(color: AppColors.text1),
                    ),
                    _RiskPill(level: scenario.riskLevel),
                  ],
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  scenario.description,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: AppSpacing.x3),
                Wrap(
                  spacing: AppSpacing.x4,
                  runSpacing: AppSpacing.x1,
                  children: [
                    _MicroMetric(
                      label: 'APY',
                      value: _signedPct((scenario.apyMultiplier - 1) * 100),
                    ),
                    _MicroMetric(
                      label: 'Vol',
                      value: '${(scenario.volatility * 100).round()}%',
                    ),
                    _MicroMetric(
                      label: '',
                      value: '${scenario.durationMonths}M',
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Icon(
            selected
                ? Icons.radio_button_checked_rounded
                : Icons.visibility_outlined,
            color: selected ? color : AppColors.text3,
            size: 18,
          ),
        ],
      ),
    );
  }
}

class _CustomScenarioControls extends StatelessWidget {
  const _CustomScenarioControls({
    required this.multiplier,
    required this.volatility,
    required this.onMultiplierChanged,
    required this.onVolatilityChanged,
  });

  final double multiplier;
  final double volatility;
  final ValueChanged<double> onMultiplierChanged;
  final ValueChanged<double> onVolatilityChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        children: [
          _SliderRow(
            label: 'APY multiplier',
            value: multiplier,
            min: .25,
            max: 2.5,
            divisions: 9,
            display: '${multiplier.toStringAsFixed(2)}x',
            onChanged: onMultiplierChanged,
          ),
          const SizedBox(height: AppSpacing.x4),
          _SliderRow(
            label: 'Biến động',
            value: volatility,
            min: .05,
            max: .45,
            divisions: 8,
            display: '${(volatility * 100).round()}%',
            onChanged: onVolatilityChanged,
          ),
        ],
      ),
    );
  }
}

class _SliderRow extends StatelessWidget {
  const _SliderRow({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.display,
    required this.onChanged,
  });

  final String label;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final String display;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: _captionBold.copyWith(color: AppColors.text1),
              ),
            ),
            Text(
              display,
              style: _captionBold.copyWith(color: AppColors.primary),
            ),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: AppColors.primary,
            inactiveTrackColor: AppColors.surface3,
            thumbColor: AppColors.primary,
            overlayColor: AppColors.primary20,
          ),
          child: Slider(
            value: value.clamp(min, max),
            min: min,
            max: max,
            divisions: divisions,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

class _PortfolioList extends StatelessWidget {
  const _PortfolioList({required this.positions});

  final List<SavingsWhatIfPortfolioPositionDraft> positions;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: SavingsWhatIfPage.portfolioKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        children: [
          for (final position in positions) ...[
            _PortfolioRow(position: position),
            if (position != positions.last)
              const Divider(color: AppColors.divider, height: AppSpacing.x5),
          ],
        ],
      ),
    );
  }
}

class _PortfolioRow extends StatelessWidget {
  const _PortfolioRow({required this.position});

  final SavingsWhatIfPortfolioPositionDraft position;

  @override
  Widget build(BuildContext context) {
    final color = _assetColor(position.colorKey);
    return Row(
      children: [
        _AssetBadge(asset: position.asset, color: color),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: Text(
            position.product,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: _captionBold.copyWith(color: AppColors.text1),
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              _money(position.amountUsd),
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
            Text(
              '${position.currentApyPct.toStringAsFixed(1)}%',
              style: _captionBold.copyWith(
                color: AppColors.buy,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ResultsTab extends StatelessWidget {
  const _ResultsTab({
    required this.result,
    required this.scenario,
    required this.hasRun,
    required this.onRun,
    required this.onReset,
  });

  final _ScenarioResult result;
  final SavingsWhatIfScenarioDraft scenario;
  final bool hasRun;
  final VoidCallback onRun;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    if (!hasRun) {
      return _EmptyResults(onRun: onRun);
    }

    final positive = result.difference >= 0;
    final impactColor = positive ? AppColors.buy : AppColors.sell;
    return Column(
      key: SavingsWhatIfPage.resultsKey,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(label: 'Kết quả mô phỏng'),
        VitCard(
          radius: VitCardRadius.lg,
          padding: const EdgeInsets.all(AppSpacing.x4),
          borderColor: impactColor.withValues(alpha: .35),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _RoundIcon(
                    color: impactColor,
                    icon: _scenarioIcon(scenario.iconKey),
                  ),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Kịch bản: ${scenario.label}',
                          style: _captionBold.copyWith(color: AppColors.text1),
                        ),
                        Text(
                          '${scenario.durationMonths} tháng · ${_riskLabel(scenario.riskLevel)}',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text3,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _ImpactBadge(value: result.differencePct),
                ],
              ),
              const SizedBox(height: AppSpacing.x4),
              Row(
                children: [
                  Expanded(
                    child: _MetricTile(
                      label: 'Giá trị cuối',
                      value: _money(result.scenarioValue),
                      color: impactColor,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: _MetricTile(
                      label: 'Chênh lệch',
                      value:
                          '${positive ? '+' : ''}${_money(result.difference)}',
                      color: impactColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.x3),
              Row(
                children: [
                  Expanded(
                    child: _MetricTile(
                      label: 'Lãi baseline',
                      value: _money(result.baselineInterest),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: _MetricTile(
                      label: 'Lãi kịch bản',
                      value: _money(result.scenarioInterest),
                      color: impactColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        _ComparisonChart(result: result),
        const SizedBox(height: AppSpacing.x4),
        const _SectionTitle(label: 'Ảnh hưởng theo tài sản'),
        _AssetImpactList(result: result),
        const SizedBox(height: AppSpacing.x4),
        Row(
          children: [
            Expanded(
              child: VitCtaButton(
                key: SavingsWhatIfPage.resetKey,
                variant: VitCtaButtonVariant.secondary,
                onPressed: onReset,
                leading: const Icon(Icons.restart_alt_rounded),
                child: const Text('Reset'),
              ),
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: VitCtaButton(
                onPressed: onRun,
                leading: const Icon(Icons.play_arrow_rounded),
                child: const Text('Chạy lại'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _EmptyResults extends StatelessWidget {
  const _EmptyResults({required this.onRun});

  final VoidCallback onRun;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        children: [
          const Icon(
            Icons.analytics_outlined,
            color: AppColors.text3,
            size: 44,
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            'Chưa chạy mô phỏng',
            style: _captionBold.copyWith(color: AppColors.text1),
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            'Chọn kịch bản và bấm "Chạy mô phỏng" để xem kết quả.',
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x4),
          VitCtaButton(
            onPressed: onRun,
            leading: const Icon(Icons.play_arrow_rounded),
            child: const Text('Chạy mô phỏng'),
          ),
        ],
      ),
    );
  }
}

class _StressTab extends StatelessWidget {
  const _StressTab({required this.snapshot});

  final SavingsWhatIfSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final results = [
      for (final scenario in snapshot.scenarios)
        if (scenario.id != SavingsWhatIfScenarioId.custom)
          _StressScenarioResult(
            scenario: scenario,
            result: _simulateScenario(
              snapshot.portfolio,
              scenario,
              snapshot.defaultCustomMultiplier,
              snapshot.defaultCustomVolatility,
            ),
          ),
    ]..sort((a, b) => b.result.difference.compareTo(a.result.difference));
    final worst = results.last;
    final best = results.first;
    final average =
        results.fold<double>(
          0,
          (sum, entry) => sum + entry.result.differencePct,
        ) /
        results.length;
    final score = math.max(0, math.min(100, 50 + average * 5)).round();
    final scoreColor = score >= 60
        ? AppColors.buy
        : score >= 40
        ? AppColors.warn
        : AppColors.sell;

    return Column(
      key: SavingsWhatIfPage.stressKey,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        VitCard(
          radius: VitCardRadius.lg,
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.stacked_line_chart_rounded,
                    color: AppColors.primary,
                    size: 18,
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Text(
                    'Stress Test tổng hợp',
                    style: _captionBold.copyWith(color: AppColors.text2),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.x4),
              _StressBars(results: results),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        const _SectionTitle(label: 'Xếp hạng theo ảnh hưởng'),
        for (final entry in results) ...[
          _StressRankCard(entry: entry),
          if (entry != results.last) const SizedBox(height: AppSpacing.x3),
        ],
        const SizedBox(height: AppSpacing.x4),
        VitCard(
          radius: VitCardRadius.lg,
          padding: const EdgeInsets.all(AppSpacing.x4),
          borderColor: scoreColor.withValues(alpha: .35),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.shield_outlined, color: scoreColor, size: 18),
                  const SizedBox(width: AppSpacing.x2),
                  Text(
                    'Đánh giá chống chịu',
                    style: _captionBold.copyWith(color: AppColors.text2),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.x4),
              Row(
                children: [
                  _ScoreRing(score: score, color: scoreColor),
                  const SizedBox(width: AppSpacing.x4),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          score >= 60
                              ? 'Danh mục chống chịu tốt'
                              : score >= 40
                              ? 'Cần cải thiện'
                              : 'Rủi ro cao',
                          style: _captionBold.copyWith(color: AppColors.text1),
                        ),
                        const SizedBox(height: AppSpacing.x1),
                        Text(
                          'Xấu nhất (${worst.scenario.label}): ${worst.result.differencePct.toStringAsFixed(1)}%. Tốt nhất (${best.scenario.label}): +${best.result.differencePct.toStringAsFixed(1)}%.',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text3,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.x4),
              Row(
                children: [
                  Expanded(
                    child: _MetricTile(
                      label: 'TB ảnh hưởng',
                      value:
                          '${average >= 0 ? '+' : ''}${average.toStringAsFixed(1)}%',
                      color: average >= 0 ? AppColors.buy : AppColors.sell,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: _MetricTile(
                      label: 'Xấu nhất',
                      value:
                          '${worst.result.differencePct.toStringAsFixed(1)}%',
                      color: AppColors.sell,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: _MetricTile(
                      label: 'Tốt nhất',
                      value:
                          '+${best.result.differencePct.toStringAsFixed(1)}%',
                      color: AppColors.buy,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        const _InfoCallout(
          icon: Icons.auto_awesome_rounded,
          color: AppColors.primary,
          title: 'Gợi ý tăng kháng chịu',
          text:
              'Đa dạng hóa tài sản và pha trộn sản phẩm linh hoạt với cố định giúp giảm rủi ro trong kịch bản bất lợi. Cân nhắc tăng tỷ trọng stablecoin để đảm bảo ổn định.',
        ),
        const SizedBox(height: AppSpacing.x3),
        _Disclaimer(text: snapshot.stressDisclaimer, tone: AppColors.warn),
      ],
    );
  }
}

class _StressBars extends StatelessWidget {
  const _StressBars({required this.results});

  final List<_StressScenarioResult> results;

  @override
  Widget build(BuildContext context) {
    final maxAbs = results.fold<double>(
      1,
      (maxValue, entry) => math.max(maxValue, entry.result.differencePct.abs()),
    );
    return Column(
      children: [
        for (final entry in results) ...[
          Row(
            children: [
              SizedBox(
                width: 88,
                child: Text(
                  entry.scenario.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: ClipRRect(
                  borderRadius: AppRadii.smRadius,
                  child: LinearProgressIndicator(
                    minHeight: 8,
                    value: entry.result.differencePct.abs() / maxAbs,
                    backgroundColor: AppColors.surface3,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      entry.result.differencePct >= 0
                          ? AppColors.buy
                          : AppColors.sell,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              SizedBox(
                width: 52,
                child: Text(
                  '${entry.result.differencePct >= 0 ? '+' : ''}${entry.result.differencePct.toStringAsFixed(1)}%',
                  textAlign: TextAlign.right,
                  style: _microBold.copyWith(
                    color: entry.result.differencePct >= 0
                        ? AppColors.buy
                        : AppColors.sell,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ),
            ],
          ),
          if (entry != results.last) const SizedBox(height: AppSpacing.x3),
        ],
      ],
    );
  }
}

class _StressRankCard extends StatelessWidget {
  const _StressRankCard({required this.entry});

  final _StressScenarioResult entry;

  @override
  Widget build(BuildContext context) {
    final result = entry.result;
    final color = result.difference >= 0 ? AppColors.buy : AppColors.sell;
    return VitCard(
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      borderColor: color.withValues(alpha: .18),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _RoundIcon(
                color: color,
                icon: _scenarioIcon(entry.scenario.iconKey),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: AppSpacing.x2,
                      runSpacing: AppSpacing.x1,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          entry.scenario.label,
                          style: _captionBold.copyWith(color: AppColors.text1),
                        ),
                        _RiskPill(level: entry.scenario.riskLevel),
                      ],
                    ),
                    Text(
                      entry.scenario.description,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Text(
                '${result.differencePct >= 0 ? '+' : ''}${result.differencePct.toStringAsFixed(1)}%',
                style: _captionBold.copyWith(
                  color: color,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              Expanded(
                child: _MetricTile(
                  label: 'Giá trị cuối',
                  value: _money(result.scenarioValue),
                  color: color,
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: _MetricTile(
                  label: 'Drawdown',
                  value: '${result.maxDrawdown.toStringAsFixed(2)}%',
                  color: result.maxDrawdown > 1
                      ? AppColors.sell
                      : AppColors.warn,
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: _MetricTile(
                  label: 'Hồi phục',
                  value: result.recoveryMonths == 0
                      ? '-'
                      : '${result.recoveryMonths}M',
                  color: result.recoveryMonths == 0
                      ? AppColors.buy
                      : AppColors.warn,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ComparisonChart extends StatelessWidget {
  const _ComparisonChart({required this.result});

  final _ScenarioResult result;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Baseline vs kịch bản',
            style: _captionBold.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: AppSpacing.x4),
          SizedBox(
            height: 150,
            width: double.infinity,
            child: CustomPaint(
              painter: _LineChartPainter(points: result.monthlyData),
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              _LegendDot(color: AppColors.primary, label: 'Baseline'),
              SizedBox(width: AppSpacing.x4),
              _LegendDot(color: AppColors.buy, label: 'Kịch bản'),
            ],
          ),
        ],
      ),
    );
  }
}

class _AssetImpactList extends StatelessWidget {
  const _AssetImpactList({required this.result});

  final _ScenarioResult result;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: SavingsWhatIfPage.assetImpactKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        children: [
          for (final impact in result.assetImpact) ...[
            Row(
              children: [
                _AssetBadge(asset: impact.asset, color: impact.color),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        impact.asset,
                        style: _captionBold.copyWith(color: AppColors.text1),
                      ),
                      Text(
                        'Baseline ${_money(impact.baseInterest)}',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${impact.diff >= 0 ? '+' : ''}${_money(impact.diff)}',
                  style: _captionBold.copyWith(
                    color: impact.diff >= 0 ? AppColors.buy : AppColors.sell,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ],
            ),
            if (impact != result.assetImpact.last)
              const Divider(color: AppColors.divider, height: AppSpacing.x5),
          ],
        ],
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({required this.label, required this.value, this.color});

  final String label;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.sm,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x1),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: _captionBold.copyWith(
                color: color ?? AppColors.text1,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ImpactBadge extends StatelessWidget {
  const _ImpactBadge({required this.value});

  final double value;

  @override
  Widget build(BuildContext context) {
    final positive = value >= 0;
    final color = positive ? AppColors.buy : AppColors.sell;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: AppRadii.smRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x2,
          vertical: AppSpacing.x1,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              positive
                  ? Icons.arrow_upward_rounded
                  : Icons.arrow_downward_rounded,
              color: color,
              size: 13,
            ),
            const SizedBox(width: AppSpacing.x1),
            Text(
              '${positive ? '+' : ''}${value.toStringAsFixed(2)}%',
              style: _microBold.copyWith(
                color: color,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 16,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            borderRadius: AppRadii.xsRadius,
          ),
        ),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: Text(
            label,
            style: _captionBold.copyWith(color: AppColors.text2),
          ),
        ),
      ],
    );
  }
}

class _RiskPill extends StatelessWidget {
  const _RiskPill({required this.level});

  final SavingsWhatIfRiskLevel level;

  @override
  Widget build(BuildContext context) {
    final color = _riskColor(level);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: .14),
        borderRadius: AppRadii.xsRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x2,
          vertical: 2,
        ),
        child: Text(
          _riskLabel(level),
          style: _microBold.copyWith(color: color, height: 1.2),
        ),
      ),
    );
  }
}

class _MicroMetric extends StatelessWidget {
  const _MicroMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Text(
      label.isEmpty ? value : '$label: $value',
      style: AppTextStyles.micro.copyWith(
        color: AppColors.text3,
        fontFeatures: AppTextStyles.tabularFigures,
      ),
    );
  }
}

class _RoundIcon extends StatelessWidget {
  const _RoundIcon({required this.color, required this.icon});

  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color.withValues(alpha: .14),
        borderRadius: AppRadii.lgRadius,
      ),
      child: Icon(icon, color: color, size: 18),
    );
  }
}

class _AssetBadge extends StatelessWidget {
  const _AssetBadge({required this.asset, required this.color});

  final String asset;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 31,
      height: 31,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.withValues(alpha: .14),
        borderRadius: AppRadii.lgRadius,
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          asset,
          style: _microBold.copyWith(color: color, fontSize: 8),
        ),
      ),
    );
  }
}

class _Disclaimer extends StatelessWidget {
  const _Disclaimer({required this.text, required this.tone});

  final String text;
  final Color tone;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x3),
      borderColor: tone.withValues(alpha: .25),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.warning_amber_rounded, color: tone, size: 18),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCallout extends StatelessWidget {
  const _InfoCallout({
    required this.icon,
    required this.color,
    required this.title,
    required this.text,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x3),
      borderColor: color.withValues(alpha: .22),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: _captionBold.copyWith(color: AppColors.text1),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  text,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ScoreRing extends StatelessWidget {
  const _ScoreRing({required this.score, required this.color});

  final int score;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 64,
      height: 64,
      child: CustomPaint(
        painter: _RingPainter(score: score, color: color),
        child: Center(
          child: Text(
            '$score',
            style: AppTextStyles.baseMedium.copyWith(
              color: color,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ),
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 9,
          height: 9,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: AppSpacing.x2),
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
      ],
    );
  }
}

class _LineChartPainter extends CustomPainter {
  const _LineChartPainter({required this.points});

  final List<_MonthlyPoint> points;

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = AppColors.divider
      ..strokeWidth = 1;
    for (var i = 0; i <= 3; i++) {
      final y = size.height * i / 3;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final values = [
      for (final point in points) point.baseline,
      for (final point in points) point.scenario,
    ];
    final minValue = values.reduce(math.min);
    final maxValue = values.reduce(math.max);
    final span = math.max(1, maxValue - minValue);

    Path pathFor(double Function(_MonthlyPoint point) selector) {
      final path = Path();
      for (var i = 0; i < points.length; i++) {
        final x = points.length == 1
            ? 0.0
            : size.width * i / (points.length - 1);
        final value = selector(points[i]);
        final y = size.height - ((value - minValue) / span * size.height);
        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      return path;
    }

    final baselinePaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round;
    final scenarioPaint = Paint()
      ..color = AppColors.buy
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(pathFor((point) => point.baseline), baselinePaint);
    canvas.drawPath(pathFor((point) => point.scenario), scenarioPaint);
  }

  @override
  bool shouldRepaint(covariant _LineChartPainter oldDelegate) =>
      oldDelegate.points != points;
}

class _RingPainter extends CustomPainter {
  const _RingPainter({required this.score, required this.color});

  final int score;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 4;
    final base = Paint()
      ..color = AppColors.surface3
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round;
    final progress = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, base);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      math.pi * 2 * score / 100,
      false,
      progress,
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) =>
      oldDelegate.score != score || oldDelegate.color != color;
}

final class _ScenarioResult {
  const _ScenarioResult({
    required this.scenarioValue,
    required this.baselineValue,
    required this.difference,
    required this.differencePct,
    required this.baselineInterest,
    required this.scenarioInterest,
    required this.maxDrawdown,
    required this.recoveryMonths,
    required this.monthlyData,
    required this.assetImpact,
  });

  final double scenarioValue;
  final double baselineValue;
  final double difference;
  final double differencePct;
  final double baselineInterest;
  final double scenarioInterest;
  final double maxDrawdown;
  final int recoveryMonths;
  final List<_MonthlyPoint> monthlyData;
  final List<_AssetImpact> assetImpact;
}

final class _MonthlyPoint {
  const _MonthlyPoint({required this.baseline, required this.scenario});

  final double baseline;
  final double scenario;
}

final class _AssetImpact {
  const _AssetImpact({
    required this.asset,
    required this.color,
    required this.baseInterest,
    required this.scenarioInterest,
    required this.diff,
  });

  final String asset;
  final Color color;
  final double baseInterest;
  final double scenarioInterest;
  final double diff;
}

final class _StressScenarioResult {
  const _StressScenarioResult({required this.scenario, required this.result});

  final SavingsWhatIfScenarioDraft scenario;
  final _ScenarioResult result;
}

SavingsWhatIfScenarioDraft _scenarioById(
  SavingsWhatIfSnapshot snapshot,
  SavingsWhatIfScenarioId id,
) {
  return snapshot.scenarios.firstWhere((scenario) => scenario.id == id);
}

double _totalPortfolioValue(
  List<SavingsWhatIfPortfolioPositionDraft> positions,
) {
  return positions.fold<double>(0, (sum, position) => sum + position.amountUsd);
}

double _weightedApy(List<SavingsWhatIfPortfolioPositionDraft> positions) {
  final total = _totalPortfolioValue(positions);
  if (total == 0) return 0;
  return positions.fold<double>(
    0,
    (sum, position) =>
        sum + position.currentApyPct * position.amountUsd / total,
  );
}

_ScenarioResult _simulateScenario(
  List<SavingsWhatIfPortfolioPositionDraft> portfolio,
  SavingsWhatIfScenarioDraft scenario,
  double customMultiplier,
  double customVolatility,
) {
  final totalValue = _totalPortfolioValue(portfolio);
  final multiplier = scenario.id == SavingsWhatIfScenarioId.custom
      ? customMultiplier
      : scenario.apyMultiplier;
  final volatility = scenario.id == SavingsWhatIfScenarioId.custom
      ? customVolatility
      : scenario.volatility;
  final months = scenario.durationMonths;
  const baseVariance = [
    .02,
    -.01,
    .03,
    -.02,
    .01,
    -.01,
    .02,
    -.015,
    .025,
    -.01,
    .015,
    -.02,
  ];
  const scenarioVariance = [
    -.05,
    .08,
    -.12,
    .06,
    -.03,
    .1,
    -.08,
    .04,
    -.06,
    .07,
    -.04,
    .05,
  ];

  var baselineValue = totalValue;
  var scenarioValue = totalValue;
  var baselineInterest = 0.0;
  var scenarioInterest = 0.0;
  var maxScenarioValue = totalValue;
  var maxDrawdown = 0.0;
  var recoveryMonths = 0;
  var hasRecovered = true;
  final baselineApy = _weightedApy(portfolio);
  final scenarioApy = baselineApy * multiplier;
  final points = <_MonthlyPoint>[];

  for (var i = 0; i < months; i++) {
    final baseRate = (baselineApy / 100 / 12) * (1 + baseVariance[i % 12]);
    final scenarioRate =
        (scenarioApy / 100 / 12) * (1 + scenarioVariance[i % 12] * volatility);
    final baseInterest = baselineValue * baseRate;
    final scenInterest = scenarioValue * scenarioRate;
    final boundedScenarioInterest = math.max(
      scenInterest,
      -scenarioValue * .02,
    );

    baselineValue += baseInterest;
    scenarioValue += boundedScenarioInterest;
    baselineInterest += baseInterest;
    scenarioInterest += math.max(scenInterest, 0);

    if (scenarioValue > maxScenarioValue) maxScenarioValue = scenarioValue;
    final drawdown =
        ((maxScenarioValue - scenarioValue) / maxScenarioValue) * 100;
    maxDrawdown = math.max(maxDrawdown, drawdown);
    if (scenarioValue < totalValue && hasRecovered) {
      hasRecovered = false;
      recoveryMonths = 0;
    }
    if (!hasRecovered && scenarioValue >= totalValue) {
      hasRecovered = true;
    }
    if (!hasRecovered) recoveryMonths++;

    points.add(
      _MonthlyPoint(
        baseline: _roundMoney(baselineValue),
        scenario: _roundMoney(scenarioValue),
      ),
    );
  }

  final assetImpact = [
    for (final position in portfolio)
      _AssetImpact(
        asset: position.asset,
        color: _assetColor(position.colorKey),
        baseInterest: _roundMoney(
          position.amountUsd * position.currentApyPct / 100 * months / 12,
        ),
        scenarioInterest: _roundMoney(
          math.max(
            position.amountUsd *
                position.currentApyPct *
                multiplier /
                100 *
                months /
                12,
            0,
          ),
        ),
        diff: _roundMoney(
          position.amountUsd *
              position.currentApyPct *
              (multiplier - 1) /
              100 *
              months /
              12,
        ),
      ),
  ];

  return _ScenarioResult(
    scenarioValue: _roundMoney(scenarioValue),
    baselineValue: _roundMoney(baselineValue),
    difference: _roundMoney(scenarioValue - baselineValue),
    differencePct: _roundMoney(
      ((scenarioValue - baselineValue) / baselineValue) * 100,
    ),
    baselineInterest: _roundMoney(baselineInterest),
    scenarioInterest: _roundMoney(scenarioInterest),
    maxDrawdown: _roundMoney(maxDrawdown),
    recoveryMonths: hasRecovered ? 0 : recoveryMonths,
    monthlyData: points,
    assetImpact: assetImpact,
  );
}

double _roundMoney(double value) => (value * 100).roundToDouble() / 100;

String _money(double value) {
  final sign = value < 0 ? '-' : '';
  final dollars = value.abs().round();
  final text = dollars.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < text.length; i++) {
    if (i > 0 && (text.length - i) % 3 == 0) buffer.write(',');
    buffer.write(text[i]);
  }
  return '$sign\$${buffer.toString()}.00';
}

String _signedPct(double value) {
  final rounded = value.round();
  return '${rounded >= 0 ? '+' : ''}$rounded%';
}

IconData _scenarioIcon(String key) {
  return switch (key) {
    'trending_down' => Icons.trending_down_rounded,
    'trending_up' => Icons.trending_up_rounded,
    'snowflake' => Icons.ac_unit_rounded,
    'storm' => Icons.thunderstorm_outlined,
    'flame' => Icons.local_fire_department_outlined,
    'sliders' => Icons.tune_rounded,
    _ => Icons.analytics_outlined,
  };
}

Color _riskColor(SavingsWhatIfRiskLevel level) {
  return switch (level) {
    SavingsWhatIfRiskLevel.low => AppColors.buy,
    SavingsWhatIfRiskLevel.medium => AppColors.warn,
    SavingsWhatIfRiskLevel.high => AppColors.sell,
    SavingsWhatIfRiskLevel.extreme => AppColors.sell,
  };
}

String _riskLabel(SavingsWhatIfRiskLevel level) {
  return switch (level) {
    SavingsWhatIfRiskLevel.low => 'Thấp',
    SavingsWhatIfRiskLevel.medium => 'Trung bình',
    SavingsWhatIfRiskLevel.high => 'Cao',
    SavingsWhatIfRiskLevel.extreme => 'Cực cao',
  };
}

Color _assetColor(String key) {
  return switch (key) {
    'buy' => AppColors.buy,
    'sell' => AppColors.sell,
    'warn' => AppColors.warn,
    'accent' => AppColors.accent,
    'primary' => AppColors.primary,
    _ => AppColors.text2,
  };
}
