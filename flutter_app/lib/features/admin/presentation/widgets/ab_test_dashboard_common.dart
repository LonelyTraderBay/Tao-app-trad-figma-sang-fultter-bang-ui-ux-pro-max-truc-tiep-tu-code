part of '../pages/ab_test_dashboard.dart';

class _ExpandedDetails extends StatelessWidget {
  const _ExpandedDetails({required this.test});

  final AdminAbTestSummary test;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: _DetailStat(label: 'Z-Score', value: test.zScoreLabel),
            ),
            const SizedBox(width: AppSpacing.x4),
            Expanded(
              child: _DetailStat(label: 'P-Value', value: test.pValueLabel),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x4),
        DecoratedBox(
          decoration: const BoxDecoration(
            color: AppColors.warn08,
            borderRadius: AppRadii.inputRadius,
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.x3),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.error_outline_rounded,
                  color: AppColors.warn,
                  size: 16,
                ),
                const SizedBox(width: AppSpacing.x2),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cần thêm dữ liệu',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.warn,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                      Text(
                        'Độ tin cậy ${test.confidenceLabel} < 95%',
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
        ),
        const SizedBox(height: AppSpacing.x4),
        Row(
          children: [
            Text(
              'Kích thước mẫu',
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
            const Spacer(),
            Text(
              '${test.sampleSize} / ${test.minSampleSize}',
              style: AppTextStyles.caption.copyWith(
                fontWeight: AppTextStyles.bold,
                fontFamily: 'monospace',
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x2),
        ClipRRect(
          borderRadius: AppRadii.xsRadius,
          child: const SizedBox(
            height: 7,
            child: ColoredBox(color: AppColors.surface2),
          ),
        ),
      ],
    );
  }
}

class _DetailStat extends StatelessWidget {
  const _DetailStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          value,
          style: AppTextStyles.baseMedium.copyWith(
            fontSize: 15,
            fontFamily: 'monospace',
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _EmptyTestsCard extends StatelessWidget {
  const _EmptyTestsCard();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x6),
      child: Column(
        children: [
          const Icon(Icons.science_outlined, color: AppColors.text3, size: 48),
          const SizedBox(height: AppSpacing.x4),
          Text(
            'Chưa có A/B test nào',
            style: AppTextStyles.baseMedium.copyWith(
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            'Tạo test mới để bắt đầu thử nghiệm',
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

Color _variantAccent(AdminAbTestVariant variant) {
  if (variant.isWinner) return AppColors.buy;
  if (variant.isControl) return AppColors.accent;
  return AppColors.primary;
}
