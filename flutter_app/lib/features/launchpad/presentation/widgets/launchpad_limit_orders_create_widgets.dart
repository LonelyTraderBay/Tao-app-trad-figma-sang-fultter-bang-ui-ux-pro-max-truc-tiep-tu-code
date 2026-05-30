part of '../pages/launchpad_limit_orders_page.dart';

class _CreateOrderSection extends StatelessWidget {
  const _CreateOrderSection({
    required this.orderSide,
    required this.tokenController,
    required this.targetPriceController,
    required this.amountController,
    required this.expiryDays,
    required this.partialFill,
    required this.submissionMessage,
    required this.onSideChanged,
    required this.onExpiryChanged,
    required this.onPartialFillChanged,
    required this.onInputChanged,
  });

  final LaunchpadLimitOrderSide orderSide;
  final TextEditingController tokenController;
  final TextEditingController targetPriceController;
  final TextEditingController amountController;
  final String expiryDays;
  final bool partialFill;
  final String? submissionMessage;
  final ValueChanged<LaunchpadLimitOrderSide> onSideChanged;
  final ValueChanged<String> onExpiryChanged;
  final ValueChanged<bool> onPartialFillChanged;
  final VoidCallback onInputChanged;

  @override
  Widget build(BuildContext context) {
    final hasPreview =
        targetPriceController.text.trim().isNotEmpty &&
        amountController.text.trim().isNotEmpty;
    return Container(
      key: LaunchpadLimitOrdersPage.createKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          VitPageSection(
            label: 'Loai lenh',
            accentColor: AppColors.primary,
            children: [
              Row(
                children: [
                  Expanded(
                    child: _SideChoice(
                      side: LaunchpadLimitOrderSide.buy,
                      active: orderSide == LaunchpadLimitOrderSide.buy,
                      onTap: () => onSideChanged(LaunchpadLimitOrderSide.buy),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: _SideChoice(
                      side: LaunchpadLimitOrderSide.sell,
                      active: orderSide == LaunchpadLimitOrderSide.sell,
                      onTap: () => onSideChanged(LaunchpadLimitOrderSide.sell),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          VitPageSection(
            label: 'Chi tiet lenh',
            accentColor: AppColors.primary,
            children: [
              VitCard(
                padding: const EdgeInsets.all(AppSpacing.x4),
                child: Column(
                  children: [
                    _LabeledField(
                      fieldKey: LaunchpadLimitOrdersPage.tokenFieldKey,
                      label: 'Token',
                      controller: tokenController,
                      hintText: 'ARB',
                      onChanged: onInputChanged,
                    ),
                    const SizedBox(height: AppSpacing.x4),
                    _LabeledField(
                      fieldKey: LaunchpadLimitOrdersPage.targetFieldKey,
                      label: 'Target Price (USD)',
                      controller: targetPriceController,
                      hintText: '0.00',
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      onChanged: onInputChanged,
                    ),
                    const SizedBox(height: AppSpacing.x4),
                    _LabeledField(
                      fieldKey: LaunchpadLimitOrdersPage.amountFieldKey,
                      label: 'Amount',
                      controller: amountController,
                      hintText: '0',
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      onChanged: onInputChanged,
                    ),
                    const SizedBox(height: AppSpacing.x4),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Expiry (days)',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text2,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x2),
                    Row(
                      children: [
                        for (final value in ['1', '7', '14', '30']) ...[
                          Expanded(
                            child: _ExpiryButton(
                              value: value,
                              active: expiryDays == value,
                              onTap: () => onExpiryChanged(value),
                            ),
                          ),
                          if (value != '30')
                            const SizedBox(width: AppSpacing.x2),
                        ],
                      ],
                    ),
                    const SizedBox(height: AppSpacing.x4),
                    const Divider(height: 1, color: AppColors.border),
                    const SizedBox(height: AppSpacing.x3),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Allow Partial Fill',
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.text1,
                                  fontWeight: AppTextStyles.bold,
                                ),
                              ),
                              Text(
                                'Cho phep khop mot phan',
                                style: AppTextStyles.micro.copyWith(
                                  color: AppColors.text3,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          key: LaunchpadLimitOrdersPage.partialFillKey,
                          value: partialFill,
                          activeThumbColor: AppColors.primary,
                          onChanged: onPartialFillChanged,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (hasPreview) ...[
            const SizedBox(height: AppSpacing.x4),
            _OrderPreview(
              side: orderSide,
              token: tokenController.text.trim(),
              targetPrice: targetPriceController.text.trim(),
              amount: amountController.text.trim(),
              expiryDays: expiryDays,
              partialFill: partialFill,
            ),
          ],
          if (submissionMessage != null) ...[
            const SizedBox(height: AppSpacing.x4),
            VitCard(
              padding: const EdgeInsets.all(AppSpacing.x3),
              borderColor: AppColors.buy20,
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle_outline_rounded,
                    color: AppColors.buy,
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Expanded(
                    child: Text(
                      submissionMessage!,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text2,
                        height: 1.45,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SideChoice extends StatelessWidget {
  const _SideChoice({
    required this.side,
    required this.active,
    required this.onTap,
  });

  final LaunchpadLimitOrderSide side;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isBuy = side == LaunchpadLimitOrderSide.buy;
    final color = isBuy ? AppColors.buy : AppColors.sell;
    return InkWell(
      key: LaunchpadLimitOrdersPage.sideKey(side),
      onTap: onTap,
      borderRadius: AppRadii.cardRadius,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.x4),
        decoration: BoxDecoration(
          color: active ? color.withValues(alpha: .10) : AppColors.surface,
          border: Border.all(color: active ? color : AppColors.cardBorder),
          borderRadius: AppRadii.cardRadius,
        ),
        child: Column(
          children: [
            Icon(
              isBuy ? Icons.south_rounded : Icons.north_rounded,
              color: active ? color : AppColors.text3,
            ),
            const SizedBox(height: AppSpacing.x2),
            Text(
              isBuy ? 'Buy' : 'Sell',
              style: AppTextStyles.base.copyWith(
                color: active ? color : AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.x1),
            Text(
              isBuy ? 'Mua khi gia xuong' : 'Ban khi gia len',
              textAlign: TextAlign.center,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ],
        ),
      ),
    );
  }
}

class _LabeledField extends StatelessWidget {
  const _LabeledField({
    required this.fieldKey,
    required this.label,
    required this.controller,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    required this.onChanged,
  });

  final Key fieldKey;
  final String label;
  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: AppColors.text2),
        ),
        const SizedBox(height: AppSpacing.x2),
        TextField(
          key: fieldKey,
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: keyboardType == TextInputType.text
              ? const []
              : [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
          onChanged: (_) => onChanged(),
          style: AppTextStyles.base.copyWith(color: AppColors.text1),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: AppTextStyles.base.copyWith(color: AppColors.text3),
            isDense: true,
            filled: true,
            fillColor: AppColors.bg,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.x4,
              vertical: AppSpacing.x3,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppRadii.inputRadius,
              borderSide: const BorderSide(color: AppColors.cardBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppRadii.inputRadius,
              borderSide: const BorderSide(color: AppColors.primary),
            ),
          ),
        ),
      ],
    );
  }
}

class _ExpiryButton extends StatelessWidget {
  const _ExpiryButton({
    required this.value,
    required this.active,
    required this.onTap,
  });

  final String value;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: LaunchpadLimitOrdersPage.expiryKey(value),
      onTap: onTap,
      borderRadius: AppRadii.inputRadius,
      child: Container(
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? AppColors.primary : AppColors.bg,
          borderRadius: AppRadii.inputRadius,
        ),
        child: Text(
          '${value}d',
          style: AppTextStyles.caption.copyWith(
            color: active ? AppColors.onAccent : AppColors.text1,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}

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

String _formatPrice(double value) => '\$${value.toStringAsFixed(2)}';

String _formatAmount(double value) {
  if (value == value.roundToDouble()) {
    return value.toStringAsFixed(0);
  }
  return value.toStringAsFixed(2);
}
