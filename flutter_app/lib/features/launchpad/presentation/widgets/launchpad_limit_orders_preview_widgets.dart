part of '../pages/launchpad_limit_orders_page.dart';

class _OrderPreview extends StatelessWidget {
  const _OrderPreview({
    required this.side,
    required this.token,
    required this.targetPrice,
    required this.amount,
    required this.expiryDays,
    required this.partialFill,
  });

  final LaunchpadLimitOrderSide side;
  final String token;
  final String targetPrice;
  final String amount;
  final String expiryDays;
  final bool partialFill;

  @override
  Widget build(BuildContext context) {
    final price = double.tryParse(targetPrice) ?? 0;
    final size = double.tryParse(amount) ?? 0;
    final sideLabel = side == LaunchpadLimitOrderSide.buy ? 'BUY' : 'SELL';
    return Container(
      key: LaunchpadLimitOrdersPage.previewKey,
      padding: const EdgeInsets.all(AppSpacing.x4),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: .10),
        border: Border.all(color: AppColors.primary20),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Preview',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              _PreviewMetric(label: 'Type', value: '$sideLabel $token'),
              _PreviewMetric(
                label: 'Total Value',
                value: '\$${(price * size).toStringAsFixed(2)}',
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              _PreviewMetric(label: 'Expires', value: '$expiryDays days'),
              _PreviewMetric(
                label: 'Partial',
                value: partialFill ? 'Yes' : 'No',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PreviewMetric extends StatelessWidget {
  const _PreviewMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 10,
            ),
          ),
          Text(
            value,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyOrders extends StatelessWidget {
  const _EmptyOrders();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x4,
        vertical: AppSpacing.x6,
      ),
      child: Column(
        children: [
          const Icon(Icons.schedule_rounded, color: AppColors.text3, size: 42),
          const SizedBox(height: AppSpacing.x3),
          Text(
            'No active orders',
            style: AppTextStyles.base.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            'Create a limit order to get started',
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}
