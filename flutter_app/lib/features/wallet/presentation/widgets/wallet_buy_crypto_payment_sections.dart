part of 'wallet_buy_crypto_sections.dart';

class _PaymentMethodGroup extends StatelessWidget {
  const _PaymentMethodGroup({
    required this.icon,
    required this.label,
    required this.methods,
    required this.selectedId,
    required this.onChanged,
  });

  final IconData icon;
  final String label;
  final List<WalletPaymentMethod> methods;
  final String selectedId;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Icon(icon, color: AppColors.text3, size: 13),
            const SizedBox(width: 6),
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text3,
                fontSize: 12,
                height: 1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        for (final method in methods) ...[
          _PaymentMethodCard(
            method: method,
            selected: method.id == selectedId,
            onTap: () => onChanged(method.id),
          ),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class _PaymentMethodCard extends StatelessWidget {
  const _PaymentMethodCard({
    required this.method,
    required this.selected,
    required this.onTap,
  });

  final WalletPaymentMethod method;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final instant = method.type != WalletPaymentMethodType.bank;
    return GestureDetector(
      key: Key('sc145_buy_crypto_payment_${method.id}'),
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 64,
        padding: const EdgeInsets.fromLTRB(12, 10, 13, 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary08 : _buyPanel,
          borderRadius: AppRadii.inputRadius,
          border: Border.all(
            color: selected ? _buyPrimary : AppColors.borderSolid,
            width: 1.35,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Color(method.logoColorHex).withValues(alpha: .18),
                borderRadius: AppRadii.lgRadius,
              ),
              alignment: Alignment.center,
              child: Text(
                method.logo,
                style: AppTextStyles.micro.copyWith(
                  color: Color(method.logoColorHex),
                  fontSize: method.logo.length > 3 ? 9 : 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          method.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.baseMedium.copyWith(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            height: 1,
                          ),
                        ),
                      ),
                      if (method.isPopular) ...[
                        const SizedBox(width: 8),
                        const _PopularBadge(),
                      ],
                    ],
                  ),
                  const SizedBox(height: 9),
                  Row(
                    children: [
                      Icon(
                        instant
                            ? Icons.flash_on_rounded
                            : Icons.access_time_rounded,
                        color: instant ? _buyGreen : AppColors.text3,
                        size: 11,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        method.processingTime,
                        style: AppTextStyles.micro.copyWith(
                          color: instant ? _buyGreen : AppColors.text3,
                          fontSize: 11,
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            _RadioMark(selected: selected),
          ],
        ),
      ),
    );
  }
}

class _PopularBadge extends StatelessWidget {
  const _PopularBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.buy10,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Text(
        'Phổ biến',
        style: AppTextStyles.micro.copyWith(
          color: _buyGreen,
          fontSize: 11,
          fontWeight: FontWeight.w800,
          height: 1,
        ),
      ),
    );
  }
}

class _RadioMark extends StatelessWidget {
  const _RadioMark({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? _buyPrimary : AppColors.borderSolid,
          width: 2,
        ),
      ),
      alignment: Alignment.center,
      child: selected
          ? Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: _buyPrimary,
                shape: BoxShape.circle,
              ),
            )
          : null,
    );
  }
}

class _RateInfoCard extends StatelessWidget {
  const _RateInfoCard({required this.crypto, required this.payment});

  final WalletBuyCryptoOption crypto;
  final WalletPaymentMethod payment;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 15, 16, 15),
      decoration: BoxDecoration(
        color: _buyPanel,
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: AppColors.overlayStroke),
      ),
      child: Column(
        children: [
          _RateRow(
            label: 'Tỷ giá hiện tại',
            value: '1 ${crypto.symbol} = ${_formatInt(crypto.priceVnd)} VND',
          ),
          const SizedBox(height: 12),
          const _RateRow(
            label: 'Phí giao dịch',
            value: 'Miễn phí',
            valueColor: _buyGreen,
          ),
          const SizedBox(height: 12),
          _RateRow(
            label: 'Hạn mức ngày',
            value: '${payment.dailyLimitLabel} VND',
          ),
        ],
      ),
    );
  }
}

class _RateRow extends StatelessWidget {
  const _RateRow({required this.label, required this.value, this.valueColor});

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontSize: 13,
              height: 1,
            ),
          ),
        ),
        Text(
          value,
          style: AppTextStyles.caption.copyWith(
            color: valueColor ?? AppColors.text1,
            fontSize: 13,
            fontWeight: FontWeight.w800,
            height: 1,
          ),
        ),
      ],
    );
  }
}
