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
import 'package:vit_trade_flutter/app/providers/wallet_controller_providers.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/widgets/vit_wallet_detail_scaffold.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

part '../widgets/deposit_page_sections.dart';
part '../widgets/deposit_page_common.dart';

const _depositPrimary = AppColors.primary;
const _depositGreen = AppColors.buy;
const _depositRed = AppColors.sell;
const _depositNativeBottomClearance = 88.0;
const _depositVisualBottomClearance = 112.0;
const _depositGap = 8.0;
const _depositTinyGap = 4.0;
const _depositInlineGap = 8.0;
const _depositSelectorHeight = 60.0;
const _depositQrSize = 132.0;
const _depositStatusDotSize = AppSpacing.x2 - AppSpacing.dividerHairline * 2;
const _depositCopyButtonHeight = 44.0;
const _depositRefreshHeight = 44.0;

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

    return VitWalletDetailScaffold(
      title: 'Nạp ${snapshot.asset}',
      subtitle: 'Nạp tiền · Wallet',
      semanticLabel: widget.assetScoped
          ? 'SC-138 DepositPage Asset'
          : 'SC-137 DepositPage',
      contentKey: DepositPage.contentKey,
      bottomInset: bottomInset,
      onBack: () => context.go(AppRoutePaths.wallet),
      children: [
        const VitSectionHeader(
          title: 'M\u1EA1ng n\u1EA1p',
          icon: Icons.hub_outlined,
          iconColor: _depositPrimary,
          accentColor: _depositPrimary,
        ),
        _NetworkSelector(
          asset: snapshot.asset,
          selected: selected,
          onTap: () => _openNetworkPicker(snapshot.networks),
        ),
        const VitSectionHeader(
          title: '\u0110\u1ECBa ch\u1EC9 n\u1EA1p',
          icon: Icons.qr_code_2_rounded,
          iconColor: _depositPrimary,
          accentColor: _depositPrimary,
        ),
        _QrAddressCard(
          asset: snapshot.asset,
          network: selected,
          copied: _copied,
          onCopy: () => _copyAddress(selected.address),
        ),
        const VitSectionHeader(
          title: 'An to\u00E0n',
          icon: Icons.shield_outlined,
          iconColor: _depositRed,
          accentColor: _depositRed,
        ),
        _WarningCard(asset: snapshot.asset, network: selected),
        const VitSectionHeader(
          title: 'Chi ti\u1EBFt n\u1EA1p',
          icon: Icons.receipt_long_outlined,
          iconColor: _depositPrimary,
          accentColor: _depositPrimary,
        ),
        _DepositInfoCard(
          asset: snapshot.asset,
          network: selected,
        ),
        _RefreshButton(onTap: _refreshDepositIntent),
      ],
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

  void _refreshDepositIntent() {
    setState(() => _copied = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đã làm mới thông tin nạp tiền'),
        duration: Duration(milliseconds: 900),
      ),
    );
  }

  void _openNetworkPicker(List<WalletDepositNetwork> networks) {
    showVitBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return VitSheetPanel(
          title: 'Chọn mạng lưới',
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: networks.length,
            separatorBuilder: (_, _) => const SizedBox(height: _depositTinyGap),
            itemBuilder: (context, index) {
              final network = networks[index];
              return _NetworkOption(
                network: network,
                selected:
                    network.id == _selectedNetworkId ||
                    (_selectedNetworkId == null &&
                        network.id == networks.first.id),
                onTap: () {
                  setState(() => _selectedNetworkId = network.id);
                  Navigator.of(context).pop();
                },
              );
            },
          ),
        );
      },
    );
  }
}
