part of '../pages/product_governance_page.dart';

class _ComplianceNotice extends StatelessWidget {
  const _ComplianceNotice({required this.snapshot});

  final TradeProductGovernanceSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      padding: AppSpacing.cardPaddingCompact,
      borderColor: _govGreen.withValues(alpha: .24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.check_circle_outline,
            color: AppColors.text1,
            size: AppSpacing.inputPrefixIcon,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'All Products Compliant',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  '${snapshot.products.length}/3 products have approved target markets. Next review: ${snapshot.nextReviewLabel}.',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text2,
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

class _Stats extends StatelessWidget {
  const _Stats({required this.products});

  final List<TradeCopyProduct> products;

  @override
  Widget build(BuildContext context) {
    const cards = [
      ('Total Products', '3', '2 approved', _govGreen),
      ('Reviews Due', '1', 'Within 3 months', _govAmber),
      ('Channels', '3', 'Active', AppColors.text3),
    ];
    return Row(
      children: [
        for (final card in cards) ...[
          Expanded(
            child: VitMetricCard(
              label: card.$1,
              value: card.$1 == 'Total Products'
                  ? products.length.toString()
                  : card.$2,
              accentColor: card.$4,
            ),
          ),
          if (card != cards.last) const SizedBox(width: AppSpacing.x2),
        ],
      ],
    );
  }
}

class _Tabs extends StatelessWidget {
  const _Tabs({required this.activeId, required this.onChanged});

  final String activeId;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    const tabs = [
      ('products', 'Products'),
      ('reviews', 'Reviews'),
      ('distribution', 'Distribution'),
    ];
    return VitCard(
      density: VitDensity.compact,
      padding: AppSpacing.zeroInsets,
      child: VitTabBar(
        variant: VitTabBarVariant.underline,
        activeKey: activeId,
        tabs: [
          for (final tab in tabs)
            VitTabItem(
              key: tab.$1,
              label: tab.$2,
              widgetKey: ProductGovernancePage.tabKey(tab.$1),
            ),
        ],
        onChanged: onChanged,
      ),
    );
  }
}
