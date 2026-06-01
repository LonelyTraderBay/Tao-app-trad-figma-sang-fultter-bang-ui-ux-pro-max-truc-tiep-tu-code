part of '../pages/bot_optimization_page.dart';

class _IntroCard extends StatelessWidget {
  const _IntroCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
      decoration: BoxDecoration(
        color: _optimizationPrimary.withValues(alpha: .08),
        border: Border.all(color: _optimizationPrimary.withValues(alpha: .22)),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.bolt_outlined,
            color: _optimizationPrimary,
            size: 21,
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Automated Parameter Tuning',
                  style: AppTextStyles.baseMedium.copyWith(
                    color: AppColors.text1,
                    fontSize: 15,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Use genetic algorithms to find optimal bot parameters that maximize Sharpe ratio while minimizing drawdown. This typically takes 2-5 minutes.',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    fontSize: 11,
                    height: 1.45,
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
    return _Card(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Column(
        children: [
          for (final target in targets) ...[
            _TargetTile(
              key: BotOptimizationPage.targetKey(target.id),
              target: target,
              selected: target.id == selectedId,
              onTap: () => onChanged(target.id),
            ),
            if (target != targets.last) const SizedBox(height: 12),
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
      child: Container(
        height: 64,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: selected
              ? _optimizationPrimary.withValues(alpha: .05)
              : _optimizationPanel2,
          border: Border.all(
            color: selected ? _optimizationPrimary : AppColors.borderSolid,
            width: selected ? 1.3 : 1,
          ),
          borderRadius: AppRadii.cardRadius,
        ),
        child: Row(
          children: [
            Container(
              width: 18,
              height: 18,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected
                      ? _optimizationPrimary
                      : AppColors.borderSolid,
                  width: 2,
                ),
              ),
              child: selected
                  ? Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: _optimizationPrimary,
                        shape: BoxShape.circle,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    target.label,
                    style: AppTextStyles.caption.copyWith(
                      color: selected ? _optimizationPrimary : AppColors.text1,
                      fontSize: 13,
                      fontWeight: AppTextStyles.bold,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    target.description,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      fontSize: 10,
                      height: 1,
                    ),
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

    return _Card(
      padding: const EdgeInsets.fromLTRB(16, 19, 16, 25),
      child: Column(
        children: [
          _RangeSliderRow(
            key: BotOptimizationPage.rangeKey(countRange.id),
            range: countRange,
            value: gridCount,
            onChanged: onGridCountChanged,
          ),
          const SizedBox(height: 22),
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
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  fontSize: 12,
                  height: 1,
                ),
              ),
            ),
            Text(
              '${range.min.toStringAsFixed(0)} - ${range.max.toStringAsFixed(0)}$unit',
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text1,
                fontSize: 10,
                fontWeight: AppTextStyles.bold,
                fontFamily: 'Roboto',
                height: 1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 9),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 7,
            activeTrackColor: _optimizationPrimary,
            inactiveTrackColor: AppColors.onAccent,
            thumbColor: _optimizationPrimary,
            overlayColor: _optimizationPrimary.withValues(alpha: .12),
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
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
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 17, 16, 17),
      decoration: BoxDecoration(
        color: _optimizationPanel2,
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How It Works',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontSize: 12,
              fontWeight: AppTextStyles.bold,
              height: 1,
            ),
          ),
          const SizedBox(height: 12),
          for (final step in steps) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 4,
                  height: 4,
                  margin: const EdgeInsets.only(top: 7),
                  decoration: const BoxDecoration(
                    color: AppColors.text3,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Text(
                    step,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text3,
                      fontSize: 11,
                      height: 1.45,
                    ),
                  ),
                ),
              ],
            ),
            if (step != steps.last) const SizedBox(height: 10),
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
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: _optimizationPrimary.withValues(alpha: .08),
        border: Border.all(color: _optimizationPrimary.withValues(alpha: .24)),
        borderRadius: AppRadii.inputRadius,
      ),
      child: Text(
        'Optimization queued (${result.jobId}) - about ${result.estimatedMinutes} min',
        style: AppTextStyles.caption.copyWith(
          color: AppColors.text2,
          fontSize: 11,
          height: 1.35,
        ),
      ),
    );
  }
}
