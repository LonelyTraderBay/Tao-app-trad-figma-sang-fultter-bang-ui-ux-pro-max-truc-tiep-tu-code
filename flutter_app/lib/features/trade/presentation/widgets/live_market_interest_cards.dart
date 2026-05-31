import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/live_market_chart_painter.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/live_market_common_widgets.dart';

class LiveMarketInterestTab extends StatelessWidget {
  const LiveMarketInterestTab({required this.snapshot, super.key});

  final TradeMarketDataAnalyticsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _OpenInterestCard(data: snapshot.openInterest),
        const SizedBox(height: 12),
        _LongShortCard(data: snapshot.longShortRatio),
        const SizedBox(height: 12),
        _TopTradersCard(data: snapshot.topTraders),
        const SizedBox(height: 12),
        _FundingCard(data: snapshot.fundingRate),
      ],
    );
  }
}

class _OpenInterestCard extends StatelessWidget {
  const _OpenInterestCard({required this.data});

  final TradeMarketOpenInterest data;

  @override
  Widget build(BuildContext context) {
    final positive = data.change24hPct >= 0;
    final tone = positive ? liveMarketGreen : liveMarketRed;
    return LiveMarketCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const LiveMarketCardHeader(
            icon: Icons.show_chart_rounded,
            color: liveMarketPrimary,
            title: 'Open Interest',
            trailing: 'BTC/USDT >',
          ),
          const SizedBox(height: 18),
          const LiveMarketMutedLabel('Total Open Interest'),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                formatLiveMarketMillions(data.current),
                style: AppTextStyles.sectionTitle.copyWith(
                  color: AppColors.text1,
                  fontSize: 26,
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                  height: 1,
                ),
              ),
              const SizedBox(width: 8),
              LiveMarketChip(
                label:
                    '${positive ? '+' : ''}${data.change24hPct.toStringAsFixed(2)}%',
                color: tone,
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: LiveMarketMetricBox(
                  label: 'Change 24h',
                  value:
                      '${positive ? '+' : ''}${formatLiveMarketMillions(data.change24h)}',
                  color: tone,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: LiveMarketMetricBox(
                  label: 'High 24h',
                  value: formatLiveMarketMillions(data.high24h),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: LiveMarketMetricBox(
                  label: 'Low 24h',
                  value: formatLiveMarketMillions(data.low24h),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const LiveMarketInfoStrip(),
        ],
      ),
    );
  }
}

class _LongShortCard extends StatelessWidget {
  const _LongShortCard({required this.data});

  final TradeMarketLongShortRatio data;

