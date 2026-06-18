part of '../pages/ex_ante_costs_page.dart';

class _RegulatoryNotice extends StatelessWidget {
  const _RegulatoryNotice();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.zeroInsets.copyWith(
        left: AppSpacing.tradeFeeRowGap,
        right: AppSpacing.x3,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.shield_outlined,
            color: AppColors.text1,
            size: AppSpacing.tradeTpslIcon,
          ),
          const SizedBox(width: AppSpacing.tradeFeeRowGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PRIIPs Cost Disclosure',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x3),
                Text(
                  'This document shows all costs you will pay before investing. '
                  'Required by EU regulation for retail clients.',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text1,
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

class _InvestmentCard extends StatelessWidget {
  const _InvestmentCard({required this.snapshot});

  final TradeExAnteCostsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: AppSpacing.tradeFeeCardPadding,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              VitCard(
                variant: VitCardVariant.ghost,
                radius: VitCardRadius.sm,
                width: AppSpacing.walletTransactionExplorerHeight,
                height: AppSpacing.walletTransactionExplorerHeight,
                clip: true,
                background: ColoredBox(
                  color: _costPrimary.withValues(alpha: .13),
                ),
                child: const Icon(
                  Icons.attach_money_rounded,
                  color: _costPrimary,
                  size: AppSpacing.statusPillHeightMd,
                ),
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Example Investment Amount',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x4),
                    Text(
                      _formatEur(snapshot.investmentAmount),
                      style: AppTextStyles.heroNumber.copyWith(
                        color: AppColors.text1,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.tradeFeeRowGap),
                    Text(
                      'Estimated for illustration purposes',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.walletAddressFilterGap),
          Row(
            children: [
              Expanded(
                child: _MetricBox(
                  label: 'Total Costs (Year 1)',
                  value: _formatEur(snapshot.totalFirstYear),
                ),
              ),
              const SizedBox(width: AppSpacing.tradeFeeRowGap),
              Expanded(
                child: _MetricBox(
                  label: '% of Investment',
                  value: '${snapshot.totalPercentage.toStringAsFixed(2)}%',
                  valueColor: _costRed,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Tabs extends StatelessWidget {
  const _Tabs({required this.activeId, required this.onChanged});

  final String activeId;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    const tabs = [
      ('summary', 'Summary'),
      ('breakdown', 'Breakdown'),
      ('scenarios', 'Scenarios'),
    ];
    return VitCard(
      height: AppSpacing.x7,
      padding: AppSpacing.zeroInsets,
      child: VitTabBar(
        activeKey: activeId,
        onChanged: onChanged,
        variant: VitTabBarVariant.underline,
        tabs: [
          for (final tab in tabs)
            VitTabItem(
              key: tab.$1,
              label: tab.$2,
              widgetKey: ExAnteCostsPage.tabKey(tab.$1),
            ),
        ],
      ),
    );
  }
}
