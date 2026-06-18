part of '../pages/ex_ante_costs_page.dart';

class _Summary extends StatelessWidget {
  const _Summary({required this.snapshot});

  final TradeExAnteCostsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final categories = [
      (
        TradeExAnteCostCategory.oneOff,
        'One-off Costs',
        'Costs paid once when entering or exiting the investment',
        _costPrimary,
        _formatEur(snapshot.oneOffCosts),
      ),
      (
        TradeExAnteCostCategory.recurring,
        'Recurring Costs',
        'Costs paid every year while you hold the investment',
        _costAmber,
        '${_formatEur(snapshot.recurringCosts)}/year',
      ),
      (
        TradeExAnteCostCategory.incidental,
        'Incidental Costs',
        'Performance fees (only paid if investment performs well)',
        _costGreen,
        _formatEur(snapshot.incidentalCosts),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionLabel('Cost Summary'),
        const SizedBox(height: AppSpacing.tradeListGap),
        for (final item in categories) ...[
          _CategoryCard(
            color: item.$4,
            title: item.$2,
            description: item.$3,
            amount: item.$5,
          ),
          if (item != categories.last) const SizedBox(height: AppSpacing.x4),
        ],
        const SizedBox(height: AppSpacing.x5 + AppSpacing.x2),
        const _SectionLabel('Impact on Returns'),
        const SizedBox(height: AppSpacing.tradeListGap),
        _RiyCard(snapshot: snapshot),
        const SizedBox(height: AppSpacing.contentPad),
        _FullWidthButton(
          key: ExAnteCostsPage.riyKey,
          icon: Icons.calculate_outlined,
          label: 'Use RIY Calculator',
          onPressed: () => context.go(AppRoutePaths.tradeCopyRiyCalculator),
        ),
      ],
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    required this.color,
    required this.title,
    required this.description,
    required this.amount,
  });

  final Color color;
  final String title;
  final String description;
  final String amount;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: AppSpacing.tradeFeeCardPadding,
      child: Column(
        children: [
          Row(
            children: [
              VitCard(
                variant: VitCardVariant.ghost,
                radius: VitCardRadius.sm,
                width: AppSpacing.statusPillIconSizeMd,
                height: AppSpacing.statusPillIconSizeMd,
                clip: true,
                background: ColoredBox(color: color),
                child: const SizedBox.shrink(),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              Text(
                amount,
                style: AppTextStyles.baseMedium.copyWith(
                  color: AppColors.text1,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.transferSectionGap),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              description,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ),
        ],
      ),
    );
  }
}

class _RiyCard extends StatelessWidget {
  const _RiyCard({required this.snapshot});

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
                background: ColoredBox(color: _costRed.withValues(alpha: .13)),
                child: const Icon(Icons.trending_down_rounded, color: _costRed),
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Reduction in Yield (RIY)',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x3),
                    Text(
                      'How much costs reduce your returns over '
                      '${snapshot.holdingPeriodYears} years',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${snapshot.reductionInYield.toStringAsFixed(2)}%',
                style: AppTextStyles.heroNumber.copyWith(color: _costRed),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.transferSectionGap),
          _WarningBox(
            text:
                'Example: If the investment returns 8% per year, after costs '
                'you would receive approximately '
                '${(8 - snapshot.reductionInYield).toStringAsFixed(2)}% per year.',
          ),
        ],
      ),
    );
  }
}

class _Breakdown extends StatelessWidget {
  const _Breakdown({required this.snapshot});

  final TradeExAnteCostsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionLabel('Detailed Cost Breakdown'),
        const SizedBox(height: AppSpacing.tradeListGap),
        for (final cost in snapshot.costs) ...[
          _CostItemCard(cost: cost),
          if (cost != snapshot.costs.last)
            const SizedBox(height: AppSpacing.tradeListGap),
        ],
      ],
    );
  }
}

class _CostItemCard extends StatelessWidget {
  const _CostItemCard({required this.cost});

  final TradeExAnteCostItem cost;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: AppSpacing.cardPaddingCompact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            cost.type,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            cost.description,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.tradeFeeRowGap),
          Row(
            children: [
              Expanded(
                child: _MetricBox(
                  label: 'Amount',
                  value: _formatEur(cost.amountEur),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _MetricBox(
                  label: '% of Investment',
                  value: '${cost.percentOfInvestment.toStringAsFixed(2)}%',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
