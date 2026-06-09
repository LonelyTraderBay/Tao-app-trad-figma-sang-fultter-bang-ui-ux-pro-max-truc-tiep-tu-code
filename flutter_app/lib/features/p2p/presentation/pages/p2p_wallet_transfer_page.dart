import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';

part '../widgets/p2p_wallet_transfer_form.dart';
part '../widgets/p2p_wallet_transfer_amount.dart';
part '../widgets/p2p_wallet_transfer_confirm.dart';

class P2PWalletTransferPage extends ConsumerStatefulWidget {
  const P2PWalletTransferPage({
    super.key,
    this.initialAsset,
    this.initialType,
    this.shellRenderMode,
  });

  static const directionKey = Key('sc261_p2p_wallet_transfer_direction');
  static const switchKey = Key('sc261_p2p_wallet_transfer_switch');
  static const assetSelectorKey = Key('sc261_p2p_wallet_transfer_assets');
  static const amountFieldKey = Key('sc261_p2p_wallet_transfer_amount');
  static const maxKey = Key('sc261_p2p_wallet_transfer_max');
  static const submitKey = Key('sc261_p2p_wallet_transfer_submit');
  static const confirmKey = Key('sc261_p2p_wallet_transfer_confirm');
  static const feeKey = Key('sc261_p2p_wallet_transfer_fee');
  static const escrowNoteKey = Key('sc261_p2p_wallet_transfer_escrow_note');
  static const confirmPanelKey = Key('sc261_p2p_wallet_transfer_confirm_panel');

  static Key assetKey(String symbol) =>
      Key('sc261_p2p_wallet_transfer_asset_$symbol');
  static Key activeAssetKey(String symbol) =>
      Key('sc261_p2p_wallet_transfer_active_asset_$symbol');

  static Key percentKey(int value) =>
      Key('sc261_p2p_wallet_transfer_percent_$value');

  final String? initialAsset;
  final String? initialType;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<P2PWalletTransferPage> createState() =>
      _P2PWalletTransferPageState();
}

class _P2PWalletTransferPageState extends ConsumerState<P2PWalletTransferPage> {
  late final TextEditingController _amountController;
  late String _asset;
  late String _type;
  bool _showConfirm = false;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
    _asset = (widget.initialAsset ?? 'USDT').toUpperCase();
    _type = widget.initialType == 'withdraw' ? 'withdraw' : 'deposit';
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  double get _amount =>
      double.tryParse(_amountController.text.replaceAll(',', '')) ?? 0;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(
      p2pWalletTransferProvider((asset: _asset, type: _type)),
    );
    if (!snapshot.assets.any((item) => item.symbol == _asset)) {
      _asset = snapshot.defaultAsset;
    }

    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x5
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;
    final source = snapshot.sourceBalance(_type, _asset);
    final destination = snapshot.destinationBalance(_type, _asset);
    final canTransfer = _amount > 0 && _amount <= source.available;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-261 P2PWalletTransferPage',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: _showConfirm ? 'Xác nhận chuyển tiền' : 'Chuyển tiền',
            subtitle: 'Ví · P2P',
            showBack: true,
            onBack: () {
              if (_showConfirm) {
                setState(() => _showConfirm = false);
                return;
              }
              context.go(snapshot.parentRoute);
            },
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(
                    context,
                  ).copyWith(scrollbars: false),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(
                      AppSpacing.contentPad,
                      AppSpacing.x4,
                      AppSpacing.contentPad,
                      bottomInset,
                    ),
                    child: VitPageContent(
                      padding: VitContentPadding.none,
                      children: [
                        if (_showConfirm)
                          _ConfirmTransferView(
                            snapshot: snapshot,
                            source: source,
                            destination: destination,
                            amount: _amount,
                            asset: _asset,
                            onEdit: () => setState(() => _showConfirm = false),
                            onConfirm: () {
                              HapticFeedback.mediumImpact();
                              context.go(snapshot.parentRoute);
                            },
                          )
                        else
                          _TransferForm(
                            snapshot: snapshot,
                            source: source,
                            destination: destination,
                            type: _type,
                            asset: _asset,
                            amountController: _amountController,
                            amount: _amount,
                            canTransfer: canTransfer,
                            onSwitch: _switchDirection,
                            onAssetChanged: _setAsset,
                            onMax: () => _setAmount(source.available),
                            onPercent: (percent) =>
                                _setAmount(source.available * percent / 100),
                            onAmountChanged: () => setState(() {}),
                            onSubmit: canTransfer
                                ? () {
                                    HapticFeedback.mediumImpact();
                                    setState(() => _showConfirm = true);
                                  }
                                : null,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _switchDirection() {
    HapticFeedback.selectionClick();
    setState(() {
      _type = _type == 'deposit' ? 'withdraw' : 'deposit';
      _amountController.clear();
      _showConfirm = false;
    });
  }

  void _setAsset(String symbol) {
    HapticFeedback.selectionClick();
    setState(() {
      _asset = symbol;
      _amountController.clear();
      _showConfirm = false;
    });
  }

  void _setAmount(double value) {
    HapticFeedback.selectionClick();
    _amountController.text = _formatTransferAmount(value, _asset);
    setState(() {});
  }
}
