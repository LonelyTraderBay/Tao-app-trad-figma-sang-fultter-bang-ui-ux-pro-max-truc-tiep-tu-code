part of '../../pages/margin/margin_trading_page.dart';

class _OrderSummary extends StatelessWidget {
  const _OrderSummary({
    required this.available,
    required this.liquidationPrice,
  });

  final double available;
  final String liquidationPrice;

  @override
  Widget build(BuildContext context) {
    return VitFinancialSafetySummary(
      title: 'Margin order preview',
      contractId: 'SC-085 Margin preview',
      density: VitDensity.tool,
      footer:
          'Review margin, liquidation, fee, leverage limit, and side before opening a position.',
      items: [
        VitFinancialSafetyItem(
          label: 'Available margin',
          value: _formatMoney(available),
          leading: const Icon(Icons.account_balance_wallet_outlined),
          valueColor: AppColors.onAccent,
        ),
        VitFinancialSafetyItem(
          label: 'Liquidation estimate',
          value: liquidationPrice,
          leading: const Icon(Icons.warning_amber_rounded),
          valueColor: _marginRed,
        ),
        const VitFinancialSafetyItem(
          label: 'Trading fee',
          value: '0.05% preview',
          leading: Icon(Icons.receipt_long_outlined),
          valueColor: AppColors.text2,
        ),
        const VitFinancialSafetyItem(
          label: 'Risk check',
          value: 'Confirm leverage before submit',
          leading: Icon(Icons.verified_user_outlined),
          valueColor: _marginAmber,
        ),
      ],
    );
  }
}
