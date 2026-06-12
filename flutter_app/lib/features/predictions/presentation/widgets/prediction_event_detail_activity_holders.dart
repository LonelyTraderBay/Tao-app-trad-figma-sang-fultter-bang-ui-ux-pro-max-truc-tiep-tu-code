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
            const SizedBox(width: 28, child: _OrderBookLabel('#')),
            const Expanded(child: _OrderBookLabel('TRADER')),
            const SizedBox(
              width: 54,
              child: _OrderBookLabel('SIDE', alignEnd: true),
            ),
            const SizedBox(
              width: 70,
              child: _OrderBookLabel('SHARES', alignEnd: true),
            ),
          ],
        ),
        const Padding(padding: EdgeInsets.only(top: 8)),
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
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 28,
            child: Icon(
              rank == 1 ? Icons.workspace_premium_rounded : Icons.circle,
              color: rank == 1 ? AppColors.warn : AppColors.text3,
              size: rank == 1 ? 15 : 6,
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
            width: 54,
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
            width: 70,
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
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: AppColors.surface2,
                    borderRadius: AppRadii.smRadius,
                  ),
                  child: const Icon(
                    Icons.flash_on_rounded,
                    color: _predictionPrimary,
                    size: 14,
                  ),
                ),
                const SizedBox(width: 10),
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
