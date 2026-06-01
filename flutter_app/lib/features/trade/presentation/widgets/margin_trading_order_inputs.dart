part of '../pages/margin_trading_page.dart';

class _InputCard extends StatelessWidget {
  const _InputCard({
    required this.label,
    required this.suffix,
    required this.value,
  });

  final String label;
  final String suffix;
  final String value;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      minHeight: 90,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    fontSize: 12,
                  ),
                ),
              ),
              Text(
                suffix,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  fontSize: 10,
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          Text(
            value,
            style: AppTextStyles.baseMedium.copyWith(
              color: AppColors.onAccent,
              fontSize: 20,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class _PriceInput extends StatelessWidget {
  const _PriceInput({required this.price});

  final String price;

  @override
  Widget build(BuildContext context) {
    return _InputCard(label: 'Giá đặt lệnh', suffix: 'USDT', value: price);
  }
}

class _AmountInput extends StatelessWidget {
  const _AmountInput({required this.amount, required this.onMaxAmount});

  final String amount;
  final VoidCallback onMaxAmount;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      minHeight: 97,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Số lượng (BTC)',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    fontSize: 12,
                  ),
                ),
              ),
              InkWell(
                key: MarginTradingPage.maxAmountKey,
                onTap: onMaxAmount,
                borderRadius: AppRadii.smRadius,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: _marginPrimary.withValues(alpha: .08),
                    borderRadius: AppRadii.smRadius,
                  ),
                  child: Text(
                    'Tối đa',
                    style: AppTextStyles.micro.copyWith(
                      color: _marginPrimary,
                      fontSize: 11,
                      fontWeight: AppTextStyles.bold,
                      height: 1,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            amount,
            style: AppTextStyles.baseMedium.copyWith(
              color: AppColors.text2,
              fontSize: 21,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}
