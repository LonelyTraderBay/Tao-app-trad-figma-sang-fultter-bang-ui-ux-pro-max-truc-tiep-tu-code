import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/controllers/wallet_controller.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';

const _addressBackground = AppColors.bg;
const _addressPanel = AppColors.surface;
const _addressPanel2 = AppColors.surface2;
const _addressPrimary = AppColors.primary;
const _addressGreen = AppColors.buy;
const _addressAmber = AppColors.caution;
const _addressRed = AppColors.sell;

class AddressConfirmPreviewSheet extends StatelessWidget {
  const AddressConfirmPreviewSheet({
    super.key,
    required this.preview,
    required this.onConfirm,
  });

  static const confirmButtonKey = Key('sc143_address_confirm_save');

  final AddressAddPreview preview;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Xác nhận lưu địa chỉ',
              style: AppTextStyles.sectionTitle.copyWith(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              preview.auditTrailNote,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 14),
            _PreviewPanel(
              rows: [
                ('Tên', preview.label),
                ('Mạng', preview.networkLabel),
                ('Tài sản', preview.asset),
                ('Địa chỉ', preview.maskedAddress),
                if (preview.memo != null) ('Memo', preview.memo!),
                ('Whitelist', preview.whitelistLabel),
              ],
            ),
            const SizedBox(height: 16),
            _PrimaryActionButton(
              key: confirmButtonKey,
              enabled: true,
              label: 'Xác nhận lưu',
              onTap: onConfirm,
            ),
          ],
        ),
      ),
    );
  }
}

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
        _FieldSection(
          label: 'Tên địa chỉ',
          required: true,
          child: _TextInput(
            fieldKey: const Key('sc143_address_label_field'),
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
                      ? _addressAmber
                      : AppColors.text3,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 26),
        _FieldLabel(label: 'Mạng lưới', required: true),
        const SizedBox(height: 9),
        _NetworkGrid(
          networks: snapshot.networks,
          selectedId: selectedNetworkId,
          onChanged: onNetworkChanged,
        ),
        const SizedBox(height: 26),
        const _FieldLabel(label: 'Tài sản'),
        const SizedBox(height: 12),
        _AssetSelector(
          assets: snapshot.assets,
          selectedAsset: selectedAsset,
          onChanged: onAssetChanged,
        ),
        const SizedBox(height: 34),
        _FieldSection(
          label: 'Địa chỉ ví',
          required: true,
          child: _AddressInput(
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
        _FieldSection(
          label: 'Memo / Tag',
          optionalText: '(tùy chọn)',
          child: _TextInput(
            fieldKey: const Key('sc143_address_memo_field'),
            controller: memoController,
            hintText: 'Nhập memo nếu cần...',
            height: 48,
            onChanged: onInputChanged,
          ),
        ),
        const SizedBox(height: 32),
        _WhitelistCard(enabled: whitelist, onTap: onWhitelistChanged),
        const SizedBox(height: 24),
        const _WarningCard(),
        const SizedBox(height: 24),
        _AgreementRow(agreed: agreed, onTap: onAgreementChanged),
        if (labelController.text.trim().isNotEmpty &&
            addressController.text.trim().isNotEmpty) ...[
          const SizedBox(height: 18),
          _PreviewPanel(
            rows: [
              ('Tên', labelController.text.trim()),
              ('Mạng', selectedNetwork.label),
              ('Tài sản', selectedAsset),
              ('Địa chỉ', _maskAddress(addressController.text.trim())),
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

class _FieldSection extends StatelessWidget {
  const _FieldSection({
    required this.label,
    required this.child,
    this.required = false,
    this.optionalText,
  });

  final String label;
  final Widget child;
  final bool required;
  final String? optionalText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _FieldLabel(
          label: label,
          required: required,
          optionalText: optionalText,
        ),
        const SizedBox(height: 9),
        child,
      ],
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({
    required this.label,
    this.required = false,
    this.optionalText,
  });

  final String label;
  final bool required;
  final String? optionalText;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: AppTextStyles.caption.copyWith(
          color: AppColors.text2,
          fontSize: 13,
          fontWeight: FontWeight.w700,
          fontFamily: 'Roboto',
          height: 1.1,
        ),
        children: [
          TextSpan(text: label),
          if (required)
            const TextSpan(
              text: ' *',
              style: TextStyle(color: _addressRed),
            ),
          if (optionalText != null)
            TextSpan(
              text: ' $optionalText',
              style: const TextStyle(
                color: AppColors.text3,
                fontWeight: FontWeight.w400,
              ),
            ),
        ],
      ),
    );
  }
}

class _TextInput extends StatelessWidget {
  const _TextInput({
    this.fieldKey,
    required this.controller,
    required this.hintText,
    required this.onChanged,
    this.maxLength,
    this.height = 52,
  });

  final Key? fieldKey;
  final TextEditingController controller;
  final String hintText;
  final VoidCallback onChanged;
  final int? maxLength;
  final double height;

  @override
  Widget build(BuildContext context) {
    final hasValue = controller.text.trim().isNotEmpty;
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: _addressPanel2,
        borderRadius: AppRadii.cardRadius,
        border: Border.all(
          color: hasValue ? _addressPrimary : AppColors.borderSolid,
          width: 1.35,
        ),
      ),
      alignment: Alignment.center,
      child: TextField(
        key: fieldKey,
        controller: controller,
        maxLength: maxLength,
        onChanged: (_) => onChanged(),
        style: AppTextStyles.body.copyWith(
          color: AppColors.text1,
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: AppTextStyles.body.copyWith(
            color: AppColors.text2,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
          border: InputBorder.none,
          counterText: '',
          isCollapsed: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        ),
      ),
    );
  }
}

class _AddressInput extends StatelessWidget {
  const _AddressInput({required this.controller, required this.onChanged});

  final TextEditingController controller;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final hasValue = controller.text.trim().length > 8;
    return Container(
      height: 52,
      padding: const EdgeInsets.only(left: 16, right: 9),
      decoration: BoxDecoration(
        color: _addressPanel2,
        borderRadius: AppRadii.inputRadius,
        border: Border.all(
          color: hasValue ? _addressPrimary : AppColors.borderSolid,
          width: 1.35,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              key: const Key('sc143_address_address_field'),
              controller: controller,
              onChanged: (_) => onChanged(),
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontFamily: 'Roboto',
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
              decoration: InputDecoration(
                hintText: 'Nhập hoặc dán địa chỉ...',
                hintStyle: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  fontFamily: 'Roboto',
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
                border: InputBorder.none,
                isCollapsed: true,
              ),
            ),
          ),
          _IconCircleButton(
            icon: Icons.content_paste_rounded,
            onTap: () async {
              final data = await Clipboard.getData(Clipboard.kTextPlain);
              final text = data?.text;
              if (text == null || text.isEmpty) return;
              controller.text = text;
              onChanged();
            },
          ),
          const SizedBox(width: 7),
          _IconCircleButton(icon: Icons.qr_code_scanner_rounded, onTap: () {}),
        ],
      ),
    );
  }
}

