import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/widgets/wallet_token_approval_common.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_card.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_cta_button.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_toggle_pill.dart';

class WalletTokenApprovalSettingsTab extends StatelessWidget {
  const WalletTokenApprovalSettingsTab({
    required this.autoRevokeUnused,
    required this.warnUnlimited,
    required this.onAutoRevoke,
    required this.onWarnUnlimited,
    required this.onScanRisk,
    super.key,
  });

  final bool autoRevokeUnused;
  final bool warnUnlimited;
  final VoidCallback onAutoRevoke;
  final VoidCallback onWarnUnlimited;
  final VoidCallback onScanRisk;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const WalletTokenApprovalSectionLabel(label: 'Security Settings'),
        const SizedBox(height: AppSpacing.walletTokenStatValueGap),
        WalletTokenApprovalSettingsRow(
          title: 'Auto-revoke Unused Approvals',
          description: 'Automatically revoke approvals unused for 90+ days',
          enabled: autoRevokeUnused,
          onTap: onAutoRevoke,
        ),
        const SizedBox(height: AppSpacing.walletTokenStatValueGap),
        WalletTokenApprovalSettingsRow(
          title: 'Warn Unlimited Approvals',
          description: 'Show warning before approving unlimited amounts',
          enabled: warnUnlimited,
          onTap: onWarnUnlimited,
        ),
        const SizedBox(height: AppSpacing.walletTokenNoticeGap),
        VitCtaButton(
          key: const Key('sc150_token_approval_scan_risky'),
          onPressed: onScanRisk,
          height: AppSpacing.walletTokenScanButtonHeight,
          child: const Text('Scan for Risky Approvals'),
        ),
        const SizedBox(height: AppSpacing.walletTokenNoticeGap),
        const WalletTokenApprovalBestPracticesCard(),
      ],
    );
  }
}

class WalletTokenApprovalSettingsRow extends StatelessWidget {
  const WalletTokenApprovalSettingsRow({
    required this.title,
    required this.description,
    required this.enabled,
    required this.onTap,
    super.key,
  });

  final String title;
  final String description;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: enabled,
      label: '$title setting',
      value: enabled ? 'Enabled' : 'Disabled',
      child: VitCard(
        padding: AppSpacing.cardPadding,
        borderColor: walletTokenApprovalBorder,
        onTap: onTap,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.walletAddressSectionGap),
                  Text(
                    description,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text3,
                    ),
                  ),
                ],
              ),
            ),
            VitTogglePill(
              enabled: enabled,
              width: AppSpacing.walletAddressSwitchWidth,
              height: AppSpacing.walletAddressSwitchHeight,
              knobSize: AppSpacing.walletTokenSwitchKnob,
              knobMargin: AppSpacing.walletTokenSwitchPadding,
              activeColor: walletTokenApprovalPrimary,
              inactiveColor: AppColors.surface3,
              inactiveKnobColor: AppColors.onAccent,
              duration: const Duration(milliseconds: 150),
            ),
          ],
        ),
      ),
    );
  }
}

class WalletTokenApprovalBestPracticesCard extends StatelessWidget {
  const WalletTokenApprovalBestPracticesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: AppSpacing.cardPadding,
      borderColor: walletTokenApprovalBorder,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Best Practices',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.walletAddressAddAssetLabelGap),
          for (final tip in const [
            'Regularly review active approvals',
            'Revoke unused or old approvals',
            'Avoid unlimited approvals when possible',
            'Only approve verified contracts',
          ]) ...[
            Row(
              children: [
                const Icon(
                  Icons.check_circle_outline_rounded,
                  color: walletTokenApprovalGreen,
                  size: AppSpacing.walletTokenNoticeIcon,
                ),
                const SizedBox(width: AppSpacing.rowGap),
                Expanded(
                  child: Text(
                    tip,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.rowGap),
          ],
        ],
      ),
    );
  }
}
