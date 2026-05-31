import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/controllers/wallet_controller.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/widgets/wallet_address_add_common.dart';

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
      spacing: 10,
      runSpacing: 8,
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
    return Container(
      width: 126.5,
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: selected ? AppColors.primary15 : addressAddPanel2,
        borderRadius: AppRadii.lgRadius,
        border: Border.all(
          color: selected ? AppColors.primary60 : AppColors.borderSolid,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: Color(network.colorHex),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              network.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: selected ? addressAddPrimary : AppColors.text2,
                fontSize: 12,
                fontWeight: FontWeight.w800,
                height: 1,
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
      spacing: 17,
      runSpacing: 12,
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
              child: Container(
                width: asset == 'MATIC' ? 64 : 53,
                height: 34,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: asset == selectedAsset
                      ? AppColors.primary15
                      : AppColors.transparent,
                  borderRadius: AppRadii.cardRadius,
                  border: Border.all(
                    color: asset == selectedAsset
                        ? AppColors.primary60
                        : AppColors.transparent,
                  ),
                ),
                child: Text(
                  asset,
                  style: AppTextStyles.caption.copyWith(
                    color: asset == selectedAsset
                        ? addressAddPrimary
                        : AppColors.text2,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    height: 1,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
