part of '../pages/risk_indicator_explainer_page.dart';

class _SriExplanationCard extends StatelessWidget {
  const _SriExplanationCard({required this.holdingPeriodYears});

  final int holdingPeriodYears;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.fromLTRB(16, 17, 16, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'The Summary Risk Indicator (SRI) is a guide to the level of risk '
            'of this product compared to other products. It shows how likely '
            'it is that the product will lose money because of movements in '
            'the markets or because we are not able to pay you.',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontSize: 11,
              height: 1.55,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 1),
                child: Icon(
                  Icons.info_outline_rounded,
                  color: AppColors.text1,
                  size: 15,
                ),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  'The risk indicator assumes you keep the product for '
                  '$holdingPeriodYears years. The actual risk can vary '
                  'significantly if you cash in at an early stage.',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text1,
                    fontSize: 10,
                    fontWeight: AppTextStyles.bold,
                    height: 1.28,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RiskLevelCard extends StatelessWidget {
  const _RiskLevelCard({required this.level, required this.isProductLevel});

  final TradeRiskIndicatorLevel level;
  final bool isProductLevel;

  @override
  Widget build(BuildContext context) {
    final color = _colorForTier(level.tier);
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 76),
      child: _Card(
        key: RiskIndicatorExplainerPage.levelKey(level.level),
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 11),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withValues(alpha: .11),
                borderRadius: AppRadii.lgRadius,
              ),
              alignment: Alignment.center,
              child: Text(
                '${level.level}',
                style: AppTextStyles.baseMedium.copyWith(
                  color: color,
                  fontSize: 18,
                  fontWeight: AppTextStyles.bold,
                  height: 1,
                ),
              ),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          level.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text1,
                            fontSize: 12,
                            fontWeight: AppTextStyles.bold,
                            height: 1.1,
                          ),
                        ),
                      ),
                      if (isProductLevel) ...[
                        const SizedBox(width: 9),
                        Text(
                          'THIS PRODUCT',
                          style: AppTextStyles.micro.copyWith(
                            color: _riskPrimary,
                            fontSize: 9,
                            fontWeight: AppTextStyles.bold,
                            height: 1,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    level.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      fontSize: 10,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Examples: ${level.examples.join(', ')}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      fontSize: 9,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AdditionalRisksCard extends StatelessWidget {
  const _AdditionalRisksCard({required this.risks});

  final List<TradeRiskIndicatorAdditionalRisk> risks;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 164),
      child: _Card(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 17),
        child: Column(
          children: [
            for (final risk in risks) ...[
              _AdditionalRiskRow(risk: risk),
              if (risk != risks.last) const SizedBox(height: 14),
            ],
          ],
        ),
      ),
    );
  }
}

class _AdditionalRiskRow extends StatelessWidget {
  const _AdditionalRiskRow({required this.risk});

  final TradeRiskIndicatorAdditionalRisk risk;

  @override
  Widget build(BuildContext context) {
    return Row(
      key: RiskIndicatorExplainerPage.additionalRiskKey(risk.title),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 1),
          child: Icon(
            Icons.warning_amber_rounded,
            color: AppColors.text1,
            size: 14,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                risk.title,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontSize: 11,
                  fontWeight: AppTextStyles.bold,
                  height: 1,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                risk.description,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  fontSize: 10,
                  height: 1.25,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 15,
          decoration: BoxDecoration(
            color: _riskPrimary,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 7),
        Expanded(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontSize: 12,
              fontWeight: AppTextStyles.bold,
              height: 1,
            ),
          ),
        ),
      ],
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({super.key, required this.child, required this.padding});

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: _riskPanel,
        border: Border.all(color: _riskBorder.withValues(alpha: .76)),
        borderRadius: AppRadii.cardRadius,
      ),
      child: child,
    );
  }
}

Color _colorForTier(TradeRiskIndicatorTier tier) {
  return switch (tier) {
    TradeRiskIndicatorTier.low => _riskGreen,
    TradeRiskIndicatorTier.medium => _riskPrimary,
    TradeRiskIndicatorTier.elevated => _riskAmber,
    TradeRiskIndicatorTier.high => _riskRed,
  };
}
