part of 'trade_page.dart';

class _LabelValue extends StatelessWidget {
  const _LabelValue({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: AppColors.text2),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontFeatures: AppTextStyles.tabularFigures,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class _TradeInput extends StatelessWidget {
  const _TradeInput({
    super.key,
    required this.label,
    required this.suffix,
    required this.controller,
    required this.onChanged,
  });

  final String label;
  final String suffix;
  final TextEditingController controller;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return VitInput(
      controller: controller,
      label: label,
      semanticLabel: label,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
      textStyle: AppTextStyles.baseMedium.copyWith(
        fontFeatures: AppTextStyles.tabularFigures,
      ),
      suffix: Text(
        suffix,
        style: AppTextStyles.caption.copyWith(
          color: AppColors.text3,
          fontWeight: AppTextStyles.bold,
        ),
      ),
      onChanged: (_) => onChanged(),
    );
  }
}

class _TpslSwitch extends StatelessWidget {
  const _TpslSwitch({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      padding: AppSpacing.cardPaddingCompact,
      variant: VitCardVariant.inner,
      borderColor: AppColors.borderSolid,
      child: Row(
        children: [
          const Icon(
            Icons.shield_outlined,
            color: AppColors.text3,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x2),
          Text(
            'TP/SL',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              'Take Profit / Stop Loss',
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppColors.buy,
          ),
        ],
      ),
    );
  }
}

class _FeeCard extends StatelessWidget {
  const _FeeCard({required this.preview});

  final TradeOrderPreview preview;

  @override
  Widget build(BuildContext context) {
    return VitFinancialSafetySummary(
      title: 'Order preview',
      density: VitDensity.compact,
      footer: 'Review price, amount, fee, and risk before sending this order.',
      items: [
        VitFinancialSafetyItem(
          label: 'Estimated total',
          value: '\$${preview.total.toStringAsFixed(2)}',
          leading: const Icon(Icons.payments_outlined),
        ),
        VitFinancialSafetyItem(
          label: 'Maker fee',
          value: '0.085% ~= \$${preview.fee.toStringAsFixed(2)}',
          leading: const Icon(Icons.receipt_long_outlined),
          valueColor: AppColors.text2,
        ),
        const VitFinancialSafetyItem(
          label: 'VIP tier',
          value: 'VIP 1 discount -5%',
          leading: Icon(Icons.workspace_premium_outlined),
          valueColor: AppColors.buy,
        ),
        const VitFinancialSafetyItem(
          label: 'Risk check',
          value: 'Preview before submit',
          leading: Icon(Icons.verified_user_outlined),
          valueColor: AppColors.warn,
        ),
      ],
    );
  }
}

class _OpenOrdersList extends StatelessWidget {
  const _OpenOrdersList({required this.orders});

  final List<TradeOpenOrder> orders;

  @override
  Widget build(BuildContext context) {
    return VitTradeOrderList(
      records: [
        for (final order in orders)
          VitTradeOrderRecord(
            id: order.id,
            symbol: order.symbol,
            sideLabel: order.side == TradeOrderSide.buy ? 'MUA' : 'BÁN',
            sideColor: order.side == TradeOrderSide.buy
                ? AppColors.buy
                : AppColors.sell,
            detail: '${order.amount} @ ${order.price.toStringAsFixed(2)}',
          ),
      ],
      emptyLabel: 'Chưa có lệnh đang mở',
    );
  }
}

class _HistoryList extends StatelessWidget {
  const _HistoryList();

  @override
  Widget build(BuildContext context) {
    return VitTradeOrderList(
      records: [
        VitTradeOrderRecord(
          id: 'hist-1',
          symbol: 'BTC/USDT',
          sideLabel: 'MUA',
          sideColor: AppColors.buy,
          detail: 'Đã khớp',
          onTap: () => context.go(AppRoutePaths.tradeOrderReceipt),
        ),
        VitTradeOrderRecord(
          id: 'hist-2',
          symbol: 'ETH/USDT',
          sideLabel: 'BÁN',
          sideColor: AppColors.sell,
          detail: 'Một phần',
          onTap: () => context.go(AppRoutePaths.tradeOrderReceipt),
        ),
      ],
    );
  }
}

String _formatPrice(double value) {
  final raw = value.toStringAsFixed(2);
  final parts = raw.split('.');
  final whole = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    final fromEnd = whole.length - i;
    buffer.write(whole[i]);
    if (fromEnd > 1 && fromEnd % 3 == 1) buffer.write(',');
  }
  return '$buffer.${parts.last}';
}

String _formatMoney(double value) => _formatPrice(value);
