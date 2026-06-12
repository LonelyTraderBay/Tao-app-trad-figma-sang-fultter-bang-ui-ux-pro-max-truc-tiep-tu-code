import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/widgets/wallet_token_approval_common.dart';

class WalletTokenApprovalTabs extends StatelessWidget {
  const WalletTokenApprovalTabs({
    required this.activeTab,
    required this.onChanged,
    super.key,
  });

  final String activeTab;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSpacing.walletTokenTabsHeight,
      decoration: const BoxDecoration(
        color: walletTokenApprovalPanel,
        border: Border(bottom: BorderSide(color: walletTokenApprovalBorder)),
      ),
      child: Row(
        children: [
          for (final tab in const [
            walletTokenApprovalTabActive,
            walletTokenApprovalTabHistory,
            walletTokenApprovalTabSettings,
          ])
            Expanded(
              child: Semantics(
                button: true,
                selected: activeTab == tab,
                label:
                    '${walletTokenApprovalTabSemanticLabel(tab)} approvals tab',
                child: GestureDetector(
                  key: walletTokenApprovalTabKey(tab),
                  onTap: () => onChanged(tab),
                  behavior: HitTestBehavior.opaque,
                  child: Stack(
                    children: [
                      Center(
                        child: Text(
                          tab,
                          style: AppTextStyles.caption.copyWith(
                            color: activeTab == tab
                                ? walletTokenApprovalPrimary
                                : AppColors.textDisabled,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                      ),
                      Positioned(
                        left: AppSpacing.walletTokenTabIndicatorInset,
                        right: AppSpacing.walletTokenTabIndicatorInset,
                        bottom: 0,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          height: AppSpacing.tabBarUnderlineHeight,
                          color: activeTab == tab
                              ? walletTokenApprovalPrimary
                              : AppColors.transparent,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
