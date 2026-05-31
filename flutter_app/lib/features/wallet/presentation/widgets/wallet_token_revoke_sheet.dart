import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/controllers/wallet_controller.dart';

class WalletTokenRevokeSheet extends StatelessWidget {
  const WalletTokenRevokeSheet({super.key, required this.preview});

  final TokenRevokePreview preview;

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
              preview.title,
              style: AppTextStyles.sectionTitle.copyWith(fontSize: 18),
            ),
            const SizedBox(height: 12),
            Text(
              preview.body,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                fontSize: 12,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _TokenSheetButton(
                    key: const Key('sc150_token_approval_sheet_cancel'),
                    label: 'Cancel',
                    background: AppColors.surface3,
                    color: AppColors.text2,
                    onTap: () => Navigator.of(context).pop(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _TokenSheetButton(
                    key: const Key('sc150_token_approval_sheet_confirm'),
                    label: preview.confirmLabel,
                    background: AppColors.sell,
                    color: AppColors.onAccent,
                    onTap: () => Navigator.of(context).pop(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TokenSheetButton extends StatelessWidget {
  const _TokenSheetButton({
    super.key,
    required this.label,
    required this.background,
    required this.color,
    required this.onTap,
  });

  final String label;
  final Color background;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label == 'Cancel' ? 'Cancel token revoke preview' : label,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          height: 46,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: background,
            borderRadius: AppRadii.inputRadius,
          ),
          child: Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}
