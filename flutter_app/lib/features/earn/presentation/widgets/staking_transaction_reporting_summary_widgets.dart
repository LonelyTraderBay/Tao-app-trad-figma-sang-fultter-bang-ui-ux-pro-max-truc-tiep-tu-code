part of '../pages/staking_transaction_reporting_page.dart';

class _InfoBanner extends StatelessWidget {
  const _InfoBanner({required this.snapshot});

  final StakingTransactionReportingSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingTransactionReportingPage.infoKey,
      variant: VitCardVariant.inner,
      borderColor: AppColors.primary20,
      padding: _transactionReportingCardPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.description_outlined,
            color: AppColors.primarySoft,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(snapshot.infoTitle, style: AppTextStyles.baseMedium),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  snapshot.infoBody,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: _transactionReportingBodyLineHeight,
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

class _Selectors extends StatelessWidget {
  const _Selectors({
    required this.snapshot,
    required this.year,
    required this.costBasis,
    required this.onYearChanged,
    required this.onOpenCostBasis,
  });

  final StakingTransactionReportingSnapshot snapshot;
  final String year;
  final String costBasis;
  final ValueChanged<String> onYearChanged;
  final VoidCallback onOpenCostBasis;

  @override
  Widget build(BuildContext context) {
    return Row(
      key: StakingTransactionReportingPage.selectorsKey,
      children: [
        Expanded(
          child: VitCard(
            padding: _transactionReportingCardPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tax Year',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
                const SizedBox(height: AppSpacing.x2),
                VitCard(
                  variant: VitCardVariant.inner,
                  radius: VitCardRadius.md,
                  padding: AppSpacing.zeroInsets.copyWith(
                    left: AppSpacing.x4,
                    right: AppSpacing.x4,
                  ),
                  onTap: () {
                    final currentIndex = snapshot.years.indexOf(year);
                    final nextIndex =
                        (currentIndex + 1) % snapshot.years.length;
                    onYearChanged(snapshot.years[nextIndex]);
                  },
                  child: SizedBox(
                    height: _transactionReportingControlExtent,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            year,
                            style: AppTextStyles.baseMedium.copyWith(
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.expand_more_rounded,
                          color: AppColors.text2,
                          size: AppSpacing.iconSm,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: VitCard(
            onTap: onOpenCostBasis,
            padding: _transactionReportingCardPadding,
            child: SizedBox(
              height: _transactionReportingControlExtent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cost Basis',
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                  const SizedBox(height: AppSpacing.x2),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          costBasis,
                          style: AppTextStyles.baseMedium.copyWith(
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.filter_list_rounded,
                        color: AppColors.text3,
                        size: AppSpacing.iconSm,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ReportingTabs extends StatelessWidget {
  const _ReportingTabs({required this.active, required this.onChanged});

  final _ReportingTab active;
  final ValueChanged<_ReportingTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return Material(
      key: StakingTransactionReportingPage.tabsKey,
      color: AppColors.surface,
      child: Row(
        children: [
          for (final tab in _ReportingTab.values)
            Expanded(
              child: VitCard(
                key: StakingTransactionReportingPage.tabKey(tab.name),
                variant: VitCardVariant.ghost,
                radius: VitCardRadius.sm,
                padding: AppSpacing.zeroInsets.copyWith(top: AppSpacing.x3),
                onTap: () => onChanged(tab),
                child: Column(
                  children: [
                    Text(
                      _tabLabel(tab),
                      style: AppTextStyles.caption.copyWith(
                        color: active == tab
                            ? AppColors.primarySoft
                            : AppColors.text3,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x2),
                    SizedBox(
                      width: AppSpacing.buttonHero,
                      height: _transactionReportingIndicatorExtent,
                      child: AnimatedScale(
                        duration: const Duration(milliseconds: 160),
                        scale: active == tab ? 1 : 0,
                        child: Material(
                          color: active == tab
                              ? AppColors.primarySoft
                              : AppColors.transparent,
                          borderRadius: AppRadii.xsRadius,
                        ),
                      ),
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

class _SummaryTab extends StatelessWidget {
  const _SummaryTab({required this.snapshot, required this.costBasis});

  final StakingTransactionReportingSnapshot snapshot;
  final String costBasis;

  @override
  Widget build(BuildContext context) {
    final summary = snapshot.summary;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitPageSection(
          key: StakingTransactionReportingPage.summaryKey,
          label: 'Tax Summary ${snapshot.defaultYear}',
          accentColor: AppColors.primarySoft,
          density: VitDensity.compact,
          children: [
            VitCard(
              radius: VitCardRadius.lg,
              padding: _transactionReportingCardPadding,
              child: Column(
                children: [
                  _SummaryPanel(
                    label: 'Total Staking Income',
                    value: _formatUsd(summary.totalStakingIncome),
                    body:
                        'Taxed as ordinary income at your marginal tax rate (reported on Form 1099-MISC)',
                  ),
                  const SizedBox(height: AppSpacing.x3),
                  _GainsPanel(summary: summary),
                  const SizedBox(height: AppSpacing.x3),
                  _CostBasisPanel(summary: summary, method: costBasis),
                ],
              ),
            ),
          ],
        ),
        VitPageSection(
          key: StakingTransactionReportingPage.rewardsKey,
          label: 'Staking Rewards by Asset',
          accentColor: AppColors.primarySoft,
          density: VitDensity.compact,
          children: [
            VitCard(
              radius: VitCardRadius.lg,
              padding: _transactionReportingCardPadding,
              child: Column(
                children: [
                  for (final reward in summary.rewardsByAsset) ...[
                    _RewardAssetRow(reward: reward),
                    if (reward != summary.rewardsByAsset.last)
                      const SizedBox(height: AppSpacing.x3),
                  ],
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SummaryPanel extends StatelessWidget {
  const _SummaryPanel({
    required this.label,
    required this.value,
    required this.body,
  });

  final String label;
  final String value;
  final String body;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.lg,
      padding: _transactionReportingCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(child: Text(label, style: AppTextStyles.baseMedium)),
              const SizedBox(width: AppSpacing.x3),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  value,
                  style: AppTextStyles.sectionTitle.copyWith(
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            body,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: _transactionReportingMetricLineHeight,
            ),
          ),
        ],
      ),
    );
  }
}

class _GainsPanel extends StatelessWidget {
  const _GainsPanel({required this.summary});

  final StakingTaxSummaryDraft summary;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.lg,
      padding: _transactionReportingCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Total Capital Gains',
                  style: AppTextStyles.baseMedium,
                ),
              ),
              Text(
                _formatUsd(summary.totalCapitalGains),
                style: AppTextStyles.sectionTitle.copyWith(
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              Expanded(
                child: _SmallMetric(
                  label: 'Short-term (<1 year)',
                  value: _formatUsd(summary.shortTermGains),
                  color: AppColors.warn,
                ),
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: _SmallMetric(
                  label: 'Long-term (>=1 year)',
                  value: _formatUsd(summary.longTermGains),
                  color: AppColors.buy,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            'Reported on Form 8949 and Schedule D. Long-term gains taxed at lower rates.',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: _transactionReportingMetricLineHeight,
            ),
          ),
        ],
      ),
    );
  }
}

class _CostBasisPanel extends StatelessWidget {
  const _CostBasisPanel({required this.summary, required this.method});

  final StakingTaxSummaryDraft summary;
  final String method;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.lg,
      padding: _transactionReportingCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: _SmallMetric(
                  label: 'Cost Basis',
                  value: _formatUsd(summary.costBasis),
                ),
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: _SmallMetric(
                  label: 'Proceeds',
                  value: _formatUsd(summary.proceeds),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            'Using $method method',
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _SmallMetric extends StatelessWidget {
  const _SmallMetric({
    required this.label,
    required this.value,
    this.color = AppColors.text1,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x1),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            value,
            style: AppTextStyles.baseMedium.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ),
      ],
    );
  }
}
