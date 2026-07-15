import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/widgets/tools/wallet_token_approval_common.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_tab_bar.dart';
import 'package:vit_trade_flutter/app/theme/spacing/wallet_spacing_tokens.dart';

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
    return ColoredBox(
      color: walletTokenApprovalPanel,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: WalletSpacingTokens.walletTokenTabsHeight,
            child: Semantics(
              container: true,
              label:
                  '${walletTokenApprovalTabSemanticLabel(activeTab)} approvals tab',
              child: VitTabBar(
                variant: VitTabBarVariant.underline,
                activeKey: activeTab,
                onChanged: onChanged,
                tabs: [
                  for (final tab in const [
                    walletTokenApprovalTabActive,
                    walletTokenApprovalTabHistory,
                    walletTokenApprovalTabSettings,
                  ])
                    VitTabItem(
                      key: tab,
                      label: tab,
                      widgetKey: walletTokenApprovalTabKey(tab),
                    ),
                ],
              ),
            ),
          ),
          const Divider(
            height: AppSpacing.dividerHairline,
            color: walletTokenApprovalBorder,
          ),
        ],
      ),
    );
  }
}
