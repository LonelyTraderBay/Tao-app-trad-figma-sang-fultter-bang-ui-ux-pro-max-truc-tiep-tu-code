import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/wallet_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/core/product_flow/contextual_support_contract.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/widgets/withdraw_common.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/widgets/withdraw_form_sections.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/widgets/withdraw_network_picker.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/widgets/withdraw_preview_sheet.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_high_risk_state_panel.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_bottom_sheet.dart';

class WithdrawPage extends ConsumerStatefulWidget {
  const WithdrawPage({
    super.key,
    this.asset = 'USDT',
    this.assetScoped = false,
    this.shellRenderMode,
  });

  static const contentKey = withdrawContentKey;
  static const networkSelectorKey = withdrawNetworkSelectorKey;
  static const addressFieldKey = withdrawAddressFieldKey;
  static const amountFieldKey = withdrawAmountFieldKey;
  static const allAmountKey = withdrawAllAmountKey;
  static const nextKey = withdrawNextKey;
  static const supportKey = withdrawSupportKey;
  static const cancelConfirmKey = withdrawCancelConfirmKey;
  static const confirmWithdrawKey = withdrawConfirmWithdrawKey;

  static Key networkKey(String id) => withdrawNetworkKey(id);
  static Key recentAddressKey(String label) => withdrawRecentAddressKey(label);

  final String asset;
  final bool assetScoped;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<WithdrawPage> createState() => _WithdrawPageState();
}

class _WithdrawPageState extends ConsumerState<WithdrawPage> {
  late final TextEditingController _addressController;
  late final TextEditingController _amountController;
  String? _selectedNetworkId;

  @override
  void initState() {
    super.initState();
    _addressController = TextEditingController();
    _amountController = TextEditingController();
  }

  @override
  void dispose() {
    _addressController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(
      withdrawControllerProvider((
        asset: widget.asset,
        assetScoped: widget.assetScoped,
      )),
    );
    final snapshot = controller.state.snapshot;
    final selected = controller.selectedNetwork(_selectedNetworkId);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 92
            : DeviceMetrics.nativeBottomChrome + 28) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: widget.assetScoped
          ? 'SC-140 WithdrawPage Asset'
          : 'SC-139 WithdrawPage',
      child: Material(
        color: withdrawBackground,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Rút ${snapshot.asset}',
            subtitle: 'Rút tiền · Wallet',
            showBack: true,
            onBack: () => goBackOrFallback(
              context,
              fallbackPath: AppRoutePaths.wallet,
              mode: BackNavigationMode.historyThenFallback,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  key: WithdrawPage.contentKey,
                  padding: EdgeInsets.fromLTRB(20, 13, 20, bottomInset),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      WithdrawBalanceCard(
                        asset: snapshot.asset,
                        value: snapshot.available,
                      ),
                      const SizedBox(height: 20),
                      WithdrawNetworkSelector(
                        asset: snapshot.asset,
                        network: selected,
                        onTap: () => _openNetworkPicker(controller),
                      ),
                      const SizedBox(height: 18),
                      WithdrawAddressInput(
                        asset: snapshot.asset,
                        network: selected,
                        controller: _addressController,
                        onScan: () {},
                      ),
                      const SizedBox(height: 8),
                      WithdrawRecentAddresses(
                        addresses: snapshot.recentAddresses,
                        onSelect: (address) {
                          _addressController.text = address.address;
                          setState(() {});
                        },
                      ),
                      const SizedBox(height: 12),
                      WithdrawAmountInput(
                        asset: snapshot.asset,
                        available: snapshot.available,
                        controller: _amountController,
                        onAll: () {
                          _amountController.text = formatWithdrawBalance(
                            snapshot.available,
                          );
                          setState(() {});
                        },
                      ),
                      const SizedBox(height: 16),
                      const WithdrawWarning(),
                      const SizedBox(height: 16),
                      WithdrawSupportLink(
                        onTap: () => context.go(
                          ContextualSupportContracts.supportRouteFor(
                            ContextualSupportFlow.withdrawal,
                            referenceId:
                                'withdraw-${snapshot.asset.toLowerCase()}',
                            sourceRoute: widget.assetScoped
                                ? AppRoutePaths.walletWithdrawAsset(
                                    snapshot.asset,
                                  )
                                : AppRoutePaths.walletWithdraw,
                            issueLabel:
                                'Withdrawal support for ${snapshot.asset}',
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      WithdrawNextButton(
                        onTap: () => _showConfirmPreview(controller, selected),
                      ),
                      if (snapshot.highRiskContractId != null) ...[
                        const SizedBox(height: 16),
                        VitHighRiskStatePanel(
                          state: VitHighRiskUiState.riskReview,
                          title: 'Withdrawal safety states active',
                          message:
                              'Limits, setup, fee preview, confirmation, submitted status and recovery are tracked as one money-movement contract.',
                          contractId: snapshot.highRiskContractId,
                        ),
                      ],
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

  void _openNetworkPicker(WithdrawController controller) {
    final networks = controller.state.snapshot.networks;
    showVitBottomSheet<void>(
      context: context,
      backgroundColor: withdrawPanel,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (context) {
        return WithdrawNetworkPicker(
          networks: networks,
          selectedNetworkId: controller.selectedNetwork(_selectedNetworkId).id,
          onSelected: (network) {
            setState(() => _selectedNetworkId = network.id);
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  void _showConfirmPreview(
    WithdrawController controller,
    WalletWithdrawNetwork network,
  ) {
    final amount = _amountController.text.trim().isEmpty
        ? '0'
        : _amountController.text.trim();
    final address = _addressController.text.trim().isEmpty
        ? 'Chưa nhập'
        : _addressController.text.trim();
    final preview = controller.preview(
      address: address,
      amount: amount,
      network: network,
    );

    showVitBottomSheet<void>(
      context: context,
      backgroundColor: withdrawPanel,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (context) => WithdrawPreviewSheet(preview: preview),
    );
  }
}
