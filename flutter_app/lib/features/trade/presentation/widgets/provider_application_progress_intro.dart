part of '../pages/provider_application_page.dart';

class _ProgressBars extends StatelessWidget {
  const _ProgressBars({required this.steps, required this.activeStep});

  final List<TradeProviderApplicationStep> steps;
  final TradeProviderApplicationStep activeStep;

  @override
  Widget build(BuildContext context) {
    final activeIndex = steps.indexOf(activeStep);
    return Row(
      children: [
        for (var index = 0; index < steps.length; index++) ...[
          Expanded(
            child: Container(
              height: 4,
              decoration: BoxDecoration(
                color: activeIndex >= index
                    ? _providerPrimary
                    : AppColors.surface3,
                borderRadius: AppRadii.xlRadius,
              ),
            ),
          ),
          if (index != steps.length - 1) const SizedBox(width: 9),
        ],
      ],
    );
  }
}

class _IntroStep extends StatelessWidget {
  const _IntroStep({required this.snapshot});

  final TradeProviderApplicationSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Icon(Icons.groups_2_outlined, color: _providerPrimary, size: 44),
        const SizedBox(height: 38),
        Text(
          'Trở thành Copy Trading Provider',
          textAlign: TextAlign.center,
          style: AppTextStyles.sectionTitle.copyWith(height: 1.18),
        ),
        const SizedBox(height: 10),
        Text(
          'Chia sẻ chiến lược giao dịch và kiếm performance fee từ những người copy bạn',
          textAlign: TextAlign.center,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text3,
            height: 1.42,
          ),
        ),
        const SizedBox(height: 42),
        _SectionLabel(label: 'Lợi ích', color: _providerGreen),
        const SizedBox(height: 10),
        for (final benefit in snapshot.benefits) ...[
          _BenefitCard(benefit: benefit),
          if (benefit != snapshot.benefits.last) const SizedBox(height: 12),
        ],
        const SizedBox(height: 18),
        _ResponsibilitiesCard(items: snapshot.responsibilities),
        const SizedBox(height: 14),
        _SectionLabel(label: 'Yêu cầu cơ bản', color: AppColors.text3),
        const SizedBox(height: 10),
        for (final requirement in snapshot.requirements) ...[
          _RequirementPreview(requirement: requirement),
          if (requirement != snapshot.requirements.last)
            const SizedBox(height: 8),
        ],
      ],
    );
  }
}

class _BenefitCard extends StatelessWidget {
  const _BenefitCard({required this.benefit});

  final TradeProviderBenefit benefit;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      constraints: const BoxConstraints(minHeight: 64),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: AppColors.surfaceSuccessSoft,
              shape: BoxShape.circle,
            ),
            child: Icon(_benefitIcon(benefit.iconName), color: _providerGreen),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  benefit.title,
                  style: AppTextStyles.baseMedium.copyWith(
                    fontWeight: AppTextStyles.extraBold,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  benefit.description,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    height: 1.25,
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

class _ResponsibilitiesCard extends StatelessWidget {
  const _ResponsibilitiesCard({required this.items});

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(16),
      borderColor: _providerWarning.withValues(alpha: .55),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: _providerWarning,
            size: 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Trách nhiệm quan trọng',
                  style: AppTextStyles.baseMedium.copyWith(
                    color: _providerWarning,
                    fontWeight: AppTextStyles.extraBold,
                  ),
                ),
                const SizedBox(height: 6),
                for (final item in items)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: Text(
                      '• $item',
                      style: AppTextStyles.caption.copyWith(
                        color: _providerWarning,
                        height: 1.3,
                      ),
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

class _RequirementPreview extends StatelessWidget {
  const _RequirementPreview({required this.requirement});

  final TradeProviderRequirement requirement;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              requirement.label,
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
          ),
          Icon(
            requirement.met
                ? Icons.check_circle_rounded
                : Icons.cancel_outlined,
            color: requirement.met ? _providerGreen : AppColors.text3,
            size: 14,
          ),
        ],
      ),
    );
  }
}
