import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/controllers/wallet_controller.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/widgets/tools/wallet_token_approval_common.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_card.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_cta_button.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_high_risk_state_panel.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_info_row.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_sheet_handle.dart';
import 'package:vit_trade_flutter/app/theme/spacing/wallet_spacing_tokens.dart';

class WalletTokenRevokeSheet extends StatelessWidget {
  const WalletTokenRevokeSheet({super.key, required this.preview});

  final TokenRevokePreview preview;

  @override
  Widget build(BuildContext context) {
    // Confirm / risk-review sheets prefer calmer density (craft #6).
    const confirmDensity = VitDensity.standard;
    final lines = preview.body.split('\n');
    final intro = lines.first;
    final rows = [
      for (final line in lines.skip(1)) _TokenPreviewRow.fromLine(line),
    ].whereType<_TokenPreviewRow>().toList(growable: false);
    final allowanceMatches = [
      for (final row in rows)
        if (row.label == 'Hạn mức') row.value,
    ];
    final allowance = allowanceMatches.isEmpty ? null : allowanceMatches.first;
    final detailRows = rows
        .where((row) => row.label != 'Hạn mức')
        .toList(growable: false);

    return VitSheetPanel(
      title: preview.title,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView(
              children: [
                VitHighRiskStatePanel(
                  state: VitHighRiskUiState.riskReview,
                  title: preview.bulk
                      ? 'Xem trước thu hồi hàng loạt'
                      : 'Xem trước thu hồi token',
                  message: intro,
                  // Snapshot has no highRiskContractId — do not invent one.
                  density: confirmDensity,
                ),
                if (allowance != null) ...[
                  const SizedBox(
                    height: WalletSpacingTokens.walletTokenNoticeGap,
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.symmetric(
                      horizontal: AppSpacing.x4,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Hạn mức',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text3,
                            ),
                          ),
                        ),
                        Flexible(
                          child: Text(
                            allowance,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.end,
                            style: AppTextStyles.amountSm.copyWith(
                              color: AppColors.text1,
                              fontFeatures: AppTextStyles.tabularFigures,
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    height: AppSpacing.dividerHairline,
                    thickness: AppSpacing.dividerHairline,
                    color: AppColors.border,
                  ),
                ],
                const SizedBox(
                  height: WalletSpacingTokens.walletTokenNoticeGap,
                ),
                VitCard(
                  density: confirmDensity,
                  variant: VitCardVariant.inner,
                  borderColor: walletTokenApprovalBorder,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (var i = 0; i < detailRows.length; i++)
                        VitInfoRow(
                          label: detailRows[i].label,
                          value: detailRows[i].value,
                          density: confirmDensity,
                          showDivider: i != detailRows.length - 1,
                        ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: WalletSpacingTokens.walletTokenNoticeGap,
                ),
                VitCard(
                  variant: VitCardVariant.inner,
                  density: confirmDensity,
                  borderColor: AppColors.riskWarning.withValues(alpha: .24),
                  child: Text(
                    'Không hoàn tác sau khi xác nhận. Bước tiếp theo: phát sóng giao dịch thu hồi trên mạng và cập nhật danh sách phê duyệt.',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.riskWarning,
                    ),
                  ),
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
                  label: 'Hủy',
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
      label: label == 'Hủy' ? 'Hủy xem trước thu hồi token' : label,
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
