part of '../pages/copy_configuration_page.dart';

class _RiskToggle extends StatelessWidget {
  const _RiskToggle({
    required this.title,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          const Icon(Icons.shield_outlined, color: AppColors.text3, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Switch(
            value: value,
            activeThumbColor: _configurationPrimary,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _ValidationCard extends StatelessWidget {
  const _ValidationCard({required this.item});

  final TradeCopyConfigurationValidation item;

  @override
  Widget build(BuildContext context) {
    final color = switch (item.level) {
      TradeCopyConfigurationValidationLevel.error => _configurationRed,
      TradeCopyConfigurationValidationLevel.warning => AppColors.warn,
      TradeCopyConfigurationValidationLevel.info => _configurationPrimary,
    };

    return VitCard(
      variant: VitCardVariant.ghost,
      borderColor: color.withValues(alpha: .55),
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(_validationIcon(item.level), color: color, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              item.message,
              style: AppTextStyles.captionSm.copyWith(
                color: color,
                height: 1.35,
              ),
            ),
          ),
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
          Text(
            value,
            style: AppTextStyles.caption.copyWith(
              color: valueColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _PresetButton extends StatelessWidget {
  const _PresetButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.text2,
          side: const BorderSide(color: AppColors.borderSolid),
          shape: RoundedRectangleBorder(borderRadius: AppRadii.smRadius),
          padding: EdgeInsets.zero,
        ),
        child: Text(label, style: AppTextStyles.caption),
      ),
    );
  }
}

class _RiskPill extends StatelessWidget {
  const _RiskPill({required this.level});

  final TradeCopyRiskLevel level;

  @override
  Widget build(BuildContext context) {
    final color = switch (level) {
      TradeCopyRiskLevel.low => _configurationGreen,
      TradeCopyRiskLevel.medium => AppColors.warn,
      TradeCopyRiskLevel.high => _configurationRed,
    };

    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: .14),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(
          switch (level) {
            TradeCopyRiskLevel.low => 'Low',
            TradeCopyRiskLevel.medium => 'Medium',
            TradeCopyRiskLevel.high => 'High',
          },
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.extraBold,
          ),
        ),
      ),
    );
  }
}

String _modeLabel(TradeCopyConfigurationMode mode) {
  return switch (mode) {
    TradeCopyConfigurationMode.mirror => 'Mirror Copy',
    TradeCopyConfigurationMode.fixed => 'Fixed Ratio',
    TradeCopyConfigurationMode.smart => 'Smart Copy',
  };
}

String _modeDescription(TradeCopyConfigurationMode mode) {
  return switch (mode) {
    TradeCopyConfigurationMode.mirror =>
      'Sao chép chính xác tỷ lệ vị thế của provider.',
    TradeCopyConfigurationMode.fixed =>
      'Copy với tỷ lệ cố định để kiểm soát vốn tốt hơn.',
    TradeCopyConfigurationMode.smart =>
      'Tự điều chỉnh size theo volatility và risk.',
  };
}

IconData _validationIcon(TradeCopyConfigurationValidationLevel level) {
  return switch (level) {
    TradeCopyConfigurationValidationLevel.error => Icons.error_outline_rounded,
    TradeCopyConfigurationValidationLevel.warning =>
      Icons.warning_amber_rounded,
    TradeCopyConfigurationValidationLevel.info => Icons.info_outline_rounded,
  };
}
