import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_cta_button.dart';

const walletTokenApprovalBackground = AppColors.bg;
const walletTokenApprovalPanel = AppColors.surface;
const walletTokenApprovalBorder = AppColors.overlayStroke;
const walletTokenApprovalPrimary = AppColors.primary;
const walletTokenApprovalGreen = AppColors.buy;
const walletTokenApprovalAmber = AppColors.caution;
const walletTokenApprovalOrange = AppColors.riskHigh;
const walletTokenApprovalRed = AppColors.sell;
const walletTokenApprovalPurple = AppColors.accent;

const walletTokenApprovalTabActive = 'Ho\u1EA1t \u0111\u1ED9ng';
const walletTokenApprovalTabHistory = 'L\u1ECBch s\u1EED';
const walletTokenApprovalTabSettings = 'C\u00E0i \u0111\u1EB7t';

const walletTokenApprovalContentKey = Key('sc150_token_approval_content');
const walletTokenApprovalRevokeAllKey = Key('sc150_token_approval_revoke_all');
const walletTokenApprovalRevokeSheetCancelKey = Key(
  'sc150_token_approval_sheet_cancel',
);
const walletTokenApprovalRevokeSheetConfirmKey = Key(
  'sc150_token_approval_sheet_confirm',
);

Key walletTokenApprovalTabKey(String label) {
  return Key('sc150_token_approval_tab_$label');
}

Key walletTokenApprovalApprovalKey(String id) {
  return Key('sc150_token_approval_$id');
}

Key walletTokenApprovalRevokeKey(String id) {
  return Key('sc150_token_approval_revoke_$id');
}

String walletTokenApprovalTabSemanticLabel(String tab) {
  return switch (tab) {
    walletTokenApprovalTabActive => 'Active',
    walletTokenApprovalTabHistory => 'History',
    walletTokenApprovalTabSettings => 'Settings',
    _ => tab,
  };
}

Color walletTokenApprovalRiskColor(String risk) {
  return switch (risk) {
    'critical' => walletTokenApprovalRed,
    'high' => walletTokenApprovalOrange,
    'medium' => walletTokenApprovalAmber,
    'low' => walletTokenApprovalGreen,
    _ => AppColors.text3,
  };
}

class WalletTokenApprovalSectionLabel extends StatelessWidget {
  const WalletTokenApprovalSectionLabel({required this.label, super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: AppSpacing.walletTokenSectionMarkerWidth,
          height: AppSpacing.walletTokenSectionMarkerHeight,
          decoration: BoxDecoration(
            color: walletTokenApprovalPrimary,
            borderRadius: BorderRadius.circular(
              AppSpacing.walletTokenSectionMarkerRadius,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.walletAddressSectionGap),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textMutedBlue,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}

class WalletTokenApprovalRevokeAllButton extends StatelessWidget {
  const WalletTokenApprovalRevokeAllButton({required this.onTap, super.key});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Revoke all high-risk token approvals',
      child: VitCtaButton(
        key: walletTokenApprovalRevokeAllKey,
        onPressed: onTap,
        variant: VitCtaButtonVariant.danger,
        height: AppSpacing.inputHeight,
        leading: const Icon(Icons.delete_outline_rounded),
        child: const Text('Revoke All High-Risk Approvals'),
      ),
    );
  }
}

class WalletTokenApprovalInfoNotice extends StatelessWidget {
  const WalletTokenApprovalInfoNotice({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        minHeight: AppSpacing.walletTokenNoticeMinHeight,
      ),
      padding: AppSpacing.walletTokenNoticePadding,
      decoration: BoxDecoration(
        color: walletTokenApprovalPrimary.withValues(alpha: .08),
        borderRadius: AppRadii.cardRadius,
        border: Border.all(
          color: walletTokenApprovalPrimary.withValues(alpha: .20),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: walletTokenApprovalPrimary,
            size: AppSpacing.walletTokenNoticeIcon,
          ),
          const SizedBox(width: AppSpacing.walletTokenApprovalHeaderGap),
          Expanded(
            child: Text(
              'Token approvals allow smart contracts to spend your tokens. Revoke unused or suspicious approvals to protect your assets.',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                height: 1.48,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
