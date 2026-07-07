import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/controllers/wallet_controller.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/widgets/wallet_token_approval_common.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_card.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_cta_button.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_high_risk_state_panel.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_info_row.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_inset_scroll_view.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_sheet_handle.dart';
import 'package:vit_trade_flutter/app/theme/spacing/wallet_spacing_tokens.dart';

class WalletTokenRevokeSheet extends StatelessWidget {
  const WalletTokenRevokeSheet({super.key, required this.preview});

  final TokenRevokePreview preview;

  @override
  Widget build(BuildContext context) {
    final lines = preview.body.split('\n');
    final intro = lines.first;
    final rows = [
      for (final line in lines.skip(1)) _TokenPreviewRow.fromLine(line),
    ].whereType<_TokenPreviewRow>().toList(growable: false);

    return VitSheetPanel(
      title: preview.title,
      child: VitInsetScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            VitHighRiskStatePanel(
              state: VitHighRiskUiState.riskReview,
              title: preview.bulk
                  ? 'Bulk revoke preview'
                  : 'Token revoke preview',
              message: intro,
              contractId: preview.bulk
                  ? 'Multiple high-risk approvals'
                  : 'Single approval review',
              density: VitDensity.compact,
            ),
            const SizedBox(height: WalletSpacingTokens.walletTokenNoticeGap),
            VitCard(
              density: VitDensity.compact,
              variant: VitCardVariant.inner,
              borderColor: walletTokenApprovalBorder,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var i = 0; i < rows.length; i++)
                    VitInfoRow(
                      label: rows[i].label,
                      value: rows[i].value,
                      density: VitDensity.compact,
                      showDivider: i != rows.length - 1,
                    ),
                ],
              ),
            ),
            const SizedBox(height: WalletSpacingTokens.walletTokenNoticeGap),
            Row(
              children: [
                Expanded(
                  child: _TokenSheetButton(
                    key: walletTokenApprovalRevokeSheetCancelKey,
                    label: 'Cancel',
                    onTap: () => Navigator.of(context).pop(),
                  ),
                ),
                const SizedBox(width: AppSpacing.rowGapRegular),
                Expanded(
                  child: _TokenSheetButton(
                    key: walletTokenApprovalRevokeSheetConfirmKey,
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

class _TokenPreviewRow {
  const _TokenPreviewRow({required this.label, required this.value});

  final String label;
  final String value;

  static _TokenPreviewRow? fromLine(String line) {
    final separator = line.indexOf(':');
    if (separator <= 0 || separator >= line.length - 1) {
      return null;
    }
    return _TokenPreviewRow(
      label: line.substring(0, separator),
      value: line.substring(separator + 1).trim(),
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
        height: WalletSpacingTokens.walletTokenSheetButtonHeight,
        child: Text(label),
      ),
    );
  }
}
