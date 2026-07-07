part of '../pages/copy_trading_page.dart';

class _CopyHeroCard extends StatelessWidget {
  const _CopyHeroCard({required this.snapshot});

  final TradeCopyTradingSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: AppSpacing.cardPaddingCompact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tổng AUM',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      _formatCompact(snapshot.totalAum, prefix: r'$'),
                      style: AppTextStyles.heroNumber.copyWith(
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 1,
                height: AppSpacing.x6,
                color: AppColors.border,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: AppSpacing.x4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Người đang copy',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x1),
                      Text(
                        _formatCompactNumber(snapshot.totalCopiers),
                        style: AppTextStyles.heroNumber.copyWith(
                          color: _copyPrimary,
                          fontFeatures: AppTextStyles.tabularFigures,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            'Cập nhật ${snapshot.lastUpdatedLabel}',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3.withValues(alpha: .70),
            ),
          ),
        ],
      ),
    );
  }
}
