part of 'savings_recommendations_page.dart';

class _CompareRow extends StatelessWidget {
  const _CompareRow({
    required this.label,
    required this.values,
    this.color,
    this.header = false,
  });

  final String label;
  final List<String> values;
  final Color? color;
  final bool header;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.earnVerticalPaddingX2,
      child: Row(
        children: [
          SizedBox(
            width: AppSpacing.savingsRecommendationsMatrixLabelWidth,
            child: Text(
              label,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ),
          for (final value in values)
            Expanded(
              child: Text(
                value,
                maxLines: header ? 2 : 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: AppTextStyles.micro.copyWith(
                  color: color ?? (header ? AppColors.text1 : AppColors.text2),
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SheetMetric extends StatelessWidget {
  const _SheetMetric({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.earnVerticalPaddingX2,
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(color: AppColors.text3),
            ),
          ),
          Text(
            value,
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class _AllocationDetailRow extends StatelessWidget {
  const _AllocationDetailRow({required this.item, required this.amount});

  final SavingsStrategyAllocationDraft item;
  final double amount;

  @override
  Widget build(BuildContext context) {
    final color = _assetColor(item.asset);
    return Row(
      children: [
        _AssetBadge(asset: item.asset, color: color),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.product,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.x1),
              Row(
                children: [
                  Icon(
                    item.type == SavingsStrategyAllocationType.flexible
                        ? Icons.lock_open_rounded
                        : Icons.lock_outline_rounded,
                    color: item.type == SavingsStrategyAllocationType.flexible
                        ? AppColors.buy
                        : AppColors.warn,
                    size: AppSpacing.iconSm,
                  ),
                  const SizedBox(width: AppSpacing.x1),
                  Expanded(
                    child: Text(
                      item.type == SavingsStrategyAllocationType.flexible
                          ? 'Linh hoạt'
                          : 'Cố định ${item.lockDays}D',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ),
                  Text(
                    '${_formatPercent(item.apy)} APY',
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.buy,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${item.percentage}%',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
            Text(
              _formatUsd(amount * item.percentage / 100),
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ],
        ),
      ],
    );
  }
}

class _BulletSection extends StatelessWidget {
  const _BulletSection({
    required this.title,
    required this.items,
    required this.color,
  });

  final String title;
  final List<String> items;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.x3),
        for (final item in items) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: AppSpacing.savingsRecommendationsBulletPadding,
                child: SizedBox.square(
                  dimension: AppSpacing.x1,
                  child: DecoratedBox(
                    decoration: ShapeDecoration(
                      color: color,
                      shape: const CircleBorder(),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  item,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: AppTextStyles.caption.height,
                  ),
                ),
              ),
            ],
          ),
          if (item != items.last) const SizedBox(height: AppSpacing.x2),
        ],
      ],
    );
  }
}

class _SmallPill extends StatelessWidget {
  const _SmallPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: color.withValues(alpha: 0.12),
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.mdRadius),
      ),
      child: Padding(
        padding: AppSpacing.earnSmallPillPadding,
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}

class _RoundIcon extends StatelessWidget {
  const _RoundIcon({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: color.withValues(alpha: 0.12),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadii.mdRadius,
          side: BorderSide(color: color.withValues(alpha: 0.22)),
        ),
      ),
      child: SizedBox(
        width: AppSpacing.x6,
        height: AppSpacing.x6,
        child: Icon(icon, color: color, size: AppSpacing.iconSm),
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
      decoration: ShapeDecoration(
        color: color.withValues(alpha: 0.12),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadii.xlRadius,
          side: BorderSide(color: color.withValues(alpha: 0.25)),
        ),
      ),
      child: SizedBox.square(
        dimension: AppSpacing.x7,
        child: Center(
          child: Text(
            asset,
            style: AppTextStyles.micro.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
              height: AppTextStyles.micro.height,
            ),
          ),
        ),
      ),
    );
  }
}

String _formatUsd(double value) {
  final rounded = value.abs() >= 1000
      ? value.toStringAsFixed(0)
      : value.toStringAsFixed(2);
  final parts = rounded.split('.');
  final whole = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    final fromEnd = whole.length - i;
    buffer.write(whole[i]);
    if (fromEnd > 1 && fromEnd % 3 == 1) buffer.write(',');
  }
  if (parts.length > 1) buffer.write('.${parts.last}');
  return '\$$buffer';
}

String _formatPercent(double value) {
  if (value == value.roundToDouble()) return '${value.toStringAsFixed(0)}%';
  return '${value.toStringAsFixed(1)}%';
}

Color _assetColor(String asset) {
  return switch (asset) {
    'USDT' => AppColors.buy,
    'BTC' => AppColors.warn,
    'SOL' => AppColors.accent,
    'ETH' => AppColors.primary,
    _ => AppColors.primary,
  };
}

String _riskToleranceLabel(SavingsProfileRiskTolerance value) {
  return switch (value) {
    SavingsProfileRiskTolerance.conservative => 'Thận trọng',
    SavingsProfileRiskTolerance.moderate => 'Trung bình',
    SavingsProfileRiskTolerance.aggressive => 'Tích cực',
  };
}

String _horizonLabel(SavingsInvestmentHorizon value) {
  return switch (value) {
    SavingsInvestmentHorizon.short => 'Ngắn hạn',
    SavingsInvestmentHorizon.medium => 'Trung hạn',
    SavingsInvestmentHorizon.long => 'Dài hạn',
  };
}

String _liquidityLabel(SavingsLiquidityNeed value) {
  return switch (value) {
    SavingsLiquidityNeed.high => 'Cao',
    SavingsLiquidityNeed.medium => 'Trung bình',
    SavingsLiquidityNeed.low => 'Thấp',
  };
}

String _strategyRiskLabel(SavingsStrategyRiskLevel value) {
  return switch (value) {
    SavingsStrategyRiskLevel.low => 'Thấp',
    SavingsStrategyRiskLevel.medium => 'Trung bình',
    SavingsStrategyRiskLevel.high => 'Cao',
  };
}

Color _strategyRiskColor(SavingsStrategyRiskLevel value) {
  return switch (value) {
    SavingsStrategyRiskLevel.low => AppColors.buy,
    SavingsStrategyRiskLevel.medium => AppColors.warn,
    SavingsStrategyRiskLevel.high => AppColors.sell,
  };
}

Color _insightColor(EarnRiskLevel tone) {
  return switch (tone) {
    EarnRiskLevel.low => AppColors.buy,
    EarnRiskLevel.medium => AppColors.primary,
    EarnRiskLevel.high => AppColors.warn,
  };
}

IconData _insightIcon(String iconKey) {
  return switch (iconKey) {
    'target' => Icons.track_changes_rounded,
    'calculator' => Icons.calculate_outlined,
    'shield' => Icons.shield_outlined,
    'clock' => Icons.schedule_rounded,
    _ => Icons.auto_awesome_rounded,
  };
}
