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
      color: AppColors.transparent,
      borderRadius: AppRadii.inputRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.inputRadius,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.x2),
          decoration: BoxDecoration(
            color: selected ? AppColors.primary12 : AppColors.transparent,
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
