part of '../pages/staking_risk_disclosure_page.dart';

class _AssessmentTab extends StatelessWidget {
  const _AssessmentTab({required this.snapshot, required this.onStart});

  final StakingRiskDisclosureSnapshot snapshot;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitCard(
          radius: VitCardRadius.lg,
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.primary12,
                      border: Border.all(
                        color: AppColors.primary30,
                        width: 1.5,
                      ),
                      borderRadius: AppRadii.cardLargeRadius,
                    ),
                    child: const Icon(
                      Icons.balance_rounded,
                      color: AppColors.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          snapshot.assessmentTitle,
                          style: AppTextStyles.baseMedium.copyWith(
                            color: AppColors.text1,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.x1),
                        Text(
                          snapshot.assessmentSubtitle,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text3,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.x4),
              Text(
                snapshot.assessmentBody,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: AppSpacing.x4),
              VitCtaButton(
                key: StakingRiskDisclosurePage.assessmentCtaKey,
                height: 44,
                onPressed: onStart,
                trailing: const Icon(Icons.chevron_right_rounded),
                child: Text(snapshot.assessmentCta),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.x5),
        _SectionLabel(snapshot.faqTitle),
        const SizedBox(height: AppSpacing.x3),
        for (final faq in snapshot.faqs) ...[
          VitCard(
            radius: VitCardRadius.lg,
            padding: const EdgeInsets.all(AppSpacing.x4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  faq.question,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  faq.answer,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontSize: 12,
                    height: 1.55,
                  ),
                ),
              ],
            ),
          ),
          if (faq != snapshot.faqs.last) const SizedBox(height: AppSpacing.x3),
        ],
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
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: AppSpacing.x2),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontWeight: AppTextStyles.bold,
            height: 1,
          ),
        ),
      ],
    );
  }
}

class _RiskLevelBadge extends StatelessWidget {
  const _RiskLevelBadge({required this.level, this.prefix = false});

  final StakingDisclosureRiskLevel level;
  final bool prefix;

  @override
  Widget build(BuildContext context) {
    final label = prefix
        ? 'Rủi ro ${_riskLevelLabel(level)}'
        : _riskLevelLabel(level);
    final color = _riskColor(level);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x2,
      ),
      decoration: BoxDecoration(
        color: _riskTint(level),
        borderRadius: AppRadii.mdRadius,
      ),
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
    );
  }
}

Color _riskColor(StakingDisclosureRiskLevel level) {
  return switch (level) {
    StakingDisclosureRiskLevel.low => AppColors.buy,
    StakingDisclosureRiskLevel.medium => AppColors.warn,
    StakingDisclosureRiskLevel.high => AppColors.sell,
  };
}

Color _riskTint(StakingDisclosureRiskLevel level) {
  return switch (level) {
    StakingDisclosureRiskLevel.low => AppColors.buy10,
    StakingDisclosureRiskLevel.medium => AppColors.warn10,
    StakingDisclosureRiskLevel.high => AppColors.sell10,
  };
}

String _riskLevelLabel(StakingDisclosureRiskLevel level) {
  return switch (level) {
    StakingDisclosureRiskLevel.low => 'Thấp',
    StakingDisclosureRiskLevel.medium => 'Trung bình',
    StakingDisclosureRiskLevel.high => 'Cao',
  };
}

IconData _categoryIcon(String id) {
  return switch (id) {
    'market' => Icons.trending_down_rounded,
    'liquidity' => Icons.lock_outline_rounded,
    'slashing' => Icons.report_problem_outlined,
    'smart-contract' => Icons.code_rounded,
    'counterparty' => Icons.business_rounded,
    'regulatory' => Icons.gavel_rounded,
    'technical' => Icons.public_rounded,
    _ => Icons.warning_amber_rounded,
  };
}
