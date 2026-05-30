import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';

const _livePanel = AppColors.surface;
const _livePanel2 = AppColors.surface2;
const _liveSurface3 = AppColors.surfaceNavyDeep;
const _liveBorder = AppColors.borderSolid;
const _livePrimary = AppColors.primary;
const _liveGreen = AppColors.buy;
const _liveRed = AppColors.sell;
const _livePurple = AppColors.accent;
const _liveAmber = AppColors.caution;

class LiveMarketPairCard extends StatelessWidget {
  const LiveMarketPairCard({super.key, required this.snapshot});

  final TradeMarketDataAnalyticsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 119,
      padding: const EdgeInsets.fromLTRB(16, 15, 16, 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _liveGreen.withValues(alpha: .08),
            _livePrimary.withValues(alpha: .08),
          ],
        ),
        border: Border.all(
          color: _liveGreen.withValues(alpha: .22),
          width: 1.5,
        ),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        children: [
          Row(
            children: [
              const _LiveDot(),
              const Spacer(),
              _Chip(label: 'WebSocket Active', color: _liveGreen),
            ],
          ),
          const Spacer(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: _PairValue(
                  label: 'Analyzing',
                  value: snapshot.selectedPair,
                ),
              ),
              _PairValue(
                label: 'Mark Price',
                value: '\$${_formatMoney(snapshot.markPrice)}',
                color: _liveGreen,
                alignRight: true,
                monospace: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LiveDot extends StatelessWidget {
  const _LiveDot();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            color: _liveGreen,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 7),
        Text(
          'LIVE',
          style: AppTextStyles.micro.copyWith(
            color: _liveGreen,
            fontSize: 10,
            fontWeight: AppTextStyles.bold,
            height: 1,
          ),
        ),
      ],
    );
  }
}

class _PairValue extends StatelessWidget {
  const _PairValue({
    required this.label,
    required this.value,
    this.color = AppColors.text1,
    this.alignRight = false,
    this.monospace = false,
  });

  final String label;
  final String value;
  final Color color;
  final bool alignRight;
  final bool monospace;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignRight
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text3,
            fontSize: 12,
            height: 1,
          ),
        ),
        const SizedBox(height: 9),
        Text(
          value,
          style: AppTextStyles.baseMedium.copyWith(
            color: color,
            fontSize: 20,
            fontWeight: AppTextStyles.bold,
            fontFamily: monospace ? 'monospace' : null,
            fontFeatures: AppTextStyles.tabularFigures,
            height: 1,
          ),
        ),
      ],
    );
  }
}

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
      color: _livePanel,
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
                            ? _livePrimary
                            : AppColors.transparent,
                        width: 2,
                      ),
                    ),
                  ),
                  child: Text(
                    tab.$2,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: activeId == tab.$1
                          ? _livePrimary
                          : AppColors.text3,
                      fontSize: 12,
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
      'market' => _MarketTab(snapshot: snapshot),
      'liquidations' => _LiquidationsTab(snapshot: snapshot),
      _ => _SentimentTab(snapshot: snapshot),
    };
  }
}

