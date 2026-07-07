part of '../pages/prediction_event_detail_page.dart';

class _HoldersContent extends StatelessWidget {
  const _HoldersContent({required this.snapshot});

  final PredictionEventDetailSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const SizedBox(
              width: PredictionsSpacingTokens
                  .predictionDetailHolderRankColumnWidth,
              child: _OrderBookLabel('#'),
            ),
            const Expanded(child: _OrderBookLabel('TRADER')),
            const SizedBox(
              width: PredictionsSpacingTokens
                  .predictionDetailHolderSideColumnWidth,
              child: _OrderBookLabel('SIDE', alignEnd: true),
            ),
            const SizedBox(
              width: PredictionsSpacingTokens
                  .predictionDetailHolderSharesColumnWidth,
              child: _OrderBookLabel('SHARES', alignEnd: true),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        for (var index = 0; index < snapshot.topHolders.length; index += 1)
          _HolderRow(rank: index + 1, holder: snapshot.topHolders[index]),
      ],
    );
  }
}

class _HolderRow extends StatelessWidget {
  const _HolderRow({required this.rank, required this.holder});

  final int rank;
  final PredictionHolderDraft holder;

  @override
  Widget build(BuildContext context) {
    final color = holder.outcome == 'Yes' ? AppColors.buy : AppColors.sell;
    return Padding(
      padding: PredictionsSpacingTokens.predictionDetailHolderRowPadding,
      child: Row(
        children: [
          SizedBox(
            width:
                PredictionsSpacingTokens.predictionDetailHolderRankColumnWidth,
            child: Icon(
              rank == 1 ? Icons.workspace_premium_rounded : Icons.circle,
              color: rank == 1 ? AppColors.warn : AppColors.text3,
              size: rank == 1
                  ? PredictionsSpacingTokens.predictionDetailHolderWinnerIcon
                  : PredictionsSpacingTokens.predictionDetailHolderDefaultIcon,
            ),
          ),
          Expanded(
            child: Text(
              holder.name,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          SizedBox(
            width:
                PredictionsSpacingTokens.predictionDetailHolderSideColumnWidth,
            child: Align(
              alignment: Alignment.centerRight,
              child: _TinyBadge(
                label: holder.outcome,
                color: color,
                background: color.withValues(alpha: .12),
              ),
            ),
          ),
          SizedBox(
            width: PredictionsSpacingTokens
                .predictionDetailHolderSharesColumnWidth,
            child: Text(
              _formatInt(holder.shares),
              textAlign: TextAlign.end,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text2,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivityContent extends StatelessWidget {
  const _ActivityContent({required this.snapshot});

  final PredictionEventDetailSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final item in snapshot.activity)
          Padding(
            padding:
                PredictionsSpacingTokens.predictionDetailActivityRowPadding,
            child: Row(
              children: [
                Material(
                  color: AppColors.surface2,
                  borderRadius: AppRadii.smRadius,
                  child: const SizedBox.square(
                    dimension: PredictionsSpacingTokens
                        .predictionDetailActivityIconBox,
                    child: Icon(
                      Icons.flash_on_rounded,
                      color: _predictionPrimary,
                      size:
                          PredictionsSpacingTokens.predictionDetailActivityIcon,
                    ),
                  ),
                ),
                const SizedBox(
                  width:
                      PredictionsSpacingTokens.predictionDetailActivityIconGap,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${item.actor} ${item.action}',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                      Text(
                        item.amount,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  item.time,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