  @override
  Widget build(BuildContext context) {
    return LiveMarketCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const LiveMarketCardHeader(
            icon: Icons.groups_2_outlined,
            color: liveMarketPurple,
            title: 'Long/Short Ratio',
            badge: 'Long',
          ),
          const SizedBox(height: 16),
          const _ToggleBar(),
          const SizedBox(height: 16),
          Row(
            children: [
              _TrendLabel(
                text: 'Long ${data.longPct.toStringAsFixed(1)}%',
                color: liveMarketGreen,
                icon: Icons.trending_up_rounded,
              ),
              const Spacer(),
              _TrendLabel(
                text: 'Short ${data.shortPct.toStringAsFixed(1)}%',
                color: liveMarketRed,
                icon: Icons.trending_down_rounded,
                iconAfter: true,
              ),
            ],
          ),
          const SizedBox(height: 9),
          LiveMarketRatioBar(longPct: data.longPct),
          const SizedBox(height: 10),
          Text(
            'Long/Short Ratio',
            textAlign: TextAlign.center,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 10,
              height: 1,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            data.ratio.toStringAsFixed(2),
            textAlign: TextAlign.center,
            style: AppTextStyles.sectionTitle.copyWith(
              color: liveMarketGreen,
              fontSize: 21,
              fontWeight: AppTextStyles.bold,
              fontFamily: 'monospace',
              fontFeatures: AppTextStyles.tabularFigures,
              height: 1,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: LiveMarketMetricBox(
                  label: 'Long Accounts',
                  value: formatLiveMarketInt(data.longAccounts),
                  color: liveMarketGreen,
                  bg: liveMarketGreen.withValues(alpha: .09),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: LiveMarketMetricBox(
                  label: 'Short Accounts',
                  value: formatLiveMarketInt(data.shortAccounts),
                  color: liveMarketRed,
                  bg: liveMarketRed.withValues(alpha: .08),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TopTradersCard extends StatelessWidget {
  const _TopTradersCard({required this.data});

  final TradeTopTraderPositions data;

  @override
  Widget build(BuildContext context) {
    final shortShift = data.change24h < 0;
    return LiveMarketCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const LiveMarketCardHeader(
            icon: Icons.visibility_rounded,
            color: liveMarketAmber,
            title: 'Top Traders',
            badge: 'Long',
          ),
          const SizedBox(height: 16),
          Container(
            height: 113,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: liveMarketGreen.withValues(alpha: .09),
              border: Border.all(color: liveMarketGreen.withValues(alpha: .2)),
              borderRadius: AppRadii.cardRadius,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const LiveMarketMutedLabel(
                  'Top traders dang Long',
                  align: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  '${data.longPct.toStringAsFixed(1)}%',
                  style: AppTextStyles.heroNumber.copyWith(
                    color: liveMarketGreen,
                    fontSize: 36,
                    fontFamily: 'monospace',
                    height: 1,
                  ),
                ),
                const SizedBox(height: 9),
                const LiveMarketMutedLabel(
                  'of top traders are long',
                  align: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          LiveMarketRatioBar(longPct: data.longPct),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.fromLTRB(12, 11, 12, 11),
            decoration: BoxDecoration(
              color: liveMarketPanel2,
              borderRadius: AppRadii.cardRadius,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const LiveMarketMutedLabel('24h Change'),
                      const SizedBox(height: 7),
                      Text(
                        'Shifted ${data.change24h.abs().toStringAsFixed(1)}% to ${shortShift ? 'Short' : 'Long'}',
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.text1,
                          fontSize: 14,
                          fontWeight: AppTextStyles.bold,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: (shortShift ? liveMarketRed : liveMarketGreen)
                        .withValues(alpha: .12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    shortShift
                        ? Icons.trending_down_rounded
                        : Icons.trending_up_rounded,
                    color: shortShift ? liveMarketRed : liveMarketGreen,
                    size: 23,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          LiveMarketInfoStrip(
            bg: liveMarketAmber.withValues(alpha: .06),
            color: liveMarketAmber,
          ),
        ],
      ),
    );
  }
}

class _FundingCard extends StatelessWidget {
  const _FundingCard({required this.data});

  final TradeFundingRateHistory data;

  @override
  Widget build(BuildContext context) {
    return LiveMarketCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LiveMarketCardHeader(
            icon: Icons.attach_money_rounded,
            color: liveMarketPrimary,
            title: 'Funding Rate',
            badge: '+${data.currentRatePct.toStringAsFixed(4)}%',
            badgeColor: liveMarketRed,
          ),
          const SizedBox(height: 16),
          Container(
            height: 54,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: liveMarketSurface3,
              borderRadius: AppRadii.cardRadius,
            ),
            child: Row(
              children: [
                Text(
                  'Next funding in',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontSize: 12,
                  ),
                ),
                const Spacer(),
                Text(
                  data.nextFundingLabel,
                  style: AppTextStyles.baseMedium.copyWith(
                    color: liveMarketPrimary,
                    fontSize: 18,
                    fontWeight: AppTextStyles.bold,
                    fontFamily: 'monospace',
                    fontFeatures: AppTextStyles.tabularFigures,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: LiveMarketMetricBox(
                  label: 'Current',
                  value: '+${data.currentRatePct.toStringAsFixed(3)}%',
                  color: liveMarketRed,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: LiveMarketMetricBox(
                  label: '24h Avg',
                  value: '${data.avgRatePct.toStringAsFixed(3)}%',
                  color: liveMarketGreen,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: LiveMarketMetricBox(
                  label: 'Range',
                  value: '${data.rangePct.toStringAsFixed(3)}%',
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          Container(
            height: 67,
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 6),
            decoration: BoxDecoration(
              color: liveMarketPanel2,
              borderRadius: AppRadii.cardRadius,
            ),
            child: CustomPaint(
              painter: LiveMarketLinePainter(values: data.historyPct),
            ),
          ),
          const SizedBox(height: 12),
          const LiveMarketInfoStrip(),
        ],
      ),
    );
  }
}

class _ToggleBar extends StatelessWidget {
  const _ToggleBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: liveMarketPanel2,
        borderRadius: AppRadii.cardRadius,
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: liveMarketPrimary,
                borderRadius: AppRadii.inputRadius,
              ),
              child: Text(
                'By Accounts',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.onAccent,
                  fontSize: 12,
                  fontWeight: AppTextStyles.bold,
                  height: 1,
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                'By Volume',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text3,
                  fontSize: 12,
                  fontWeight: AppTextStyles.medium,
                  height: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TrendLabel extends StatelessWidget {
  const _TrendLabel({
    required this.text,
    required this.color,
    required this.icon,
    this.iconAfter = false,
  });

  final String text;
  final Color color;
  final IconData icon;
  final bool iconAfter;

  @override
  Widget build(BuildContext context) {
    final widgets = <Widget>[
      Icon(icon, color: color, size: 15),
      const SizedBox(width: 4),
      Text(
        text,
        style: AppTextStyles.caption.copyWith(
          color: color,
          fontSize: 12,
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
    ];
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: iconAfter ? widgets.reversed.toList() : widgets,
    );
  }
}
