part of '../pages/predictions_breaking_page.dart';

class _MovementSummary extends StatelessWidget {
  const _MovementSummary({required this.snapshot});

  final PredictionBreakingSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: AppSpacing.predictionBreakingMovementPadding,
      child: Row(
        children: [
          const Icon(
            Icons.bolt_rounded,
            color: AppColors.warn,
            size: AppSpacing.predictionBreakingMovementIcon,
          ),
          const SizedBox(width: AppSpacing.predictionBreakingMovementGap),
          Text(
            '24h Movement',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const Spacer(),
          _MovementCount(
            icon: Icons.trending_up_rounded,
            label: '${snapshot.upCount} up',
            color: AppColors.buy,
          ),
          const SizedBox(width: AppSpacing.predictionBreakingMovementCountGap),
          _MovementCount(
            icon: Icons.trending_down_rounded,
            label: '${snapshot.downCount} down',
            color: AppColors.sell,
          ),
        ],
      ),
    );
  }
}

class _MovementCount extends StatelessWidget {
  const _MovementCount({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: AppSpacing.predictionBreakingCountIcon),
        const SizedBox(width: AppSpacing.predictionBreakingCountIconGap),
        Text(
          label,
          style: AppTextStyles.badge.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}

class _CategoryTabs extends StatelessWidget {
  const _CategoryTabs({
    required this.categories,
    required this.activeCategory,
    required this.onSelected,
  });

  final List<String> categories;
  final String? activeCategory;
  final ValueChanged<String?> onSelected;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      (id: null, label: 'All', key: PredictionsBreakingPage.allTabKey),
      for (final category in categories)
        (
          id: category,
          label: category == 'Live Crypto' ? 'Crypto' : category,
          key: category == 'Live Crypto'
              ? PredictionsBreakingPage.cryptoTabKey
              : Key('sc029_category_$category'),
        ),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (var index = 0; index < tabs.length; index += 1) ...[
            _CategoryTabButton(
              key: tabs[index].key,
              label: tabs[index].label,
              active: activeCategory == tabs[index].id,
              onTap: () => onSelected(tabs[index].id),
            ),
            if (index != tabs.length - 1)
              const SizedBox(width: AppSpacing.predictionBreakingTabGap),
          ],
        ],
      ),
    );
  }
}

class _CategoryTabButton extends StatelessWidget {
  const _CategoryTabButton({
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
    return Material(
      color: active
          ? _predictionPrimary.withValues(alpha: .14)
          : AppColors.transparent,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: active
              ? _predictionPrimary.withValues(alpha: .36)
              : AppColors.transparent,
        ),
        borderRadius: AppRadii.mdRadius,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.mdRadius,
        child: SizedBox(
          height: AppSpacing.predictionBreakingTabHeight,
          child: Padding(
            padding: AppSpacing.predictionBreakingTabPadding,
            child: Center(
              child: Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: active ? _predictionPrimary : AppColors.text3,
                  fontWeight: active
                      ? AppTextStyles.bold
                      : AppTextStyles.normal,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MoverCard extends StatelessWidget {
  const _MoverCard({
    super.key,
    required this.event,
    required this.rank,
    required this.onTap,
  });

  final PredictionEventDraft event;
  final int rank;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final topOutcome = event.outcomes.first;
    final isUp = event.change24h > 0;
    final rankColor = switch (rank) {
      1 => AppColors.warn,
      2 => AppColors.medalSilverBlue,
      3 => AppColors.medalBronze,
      _ => AppColors.text3,
    };
    final changeColor = isUp ? AppColors.buy : AppColors.sell;

    return VitCard(
      onTap: onTap,
      padding: AppSpacing.predictionBreakingMoverPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Material(
            color: rank <= 3
                ? rankColor.withValues(alpha: .12)
                : AppColors.surface2,
            borderRadius: AppRadii.smRadius,
            child: SizedBox.square(
              dimension: AppSpacing.predictionBreakingRankBox,
              child: Center(
                child: Text(
                  '$rank',
                  style: AppTextStyles.caption.copyWith(
                    color: rankColor,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.predictionBreakingMoverGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.predictionBreakingTitleGap),
                Wrap(
                  spacing: AppSpacing.predictionBreakingOutcomeGap,
                  runSpacing: AppSpacing.predictionBreakingOutcomeRunGap,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: 'Yes: ',
                        style: AppTextStyles.numericMicro.copyWith(
                          color: AppColors.text2,
                        ),
                        children: [
                          TextSpan(
                            text: '${topOutcome.chance}%',
                            style: AppTextStyles.numericMicro.copyWith(
                              color: topOutcome.chance >= 50
                                  ? AppColors.buy
                                  : AppColors.sell,
                              fontWeight: AppTextStyles.bold,
                              fontFeatures: AppTextStyles.tabularFigures,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _ChangeBadge(value: event.change24h, color: changeColor),
                  ],
                ),
                const SizedBox(height: AppSpacing.predictionBreakingMetaGap),
                Wrap(
                  spacing: AppSpacing.predictionBreakingMetaGap,
                  runSpacing: AppSpacing.predictionBreakingMetaRunGap,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    _TinyBadge(event.category),
                    _MetaIcon(
                      icon: Icons.bar_chart_rounded,
                      label: _formatVolume(event.volume24h),
                    ),
                    _MetaIcon(
                      icon: Icons.schedule_rounded,
                      label: _timeRemaining(event.endDate),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChangeBadge extends StatelessWidget {
  const _ChangeBadge({required this.value, required this.color});

  final double value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final isUp = value > 0;
    return Material(
      color: color.withValues(alpha: .14),
      borderRadius: AppRadii.badgeRadius,
      child: Padding(
        padding: AppSpacing.predictionBreakingChangePadding,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isUp ? Icons.arrow_outward_rounded : Icons.south_east_rounded,
              size: AppSpacing.predictionBreakingChangeIcon,
              color: color,
            ),
            const SizedBox(width: AppSpacing.predictionBreakingChangeIconGap),
            Text(
              _formatPercent(value),
              style: AppTextStyles.badge.copyWith(
                color: color,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TinyBadge extends StatelessWidget {
  const _TinyBadge(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _predictionPrimary.withValues(alpha: .14),
      borderRadius: AppRadii.xsRadius,
      child: Padding(
        padding: AppSpacing.predictionBreakingTinyBadgePadding,
        child: Text(
          label,
          style: AppTextStyles.numericMicro.copyWith(
            color: _predictionPrimary,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}

class _MetaIcon extends StatelessWidget {
  const _MetaIcon({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: AppColors.text3,
          size: AppSpacing.predictionBreakingMetaIcon,
        ),
        const SizedBox(width: AppSpacing.predictionBreakingMetaIconGap),
        Text(
          label,
          style: AppTextStyles.numericMicro.copyWith(color: AppColors.text3),
        ),
      ],
    );
  }
}
