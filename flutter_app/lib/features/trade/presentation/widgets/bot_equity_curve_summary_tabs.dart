part of '../pages/bot_equity_curve_page.dart';

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.summary});

  final TradeBotEquityCurveSummary summary;

  @override
  Widget build(BuildContext context) {
    final items = [
      (
        'Bot Return',
        '+${summary.botReturnPct.toStringAsFixed(1)}%',
        _equityGreen,
      ),
      (
        'Buy & Hold',
        '+${summary.buyHoldReturnPct.toStringAsFixed(1)}%',
        AppColors.text1,
      ),
      ('Alpha', '+${summary.alphaPct.toStringAsFixed(1)}%', _equityGreen),
    ];

    return Row(
      children: [
        for (var i = 0; i < items.length; i++) ...[
          Expanded(
            child: _Card(
              padding: AppSpacing.tradeBotInnerPanelPadding,
              child: SizedBox(
                height: AppSpacing.tradeBotEquitySummaryMetricHeight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      items[i].$1,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.formFieldLabelGap),
                    Text(
                      items[i].$2,
                      style: AppTextStyles.baseMedium.copyWith(
                        color: items[i].$3,
                        fontWeight: AppTextStyles.bold,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (i != items.length - 1)
            const SizedBox(width: AppSpacing.tradeBotCardGap),
        ],
      ],
    );
  }
}

class _Tabs extends StatelessWidget {
  const _Tabs({required this.active, required this.onChanged});

  final String active;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    const tabs = [
      ('equity', 'Equity Curve'),
      ('sharpe', 'Rolling Sharpe'),
      ('alpha', 'Monthly Alpha'),
    ];
    return VitTabBar(
      tabs: [
        for (final tab in tabs)
          VitTabItem(
            key: tab.$1,
            label: tab.$2,
            widgetKey: BotEquityCurvePage.tabKey(tab.$1),
          ),
      ],
      activeKey: active,
      onChanged: onChanged,
      variant: VitTabBarVariant.segment,
    );
  }
}
