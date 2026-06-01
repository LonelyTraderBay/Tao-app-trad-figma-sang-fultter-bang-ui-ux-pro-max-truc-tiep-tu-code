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
    const heights = [90.0, 110.0, 75.0];
    const colors = [
      AppColors.medalSilver,
      AppColors.medalGold,
      AppColors.medalBronze,
    ];
    const labels = ['2nd', '1st', '3rd'];

    return VitCard(
      padding: const EdgeInsets.fromLTRB(14, 16, 14, 0),
      child: SizedBox(
        height: 198,
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
        Text(trader.avatar, style: const TextStyle(fontSize: 22)),
        const SizedBox(height: 4),
        Text(
          trader.user,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text1,
            fontSize: 11,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          _formatSignedCompact(trader.pnl),
          style: AppTextStyles.caption.copyWith(
            color: AppColors.buy,
            fontSize: 12,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          height: height,
          margin: const EdgeInsets.symmetric(horizontal: 5),
          alignment: Alignment.bottomCenter,
          padding: const EdgeInsets.only(bottom: 13),
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
            borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (winner) ...[
                const Icon(
                  Icons.workspace_premium_rounded,
                  color: AppColors.medalGold,
                  size: 14,
                ),
                const SizedBox(width: 4),
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
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          const SizedBox(width: 32, child: _HeaderLabel('#')),
          const Expanded(child: _HeaderLabel('TRADER')),
          SizedBox(
            width: 84,
            child: Align(
              alignment: Alignment.centerRight,
              child: _HeaderLabel(
                metric == PredictionLeaderboardMetric.pnl ? 'P/L' : 'VOLUME',
              ),
            ),
          ),
          const SizedBox(
            width: 58,
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
        fontSize: 10,
        fontWeight: AppTextStyles.bold,
      ),
    );
  }
}
