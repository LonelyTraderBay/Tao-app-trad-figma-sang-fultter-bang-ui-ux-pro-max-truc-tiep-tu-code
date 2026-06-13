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
      padding: const EdgeInsets.all(12),
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            checked
                ? Icons.check_box_rounded
                : Icons.check_box_outline_blank_rounded,
            color: checked ? _confirmationPrimary : AppColors.text3,
            size: 22,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              item.label,
              style: AppTextStyles.captionSm.copyWith(
                color: AppColors.text1,
                height: 1.4,
              ),
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
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.schedule_rounded,
            color: _confirmationPrimary,
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Sau khi xác nhận, bạn có $hours giờ cooling-off để review lại quyết định trước khi copy chính thức kích hoạt.',
              style: AppTextStyles.captionSm.copyWith(
                color: _confirmationPrimary,
                height: 1.45,
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
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Điều gì xảy ra tiếp theo?',
            style: AppTextStyles.baseMedium.copyWith(
              fontWeight: AppTextStyles.extraBold,
            ),
          ),
          const SizedBox(height: 12),
          for (var index = 0; index < steps.length; index++) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 13,
                  backgroundColor: _confirmationPrimary.withValues(alpha: .16),
                  child: Text(
                    '${index + 1}',
                    style: AppTextStyles.micro.copyWith(
                      color: _confirmationPrimary,
                      fontWeight: AppTextStyles.extraBold,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    steps[index],
                    style: AppTextStyles.captionSm.copyWith(
                      color: AppColors.text2,
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
            if (index != steps.length - 1) const SizedBox(height: 10),
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
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              softWrap: true,
              style: AppTextStyles.caption.copyWith(
                color: valueColor,
                fontWeight: FontWeight.w700,
                height: 1.25,
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
