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
            const SizedBox(width: AppSpacing.walletBuyGroupIconGap),
            Text(
              label,
              style: AppTextStyles.captionSm.copyWith(color: AppColors.text3),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.walletBuyPaymentCardGap),
        for (final method in methods) ...[
          _PaymentMethodCard(
            method: method,
            selected: method.id == selectedId,
            onTap: () => onChanged(method.id),
          ),
          const SizedBox(height: AppSpacing.walletBuyPaymentCardGap),
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
    return VitCard(
      key: Key('sc145_buy_crypto_payment_${method.id}'),
      onTap: onTap,
      variant: VitCardVariant.ghost,
      borderColor: AppColors.transparent,
      child: VitCard(
        height: AppSpacing.walletBuyPaymentCardHeight,
        padding: AppSpacing.walletBuyPaymentCardPadding,
        radius: VitCardRadius.sm,
        borderColor: selected ? _buyPrimary : AppColors.borderSolid,
        clip: true,
        background: ColoredBox(
          color: selected ? AppColors.primary08 : _buyPanel,
        ),
        child: Row(
          children: [
            VitCard(
              width: AppSpacing.walletBuyPaymentLogoSize,
              height: AppSpacing.walletBuyPaymentLogoSize,
              alignment: Alignment.center,
              radius: VitCardRadius.lg,
              clip: true,
              background: ColoredBox(
                color: Color(method.logoColorHex).withValues(alpha: .18),
              ),
              child: Text(
                method.logo,
                style: method.logo.length > 3
                    ? AppTextStyles.micro.copyWith(
                        color: Color(method.logoColorHex),
                      )
                    : AppTextStyles.badge.copyWith(
                        color: Color(method.logoColorHex),
                      ),
              ),
            ),
            const SizedBox(width: AppSpacing.cardGap),
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
                          style: AppTextStyles.captionSm,
                        ),
                      ),
                      if (method.isPopular) ...[
                        const SizedBox(
                          width: AppSpacing.walletBuyPaymentPopularGap,
                        ),
                        const _PopularBadge(),
                      ],
                    ],
                  ),
                  const SizedBox(height: AppSpacing.walletBuyGroupIconGap),
                  Row(
                    children: [
                      Icon(
                        instant
                            ? Icons.flash_on_rounded
                            : Icons.access_time_rounded,
                        color: instant ? _buyGreen : AppColors.text3,
                        size: 11,
                      ),
                      const SizedBox(width: AppSpacing.walletBuyPaymentMetaGap),
                      Text(
                        method.processingTime,
                        style: AppTextStyles.micro.copyWith(
                          height: AppSpacing.walletBuyMetaLineHeight,
                          color: instant ? _buyGreen : AppColors.text3,
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
    return VitCard(
      padding: AppSpacing.walletBuyPopularBadgePadding,
      radius: VitCardRadius.sm,
      clip: true,
      background: const ColoredBox(color: AppColors.buy10),
      child: Text(
        'Phổ biến',
        style: AppTextStyles.badge.copyWith(color: _buyGreen),
      ),
    );
  }
}

class _RadioMark extends StatelessWidget {
  const _RadioMark({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Icon(
      selected
          ? Icons.radio_button_checked_rounded
          : Icons.radio_button_unchecked_rounded,
      color: selected ? _buyPrimary : AppColors.borderSolid,
      size: AppSpacing.iconMd,
    );
  }
}

class _RateInfoCard extends StatelessWidget {
  const _RateInfoCard({required this.crypto, required this.payment});

  final WalletBuyCryptoOption crypto;
  final WalletPaymentMethod payment;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: AppSpacing.walletBuyRateInfoPadding,
      borderColor: AppColors.overlayStroke,
      clip: true,
      background: const ColoredBox(color: _buyPanel),
      child: Column(
        children: [
          _RateRow(
            label: 'Tỷ giá hiện tại',
            value: '1 ${crypto.symbol} = ${_formatInt(crypto.priceVnd)} VND',
          ),
          const SizedBox(height: AppSpacing.walletBuyInlineGap),
          const _RateRow(
            label: 'Phí giao dịch',
            value: 'Miễn phí',
            valueColor: _buyGreen,
          ),
          const SizedBox(height: AppSpacing.walletBuyInlineGap),
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
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
        ),
        Text(
          value,
          style: AppTextStyles.caption.copyWith(
            color: valueColor ?? AppColors.text1,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}
