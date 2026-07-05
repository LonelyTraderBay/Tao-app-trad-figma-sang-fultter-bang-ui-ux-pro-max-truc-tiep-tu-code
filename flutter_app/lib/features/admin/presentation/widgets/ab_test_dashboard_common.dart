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
          decoration: const ShapeDecoration(
            color: AppColors.warn08,
            shape: RoundedRectangleBorder(borderRadius: AppRadii.inputRadius),
          ),
          child: Padding(
            padding: AppSpacing.adminCompactPadding,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.error_outline_rounded,
                  color: AppColors.warn,
                  size: AppSpacing.adminIconMd,
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
              style: AppTextStyles.numericCode.copyWith(
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x2),
        ClipRRect(
          borderRadius: AppRadii.xsRadius,
          child: const SizedBox(
            height: AppSpacing.adminProgressHeight,
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
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

Color _variantAccent(AdminAbTestVariant variant) {
  if (variant.isWinner) return AppColors.buy;
  if (variant.isControl) return AppColors.accent;
  return AppColors.primary;
}
