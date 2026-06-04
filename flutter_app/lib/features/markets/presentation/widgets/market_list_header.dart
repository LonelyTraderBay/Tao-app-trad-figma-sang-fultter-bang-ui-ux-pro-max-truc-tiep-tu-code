import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/shared/layout/vit_header_action_button.dart';
import 'package:vit_trade_flutter/shared/layout/vit_top_chrome.dart';

class MarketListHeader extends StatelessWidget {
  const MarketListHeader({super.key, required this.onNavigate});

  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    return VitTopChrome(
      type: VitTopChromeType.rootModule,
      title: 'Th\u1ECB tr\u01B0\u1EDDng',
      actions: [
        VitHeaderActionItem(
          type: VitHeaderActionType.overview,
          tooltip: 'T\u1ED5ng quan th\u1ECB tr\u01B0\u1EDDng',
          onPressed: () => onNavigate('/markets/overview'),
        ),
        VitHeaderActionItem(
          type: VitHeaderActionType.analytics,
          tooltip: 'Bi\u1EBFn \u0111\u1ED9ng',
          onPressed: () => onNavigate('/markets/movers'),
        ),
        VitHeaderActionItem(
          type: VitHeaderActionType.sectors,
          tooltip: 'Ng\u00E0nh',
          onPressed: () => onNavigate('/markets/sectors'),
        ),
      ],
    );
  }
}
