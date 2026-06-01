part of '../pages/product_governance_page.dart';

class _ReviewsTab extends StatelessWidget {
  const _ReviewsTab({required this.products});

  final List<TradeCopyProduct> products;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionLabel('Review Schedule'),
        const SizedBox(height: 12),
        _Card(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              for (final product in products) ...[
                _ReviewRow(product: product),
                if (product != products.last) const SizedBox(height: 12),
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
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _govPanel2,
        borderRadius: AppRadii.mdRadius,
      ),
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
                    fontSize: 12,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  'Due: ${product.nextReview}',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontSize: 10,
                    height: 1,
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
                  fontSize: 14,
                  fontWeight: AppTextStyles.bold,
                  height: 1,
                ),
              ),
              if (urgent) ...[
                const SizedBox(height: 6),
                Text(
                  'Action needed',
                  style: AppTextStyles.micro.copyWith(
                    color: _govAmber,
                    fontSize: 9,
                    height: 1,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionLabel('Distribution Channels'),
        const SizedBox(height: 12),
        for (final channel in channels) ...[
          _Card(
            padding: const EdgeInsets.all(13),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _govPrimary.withValues(alpha: .13),
                    borderRadius: AppRadii.inputRadius,
                  ),
                  child: const Icon(
                    Icons.monitor_heart_outlined,
                    color: _govPrimary,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        channel,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontSize: 13,
                          fontWeight: AppTextStyles.bold,
                          height: 1,
                        ),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        '${_productCountForChannel(products, channel)} products',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                          fontSize: 10,
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.check_circle_outline,
                  color: _govGreen,
                  size: 19,
                ),
              ],
            ),
          ),
          if (channel != channels.last) const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .14),
        borderRadius: BorderRadius.circular(5),
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

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 16,
          decoration: BoxDecoration(
            color: _govPrimary,
            borderRadius: BorderRadius.circular(999),
          ),
        ),
        const SizedBox(width: 7),
        Text(
          text,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontSize: 11,
            fontWeight: AppTextStyles.bold,
            height: 1,
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
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: _govPanel,
        border: Border.all(color: _govBorder.withValues(alpha: .72)),
        borderRadius: AppRadii.cardRadius,
      ),
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
