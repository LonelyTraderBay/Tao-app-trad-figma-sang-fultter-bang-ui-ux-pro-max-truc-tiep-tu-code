part of '../pages/risk_indicator_explainer_page.dart';

class _ProductSriCard extends StatelessWidget {
  const _ProductSriCard({required this.snapshot});

  final TradeRiskIndicatorSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            snapshot.productName,
            textAlign: TextAlign.center,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Summary Risk Indicator',
            textAlign: TextAlign.center,
            style: AppTextStyles.baseMedium.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
              height: 1,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              for (final level in snapshot.levels) ...[
                Expanded(
                  child: _ScaleTile(
                    level: level.level,
                    color: level.level <= snapshot.productSri
                        ? _colorForTier(level.tier)
                        : _riskPanel2,
                    active: level.level <= snapshot.productSri,
                  ),
                ),
                if (level != snapshot.levels.last) const SizedBox(width: 4),
              ],
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Lower Risk',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  height: 1,
                ),
              ),
              Text(
                'Higher Risk',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  height: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const _SriWarning(),
        ],
      ),
    );
  }
}

class _ScaleTile extends StatelessWidget {
  const _ScaleTile({
    required this.level,
    required this.color,
    required this.active,
  });

  final int level;
  final Color color;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 48),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color,
          borderRadius: AppRadii.xsRadius,
        ),
        child: Center(
          child: Text(
            '$level',
            style: AppTextStyles.baseMedium.copyWith(
              color: active ? AppColors.onAccent : AppColors.text3,
              fontWeight: AppTextStyles.bold,
              height: 1,
            ),
          ),
        ),
      ),
    );
  }
}

class _SriWarning extends StatelessWidget {
  const _SriWarning();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.ghost,
      constraints: const BoxConstraints(minHeight: 52),
      padding: const EdgeInsets.fromLTRB(13, 11, 13, 11),
      borderColor: _riskAmber.withValues(alpha: .24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Icon(
              Icons.warning_amber_rounded,
              color: _riskAmber,
              size: 15,
            ),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text: 'SRI 6 - High Risk: ',
                    style: TextStyle(fontWeight: AppTextStyles.bold),
                  ),
                  const TextSpan(
                    text:
                        'This product has high volatility. You could lose a '
                        'significant portion of your investment.',
                  ),
                ],
              ),
              style: AppTextStyles.micro.copyWith(
                color: _riskAmber,
                fontWeight: AppTextStyles.medium,
                height: 1.28,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
