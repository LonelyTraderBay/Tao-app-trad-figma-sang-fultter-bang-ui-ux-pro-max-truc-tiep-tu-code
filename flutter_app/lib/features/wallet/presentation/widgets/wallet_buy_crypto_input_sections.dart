part of 'wallet_buy_crypto_sections.dart';

class BuyInputContent extends StatelessWidget {
  const BuyInputContent({
    super.key,
    required this.snapshot,
    required this.selectedCrypto,
    required this.selectedPaymentId,
    required this.amountController,
    required this.amountVnd,
    required this.receiveAmount,
    required this.onAmountChanged,
    required this.onPreset,
    required this.onCryptoTap,
    required this.onPaymentChanged,
    required this.onBuy,
  });

  final WalletBuyCryptoSnapshot snapshot;
  final WalletBuyCryptoOption selectedCrypto;
  final String selectedPaymentId;
  final TextEditingController amountController;
  final int amountVnd;
  final double receiveAmount;
  final VoidCallback onAmountChanged;
  final ValueChanged<int> onPreset;
  final VoidCallback onCryptoTap;
  final ValueChanged<String> onPaymentChanged;
  final VoidCallback? onBuy;

  @override
  Widget build(BuildContext context) {
    final selectedPayment = snapshot.paymentMethods.firstWhere(
      (method) => method.id == selectedPaymentId,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _ZeroFeeBanner(),
        const SizedBox(height: 17),
        _AmountCard(
          snapshot: snapshot,
          selectedCrypto: selectedCrypto,
          amountController: amountController,
          amountVnd: amountVnd,
          receiveAmount: receiveAmount,
          onAmountChanged: onAmountChanged,
          onPreset: onPreset,
          onCryptoTap: onCryptoTap,
        ),
        const SizedBox(height: 19),
        Text('Phương thức thanh toán', style: AppTextStyles.baseMedium),
        const SizedBox(height: 18),
        _PaymentMethodGroup(
          icon: Icons.account_balance_rounded,
          label: 'Chuyển khoản ngân hàng',
          methods: snapshot.paymentMethods
              .where((method) => method.type == WalletPaymentMethodType.bank)
              .toList(),
          selectedId: selectedPaymentId,
          onChanged: onPaymentChanged,
        ),
        const SizedBox(height: 16),
        _PaymentMethodGroup(
          icon: Icons.phone_android_rounded,
          label: 'Ví điện tử',
          methods: snapshot.paymentMethods
              .where((method) => method.type != WalletPaymentMethodType.bank)
              .toList(),
          selectedId: selectedPaymentId,
          onChanged: onPaymentChanged,
        ),
        const SizedBox(height: 16),
        _RateInfoCard(crypto: selectedCrypto, payment: selectedPayment),
        const SizedBox(height: 16),
        _BuyButton(
          enabled: onBuy != null,
          symbol: selectedCrypto.symbol,
          onTap: onBuy,
        ),
      ],
    );
  }
}

class _ZeroFeeBanner extends StatelessWidget {
  const _ZeroFeeBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 57,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.buy.withValues(alpha: .08),
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: AppColors.buy20),
      ),
      child: Row(
        children: [
          const Icon(Icons.shield_outlined, color: _buyGreen, size: 15),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Mua trực tiếp bằng VND — Phí 0% — Nhận USDT tức thì',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                height: 1.45,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text('0% phí', style: AppTextStyles.badge.copyWith(color: _buyGreen)),
        ],
      ),
    );
  }
}

class _AmountCard extends StatelessWidget {
  const _AmountCard({
    required this.snapshot,
    required this.selectedCrypto,
    required this.amountController,
    required this.amountVnd,
    required this.receiveAmount,
    required this.onAmountChanged,
    required this.onPreset,
    required this.onCryptoTap,
  });