class _IconCircleButton extends StatelessWidget {
  const _IconCircleButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: AppColors.overlayStroke,
          borderRadius: AppRadii.mdRadius,
        ),
        child: Icon(icon, color: AppColors.text2, size: 16),
      ),
    );
  }
}

class _NetworkGrid extends StatelessWidget {
  const _NetworkGrid({
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
          GestureDetector(
            key: Key('sc143_address_network_${network.id}'),
            onTap: () => onChanged(network.id),
            behavior: HitTestBehavior.opaque,
            child: _NetworkChip(
              network: network,
              selected: network.id == selectedId,
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
        color: selected ? AppColors.primary15 : _addressPanel2,
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
                color: selected ? _addressPrimary : AppColors.text2,
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

class _AssetSelector extends StatelessWidget {
  const _AssetSelector({
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
          GestureDetector(
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
                      ? _addressPrimary
                      : AppColors.text2,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  height: 1,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _WhitelistCard extends StatelessWidget {
  const _WhitelistCard({required this.enabled, required this.onTap});

  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: const Key('sc143_address_whitelist'),
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 80,
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        decoration: BoxDecoration(
          color: _addressPanel,
          borderRadius: AppRadii.cardRadius,
          border: Border.all(color: AppColors.overlayStroke),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: enabled ? AppColors.buy10 : _addressPanel2,
                borderRadius: AppRadii.cardRadius,
                border: Border.all(
                  color: enabled
                      ? AppColors.buy.withValues(alpha: .30)
                      : AppColors.borderSolid,
                ),
              ),
              child: Icon(
                Icons.shield_outlined,
                color: enabled ? _addressGreen : AppColors.text3,
                size: 18,
              ),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Thêm vào Whitelist',
                    style: AppTextStyles.body.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Chỉ rút tiền đến địa chỉ whitelist',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      fontSize: 12,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),
            _SwitchPill(enabled: enabled),
          ],
        ),
      ),
    );
  }
}

class _SwitchPill extends StatelessWidget {
  const _SwitchPill({required this.enabled});

  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 24,
      decoration: BoxDecoration(
        color: enabled ? _addressGreen : _addressPanel2,
        borderRadius: AppRadii.mdRadius,
        border: Border.all(
          color: enabled ? _addressGreen : AppColors.borderSolid,
          width: 1.5,
        ),
      ),
      child: AnimatedAlign(
        alignment: enabled ? Alignment.centerRight : Alignment.centerLeft,
        duration: const Duration(milliseconds: 160),
        child: Container(
          width: 18,
          height: 18,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          decoration: const BoxDecoration(
            color: AppColors.onAccent,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

class _WarningCard extends StatelessWidget {
  const _WarningCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: AppColors.caution.withValues(alpha: .06),
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: AppColors.caution.withValues(alpha: .15)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Icon(
              Icons.warning_amber_rounded,
              color: _addressAmber,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Lưu ý quan trọng',
                  style: AppTextStyles.caption.copyWith(
                    color: _addressAmber,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Kiểm tra kỹ địa chỉ và mạng lưới trước khi lưu. Rút tiền sai địa chỉ hoặc sai mạng sẽ mất vĩnh viễn và không thể khôi phục.',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontSize: 12,
                    height: 1.58,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AgreementRow extends StatelessWidget {
  const _AgreementRow({required this.agreed, required this.onTap});

  final bool agreed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: const Key('sc143_address_agreement'),
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            margin: const EdgeInsets.only(top: 2),
            decoration: BoxDecoration(
              color: agreed ? _addressGreen : AppColors.transparent,
              borderRadius: BorderRadius.circular(9),
              border: Border.all(
                color: agreed ? _addressGreen : AppColors.borderSolid,
                width: 2,
              ),
            ),
            child: agreed
                ? const Icon(
                    Icons.check_rounded,
                    color: AppColors.onAccent,
                    size: 16,
                  )
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Tôi xác nhận địa chỉ ví và mạng lưới chính xác. Tôi hiểu rằng gửi tiền sai địa chỉ sẽ không thể hoàn lại.',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                fontSize: 13,
                height: 1.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PreviewPanel extends StatelessWidget {
  const _PreviewPanel({required this.rows});

  final List<(String, String)> rows;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _addressPanel,
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: AppColors.overlayStroke),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Xem trước',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          for (final row in rows) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    row.$1,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text3,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Flexible(
                  flex: 2,
                  child: Text(
                    row.$2,
                    textAlign: TextAlign.right,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      fontFamily: row.$1 == 'Địa chỉ' ? 'Roboto Mono' : null,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}

class AddressSaveFooter extends StatelessWidget {
  const AddressSaveFooter({
    super.key,
    required this.enabled,
    required this.onTap,
  });

  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      decoration: const BoxDecoration(
        color: AppColors.navBg,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: _PrimaryActionButton(
        key: const Key('sc143_address_save'),
        enabled: enabled,
        label: 'Lưu địa chỉ',
        onTap: onTap,
      ),
    );
  }
}

class _PrimaryActionButton extends StatelessWidget {
  const _PrimaryActionButton({
    super.key,
    required this.enabled,
    required this.label,
    required this.onTap,
  });

  final bool enabled;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: AppSpacing.inputHeight,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: enabled ? _addressPrimary : AppColors.surface3,
          borderRadius: AppRadii.inputRadius,
          boxShadow: enabled
              ? [
                  BoxShadow(
                    color: _addressPrimary.withValues(alpha: .22),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: AppTextStyles.baseMedium.copyWith(
            color: enabled ? AppColors.onAccent : AppColors.text3,
            fontSize: 15,
            fontWeight: FontWeight.w800,
            height: 1,
          ),
        ),
      ),
    );
  }
}

class AddressSavedState extends StatelessWidget {
  const AddressSavedState({
    super.key,
    required this.label,
    required this.whitelist,
    required this.onBack,
  });

  final String label;
  final bool whitelist;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return VitPageLayout(
      semanticLabel: 'SC-143 AddressAddPage Success',
      child: Material(
        color: _addressBackground,
        child: Column(
          children: [
            VitHeader(
              title: 'Thêm địa chỉ',
              subtitle: 'Sổ địa chỉ · Wallet',
              showBack: true,
              onBack: onBack,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.buy10,
                        borderRadius: AppRadii.cardLargeRadius,
                        border: Border.all(color: AppColors.buy20, width: 1.5),
                      ),
                      child: const Icon(
                        Icons.check_circle_outline_rounded,
                        color: _addressGreen,
                        size: 42,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Đã lưu thành công!',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.sectionTitle.copyWith(fontSize: 20),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Địa chỉ "$label" đã được thêm vào sổ địa chỉ.',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.buy10,
                        borderRadius: AppRadii.cardRadius,
                        border: Border.all(color: AppColors.buy15),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.shield_outlined,
                            color: _addressGreen,
                            size: 14,
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              whitelist
                                  ? 'Đã thêm vào whitelist'
                                  : 'Chưa whitelist - có thể bật sau',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.micro.copyWith(
                                color: _addressGreen,
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
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
    );
  }
}

String _maskAddress(String address) {
  if (address.length <= 24) return address;
  return '${address.substring(0, 16)}...${address.substring(address.length - 8)}';
}
