part of '../pages/savings_risk_assessment_page.dart';

class _StrategyMatchCard extends StatelessWidget {
  const _StrategyMatchCard({required this.strategyMatch});

  final String strategyMatch;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        children: [
          const Icon(
            Icons.auto_awesome_rounded,
            color: AppColors.primary,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Chiến lược phù hợp',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  strategyMatch,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductResultTile extends StatelessWidget {
  const _ProductResultTile({required this.product});

  final SavingsRiskProductDraft product;

  @override
  Widget build(BuildContext context) {
    final accent = _assetColor(product.asset);

    return VitCard(
      variant: VitCardVariant.inner,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        children: [
          _AssetBadge(asset: product.asset, color: accent),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Row(
                  children: [
                    Icon(
                      product.type == SavingsStrategyAllocationType.flexible
                          ? Icons.lock_open_rounded
                          : Icons.lock_outline_rounded,
                      color:
                          product.type == SavingsStrategyAllocationType.flexible
                          ? AppColors.buy
                          : AppColors.warn,
                      size: AppSpacing.iconSm,
                    ),
                    const SizedBox(width: AppSpacing.x1),
                    Expanded(
                      child: Text(
                        '${product.type == SavingsStrategyAllocationType.flexible ? 'Linh hoạt' : 'Cố định'} - ${product.risk}',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Text(
            product.apy,
            style: AppTextStyles.baseMedium.copyWith(
              color: AppColors.buy,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class _BulletRow extends StatelessWidget {
  const _BulletRow({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: AppSpacing.x3),
          child: SizedBox(
            width: AppSpacing.x1,
            height: AppSpacing.x1,
            child: DecoratedBox(
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              height: 1.5,
            ),
          ),
        ),
      ],
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
        color: color.withValues(alpha: 0.12),
        border: Border.all(color: color.withValues(alpha: 0.25)),
        borderRadius: AppRadii.xlRadius,
      ),
      child: SizedBox(
        width: AppSpacing.x7,
        height: AppSpacing.x7,
        child: Center(
          child: Text(
            asset,
            style: AppTextStyles.micro.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
              height: 1,
            ),
          ),
        ),
      ),
    );
  }
}

Color _profileAccent(SavingsRiskProfileLevel level) {
  return switch (level) {
    SavingsRiskProfileLevel.conservative => AppColors.buy,
    SavingsRiskProfileLevel.moderate => AppColors.warn,
    SavingsRiskProfileLevel.aggressive => AppColors.sell,
  };
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
