import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/features/wallet/presentation/widgets/wallet_manager_common.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

class WalletManagerTabs extends StatelessWidget {
  const WalletManagerTabs({
    super.key,
    required this.activeTab,
    required this.onChanged,
  });

  final String activeTab;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitTabBar(
      activeKey: activeTab,
      onChanged: onChanged,
      variant: VitTabBarVariant.segment,
      tabs: const [
        VitTabItem(
          key: walletManagerTabAll,
          label: walletManagerTabAll,
          icon: Icons.account_balance_wallet_outlined,
          widgetKey: Key('sc148_multi_manager_tab_$walletManagerTabAll'),
        ),
        VitTabItem(
          key: walletManagerTabGroups,
          label: walletManagerTabGroups,
          icon: Icons.folder_outlined,
          widgetKey: Key('sc148_multi_manager_tab_$walletManagerTabGroups'),
        ),
        VitTabItem(
          key: walletManagerTabActivity,
          label: walletManagerTabActivity,
          icon: Icons.history_rounded,
          widgetKey: Key('sc148_multi_manager_tab_$walletManagerTabActivity'),
        ),
      ],
    );
  }
}
