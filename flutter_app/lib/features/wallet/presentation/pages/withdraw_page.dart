import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/wallet_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/core/product_flow/contextual_support_contract.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/widgets/withdraw_common.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/widgets/withdraw_form_sections.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/widgets/withdraw_network_picker.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/widgets/withdraw_preview_sheet.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_card.dart';
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
    final scrollEndClearance =
        (mode.usesVisualQaFrame
            ? AppSpacing.x7 + AppSpacing.x6
            : AppSpacing.x7) +
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
                  padding: AppSpacing.contentInsets.copyWith(
                    top: AppSpacing.x4,
                    bottom: scrollEndClearance,
                  ),
                  child: VitPageContent(
                    padding: VitContentPadding.none,
                    gap: VitContentGap.tight,
                    fullBleed: true,
                    children: [
                      VitCard(
                        variant: VitCardVariant.ghost,
                        radius: VitCardRadius.md,
                        padding: EdgeInsets.zero,
                        child: WithdrawBalanceCard(
                          asset: snapshot.asset,
                          value: snapshot.available,
                        ),
                      ),
                      VitCard(
                        padding: AppSpacing.cardPadding,
                        child: VitPageContent(
                          padding: VitContentPadding.none,
                          gap: VitContentGap.tight,
                          fullBleed: true,
                          children: [
                            WithdrawNetworkSelector(
                              asset: snapshot.asset,
                              network: selected,
                              onTap: () => _openNetworkPicker(controller),
                            ),
                            WithdrawAddressInput(
                              asset: snapshot.asset,
                              network: selected,
                              controller: _addressController,
                              onScan: () {},
                            ),
                            WithdrawRecentAddresses(
                              addresses: snapshot.recentAddresses,
                              onSelect: (address) {
                                _addressController.text = address.address;
                                setState(() {});
                              },
                            ),
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
                          ],
                        ),
                      ),
                      VitCard(
                        padding: AppSpacing.cardPadding,
                        child: VitPageContent(
                          padding: VitContentPadding.none,
                          gap: VitContentGap.tight,
                          fullBleed: true,
                          children: [
                            const WithdrawWarning(),
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
                            WithdrawNextButton(
                              onTap: () =>
                                  _showConfirmPreview(controller, selected),
                            ),
                            if (snapshot.highRiskContractId != null)
                              VitHighRiskStatePanel(
                                state: VitHighRiskUiState.riskReview,
                                title: 'Withdrawal safety states active',
                                message:
                                    'Limits, setup, fee preview, confirmation, submitted status and recovery are tracked as one money-movement contract.',
                                contractId: snapshot.highRiskContractId,
                              ),
                          ],
                        ),
                      ),
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
        borderRadius: AppRadii.sheetTopRadius,
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
        borderRadius: AppRadii.sheetTopRadius,
      ),
      builder: (context) => WithdrawPreviewSheet(preview: preview),
    );
  }
}
