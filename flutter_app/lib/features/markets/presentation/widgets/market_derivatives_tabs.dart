import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/market_derivatives_common.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/markets_spacing_tokens.dart';

class MarketDerivativesTabs extends StatelessWidget {
  const MarketDerivativesTabs({
    super.key,
    required this.activeTab,
    required this.onChanged,
  });

  final String activeTab;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      child: SizedBox(
        height: MarketsSpacingTokens.marketDerivativesTabsHeight,
        child: VitTabBar(
          activeKey: activeTab,
          variant: VitTabBarVariant.underline,
          onChanged: onChanged,
          tabs: const [
            VitTabItem(
              key: 'overview',
              label: 'Tổng quan',
              widgetKey: MarketDerivativesKeys.overviewTab,
            ),
            VitTabItem(
              key: 'perpetual',
              label: 'Perpetual',
              widgetKey: MarketDerivativesKeys.perpetualTab,
            ),
            VitTabItem(
              key: 'liquidation',
              label: 'Thanh lý',
              widgetKey: MarketDerivativesKeys.liquidationTab,
            ),
          ],
        ),
      ),
    );
  }
}
