part of '../pages/launchpad_batch_claim_page.dart';

class _BatchSummaryHero extends StatelessWidget {
  const _BatchSummaryHero({required this.summary});

  final LaunchpadBatchClaimSummaryDraft summary;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: LaunchpadBatchClaimPage.heroKey,
      variant: VitCardVariant.hero,
      radius: VitCardRadius.lg,
      borderColor: AppColors.buy.withValues(alpha: .18),
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.layers_outlined,
                color: AppColors.portfolioTextDim,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  'Tổng có thể nhận từ 2 vị trí',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.portfolioTextDim,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _formatUsd(summary.totalClaimableUsd),
                style: AppTextStyles.pageTitle.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.x1),
                child: Text(
                  'USD',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.portfolioTextMuted,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Wrap(
            spacing: AppSpacing.x2,
            runSpacing: AppSpacing.x2,
            children: [
              for (final entry in summary.totalClaimable.entries)
                _TokenPill(amount: entry.value, token: entry.key),
            ],
          ),
        ],
      ),
    );
  }
}

class _TokenPill extends StatelessWidget {
  const _TokenPill({required this.amount, required this.token});

  final double amount;
  final String token;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x1,
      ),
      decoration: BoxDecoration(
        color: AppColors.portfolioBtnGhost,
        borderRadius: AppRadii.inputRadius,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _formatNumber(amount),
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(width: AppSpacing.x1),
          Text(
            token,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.portfolioTextMuted,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _GasSavingsBanner extends StatelessWidget {
  const _GasSavingsBanner({required this.summary});

  final LaunchpadBatchClaimSummaryDraft summary;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: LaunchpadBatchClaimPage.gasKey,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x4,
        vertical: AppSpacing.x3,
      ),
      decoration: BoxDecoration(
        color: AppColors.buy.withValues(alpha: .08),
        border: Border.all(color: AppColors.buy.withValues(alpha: .18)),
        borderRadius: AppRadii.lgRadius,
      ),
      child: Row(
        children: [
          Container(
            width: AppSpacing.launchpadBox36,
            height: AppSpacing.launchpadBox36,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.buy15,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.local_gas_station_outlined,
              color: AppColors.buy,
              size: AppSpacing.iconMd,
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tiết kiệm ~${summary.gasSavingsPercent}% gas',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.buy,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  'Batch: ${summary.estimatedGasBatch} vs Riêng lẻ: ${summary.estimatedGasIndividual} (tiết kiệm ~${_formatUsd(summary.gasSavingsUsd)})',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
