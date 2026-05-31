part of '../pages/ex_ante_costs_page.dart';

class _DownloadAction extends StatelessWidget {
  const _DownloadAction();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: _costPanel2,
        border: Border.all(color: _costBorder.withValues(alpha: .72)),
        borderRadius: AppRadii.smRadius,
      ),
      child: const Icon(
        Icons.download_rounded,
        color: AppColors.text1,
        size: 18,
      ),
    );
  }
}

class _RegulatoryNotice extends StatelessWidget {
  const _RegulatoryNotice();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 8, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.shield_outlined, color: AppColors.text1, size: 16),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PRIIPs Cost Disclosure',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontSize: 11,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'This document shows all costs you will pay before investing. '
                  'Required by EU regulation for retail clients.',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text1,
                    fontSize: 10,
                    fontWeight: AppTextStyles.bold,
                    height: 1.35,
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
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 17),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _costPrimary.withValues(alpha: .13),
                  borderRadius: AppRadii.inputRadius,
                ),
                child: const Icon(
                  Icons.attach_money_rounded,
                  color: _costPrimary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Example Investment Amount',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                        fontSize: 11,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 13),
                    Text(
                      _formatEur(snapshot.investmentAmount),
                      style: AppTextStyles.heroNumber.copyWith(
                        color: AppColors.text1,
                        fontSize: 24,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Estimated for illustration purposes',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                        fontSize: 10,
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _MetricBox(
                  label: 'Total Costs (Year 1)',
                  value: _formatEur(snapshot.totalFirstYear),
                ),
              ),
              const SizedBox(width: 10),
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
    return Container(
      height: 53,
      color: _costPanel,
      child: Row(
        children: [
          for (final tab in tabs)
            Expanded(
              child: InkWell(
                key: ExAnteCostsPage.tabKey(tab.$1),
                onTap: () => onChanged(tab.$1),
                child: Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          tab.$2,
                          style: AppTextStyles.caption.copyWith(
                            color: activeId == tab.$1
                                ? _costPrimary
                                : AppColors.text3,
                            fontSize: 12,
                            fontWeight: AppTextStyles.bold,
                            height: 1,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: activeId == tab.$1 ? 100 : 0,
                      height: 2,
                      color: _costPrimary,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
