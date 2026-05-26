import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
import 'package:vit_trade_flutter/features/earn/data/earn_repository.dart';

TextStyle get _captionBold =>
    AppTextStyles.caption.copyWith(fontWeight: AppTextStyles.bold);
TextStyle get _microBold =>
    AppTextStyles.micro.copyWith(fontWeight: AppTextStyles.bold);

class SavingsBacktestPage extends ConsumerStatefulWidget {
  const SavingsBacktestPage({super.key, this.shellRenderMode});

  static const summaryKey = Key('sc349_summary');
  static const amountFieldKey = Key('sc349_amount_field');
  static const allocationKey = Key('sc349_allocation');
  static const runKey = Key('sc349_run');
  static const resultsKey = Key('sc349_results');
  static const compareKey = Key('sc349_compare');
  static const applyKey = Key('sc349_apply');

  static Key tabKey(String id) => Key('sc349_tab_$id');
  static Key amountKey(int amount) => Key('sc349_amount_$amount');
  static Key periodKey(SavingsBacktestPeriod id) =>
      Key('sc349_period_${id.name}');
  static Key presetKey(SavingsBacktestPreset id) =>
      Key('sc349_preset_${id.name}');
  static Key slotKey(String id) => Key('sc349_slot_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<SavingsBacktestPage> createState() =>
      _SavingsBacktestPageState();
}

class _SavingsBacktestPageState extends ConsumerState<SavingsBacktestPage> {
  String? _tab;
  SavingsBacktestPreset? _preset;
  SavingsBacktestPeriod? _period;
  late final TextEditingController _amountController;
  int _amountUsd = 10000;
  bool _hasRun = false;

  @override
  void initState() {
    super.initState();
    final snapshot = const MockSavingsBacktestRepository().getBacktest();
    _amountUsd = snapshot.defaultAmountUsd;
    _amountController = TextEditingController(text: '$_amountUsd');
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(savingsBacktestRepositoryProvider).getBacktest();
    final activeTab = _tab ?? snapshot.defaultTab;
    final selectedPreset = _preset ?? snapshot.defaultPreset;
    final selectedPeriod = _period ?? snapshot.defaultPeriod;
    final preset = _presetById(snapshot, selectedPreset);
    final period = _periodById(snapshot, selectedPeriod);
    final weightedApy = _weightedApy(preset.slots);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-349 SavingsBacktestPage',
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
                    _BacktestHero(
                      snapshot: snapshot,
                      amountUsd: _amountUsd,
                      preset: preset,
                      period: period,
                      weightedApy: weightedApy,
                      hasRun: _hasRun,
                      result: snapshot.result,
                    ),
                    _BacktestTabs(
                      tabs: snapshot.tabs,
                      active: activeTab,
                      onChanged: (tab) {
                        HapticFeedback.selectionClick();
                        setState(() => _tab = tab);
                      },
                    ),
                    if (activeTab == 'setup')
                      ..._buildSetup(
                        snapshot,
                        preset,
                        selectedPeriod,
                        weightedApy,
                      )
                    else if (activeTab == 'results')
                      if (_hasRun)
                        _ResultsTab(
                          snapshot: snapshot,
                          amountUsd: _amountUsd,
                          period: period,
                          preset: preset,
                          onReset: _reset,
                          onApply: () =>
                              context.go(snapshot.recommendationsRoute),
                        )
                      else
                        _NoResults(
                          onSetup: () => setState(() => _tab = 'setup'),
                        )
                    else
                      _CompareTab(snapshot: snapshot, amountUsd: _amountUsd),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildSetup(
    SavingsBacktestSnapshot snapshot,
    SavingsBacktestPresetDraft preset,
    SavingsBacktestPeriod selectedPeriod,
    double weightedApy,
  ) {
    return [
      _SectionTitle(label: 'Vốn ban đầu (USD)'),
      _AmountField(
        controller: _amountController,
        quickAmounts: snapshot.quickAmounts,
        amountUsd: _amountUsd,
        onAmountChanged: (amount) {
          HapticFeedback.selectionClick();
          setState(() {
            _amountUsd = amount;
            _amountController.text = '$amount';
            _hasRun = false;
          });
        },
      ),
      _SectionTitle(label: 'Thời gian mô phỏng'),
      _PeriodRow(
        periods: snapshot.periods,
        selected: selectedPeriod,
        onChanged: (period) {
          HapticFeedback.selectionClick();
          setState(() {
            _period = period;
            _hasRun = false;
          });
        },
      ),
      _SectionTitle(label: 'Chiến lược phân bổ'),
      _PresetList(
        presets: snapshot.presets,
        selected: preset.id,
        onChanged: (preset) {
          HapticFeedback.selectionClick();
          setState(() {
            _preset = preset;
            _hasRun = false;
          });
        },
      ),
      _SectionTitle(label: 'Phân bổ hiện tại'),
      _AllocationCard(
        preset: preset,
        weightedApy: weightedApy,
        amountUsd: _amountUsd,
      ),
      _Disclaimer(text: snapshot.disclaimer),
      VitCtaButton(
        key: SavingsBacktestPage.runKey,
        onPressed: () {
          HapticFeedback.mediumImpact();
          setState(() {
            _hasRun = true;
            _tab = 'results';
          });
        },
        leading: const Icon(Icons.play_arrow_rounded),
        child: const Text('Chạy mô phỏng'),
      ),
    ];
  }

  void _reset() {
    HapticFeedback.selectionClick();
    setState(() {
      _hasRun = false;
      _tab = 'setup';
    });
  }
}

class _BacktestHero extends StatelessWidget {
  const _BacktestHero({
    required this.snapshot,
    required this.amountUsd,
    required this.preset,
    required this.period,
    required this.weightedApy,
    required this.hasRun,
    required this.result,
  });

