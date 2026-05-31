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
    return GestureDetector(
      key: const Key('sc145_buy_crypto_buy'),
      onTap: enabled ? onTap : null,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 52,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: enabled ? _buyGreen : AppColors.surface3,
          borderRadius: AppRadii.inputRadius,
        ),
        child: Text(
          enabled ? 'Mua $symbol' : 'Nhập số tiền mua',
          style: AppTextStyles.baseMedium.copyWith(
            color: enabled ? AppColors.onAccent : AppColors.text3,
            fontSize: 15,
            fontWeight: FontWeight.w800,
            height: 1,
          ),
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
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: AppRadii.lgRadius,
            border: Border.all(color: AppColors.primary40),
          ),
          child: Column(
            children: [
              Text(
                'Bạn sẽ nhận được',
                style: AppTextStyles.caption.copyWith(color: AppColors.text2),
              ),
              const SizedBox(height: 10),
              Text(
                '${_formatCrypto(receiveAmount)} ${crypto.symbol}',
                style: AppTextStyles.sectionTitle.copyWith(color: _buyGreen),
              ),
              const SizedBox(height: 20),
              _RateRow(
                label: 'Thanh toán',
                value: '${_formatInt(amountVnd)} VND',
              ),
              const SizedBox(height: 12),
              _RateRow(label: 'Phương thức', value: payment.name),
              const SizedBox(height: 12),
              const _RateRow(
                label: 'Phí',
                value: 'Miễn phí',
                valueColor: _buyGreen,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _ActionButton(label: 'Xác nhận thanh toán', onTap: onConfirm),
        const SizedBox(height: 12),
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
                padding: const EdgeInsets.fromLTRB(20, 40, 20, 120),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 88,
                      height: 88,
                      decoration: BoxDecoration(
                        color: AppColors.buy10,
                        borderRadius: BorderRadius.circular(44),
                        border: Border.all(color: AppColors.buy20, width: 2),
                      ),
                      child: const Icon(
                        Icons.check_circle_outline_rounded,
                        color: _buyGreen,
                        size: 46,
                      ),
                    ),
                    const SizedBox(height: 22),
                    Text(
                      'Đặt lệnh thành công!',
                      style: AppTextStyles.sectionTitle.copyWith(fontSize: 22),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Lệnh mua ${_formatCrypto(receiveAmount)} ${crypto.symbol} từ ${_formatInt(amountVnd)} VND đã được đặt.',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _ActionButton(label: 'Về Ví', onTap: onWallet),
                    const SizedBox(height: 12),
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
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 52,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _buyPrimary,
          borderRadius: AppRadii.inputRadius,
        ),
        child: Text(
          label,
          style: AppTextStyles.baseMedium.copyWith(
            color: AppColors.onAccent,
            fontWeight: FontWeight.w800,
          ),
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
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 52,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _buyPanel2,
          borderRadius: AppRadii.inputRadius,
          border: Border.all(color: AppColors.borderSolid),
        ),
        child: Text(
          label,
          style: AppTextStyles.baseMedium.copyWith(
            color: AppColors.text2,
            fontWeight: FontWeight.w800,
          ),
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
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary08 : _buyPanel2,
          borderRadius: AppRadii.cardRadius,
          border: Border.all(
            color: selected ? _buyPrimary : AppColors.borderSolid,
          ),
        ),
        child: Row(
          children: [
            _CryptoLogo(option: option),
            const SizedBox(width: 12),
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
      ),
    );
  }
}

class _CryptoLogo extends StatelessWidget {
  const _CryptoLogo({required this.option, this.size = 40});

  final WalletBuyCryptoOption option;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Color(option.colorHex).withValues(alpha: .18),
        borderRadius: BorderRadius.circular(size / 2),
      ),
      alignment: Alignment.center,
      child: Text(
        option.symbol.length > 3
            ? option.symbol.substring(0, 3)
            : option.symbol,
        style: AppTextStyles.micro.copyWith(
          color: Color(option.colorHex),
          fontSize: size <= 26 ? 8 : 10,
          fontWeight: FontWeight.w800,
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
