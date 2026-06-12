part of '../pages/predictions_rewards_page.dart';

class _RewardsHero extends StatelessWidget {
  const _RewardsHero({required this.snapshot});

  final PredictionRewardsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.predictionRewardsHeroPadding,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.surface, AppColors.surface2, AppColors.warningBg],
        ),
        border: Border.all(color: AppColors.accent20),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: AppSpacing.predictionRewardsHeroIconBox,
                height: AppSpacing.predictionRewardsHeroIconBox,
                decoration: BoxDecoration(
                  color: AppColors.warn10,
                  borderRadius: AppRadii.cardRadius,
                ),
                child: const Icon(
                  Icons.card_giftcard_rounded,
                  color: AppColors.warn,
                  size: AppSpacing.predictionRewardsHeroIcon,
                ),
              ),
              const SizedBox(width: AppSpacing.predictionRewardsHeroTitleGap),
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
          const Padding(
            padding: EdgeInsets.only(
              top: AppSpacing.predictionRewardsHeroPoolGap,
            ),
          ),
          Row(
            children: [
              const Icon(
                Icons.help_outline_rounded,
                color: AppColors.portfolioTextMuted,
                size: AppSpacing.predictionRewardsPoolIcon,
              ),
              const SizedBox(width: AppSpacing.predictionRewardsPoolGap),
              Text(
                'Total daily pool:',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.portfolioTextMuted,
                ),
              ),
              const SizedBox(width: AppSpacing.predictionRewardsPoolGap),
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
    return Container(
      padding: AppSpacing.predictionRewardsNotePadding,
      decoration: BoxDecoration(
        color: _predictionPrimary.withValues(alpha: .07),
        border: Border.all(color: _predictionPrimary.withValues(alpha: .18)),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: _predictionPrimary,
            size: AppSpacing.predictionRewardsNoteIcon,
          ),
          const SizedBox(width: AppSpacing.predictionRewardsNoteGap),
          Expanded(
            child: Text.rich(
              const TextSpan(
                children: [
                  TextSpan(text: 'How it works:'),
                  TextSpan(
                    text: ' Place a ',
                    style: TextStyle(fontWeight: FontWeight.w400),
                  ),
                  TextSpan(text: 'limit order'),
                  TextSpan(
                    text: ' (not market order) within the ',
                    style: TextStyle(fontWeight: FontWeight.w400),
                  ),
                  TextSpan(text: 'Max Spread'),
                  TextSpan(
                    text: ' and hold at least ',
                    style: TextStyle(fontWeight: FontWeight.w400),
                  ),
                  TextSpan(text: 'Min Shares'),
                  TextSpan(
                    text:
                        '. Rewards are distributed daily in USDT at 00:00 UTC.',
                    style: TextStyle(fontWeight: FontWeight.w400),
                  ),
                ],
              ),
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text2,
                height: AppSpacing.predictionRewardsNoteLineHeight,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
        ],
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
      height: AppSpacing.predictionRewardsFilterHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          if (index == categories.length) {
            return _FilterChip(
              key: PredictionsRewardsPage.favoritesFilterKey,
              label: 'Favs',
              active: favoritesOnly,
              icon: Icons.favorite_rounded,
              activeColor: AppColors.sell,
              onTap: onFavoritesToggle,
            );
          }
          final category = categories[index];
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
        separatorBuilder: (_, _) =>
            const SizedBox(width: AppSpacing.predictionRewardsFilterGap),
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
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.smRadius,
      child: Container(
        height: AppSpacing.predictionRewardsFilterHeight,
        padding: AppSpacing.predictionRewardsFilterPadding,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active
              ? activeColor.withValues(alpha: .13)
              : AppColors.surface2,
          border: Border.all(
            color: active
                ? activeColor.withValues(alpha: .35)
                : AppColors.transparent,
          ),
          borderRadius: AppRadii.smRadius,
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                color: active ? activeColor : AppColors.text3,
                size: AppSpacing.predictionRewardsFilterIcon,
              ),
              const SizedBox(width: AppSpacing.predictionRewardsFilterIconGap),
            ],
            Text(
              label,
              style: AppTextStyles.micro.copyWith(
                color: active ? activeColor : AppColors.text3,
                fontWeight: active ? AppTextStyles.bold : AppTextStyles.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
