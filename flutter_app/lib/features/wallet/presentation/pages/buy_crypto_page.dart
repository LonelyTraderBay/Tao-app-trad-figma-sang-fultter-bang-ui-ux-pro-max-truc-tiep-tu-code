import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/features/wallet/data/wallet_repository.dart';

const _buyBackground = AppColors.bg;
const _buyPanel = AppColors.surface;
const _buyPanel2 = AppColors.surface2;
const _buyPrimary = AppColors.primary;
const _buyGreen = Color(0xFF10B981);

class BuyCryptoPage extends ConsumerStatefulWidget {
  const BuyCryptoPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc145_buy_crypto_content');
  static const amountFieldKey = Key('sc145_buy_crypto_amount');
  static const cryptoSelectorKey = Key('sc145_buy_crypto_selector');
  static const buyButtonKey = Key('sc145_buy_crypto_buy');
  static Key presetKey(int amount) => Key('sc145_buy_crypto_preset_$amount');
  static Key paymentKey(String id) => Key('sc145_buy_crypto_payment_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<BuyCryptoPage> createState() => _BuyCryptoPageState();
}

class _BuyCryptoPageState extends ConsumerState<BuyCryptoPage> {
  final TextEditingController _amountController = TextEditingController();
  String _selectedCrypto = 'USDT';
  String _selectedPayment = 'momo';
  bool _confirming = false;
  bool _success = false;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  int get _amountVnd {
    return int.tryParse(_amountController.text.replaceAll(',', '')) ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(walletRepositoryProvider).getBuyCrypto();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 32
            : DeviceMetrics.nativeBottomChrome + 32) +
        MediaQuery.paddingOf(context).bottom;
    final crypto = _crypto(snapshot);
    final payment = _payment(snapshot);
    final receiveAmount = _amountVnd / crypto.priceVnd;

    if (_success) {
      return _BuySuccessState(
        crypto: crypto,
        amountVnd: _amountVnd,
        receiveAmount: receiveAmount,
        onWallet: () => context.go(AppRoutePaths.wallet),
        onBuyMore: () {
          setState(() {
            _success = false;
            _confirming = false;
            _amountController.clear();
          });
        },
      );
    }

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-145 BuyCryptoPage',
      child: Material(
        color: _buyBackground,
        child: Column(
          children: [
            VitHeader(
              title: _confirming ? 'Xác nhận mua' : 'Mua Crypto',
              subtitle: 'Giao dịch · Wallet',
              showBack: true,
              onBack: () => _confirming
                  ? setState(() => _confirming = false)
                  : context.go(AppRoutePaths.wallet),
            ),
            Expanded(
              child: SingleChildScrollView(
                key: BuyCryptoPage.contentKey,
                padding: EdgeInsets.fromLTRB(20, 14, 20, bottomInset),
                child: _confirming
                    ? _ConfirmContent(
                        crypto: crypto,
                        payment: payment,
                        amountVnd: _amountVnd,
                        receiveAmount: receiveAmount,
                        onConfirm: () => setState(() => _success = true),
                        onBack: () => setState(() => _confirming = false),
                      )
                    : _InputContent(
                        snapshot: snapshot,
                        selectedCrypto: crypto,
                        selectedPaymentId: _selectedPayment,
                        amountController: _amountController,
                        amountVnd: _amountVnd,
                        receiveAmount: receiveAmount,
                        onAmountChanged: () => setState(() {}),
                        onPreset: (amount) {
                          _amountController.text = amount.toString();
                          setState(() {});
                        },
                        onCryptoTap: () => _showCryptoPicker(snapshot),
                        onPaymentChanged: (id) =>
                            setState(() => _selectedPayment = id),
                        onBuy: _canBuy(crypto)
                            ? () => setState(() => _confirming = true)
                            : null,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  WalletBuyCryptoOption _crypto(WalletBuyCryptoSnapshot snapshot) {
    return snapshot.cryptoOptions.firstWhere(
      (option) => option.symbol == _selectedCrypto,
      orElse: () => snapshot.cryptoOptions.first,
    );
  }

  WalletPaymentMethod _payment(WalletBuyCryptoSnapshot snapshot) {
    return snapshot.paymentMethods.firstWhere(
      (method) => method.id == _selectedPayment,
      orElse: () => snapshot.paymentMethods.first,
    );
  }

  bool _canBuy(WalletBuyCryptoOption crypto) {
    return _amountVnd >= crypto.minBuyVnd && _amountVnd <= 100000000;
  }

  void _showCryptoPicker(WalletBuyCryptoSnapshot snapshot) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: _buyPanel,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (context) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Chọn loại Crypto',
                  style: AppTextStyles.sectionTitle.copyWith(fontSize: 18),
                ),
                const SizedBox(height: 12),
                for (final option in snapshot.cryptoOptions)
                  _CryptoOptionRow(
                    option: option,
                    selected: option.symbol == _selectedCrypto,
                    onTap: () {
                      setState(() => _selectedCrypto = option.symbol);
                      Navigator.of(context).pop();
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _InputContent extends StatelessWidget {
  const _InputContent({
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
        Text(
          'Phương thức thanh toán',
          style: AppTextStyles.baseMedium.copyWith(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            height: 1,
          ),
        ),
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
        color: const Color(0x1410B981),
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: const Color(0x3310B981)),
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
                fontSize: 12,
                height: 1.45,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            '0% phí',
            style: AppTextStyles.micro.copyWith(
              color: _buyGreen,
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
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
        border: Border.all(color: const Color(0x14FFFFFF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Số tiền (VND)',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontSize: 13,
                    height: 1,
                  ),
                ),
              ),
              Text(
                'Số dư: 0 VND',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text3,
                  fontSize: 12,
                  height: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 21),
          Row(
            children: [
              Text(
                '₫',
                style: AppTextStyles.sectionTitle.copyWith(
                  color: AppColors.text3,
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  key: BuyCryptoPage.amountFieldKey,
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (_) => onAmountChanged(),
                  style: AppTextStyles.sectionTitle.copyWith(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    height: 1,
                  ),
                  decoration: InputDecoration(
                    hintText: '0',
                    hintStyle: AppTextStyles.sectionTitle.copyWith(
                      color: AppColors.text2,
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
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
      key: BuyCryptoPage.presetKey(amount),
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
          style: AppTextStyles.caption.copyWith(
            color: selected ? Colors.white : AppColors.text2,
            fontSize: 12,
            fontWeight: FontWeight.w800,
            height: 1,
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
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontSize: 11,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '${_formatCrypto(receiveAmount)} ${crypto.symbol}',
                  style: AppTextStyles.baseMedium.copyWith(
                    color: _buyGreen,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            key: BuyCryptoPage.cryptoSelectorKey,
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
                    style: AppTextStyles.caption.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
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
      key: BuyCryptoPage.paymentKey(method.id),
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
        border: Border.all(color: const Color(0x14FFFFFF)),
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
      key: BuyCryptoPage.buyButtonKey,
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
            color: enabled ? Colors.white : AppColors.text3,
            fontSize: 15,
            fontWeight: FontWeight.w800,
            height: 1,
          ),
        ),
      ),
    );
  }
}

class _ConfirmContent extends StatelessWidget {
  const _ConfirmContent({
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

class _BuySuccessState extends StatelessWidget {
  const _BuySuccessState({
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
            color: Colors.white,
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

class _CryptoOptionRow extends StatelessWidget {
  const _CryptoOptionRow({
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