  final SavingsBacktestSnapshot snapshot;
  final int amountUsd;
  final SavingsBacktestPresetDraft preset;
  final SavingsBacktestPeriodDraft period;
  final double weightedApy;
  final bool hasRun;
  final SavingsBacktestResultDraft result;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: SavingsBacktestPage.summaryKey,
      variant: VitCardVariant.hero,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.show_chart_rounded,
                color: AppColors.accent,
                size: AppSpacing.iconMd,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  snapshot.heroLabel,
                  style: AppTextStyles.base.copyWith(color: AppColors.text2),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Vốn ban đầu',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                    Text(
                      _usd(amountUsd),
                      style: AppTextStyles.sectionTitle.copyWith(
                        color: AppColors.text1,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ],
                ),
              ),
              if (hasRun)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Giá trị cuối kỳ',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                    Text(
                      _usd(result.finalValueUsd),
                      style: AppTextStyles.sectionTitle.copyWith(
                        color: AppColors.buy,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.x5),
          Row(
            children: [
              Expanded(
                child: _HeroMetric(label: 'Chiến lược', value: preset.label),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _HeroMetric(
                  label: 'APY TB',
                  value: '${weightedApy.toStringAsFixed(1)}%',
                  valueColor: AppColors.buy,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _HeroMetric(label: 'Thời gian', value: period.label),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroMetric extends StatelessWidget {
  const _HeroMetric({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return VitCardStat(
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: _captionBold.copyWith(color: valueColor),
          ),
        ],
      ),
    );
  }
}

class _BacktestTabs extends StatelessWidget {
  const _BacktestTabs({
    required this.tabs,
    required this.active,
    required this.onChanged,
  });

  final List<SavingsPreferenceTabDraft> tabs;
  final String active;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitTabBar(
      variant: VitTabBarVariant.segment,
      activeKey: active,
      onChanged: onChanged,
      tabs: [
        for (final tab in tabs)
          VitTabItem(
            key: tab.id,
            label: tab.label,
            icon: switch (tab.id) {
              'setup' => Icons.tune_rounded,
              'results' => Icons.query_stats_rounded,
              _ => Icons.compare_arrows_rounded,
            },
          ),
      ],
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
          width: 3,
          height: 15,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            borderRadius: AppRadii.xsRadius,
          ),
        ),
        const SizedBox(width: AppSpacing.x2),
        Text(label, style: _captionBold.copyWith(color: AppColors.text2)),
      ],
    );
  }
}