  final WalletBuyCryptoSnapshot snapshot;
  final WalletBuyCryptoOption selectedCrypto;
  final TextEditingController amountController;
  final int amountVnd;
  final double receiveAmount;
  final VoidCallback onAmountChanged;
  final ValueChanged<int> onPreset;
  final VoidCallback onCryptoTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 252),
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
      decoration: BoxDecoration(
        color: _buyPanel,
        borderRadius: AppRadii.lgRadius,
        border: Border.all(color: AppColors.overlayStroke),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Số tiền (VND)',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
              ),
              Text(
                'Số dư: 0 VND',
                style: AppTextStyles.captionSm.copyWith(
                  color: AppColors.text3,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ],
          ),
          const SizedBox(height: 21),
          Row(
            children: [
              Text(
                '₫',
                style: AppTextStyles.amountSm.copyWith(color: AppColors.text3),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  key: const Key('sc145_buy_crypto_amount'),
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (_) => onAmountChanged(),
                  style: AppTextStyles.amountMd.copyWith(
                    color: AppColors.text1,
                    fontFeatures: AppTextStyles.tabularFigures,
                    height: 1,
                  ),
                  decoration: InputDecoration(
                    hintText: '0',
                    hintStyle: AppTextStyles.amountMd.copyWith(
                      color: AppColors.text2,
                      fontFeatures: AppTextStyles.tabularFigures,
                      height: 1,
                    ),
                    border: InputBorder.none,
                    isCollapsed: true,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              for (var i = 0; i < snapshot.presetAmounts.length; i++) ...[
                Expanded(
                  child: _PresetChip(
                    amount: snapshot.presetAmounts[i],
                    selected:
                        amountController.text ==
                        snapshot.presetAmounts[i].toString(),
                    onTap: () => onPreset(snapshot.presetAmounts[i]),
                  ),
                ),
                if (i != snapshot.presetAmounts.length - 1)
                  const SizedBox(width: 8),
              ],
            ],
          ),
          const SizedBox(height: 17),
          _ReceivePanel(
            crypto: selectedCrypto,
            receiveAmount: receiveAmount,
            onCryptoTap: onCryptoTap,
          ),
        ],
      ),
    );
  }
}

class _PresetChip extends StatelessWidget {
  const _PresetChip({
    required this.amount,
    required this.selected,
    required this.onTap,
  });

  final int amount;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: Key('sc145_buy_crypto_preset_$amount'),
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 30,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? _buyPrimary : _buyPanel2,
          borderRadius: AppRadii.inputRadius,
          border: Border.all(
            color: selected ? _buyPrimary : AppColors.borderSolid,
          ),
        ),
        child: Text(
          '${amount ~/ 1000}K',
          style: AppTextStyles.badge.copyWith(
            color: selected ? AppColors.onAccent : AppColors.text2,
          ),
        ),
      ),
    );
  }
}

class _ReceivePanel extends StatelessWidget {
  const _ReceivePanel({
    required this.crypto,
    required this.receiveAmount,
    required this.onCryptoTap,
  });

  final WalletBuyCryptoOption crypto;
  final double receiveAmount;
  final VoidCallback onCryptoTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 66,
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
      decoration: BoxDecoration(
        color: _buyPanel2,
        borderRadius: AppRadii.cardRadius,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Bạn sẽ nhận được',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
                const SizedBox(height: 10),
                Text(
                  '${_formatCrypto(receiveAmount)} ${crypto.symbol}',
                  style: AppTextStyles.base.copyWith(
                    color: _buyGreen,
                    height: 1.1,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            key: const Key('sc145_buy_crypto_selector'),
            onTap: onCryptoTap,
            behavior: HitTestBehavior.opaque,
            child: Container(
              height: 42,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: _buyPanel,
                borderRadius: AppRadii.cardRadius,
                border: Border.all(color: AppColors.borderSolid),
              ),
              child: Row(
                children: [
                  _CryptoLogo(option: crypto, size: 25),
                  const SizedBox(width: 10),
                  Text(
                    crypto.symbol,
                    style: AppTextStyles.body.copyWith(
                      fontWeight: AppTextStyles.medium,
                    ),
                  ),
                  const SizedBox(width: 7),
                  const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: AppColors.text2,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
