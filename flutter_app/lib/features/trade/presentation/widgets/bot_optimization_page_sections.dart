part of '../pages/bot_optimization_page.dart';

class _IntroCard extends StatelessWidget {
  const _IntroCard();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.ghost,
      padding: AppSpacing.tradeBotCardPadding,
      borderColor: _optimizationPrimary.withValues(alpha: .22),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.bolt_outlined,
            color: _optimizationPrimary,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Automated Parameter Tuning',
                  style: AppTextStyles.baseMedium.copyWith(
                    color: AppColors.text1,
                  ),
                ),
                const SizedBox(height: AppSpacing.x3),
                Text(
                  'Use genetic algorithms to find optimal bot parameters that maximize Sharpe ratio while minimizing drawdown. This typically takes 2-5 minutes.',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TargetCard extends StatelessWidget {
  const _TargetCard({
    required this.targets,
    required this.selectedId,
    required this.onChanged,
  });

  final List<TradeBotOptimizationTarget> targets;
  final String selectedId;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: AppSpacing.tradeBotCompactCardPadding,
      borderColor: AppColors.cardBorder,
      child: Column(
        children: [
          for (final target in targets) ...[
            _TargetTile(
              key: BotOptimizationPage.targetKey(target.id),
              target: target,
              selected: target.id == selectedId,
              onTap: () => onChanged(target.id),
            ),
            if (target != targets.last) const SizedBox(height: AppSpacing.x2),
          ],
        ],
      ),
    );
  }
}

class _TargetTile extends StatelessWidget {
  const _TargetTile({
    super.key,
    required this.target,
    required this.selected,
    required this.onTap,
  });

  final TradeBotOptimizationTarget target;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.cardRadius,
      child: VitCard(
        variant: VitCardVariant.inner,
        constraints: const BoxConstraints(minHeight: AppSpacing.buttonStandard),
        padding: AppSpacing.tradeBotChipPadding,
        borderColor: selected ? _optimizationPrimary : AppColors.borderSolid,
        child: Row(
          children: [
            Icon(
              selected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_unchecked_rounded,
              color: selected ? _optimizationPrimary : AppColors.borderSolid,
              size: AppSpacing.iconMd,
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    target.label,
                    style: AppTextStyles.caption.copyWith(
                      color: selected ? _optimizationPrimary : AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x2),
                  Text(
                    target.description,
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RangeCard extends StatelessWidget {
  const _RangeCard({
    required this.ranges,
    required this.gridCount,
    required this.gridRange,
    required this.onGridCountChanged,
    required this.onGridRangeChanged,
  });

  final List<TradeBotOptimizationRange> ranges;
  final double gridCount;
  final double gridRange;
  final ValueChanged<double> onGridCountChanged;
  final ValueChanged<double> onGridRangeChanged;

  @override
  Widget build(BuildContext context) {
    final countRange = ranges.firstWhere((item) => item.id == 'gridCount');
    final rangePct = ranges.firstWhere((item) => item.id == 'gridRange');

    return VitCard(
      padding: AppSpacing.tradeBotCardPadding,
      borderColor: AppColors.cardBorder,
      child: Column(
        children: [
          _RangeSliderRow(
            key: BotOptimizationPage.rangeKey(countRange.id),
            range: countRange,
            value: gridCount,
            onChanged: onGridCountChanged,
          ),
          const SizedBox(height: AppSpacing.x3),
          _RangeSliderRow(
            key: BotOptimizationPage.rangeKey(rangePct.id),
            range: rangePct,
            value: gridRange,
            onChanged: onGridRangeChanged,
          ),
        ],
      ),
    );
  }
}

class _RangeSliderRow extends StatelessWidget {
  const _RangeSliderRow({
    super.key,
    required this.range,
    required this.value,
    required this.onChanged,
  });

  final TradeBotOptimizationRange range;
  final double value;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    final unit = range.unit;
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                range.label,
                style: AppTextStyles.caption.copyWith(color: AppColors.text2),
              ),
            ),
            Text(
              '${range.min.toStringAsFixed(0)} - ${range.max.toStringAsFixed(0)}$unit',
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x3),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: AppSpacing.x3,
            activeTrackColor: _optimizationPrimary,
            inactiveTrackColor: AppColors.onAccent,
            thumbColor: _optimizationPrimary,
            overlayColor: _optimizationPrimary.withValues(alpha: .12),
            thumbShape: const RoundSliderThumbShape(
              enabledThumbRadius: AppSpacing.x3,
            ),
            overlayShape: SliderComponentShape.noOverlay,
          ),
          child: Slider(
            value: value,
            min: range.min,
            max: range.max,
            onChanged: (raw) {
              final stepped = (raw / range.step).round() * range.step;
              onChanged(stepped.clamp(range.min, range.max).toDouble());
            },
          ),
        ),
      ],
    );
  }
}

class _HowItWorksCard extends StatelessWidget {
  const _HowItWorksCard({required this.steps});

  final List<String> steps;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: AppSpacing.tradeBotCompactCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How It Works',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          for (final step in steps) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.circle,
                  color: AppColors.text3,
                  size: AppSpacing.x2,
                ),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: Text(
                    step,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text3,
                    ),
                  ),
                ),
              ],
            ),
            if (step != steps.last) const SizedBox(height: AppSpacing.x2),
          ],
        ],
      ),
    );
  }
}

class _QueuedCard extends StatelessWidget {
  const _QueuedCard({required this.result});

  final TradeBotOptimizationResult result;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.ghost,
      padding: AppSpacing.tradeBotCompactCardPadding,
      borderColor: _optimizationPrimary.withValues(alpha: .24),
      child: Text(
        'Optimization queued (${result.jobId}) - about ${result.estimatedMinutes} min',
        style: AppTextStyles.caption.copyWith(color: AppColors.text2),
      ),
    );
  }
}
