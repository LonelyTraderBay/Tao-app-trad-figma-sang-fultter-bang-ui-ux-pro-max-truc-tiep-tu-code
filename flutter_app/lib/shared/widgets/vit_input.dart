import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';

class VitInput extends StatelessWidget {
  const VitInput({
    super.key,
    required this.controller,
    this.fieldKey,
    this.focusNode,
    this.label,
    this.semanticLabel,
    this.hintText,
    this.prefix,
    this.suffix,
    this.errorText,
    this.obscureText = false,
    this.enabled = true,
    this.autofocus = false,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.autofillHints,
    this.textAlign = TextAlign.start,
    this.textStyle,
    this.onChanged,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final Key? fieldKey;
  final FocusNode? focusNode;
  final String? label;
  final String? semanticLabel;
  final String? hintText;
  final Widget? prefix;
  final Widget? suffix;
  final String? errorText;
  final bool obscureText;
  final bool enabled;
  final bool autofocus;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final Iterable<String>? autofillHints;
  final TextAlign textAlign;
  final TextStyle? textStyle;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  bool get _hasError => errorText != null;

  bool get _showErrorText => errorText != null && errorText!.trim().isNotEmpty;

  String? get _resolvedSemanticLabel {
    final parts = <String>[];
    final explicit = semanticLabel?.trim();
    final visual = label?.trim();
    if (explicit != null && explicit.isNotEmpty) {
      parts.add(explicit);
    } else if (visual != null && visual.isNotEmpty) {
      parts.add(visual);
    }
    if (_showErrorText) {
      parts.add('Error: ${errorText!.trim()}');
    }
    return parts.isEmpty ? null : parts.join('. ');
  }

  String? get _resolvedSemanticHint {
    if (_showErrorText) return errorText!.trim();
    final hint = hintText?.trim();
    return hint == null || hint.isEmpty ? null : hint;
  }

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
              textCapitalization: textCapitalization,
              inputFormatters: inputFormatters,
              autofillHints: autofillHints,
              textAlign: textAlign,
              cursorColor: AppColors.primary,
              style: textStyle ?? AppTextStyles.body.copyWith(fontSize: 15),
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
          label: _resolvedSemanticLabel,
          hint: _resolvedSemanticHint,
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
