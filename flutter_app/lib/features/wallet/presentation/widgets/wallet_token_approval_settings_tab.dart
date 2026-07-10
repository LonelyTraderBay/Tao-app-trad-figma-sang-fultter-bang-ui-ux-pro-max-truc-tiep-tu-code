import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/widgets/wallet_token_approval_common.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_card.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_cta_button.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_toggle_pill.dart';
import 'package:vit_trade_flutter/app/theme/spacing/shared_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/spacing/wallet_spacing_tokens.dart';

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
    return VitPageSection(
      label: 'Security Settings',
      headerIcon: Icons.tune_rounded,
      accentColor: walletTokenApprovalPrimary,
      innerGap: AppSpacing.pageRhythmFormInnerGap,
      children: [
        WalletTokenApprovalSettingsRow(
          title: 'Auto-revoke Unused Approvals',
          description: 'Automatically revoke approvals unused for 90+ days',
          enabled: autoRevokeUnused,
          onTap: onAutoRevoke,
        ),
        const SizedBox(height: WalletSpacingTokens.walletTokenStatValueGap),
        WalletTokenApprovalSettingsRow(
          title: 'Warn Unlimited Approvals',
          description: 'Show warning before approving unlimited amounts',
          enabled: warnUnlimited,
          onTap: onWarnUnlimited,
        ),
        const SizedBox(height: WalletSpacingTokens.walletTokenNoticeGap),
        VitCtaButton(
          key: const Key('sc150_token_approval_scan_risky'),
          onPressed: onScanRisk,
          height: WalletSpacingTokens.walletTokenScanButtonHeight,
          leading: const Icon(Icons.manage_search_rounded),
          child: const Text('Scan for Risky Approvals'),
        ),
        const SizedBox(height: WalletSpacingTokens.walletTokenNoticeGap),
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
        density: VitDensity.compact,
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
                  const SizedBox(height: AppSpacing.pageRhythmFormSectionGap),
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
              width: SharedSpacingTokens.walletAddressSwitchWidth,
              height: SharedSpacingTokens.walletAddressSwitchHeight,
              knobSize: WalletSpacingTokens.walletTokenSwitchKnob,
              knobMargin: WalletSpacingTokens.walletTokenSwitchPadding,
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
      density: VitDensity.compact,
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
          const SizedBox(
            height: WalletSpacingTokens.walletAddressAddAssetLabelGap,
          ),
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
                  size: WalletSpacingTokens.walletTokenNoticeIcon,
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
