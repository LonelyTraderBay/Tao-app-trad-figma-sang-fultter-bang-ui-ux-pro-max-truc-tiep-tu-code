part of '../pages/prediction_event_detail_page.dart';

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
          spacing: AppSpacing.x2,
          runSpacing: AppSpacing.x1,
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
        const SizedBox(height: AppSpacing.x2),
        Text(
          event.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.sectionTitle,
        ),
        const SizedBox(height: AppSpacing.x2),
        Wrap(
          spacing: AppSpacing.x3,
          runSpacing: AppSpacing.x1,
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
        const SizedBox(height: AppSpacing.x3),
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
                if (index == 0)
                  const SizedBox(width: AppSpacing.predictionDetailOutcomeGap),
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
          const SizedBox(height: AppSpacing.x2),
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
    return VitCard(
      onTap: onTap,
      borderColor: outcome.color.withValues(alpha: selected ? .42 : .18),
      background: ColoredBox(
        color: outcome.color.withValues(alpha: isYes ? .08 : .07),
      ),
      clip: true,
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox.square(
                dimension: AppSpacing.predictionDetailOutcomeDot,
                child: Material(
                  color: outcome.color,
                  shape: const CircleBorder(),
                ),
              ),
              const SizedBox(width: AppSpacing.predictionDetailOutcomeLabelGap),
              Text(
                outcome.label,
                style: AppTextStyles.body.copyWith(
                  color: outcome.color,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            '${outcome.chance}%',
            style: AppTextStyles.sectionTitle.copyWith(
              color: outcome.color,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
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
              const SizedBox(
                width: AppSpacing.predictionDetailOutcomeChanceGap,
              ),
              Flexible(
                child: Text(
                  _formatPrice(outcome.chance / 100),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text2,
                    fontWeight: AppTextStyles.bold,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ),
            ],
          ),
        ],
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
        for (var index = 0; index < event.outcomes.length; index += 1) ...[
          _MultiOutcomeRow(
            outcome: event.outcomes[index],
            selected: selectedOutcome == event.outcomes[index].label,
            onTap: () => onOutcomeSelected(event.outcomes[index].label),
          ),
          if (index != event.outcomes.length - 1)
            const SizedBox(height: AppSpacing.x2),
        ],
      ],
    );
  }
}

class _MultiOutcomeRow extends StatelessWidget {
  const _MultiOutcomeRow({
    required this.outcome,
    required this.selected,
    required this.onTap,
  });

  final PredictionOutcomeDraft outcome;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      onTap: onTap,
      variant: VitCardVariant.inner,
      radius: VitCardRadius.standard,
      borderColor: selected
          ? outcome.color.withValues(alpha: .34)
          : AppColors.cardBorder,
      background: selected
          ? ColoredBox(color: outcome.color.withValues(alpha: .12))
          : null,
      clip: selected,
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x2,
      ),
      child: Row(
        children: [
          SizedBox.square(
            dimension: AppSpacing.predictionDetailMultiOutcomeDot,
            child: Material(color: outcome.color, shape: const CircleBorder()),
          ),
          const SizedBox(width: AppSpacing.predictionDetailMultiOutcomeGap),
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
      borderRadius: AppRadii.pillRadius,
      child: SizedBox(
        height: AppSpacing.x2,
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
