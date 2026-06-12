import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/controllers/wallet_controller.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_cta_button.dart';

class WalletTokenRevokeSheet extends StatelessWidget {
  const WalletTokenRevokeSheet({super.key, required this.preview});

  final TokenRevokePreview preview;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: AppSpacing.transferSheetPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(preview.title, style: AppTextStyles.sectionTitle),
            const SizedBox(height: AppSpacing.walletAddressAddAssetLabelGap),
            Text(
              preview.body,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                height: 1.45,
              ),
            ),
            const SizedBox(height: AppSpacing.walletTokenNoticeGap),
            Row(
              children: [
                Expanded(
                  child: _TokenSheetButton(
                    key: const Key('sc150_token_approval_sheet_cancel'),
                    label: 'Cancel',
                    onTap: () => Navigator.of(context).pop(),
                  ),
                ),
                const SizedBox(width: AppSpacing.rowGapRegular),
                Expanded(
                  child: _TokenSheetButton(
                    key: const Key('sc150_token_approval_sheet_confirm'),
                    label: preview.confirmLabel,
                    danger: true,
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
    this.danger = false,
    required this.onTap,
  });

  final String label;
  final bool danger;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label == 'Cancel' ? 'Cancel token revoke preview' : label,
      child: VitCtaButton(
        onPressed: onTap,
        variant: danger
            ? VitCtaButtonVariant.danger
            : VitCtaButtonVariant.secondary,
        height: AppSpacing.walletTokenSheetButtonHeight,
        child: Text(label),
      ),
    );
  }
}
