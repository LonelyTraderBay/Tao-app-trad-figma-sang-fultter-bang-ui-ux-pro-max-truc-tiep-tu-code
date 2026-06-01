part of '../pages/prediction_market_maker_page.dart';

class _PositionsTab extends StatelessWidget {
  const _PositionsTab({required this.snapshot});

  final PredictionMarketMakerSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Cac vi the',
      accentColor: _predictionPrimary,
      children: [
        _PositionSummary(snapshot: snapshot),
        for (final position in snapshot.positions) _PositionCard(position),
      ],
    );
  }
}

class _PositionSummary extends StatelessWidget {
  const _PositionSummary({required this.snapshot});

  final PredictionMarketMakerSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _OverviewMetric(
                  label: 'Current Value',
                  value: _formatMoney(snapshot.totalValue),
                ),
              ),
              Expanded(
                child: _OverviewMetric(
                  label: 'Total Fees',
                  value: _formatMoney(snapshot.totalFees),
                  valueColor: AppColors.buy,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _OverviewMetric(
                  label: 'IL',
                  value: _formatMoney(snapshot.totalImpermanentLoss),
                  valueColor: AppColors.sell,
                  small: true,
                ),
              ),
              Expanded(
                child: _OverviewMetric(
                  label: 'Net Return',
                  value:
                      '${snapshot.netReturn >= 0 ? '+' : ''}${_formatMoney(snapshot.netReturn)}',
                  valueColor: snapshot.netReturn >= 0
                      ? AppColors.buy
                      : AppColors.sell,
                  small: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PositionCard extends StatelessWidget {
  const _PositionCard(this.position);

  final PredictionLiquidityPositionDraft position;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  position.eventName,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              Text(
                '${position.apr.toStringAsFixed(1)}% APR',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.buy,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _OverviewMetric(
                  label: 'Provided',
                  value: _formatMoney(position.liquidityProvided),
                  small: true,
                ),
              ),
              Expanded(
                child: _OverviewMetric(
                  label: 'Fees Earned',
                  value: '+${_formatMoney(position.feesEarned)}',
                  valueColor: AppColors.buy,
                  small: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
