import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/features/trade_compliance/presentation/widgets/execution/live_market_common_widgets.dart';
import 'package:vit_trade_flutter/features/trade_compliance/presentation/widgets/execution/live_market_interest_cards.dart';
import 'package:vit_trade_flutter/features/trade_compliance/presentation/widgets/execution/live_market_liquidations.dart';
import 'package:vit_trade_flutter/features/trade_compliance/presentation/widgets/execution/live_market_sentiment.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

class LiveMarketUnderlineTabs extends StatelessWidget {
  const LiveMarketUnderlineTabs({
    super.key,
    required this.activeId,
    required this.onChanged,
    required this.keyBuilder,
  });

  final String activeId;
  final ValueChanged<String> onChanged;
  final Key Function(String id) keyBuilder;

  static const _tabs = [
    ('market', 'Market Data'),
    ('liquidations', 'Liquidations'),
    ('sentiment', 'Sentiment'),
  ];

  @override
  Widget build(BuildContext context) {
    return LiveMarketCard(
      variant: VitCardVariant.inner,
      borderColor: liveMarketBorder,
      padding: AppSpacing.zeroInsets,
      child: VitTabBar(
        tabs: [
          for (final tab in _tabs)
            VitTabItem(
              key: tab.$1,
              label: tab.$2,
              widgetKey: keyBuilder(tab.$1),
            ),
        ],
        activeKey: activeId,
        onChanged: onChanged,
        variant: VitTabBarVariant.underline,
      ),
    );
  }
}

class LiveMarketTabContent extends StatelessWidget {
  const LiveMarketTabContent({
    super.key,
    required this.activeTab,
    required this.snapshot,
  });

  final String activeTab;
  final TradeMarketDataAnalyticsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return switch (activeTab) {
      'market' => LiveMarketInterestTab(snapshot: snapshot),
      'liquidations' => LiveMarketLiquidationsTab(snapshot: snapshot),
      _ => LiveMarketSentimentTab(snapshot: snapshot),
    };
  }
}
