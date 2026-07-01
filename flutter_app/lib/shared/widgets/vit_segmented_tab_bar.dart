import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/shared/widgets/vit_tab_bar.dart';

/// Segment-style tab row for 2–5 navigation/filter tabs.
///
/// Do **not** wrap in [VitCard] or [DecoratedBox] with a border — each tab
/// already renders its own pill outline (ghost border when unselected).
class VitSegmentedTabBar extends StatelessWidget {
  const VitSegmentedTabBar({
    super.key,
    required this.tabs,
    required this.activeKey,
    required this.onChanged,
  });

  final List<VitTabItem> tabs;
  final String activeKey;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitTabBar(
      tabs: tabs,
      activeKey: activeKey,
      onChanged: onChanged,
      variant: VitTabBarVariant.segment,
    );
  }
}
