import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/wallet_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/widgets/wallet_buy_crypto_sections.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';

const _buyBackground = AppColors.bg;
const _buyPanel = AppColors.surface;

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
    final snapshot = ref.watch(walletBuyCryptoProvider);
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
      return BuySuccessState(
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
                    ? BuyConfirmContent(
                        crypto: crypto,
                        payment: payment,
                        amountVnd: _amountVnd,
                        receiveAmount: receiveAmount,
                        onConfirm: () => setState(() => _success = true),
                        onBack: () => setState(() => _confirming = false),
                      )
                    : BuyInputContent(
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
                  BuyCryptoOptionRow(
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