class _MarketTab extends StatelessWidget {
  const _MarketTab({required this.snapshot});

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
    final tone = positive ? _liveGreen : _liveRed;
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _CardHeader(
            icon: Icons.show_chart_rounded,
            color: _livePrimary,
            title: 'Open Interest',
            trailing: 'BTC/USDT >',
          ),
          const SizedBox(height: 18),
          _MutedLabel('Total Open Interest'),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                _formatMillions(data.current),
                style: AppTextStyles.sectionTitle.copyWith(
                  color: AppColors.text1,
                  fontSize: 26,
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                  height: 1,
                ),
              ),
              const SizedBox(width: 8),
              _Chip(
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
                child: _MetricBox(
                  label: 'Change 24h',
                  value:
                      '${positive ? '+' : ''}${_formatMillions(data.change24h)}',
                  color: tone,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _MetricBox(
                  label: 'High 24h',
                  value: _formatMillions(data.high24h),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _MetricBox(
                  label: 'Low 24h',
                  value: _formatMillions(data.low24h),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const _InfoStrip(),
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
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _CardHeader(
            icon: Icons.groups_2_outlined,
            color: _livePurple,
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
                color: _liveGreen,
                icon: Icons.trending_up_rounded,
              ),
              const Spacer(),
              _TrendLabel(
                text: 'Short ${data.shortPct.toStringAsFixed(1)}%',
                color: _liveRed,
                icon: Icons.trending_down_rounded,
                iconAfter: true,
              ),
            ],
          ),
          const SizedBox(height: 9),
          _RatioBar(longPct: data.longPct),
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
              color: _liveGreen,
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
                child: _MetricBox(
                  label: 'Long Accounts',
                  value: _formatInt(data.longAccounts),
                  color: _liveGreen,
                  bg: _liveGreen.withValues(alpha: .09),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _MetricBox(
                  label: 'Short Accounts',
                  value: _formatInt(data.shortAccounts),
                  color: _liveRed,
                  bg: _liveRed.withValues(alpha: .08),
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
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _CardHeader(
            icon: Icons.visibility_rounded,
            color: _liveAmber,
            title: 'Top Traders',
            badge: 'Long',
          ),
          const SizedBox(height: 16),
          Container(
            height: 113,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _liveGreen.withValues(alpha: .09),
              border: Border.all(color: _liveGreen.withValues(alpha: .2)),
              borderRadius: AppRadii.cardRadius,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _MutedLabel('Top traders dang Long', align: TextAlign.center),
                const SizedBox(height: 8),
                Text(
                  '${data.longPct.toStringAsFixed(1)}%',
                  style: AppTextStyles.heroNumber.copyWith(
                    color: _liveGreen,
                    fontSize: 36,
                    fontFamily: 'monospace',
                    height: 1,
                  ),
                ),
                const SizedBox(height: 9),
                _MutedLabel('of top traders are long', align: TextAlign.center),
              ],
            ),
          ),
          const SizedBox(height: 14),
          _RatioBar(longPct: data.longPct),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.fromLTRB(12, 11, 12, 11),
            decoration: BoxDecoration(
              color: _livePanel2,
              borderRadius: AppRadii.cardRadius,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _MutedLabel('24h Change'),
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
                    color: (shortShift ? _liveRed : _liveGreen).withValues(
                      alpha: .12,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    shortShift
                        ? Icons.trending_down_rounded
                        : Icons.trending_up_rounded,
                    color: shortShift ? _liveRed : _liveGreen,
                    size: 23,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          _InfoStrip(bg: _liveAmber.withValues(alpha: .06), color: _liveAmber),
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
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _CardHeader(
            icon: Icons.attach_money_rounded,
            color: _livePrimary,
            title: 'Funding Rate',
            badge: '+${data.currentRatePct.toStringAsFixed(4)}%',
            badgeColor: _liveRed,
          ),
          const SizedBox(height: 16),
          Container(
            height: 54,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: _liveSurface3,
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
                    color: _livePrimary,
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
                child: _MetricBox(
                  label: 'Current',
                  value: '+${data.currentRatePct.toStringAsFixed(3)}%',
                  color: _liveRed,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _MetricBox(
                  label: '24h Avg',
                  value: '${data.avgRatePct.toStringAsFixed(3)}%',
                  color: _liveGreen,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _MetricBox(
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
              color: _livePanel2,
              borderRadius: AppRadii.cardRadius,
            ),
            child: CustomPaint(painter: _LinePainter(values: data.historyPct)),
          ),
          const SizedBox(height: 12),
          const _InfoStrip(),
        ],
      ),
    );
  }
}

class _LiquidationsTab extends StatelessWidget {
  const _LiquidationsTab({required this.snapshot});

  final TradeMarketDataAnalyticsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _CardHeader(
                icon: Icons.flash_on_rounded,
                color: _liveAmber,
                title: 'Liquidation Stats',
                badge: 'Live',
              ),
              const SizedBox(height: 12),
              _MetricBox(
                label: '24h Total',
                value: _formatCompactUsd(snapshot.liquidationStats.total24h),
                color: AppColors.text1,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _CardHeader(
                icon: Icons.history_rounded,
                color: _livePrimary,
                title: 'Recent Liquidations',
                badge: 'Real-time',
              ),
              const SizedBox(height: 12),
              for (final liquidation in snapshot.recentLiquidations) ...[
                _LiquidationRow(liquidation: liquidation),
                if (liquidation != snapshot.recentLiquidations.last)
                  const SizedBox(height: 8),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _SentimentTab extends StatelessWidget {
  const _SentimentTab({required this.snapshot});

  final TradeMarketDataAnalyticsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _CardHeader(
                icon: Icons.psychology_outlined,
                color: _livePurple,
                title: 'Market Sentiment',
              ),
              const SizedBox(height: 14),
              Text(
                '${snapshot.sentiment.score}',
                textAlign: TextAlign.center,
                style: AppTextStyles.heroNumber.copyWith(
                  color: _liveAmber,
                  fontSize: 42,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Live Data Sources',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: 12),
              for (final item in const [
                'Open Interest',
                'Long/Short Ratio',
                'Top Traders',
                'Funding Rate',
                'Liquidations',
              ])
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _SourceRow(label: item),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CardHeader extends StatelessWidget {
  const _CardHeader({
    required this.icon,
    required this.color,
    required this.title,
    this.trailing,
    this.badge,
    this.badgeColor,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String? trailing;
  final String? badge;
  final Color? badgeColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.body.copyWith(
              color: AppColors.text1,
              fontSize: 15,
              fontWeight: AppTextStyles.bold,
              height: 1,
            ),
          ),
        ),
        if (trailing != null)
          Text(
            trailing!,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 10,
              height: 1,
            ),
          )
        else if (badge != null)
          _Chip(label: badge!, color: badgeColor ?? _liveGreen),
      ],
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _livePanel,
        border: Border.all(color: _liveBorder.withValues(alpha: .72)),
        borderRadius: AppRadii.cardRadius,
      ),
      child: child,
    );
  }
}

class _MetricBox extends StatelessWidget {
  const _MetricBox({
    required this.label,
    required this.value,
    this.color = AppColors.text1,
    this.bg = _livePanel2,
  });

  final String label;
  final String value;
  final Color color;
  final Color bg;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 57),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(color: bg, borderRadius: AppRadii.cardRadius),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _MutedLabel(label, align: TextAlign.center),
          const SizedBox(height: 8),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontSize: 12,
              fontWeight: AppTextStyles.bold,
              fontFamily: 'monospace',
              fontFeatures: AppTextStyles.tabularFigures,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontSize: 10,
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
    );
  }
}

