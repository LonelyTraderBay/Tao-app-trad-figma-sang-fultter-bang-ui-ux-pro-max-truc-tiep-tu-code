part of '../pages/product_governance_page.dart';

class _ReviewsTab extends StatelessWidget {
  const _ReviewsTab({required this.products});

  final List<TradeCopyProduct> products;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Review Schedule',
      children: [
        _Card(
          padding: AppSpacing.productGovernanceCardPadding,
          child: Column(
            children: [
              for (final product in products) ...[
                _ReviewRow(product: product),
                if (product != products.last)
                  const SizedBox(height: AppSpacing.productGovernanceReviewGap),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _ReviewRow extends StatelessWidget {
  const _ReviewRow({required this.product});

  final TradeCopyProduct product;

  @override
  Widget build(BuildContext context) {
    final urgent = product.id == 'prod-3';
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.sm,
      padding: AppSpacing.productGovernanceReviewRowPadding,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                    height: AppSpacing.productGovernanceLineHeightTight,
                  ),
                ),
                const SizedBox(
                  height: AppSpacing.productGovernanceReviewTextGap,
                ),
                Text(
                  'Due: ${product.nextReview}',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    height: AppSpacing.productGovernanceLineHeightTight,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                urgent ? 'Due soon' : 'Scheduled',
                style: AppTextStyles.caption.copyWith(
                  color: urgent ? _govAmber : AppColors.text2,
                  fontWeight: AppTextStyles.bold,
                  height: AppSpacing.productGovernanceLineHeightTight,
                ),
              ),
              if (urgent) ...[
                const SizedBox(
                  height: AppSpacing.productGovernanceReviewActionGap,
                ),
                Text(
                  'Action needed',
                  style: AppTextStyles.micro.copyWith(
                    color: _govAmber,
                    height: AppSpacing.productGovernanceLineHeightTight,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _DistributionTab extends StatelessWidget {
  const _DistributionTab({required this.products});

  final List<TradeCopyProduct> products;

  @override
  Widget build(BuildContext context) {
    const channels = ['App', 'Web Platform', 'API'];
    return VitPageSection(
      label: 'Distribution Channels',
      customGap: AppSpacing.productGovernanceContentGap,
      children: [
        for (final channel in channels)
          _Card(
            padding: AppSpacing.productGovernanceDistributionCardPadding,
            child: Row(
              children: [
                VitCard(
                  width: AppSpacing.productGovernanceChannelIconBox,
                  height: AppSpacing.productGovernanceChannelIconBox,
                  variant: VitCardVariant.inner,
                  alignment: Alignment.center,
                  borderColor: _govPrimary.withValues(alpha: .35),
                  child: const Icon(
                    Icons.monitor_heart_outlined,
                    color: _govPrimary,
                    size: AppSpacing.productGovernanceActionIcon,
                  ),
                ),
                const SizedBox(width: AppSpacing.productGovernanceReviewGap),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        channel,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                          height: AppSpacing.productGovernanceLineHeightTight,
                        ),
                      ),
                      const SizedBox(
                        height: AppSpacing.productGovernanceReviewTextGap,
                      ),
                      Text(
                        '${_productCountForChannel(products, channel)} products',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                          height: AppSpacing.productGovernanceLineHeightTight,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.check_circle_outline,
                  color: _govGreen,
                  size: AppSpacing.productGovernanceChannelStatusIcon,
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({super.key, required this.child, required this.padding});

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: padding,
      borderColor: _govBorder.withValues(alpha: .72),
      child: child,
    );
  }
}

({Color color, String label}) _statusStyle(String status) {
  return switch (status) {
    'under-review' => (color: _govAmber, label: 'Under Review'),
    'restricted' => (color: _govRed, label: 'Restricted'),
    _ => (color: _govGreen, label: 'Approved'),
  };
}

({Color color, String label}) _riskStyle(String risk) {
  return switch (risk) {
    'medium' => (color: _govAmber, label: 'Medium Risk'),
    'low' => (color: _govGreen, label: 'Low Risk'),
    _ => (color: _govRed, label: 'High Risk'),
  };
}

int _productCountForChannel(List<TradeCopyProduct> products, String channel) {
  return products
      .where(
        (product) =>
            product.distributionChannels.any((item) => item.contains(channel)),
      )
      .length;
}
