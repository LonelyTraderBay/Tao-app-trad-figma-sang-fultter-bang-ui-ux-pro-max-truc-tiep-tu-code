import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/controllers/wallet_controller.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/widgets/wallet_address_add_agreement.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/widgets/wallet_address_add_common.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/widgets/wallet_address_add_preview.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/widgets/wallet_address_add_selectors.dart';

class AddressAddForm extends StatelessWidget {
  const AddressAddForm({
    super.key,
    required this.snapshot,
    required this.selectedNetworkId,
    required this.selectedAsset,
    required this.labelController,
    required this.addressController,
    required this.memoController,
    required this.whitelist,
    required this.agreed,
    required this.onNetworkChanged,
    required this.onAssetChanged,
    required this.onWhitelistChanged,
    required this.onAgreementChanged,
    required this.onInputChanged,
  });

  final WalletAddressAddSnapshot snapshot;
  final String selectedNetworkId;
  final String selectedAsset;
  final TextEditingController labelController;
  final TextEditingController addressController;
  final TextEditingController memoController;
  final bool whitelist;
  final bool agreed;
  final ValueChanged<String> onNetworkChanged;
  final ValueChanged<String> onAssetChanged;
  final VoidCallback onWhitelistChanged;
  final VoidCallback onAgreementChanged;
  final VoidCallback onInputChanged;

  @override
  Widget build(BuildContext context) {
    final selectedNetwork = snapshot.networks.firstWhere(
      (network) => network.id == selectedNetworkId,
      orElse: () => snapshot.networks.first,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AddressFieldSection(
          label: 'Tên địa chỉ',
          required: true,
          child: AddressTextInput(
            fieldKey: const Key('sc143_address_label_field'),
            semanticLabel: 'Address label',
            controller: labelController,
            hintText: 'VD: Ví lạnh cá nhân, Sàn Binance...',
            maxLength: 30,
            onChanged: onInputChanged,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 6, 4, 0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Đặt tên dễ nhớ cho ví',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontSize: 11,
                  ),
                ),
              ),
              Text(
                '${labelController.text.length}/30',
                style: AppTextStyles.micro.copyWith(
                  color: labelController.text.length > 25
                      ? addressAddAmber
                      : AppColors.text3,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 26),
        const AddressFieldLabel(label: 'Mạng lưới', required: true),
        const SizedBox(height: 9),
        AddressNetworkGrid(
          networks: snapshot.networks,
          selectedId: selectedNetworkId,
          onChanged: onNetworkChanged,
        ),
        const SizedBox(height: 26),
        const AddressFieldLabel(label: 'Tài sản'),
        const SizedBox(height: 12),
        AddressAssetSelector(
          assets: snapshot.assets,
          selectedAsset: selectedAsset,
          onChanged: onAssetChanged,
        ),
        const SizedBox(height: 34),
        AddressFieldSection(
          label: 'Địa chỉ ví',
          required: true,
          child: AddressWalletInput(
            controller: addressController,
            onChanged: onInputChanged,
          ),
        ),
        const SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text(
            selectedNetwork.addressHint,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 11,
              height: 1,
            ),
          ),
        ),
        const SizedBox(height: 28),
        AddressFieldSection(
          label: 'Memo / Tag',
          optionalText: '(tùy chọn)',
          child: AddressTextInput(
            fieldKey: const Key('sc143_address_memo_field'),
            semanticLabel: 'Address memo optional',
            controller: memoController,
            hintText: 'Nhập memo nếu cần...',
            height: 48,
            onChanged: onInputChanged,
          ),
        ),
        const SizedBox(height: 32),
        AddressWhitelistCard(enabled: whitelist, onTap: onWhitelistChanged),
        const SizedBox(height: 24),
        const AddressWarningCard(),
        const SizedBox(height: 24),
        AddressAgreementRow(agreed: agreed, onTap: onAgreementChanged),
        if (labelController.text.trim().isNotEmpty &&
            addressController.text.trim().isNotEmpty) ...[
          const SizedBox(height: 18),
          AddressPreviewPanel(
            rows: [
              ('Tên', labelController.text.trim()),
              ('Mạng', selectedNetwork.label),
              ('Tài sản', selectedAsset),
              ('Địa chỉ', maskWalletAddress(addressController.text.trim())),
              if (memoController.text.trim().isNotEmpty)
                ('Memo', memoController.text.trim()),
              ('Whitelist', whitelist ? 'Có' : 'Không'),
            ],
          ),
        ],
      ],
    );
  }
}
