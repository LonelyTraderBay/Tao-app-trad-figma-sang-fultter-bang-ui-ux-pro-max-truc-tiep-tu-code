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
            fontSize: 10,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 6),
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
                  fontSize: 12,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ),
            if (trailingIcon != null) ...[
              const SizedBox(width: 5),
              Icon(trailingIcon, color: color, size: 12),
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .14),
        borderRadius: AppRadii.smRadius,
      ),
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontSize: 9,
          fontWeight: AppTextStyles.bold,
          height: 1,
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: AppRadii.smRadius,
      ),
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(color: AppColors.text2),
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
    return SizedBox(
      width: 30,
      height: 30,
      child: IconButton(
        onPressed: onTap,
        padding: EdgeInsets.zero,
        icon: Icon(icon, color: color, size: 15),
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
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: background,
        borderRadius: AppRadii.mdRadius,
      ),
      child: Icon(icon, color: color, size: 16),
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
    return SizedBox(
      height: 48,
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: _predictionPrimary,
          borderRadius: AppRadii.inputRadius,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.onAccent, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTextStyles.body.copyWith(
                color: AppColors.onAccent,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
      ),
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
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 15),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text2,
                height: 1.5,
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
