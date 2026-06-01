part of '../pages/product_governance_page.dart';

class _ComplianceNotice extends StatelessWidget {
  const _ComplianceNotice({required this.snapshot});

  final TradeProductGovernanceSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.check_circle_outline,
            color: AppColors.text1,
            size: 17,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'All Products Compliant',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontSize: 11,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${snapshot.products.length}/3 products have approved target markets. Next review: ${snapshot.nextReviewLabel}.',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text2,
                    fontSize: 10,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
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
    final approved = products
        .where((product) => product.status == 'approved')
        .length;
    const cards = [
      ('Total Products', '3', '2 approved', _govGreen),
      ('Reviews Due', '1', 'Within 3 months', _govAmber),
      ('Channels', '3', 'Active', AppColors.text3),
    ];
    return Row(
      children: [
        for (final card in cards) ...[
          Expanded(
            child: _StatCard(
              label: card.$1,
              value: card.$1 == 'Total Products'
                  ? products.length.toString()
                  : card.$2,
              helper: card.$1 == 'Total Products'
                  ? '$approved approved'
                  : card.$3,
              helperColor: card.$4,
            ),
          ),
          if (card != cards.last) const SizedBox(width: 12),
        ],
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.helper,
    required this.helperColor,
  });

  final String label;
  final String value;
  final String helper;
  final Color helperColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 89,
      padding: const EdgeInsets.fromLTRB(12, 14, 12, 12),
      decoration: BoxDecoration(
        color: _govPanel,
        border: Border.all(color: _govBorder.withValues(alpha: .72)),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 10,
              height: 1,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: AppTextStyles.body.copyWith(
              color: AppColors.text1,
              fontSize: 20,
              fontWeight: AppTextStyles.bold,
              height: 1,
            ),
          ),
          const Spacer(),
          Text(
            helper,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: helperColor,
              fontSize: 9,
              height: 1,
            ),
          ),
        ],
      ),
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
    return Container(
      height: 53,
      color: _govPanel,
      child: Row(
        children: [
          for (final tab in tabs)
            Expanded(
              child: InkWell(
                key: ProductGovernancePage.tabKey(tab.$1),
                onTap: () => onChanged(tab.$1),
                child: Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          tab.$2,
                          style: AppTextStyles.caption.copyWith(
                            color: activeId == tab.$1
                                ? _govPrimary
                                : AppColors.text3,
                            fontSize: 12,
                            fontWeight: AppTextStyles.bold,
                            height: 1,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: activeId == tab.$1 ? 100 : 0,
                      height: 2,
                      color: _govPrimary,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
