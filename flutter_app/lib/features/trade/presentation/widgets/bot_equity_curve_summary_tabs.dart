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
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
              child: SizedBox(
                height: 52,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      items[i].$1,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                        fontSize: 10,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      items[i].$2,
                      style: AppTextStyles.baseMedium.copyWith(
                        color: items[i].$3,
                        fontSize: 18,
                        fontWeight: AppTextStyles.bold,
                        fontFamily: 'Roboto',
                        fontFeatures: AppTextStyles.tabularFigures,
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (i != items.length - 1) const SizedBox(width: 12),
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
    return Row(
      children: [
        for (var i = 0; i < tabs.length; i++) ...[
          Expanded(
            child: GestureDetector(
              key: BotEquityCurvePage.tabKey(tabs[i].$1),
              behavior: HitTestBehavior.opaque,
              onTap: () => onChanged(tabs[i].$1),
              child: Container(
                height: 35,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: active == tabs[i].$1
                      ? _equityPrimary.withValues(alpha: .15)
                      : _equityPanel2,
                  borderRadius: AppRadii.cardRadius,
                  border: Border.all(
                    color: active == tabs[i].$1
                        ? _equityPrimary.withValues(alpha: .50)
                        : AppColors.transparent,
                  ),
                ),
                child: Text(
                  tabs[i].$2,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: active == tabs[i].$1
                        ? _equityPrimary
                        : AppColors.text3,
                    fontSize: 12,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
              ),
            ),
          ),
          if (i != tabs.length - 1) const SizedBox(width: 8),
        ],
      ],
    );
  }
}
