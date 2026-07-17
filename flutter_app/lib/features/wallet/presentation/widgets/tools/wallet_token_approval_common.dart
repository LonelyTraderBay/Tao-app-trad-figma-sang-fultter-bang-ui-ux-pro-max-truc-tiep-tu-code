import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_card.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_cta_button.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_status_pill.dart';
import 'package:vit_trade_flutter/app/theme/spacing/wallet_spacing_tokens.dart';

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
    walletTokenApprovalTabActive => 'Đang hoạt động',
    walletTokenApprovalTabHistory => 'Lịch sử',
    walletTokenApprovalTabSettings => 'Cài đặt',
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

VitStatusPillStatus walletTokenApprovalRiskStatus(String risk) {
  return switch (risk) {
    'critical' => VitStatusPillStatus.error,
    'high' => VitStatusPillStatus.orange,
    'medium' => VitStatusPillStatus.warning,
    'low' => VitStatusPillStatus.success,
    _ => VitStatusPillStatus.neutral,
  };
}

IconData walletTokenApprovalRiskIcon(String risk) {
  return switch (risk) {
    'critical' => Icons.report_gmailerrorred_rounded,
    'high' => Icons.warning_amber_rounded,
    'medium' => Icons.info_outline_rounded,
    'low' => Icons.verified_user_outlined,
    _ => Icons.shield_outlined,
  };
}

String walletTokenApprovalRiskLabel(String risk) {
  return switch (risk) {
    'critical' => 'CRITICAL',
    'high' => 'HIGH',
    'medium' => 'MEDIUM',
    'low' => 'LOW',
    _ => risk.toUpperCase(),
  };
}

class WalletTokenApprovalRevokeAllButton extends StatelessWidget {
  const WalletTokenApprovalRevokeAllButton({required this.onTap, super.key});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Thu hồi tất cả ủy quyền token rủi ro cao',
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
    return VitCard(
      density: VitDensity.compact,
      variant: VitCardVariant.inner,
      borderColor: AppColors.primary20,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: walletTokenApprovalPrimary,
            size: WalletSpacingTokens.walletTokenNoticeIcon,
          ),
          const SizedBox(
            width: WalletSpacingTokens.walletTokenApprovalHeaderGap,
          ),
          Expanded(
            child: Text(
              'Token approvals allow smart contracts to spend your tokens. Revoke unused or suspicious approvals to protect your assets.',
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
          ),
        ],
      ),
    );
  }
}
