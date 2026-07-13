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
          padding: AppSpacing.cardPaddingCompact,
          child: Column(
            children: [
              for (final product in products) ...[
                _ReviewRow(product: product),
                if (product != products.last)
                  const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
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
      radius: VitCardRadius.standard,
      density: VitDensity.compact,
      padding: AppSpacing.cardPaddingCompact,
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
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  'Due: ${product.nextReview}',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
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
                ),
              ),
              if (urgent) ...[
                const SizedBox(height: AppSpacing.x1),
                Text(
                  'Action needed',
                  style: AppTextStyles.micro.copyWith(color: _govAmber),
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
      density: VitDensity.compact,
      children: [
        for (final channel in channels)
          _Card(
            padding: AppSpacing.cardPaddingCompact,
            child: Row(
              children: [
                // card-tile: allow-start — fixed surface, not horizontal strip tile
                VitCard(
                  width: AppSpacing.buttonCompact,
                  height: AppSpacing.buttonCompact,
                  variant: VitCardVariant.inner,
                  alignment: Alignment.center,
                  borderColor: _govPrimary.withValues(alpha: .35),
                  child: const Icon(
                    Icons.monitor_heart_outlined,
                    color: _govPrimary,
                    size: AppSpacing.inputPrefixIcon,
                  ),
                ),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        channel,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x1),
                      Text(
                        '${_productCountForChannel(products, channel)} products',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.check_circle_outline,
                  color: _govGreen,
                  size: AppSpacing.inputPrefixIcon,
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
      density: VitDensity.compact,
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
