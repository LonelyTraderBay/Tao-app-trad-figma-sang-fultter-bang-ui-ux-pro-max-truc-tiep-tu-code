part of 'prediction_event_detail_page.dart';

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({
    super.key,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 36,
      height: 36,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.searchBg,
          border: Border.all(color: AppColors.border),
          borderRadius: AppRadii.smRadius,
        ),
        child: IconButton(
          onPressed: onTap,
          padding: EdgeInsets.zero,
          icon: Icon(icon, color: color, size: 17),
        ),
      ),
    );
  }
}

class _EventHeader extends StatelessWidget {
  const _EventHeader({
    required this.event,
    required this.selectedOutcome,
    required this.onOutcomeSelected,
  });

  final PredictionEventDraft event;
  final String selectedOutcome;
  final ValueChanged<String> onOutcomeSelected;

  @override
  Widget build(BuildContext context) {
    final outcomes = event.outcomes.take(2).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 7,
          runSpacing: 6,
          children: [
            _TinyBadge(
              label: event.category,
              color: _predictionPrimary,
              background: _predictionPrimary.withValues(alpha: .13),
            ),
            for (final tag in event.tags)
              _TinyBadge(
                label: tag,
                color: AppColors.text3,
                background: AppColors.surface2,
              ),
            if (event.status == PredictionEventStatus.resolved)
              _TinyBadge(
                label: 'RESOLVED',
                color: AppColors.text3,
                background: AppColors.surface2,
              ),
          ],
        ),
        const SizedBox(height: 9),
        Text(
          event.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.sectionTitle.copyWith(
            fontSize: 20,
            height: 1.30,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          runSpacing: 6,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            _MetaItem(
              icon: Icons.schedule_rounded,
              label: _timeRemaining(event.endDate),
            ),
            _MetaItem(
              icon: Icons.group_outlined,
              label: _formatInt(event.participants),
            ),
            _MetaItem(
              icon: Icons.bar_chart_rounded,
              label: _formatVolume(event.totalVolume),
            ),
            _ChangeLabel(value: event.change24h),
          ],
        ),
        const SizedBox(height: 15),
        if (event.outcomes.length == 2)
          Row(
            children: [
              for (var index = 0; index < outcomes.length; index += 1) ...[
                Expanded(
                  child: _OutcomeCard(
                    outcome: outcomes[index],
                    selected: selectedOutcome == outcomes[index].label,
                    onTap: () => onOutcomeSelected(outcomes[index].label),
                  ),
                ),
                if (index == 0) const SizedBox(width: 12),
              ],
            ],
          )
        else
          _MultiOutcomeList(
            event: event,
            selectedOutcome: selectedOutcome,
            onOutcomeSelected: onOutcomeSelected,
          ),
        if (event.outcomes.length == 2) ...[
          const SizedBox(height: 12),
          _ProbabilityBar(outcomes: outcomes),
        ],
      ],
    );
  }
}

class _OutcomeCard extends StatelessWidget {
  const _OutcomeCard({
    required this.outcome,
    required this.selected,
    required this.onTap,
  });

