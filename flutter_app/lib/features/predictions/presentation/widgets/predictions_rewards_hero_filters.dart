part of '../pages/predictions_rewards_page.dart';

class _RewardsHero extends StatelessWidget {
  const _RewardsHero({required this.snapshot});

  final PredictionRewardsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
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
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.warn10,
                  borderRadius: AppRadii.cardRadius,
                ),
                child: const Icon(
                  Icons.card_giftcard_rounded,
                  color: AppColors.warn,
                  size: 23,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Daily Rewards',
                      style: AppTextStyles.sectionTitle.copyWith(
                        color: AppColors.onAccent,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      'Earn rewards by placing competitive limit orders',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.portfolioTextDim,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              const Icon(
                Icons.help_outline_rounded,
                color: AppColors.portfolioTextMuted,
                size: 13,
              ),
              const SizedBox(width: 7),
              Text(
                'Total daily pool:',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.portfolioTextMuted,
                  fontSize: 11,
                ),
              ),
              const SizedBox(width: 7),
              Text(
                '\$${snapshot.totalDailyPool.toStringAsFixed(0)}',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.warn,
                  fontSize: 16,
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
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
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
            size: 15,
          ),
          const SizedBox(width: 9),
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
                fontSize: 11,
                height: 1.45,
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
      height: 31,
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
        separatorBuilder: (_, _) => const SizedBox(width: 8),
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
        height: 31,
        padding: const EdgeInsets.symmetric(horizontal: 12),
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
                size: 11,
              ),
              const SizedBox(width: 5),
            ],
            Text(
              label,
              style: AppTextStyles.micro.copyWith(
                color: active ? activeColor : AppColors.text3,
                fontSize: 11,
                fontWeight: active ? AppTextStyles.bold : AppTextStyles.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
