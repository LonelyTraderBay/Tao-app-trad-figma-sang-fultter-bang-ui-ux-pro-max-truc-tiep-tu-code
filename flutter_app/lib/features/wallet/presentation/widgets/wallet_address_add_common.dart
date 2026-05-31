import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';

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
        const SizedBox(height: 9),
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
              style: TextStyle(color: addressAddRed),
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

class AddressTextInput extends StatelessWidget {
  const AddressTextInput({
    super.key,
    this.fieldKey,
    required this.semanticLabel,
    required this.controller,
    required this.hintText,
    required this.onChanged,
    this.maxLength,
    this.height = 52,
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
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: addressAddPanel2,
        borderRadius: AppRadii.cardRadius,
        border: Border.all(
          color: hasValue ? addressAddPrimary : AppColors.borderSolid,
          width: 1.35,
        ),
      ),
      alignment: Alignment.center,
      child: Semantics(
        textField: true,
        label: semanticLabel,
        hint: hintText,
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
    return Container(
      height: 52,
      padding: const EdgeInsets.only(left: 16, right: 9),
      decoration: BoxDecoration(
        color: addressAddPanel2,
        borderRadius: AppRadii.inputRadius,
        border: Border.all(
          color: hasValue ? addressAddPrimary : AppColors.borderSolid,
          width: 1.35,
        ),
      ),
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
          const SizedBox(width: 7),
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
      child: GestureDetector(
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
      child: GestureDetector(
        onTap: enabled ? onTap : null,
        behavior: HitTestBehavior.opaque,
        child: Container(
          height: AppSpacing.inputHeight,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: enabled ? addressAddPrimary : AppColors.surface3,
            borderRadius: AppRadii.inputRadius,
            boxShadow: enabled
                ? [
                    BoxShadow(
                      color: addressAddPrimary.withValues(alpha: .22),
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
      ),
    );
  }
}

String maskWalletAddress(String address) {
  if (address.length <= 24) return address;
  return '${address.substring(0, 16)}...${address.substring(address.length - 8)}';
}