  final PredictionOutcomeDraft outcome;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isYes = outcome.label == 'Yes';
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.cardRadius,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: outcome.color.withValues(alpha: isYes ? .08 : .07),
          border: Border.all(
            color: outcome.color.withValues(alpha: selected ? .42 : .18),
          ),
          borderRadius: AppRadii.cardRadius,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 11,
                  height: 11,
                  decoration: BoxDecoration(
                    color: outcome.color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 7),
                Text(
                  outcome.label,
                  style: AppTextStyles.body.copyWith(
                    color: outcome.color,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              '${outcome.chance}%',
              style: AppTextStyles.heroNumber.copyWith(
                color: outcome.color,
                fontSize: 28,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    isYes ? 'Best Bid' : 'Best Ask',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    _formatPrice(outcome.chance / 100),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text2,
                      fontSize: 11,
                      fontWeight: AppTextStyles.bold,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MultiOutcomeList extends StatelessWidget {
  const _MultiOutcomeList({
    required this.event,
    required this.selectedOutcome,
    required this.onOutcomeSelected,
  });

  final PredictionEventDraft event;
  final String selectedOutcome;
  final ValueChanged<String> onOutcomeSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final outcome in event.outcomes)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: InkWell(
              onTap: () => onOutcomeSelected(outcome.label),
              borderRadius: AppRadii.mdRadius,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: selectedOutcome == outcome.label
                      ? outcome.color.withValues(alpha: .12)
                      : AppColors.surface,
                  border: Border.all(
                    color: selectedOutcome == outcome.label
                        ? outcome.color.withValues(alpha: .34)
                        : AppColors.cardBorder,
                  ),
                  borderRadius: AppRadii.mdRadius,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: outcome.color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        outcome.label,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                    Text(
                      '${outcome.chance}%',
                      style: AppTextStyles.body.copyWith(
                        color: outcome.color,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _ProbabilityBar extends StatelessWidget {
  const _ProbabilityBar({required this.outcomes});

  final List<PredictionOutcomeDraft> outcomes;

  @override
  Widget build(BuildContext context) {
    final yes = outcomes.first;
    final no = outcomes.last;
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: SizedBox(
        height: 10,
        child: Row(
          children: [
            Expanded(
              flex: yes.chance,
              child: ColoredBox(color: yes.color),
            ),
            Expanded(
              flex: no.chance,
              child: ColoredBox(color: no.color),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  const _StatsGrid({required this.event});

  final PredictionEventDraft event;

  @override
  Widget build(BuildContext context) {
    final stats = [
      _StatItem(
        icon: Icons.bar_chart_rounded,
        label: 'Volume 24h',
        value: _formatVolume(event.volume24h),
        color: _predictionPrimary,
      ),
      _StatItem(
        icon: Icons.group_outlined,
        label: 'Participants',
        value: _formatInt(event.participants),
        color: _predictionPurple,
      ),
      _StatItem(
        icon: Icons.stacked_line_chart_rounded,
        label: 'Total Volume',
        value: _formatVolume(event.totalVolume),
        color: AppColors.buy,
      ),
      _StatItem(
        icon: Icons.schedule_rounded,
        label: 'Ends in',
        value: _timeRemaining(event.endDate),
        color: AppColors.warn,
      ),
    ];

    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      childAspectRatio: 2.7,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        for (final stat in stats)
          VitCard(
            variant: VitCardVariant.inner,
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: stat.color.withValues(alpha: .12),
                    borderRadius: AppRadii.smRadius,
                  ),
                  child: Icon(stat.icon, color: stat.color, size: 15),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        stat.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                      Text(
                        stat.value,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                          fontFeatures: AppTextStyles.tabularFigures,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _StatItem {
  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;
}

class _PositionBanner extends StatelessWidget {
  const _PositionBanner({required this.position});

  final PredictionDetailPositionDraft position;

  @override
  Widget build(BuildContext context) {
    final color = position.pnl >= 0 ? AppColors.buy : AppColors.sell;
    return VitCard(
      borderColor: color.withValues(alpha: .22),
      padding: const EdgeInsets.all(13),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.bolt_rounded, color: AppColors.warn, size: 13),
              const SizedBox(width: 6),
              Text(
                'Your Position',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 9),
          Row(
            children: [
              _TinyBadge(
                label: position.outcome,
                color: position.outcome == 'Yes'
                    ? AppColors.buy
                    : AppColors.sell,
                background: position.outcome == 'Yes'
                    ? AppColors.buy10
                    : AppColors.sell10,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${position.shares.toStringAsFixed(0)} shares @ '
                  '${_formatPrice(position.avgPrice)}',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text2,
                    fontSize: 11,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${position.pnl >= 0 ? '+' : ''}'
                    '${_formatMoney(position.pnl)}',
                    style: AppTextStyles.caption.copyWith(
                      color: color,
                      fontWeight: AppTextStyles.bold,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                  Text(
                    '${position.pnlPct >= 0 ? '+' : ''}'
                    '${position.pnlPct.toStringAsFixed(1)}%',
                    style: AppTextStyles.micro.copyWith(
                      color: color,
                      fontWeight: AppTextStyles.medium,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ChartSection extends StatelessWidget {
  const _ChartSection({required this.snapshot});

  final PredictionEventDetailSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Price / Probability',
      accentColor: AppColors.buy,
      children: [
        VitCard(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _ChartPeriodTabs(),
              const SizedBox(height: 10),
              SizedBox(
                height: 178,
                child: CustomPaint(
                  painter: _ProbabilityChartPainter(
                    values: snapshot.probabilityHistory,
                  ),
                ),
              ),
              const SizedBox(height: 9),
              Text(
                'Volume (24h)',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
              const SizedBox(height: 5),
              SizedBox(
                height: 42,
                child: _VolumeBars(values: snapshot.volumeHistory),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
