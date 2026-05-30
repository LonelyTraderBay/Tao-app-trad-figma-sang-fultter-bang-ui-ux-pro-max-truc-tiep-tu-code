part of 'savings_backtest_page.dart';

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
