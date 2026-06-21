import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/controllers/wallet_controller.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/widgets/wallet_address_add_common.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_card.dart';

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
          Semantics(
            button: true,
            selected: network.id == selectedId,
            label: '${network.label} address network',
            child: GestureDetector(
              key: Key('sc143_address_network_${network.id}'),
              onTap: () => onChanged(network.id),
              behavior: HitTestBehavior.opaque,
              child: _NetworkChip(
                network: network,
                selected: network.id == selectedId,
              ),
            ),
          ),
      ],
    );
  }
}

class _NetworkChip extends StatelessWidget {
  const _NetworkChip({required this.network, required this.selected});

  final WalletAddressNetwork network;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      width: AppSpacing.walletAddressAddNetworkChipWidth,
      height: AppSpacing.walletAddressAddNetworkChipHeight,
      padding: AppSpacing.walletAddressAddNetworkChipPadding,
      variant: selected ? VitCardVariant.standard : VitCardVariant.inner,
      borderColor: selected ? AppColors.primary60 : AppColors.borderSolid,
      child: Row(
        children: [
          SizedBox(
            width: AppSpacing.walletAddressAddNetworkDot,
            height: AppSpacing.walletAddressAddNetworkDot,
            child: ClipOval(child: ColoredBox(color: Color(network.colorHex))),
          ),
          const SizedBox(width: AppSpacing.rowGap),
          Expanded(
            child: Text(
              network.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: selected ? addressAddPrimary : AppColors.text2,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
        ],
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
          Semantics(
            button: true,
            selected: asset == selectedAsset,
            label: '$asset address asset',
            child: GestureDetector(
              key: Key('sc143_address_asset_$asset'),
              onTap: () => onChanged(asset),
              behavior: HitTestBehavior.opaque,
              child: VitCard(
                width: asset == 'MATIC'
                    ? AppSpacing.walletAddressAddAssetChipWideWidth
                    : AppSpacing.walletAddressAddAssetChipWidth,
                height: AppSpacing.walletAddressAddAssetChipHeight,
                alignment: Alignment.center,
                variant: asset == selectedAsset
                    ? VitCardVariant.standard
                    : VitCardVariant.ghost,
                borderColor: asset == selectedAsset
                    ? AppColors.primary60
                    : AppColors.transparent,
                child: Text(
                  asset,
                  style: AppTextStyles.caption.copyWith(
                    color: asset == selectedAsset
                        ? addressAddPrimary
                        : AppColors.text2,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
