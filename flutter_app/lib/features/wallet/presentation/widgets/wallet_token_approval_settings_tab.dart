import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/widgets/wallet_token_approval_common.dart';

class WalletTokenApprovalSettingsTab extends StatelessWidget {
  const WalletTokenApprovalSettingsTab({
    required this.autoRevokeUnused,
    required this.warnUnlimited,
    required this.onAutoRevoke,
    required this.onWarnUnlimited,
    super.key,
  });

  final bool autoRevokeUnused;
  final bool warnUnlimited;
  final VoidCallback onAutoRevoke;
  final VoidCallback onWarnUnlimited;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const WalletTokenApprovalSectionLabel(label: 'Security Settings'),
        const SizedBox(height: 10),
        WalletTokenApprovalSettingsRow(
          title: 'Auto-revoke Unused Approvals',
          description: 'Automatically revoke approvals unused for 90+ days',
          enabled: autoRevokeUnused,
          onTap: onAutoRevoke,
        ),
        const SizedBox(height: 10),
        WalletTokenApprovalSettingsRow(
          title: 'Warn Unlimited Approvals',
          description: 'Show warning before approving unlimited amounts',
          enabled: warnUnlimited,
          onTap: onWarnUnlimited,
        ),
        const SizedBox(height: 16),
        Container(
          height: 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: walletTokenApprovalPrimary,
            borderRadius: AppRadii.inputRadius,
          ),
          child: Text(
            'Scan for Risky Approvals',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.onAccent,
              fontSize: 14,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        const SizedBox(height: 16),
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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: walletTokenApprovalPanel,
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: walletTokenApprovalBorder),
      ),
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
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Semantics(
            button: true,
            selected: enabled,
            label: '$title setting',
            value: enabled ? 'Enabled' : 'Disabled',
            child: GestureDetector(
              onTap: onTap,
              behavior: HitTestBehavior.opaque,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 48,
                height: 28,
                padding: const EdgeInsets.all(2),
                alignment: enabled
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: enabled
                      ? walletTokenApprovalPrimary
                      : AppColors.surface3,
                  borderRadius: AppRadii.inputRadius,
                ),
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    color: AppColors.onAccent,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WalletTokenApprovalBestPracticesCard extends StatelessWidget {
  const WalletTokenApprovalBestPracticesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: walletTokenApprovalPanel,
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: walletTokenApprovalBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Best Practices',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontSize: 13,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 12),
          for (final tip in const [
            'Regularly review active approvals',
            'Revoke unused or old approvals',
            'Avoid unlimited approvals when possible',
            'Only approve verified contracts',
          ])
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle_outline_rounded,
                    color: walletTokenApprovalGreen,
                    size: 14,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      tip,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
