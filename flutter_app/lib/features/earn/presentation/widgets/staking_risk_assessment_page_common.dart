part of '../pages/staking_risk_assessment_page.dart';

class _ResultView extends StatelessWidget {
  const _ResultView({
    required this.snapshot,
    required this.result,
    required this.score,
    required this.maxScore,
    required this.onReset,
  });

  final StakingRiskAssessmentSnapshot snapshot;
  final StakingRiskProfileResultDraft result;
  final int score;
  final int maxScore;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final accent = _profileAccent(result.level);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitHighRiskStatePanel(
          state: VitHighRiskUiState.success,
          title: 'Staking risk profile ready',
          message:
              'Review validator risk, lockup, APY variability, liquidity limits and confirmation path before subscribing.',
          contractId: 'staking-risk-assessment-result',
        ),
        VitCard(
          key: StakingRiskAssessmentPage.resultCardKey,
          radius: VitCardRadius.lg,
          borderColor: accent,
          padding: AppSpacing.earnCardPaddingX5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ResultIcon(color: accent),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hồ sơ rủi ro của bạn:',
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.x1),
                        Text(
                          result.label,
                          style: AppTextStyles.sectionTitle.copyWith(
                            color: accent,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.x2),
                        Text(
                          result.description,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text2,
                            height: AppSpacing.stakingAssessmentBodyLineHeight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.x4),
              _ScoreMeter(score: score, maxScore: maxScore, color: accent),
            ],
          ),
        ),
        VitPageSection(
          label: 'Gợi ý cho bạn',
          accentColor: accent,
          children: [
            for (final recommendation in result.recommendations)
              _BulletRow(text: recommendation, color: accent),
          ],
        ),
        VitPageSection(
          label: 'Sản phẩm phù hợp',
          accentColor: AppColors.buy,
          children: [
            for (final product in result.products)
              _ProductTile(product: product),
          ],
        ),
        VitPageSection(
          label: 'Lưu ý',
          accentColor: AppColors.warn,
          children: [
            for (final warning in result.warnings)
              _BulletRow(text: warning, color: AppColors.warn),
          ],
        ),
        _InfoBanner(text: snapshot.footerDisclaimer),
        VitCtaButton(
          key: StakingRiskAssessmentPage.exploreButtonKey,
          onPressed: () {
            HapticFeedback.selectionClick();
            context.go(snapshot.stakingRoute);
          },
          trailing: const Icon(Icons.arrow_forward_rounded),
          child: const Text('Khám phá sản phẩm'),
        ),
        VitCtaButton(
          key: StakingRiskAssessmentPage.resetButtonKey,
          variant: VitCtaButtonVariant.secondary,
          leading: const Icon(Icons.refresh_rounded),
          onPressed: onReset,
          child: const Text('Làm lại'),
        ),
      ],
    );
  }
}

class _ResultIcon extends StatelessWidget {
  const _ResultIcon({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: color.withValues(alpha: 0.12),
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: color,
            width: AppSpacing.stakingAssessmentOptionBorderWidth,
          ),
          borderRadius: AppRadii.xlRadius,
        ),
      ),
      child: SizedBox(
        width: AppSpacing.x7,
        height: AppSpacing.x7,
        child: Center(
          child: Icon(
            Icons.shield_outlined,
            color: color,
            size: AppSpacing.iconLg,
          ),
        ),
      ),
    );
  }
}

class _ScoreMeter extends StatelessWidget {
  const _ScoreMeter({
    required this.score,
    required this.maxScore,
    required this.color,
  });

  final int score;
  final int maxScore;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final progress = maxScore == 0 ? 0.0 : score / maxScore;

    return VitCard(
      variant: VitCardVariant.inner,
      padding: AppSpacing.earnCardPaddingX3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Điểm của bạn:',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
              ),
              Text(
                '$score/$maxScore điểm',
                style: AppTextStyles.caption.copyWith(
                  color: color,
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          ClipRRect(
            borderRadius: AppRadii.xlRadius,
            child: SizedBox(
              height: AppSpacing.x2,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  const ColoredBox(color: AppColors.surface3),
                  FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: progress.clamp(0, 1),
                    child: ColoredBox(color: color),
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

class _BulletRow extends StatelessWidget {
  const _BulletRow({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.check_circle_rounded, color: color, size: AppSpacing.iconSm),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              height: AppSpacing.stakingAssessmentBodyLineHeight,
            ),
          ),
        ),
      ],
    );
  }
}

class _ProductTile extends StatelessWidget {
  const _ProductTile({required this.product});

  final StakingRiskAssessmentProductDraft product;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: AppSpacing.earnCardPaddingX4,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name, style: AppTextStyles.baseMedium),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  'Rủi ro: ${product.risk}',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                product.apy,
                style: AppTextStyles.sectionTitle.copyWith(
                  color: AppColors.buy,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
              Text(
                'APY',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Color _profileAccent(StakingRiskProfileLevel level) {
  return switch (level) {
    StakingRiskProfileLevel.conservative => AppColors.buy,
    StakingRiskProfileLevel.moderate => AppColors.warn,
    StakingRiskProfileLevel.aggressive => AppColors.sell,
  };
}
