import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/controllers/wallet_controller.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/widgets/transfer/withdraw_common.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_card.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_cta_button.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_info_row.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_sheet_handle.dart';
import 'package:vit_trade_flutter/app/theme/spacing/wallet_spacing_tokens.dart';

class WithdrawPreviewSheet extends StatelessWidget {
  const WithdrawPreviewSheet({required this.preview, super.key});

  final WithdrawPreview preview;

  @override
  Widget build(BuildContext context) {
    return VitSheetPanel(
      title: 'Xác nhận rút tiền',
      child: ListView(
        shrinkWrap: true,
        children: [
          VitInfoRow(
            label: 'Số lượng',
            value: preview.amountLabel,
            density: VitDensity.compact,
            showDivider: true,
          ),
          VitInfoRow(
            label: 'Mạng lưới',
            value: preview.networkName,
            density: VitDensity.compact,
            showDivider: true,
          ),
          VitInfoRow(
            label: 'Phí mạng',
            value: preview.feeLabel,
            density: VitDensity.compact,
            showDivider: true,
          ),
          VitInfoRow(
            label: 'Nhận dự kiến',
            value: preview.receivedLabel,
            density: VitDensity.compact,
            showDivider: true,
          ),
          VitInfoRow(
            label: 'Địa chỉ nhận',
            value: preview.maskedAddress,
            density: VitDensity.compact,
          ),
          const SizedBox(height: WalletSpacingTokens.transferInfoGap),
          VitCard(
            variant: VitCardVariant.inner,
            density: VitDensity.compact,
            borderColor: withdrawAmber.withValues(alpha: .24),
            child: Text(
              'High-risk action: preview + confirm + audit trail required.',
              style: AppTextStyles.caption.copyWith(color: withdrawAmber),
            ),
          ),
          const SizedBox(height: WalletSpacingTokens.transferInfoGap),
          Row(
            children: [
              Expanded(
                child: WithdrawConfirmActionButton(
                  key: withdrawCancelConfirmKey,
                  label: 'Hủy',
                  onTap: () => Navigator.of(context).pop(),
                ),
              ),
              const SizedBox(width: AppSpacing.pageRhythmStandardInnerGap),
              Expanded(
                child: WithdrawConfirmActionButton(
                  key: withdrawConfirmWithdrawKey,
                  label: 'Xác nhận rút',
                  primary: true,
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

class WithdrawConfirmActionButton extends StatelessWidget {
  const WithdrawConfirmActionButton({
    required this.label,
    required this.onTap,
    this.primary = false,
    super.key,
  });

  final String label;
  final VoidCallback onTap;
  final bool primary;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: true,
      label: primary ? 'Xác nhận rút' : 'Hủy xem trước lệnh rút',
      child: VitCtaButton(
        height: AppSpacing.ctaHeight,
        variant: primary
            ? VitCtaButtonVariant.warning
            : VitCtaButtonVariant.secondary,
        onPressed: onTap,
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(fontWeight: AppTextStyles.bold),
        ),
      ),
    );
  }
}
