import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/live_market_chart_painter.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/live_market_common_widgets.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

part 'live_market_interest_funding.dart';
part 'live_market_interest_open_interest.dart';
part 'live_market_interest_ratio.dart';
part 'live_market_interest_top_traders.dart';

class LiveMarketInterestTab extends StatelessWidget {
  const LiveMarketInterestTab({required this.snapshot, super.key});

  final TradeMarketDataAnalyticsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _OpenInterestCard(data: snapshot.openInterest),
        const SizedBox(height: AppSpacing.liveMarketCardGap),
        _LongShortCard(data: snapshot.longShortRatio),
        const SizedBox(height: AppSpacing.liveMarketCardGap),
        _TopTradersCard(data: snapshot.topTraders),
        const SizedBox(height: AppSpacing.liveMarketCardGap),
        _FundingCard(data: snapshot.fundingRate),
      ],
    );
  }
}