class _MutedLabel extends StatelessWidget {
  const _MutedLabel(this.text, {this.align});

  final String text;
  final TextAlign? align;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align,
      style: AppTextStyles.micro.copyWith(
        color: AppColors.text3,
        fontSize: 10,
        height: 1.25,
      ),
    );
  }
}

class _InfoStrip extends StatelessWidget {
  const _InfoStrip({this.bg = _liveSurface3, this.color = _livePrimary});

  final Color bg;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(color: bg, borderRadius: AppRadii.cardRadius),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded, color: color, size: 14),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              'OI tang + gia tang = bullish strong. OI tang + gia giam = bearish momentum. OI giam = positions dong.',
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                fontSize: 10,
                height: 1.42,
              ),
            ),
          ),
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
        color: _livePanel2,
        borderRadius: AppRadii.cardRadius,
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _livePrimary,
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

class _RatioBar extends StatelessWidget {
  const _RatioBar({required this.longPct});

  final double longPct;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: SizedBox(
        height: 12,
        child: Row(
          children: [
            Expanded(
              flex: (longPct * 10).round(),
              child: const ColoredBox(color: _liveGreen),
            ),
            Expanded(
              flex: ((100 - longPct) * 10).round(),
              child: const ColoredBox(color: _liveRed),
            ),
          ],
        ),
      ),
    );
  }
}

class _LiquidationRow extends StatelessWidget {
  const _LiquidationRow({required this.liquidation});

  final TradeRecentLiquidation liquidation;

  @override
  Widget build(BuildContext context) {
    final color = liquidation.side == 'long' ? _liveGreen : _liveRed;
    return Container(
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: _livePanel2,
        borderRadius: AppRadii.mdRadius,
      ),
      child: Row(
        children: [
          _Chip(label: liquidation.side.toUpperCase(), color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              liquidation.pair,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          Text(
            _formatCompactUsd(liquidation.size),
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontSize: 12,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _SourceRow extends StatelessWidget {
  const _SourceRow({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _livePanel2,
        borderRadius: AppRadii.mdRadius,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          const _LiveDot(),
        ],
      ),
    );
  }
}

class _LinePainter extends CustomPainter {
  const _LinePainter({required this.values});

  final List<double> values;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.length < 2) return;
    final maxValue = values.reduce(math.max);
    final minValue = values.reduce(math.min);
    final span = math.max(maxValue - minValue, .001);
    final zeroY = size.height * (maxValue / span).clamp(0, 1);
    final gridPaint = Paint()
      ..color = AppColors.text3.withValues(alpha: .18)
      ..strokeWidth = 1;
    canvas.drawLine(Offset(0, zeroY), Offset(size.width, zeroY), gridPaint);

    final path = Path();
    for (var i = 0; i < values.length; i++) {
      final x = size.width * i / (values.length - 1);
      final y = size.height - ((values[i] - minValue) / span * size.height);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = _liveRed
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(covariant _LinePainter oldDelegate) {
    return oldDelegate.values != values;
  }
}

String _formatMillions(double value) {
  return '\$${(value / 1000000).toStringAsFixed(2)}M';
}

String _formatCompactUsd(double value) {
  if (value >= 1000000000) {
    return '\$${(value / 1000000000).toStringAsFixed(2)}B';
  }
  if (value >= 1000000) return '\$${(value / 1000000).toStringAsFixed(1)}M';
  if (value >= 1000) return '\$${(value / 1000).toStringAsFixed(0)}K';
  return '\$${value.toStringAsFixed(0)}';
}

String _formatMoney(double value) {
  final fixed = value.toStringAsFixed(2);
  final parts = fixed.split('.');
  final buffer = StringBuffer();
  for (var i = 0; i < parts.first.length; i++) {
    final remaining = parts.first.length - i;
    buffer.write(parts.first[i]);
    if (remaining > 1 && remaining % 3 == 1) buffer.write(',');
  }
  return '${buffer.toString()}.${parts.last}';
}

String _formatInt(int value) {
  final raw = value.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < raw.length; i++) {
    final remaining = raw.length - i;
    buffer.write(raw[i]);
    if (remaining > 1 && remaining % 3 == 1) buffer.write(',');
  }
  return buffer.toString();
}
