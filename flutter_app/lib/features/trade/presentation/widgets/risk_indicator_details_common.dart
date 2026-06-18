part of '../pages/risk_indicator_explainer_page.dart';

class _SriExplanationCard extends StatelessWidget {
  const _SriExplanationCard({required this.holdingPeriodYears});

  final int holdingPeriodYears;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: AppSpacing.tradeBotCardPaddingTall,
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
              height: AppSpacing.tradeBotLineHeightRelaxed,
            ),
          ),
          const SizedBox(height: AppSpacing.tradeToolContentGap),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: AppSpacing.tradeBotNoticeIconTopPadding,
                child: Icon(
                  Icons.info_outline_rounded,
                  color: AppColors.text1,
                  size: AppSpacing.tradeBotSmallIcon,
                ),
              ),
              const SizedBox(width: AppSpacing.tradeBotDisclosureGap),
              Expanded(
                child: Text(
                  'The risk indicator assumes you keep the product for '
                  '$holdingPeriodYears years. The actual risk can vary '
                  'significantly if you cash in at an early stage.',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                    height: AppSpacing.tradeBotLineHeightCompact,
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
    return _Card(
      key: RiskIndicatorExplainerPage.levelKey(level.level),
      padding: AppSpacing.tradeBotCompactCardPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          VitCard(
            variant: VitCardVariant.ghost,
            radius: VitCardRadius.lg,
            width: AppSpacing.tradeBotQuestionIconBox,
            height: AppSpacing.tradeBotQuestionIconBox,
            alignment: Alignment.center,
            clip: true,
            borderColor: color.withValues(alpha: .18),
            background: ColoredBox(color: color.withValues(alpha: .11)),
            child: Text(
              '${level.level}',
              style: AppTextStyles.baseMedium.copyWith(
                color: color,
                fontWeight: AppTextStyles.bold,
                height: AppSpacing.tradeBotLineHeightTight,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.tradeBotCardGap),
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
                          fontWeight: AppTextStyles.bold,
                          height: AppSpacing.tradeBotLineHeightShort,
                        ),
                      ),
                    ),
                    if (isProductLevel) ...[
                      const SizedBox(width: AppSpacing.tradeBotDisclosureGap),
                      const VitAccentPill(
                        label: 'THIS PRODUCT',
                        accentColor: _riskPrimary,
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: AppSpacing.tradeBotSmallGap),
                Text(
                  level.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    height: AppSpacing.tradeBotLineHeightShort,
                  ),
                ),
                const SizedBox(height: AppSpacing.tradeBotNarrowIconGap),
                Text(
                  'Examples: ${level.examples.join(', ')}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    height: AppSpacing.tradeBotLineHeightTight,
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

class _AdditionalRisksCard extends StatelessWidget {
  const _AdditionalRisksCard({required this.risks});

  final List<TradeRiskIndicatorAdditionalRisk> risks;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 164),
      child: _Card(
        padding: AppSpacing.tradeBotCardPaddingLoose,
        child: Column(
          children: [
            for (final risk in risks) ...[
              _AdditionalRiskRow(risk: risk),
              if (risk != risks.last)
                const SizedBox(height: AppSpacing.tradeBotStatusGap),
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
          padding: AppSpacing.tradeBotNoticeIconTopPadding,
          child: Icon(
            Icons.warning_amber_rounded,
            color: AppColors.text1,
            size: AppSpacing.tradeBotSmallIcon,
          ),
        ),
        const SizedBox(width: AppSpacing.tradeBotSmallGap),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                risk.title,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                  height: AppSpacing.tradeBotLineHeightTight,
                ),
              ),
              const SizedBox(height: AppSpacing.tradeBotNarrowIconGap),
              Text(
                risk.description,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  height: AppSpacing.tradeBotLineHeightCompact,
                ),
              ),
            ],
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
    return VitCard(
      padding: padding,
      borderColor: _riskBorder.withValues(alpha: .76),
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
