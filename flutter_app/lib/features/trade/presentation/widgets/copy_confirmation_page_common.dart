part of '../pages/copy_confirmation_page.dart';

class _ConsentTile extends StatelessWidget {
  const _ConsentTile({
    required this.item,
    required this.checked,
    required this.onTap,
  });

  final TradeCopyConsentItem item;
  final bool checked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: CopyConfirmationPage.consentKey(item.id),
      variant: checked ? VitCardVariant.standard : VitCardVariant.inner,
      borderColor: checked ? _confirmationPrimary : null,
      density: VitDensity.compact,
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            checked
                ? Icons.check_box_rounded
                : Icons.check_box_outline_blank_rounded,
            color: checked ? _confirmationPrimary : AppColors.text3,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              item.label,
              style: AppTextStyles.captionSm.copyWith(color: AppColors.text1),
            ),
          ),
        ],
      ),
    );
  }
}

class _CoolingOffCard extends StatelessWidget {
  const _CoolingOffCard({required this.hours});

  final int hours;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.ghost,
      borderColor: _confirmationPrimary,
      density: VitDensity.compact,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.schedule_rounded,
            color: _confirmationPrimary,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              'Sau khi xác nhận, bạn có $hours giờ cooling-off để review lại quyết định trước khi copy chính thức kích hoạt.',
              style: AppTextStyles.captionSm.copyWith(
                color: _confirmationPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NextStepsCard extends StatelessWidget {
  const _NextStepsCard({required this.snapshot});

  final TradeCopyConfirmationSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final steps = [
      'Khóa vốn \$${snapshot.configuration.copyCapital.toStringAsFixed(0)} trong tài khoản copy',
      '${snapshot.coolingOffHours}h cooling-off period',
      'Copy tự động bắt đầu sao chép lệnh của provider',
      'Theo dõi real-time P/L và dừng copy bất cứ lúc nào',
    ];
    return VitCard(
      density: VitDensity.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Điều gì xảy ra tiếp theo?',
            style: AppTextStyles.baseMedium.copyWith(
              fontWeight: AppTextStyles.extraBold,
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
          for (var index = 0; index < steps.length; index++) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: AppSpacing.x3,
                  backgroundColor: _confirmationPrimary.withValues(alpha: .16),
                  child: Text(
                    '${index + 1}',
                    style: AppTextStyles.micro.copyWith(
                      color: _confirmationPrimary,
                      fontWeight: AppTextStyles.extraBold,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.x2),
                Expanded(
                  child: Text(
                    steps[index],
                    style: AppTextStyles.captionSm.copyWith(
                      color: AppColors.text2,
                    ),
                  ),
                ),
              ],
            ),
            if (index != steps.length - 1)
              const SizedBox(height: AppSpacing.x2),
          ],
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(vertical: AppSpacing.x1),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ),
          const SizedBox(width: AppSpacing.x2),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              softWrap: true,
              style: AppTextStyles.caption.copyWith(
                color: valueColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String _copyModeLabel(TradeCopyConfigurationMode mode) {
  return switch (mode) {
    TradeCopyConfigurationMode.mirror => 'Mirror Copy',
    TradeCopyConfigurationMode.fixed => 'Fixed 50%',
    TradeCopyConfigurationMode.smart => 'Smart Copy',
  };
}

String _riskLabel(TradeCopyRiskLevel risk) {
  return switch (risk) {
    TradeCopyRiskLevel.low => 'Low',
    TradeCopyRiskLevel.medium => 'Medium',
    TradeCopyRiskLevel.high => 'High',
  };
}
