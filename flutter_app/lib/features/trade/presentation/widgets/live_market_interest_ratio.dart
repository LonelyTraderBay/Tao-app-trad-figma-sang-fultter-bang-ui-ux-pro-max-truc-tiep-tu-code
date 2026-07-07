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
          const SizedBox(height: AppSpacing.liveMarketCardGap),
          const _ToggleBar(),
          const SizedBox(height: AppSpacing.liveMarketCardGap),
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
          const SizedBox(height: AppSpacing.rowGapRegular),
          LiveMarketRatioBar(longPct: data.longPct),
          const SizedBox(height: AppSpacing.statusPillHorizontalPaddingMd),
          Text(
            'Long/Short Ratio',
            textAlign: TextAlign.center,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.formFieldLabelGap),
          Text(
            data.ratio.toStringAsFixed(2),
            textAlign: TextAlign.center,
            style: AppTextStyles.sectionTitle.copyWith(
              color: liveMarketGreen,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
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
              const SizedBox(width: AppSpacing.statusPillHorizontalPaddingMd),
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
    return LiveMarketCard(
      variant: VitCardVariant.inner,
      borderColor: AppColors.transparent,
      height: AppSpacing.liveMarketToggleHeight,
      padding: AppSpacing.liveMarketTogglePadding,
      child: Row(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: AppRadii.inputRadius,
              child: ColoredBox(
                color: liveMarketPrimary,
                child: Center(
                  child: Text(
                    'By Accounts',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.onAccent,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
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
                  fontWeight: AppTextStyles.medium,
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
      Icon(icon, color: color, size: AppSpacing.liveMarketTrendIcon),
      const SizedBox(width: AppSpacing.statusPillGapMd),
      Text(
        text,
        style: AppTextStyles.caption.copyWith(
          color: color,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    ];
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: iconAfter ? widgets.reversed.toList() : widgets,
    );
  }
}
