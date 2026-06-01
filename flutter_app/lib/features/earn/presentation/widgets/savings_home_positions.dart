part of '../pages/savings_page.dart';

class _SavingsPositions extends StatelessWidget {
  const _SavingsPositions({required this.positions});

  final List<SavingsPositionDraft> positions;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final position in positions) ...[
          VitCard(
            radius: VitCardRadius.lg,
            padding: const EdgeInsets.all(AppSpacing.x4),
            child: Row(
              children: [
                _AssetBadge(
                  asset: position.asset,
                  color: _riskColor(position.riskLevel),
                ),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        position.product,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                      Text(
                        '${position.amount} - ${position.apy} APY',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text2,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  position.earned,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.buy,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ],
            ),
          ),
          if (position != positions.last) const SizedBox(height: AppSpacing.x3),
        ],
      ],
    );
  }
}

class _RoundIcon extends StatelessWidget {
  const _RoundIcon({required this.tone});

  final EarnRiskLevel tone;

  @override
  Widget build(BuildContext context) {
    final color = _riskColor(tone);
    final icon = switch (tone) {
      EarnRiskLevel.low => Icons.repeat_rounded,
      EarnRiskLevel.medium => Icons.schedule_rounded,
      EarnRiskLevel.high => Icons.auto_awesome_rounded,
    };

    return DecoratedBox(
      decoration: BoxDecoration(
        color: _riskTint(tone),
        borderRadius: AppRadii.mdRadius,
      ),
      child: SizedBox(
        width: AppSpacing.x6,
        height: AppSpacing.x6,
        child: Icon(icon, color: color, size: AppSpacing.iconSm),
      ),
    );
  }
}

class _RiskPill extends StatelessWidget {
  const _RiskPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.buy10,
        borderRadius: AppRadii.xsRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x2,
          vertical: AppSpacing.x1,
        ),
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.buy,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}

class _AssetBadge extends StatelessWidget {
  const _AssetBadge({required this.asset, required this.color});

  final String asset;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface2,
        border: Border.all(color: color.withValues(alpha: 0.4)),
        borderRadius: AppRadii.mdRadius,
      ),
      child: SizedBox(
        width: AppSpacing.x7,
        height: AppSpacing.x7,
        child: Center(
          child: Text(
            asset.length > 3 ? asset.substring(0, 3) : asset,
            style: AppTextStyles.micro.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({
    required this.label,
    required this.color,
    required this.background,
  });

  final String label;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        borderRadius: AppRadii.xsRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x2,
          vertical: AppSpacing.x1,
        ),
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.progress, required this.color});

  final double progress;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: AppRadii.xlRadius,
      child: SizedBox(
        height: AppSpacing.x2,
        child: Stack(
          fit: StackFit.expand,
          children: [
            const ColoredBox(color: AppColors.surface3),
            FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress.clamp(0, 1),
              child: ColoredBox(color: color),
            ),
          ],
        ),
      ),
    );
  }
}
