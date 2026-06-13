part of '../pages/staking_earn_page.dart';

class _ProductList extends StatelessWidget {
  const _ProductList({required this.products});

  final List<EarnProductDraft> products;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final product in products) ...[
          _ProductCard(product: product),
          if (product != products.last) const SizedBox(height: AppSpacing.x3),
        ],
      ],
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.product});

  final EarnProductDraft product;

  @override
  Widget build(BuildContext context) {
    final riskColor = _riskColor(product.riskLevel);
    final accent = _productAccent(product);

    return VitCard(
      key: StakingEarnPage.productKey(product.id),
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _AssetBadge(asset: product.asset, color: accent),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: AppSpacing.x2,
                      runSpacing: AppSpacing.x1,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          product.name,
                          style: AppTextStyles.baseMedium.copyWith(
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                        if (product.isHot)
                          const _StatusBadge(
                            label: 'HOT',
                            color: AppColors.sell,
                            background: AppColors.sell10,
                          ),
                        if (product.isNew)
                          const _StatusBadge(
                            label: 'MOI',
                            color: AppColors.primary,
                            background: AppColors.primary12,
                          ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Row(
                      children: [
                        Icon(
                          _productTypeIcon(product.type),
                          color: _productTypeColor(product.type),
                          size: AppSpacing.iconSm,
                        ),
                        const SizedBox(width: AppSpacing.x1),
                        Expanded(
                          child: Text(
                            '${product.lockLabel} - ${product.participants}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.captionSm.copyWith(
                              color: AppColors.text2,
                            ),
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
                    product.apy,
                    style: AppTextStyles.amountXs.copyWith(
                      color: AppColors.buy,
                    ),
                  ),
                  Text(
                    'APY',
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                  if (product.boostApy != null)
                    Text(
                      product.boostApy!,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.warn,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Da staking: ${product.totalStaked}',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
              Text(
                'Rui ro: ${_riskLabel(product.riskLevel)}',
                style: AppTextStyles.micro.copyWith(
                  color: riskColor,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x2),
          _ProgressBar(progress: product.progress, color: accent),
        ],
      ),
    );
  }
}
