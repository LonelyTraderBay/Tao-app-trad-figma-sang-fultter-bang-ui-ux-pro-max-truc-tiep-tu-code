part of 'onboarding_flow.dart';

class _GoalsStep extends StatelessWidget {
  const _GoalsStep({
    super.key,
    required this.goals,
    required this.selectedGoals,
    required this.onToggle,
  });

  final List<OnboardingGoalDraft> goals;
  final Set<OnboardingUserGoalDraft> selectedGoals;
  final ValueChanged<OnboardingUserGoalDraft> onToggle;

  @override
  Widget build(BuildContext context) {
    return VitPageContent(
      padding: VitContentPadding.relaxed,
      gap: VitContentGap.defaultGap,
      children: [
        _StepHeading(
          title: 'Bạn muốn làm gì?',
          subtitle: 'Chọn một hoặc nhiều mục tiêu để cá nhân hóa trải nghiệm',
        ),
        GridView.count(
          crossAxisCount: AppSpacing.onboardingGoalGridColumns,
          mainAxisSpacing: AppSpacing.x3,
          crossAxisSpacing: AppSpacing.x3,
          childAspectRatio: AppSpacing.onboardingGoalGridAspectRatio,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: [
            for (final goal in goals)
              _GoalTile(
                key: OnboardingFlow.goalKey(goal.id),
                goal: goal,
                selected: selectedGoals.contains(goal.id),
                onTap: () => onToggle(goal.id),
              ),
          ],
        ),
        Text(
          selectedGoals.isEmpty
              ? 'Bạn có thể bỏ qua bước này'
              : 'Đã chọn ${selectedGoals.length} mục tiêu',
          textAlign: TextAlign.center,
          style: AppTextStyles.captionSm.copyWith(color: AppColors.text3),
        ),
      ],
    );
  }
}

class _CompleteStep extends StatelessWidget {
  const _CompleteStep({
    super.key,
    required this.selectedGoals,
    required this.recommendations,
    required this.onOpenRoute,
  });

  final List<OnboardingUserGoalDraft> selectedGoals;
  final Map<OnboardingUserGoalDraft, OnboardingRecommendationDraft>
  recommendations;
  final ValueChanged<String> onOpenRoute;

  @override
  Widget build(BuildContext context) {
    final visibleRecommendations = selectedGoals
        .map((goal) => recommendations[goal])
        .whereType<OnboardingRecommendationDraft>()
        .take(3)
        .toList(growable: false);

    return VitPageContent(
      padding: VitContentPadding.relaxed,
      gap: VitContentGap.relaxed,
      children: [
        const SizedBox(height: AppSpacing.x5),
        const _HeroIcon(
          icon: Icons.check_circle_outline_rounded,
          success: true,
        ),
        Column(
          children: [
            Text(
              'Sẵn sàng!',
              textAlign: TextAlign.center,
              style: AppTextStyles.pageTitle,
            ),
            const SizedBox(height: AppSpacing.x2),
            Text(
              selectedGoals.isEmpty
                  ? 'Bạn đã sẵn sàng khám phá toàn bộ nền tảng'
                  : 'Trải nghiệm đã được cá nhân hóa theo mục tiêu của bạn',
              textAlign: TextAlign.center,
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
          ],
        ),
        if (visibleRecommendations.isNotEmpty) ...[
          VitPageSection(
            label: 'Đề xuất cho bạn',
            children: [
              for (final recommendation in visibleRecommendations)
                _RecommendationCard(
                  recommendation: recommendation,
                  onTap: () => onOpenRoute(recommendation.route),
                ),
            ],
          ),
        ],
        VitCard(
          padding: AppSpacing.onboardingCardPadding,
          radius: VitCardRadius.md,
          borderColor: AppColors.primary20,
          child: Text.rich(
            TextSpan(
              text:
                  'Bạn có thể thiết lập bảo mật nâng cao (2FA, biometrics) bất kỳ lúc nào trong ',
              children: [
                TextSpan(
                  text: 'Cài đặt bảo mật',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primary,
                    fontWeight: AppTextStyles.medium,
                  ),
                ),
                const TextSpan(text: '.'),
              ],
            ),
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
        ),
      ],
    );
  }
}

class _ProgressHeader extends StatelessWidget {
  const _ProgressHeader({required this.currentIndex, required this.total});

  final int currentIndex;
  final int total;

