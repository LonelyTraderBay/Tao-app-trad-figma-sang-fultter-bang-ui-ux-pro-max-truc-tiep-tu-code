part of '../pages/margin_trading_page.dart';

class _PriceComparison extends StatelessWidget {
  const _PriceComparison({required this.prices});

  final TradeMarginReferencePrices prices;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _SectionHeader(
            icon: Icons.show_chart_rounded,
            iconColor: _marginPrimary,
            title: 'Giá tham chiếu',
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.fromLTRB(13, 12, 13, 13),
            decoration: BoxDecoration(
              color: _marginPrimary.withValues(alpha: .06),
              borderRadius: AppRadii.cardRadius,
            ),
            child: Row(
              children: [
                Expanded(
                  child: _PriceColumn(
                    label: 'Mark Price',
                    value: _formatPriceWithDollar(prices.markPrice),
                    large: true,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: _marginPrimary.withValues(alpha: .12),
                    border: Border.all(
                      color: _marginPrimary.withValues(alpha: .35),
                    ),
                    borderRadius: AppRadii.mdRadius,
                  ),
                  child: Text(
                    'Dùng cho thanh lý',
                    style: AppTextStyles.micro.copyWith(
                      color: _marginPrimary,
                      fontSize: 9,
                      fontWeight: AppTextStyles.bold,
                      height: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 13),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _PriceColumn(
                  label: 'Last Price',
                  value: _formatPriceWithDollar(prices.lastPrice),
                ),
              ),
              Text(
                'Giá khớp lệnh gần nhất',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  fontSize: 9.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _PriceColumn(
                  label: 'Index Price',
                  value: _formatPriceWithDollar(prices.indexPrice),
                  dim: true,
                ),
              ),
              Text(
                'Avg của các sàn',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  fontSize: 9.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          _InfoBanner(
            text:
                'Mark Price được dùng để tính PnL và thanh lý, giúp tránh manipulation từ flash crash.',
          ),
        ],
      ),
    );
  }
}

class _PriceColumn extends StatelessWidget {
  const _PriceColumn({
    required this.label,
    required this.value,
    this.large = false,
    this.dim = false,
  });

  final String label;
  final String value;
  final bool large;
  final bool dim;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            fontSize: 10,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyles.body.copyWith(
            color: dim ? AppColors.text2 : AppColors.onAccent,
            fontSize: large ? 20 : 16,
            fontWeight: large ? AppTextStyles.bold : AppTextStyles.medium,
            fontFeatures: AppTextStyles.tabularFigures,
            height: 1.1,
          ),
        ),
      ],
    );
  }
}

class _PairCard extends StatelessWidget {
  const _PairCard({required this.snapshot});

  final TradeMarginTradingSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      minHeight: 104,
      padding: const EdgeInsets.fromLTRB(16, 15, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                snapshot.pair.symbol,
                style: AppTextStyles.baseMedium.copyWith(
                  fontSize: 17,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(width: 8),
              _MiniBadge(
                label: snapshot.defaultMode.toUpperCase(),
                color: _marginPrimary,
              ),
              const Spacer(),
              Container(
                width: 14,
                height: 8,
                decoration: BoxDecoration(
                  color: _marginRed.withValues(alpha: .06),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 26),
          Row(
            children: [
              Text(
                '--',
                style: AppTextStyles.sectionTitle.copyWith(
                  color: AppColors.onAccent,
                  fontSize: 28,
                  height: 1,
                ),
              ),
              const SizedBox(width: 9),
              Text(
                snapshot.pair.quoteAsset,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text3,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.icon,
    required this.iconColor,
    required this.title,
  });

  final IconData icon;
  final Color iconColor;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 18),
        const SizedBox(width: 8),
        Text(
          title,
          style: AppTextStyles.body.copyWith(
            color: AppColors.onAccent,
            fontSize: 15,
            fontWeight: AppTextStyles.bold,
            height: 1,
          ),
        ),
      ],
    );
  }
}
