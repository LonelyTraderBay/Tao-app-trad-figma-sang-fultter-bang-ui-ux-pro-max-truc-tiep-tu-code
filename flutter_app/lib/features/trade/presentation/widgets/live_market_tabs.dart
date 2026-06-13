import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/live_market_common_widgets.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/live_market_interest_cards.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/live_market_liquidations.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/live_market_sentiment.dart';

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
    return Container(
      height: 53,
      color: liveMarketPanel,
      child: Row(
        children: [
          for (final tab in _tabs)
            Expanded(
              child: InkWell(
                key: keyBuilder(tab.$1),
                onTap: () => onChanged(tab.$1),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 28),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: activeId == tab.$1
                            ? liveMarketPrimary
                            : AppColors.transparent,
                        width: 2,
                      ),
                    ),
                  ),
                  child: Text(
                    tab.$2,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.captionSm.copyWith(
                      color: activeId == tab.$1
                          ? liveMarketPrimary
                          : AppColors.text3,
                      fontWeight: AppTextStyles.bold,
                      height: 1,
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
