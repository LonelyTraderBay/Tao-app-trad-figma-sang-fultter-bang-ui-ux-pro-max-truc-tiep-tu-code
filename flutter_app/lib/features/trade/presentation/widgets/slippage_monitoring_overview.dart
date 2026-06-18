part of '../pages/slippage_monitoring_page.dart';

class _CriticalAlert extends StatelessWidget {
  const _CriticalAlert({required this.summary});

  final TradeSlippageSummary summary;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: AppSpacing.tradeToolAlertPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppColors.text1,
            size: AppSpacing.tradeToolAlertIcon,
          ),
          const SizedBox(width: AppSpacing.tradeToolIconGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${summary.critical} Critical Slippage Event Detected',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.formFieldLabelGap),
                Text(
                  'Slippage exceeded 1% threshold. Review affected trades and consider provider adjustments.',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text2,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  const _StatsGrid({required this.summary});

  final TradeSlippageSummary summary;

  @override
  Widget build(BuildContext context) {
    final cards = [
      (
        Icons.monitor_heart_outlined,
        _slipPrimary,
        'Total\nEvents',
        summary.total.toString(),
        'Last 24h',
        AppColors.text3,
      ),
      (
        Icons.track_changes_outlined,
        _slipGreen,
        'Avg\nSlippage',
        '${summary.avgSlippage.toStringAsFixed(1)}\nbps',
        '0.405%',
        AppColors.text3,
      ),
      (
        Icons.trending_up_rounded,
        _slipAmber,
        'Max\nSlippage',
        '${summary.maxSlippage.toStringAsFixed(1)}\nbps',
        '1.18%',
        _slipRed,
      ),
      (
        Icons.warning_amber_rounded,
        _slipRed,
        'Critical',
        summary.critical.toString(),
        '${summary.warning} warning',
        _slipRed,
      ),
    ];

    return Row(
      children: [
        for (final card in cards) ...[
          Expanded(child: _StatCard(card: card)),
          if (card != cards.last)
            const SizedBox(width: AppSpacing.tradeToolCardGap),
        ],
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.card});

  final (IconData, Color, String, String, String, Color) card;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      height: AppSpacing.tradeToolStatCardHeight,
      padding: AppSpacing.tradeBotControlPadding,
      borderColor: _slipBorder.withValues(alpha: .72),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(card.$1, color: card.$2, size: AppSpacing.iconSm),
              const SizedBox(width: AppSpacing.formFieldLabelGap),
              Expanded(
                child: Text(
                  card.$3,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.tradeToolInlineGap),
          SizedBox(
            height: AppSpacing.tradeToolStatValueHeight,
            child: Align(
              alignment: Alignment.centerLeft,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  card.$4,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ),
            ),
          ),
          const Spacer(),
          Text(
            card.$5,
            style: AppTextStyles.micro.copyWith(
              color: card.$6,
              height: AppSpacing.tradeBotLineHeightTight,
            ),
          ),
        ],
      ),
    );
  }
}

class _Tabs extends StatelessWidget {
  const _Tabs({
    required this.activeId,
    required this.summary,
    required this.onChanged,
  });

  final String activeId;
  final TradeSlippageSummary summary;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      VitTabItem(
        key: 'realtime',
        label: 'Real-time (${summary.total})',
        widgetKey: SlippageMonitoringPage.tabKey('realtime'),
      ),
      VitTabItem(
        key: 'providers',
        label: 'By Provider',
        widgetKey: SlippageMonitoringPage.tabKey('providers'),
      ),
      VitTabItem(
        key: 'history',
        label: 'History',
        widgetKey: SlippageMonitoringPage.tabKey('history'),
      ),
      VitTabItem(
        key: 'alerts',
        label: 'Alerts (${summary.critical + summary.warning})',
        widgetKey: SlippageMonitoringPage.tabKey('alerts'),
      ),
    ];
    return VitCard(
      height: AppSpacing.tradeToolTabHeight,
      padding: AppSpacing.tradeSegmentedPadding,
      child: VitTabBar(
        tabs: tabs,
        activeKey: activeId,
        onChanged: onChanged,
        variant: VitTabBarVariant.segment,
      ),
    );
  }
}
