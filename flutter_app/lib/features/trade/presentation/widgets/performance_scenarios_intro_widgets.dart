part of '../pages/performance_scenarios_page.dart';

class _WarningNotice extends StatelessWidget {
  const _WarningNotice();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.ghost,
      constraints: const BoxConstraints(
        minHeight: AppSpacing.tradeBotSecurityCardMinHeight,
      ),
      padding: AppSpacing.tradeBotDisputeNoticePadding,
      borderColor: _scenarioAmber.withValues(alpha: .38),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: AppSpacing.tradeBotIntroIconTopPadding,
            child: Icon(
              Icons.warning_amber_rounded,
              color: _scenarioAmber,
              size: AppSpacing.tradeBotSmallIcon,
            ),
          ),
          const SizedBox(width: AppSpacing.tradeBotRowGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Not a Guarantee',
                  style: AppTextStyles.badge.copyWith(
                    color: _scenarioAmber,
                    height: AppSpacing.tradeBotLineHeightShort,
                  ),
                ),
                const SizedBox(height: AppSpacing.tradeBotNarrowIconGap),
                Text(
                  'These scenarios are illustrations based on past '
                  'performance and statistical models. Actual results may '
                  'differ significantly.',
                  style: AppTextStyles.micro.copyWith(
                    color: _scenarioAmber,
                    fontWeight: AppTextStyles.medium,
                    height: AppSpacing.tradeBotLineHeightBody,
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

class _InvestmentCard extends StatelessWidget {
  const _InvestmentCard({required this.investment});

  final double investment;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: AppSpacing.tradeBotCardPaddingTall,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Example Investment',
            style: AppTextStyles.navLabel.copyWith(
              color: AppColors.text3,
              height: AppSpacing.tradeBotLineHeightCaption,
            ),
          ),
          const SizedBox(height: AppSpacing.tradeBotCardGap),
          Text(
            _formatEur(investment),
            style: AppTextStyles.amountMd.copyWith(
              color: AppColors.text1,
              height: AppSpacing.tradeBotLineHeightTight,
            ),
          ),
        ],
      ),
    );
  }
}

class _HoldingPeriodSelector extends StatelessWidget {
  const _HoldingPeriodSelector({
    required this.periods,
    required this.selectedPeriod,
    required this.onChanged,
  });

  final List<int> periods;
  final int selectedPeriod;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitTabBar(
      variant: VitTabBarVariant.segment,
      tabs: [
        for (final period in periods)
          VitTabItem(
            key: '$period',
            label: '$period ${period == 1 ? 'Year' : 'Years'}',
            widgetKey: PerformanceScenariosPage.periodKey(period),
          ),
      ],
      activeKey: '$selectedPeriod',
      onChanged: (value) => onChanged(int.parse(value)),
    );
  }
}
