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
            child: ClipRRect(
              borderRadius: AppRadii.pillRadius,
              child: SizedBox(
                height: AppSpacing.x1 + AppSpacing.hairlineStroke,
                child: ColoredBox(
                  color: activeIndex >= index
                      ? _providerPrimary
                      : AppColors.surface3,
                ),
              ),
            ),
          ),
          if (index != steps.length - 1)
            const SizedBox(width: AppSpacing.x3 + AppSpacing.hairlineStroke),
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
        const SizedBox(height: AppSpacing.x6 + AppSpacing.x1),
        Text(
          'Trở thành Copy Trading Provider',
          textAlign: TextAlign.center,
          style: AppTextStyles.sectionTitle.copyWith(
            height: AppSpacing.providerApplicationIntroTitleLineHeight,
          ),
        ),
        const SizedBox(height: AppSpacing.x3 + AppSpacing.hairlineStroke),
        Text(
          'Chia sẻ chiến lược giao dịch và kiếm performance fee từ những người copy bạn',
          textAlign: TextAlign.center,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text3,
            height: AppSpacing.providerApplicationIntroDescriptionLineHeight,
          ),
        ),
        const SizedBox(height: AppSpacing.x6 + AppSpacing.x3),
        _SectionLabel(label: 'Lợi ích', color: _providerGreen),
        const SizedBox(height: AppSpacing.x3 + AppSpacing.hairlineStroke),
        for (final benefit in snapshot.benefits) ...[
          _BenefitCard(benefit: benefit),
          if (benefit != snapshot.benefits.last)
            const SizedBox(height: AppSpacing.x4 - AppSpacing.x1),
        ],
        const SizedBox(height: AppSpacing.ctaLoadingIcon),
        _ResponsibilitiesCard(items: snapshot.responsibilities),
        const SizedBox(
          height: AppSpacing.x4 + AppSpacing.x1 - AppSpacing.hairlineStroke,
        ),
        _SectionLabel(label: 'Yêu cầu cơ bản', color: AppColors.text3),
        const SizedBox(height: AppSpacing.x3 + AppSpacing.hairlineStroke),
        for (final requirement in snapshot.requirements) ...[
          _RequirementPreview(requirement: requirement),
          if (requirement != snapshot.requirements.last)
            const SizedBox(height: AppSpacing.x3),
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
      constraints: AppSpacing.providerApplicationBenefitCardConstraints,
      padding: AppSpacing.providerApplicationBenefitCardPadding,
      child: Row(
        children: [
          CircleAvatar(
            radius: AppSpacing.x5 + AppSpacing.hairlineStroke,
            backgroundColor: AppColors.surfaceSuccessSoft,
            child: Icon(_benefitIcon(benefit.iconName), color: _providerGreen),
          ),
          const SizedBox(width: AppSpacing.x4 - AppSpacing.x1),
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
                const SizedBox(height: AppSpacing.x1),
                Text(
                  benefit.description,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    height:
                        AppSpacing
                            .providerApplicationBenefitDescriptionLineHeight,
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
      padding: AppSpacing.providerApplicationPanelPadding,
      borderColor: _providerWarning.withValues(alpha: .55),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: _providerWarning,
            size: 22,
          ),
          const SizedBox(width: AppSpacing.x4 - AppSpacing.x1),
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
                const SizedBox(height: AppSpacing.x2 + AppSpacing.x1),
                for (final item in items)
                  Padding(
                    padding:
                        AppSpacing.providerApplicationResponsibilityItemPadding,
                    child: Text(
                      '• $item',
                      style: AppTextStyles.caption.copyWith(
                        color: _providerWarning,
                        height:
                            AppSpacing
                                .providerApplicationResponsibilityLineHeight,
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
      height:
          AppSpacing.buttonCompact - AppSpacing.x1 + AppSpacing.hairlineStroke,
      padding: AppSpacing.providerApplicationRequirementPreviewPadding,
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
