import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/controllers/wallet_controller.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/widgets/wallet_address_add_common.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_choice_pill.dart';

class AddressNetworkGrid extends StatelessWidget {
  const AddressNetworkGrid({
    super.key,
    required this.networks,
    required this.selectedId,
    required this.onChanged,
  });

  final List<WalletAddressNetwork> networks;
  final String selectedId;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.walletAddressAddNetworkSpacing,
      runSpacing: AppSpacing.walletAddressAddNetworkRunSpacing,
      children: [
        for (final network in networks)
          _NetworkChip(
            key: Key('sc143_address_network_${network.id}'),
            network: network,
            selected: network.id == selectedId,
            onTap: () => onChanged(network.id),
          ),
      ],
    );
  }
}

class _NetworkChip extends StatelessWidget {
  const _NetworkChip({
    super.key,
    required this.network,
    required this.selected,
    required this.onTap,
  });

  final WalletAddressNetwork network;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSpacing.walletAddressAddNetworkChipWidth,
      child: VitChoicePill(
        label: network.label,
        selected: selected,
        onTap: onTap,
        fullWidth: true,
        height: AppSpacing.walletAddressAddNetworkChipHeight,
        padding: AppSpacing.walletAddressAddNetworkChipPadding,
        accentColor: addressAddPrimary,
        semanticLabel: '${network.label} address network',
        leading: Icon(
          Icons.circle_rounded,
          color: Color(network.colorHex),
          size: AppSpacing.walletAddressAddNetworkDot,
        ),
      ),
    );
  }
}

class AddressAssetSelector extends StatelessWidget {
  const AddressAssetSelector({
    super.key,
    required this.assets,
    required this.selectedAsset,
    required this.onChanged,
  });

  final List<String> assets;
  final String selectedAsset;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.walletAddressAddAssetSpacing,
      runSpacing: AppSpacing.walletAddressAddAssetRunSpacing,
      children: [
        for (final asset in assets)
          SizedBox(
            width: asset == 'MATIC'
                ? AppSpacing.walletAddressAddAssetChipWideWidth
                : AppSpacing.walletAddressAddAssetChipWidth,
            child: VitChoicePill(
              key: Key('sc143_address_asset_$asset'),
              label: asset,
              selected: asset == selectedAsset,
              onTap: () => onChanged(asset),
              fullWidth: true,
              height: AppSpacing.walletAddressAddAssetChipHeight,
              accentColor: addressAddPrimary,
              semanticLabel: '$asset address asset',
            ),
          ),
      ],
    );
  }
}
