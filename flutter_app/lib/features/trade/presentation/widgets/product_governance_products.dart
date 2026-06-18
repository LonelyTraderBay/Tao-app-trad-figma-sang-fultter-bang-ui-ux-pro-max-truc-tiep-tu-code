part of '../pages/product_governance_page.dart';

class _ProductsTab extends StatelessWidget {
  const _ProductsTab({required this.products});

  final List<TradeCopyProduct> products;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Copy Trading Products',
      customGap: AppSpacing.productGovernanceContentGap,
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
      padding: AppSpacing.productGovernanceCardPadding,
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
                        height: AppSpacing.productGovernanceLineHeightTight,
                      ),
                    ),
                    const SizedBox(
                      height: AppSpacing.productGovernanceReviewTextGap,
                    ),
                    Row(
                      children: [
                        VitAccentPill(
                          label: status.label,
                          accentColor: status.color,
                        ),
                        const SizedBox(
                          width: AppSpacing.productGovernancePillGap,
                        ),
                        VitAccentPill(
                          label: risk.label,
                          accentColor: risk.color,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.productGovernanceInlineGap),
              VitIconButton(
                key: ProductGovernancePage.targetMarketKey(product.id),
                onPressed: () => context.go(
                  AppRoutePaths.tradeCopyTargetMarketDefinitionForProduct(
                    product.id,
                  ),
                ),
                icon: Icons.chevron_right_rounded,
                tooltip: 'Open target market definition',
                variant: VitIconButtonVariant.ghost,
                size: VitIconButtonSize.sm,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x5),
          _TagSection(label: 'Target Market:', tags: product.targetMarket),
          const SizedBox(height: AppSpacing.productGovernanceTargetGap),
          _NegativeTarget(tags: product.negativeTarget),
          const SizedBox(height: AppSpacing.productGovernanceDateSectionGap),
          Row(
            children: [
              Expanded(
                child: _DateBox(
                  label: 'Last Review',
                  value: product.lastReview,
                ),
              ),
              const SizedBox(width: AppSpacing.productGovernanceInlineGap),
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
            height: AppSpacing.productGovernanceLineHeightTight,
          ),
        ),
        const SizedBox(height: AppSpacing.productGovernancePillGap),
        Wrap(
          spacing: AppSpacing.productGovernanceTagGap,
          runSpacing: AppSpacing.productGovernanceTagGap,
          children: [
            for (final tag in tags)
              VitAccentPill(label: tag, accentColor: AppColors.text2),
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
            height: AppSpacing.productGovernanceLineHeightTight,
          ),
        ),
        const SizedBox(height: AppSpacing.productGovernanceReviewTextGap),
        Wrap(
          spacing: AppSpacing.productGovernanceNegativeTagGap,
          runSpacing: AppSpacing.productGovernanceReviewTextGap,
          children: [
            for (final tag in tags)
              Text(
                tag,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                  height: AppSpacing.productGovernanceLineHeightTight,
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
      height: AppSpacing.productGovernanceDateBoxHeight,
      padding: AppSpacing.productGovernanceDateBoxPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: AppSpacing.productGovernanceLineHeightTight,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
              height: AppSpacing.productGovernanceLineHeightTight,
            ),
          ),
        ],
      ),
    );
  }
}
