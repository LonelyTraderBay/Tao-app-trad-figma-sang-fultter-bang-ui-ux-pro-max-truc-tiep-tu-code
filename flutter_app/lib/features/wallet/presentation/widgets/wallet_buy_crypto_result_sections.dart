part of 'wallet_buy_crypto_sections.dart';

class _BuyButton extends StatelessWidget {
  const _BuyButton({
    required this.enabled,
    required this.symbol,
    required this.onTap,
  });

  final bool enabled;
  final String symbol;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return VitCtaButton(
      key: const Key('sc145_buy_crypto_buy'),
      onPressed: enabled ? onTap : null,
      variant: VitCtaButtonVariant.success,
      height: AppSpacing.ctaHeight,
      child: Text(
          enabled ? 'Mua $symbol' : 'Nhập số tiền mua',
          style: AppTextStyles.baseMedium.copyWith(
            color: enabled ? AppColors.onAccent : AppColors.text3,
            fontWeight: AppTextStyles.bold,
          ),
        ),
    );
  }
}

class BuyConfirmContent extends StatelessWidget {
  const BuyConfirmContent({
    super.key,
    required this.crypto,
    required this.payment,
    required this.amountVnd,
    required this.receiveAmount,
    required this.onConfirm,
    required this.onBack,
  });

  final WalletBuyCryptoOption crypto;
  final WalletPaymentMethod payment;
  final int amountVnd;
  final double receiveAmount;
  final VoidCallback onConfirm;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitCard(
          padding: AppSpacing.walletBuyConfirmPadding,
          radius: VitCardRadius.lg,
          borderColor: AppColors.primary40,
          clip: true,
          background: const ColoredBox(color: AppColors.surface),
          child: Column(
            children: [
              Text(
                'Bạn sẽ nhận được',
                style: AppTextStyles.caption.copyWith(color: AppColors.text2),
              ),
              const SizedBox(height: AppSpacing.walletBuyCompactGap),
              Text(
                '${_formatCrypto(receiveAmount)} ${crypto.symbol}',
                style: AppTextStyles.sectionTitle.copyWith(color: _buyGreen),
              ),
              const SizedBox(height: AppSpacing.walletBuyConfirmAmountGap),
              _RateRow(
                label: 'Thanh toán',
                value: '${_formatInt(amountVnd)} VND',
              ),
              const SizedBox(height: AppSpacing.walletBuyInlineGap),
              _RateRow(label: 'Phương thức', value: payment.name),
              const SizedBox(height: AppSpacing.walletBuyInlineGap),
              const _RateRow(
                label: 'Phí',
                value: 'Miễn phí',
                valueColor: _buyGreen,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.walletBuySectionGap),
        _ActionButton(label: 'Xác nhận thanh toán', onTap: onConfirm),
        const SizedBox(height: AppSpacing.walletBuyInlineGap),
        _GhostButton(label: 'Quay lại chỉnh sửa', onTap: onBack),
      ],
    );
  }
}

class BuySuccessState extends StatelessWidget {
  const BuySuccessState({
    super.key,
    required this.crypto,
    required this.amountVnd,
    required this.receiveAmount,
    required this.onWallet,
    required this.onBuyMore,
  });

  final WalletBuyCryptoOption crypto;
  final int amountVnd;
  final double receiveAmount;
  final VoidCallback onWallet;
  final VoidCallback onBuyMore;

  @override
  Widget build(BuildContext context) {
    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-145 BuyCryptoPage Success',
      child: Material(
        color: _buyBackground,
        child: Column(
          children: [
            const VitHeader(
              title: 'Mua Crypto',
              subtitle: 'Giao dịch · Wallet',
            ),
            Expanded(
              child: Padding(
                padding: AppSpacing.walletBuySuccessPadding,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircleAvatar(
                      radius: AppSpacing.walletBuySuccessIconRadius,
                      backgroundColor: AppColors.buy10,
                      child: Icon(
                        Icons.check_circle_outline_rounded,
                        color: _buyGreen,
                        size: AppSpacing.walletBuySuccessGlyph,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.walletBuySuccessTitleGap),
                    Text(
                      'Đặt lệnh thành công!',
                      style: AppTextStyles.sectionTitle,
                    ),
                    const SizedBox(height: AppSpacing.walletBuyCompactGap),
                    Text(
                      'Lệnh mua ${_formatCrypto(receiveAmount)} ${crypto.symbol} từ ${_formatInt(amountVnd)} VND đã được đặt.',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.walletBuySuccessCtaGap),
                    _ActionButton(label: 'Về Ví', onTap: onWallet),
                    const SizedBox(height: AppSpacing.walletBuyInlineGap),
                    _GhostButton(label: 'Mua thêm', onTap: onBuyMore),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCtaButton(
      onPressed: onTap,
      variant: VitCtaButtonVariant.primary,
      height: AppSpacing.ctaHeight,
      child: Text(
        label,
        style: AppTextStyles.baseMedium.copyWith(
          color: AppColors.onAccent,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

class _GhostButton extends StatelessWidget {
  const _GhostButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCtaButton(
      onPressed: onTap,
      variant: VitCtaButtonVariant.ghost,
      height: AppSpacing.ctaHeight,
      child: Text(
        label,
        style: AppTextStyles.baseMedium.copyWith(
          color: AppColors.text2,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

class BuyCryptoOptionRow extends StatelessWidget {
  const BuyCryptoOptionRow({
    super.key,
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final WalletBuyCryptoOption option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      margin: AppSpacing.walletBuyOptionRowMargin,
      padding: AppSpacing.walletBuyOptionRowPadding,
      borderColor: selected ? _buyPrimary : AppColors.borderSolid,
      clip: true,
      background: ColoredBox(
        color: selected ? AppColors.primary08 : _buyPanel2,
      ),
      onTap: onTap,
      child: Row(
          children: [
            _CryptoLogo(option: option),
            const SizedBox(width: AppSpacing.walletBuyInlineGap),
            Expanded(
              child: Text(
                '${option.symbol} · ${option.name}',
                style: AppTextStyles.body,
              ),
            ),
            if (selected)
              const Icon(
                Icons.check_circle_rounded,
                color: _buyPrimary,
                size: 18,
              ),
          ],
        ),
    );
  }
}

class _CryptoLogo extends StatelessWidget {
  const _CryptoLogo({
    required this.option,
    this.size = AppSpacing.walletBuyCryptoLogoSize,
  });

  final WalletBuyCryptoOption option;
  final double size;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: size / 2,
      backgroundColor: Color(option.colorHex).withValues(alpha: .18),
      child: Text(
        option.symbol.length > 3
            ? option.symbol.substring(0, 3)
            : option.symbol,
        style: (size <= 26 ? AppTextStyles.micro : AppTextStyles.caption)
            .copyWith(
              color: Color(option.colorHex),
              fontFeatures: AppTextStyles.tabularFigures,
            ),
      ),
    );
  }
}

String _formatInt(int value) {
  final raw = value.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < raw.length; i++) {
    final reverseIndex = raw.length - i;
    buffer.write(raw[i]);
    if (reverseIndex > 1 && reverseIndex % 3 == 1) {
      buffer.write('.');
    }
  }
  return buffer.toString();
}

String _formatCrypto(double value) {
  if (value == 0) return '0';
  if (value < 1) return value.toStringAsFixed(8);
  return value.toStringAsFixed(4);
}
