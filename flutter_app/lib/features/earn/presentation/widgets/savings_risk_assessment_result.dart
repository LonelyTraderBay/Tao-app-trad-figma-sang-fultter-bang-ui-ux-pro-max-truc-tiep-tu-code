part of '../pages/savings_risk_assessment_page.dart';

class _InfoBanner extends StatelessWidget {
  const _InfoBanner({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: AppColors.primary20,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.primary,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text2,
                height: AppSpacing.savingsConsumerBodyLineHeight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultView extends StatelessWidget {
  const _ResultView({
    required this.snapshot,
    required this.result,
    required this.score,
    required this.onReset,
  });

  final SavingsRiskAssessmentSnapshot snapshot;
  final SavingsRiskProfileResultDraft result;
  final int score;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final accent = _profileAccent(result.level);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitHighRiskStatePanel(
          state: VitHighRiskUiState.success,
          title: 'Risk profile ready',
          message:
              'Review product fit, lockup, APY variability, risk notes and next steps before subscribing.',
          contractId: 'savings-risk-assessment-result',
        ),
        VitCard(
          key: SavingsRiskAssessmentPage.resultCardKey,
          radius: VitCardRadius.lg,
          borderColor: accent,
          padding: const EdgeInsets.all(AppSpacing.x5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  _ResultIcon(color: accent),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          result.label,
                          style: AppTextStyles.sectionTitle.copyWith(
                            color: accent,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.x1),
                        Text(
                          'Điểm hồ sơ: $score',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text3,
                            fontFeatures: AppTextStyles.tabularFigures,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.x4),
              Text(
                result.description,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  height: AppSpacing.savingsConsumerBodyLineHeight,
                ),
              ),
              const SizedBox(height: AppSpacing.x4),
              _StrategyMatchCard(strategyMatch: result.strategyMatch),
            ],
          ),
        ),
        VitPageSection(
          label: 'Gợi ý danh mục',
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
              _ProductResultTile(product: product),
          ],
        ),
        VitPageSection(
          label: 'Lưu ý rủi ro',
          accentColor: AppColors.warn,
          children: [
            for (final warning in result.warnings)
              _BulletRow(text: warning, color: AppColors.warn),
          ],
        ),
        _InfoBanner(text: snapshot.footerDisclaimer),
        VitCtaButton(
          key: SavingsRiskAssessmentPage.recommendationsButtonKey,
          onPressed: () {
            HapticFeedback.selectionClick();
            context.go(snapshot.recommendationsRoute);
          },
          trailing: const Icon(Icons.arrow_forward_rounded),
          child: const Text('Xem gợi ý cá nhân hóa'),
        ),
        Row(
          children: [
            Expanded(
              child: VitCtaButton(
                key: SavingsRiskAssessmentPage.productsButtonKey,
                variant: VitCtaButtonVariant.secondary,
                height: AppSpacing.buttonCompact,
                onPressed: () {
                  HapticFeedback.selectionClick();
                  context.go(snapshot.savingsRoute);
                },
                leading: const Icon(Icons.savings_outlined),
                child: const Text('Sản phẩm'),
              ),
            ),
            const SizedBox(width: AppSpacing.x2),
            Expanded(
              child: VitCtaButton(
                key: SavingsRiskAssessmentPage.resetButtonKey,
                variant: VitCtaButtonVariant.ghost,
                height: AppSpacing.buttonCompact,
                onPressed: onReset,
                leading: const Icon(Icons.refresh_rounded),
                child: const Text('Làm lại'),
              ),
            ),
          ],
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
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        border: Border.all(color: color.withValues(alpha: 0.25)),
        borderRadius: AppRadii.xlRadius,
      ),
      child: SizedBox(
        width: AppSpacing.x7,
        height: AppSpacing.x7,
        child: Icon(
          Icons.shield_outlined,
          color: color,
          size: AppSpacing.iconMd,
        ),
      ),
    );
  }
}