  @override
  Widget build(BuildContext context) {
    final progress = (currentIndex + 1) / total;

    return Column(
      children: [
        ClipRRect(
          borderRadius: AppRadii.xsRadius,
          child: LinearProgressIndicator(
            minHeight: AppSpacing.x2,
            value: progress,
            color: AppColors.primary,
            backgroundColor: AppColors.divider,
          ),
        ),
        const SizedBox(height: AppSpacing.x2),
        Row(
          children: [
            Text(
              'Bước ${currentIndex + 1}/$total',
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
            const Spacer(),
            Text(
              '${(progress * 100).round()}%',
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ],
        ),
      ],
    );
  }
}

class _StepHeading extends StatelessWidget {
  const _StepHeading({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: AppTextStyles.sectionTitle,
        ),
        const SizedBox(height: AppSpacing.x2),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: AppTextStyles.caption.copyWith(color: AppColors.text2),
        ),
      ],
    );
  }
}

class _HeroIcon extends StatelessWidget {
  const _HeroIcon({
    required this.icon,
    this.color = AppColors.primary,
    this.success = false,
  });

  final IconData icon;
  final Color color;
  final bool success;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox.square(
        dimension: AppSpacing.buttonHero,
        child: Material(
          color: success ? AppColors.buy : color,
          elevation: AppSpacing.onboardingHeroIconElevation,
          shadowColor: success ? AppColors.buy20 : AppColors.primary30,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadii.cardLargeRadius,
            side: BorderSide(color: success ? AppColors.buy20 : color),
          ),
          child: Icon(
            icon,
            color: AppColors.onAccent,
            size: AppSpacing.iconLg + AppSpacing.x2,
          ),
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({required this.feature});

  final OnboardingFeatureDraft feature;

  @override
  Widget build(BuildContext context) {
    final accent = _accentForId(feature.id);
    return Row(
      key: OnboardingFlow.featureKey(feature.id),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SmallIconBadge(
          icon: _iconForId(feature.id),
          color: accent,
          background: _backgroundForId(feature.id),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                feature.title,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.medium,
                ),
              ),
              Text(
                feature.description,
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SmallIconBadge extends StatelessWidget {
  const _SmallIconBadge({
    required this.icon,
    required this.color,
    required this.background,
  });

  final IconData icon;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: AppSpacing.onboardingSmallIconBox,
      child: Material(
        color: background,
        borderRadius: AppRadii.mdRadius,
        child: Icon(icon, color: color, size: AppSpacing.iconMd),
      ),
    );
  }
}

class _BoundaryCard extends StatelessWidget {
  const _BoundaryCard({
    required this.boundary,
    required this.expanded,
    required this.onTap,
  });

  final OnboardingBoundaryDraft boundary;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final accent = _accentForId(boundary.id);

    return VitCard(
      key: OnboardingFlow.boundaryKey(boundary.id),
      padding: AppSpacing.onboardingCardPadding,
      radius: VitCardRadius.md,
      borderColor: expanded ? accent : AppColors.cardBorder,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              _SmallIconBadge(
                icon: _iconForId(boundary.id),
                color: accent,
                background: _backgroundForId(boundary.id),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(boundary.title, style: AppTextStyles.baseMedium),
                    Text(
                      boundary.nature,
                      style: AppTextStyles.micro.copyWith(
                        color: accent,
                        fontWeight: AppTextStyles.medium,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            boundary.subtitle,
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: AppSpacing.x3),
          if (expanded)
            Column(
              children: [
                for (final example in boundary.examples) ...[
                  _BulletRow(
                    text: example,
                    color: accent,
                    icon: Icons.check_rounded,
                  ),
                  if (example != boundary.examples.last)
                    const SizedBox(height: AppSpacing.x2),
                ],
              ],
            )
          else
            Text(
              'Chạm để xem chi tiết',
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
        ],
      ),
    );
  }
}

class _TrustCard extends StatelessWidget {
  const _TrustCard({required this.pillar});

  final OnboardingTrustDraft pillar;

  @override
  Widget build(BuildContext context) {
    final accent = _accentForId(pillar.id);

    return VitCard(
      padding: AppSpacing.onboardingCardPadding,
      radius: VitCardRadius.md,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SmallIconBadge(
            icon: _iconForId(pillar.id),
            color: accent,
            background: _backgroundForId(pillar.id),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(pillar.title, style: AppTextStyles.baseMedium),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  pillar.description,
                  style: AppTextStyles.captionSm.copyWith(
                    color: AppColors.text2,
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
