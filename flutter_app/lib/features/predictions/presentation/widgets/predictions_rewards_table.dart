part of '../pages/predictions_rewards_page.dart';

class _RewardsTable extends StatelessWidget {
  const _RewardsTable({
    required this.snapshot,
    required this.rewards,
    required this.favorites,
    required this.onFavoriteToggle,
  });

  final PredictionRewardsSnapshot snapshot;
  final List<PredictionRewardOpportunityDraft> rewards;
  final Set<String> favorites;
  final ValueChanged<String> onFavoriteToggle;

  @override
  Widget build(BuildContext context) {
    if (rewards.isEmpty) {
      return const VitEmptyState(
        title: 'No rewards found',
        message: 'Try adjusting your filters',
        icon: Icons.card_giftcard_rounded,
      );
    }

    return Column(
      children: [
        const _TableHeader(),
        for (final reward in rewards)
          _RewardRow(
            key: PredictionsRewardsPage.rewardKey(reward.id),
            reward: reward,
            event: snapshot.eventFor(reward.eventId),
            favorite: favorites.contains(reward.id),
            onFavoriteToggle: () => onFavoriteToggle(reward.id),
          ),
      ],
    );
  }
}

class _TableHeader extends StatelessWidget {
  const _TableHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          Expanded(child: _HeaderText('MARKET')),
          const SizedBox(width: 6),
          const SizedBox(
            width: 54,
            child: Center(child: _HeaderText('SPREAD')),
          ),
          const SizedBox(width: 48, child: Center(child: _HeaderText('MIN'))),
          const SizedBox(
            width: 58,
            child: Align(
              alignment: Alignment.centerRight,
              child: _HeaderText('REWARD'),
            ),
          ),
          const SizedBox(width: 14),
        ],
      ),
    );
  }
}

class _HeaderText extends StatelessWidget {
  const _HeaderText(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: AppTextStyles.micro.copyWith(
        color: AppColors.text3,
        fontSize: 10,
        fontWeight: AppTextStyles.bold,
      ),
    );
  }
}

class _RewardRow extends StatelessWidget {
  const _RewardRow({
    super.key,
    required this.reward,
    required this.event,
    required this.favorite,
    required this.onFavoriteToggle,
  });

  final PredictionRewardOpportunityDraft reward;
  final PredictionEventDraft event;
  final bool favorite;
  final VoidCallback onFavoriteToggle;

  @override
  Widget build(BuildContext context) {
    final changeColor = reward.priceChange24h >= 0
        ? AppColors.buy
        : AppColors.sell;

    return InkWell(
      onTap: () => context.go(AppRoutePaths.marketsPredictionEvent(event.id)),
      child: Container(
        height: 64,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.divider)),
        ),
        child: Row(
          children: [
            InkWell(
              key: PredictionsRewardsPage.favoriteKey(reward.id),
              onTap: onFavoriteToggle,
              borderRadius: AppRadii.mdRadius,
              child: SizedBox(
                width: 20,
                child: Icon(
                  favorite ? Icons.star_rounded : Icons.star_border_rounded,
                  color: favorite ? AppColors.warn : AppColors.text3,
                  size: 15,
                ),
              ),
            ),
            const SizedBox(width: 7),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontSize: 12,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Flexible(
                        child: _TinyBadge(
                          label: reward.category,
                          color: _predictionPrimary,
                          background: _predictionPrimary.withValues(alpha: .14),
                        ),
                      ),
                      const SizedBox(width: 7),
                      Icon(
                        reward.priceChange24h >= 0
                            ? Icons.arrow_outward_rounded
                            : Icons.south_east_rounded,
                        color: changeColor,
                        size: 11,
                      ),
                      Text(
                        _formatPercent(reward.priceChange24h),
                        style: AppTextStyles.micro.copyWith(
                          color: changeColor,
                          fontSize: 10,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                      const SizedBox(width: 7),
                      Flexible(
                        child: Text(
                          '${reward.earningsPct.toStringAsFixed(reward.earningsPct == reward.earningsPct.round() ? 0 : 1)}% APY',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            SizedBox(
              width: 54,
              child: Text(
                '${(reward.maxSpread * 100).toStringAsFixed(0)}%',
                textAlign: TextAlign.center,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text2,
                  fontSize: 11,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ),
            SizedBox(
              width: 48,
              child: Text(
                '${reward.minShares}',
                textAlign: TextAlign.center,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text2,
                  fontSize: 11,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ),
            SizedBox(
              width: 58,
              child: Text(
                '\$${reward.dailyReward.toStringAsFixed(0)}',
                textAlign: TextAlign.right,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.buy,
                  fontSize: 12,
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.text3,
              size: 15,
            ),
          ],
        ),
      ),
    );
  }
}

class _RiskLink extends StatelessWidget {
  const _RiskLink({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: PredictionsRewardsPage.riskExplainerKey,
      onTap: onTap,
      borderRadius: AppRadii.mdRadius,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 9),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.shield_outlined, color: AppColors.warn, size: 13),
            const SizedBox(width: 7),
            Flexible(
              child: Text(
                'Reward không phải lợi nhuận đảm bảo — tìm hiểu thêm',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.warn,
                  fontSize: 12,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.warn,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }
}
