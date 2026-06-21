import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/app/providers/wallet_controller_providers.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

part '../widgets/deposit_page_sections.dart';
part '../widgets/deposit_page_common.dart';

const _depositBackground = AppColors.bg;
const _depositPanel = AppColors.surface;
const _depositPrimary = AppColors.primary;
const _depositGreen = AppColors.buy;
const _depositRed = AppColors.sell;
const _depositNativeBottomClearance = 88.0;
const _depositVisualBottomClearance = 112.0;
const _depositScrollTopPad = 0.0;
const _depositGap = 8.0;
const _depositTinyGap = 4.0;
const _depositInlineGap = 8.0;
const _depositSelectorHeight = 60.0;
const _depositQrSize = 132.0;
const _depositStatusDotSize = AppSpacing.x2 - AppSpacing.dividerHairline * 2;
const _depositCopyButtonHeight = 44.0;
const _depositRefreshHeight = 44.0;
const _depositCardPadding = EdgeInsetsDirectional.symmetric(
  horizontal: AppSpacing.x3,
  vertical: AppSpacing.x3,
);
const _depositCompactPadding = EdgeInsetsDirectional.symmetric(
  horizontal: AppSpacing.x3,
  vertical: AppSpacing.x2,
);
const _depositSheetPadding = EdgeInsetsDirectional.fromSTEB(
  AppSpacing.x4,
  AppSpacing.x4 - AppSpacing.dividerHairline * 2,
  AppSpacing.x4,
  AppSpacing.x4,
);

double _depositScrollBottomInset(BuildContext context, ShellRenderMode mode) {
  return (mode.usesVisualQaFrame
          ? _depositVisualBottomClearance
          : _depositNativeBottomClearance) +
      MediaQuery.paddingOf(context).bottom;
}

class DepositPage extends ConsumerStatefulWidget {
  const DepositPage({
    super.key,
    this.asset = 'USDT',
    this.assetScoped = false,
    this.shellRenderMode,
  });

  static const contentKey = Key('sc137_deposit_content');
  static const networkSelectorKey = Key('sc137_deposit_network_selector');
  static const copyAddressKey = Key('sc137_deposit_copy_address');
  static const refreshKey = Key('sc137_deposit_refresh');
  static Key networkKey(String id) => Key('sc137_deposit_network_$id');

  final String asset;
  final bool assetScoped;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<DepositPage> createState() => _DepositPageState();
}

class _DepositPageState extends ConsumerState<DepositPage> {
  String? _selectedNetworkId;
  bool _copied = false;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(
      walletDepositControllerProvider((
        asset: widget.asset,
        assetScoped: widget.assetScoped,
      )),
    );
    final selected = _selectedNetwork(snapshot.networks);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset = _depositScrollBottomInset(context, mode);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: widget.assetScoped
          ? 'SC-138 DepositPage Asset'
          : 'SC-137 DepositPage',
      child: Material(
        color: _depositBackground,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Nạp ${snapshot.asset}',
            subtitle: 'Nạp tiền · Wallet',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.wallet),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  key: DepositPage.contentKey,
                  padding: AppSpacing.contentInsets.copyWith(
                    top: _depositScrollTopPad,
                    bottom: bottomInset,
                  ),
                  child: VitPageContent(
                    padding: VitContentPadding.none,
                    density: VitDensity.compact,
                    fullBleed: true,
                    children: [
                      _NetworkSelector(
                        asset: snapshot.asset,
                        selected: selected,
                        onTap: () => _openNetworkPicker(snapshot.networks),
                      ),
                      const SizedBox(height: _depositGap),
                      _WarningCard(asset: snapshot.asset, network: selected),
                      const SizedBox(height: _depositGap),
                      _QrAddressCard(
                        asset: snapshot.asset,
                        network: selected,
                        copied: _copied,
                        onCopy: () => _copyAddress(selected.address),
                      ),
                      const SizedBox(height: _depositGap),
                      _DepositInfoCard(
                        asset: snapshot.asset,
                        network: selected,
                      ),
                      const SizedBox(height: _depositGap),
                      _RefreshButton(onTap: () {}),
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

  WalletDepositNetwork _selectedNetwork(List<WalletDepositNetwork> networks) {
    final selectedId = _selectedNetworkId;
    if (selectedId != null) {
      for (final network in networks) {
        if (network.id == selectedId) return network;
      }
    }
    return networks.first;
  }

  Future<void> _copyAddress(String address) async {
    await Clipboard.setData(ClipboardData(text: address));
    if (!mounted) return;
    setState(() => _copied = true);
  }

  void _openNetworkPicker(List<WalletDepositNetwork> networks) {
    showVitBottomSheet<void>(
      context: context,
      backgroundColor: _depositPanel,
      shape: const RoundedRectangleBorder(
        borderRadius: AppRadii.sheetTopRadius,
      ),
      builder: (context) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: _depositSheetPadding,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Chọn mạng lưới', style: AppTextStyles.sectionTitle),
                const SizedBox(height: _depositGap),
                for (final network in networks) ...[
                  _NetworkOption(
                    network: network,
                    selected:
                        network.id == _selectedNetworkId ||
                        (_selectedNetworkId == null &&
                            network.id == networks.first.id),
                    onTap: () {
                      setState(() => _selectedNetworkId = network.id);
                      Navigator.of(context).pop();
                    },
                  ),
                  const SizedBox(height: _depositTinyGap),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
