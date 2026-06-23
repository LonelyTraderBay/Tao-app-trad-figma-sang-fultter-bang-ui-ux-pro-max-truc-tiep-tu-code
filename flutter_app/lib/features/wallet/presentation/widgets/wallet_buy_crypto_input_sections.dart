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
        const SizedBox(height: AppSpacing.walletBuyBannerGap),
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
        const SizedBox(height: AppSpacing.walletBuyAmountCardGap),
        Text('Phương thức thanh toán', style: AppTextStyles.baseMedium),
        const SizedBox(height: AppSpacing.walletBuyPaymentTitleGap),
        _PaymentMethodGroup(
          icon: Icons.account_balance_rounded,
          label: 'Chuyển khoản ngân hàng',
          methods: snapshot.paymentMethods
              .where((method) => method.type == WalletPaymentMethodType.bank)
              .toList(),
          selectedId: selectedPaymentId,
          onChanged: onPaymentChanged,
        ),
        const SizedBox(height: AppSpacing.walletBuySectionGap),
        _PaymentMethodGroup(
          icon: Icons.phone_android_rounded,
          label: 'Ví điện tử',
          methods: snapshot.paymentMethods
              .where((method) => method.type != WalletPaymentMethodType.bank)
              .toList(),
          selectedId: selectedPaymentId,
          onChanged: onPaymentChanged,
        ),
        const SizedBox(height: AppSpacing.walletBuySectionGap),
        _RateInfoCard(crypto: selectedCrypto, payment: selectedPayment),
        const SizedBox(height: AppSpacing.walletBuySectionGap),
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
    return VitCard(
      height: AppSpacing.walletBuyBannerHeight,
      padding: AppSpacing.walletBuyBannerPadding,
      borderColor: AppColors.buy20,
      clip: true,
      background: ColoredBox(color: AppColors.buy.withValues(alpha: .08)),
      child: Row(
        children: [
          const Icon(Icons.shield_outlined, color: _buyGreen, size: 15),
          const SizedBox(width: AppSpacing.walletBuyInlineGap),
          Expanded(
            child: Text(
              'Mua trực tiếp bằng VND — Phí 0% — Nhận USDT tức thì',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                height: AppSpacing.walletBuyBannerLineHeight,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.walletBuyCompactGap),
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
    return VitCard(
      constraints: const BoxConstraints(
        minHeight: AppSpacing.walletBuyAmountCardMinHeight,
      ),
      padding: AppSpacing.walletBuyAmountCardPadding,
      radius: VitCardRadius.lg,
      borderColor: AppColors.overlayStroke,
      clip: true,
      background: const ColoredBox(color: _buyPanel),
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
          const SizedBox(height: AppSpacing.walletBuyAmountLabelGap),
          Row(
            children: [
              Text(
                '₫',
                style: AppTextStyles.amountSm.copyWith(color: AppColors.text3),
              ),
              const SizedBox(width: AppSpacing.walletBuyCompactGap),
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
                    height: AppSpacing.walletBuyAmountLineHeight,
                  ),
                  decoration: InputDecoration(
                    hintText: '0',
                    hintStyle: AppTextStyles.amountMd.copyWith(
                      color: AppColors.text2,
                      fontFeatures: AppTextStyles.tabularFigures,
                      height: AppSpacing.walletBuyAmountLineHeight,
                    ),
                    border: InputBorder.none,
                    isCollapsed: true,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.walletBuyPresetGap),
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
                  const SizedBox(width: AppSpacing.walletBuyPaymentPopularGap),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.walletBuyReceiveGap),
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
    return VitChoicePill(
      key: Key('sc145_buy_crypto_preset_$amount'),
      label: '${amount ~/ 1000}K',
      selected: selected,
      onTap: onTap,
      fullWidth: true,
      height: AppSpacing.walletBuyPresetChipHeight,
      accentColor: _buyPrimary,
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
    return VitCard(
      height: AppSpacing.walletBuyReceivePanelHeight,
      padding: AppSpacing.walletBuyReceivePanelPadding,
      variant: VitCardVariant.inner,
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
                const SizedBox(height: AppSpacing.walletBuyCompactGap),
                Text(
                  '${_formatCrypto(receiveAmount)} ${crypto.symbol}',
                  style: AppTextStyles.base.copyWith(
                    color: _buyGreen,
                    height: AppSpacing.walletBuyReceiveLineHeight,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ],
            ),
          ),
          VitCard(
            key: const Key('sc145_buy_crypto_selector'),
            onTap: onCryptoTap,
            height: AppSpacing.walletBuySelectorHeight,
            padding: AppSpacing.walletBuySelectorPadding,
            borderColor: AppColors.borderSolid,
            clip: true,
            background: const ColoredBox(color: _buyPanel),
            child: Row(
              children: [
                _CryptoLogo(
                  option: crypto,
                  size: AppSpacing.walletBuyCryptoLogoCompact,
                ),
                const SizedBox(width: AppSpacing.walletBuyCompactGap),
                Text(
                  crypto.symbol,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: AppTextStyles.medium,
                  ),
                ),
                const SizedBox(width: AppSpacing.walletBuyMicroGap),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.text2,
                  size: 18,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
