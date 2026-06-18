import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_card.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_cta_button.dart';

const addressAddBackground = AppColors.bg;
const addressAddPanel = AppColors.surface;
const addressAddPanel2 = AppColors.surface2;
const addressAddPrimary = AppColors.primary;
const addressAddGreen = AppColors.buy;
const addressAddAmber = AppColors.caution;
const addressAddRed = AppColors.sell;

class AddressFieldSection extends StatelessWidget {
  const AddressFieldSection({
    super.key,
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
        AddressFieldLabel(
          label: label,
          required: required,
          optionalText: optionalText,
        ),
        const SizedBox(height: AppSpacing.walletAddressStatsValueGap),
        child,
      ],
    );
  }
}

class AddressFieldLabel extends StatelessWidget {
  const AddressFieldLabel({
    super.key,
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
          fontWeight: AppTextStyles.bold,
        ),
        children: [
          TextSpan(text: label),
          if (required)
            TextSpan(
              text: ' *',
              style: AppTextStyles.caption.copyWith(color: addressAddRed),
            ),
          if (optionalText != null)
            TextSpan(
              text: ' $optionalText',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text3,
                fontWeight: AppTextStyles.normal,
              ),
            ),
        ],
      ),
    );
  }
}

class AddressTextInput extends StatelessWidget {
  const AddressTextInput({
    super.key,
    this.fieldKey,
    required this.semanticLabel,
    required this.controller,
    required this.hintText,
    required this.onChanged,
    this.maxLength,
    this.height = AppSpacing.inputHeight,
  });

  final Key? fieldKey;
  final String semanticLabel;
  final TextEditingController controller;
  final String hintText;
  final VoidCallback onChanged;
  final int? maxLength;
  final double height;

  @override
  Widget build(BuildContext context) {
    final hasValue = controller.text.trim().isNotEmpty;
    return VitCard(
      height: height,
      variant: VitCardVariant.ghost,
      borderColor: hasValue ? addressAddPrimary : AppColors.borderSolid,
      background: const ColoredBox(color: addressAddPanel2),
      alignment: Alignment.center,
      clip: true,
      child: Semantics(
        textField: true,
        label: semanticLabel,
        hint: hintText,
        child: TextField(
          key: fieldKey,
          controller: controller,
          maxLength: maxLength,
          onChanged: (_) => onChanged(),
          style: AppTextStyles.control.copyWith(color: AppColors.text1),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: AppTextStyles.control.copyWith(color: AppColors.text2),
            border: InputBorder.none,
            counterText: '',
            isCollapsed: true,
            contentPadding: AppSpacing.walletAddressAddInputPadding,
          ),
        ),
      ),
    );
  }
}

class AddressWalletInput extends StatelessWidget {
  const AddressWalletInput({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  final TextEditingController controller;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final hasValue = controller.text.trim().length > 8;
    return VitCard(
      height: AppSpacing.inputHeight,
      padding: AppSpacing.walletAddressAddWalletInputPadding,
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.sm,
      borderColor: hasValue ? addressAddPrimary : AppColors.borderSolid,
      background: const ColoredBox(color: addressAddPanel2),
      clip: true,
      child: Row(
        children: [
          Expanded(
            child: Semantics(
              textField: true,
              label: 'Wallet address',
              hint: 'Enter or paste wallet address',
              child: TextField(
                key: const Key('sc143_address_address_field'),
                controller: controller,
                onChanged: (_) => onChanged(),
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
                decoration: InputDecoration(
                  hintText: 'Nhập hoặc dán địa chỉ...',
                  hintStyle: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontWeight: AppTextStyles.bold,
                  ),
                  border: InputBorder.none,
                  isCollapsed: true,
                ),
              ),
            ),
          ),
          AddressIconCircleButton(
            semanticLabel: 'Paste wallet address',
            icon: Icons.content_paste_rounded,
            onTap: () async {
              final data = await Clipboard.getData(Clipboard.kTextPlain);
              final text = data?.text;
              if (text == null || text.isEmpty) return;
              controller.text = text;
              onChanged();
            },
          ),
          const SizedBox(width: AppSpacing.walletAddressSectionGap),
          AddressIconCircleButton(
            semanticLabel: 'Scan wallet address QR code',
            icon: Icons.qr_code_scanner_rounded,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class AddressIconCircleButton extends StatelessWidget {
  const AddressIconCircleButton({
    super.key,
    required this.semanticLabel,
    required this.icon,
    required this.onTap,
  });

  final String semanticLabel;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: semanticLabel,
      child: VitCard(
        width: AppSpacing.walletAddressAddIconButton,
        height: AppSpacing.walletAddressAddIconButton,
        variant: VitCardVariant.inner,
        alignment: Alignment.center,
        onTap: onTap,
        child: Icon(
          icon,
          color: AppColors.text2,
          size: AppSpacing.walletAddressAddIcon,
        ),
      ),
    );
  }
}

class AddressPrimaryActionButton extends StatelessWidget {
  const AddressPrimaryActionButton({
    super.key,
    required this.enabled,
    required this.label,
    this.semanticLabel,
    required this.onTap,
  });

  final bool enabled;
  final String label;
  final String? semanticLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: enabled,
      label: semanticLabel ?? label,
      child: VitCtaButton(
        onPressed: enabled ? onTap : null,
        height: AppSpacing.inputHeight,
        child: Text(label),
      ),
    );
  }
}

String maskWalletAddress(String address) {
  if (address.length <= 24) return address;
  return '${address.substring(0, 16)}...${address.substring(address.length - 8)}';
}
