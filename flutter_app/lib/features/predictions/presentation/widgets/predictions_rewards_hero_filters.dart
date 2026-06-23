part of '../pages/predictions_rewards_page.dart';

class _RewardsHero extends StatelessWidget {
  const _RewardsHero({required this.snapshot});

  final PredictionRewardsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.hero,
      borderColor: AppColors.accent20,
      density: VitDensity.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Material(
                color: AppColors.warn10,
                borderRadius: AppRadii.cardRadius,
                child: SizedBox.square(
                  dimension: VitDensity.compact.controlHeight,
                  child: const Icon(
                    Icons.card_giftcard_rounded,
                    color: AppColors.warn,
                    size: AppSpacing.predictionRewardsHeroIcon,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Daily Rewards',
                      style: AppTextStyles.sectionTitle.copyWith(
                        color: AppColors.onAccent,
                      ),
                    ),
                    Text(
                      'Earn rewards by placing competitive limit orders',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.portfolioTextDim,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x2),
          Row(
            children: [
              const Icon(
                Icons.help_outline_rounded,
                color: AppColors.portfolioTextMuted,
                size: AppSpacing.predictionRewardsPoolIcon,
              ),
              const SizedBox(width: AppSpacing.x1),
              Text(
                'Total daily pool:',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.portfolioTextMuted,
                ),
              ),
              const SizedBox(width: AppSpacing.x1),
              Text(
                '\$${snapshot.totalDailyPool.toStringAsFixed(0)}',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.warn,
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HowItWorksNote extends StatelessWidget {
  const _HowItWorksNote();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _predictionPrimary.withValues(alpha: .07),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadii.cardRadius,
        side: BorderSide(color: _predictionPrimary.withValues(alpha: .18)),
      ),
      child: Padding(
        padding: VitDensity.compact.cardPadding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.info_outline_rounded,
              color: _predictionPrimary,
              size: AppSpacing.predictionRewardsNoteIcon,
            ),
            const SizedBox(width: AppSpacing.x2),
            Expanded(
              child: Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(text: 'How it works:'),
                    TextSpan(
                      text: ' Place a ',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text2,
                        height: 1.35,
                        fontWeight: AppTextStyles.normal,
                      ),
                    ),
                    const TextSpan(text: 'limit order'),
                    TextSpan(
                      text: ' (not market order) within the ',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text2,
                        height: 1.35,
                        fontWeight: AppTextStyles.normal,
                      ),
                    ),
                    const TextSpan(text: 'Max Spread'),
                    TextSpan(
                      text: ' and hold at least ',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text2,
                        height: 1.35,
                        fontWeight: AppTextStyles.normal,
                      ),
                    ),
                    const TextSpan(text: 'Min Shares'),
                    TextSpan(
                      text:
                          '. Rewards are distributed daily in USDT at 00:00 UTC.',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text2,
                        height: 1.35,
                        fontWeight: AppTextStyles.normal,
                      ),
                    ),
                  ],
                ),
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text2,
                  height: 1.35,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryFilters extends StatelessWidget {
  const _CategoryFilters({
    required this.categories,
    required this.activeCategory,
    required this.favoritesOnly,
    required this.onCategoryChanged,
    required this.onFavoritesToggle,
  });

  final List<String> categories;
  final String activeCategory;
  final bool favoritesOnly;
  final ValueChanged<String> onCategoryChanged;
  final VoidCallback onFavoritesToggle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: VitDensity.compact.controlHeight - AppSpacing.x3,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          if (index == 0) {
            return _FilterChip(
              key: PredictionsRewardsPage.favoritesFilterKey,
              label: 'Favs',
              active: favoritesOnly,
              icon: Icons.favorite_rounded,
              activeColor: AppColors.sell,
              onTap: onFavoritesToggle,
            );
          }
          final category = categories[index - 1];
          return _FilterChip(
            key: category == 'All'
                ? PredictionsRewardsPage.allFilterKey
                : category == 'Live Crypto'
                ? PredictionsRewardsPage.liveCryptoFilterKey
                : Key('sc032_filter_$category'),
            label: category,
            active: activeCategory == category,
            onTap: () => onCategoryChanged(category),
          );
        },
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.x2),
        itemCount: categories.length + 1,
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    super.key,
    required this.label,
    required this.active,
    required this.onTap,
    this.icon,
    this.activeColor = _predictionPrimary,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;
  final IconData? icon;
  final Color activeColor;

  @override
  Widget build(BuildContext context) {
    return VitChoicePill(
      label: label,
      selected: active,
      onTap: onTap,
      accentColor: activeColor,
      height: VitDensity.compact.controlHeight - AppSpacing.x3,
      padding: AppSpacing.predictionRewardsFilterPadding,
      leading: icon == null
          ? null
          : Icon(icon, size: AppSpacing.predictionRewardsFilterIcon),
    );
  }
}
