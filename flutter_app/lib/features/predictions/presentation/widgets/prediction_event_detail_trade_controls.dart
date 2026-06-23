part of '../pages/prediction_event_detail_page.dart';

class _SegmentedToggle extends StatelessWidget {
  const _SegmentedToggle({
    required this.leftLabel,
    required this.rightLabel,
    required this.leftActive,
    required this.leftColor,
    required this.rightColor,
    required this.onLeft,
    required this.onRight,
  });

  final String leftLabel;
  final String rightLabel;
  final bool leftActive;
  final Color leftColor;
  final Color rightColor;
  final VoidCallback onLeft;
  final VoidCallback onRight;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface2,
      borderRadius: AppRadii.cardRadius,
      child: Padding(
        padding: AppSpacing.predictionDetailSegmentPadding,
        child: Row(
          children: [
            Expanded(
              child: _SegmentButton(
                label: leftLabel,
                active: leftActive,
                color: leftColor,
                onTap: onLeft,
              ),
            ),
            const SizedBox(width: AppSpacing.predictionDetailSegmentGap),
            Expanded(
              child: _SegmentButton(
                label: rightLabel,
                active: !leftActive,
                color: rightColor,
                onTap: onRight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SegmentButton extends StatelessWidget {
  const _SegmentButton({
    required this.label,
    required this.active,
    required this.color,
    required this.onTap,
  });

  final String label;
  final bool active;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitChoicePill(
      label: label,
      selected: active,
      onTap: onTap,
      accentColor: color,
      fullWidth: true,
      height: VitDensity.compact.controlHeight,
      padding: AppSpacing.zeroInsets,
    );
  }
}

class _SmallToggleChip extends StatelessWidget {
  const _SmallToggleChip({
    required this.label,
    required this.color,
    required this.active,
    required this.onTap,
  });

  final String label;
  final Color color;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitChoicePill(
      label: label,
      selected: active,
      onTap: onTap,
      accentColor: color,
      padding: AppSpacing.predictionDetailToggleChipPadding,
    );
  }
}

class _AmountChip extends StatelessWidget {
  const _AmountChip({
    required this.amount,
    required this.active,
    required this.onTap,
  });

  final String amount;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitChoicePill(
      label: '\$$amount',
      selected: active,
      onTap: onTap,
      accentColor: _predictionPrimary,
      fullWidth: true,
      height: VitDensity.compact.controlHeight,
      padding: AppSpacing.zeroInsets,
    );
  }
}

class _RiskLink extends StatelessWidget {
  const _RiskLink({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: PredictionEventDetailPage.riskLinkKey,
      onTap: onTap,
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.sm,
      child: SizedBox(
        height: VitDensity.compact.controlHeight,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.shield_outlined,
                color: AppColors.warn,
                size: AppSpacing.predictionDetailRiskIcon,
              ),
              const SizedBox(width: AppSpacing.predictionDetailRiskIconGap),
              Flexible(
                child: Text(
                  'Hiểu rủi ro trước khi giao dịch',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.warn,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.predictionDetailRiskChevronGap),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.warn,
                size: AppSpacing.predictionDetailRiskChevron,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
