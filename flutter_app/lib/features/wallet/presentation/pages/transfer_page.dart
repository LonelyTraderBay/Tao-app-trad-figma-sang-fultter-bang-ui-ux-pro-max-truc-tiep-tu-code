import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/wallet_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/widgets/wallet_transfer_sections.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_bottom_sheet.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_card.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_high_risk_state_panel.dart';

const _transferBackground = AppColors.bg;
const _transferPanel = AppColors.surface;
const _transferPrimary = AppColors.primary;
const _transferGreen = AppColors.buy;
const _transferNativeBottomClearance = 88.0;
const _transferVisualBottomClearance = 112.0;
const _transferScrollTopPad = 0.0;
const _transferGap = 8.0;
const _transferTinyGap = 4.0;
const _transferCardPadding = EdgeInsets.symmetric(horizontal: 12, vertical: 10);
const _transferSheetPadding = EdgeInsets.fromLTRB(16, 14, 16, 16);

double _transferScrollBottomInset(BuildContext context, ShellRenderMode mode) {
  return (mode.usesVisualQaFrame
          ? _transferVisualBottomClearance
          : _transferNativeBottomClearance) +
      MediaQuery.paddingOf(context).bottom;
}

class TransferPage extends ConsumerStatefulWidget {
  const TransferPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc146_transfer_content');
  static const fromWalletKey = Key('sc146_transfer_from_wallet');
  static const toWalletKey = Key('sc146_transfer_to_wallet');
  static const swapKey = Key('sc146_transfer_swap');
  static const assetSelectorKey = Key('sc146_transfer_asset');
  static const amountFieldKey = Key('sc146_transfer_amount');
  static const maxKey = Key('sc146_transfer_max');
  static const submitKey = Key('sc146_transfer_submit');
  static const confirmKey = Key('sc146_transfer_confirm');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<TransferPage> createState() => _TransferPageState();
}

