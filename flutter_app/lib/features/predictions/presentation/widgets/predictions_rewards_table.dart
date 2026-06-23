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
    return SizedBox(
      height: VitDensity.compact.controlHeight - AppSpacing.x2,
      child: Stack(
        children: [
          Padding(
            padding: AppSpacing.predictionRewardsTablePadding,
            child: Row(
              children: [
                Expanded(child: _HeaderText('MARKET')),
                const SizedBox(width: AppSpacing.x1),
                const SizedBox(
                  width: AppSpacing.predictionRewardsSpreadWidth,
                  child: Center(child: _HeaderText('SPREAD')),
                ),
                const SizedBox(
                  width: AppSpacing.predictionRewardsMinWidth,
                  child: Center(child: _HeaderText('MIN')),
                ),
                const SizedBox(
                  width: AppSpacing.predictionRewardsRewardWidth,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: _HeaderText('REWARD'),
                  ),
                ),
                const SizedBox(width: AppSpacing.x2),
              ],
            ),
          ),
          const _RewardsDivider(),
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

    return VitCard(
      onTap: () => context.go(AppRoutePaths.marketsPredictionEvent(event.id)),
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.sm,
      child: SizedBox(
        height: VitDensity.compact.controlHeight + AppSpacing.x4,
        child: Stack(
          children: [
            Padding(
              padding: AppSpacing.predictionRewardsTablePadding,
              child: Row(
                children: [
                  VitCard(
                    key: PredictionsRewardsPage.favoriteKey(reward.id),
                    onTap: onFavoriteToggle,
                    variant: VitCardVariant.ghost,
                    radius: VitCardRadius.sm,
                    width: AppSpacing.predictionRewardsFavoriteWidth,
                    height: VitDensity.compact.controlHeight - AppSpacing.x3,
                    padding: AppSpacing.zeroInsets,
                    child: Icon(
                      favorite ? Icons.star_rounded : Icons.star_border_rounded,
                      color: favorite ? AppColors.warn : AppColors.text3,
                      size: AppSpacing.predictionRewardsFavoriteIcon,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x1),
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
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.x1),
                        Row(
                          children: [
                            Flexible(
                              child: _TinyBadge(
                                label: reward.category,
                                color: _predictionPrimary,
                                background: _predictionPrimary.withValues(
                                  alpha: .14,
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.x1),
                            Icon(
                              reward.priceChange24h >= 0
                                  ? Icons.arrow_outward_rounded
                                  : Icons.south_east_rounded,
                              color: changeColor,
                              size: AppSpacing.predictionRewardsChangeIcon,
                            ),
                            Text(
                              _formatPercent(reward.priceChange24h),
                              style: AppTextStyles.micro.copyWith(
                                color: changeColor,
                                fontWeight: AppTextStyles.bold,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.x1),
                            Flexible(
                              child: Text(
                                '${reward.earningsPct.toStringAsFixed(reward.earningsPct == reward.earningsPct.round() ? 0 : 1)}% APY',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.micro.copyWith(
                                  color: AppColors.text3,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x1),
                  SizedBox(
                    width: AppSpacing.predictionRewardsSpreadWidth,
                    child: Text(
                      '${(reward.maxSpread * 100).toStringAsFixed(0)}%',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text2,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: AppSpacing.predictionRewardsMinWidth,
                    child: Text(
                      '${reward.minShares}',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text2,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: AppSpacing.predictionRewardsRewardWidth,
                    child: Text(
                      '\$${reward.dailyReward.toStringAsFixed(0)}',
                      textAlign: TextAlign.right,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.buy,
                        fontWeight: AppTextStyles.bold,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x1),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.text3,
                    size: AppSpacing.predictionRewardsChevron,
                  ),
                ],
              ),
            ),
            const _RewardsDivider(),
          ],
        ),
      ),
    );
  }
}

class _RewardsDivider extends StatelessWidget {
  const _RewardsDivider();

  @override
  Widget build(BuildContext context) {
    return const Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        height: AppSpacing.hairlineStroke,
        child: ColoredBox(color: AppColors.divider),
      ),
    );
  }
}

class _RiskLink extends StatelessWidget {
  const _RiskLink({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: PredictionsRewardsPage.riskExplainerKey,
      onTap: onTap,
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.sm,
      child: Padding(
        padding: AppSpacing.predictionRewardsRiskLinkPadding,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.shield_outlined,
              color: AppColors.warn,
              size: AppSpacing.predictionRewardsRiskIcon,
            ),
            const SizedBox(width: AppSpacing.x2),
            Flexible(
              child: Text(
                'Reward không phải lợi nhuận đảm bảo — tìm hiểu thêm',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.warn,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.x1),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.warn,
              size: AppSpacing.predictionRewardsRiskChevron,
            ),
          ],
        ),
      ),
    );
  }
}