class _AmountField extends StatelessWidget {
  const _AmountField({
    required this.controller,
    required this.quickAmounts,
    required this.amountUsd,
    required this.onAmountChanged,
  });

  final TextEditingController controller;
  final List<int> quickAmounts;
  final int amountUsd;
  final ValueChanged<int> onAmountChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        VitCard(
          variant: VitCardVariant.inner,
          radius: VitCardRadius.md,
          borderColor: AppColors.primary30,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x4),
          child: SizedBox(
            height: AppSpacing.inputHeight,
            child: Row(
              children: [
                const Icon(
                  Icons.attach_money_rounded,
                  color: AppColors.primary,
                  size: AppSpacing.iconMd,
                ),
                Expanded(
                  child: TextField(
                    key: SavingsBacktestPage.amountFieldKey,
                    controller: controller,
                    keyboardType: TextInputType.number,
                    style: AppTextStyles.base.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.x3,
                      ),
                    ),
                    onChanged: (value) {
                      final parsed = int.tryParse(value);
                      if (parsed != null && parsed >= 100) {
                        onAmountChanged(parsed);
                      }
                    },
                  ),
                ),
                Text(
                  'USD',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.x3),
        Row(
          children: [
            for (final amount in quickAmounts) ...[
              Expanded(
                child: _CompactChip(
                  key: SavingsBacktestPage.amountKey(amount),
                  label: _compactAmount(amount),
                  selected: amountUsd == amount,
                  onTap: () => onAmountChanged(amount),
                ),
              ),
              if (amount != quickAmounts.last)
                const SizedBox(width: AppSpacing.x2),
            ],
          ],
        ),
      ],
    );
  }
}

class _PeriodRow extends StatelessWidget {
  const _PeriodRow({
    required this.periods,
    required this.selected,
    required this.onChanged,
  });

  final List<SavingsBacktestPeriodDraft> periods;
  final SavingsBacktestPeriod selected;
  final ValueChanged<SavingsBacktestPeriod> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final period in periods) ...[
          Expanded(
            child: _CompactChip(
              key: SavingsBacktestPage.periodKey(period.id),
              label: period.label,
              selected: period.id == selected,
              onTap: () => onChanged(period.id),
            ),
          ),
          if (period != periods.last) const SizedBox(width: AppSpacing.x2),
        ],
      ],
    );
  }
}

class _CompactChip extends StatelessWidget {
  const _CompactChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: AppRadii.inputRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.inputRadius,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.x2),
          decoration: BoxDecoration(
            color: selected ? AppColors.primary12 : Colors.transparent,
            border: Border.all(
              color: selected ? AppColors.primary30 : AppColors.cardBorder,
            ),
            borderRadius: AppRadii.inputRadius,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: _captionBold.copyWith(
              color: selected ? AppColors.primary : AppColors.text2,
            ),
          ),
        ),
      ),
    );
  }
}

class _PresetList extends StatelessWidget {
  const _PresetList({
    required this.presets,
    required this.selected,
    required this.onChanged,
  });

  final List<SavingsBacktestPresetDraft> presets;
  final SavingsBacktestPreset selected;
  final ValueChanged<SavingsBacktestPreset> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final preset in presets) ...[
          _PresetCard(
            preset: preset,
            selected: preset.id == selected,
            onTap: () => onChanged(preset.id),
          ),
          if (preset != presets.last) const SizedBox(height: AppSpacing.x3),
        ],
      ],
    );
  }
}

class _PresetCard extends StatelessWidget {
  const _PresetCard({
    required this.preset,
    required this.selected,
    required this.onTap,
  });

  final SavingsBacktestPresetDraft preset;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = _presetColor(preset.id);
    return VitCard(
      key: SavingsBacktestPage.presetKey(preset.id),
      variant: selected ? VitCardVariant.inner : VitCardVariant.standard,
      radius: VitCardRadius.lg,
      borderColor: selected ? color : AppColors.cardBorder,
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        children: [
          _RoundIcon(icon: _iconFor(preset.iconKey), color: color),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: AppSpacing.x2,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      preset.label,
                      style: _captionBold.copyWith(color: AppColors.text1),
                    ),
                    _StatusPill(label: preset.riskLabel, color: color),
                  ],
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  preset.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  '${preset.slots.length} sản phẩm · APY TB: ${_weightedApy(preset.slots).toStringAsFixed(1)}%',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          _SelectionDot(selected: selected, color: color),
        ],
      ),
    );
  }
}

