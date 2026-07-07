part of '../pages/prediction_data_integration_page.dart';

class _CompactMetric extends StatelessWidget {
  const _CompactMetric({
    required this.label,
    required this.value,
    this.color = AppColors.text1,
    this.trailingIcon,
  });

  final String label;
  final String value;
  final Color color;
  final IconData? trailingIcon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            height: AppSpacing.predictionDataCompactLineHeight,
          ),
        ),
        const SizedBox(height: AppSpacing.x1),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: color,
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ),
            if (trailingIcon != null) ...[
              const SizedBox(width: AppSpacing.predictionDataMetricIconGap),
              Icon(
                trailingIcon,
                color: color,
                size: AppSpacing.predictionDataMetricIcon,
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class _MiniStatusPill extends StatelessWidget {
  const _MiniStatusPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: .14),
      borderRadius: AppRadii.smRadius,
      child: Padding(
        padding: AppSpacing.predictionDataStatusPillPadding,
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            height: AppSpacing.predictionDataCompactLineHeight,
          ),
        ),
      ),
    );
  }
}

class _NeutralChip extends StatelessWidget {
  const _NeutralChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface2,
      borderRadius: AppRadii.smRadius,
      child: Padding(
        padding: AppSpacing.predictionDataNeutralChipPadding,
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text2),
        ),
      ),
    );
  }
}

class _InlineIconButton extends StatelessWidget {
  const _InlineIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.color = AppColors.text3,
  });

  final IconData icon;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    // card-tile: allow-start — fixed surface, not horizontal strip tile
    return VitCard(
      width: AppSpacing.predictionDataInlineButtonSize,
      height: AppSpacing.predictionDataInlineButtonSize,
      onTap: onTap,
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.standard,
      padding: AppSpacing.zeroInsets,
      child: Icon(
        icon,
        color: color,
        size: AppSpacing.predictionDataInlineIcon,
      ),
    );
  }
}

class _IconBubble extends StatelessWidget {
  const _IconBubble({
    required this.icon,
    required this.color,
    required this.background,
  });

  final IconData icon;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: background,
      borderRadius: AppRadii.mdRadius,
      child: SizedBox.square(
        dimension: AppSpacing.predictionDataIconBubble,
        child: Icon(
          icon,
          color: color,
          size: AppSpacing.predictionDataIconBubbleIcon,
        ),
      ),
    );
  }
}

class _PrimaryBlueButton extends StatelessWidget {
  const _PrimaryBlueButton({
    super.key,
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return VitCtaButton(
      density: VitDensity.compact,
      leading: Icon(icon),
      onPressed: () {},
      child: Text(label),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.icon, required this.message});

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return _NoticeCard(icon: icon, color: _predictionPrimary, message: message);
  }
}

class _WarningCard extends StatelessWidget {
  const _WarningCard({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return _NoticeCard(
      icon: Icons.error_outline_rounded,
      color: AppColors.sell,
      message: message,
    );
  }
}

class _NoticeCard extends StatelessWidget {
  const _NoticeCard({
    required this.icon,
    required this.color,
    required this.message,
  });

  final IconData icon;
  final Color color;
  final String message;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: color.withValues(alpha: .18),
      density: VitDensity.compact,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: AppSpacing.predictionDataNoticeIcon),
          const SizedBox(width: AppSpacing.predictionDataNoticeGap),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text2,
                height: AppSpacing.predictionDataMetricLineHeight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Color _sourceStatusColor(PredictionDataSourceStatus status) {
  return switch (status) {
    PredictionDataSourceStatus.active => AppColors.buy,
    PredictionDataSourceStatus.inactive => AppColors.text3,
    PredictionDataSourceStatus.error => AppColors.sell,
  };
}

String _sourceStatusLabel(PredictionDataSourceStatus status) {
  return switch (status) {
    PredictionDataSourceStatus.active => 'ACTIVE',
    PredictionDataSourceStatus.inactive => 'INACTIVE',
    PredictionDataSourceStatus.error => 'ERROR',
  };
}

Color _apiKeyStatusColor(PredictionApiKeyStatus status) {
  return switch (status) {
    PredictionApiKeyStatus.active => AppColors.buy,
    PredictionApiKeyStatus.revoked => AppColors.sell,
  };
}

String _apiKeyStatusLabel(PredictionApiKeyStatus status) {
  return switch (status) {
    PredictionApiKeyStatus.active => 'ACTIVE',
    PredictionApiKeyStatus.revoked => 'REVOKED',
  };
}

Color _webhookStatusColor(PredictionWebhookStatus status) {
  return switch (status) {
    PredictionWebhookStatus.active => AppColors.buy,
    PredictionWebhookStatus.inactive => AppColors.text3,
  };
}

String _webhookStatusLabel(PredictionWebhookStatus status) {
  return switch (status) {
    PredictionWebhookStatus.active => 'ACTIVE',
    PredictionWebhookStatus.inactive => 'INACTIVE',
  };
}

String _formatPercent(double value) {
  if (value == value.roundToDouble()) {
    return '${value.toStringAsFixed(0)}%';
  }
  return '${value.toStringAsFixed(1)}%';
}

String _maskKey(String key) {
  final parts = key.split('_');
  if (parts.length >= 3) {
    return '${parts[0]}_${parts[1]}_${List.filled(parts[2].length, '*').join()}';
  }
  return List.filled(key.length, '*').join();
}
