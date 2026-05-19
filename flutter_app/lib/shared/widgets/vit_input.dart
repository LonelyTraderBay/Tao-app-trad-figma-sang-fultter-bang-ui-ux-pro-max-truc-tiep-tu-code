import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_radii.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_text_styles.dart';

class VitInput extends StatelessWidget {
  const VitInput({
    super.key,
    required this.controller,
    this.fieldKey,
    this.focusNode,
    this.label,
    this.hintText,
    this.prefix,
    this.suffix,
    this.errorText,
    this.obscureText = false,
    this.enabled = true,
    this.autofocus = false,
    this.keyboardType,
    this.textInputAction,
    this.autofillHints,
    this.onChanged,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final Key? fieldKey;
  final FocusNode? focusNode;
  final String? label;
  final String? hintText;
  final Widget? prefix;
  final Widget? suffix;
  final String? errorText;
  final bool obscureText;
  final bool enabled;
  final bool autofocus;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  bool get _hasError => errorText != null;

  bool get _showErrorText => errorText != null && errorText!.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final input = Container(
      height: AppSpacing.inputHeight,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: AppRadii.inputRadius,
        border: Border.all(
          color: _hasError ? AppColors.sell : AppColors.borderSolid,
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          if (prefix != null) ...[
            IconTheme(
              data: const IconThemeData(color: AppColors.text3, size: 18),
              child: prefix!,
            ),
            const SizedBox(width: AppSpacing.x3),
          ],
          Expanded(
            child: TextField(
              key: fieldKey,
              controller: controller,
              focusNode: focusNode,
              enabled: enabled,
              autofocus: autofocus,
              obscureText: obscureText,
              keyboardType: keyboardType,
              textInputAction: textInputAction,
              autofillHints: autofillHints,
              cursorColor: AppColors.primary,
              style: AppTextStyles.body.copyWith(fontSize: 15),
              onChanged: onChanged,
              onSubmitted: onSubmitted,
              decoration: InputDecoration.collapsed(
                hintText: hintText,
                hintStyle: AppTextStyles.body.copyWith(
                  color: AppColors.text3,
                  fontSize: 15,
                ),
              ),
            ),
          ),
          if (suffix != null) ...[
            const SizedBox(width: AppSpacing.x3),
            suffix!,
          ],
        ],
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: 6),
        ],
        Semantics(
          textField: true,
          label: label,
          enabled: enabled,
          child: input,
        ),
        if (_showErrorText) ...[
          const SizedBox(height: AppSpacing.x2),
          Text(
            errorText!,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.sell,
              fontSize: 12,
            ),
          ),
        ],
      ],
    );
  }
}
