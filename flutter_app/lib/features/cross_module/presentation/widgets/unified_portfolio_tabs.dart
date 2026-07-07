import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/features/cross_module/domain/entities/unified_portfolio_entities.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/cross_module_spacing_tokens.dart';

class UnifiedPortfolioTabs extends StatelessWidget {
  const UnifiedPortfolioTabs({
    super.key,
    required this.tabs,
    required this.active,
    required this.tabKey,
    required this.onChanged,
  });

  final List<UnifiedPortfolioTabDraft> tabs;
  final UnifiedPortfolioTab active;
  final Key Function(UnifiedPortfolioTab tab) tabKey;
  final ValueChanged<UnifiedPortfolioTab> onChanged;

  @override
  Widget build(BuildContext context) {
    final tabItems = [
      for (final tab in tabs)
        VitTabItem(
          key: tab.tab.name,
          label: tab.label,
          widgetKey: tabKey(tab.tab),
        ),
    ];

    return DecoratedBox(
      decoration: const ShapeDecoration(
        color: AppColors.surface,
        shape: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Padding(
        padding: CrossModuleSpacingTokens.crossModuleTabBarPadding,
        child: VitSegmentedTabBar(
          tabs: tabItems,
          activeKey: active.name,
          onChanged: (key) {
            final selected = tabs.firstWhere((tab) => tab.tab.name == key);
            onChanged(selected.tab);
          },
        ),
      ),
    );
  }
}
