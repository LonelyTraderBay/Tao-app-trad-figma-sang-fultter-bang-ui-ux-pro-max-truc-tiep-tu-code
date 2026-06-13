part of '../pages/predictions_leaderboard_page.dart';

class _Podium extends StatelessWidget {
  const _Podium({required this.traders});

  final List<PredictionLeaderboardTraderDraft> traders;

  @override
  Widget build(BuildContext context) {
    final ordered = [
      if (traders.length > 1) traders[1],
      if (traders.isNotEmpty) traders[0],
      if (traders.length > 2) traders[2],
    ];
    final heights = AppSpacing.predictionLeaderboardPodiumHeights;
    const colors = [
      AppColors.medalSilver,
      AppColors.medalGold,
      AppColors.medalBronze,
    ];
    const labels = ['2nd', '1st', '3rd'];

    return VitCard(
      padding: AppSpacing.predictionLeaderboardPodiumPadding,
      child: SizedBox(
        height: AppSpacing.predictionLeaderboardPodiumHeight,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            for (var index = 0; index < ordered.length; index += 1)
              Expanded(
                child: _PodiumColumn(
                  trader: ordered[index],
                  height: heights[index],
                  color: colors[index],
                  label: labels[index],
                  winner: index == 1,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _PodiumColumn extends StatelessWidget {
  const _PodiumColumn({
    required this.trader,
    required this.height,
    required this.color,
    required this.label,
    required this.winner,
  });

  final PredictionLeaderboardTraderDraft trader;
  final double height;
  final Color color;
  final String label;
  final bool winner;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(trader.avatar, style: AppTextStyles.avatarLg),
        const SizedBox(height: AppSpacing.predictionLeaderboardPodiumAvatarGap),
        Text(
          trader.user,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text1,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.predictionLeaderboardPodiumUserGap),
        Text(
          _formatSignedCompact(trader.pnl),
          style: AppTextStyles.caption.copyWith(
            color: AppColors.buy,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
        const SizedBox(height: AppSpacing.predictionLeaderboardPodiumValueGap),
        Container(
          height: height,
          margin: AppSpacing.predictionLeaderboardPodiumColumnMargin,
          alignment: Alignment.bottomCenter,
          padding: AppSpacing.predictionLeaderboardPodiumColumnPadding,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                color.withValues(alpha: .18),
                color.withValues(alpha: .04),
              ],
            ),
            border: Border.all(color: color.withValues(alpha: .28)),
            borderRadius: const BorderRadius.vertical(
              top: AppRadii.inputCorner,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (winner) ...[
                const Icon(
                  Icons.workspace_premium_rounded,
                  color: AppColors.medalGold,
                  size: AppSpacing.predictionLeaderboardWinnerIcon,
                ),
                const SizedBox(
                  width: AppSpacing.predictionLeaderboardWinnerGap,
                ),
              ],
              Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: color,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Rankings extends StatelessWidget {
  const _Rankings({required this.snapshot});

  final PredictionLeaderboardSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Rankings',
      accentColor: AppColors.warn,
      children: [
        VitCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              _RankingHeader(metric: snapshot.metric),
              for (var index = 0; index < snapshot.traders.length; index += 1)
                _RankingRow(
                  key: PredictionsLeaderboardPage.traderKey(
                    snapshot.traders[index].user,
                  ),
                  trader: snapshot.traders[index],
                  metric: snapshot.metric,
                  last: index == snapshot.traders.length - 1,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RankingHeader extends StatelessWidget {
  const _RankingHeader({required this.metric});

  final PredictionLeaderboardMetric metric;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSpacing.predictionLeaderboardRankingHeaderHeight,
      padding: AppSpacing.predictionLeaderboardRankingPadding,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          const SizedBox(
            width: AppSpacing.predictionLeaderboardRankWidth,
            child: _HeaderLabel('#'),
          ),
          const Expanded(child: _HeaderLabel('TRADER')),
          SizedBox(
            width: AppSpacing.predictionLeaderboardMetricWidth,
            child: Align(
              alignment: Alignment.centerRight,
              child: _HeaderLabel(
                metric == PredictionLeaderboardMetric.pnl ? 'P/L' : 'VOLUME',
              ),
            ),
          ),
          const SizedBox(
            width: AppSpacing.predictionLeaderboardWinRateWidth,
            child: Align(
              alignment: Alignment.centerRight,
              child: _HeaderLabel('WIN %'),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderLabel extends StatelessWidget {
  const _HeaderLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.micro.copyWith(
        color: AppColors.text3,
        fontWeight: AppTextStyles.bold,
      ),
    );
  }
}
