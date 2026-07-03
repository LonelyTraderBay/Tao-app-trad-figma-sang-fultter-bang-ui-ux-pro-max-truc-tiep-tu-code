part of 'savings_backtest_page.dart';


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
      radius: VitCardRadius.large,
      padding: AppSpacing.earnPaddingX5,
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
      padding: AppSpacing.earnPaddingX3,
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
        DecoratedBox(
          decoration: const ShapeDecoration(
            color: AppColors.primary,
            shape: RoundedRectangleBorder(borderRadius: AppRadii.xsRadius),
          ),
          child: const SizedBox(
            width: AppSpacing.savingsBacktestSectionMarkerWidth,
            height: AppSpacing.savingsBacktestSectionMarkerHeight,
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
        VitInput(
          fieldKey: SavingsBacktestPage.amountFieldKey,
          controller: controller,
          keyboardType: TextInputType.number,
          semanticLabel: 'Savings backtest amount',
          prefix: const Icon(Icons.attach_money_rounded),
          suffix: Text(
            'USD',
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
          textStyle: AppTextStyles.base.copyWith(
            color: AppColors.text1,
            fontWeight: AppTextStyles.bold,
          ),
          onChanged: (value) {
            final parsed = int.tryParse(value);
            if (parsed != null && parsed >= 100) {
              onAmountChanged(parsed);
            }
          },
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
    return VitChoicePill(
      label: label,
      selected: selected,
      onTap: onTap,
      fullWidth: true,
      height: AppSpacing.buttonCompact,
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
      radius: VitCardRadius.large,
      borderColor: selected ? color : AppColors.cardBorder,
      onTap: onTap,
      padding: AppSpacing.earnPaddingX4,
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
      radius: VitCardRadius.large,
      padding: AppSpacing.earnPaddingX4,
      child: Column(
        children: [
          Row(
            children: [
              CustomPaint(
                size: const Size.square(
                  AppSpacing.savingsBacktestAllocationRing,
                ),
                painter: _AllocationRingPainter(slots: preset.slots),
                child: SizedBox(
                  width: AppSpacing.savingsBacktestAllocationRing,
                  height: AppSpacing.savingsBacktestAllocationRing,
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
      padding: AppSpacing.earnBottomPaddingX1,
      child: Row(
        children: [
          DecoratedBox(
            decoration: ShapeDecoration(
              color: color,
              shape: const CircleBorder(),
            ),
            child: const SizedBox(
              width: AppSpacing.savingsBacktestLegendDot,
              height: AppSpacing.savingsBacktestLegendDot,
            ),
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
          radius: VitCardRadius.large,
          borderColor: AppColors.buy20,
          padding: AppSpacing.earnPaddingX4,
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
        EarnWarningBanner(
          text: snapshot.disclaimer,
          lineHeight: AppSpacing.savingsBacktestWarningLineHeight,
        ),
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
          radius: VitCardRadius.large,
          padding: AppSpacing.earnPaddingX4,
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
            minHeight: AppSpacing.savingsBacktestProgressHeight,
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
      radius: VitCardRadius.large,
      borderColor: preset.id == SavingsBacktestPreset.aggressive
          ? AppColors.buy20
          : AppColors.cardBorder,
      padding: AppSpacing.earnPaddingX4,
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
      radius: VitCardRadius.large,
      padding: AppSpacing.earnPaddingX6,
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
      radius: VitCardRadius.large,
      padding: AppSpacing.earnPaddingX4,
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
            height: AppSpacing.savingsBacktestGrowthChartHeight,
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
      radius: VitCardRadius.standard,
      padding: AppSpacing.earnPaddingX3,
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
      radius: VitCardRadius.standard,
      padding: AppSpacing.earnPaddingX3,
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


class _RoundIcon extends StatelessWidget {
  const _RoundIcon({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: color.withValues(alpha: 0.14),
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.mdRadius),
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
      decoration: ShapeDecoration(
        color: color.withValues(alpha: 0.14),
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.xsRadius),
      ),
      child: Padding(
        padding: AppSpacing.earnSmallPillPadding,
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
    return SizedBox(
      width: AppSpacing.savingsBacktestSelectionDot,
      height: AppSpacing.savingsBacktestSelectionDot,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          shape: CircleBorder(
            side: BorderSide(color: selected ? color : AppColors.borderSolid),
          ),
        ),
        child: selected
            ? Center(
                child: DecoratedBox(
                  decoration: ShapeDecoration(
                    color: color,
                    shape: const CircleBorder(),
                  ),
                  child: const SizedBox(
                    width: AppSpacing.savingsBacktestSelectionDotInner,
                    height: AppSpacing.savingsBacktestSelectionDotInner,
                  ),
                ),
              )
            : null,
      ),
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

