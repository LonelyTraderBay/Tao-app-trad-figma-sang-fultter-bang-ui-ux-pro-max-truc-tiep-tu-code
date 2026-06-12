part of '../pages/predictions_leaderboard_page.dart';

class _RankingRow extends StatelessWidget {
  const _RankingRow({
    super.key,
    required this.trader,
    required this.metric,
    required this.last,
  });

  final PredictionLeaderboardTraderDraft trader;
  final PredictionLeaderboardMetric metric;
  final bool last;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSpacing.predictionLeaderboardRankingRowHeight,
      padding: AppSpacing.predictionLeaderboardRankingPadding,
      decoration: BoxDecoration(
        border: last
            ? null
            : const Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: AppSpacing.predictionLeaderboardRankWidth,
            child: _RankBadge(rank: trader.rank),
          ),
          Expanded(
            child: Row(
              children: [
                Text(
                  trader.avatar,
                  style: const TextStyle(
                    fontSize: AppSpacing.predictionLeaderboardTraderAvatar,
                  ),
                ),
                const SizedBox(
                  width: AppSpacing.predictionLeaderboardTraderGap,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        trader.user,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                      Text(
                        '${trader.trades} trades',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: AppSpacing.predictionLeaderboardMetricWidth,
            child: Text(
              metric == PredictionLeaderboardMetric.pnl
                  ? _formatSignedCompact(trader.pnl)
                  : _formatCurrencyCompact(trader.volume),
              textAlign: TextAlign.right,
              style: AppTextStyles.caption.copyWith(
                color: metric == PredictionLeaderboardMetric.pnl
                    ? AppColors.buy
                    : AppColors.text1,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
          SizedBox(
            width: AppSpacing.predictionLeaderboardWinRateWidth,
            child: Text(
              '${trader.winRate}%',
              textAlign: TextAlign.right,
              style: AppTextStyles.caption.copyWith(
                color: _winRateColor(trader.winRate),
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RankBadge extends StatelessWidget {
  const _RankBadge({required this.rank});

  final int rank;

  @override
  Widget build(BuildContext context) {
    if (rank > 3) {
      return Text(
        '$rank',
        style: AppTextStyles.caption.copyWith(
          color: AppColors.text3,
          fontFeatures: AppTextStyles.tabularFigures,
        ),
      );
    }
    final color = rank == 1
        ? AppColors.medalGold
        : rank == 2
        ? AppColors.medalSilver
        : AppColors.medalBronze;
    return Container(
      width: AppSpacing.predictionLeaderboardRankBadge,
      height: AppSpacing.predictionLeaderboardRankBadge,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.withValues(alpha: .15),
        shape: BoxShape.circle,
      ),
      child: Text(
        '$rank',
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

class _BiggestWins extends StatelessWidget {
  const _BiggestWins({required this.snapshot});

  final PredictionLeaderboardSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    if (snapshot.biggestWins.isEmpty) return const SizedBox.shrink();
    return VitPageSection(
      label: 'Biggest Wins',
      accentColor: AppColors.buy,
      children: [
        Text(
          'Top single-trade profits this period',
          style: AppTextStyles.caption.copyWith(color: AppColors.text3),
        ),
        for (final trader in snapshot.biggestWins)
          _BiggestWinCard(snapshot: snapshot, trader: trader),
      ],
    );
  }
}

class _BiggestWinCard extends StatelessWidget {
  const _BiggestWinCard({required this.snapshot, required this.trader});

  final PredictionLeaderboardSnapshot snapshot;
  final PredictionLeaderboardTraderDraft trader;

  @override
  Widget build(BuildContext context) {
    final event = snapshot.eventForWin(trader);
    return VitCard(
      key: PredictionsLeaderboardPage.biggestWinKey(trader.user),
      variant: VitCardVariant.inner,
      onTap: event == null
          ? null
          : () => context.go(AppRoutePaths.marketsPredictionEvent(event.id)),
      borderColor: AppColors.transparent,
      padding: AppSpacing.predictionLeaderboardWinCardPadding,
      child: Row(
        children: [
          Container(
            width: AppSpacing.predictionLeaderboardWinIconBox,
            height: AppSpacing.predictionLeaderboardWinIconBox,
            decoration: BoxDecoration(
              color: AppColors.buy10,
              borderRadius: AppRadii.cardRadius,
            ),
            child: const Icon(
              Icons.emoji_events_outlined,
              color: AppColors.buy,
              size: AppSpacing.predictionLeaderboardWinIcon,
            ),
          ),
          const SizedBox(width: AppSpacing.predictionLeaderboardWinGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      trader.avatar,
                      style: const TextStyle(
                        fontSize: AppSpacing.predictionLeaderboardWinAvatar,
                      ),
                    ),
                    const SizedBox(
                      width: AppSpacing.predictionLeaderboardWinAvatarGap,
                    ),
                    Flexible(
                      child: Text(
                        trader.user,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: AppSpacing.predictionLeaderboardWinMarketGap,
                ),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        trader.biggestWinMarket ?? 'Prediction market',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.micro.copyWith(
                          color: event == null
                              ? AppColors.text3
                              : _predictionPrimary,
                        ),
                      ),
                    ),
                    if (event != null) ...[
                      const SizedBox(
                        width: AppSpacing.predictionLeaderboardWinMarketGap,
                      ),
                      const Icon(
                        Icons.arrow_outward_rounded,
                        color: _predictionPrimary,
                        size: AppSpacing.predictionLeaderboardWinMarketArrow,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          Text(
            _formatSignedCompact(trader.biggestWin ?? 0),
            style: AppTextStyles.caption.copyWith(
              color: AppColors.buy,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

Key _timeFilterKey(PredictionLeaderboardTimeFilter filter) {
  return switch (filter) {
    PredictionLeaderboardTimeFilter.today =>
      PredictionsLeaderboardPage.todayFilterKey,
    PredictionLeaderboardTimeFilter.weekly =>
      PredictionsLeaderboardPage.weeklyFilterKey,
    PredictionLeaderboardTimeFilter.monthly =>
      PredictionsLeaderboardPage.monthlyFilterKey,
    PredictionLeaderboardTimeFilter.allTime =>
      PredictionsLeaderboardPage.allTimeFilterKey,
  };
}

Color _winRateColor(int winRate) {
  if (winRate >= 70) return AppColors.buy;
  if (winRate >= 50) return AppColors.warn;
  return AppColors.sell;
}

String _formatSignedCompact(double value) {
  final sign = value >= 0 ? '+' : '-';
  return '$sign${_formatCurrencyCompact(value.abs())}';
}

String _formatCurrencyCompact(double value) {
  if (value >= 1000000) return '\$${(value / 1000000).toStringAsFixed(1)}M';
  if (value >= 1000) return '\$${(value / 1000).toStringAsFixed(1)}K';
  return '\$${value.toStringAsFixed(0)}';
}