class _AllocationCard extends StatelessWidget {
  const _AllocationCard({
    required this.preset,
    required this.weightedApy,
    required this.amountUsd,
  });

  final SavingsBacktestPresetDraft preset;
  final double weightedApy;
  final int amountUsd;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: SavingsBacktestPage.allocationKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        children: [
          Row(
            children: [
              CustomPaint(
                size: const Size(86, 86),
                painter: _AllocationRingPainter(slots: preset.slots),
                child: SizedBox(
                  width: 86,
                  height: 86,
                  child: Center(
                    child: Text(
                      '${preset.slots.length}',
                      style: _captionBold.copyWith(color: AppColors.text1),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: Column(
                  children: [
                    for (final slot in preset.slots) _AllocationRow(slot: slot),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              Expanded(
                child: _SummaryTile(
                  label: 'APY TB',
                  value: '${weightedApy.toStringAsFixed(1)}%',
                  color: AppColors.buy,
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: _SummaryTile(
                  label: 'Sản phẩm',
                  value: '${preset.slots.length}',
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: _SummaryTile(
                  label: 'Dự kiến lãi/năm',
                  value: _usd(amountUsd * weightedApy / 100),
                  color: AppColors.buy,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AllocationRow extends StatelessWidget {
  const _AllocationRow({required this.slot});

  final SavingsBacktestSlotDraft slot;

  @override
  Widget build(BuildContext context) {
    final color = _slotColor(slot.colorKey);
    return Padding(
      key: SavingsBacktestPage.slotKey(slot.id),
      padding: const EdgeInsets.only(bottom: AppSpacing.x1),
      child: Row(
        children: [
          Container(
            width: 9,
            height: 9,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              slot.product,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: _microBold.copyWith(color: AppColors.text1),
            ),
          ),
          const SizedBox(width: AppSpacing.x2),
          Text(
            '${slot.percentage}%',
            style: AppTextStyles.micro.copyWith(color: AppColors.text2),
          ),
          const SizedBox(width: AppSpacing.x2),
          Text(
            '${slot.avgApy.toStringAsFixed(1)}%',
            style: AppTextStyles.micro.copyWith(color: AppColors.buy),
          ),
        ],
      ),
    );
  }
}

class _ResultsTab extends StatelessWidget {
  const _ResultsTab({
    required this.snapshot,
    required this.amountUsd,
    required this.period,
    required this.preset,
    required this.onReset,
    required this.onApply,
  });

  final SavingsBacktestSnapshot snapshot;
  final int amountUsd;
  final SavingsBacktestPeriodDraft period;
  final SavingsBacktestPresetDraft preset;
  final VoidCallback onReset;
  final VoidCallback onApply;

  @override
  Widget build(BuildContext context) {
    final result = snapshot.result;
    return Column(
      key: SavingsBacktestPage.resultsKey,
      children: [
        VitCard(
          radius: VitCardRadius.lg,
          borderColor: AppColors.buy20,
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.trending_up_rounded,
                    color: AppColors.buy,
                    size: AppSpacing.iconMd,
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Text(
                    'Hiệu suất tổng quan',
                    style: _captionBold.copyWith(color: AppColors.text2),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.x3),
              Row(
                children: [
                  Expanded(
                    child: _ResultTile(
                      label: 'Tổng lãi',
                      value: '+${_usd(result.totalReturnUsd)}',
                      caption: '+${result.totalReturnPct.toStringAsFixed(2)}%',
                      color: AppColors.buy,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: _ResultTile(
                      label: 'Giá trị cuối kỳ',
                      value: _usd(result.finalValueUsd),
                      caption: period.label,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.x3),
              Row(
                children: [
                  Expanded(
                    child: _SummaryTile(
                      label: 'APY hiệu quả',
                      value:
                          '${result.annualizedReturnPct.toStringAsFixed(2)}%',
                      color: AppColors.buy,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Expanded(
                    child: _SummaryTile(
                      label: 'Max Drawdown',
                      value: '${result.maxDrawdownPct.toStringAsFixed(2)}%',
                      color: AppColors.warn,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Expanded(
                    child: _SummaryTile(
                      label: 'Sharpe',
                      value: result.sharpeRatio.toStringAsFixed(2),
                      color: AppColors.buy,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.x3),
        _GrowthChart(points: result.points, initialAmount: amountUsd),
        const SizedBox(height: AppSpacing.x3),
        Row(
          children: [
            Expanded(
              child: _ResultTile(
                label: 'Tháng dương',
                value: '${result.monthsPositive}',
                caption: 'Tốt nhất +${_usd(result.bestMonthUsd)}',
                color: AppColors.buy,
              ),
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: _ResultTile(
                label: 'Tháng âm',
                value: '${result.monthsNegative}',
                caption: 'Tệ nhất ${_usd(result.worstMonthUsd)}',
                color: result.monthsNegative > 0
                    ? AppColors.sell
                    : AppColors.text1,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x3),
        Row(
          children: [
            Expanded(
              child: VitCtaButton(
                variant: VitCtaButtonVariant.secondary,
                onPressed: onReset,
                leading: const Icon(Icons.refresh_rounded),
                child: const Text('Chạy lại'),
              ),
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: VitCtaButton(
                key: SavingsBacktestPage.applyKey,
                onPressed: onApply,
                leading: const Icon(Icons.auto_awesome_rounded),
                child: const Text('Áp dụng'),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x3),
        _Disclaimer(text: snapshot.disclaimer),
      ],
    );
  }
}

class _CompareTab extends StatelessWidget {
  const _CompareTab({required this.snapshot, required this.amountUsd});

  final SavingsBacktestSnapshot snapshot;
  final int amountUsd;

  @override
  Widget build(BuildContext context) {
    final presets = snapshot.presets
        .where((preset) => preset.id != SavingsBacktestPreset.custom)
        .toList();
    return Column(
      key: SavingsBacktestPage.compareKey,
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
                    Icons.bar_chart_rounded,
                    color: AppColors.primary,
                    size: AppSpacing.iconMd,
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Text(
                    'So sánh tăng trưởng',
                    style: _captionBold.copyWith(color: AppColors.text2),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.x4),
              for (final preset in presets) ...[
                _CompareBar(preset: preset, amountUsd: amountUsd),
                if (preset != presets.last)
                  const SizedBox(height: AppSpacing.x3),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.x3),
        for (final preset in presets) ...[
          _CompareCard(preset: preset, amountUsd: amountUsd),
          if (preset != presets.last) const SizedBox(height: AppSpacing.x3),
        ],
      ],
    );
  }
}

class _CompareBar extends StatelessWidget {
  const _CompareBar({required this.preset, required this.amountUsd});

  final SavingsBacktestPresetDraft preset;
  final int amountUsd;

  @override
  Widget build(BuildContext context) {
    final apy = _weightedApy(preset.slots);
    final projected = amountUsd * apy / 100;
    final pct = (apy / 7.5).clamp(0.0, 1.0);
    final color = _presetColor(preset.id);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                preset.label,
                style: _captionBold.copyWith(color: AppColors.text1),
              ),
            ),
            Text(
              '+${_usd(projected)}',
              style: _captionBold.copyWith(color: AppColors.buy),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x2),
        ClipRRect(
          borderRadius: AppRadii.xsRadius,
          child: LinearProgressIndicator(
            value: pct,
            minHeight: 7,
            color: color,
            backgroundColor: AppColors.surface3,
          ),
        ),
      ],
    );
  }
}

class _CompareCard extends StatelessWidget {
  const _CompareCard({required this.preset, required this.amountUsd});

  final SavingsBacktestPresetDraft preset;
  final int amountUsd;

  @override
  Widget build(BuildContext context) {
    final apy = _weightedApy(preset.slots);
    final projected = amountUsd * apy / 100;
    final color = _presetColor(preset.id);
    return VitCard(
      radius: VitCardRadius.lg,
      borderColor: preset.id == SavingsBacktestPreset.aggressive
          ? AppColors.buy20
          : AppColors.cardBorder,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        children: [
          _RoundIcon(icon: _iconFor(preset.iconKey), color: color),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: AppSpacing.x2,
                  children: [
                    Text(
                      preset.label,
                      style: _captionBold.copyWith(color: AppColors.text1),
                    ),
                    _StatusPill(label: preset.riskLabel, color: color),
                  ],
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  'APY hiệu quả ${apy.toStringAsFixed(1)}% · ${preset.slots.length} sản phẩm',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          Text(
            '+${(projected / amountUsd * 100).toStringAsFixed(2)}%',
            style: AppTextStyles.base.copyWith(
              color: AppColors.buy,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _NoResults extends StatelessWidget {
  const _NoResults({required this.onSetup});

  final VoidCallback onSetup;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x6),
      child: Column(
        children: [
          const Icon(
            Icons.play_circle_outline_rounded,
            color: AppColors.text3,
            size: AppSpacing.iconLg,
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            'Chưa chạy mô phỏng',
            style: _captionBold.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            'Thiết lập chiến lược và bấm "Chạy mô phỏng" để xem kết quả.',
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x4),
          VitCtaButton(
            onPressed: onSetup,
            fullWidth: false,
            child: const Text('Thiết lập'),
          ),
        ],
      ),
    );
  }
}

class _GrowthChart extends StatelessWidget {
  const _GrowthChart({required this.points, required this.initialAmount});

  final List<SavingsBacktestPointDraft> points;
  final int initialAmount;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.query_stats_rounded,
                color: AppColors.primary,
                size: AppSpacing.iconMd,
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                'Tăng trưởng tài sản',
                style: _captionBold.copyWith(color: AppColors.text2),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          SizedBox(
            height: 150,
            child: CustomPaint(
              painter: _GrowthPainter(
                points: points,
                initialAmount: initialAmount.toDouble(),
              ),
              child: const SizedBox.expand(),
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultTile extends StatelessWidget {
  const _ResultTile({
    required this.label,
    required this.value,
    required this.caption,
    this.color = AppColors.text1,
  });

  final String label;
  final String value;
  final String caption;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.md,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.sectionTitle.copyWith(color: color),
          ),
          Text(caption, style: AppTextStyles.micro.copyWith(color: color)),
        ],
      ),
    );
  }
}

class _SummaryTile extends StatelessWidget {
  const _SummaryTile({
    required this.label,
    required this.value,
    this.color = AppColors.text1,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.md,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: _captionBold.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}

class _Disclaimer extends StatelessWidget {
  const _Disclaimer({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.warningBg,
        border: Border.all(color: AppColors.warningBorder),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: AppColors.warn,
              size: AppSpacing.iconMd,
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: Text(
                text,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  height: 1.35,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoundIcon extends StatelessWidget {
  const _RoundIcon({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: AppRadii.mdRadius,
      ),
      child: SizedBox(
        width: AppSpacing.x7,
        height: AppSpacing.x7,
        child: Icon(icon, color: color, size: AppSpacing.iconMd),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: AppRadii.xsRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x2,
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

class _SelectionDot extends StatelessWidget {
  const _SelectionDot({required this.selected, required this.color});

  final bool selected;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: selected ? color : AppColors.borderSolid),
      ),
      child: selected
          ? Center(
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
            )
          : null,
    );
  }
}

class _AllocationRingPainter extends CustomPainter {
  const _AllocationRingPainter({required this.slots});

  final List<SavingsBacktestSlotDraft> slots;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    const stroke = 16.0;
    var start = -math.pi / 2;
    for (final slot in slots) {
      final sweep = math.pi * 2 * slot.percentage / 100;
      final paint = Paint()
        ..color = _slotColor(slot.colorKey)
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.butt;
      canvas.drawArc(rect.deflate(stroke / 2), start, sweep, false, paint);
      start += sweep;
    }
    final inner = Paint()..color = AppColors.surface;
    canvas.drawCircle(size.center(Offset.zero), size.width * 0.25, inner);
  }

  @override
  bool shouldRepaint(covariant _AllocationRingPainter oldDelegate) {
    return oldDelegate.slots != slots;
  }
}

class _GrowthPainter extends CustomPainter {
  const _GrowthPainter({required this.points, required this.initialAmount});

  final List<SavingsBacktestPointDraft> points;
  final double initialAmount;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;
    final minValue = points.map((p) => p.valueUsd).reduce(math.min);
    final maxValue = points.map((p) => p.valueUsd).reduce(math.max);
    final range = math.max(1, maxValue - minValue);
    final chartRect = Rect.fromLTWH(0, 0, size.width, size.height);
    final gridPaint = Paint()
      ..color = AppColors.divider
      ..strokeWidth = 1;
    for (var i = 0; i < 4; i++) {
      final y = chartRect.top + chartRect.height * i / 3;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final baselineY =
        chartRect.bottom -
        ((initialAmount - minValue) / range) * chartRect.height;
    final baselinePaint = Paint()
      ..color = AppColors.warn
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    canvas.drawLine(
      Offset(0, baselineY.clamp(0, size.height)),
      Offset(size.width, baselineY.clamp(0, size.height)),
      baselinePaint,
    );

    final path = Path();
    for (var i = 0; i < points.length; i++) {
      final x = chartRect.left + chartRect.width * i / (points.length - 1);
      final y =
          chartRect.bottom -
          ((points[i].valueUsd - minValue) / range) * chartRect.height;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    final fill = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(fill, Paint()..color = AppColors.buy10);
    canvas.drawPath(
      path,
      Paint()
        ..color = AppColors.buy
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(covariant _GrowthPainter oldDelegate) {
    return oldDelegate.points != points ||
        oldDelegate.initialAmount != initialAmount;
  }
}

SavingsBacktestPresetDraft _presetById(
  SavingsBacktestSnapshot snapshot,
  SavingsBacktestPreset id,
) {
  return snapshot.presets.firstWhere(
    (preset) => preset.id == id,
    orElse: () => snapshot.presets.first,
  );
}

SavingsBacktestPeriodDraft _periodById(
  SavingsBacktestSnapshot snapshot,
  SavingsBacktestPeriod id,
) {
  return snapshot.periods.firstWhere(
    (period) => period.id == id,
    orElse: () => snapshot.periods.first,
  );
}

double _weightedApy(List<SavingsBacktestSlotDraft> slots) {
  return slots.fold<double>(
    0,
    (total, slot) => total + (slot.avgApy * slot.percentage / 100),
  );
}

IconData _iconFor(String iconKey) {
  return switch (iconKey) {
    'shield' => Icons.shield_outlined,
    'target' => Icons.center_focus_strong_rounded,
    'bolt' => Icons.bolt_outlined,
    'sliders' => Icons.tune_rounded,
    _ => Icons.savings_outlined,
  };
}

Color _presetColor(SavingsBacktestPreset preset) {
  return switch (preset) {
    SavingsBacktestPreset.conservative => AppColors.buy,
    SavingsBacktestPreset.balanced => AppColors.primary,
    SavingsBacktestPreset.aggressive => AppColors.warn,
    SavingsBacktestPreset.custom => AppColors.accent,
  };
}

Color _slotColor(String colorKey) {
  return switch (colorKey) {
    'buy' => AppColors.buy,
    'primary' => AppColors.primary,
    'warn' => AppColors.warn,
    'accent' => AppColors.accent,
    'sell' => AppColors.sell,
    _ => AppColors.text3,
  };
}

String _usd(num value) {
  final fixed = value.toStringAsFixed(2);
  final parts = fixed.split('.');
  final whole = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    if (i > 0 && (whole.length - i) % 3 == 0) buffer.write(',');
    buffer.write(whole[i]);
  }
  return '\$$buffer.${parts.last}';
}

String _compactAmount(int value) {
  if (value >= 1000) return '${value ~/ 1000}K';
  return '$value';
}
