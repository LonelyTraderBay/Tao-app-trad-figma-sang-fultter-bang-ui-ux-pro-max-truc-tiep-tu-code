part of '../pages/dca_portfolio_optimizer_page.dart';

class _DriftBanner extends StatelessWidget {
  const _DriftBanner({
    required this.snapshot,
    required this.onDismiss,
    required this.onSettings,
  });

  final DcaPortfolioOptimizerSnapshot snapshot;
  final VoidCallback onDismiss;
  final VoidCallback onSettings;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: AppColors.sell20,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: AppSpacing.x7,
            height: AppSpacing.x7,
            decoration: BoxDecoration(
              color: AppColors.sell10,
              borderRadius: AppRadii.mdRadius,
              border: Border.all(color: AppColors.sell20),
            ),
            child: const Icon(
              Icons.warning_amber_rounded,
              color: AppColors.sell,
              size: AppSpacing.iconMd,
            ),
          ),
          const SizedBox(width: AppSpacing.x4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: AppSpacing.x3,
                  runSpacing: AppSpacing.x2,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      'Portfolio Drift Cao',
                      style: AppTextStyles.baseMedium.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    _SmallPill(
                      label: '${snapshot.driftPercent.toStringAsFixed(1)}%',
                      color: AppColors.sell,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  'Danh mục đã lệch ${snapshot.driftPercent.toStringAsFixed(1)}% so với phân bổ mục tiêu (ngưỡng: ${snapshot.driftThresholdPercent.toStringAsFixed(0)}%). Xem xét tái cân bằng.',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: AppSpacing.x3),
                Wrap(
                  spacing: AppSpacing.x3,
                  runSpacing: AppSpacing.x2,
                  children: [
                    _MiniButton(
                      key: DCAPortfolioOptimizer.driftSettingsKey,
                      label: 'Cài đặt',
                      icon: Icons.tune_rounded,
                      color: AppColors.sell,
                      onTap: onSettings,
                    ),
                    _MiniButton(
                      label: 'Tạm ẩn',
                      icon: Icons.visibility_off_outlined,
                      color: AppColors.text2,
                      onTap: onDismiss,
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onDismiss,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(
              minWidth: AppSpacing.x6,
              minHeight: AppSpacing.x6,
            ),
            icon: const Icon(
              Icons.close_rounded,
              color: AppColors.text3,
              size: AppSpacing.iconMd,
            ),
          ),
        ],
      ),
    );
  }
}