class _TransferPageState extends ConsumerState<TransferPage> {
  final TextEditingController _amountController = TextEditingController();
  String _fromWalletId = 'spot';
  String _toWalletId = 'funding';
  String _assetId = 'usdt';
  bool _showSuccess = false;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  double get _amount {
    return double.tryParse(_amountController.text.replaceAll(',', '')) ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(walletTransferProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset = _transferScrollBottomInset(context, mode);
    final fromWallet = _wallet(snapshot, _fromWalletId);
    final toWallet = _wallet(snapshot, _toWalletId);
    final asset = _asset(snapshot, _assetId);
    final usdValue = _amount * asset.usdRate;
    final canTransfer = _amount > 0 && _amount <= asset.available;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-146 TransferPage',
      child: Material(
        color: _transferBackground,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Chuy\u1ec3n n\u1ed9i b\u1ed9',
            subtitle: 'Chuy\u1ec3n ti\u1ec1n \u00b7 Wallet',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.wallet),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  key: TransferPage.contentKey,
                  padding: AppSpacing.contentInsets.copyWith(
                    top: _transferScrollTopPad,
                    bottom: bottomInset,
                  ),
                  child: VitPageContent(
                    padding: VitContentPadding.none,
                    density: VitDensity.compact,
                    fullBleed: true,
                    children: [
                      if (_showSuccess) ...[
                        const TransferSuccessBanner(),
                        const SizedBox(height: _transferGap),
                      ],
                      VitCard(
                        variant: VitCardVariant.standard,
                        radius: VitCardRadius.md,
                        padding: _transferCardPadding,
                        child: VitPageContent(
                          padding: VitContentPadding.none,
                          customGap: _transferGap,
                          fullBleed: true,
                          children: [
                            TransferWalletCard(
                              key: TransferPage.fromWalletKey,
                              label: 'T\u1eeb',
                              wallet: fromWallet,
                              color: _transferPrimary,
                              onTap: () => _showWalletPicker(
                                title: 'Ch\u1ecdn v\u00ed ngu\u1ed3n',
                                snapshot: snapshot,
                                excludedWalletId: _toWalletId,
                                selectedWalletId: _fromWalletId,
                                onSelected: (id) =>
                                    setState(() => _fromWalletId = id),
                              ),
                            ),
                            TransferSwapButton(onTap: _swapWallets),
                            TransferWalletCard(
                              key: TransferPage.toWalletKey,
                              label: '\u0110\u1ebfn',
                              wallet: toWallet,
                              color: _transferGreen,
                              onTap: () => _showWalletPicker(
                                title: 'Ch\u1ecdn v\u00ed nh\u1eadn',
                                snapshot: snapshot,
                                excludedWalletId: _fromWalletId,
                                selectedWalletId: _toWalletId,
                                onSelected: (id) =>
                                    setState(() => _toWalletId = id),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: _transferGap),
                      TransferAssetCard(
                        asset: asset,
                        onTap: () => _showAssetPicker(snapshot),
                      ),
                      const SizedBox(height: _transferGap),
                      TransferAmountCard(
                        controller: _amountController,
                        asset: asset,
                        onChanged: () => setState(() {}),
                        onMax: () {
                          _amountController.text = formatTransferAssetAmount(
                            asset.available,
                          );
                          setState(() {});
                        },
                      ),
                      if (_amount > 0) ...[
                        const SizedBox(height: _transferTinyGap),
                        Text(
                          '\u2248 ${formatTransferUsd(usdValue)}',
                          style: AppTextStyles.control.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                      ],
                      const SizedBox(height: _transferGap),
                      const TransferInfoNotice(),
                      const SizedBox(height: _transferGap),
                      TransferButton(
                        key: TransferPage.submitKey,
                        enabled: canTransfer,
                        onTap: canTransfer
                            ? () => _showConfirmSheet(
                                fromWallet: fromWallet,
                                toWallet: toWallet,
                                asset: asset,
                                amount: _amount,
                                usdValue: usdValue,
                              )
                            : null,
                      ),
                      const SizedBox(height: _transferGap),
                      VitHighRiskStatePanel(
                        state: VitHighRiskUiState.riskReview,
                        title: 'Review transfer before confirmation',
                        message:
                            'Check source wallet, destination wallet, amount, fee, and masked confirmation details before submitting.',
                        contractId:
                            '${fromWallet.name} -> ${toWallet.name} / ${asset.symbol}',
                      ),
                      const SizedBox(height: _transferGap),
                      RecentTransfersList(transfers: snapshot.recentTransfers),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  WalletTransferWallet _wallet(
    WalletTransferSnapshot snapshot,
    String walletId,
  ) {
    return snapshot.wallets.firstWhere(
      (wallet) => wallet.id == walletId,
      orElse: () => snapshot.wallets.first,
    );
  }

  WalletTransferAsset _asset(WalletTransferSnapshot snapshot, String assetId) {
    return snapshot.assets.firstWhere(
      (asset) => asset.id == assetId,
      orElse: () => snapshot.assets.first,
    );
  }

  void _swapWallets() {
    setState(() {
      final from = _fromWalletId;
      _fromWalletId = _toWalletId;
      _toWalletId = from;
    });
  }

  void _showWalletPicker({
    required String title,
    required WalletTransferSnapshot snapshot,
    required String excludedWalletId,
    required String selectedWalletId,
    required ValueChanged<String> onSelected,
  }) {
    showVitBottomSheet<void>(
      context: context,
      backgroundColor: _transferPanel,
      shape: const RoundedRectangleBorder(
        borderRadius: AppRadii.sheetTopRadius,
      ),
      builder: (context) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: _transferSheetPadding,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(title, style: AppTextStyles.baseMedium),
                const SizedBox(height: _transferGap),
                for (final wallet in snapshot.wallets)
                  if (wallet.id != excludedWalletId)
                    TransferWalletPickerRow(
                      wallet: wallet,
                      selected: wallet.id == selectedWalletId,
                      onTap: () {
                        onSelected(wallet.id);
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

  void _showAssetPicker(WalletTransferSnapshot snapshot) {
    showVitBottomSheet<void>(
      context: context,
      backgroundColor: _transferPanel,
      shape: const RoundedRectangleBorder(
        borderRadius: AppRadii.sheetTopRadius,
      ),
      builder: (context) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: _transferSheetPadding,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Ch\u1ecdn t\u00e0i s\u1ea3n',
                  style: AppTextStyles.baseMedium,
                ),
                const SizedBox(height: _transferGap),
                for (final asset in snapshot.assets)
                  TransferAssetPickerRow(
                    asset: asset,
                    selected: asset.id == _assetId,
                    onTap: () {
                      setState(() {
                        _assetId = asset.id;
                        _amountController.clear();
                      });
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

  void _showConfirmSheet({
    required WalletTransferWallet fromWallet,
    required WalletTransferWallet toWallet,
    required WalletTransferAsset asset,
    required double amount,
    required double usdValue,
  }) {
    showVitBottomSheet<void>(
      context: context,
      backgroundColor: _transferPanel,
      shape: const RoundedRectangleBorder(
        borderRadius: AppRadii.sheetTopRadius,
      ),
      builder: (context) => TransferConfirmSheet(
        fromWallet: fromWallet,
        toWallet: toWallet,
        asset: asset,
        amount: amount,
        usdValue: usdValue,
        onConfirm: () {
          Navigator.of(context).pop();
          setState(() {
            _showSuccess = true;
            _amountController.clear();
          });
        },
      ),
    );
  }
}
