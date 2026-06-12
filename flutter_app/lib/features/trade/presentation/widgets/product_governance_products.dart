part of '../pages/product_governance_page.dart';

class _ProductsTab extends StatelessWidget {
  const _ProductsTab({required this.products});

  final List<TradeCopyProduct> products;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Copy Trading Products',
      customGap: 12,
      children: [
        for (final product in products) _ProductCard(product: product),
      ],
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.product});

  final TradeCopyProduct product;

  @override
  Widget build(BuildContext context) {
    final status = _statusStyle(product.status);
    final risk = _riskStyle(product.riskLevel);
    return _Card(
      key: ProductGovernancePage.productKey(product.id),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 9),
                    Row(
                      children: [
                        _Pill(label: status.label, color: status.color),
                        const SizedBox(width: 8),
                        _Pill(label: risk.label, color: risk.color),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              InkWell(
                key: ProductGovernancePage.targetMarketKey(product.id),
                onTap: () => context.go(
                  AppRoutePaths.tradeCopyTargetMarketDefinitionForProduct(
                    product.id,
                  ),
                ),
                borderRadius: AppRadii.cardRadius,
                child: VitCard(
                  width: 34,
                  height: 34,
                  variant: VitCardVariant.inner,
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.text3,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _TagSection(label: 'Target Market:', tags: product.targetMarket),
          const SizedBox(height: 15),
          _NegativeTarget(tags: product.negativeTarget),
          const SizedBox(height: 17),
          Row(
            children: [
              Expanded(
                child: _DateBox(
                  label: 'Last Review',
                  value: product.lastReview,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _DateBox(
                  label: 'Next Review',
                  value: product.nextReview,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TagSection extends StatelessWidget {
  const _TagSection({required this.label, required this.tags});

  final String label;
  final List<String> tags;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            height: 1,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            for (final tag in tags)
              VitCard(
                variant: VitCardVariant.inner,
                radius: VitCardRadius.sm,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: Text(
                  tag,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text2,
                    height: 1,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _NegativeTarget extends StatelessWidget {
  const _NegativeTarget({required this.tags});

  final List<String> tags;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Negative Target:',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            height: 1,
          ),
        ),
        const SizedBox(height: 9),
        Wrap(
          spacing: 18,
          runSpacing: 7,
          children: [
            for (final tag in tags)
              Text(
                tag,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                  height: 1,
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _DateBox extends StatelessWidget {
  const _DateBox({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.sm,
      height: 47,
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: 1,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}
