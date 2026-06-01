part of 'live_market_interest_cards.dart';

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
