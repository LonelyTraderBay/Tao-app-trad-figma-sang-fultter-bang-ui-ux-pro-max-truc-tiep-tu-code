part of 'onboarding_flow.dart';

class _GoalTile extends StatelessWidget {
  const _GoalTile({
    super.key,
    required this.goal,
    required this.selected,
    required this.onTap,
  });

  final OnboardingGoalDraft goal;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final visual = _visualForGoal(goal.id);
    final accent = visual.accent;

    return VitCard(
      variant: selected ? VitCardVariant.inner : VitCardVariant.standard,
      padding: OnboardingSpacingTokens.onboardingGoalTilePadding,
      borderColor: selected ? accent : AppColors.cardBorder,
      onTap: onTap,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              VitAccentIconBox(icon: visual.icon, color: accent),
              const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
              Text(
                goal.label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.medium,
                ),
              ),
              Text(
                goal.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
              if (goal.disclosure != null) ...[
                const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                VitAccentPill(label: goal.disclosure!, accentColor: accent),
              ],
            ],
          ),
          if (selected)
            Positioned(
              top: 0,
              right: 0,
              child: Material(
                color: accent,
                shape: const CircleBorder(),
                child: const Padding(
                  padding:
                      OnboardingSpacingTokens.onboardingSelectedCheckPadding,
                  child: Icon(
                    Icons.check_rounded,
                    size: AppSpacing.iconSm,
                    color: AppColors.onAccent,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _RecommendationCard extends StatelessWidget {
  const _RecommendationCard({
    required this.recommendation,
    required this.onTap,
  });

  final OnboardingRecommendationDraft recommendation;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: OnboardingSpacingTokens.onboardingCardPadding,
      radius: VitCardRadius.standard,
      borderColor: AppColors.primary20,
      onTap: onTap,
      child: Row(
        children: [
          const VitAccentIconBox(
            icon: Icons.arrow_outward_rounded,
            color: AppColors.primary,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(recommendation.title, style: AppTextStyles.baseMedium),
                Text(
                  recommendation.description,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.arrow_forward_rounded,
            size: AppSpacing.iconMd,
            color: AppColors.text3,
          ),
        ],
      ),
    );
  }
}

class _BulletRow extends StatelessWidget {
  const _BulletRow({
    required this.text,
    required this.color,
    this.icon = Icons.circle,
  });

  final String text;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return VitBulletRow(
      text: text,
      icon: icon,
      color: color,
      iconSize: icon == Icons.circle
          ? OnboardingSpacingTokens.onboardingBulletDotIcon
          : OnboardingSpacingTokens.onboardingBulletIcon,
    );
  }
}

class _BackControl extends StatelessWidget {
  const _BackControl({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    // card-tile: allow-start — fixed surface, not horizontal strip tile
    return VitCard(
      key: OnboardingFlow.backButtonKey,
      width: AppSpacing.ctaHeight,
      height: AppSpacing.ctaHeight,
      onTap: onPressed,
      variant: VitCardVariant.inner,
      borderColor: AppColors.borderSolid,
      alignment: Alignment.center,
      child: const Icon(
        Icons.chevron_left_rounded,
        color: AppColors.text2,
        size: AppSpacing.iconLg,
      ),
    );
  }
}

({Color accent, IconData icon}) _visualForId(String id) {
  return switch (id) {
    'security' ||
    'safety' => (accent: AppColors.buy, icon: Icons.shield_outlined),
    'wallet' => (
      accent: AppColors.buy,
      icon: Icons.account_balance_wallet_outlined,
    ),
    'smart' => (accent: AppColors.accent, icon: Icons.bolt_rounded),
    'prediction' => (accent: AppColors.accent, icon: Icons.query_stats_rounded),
    'transparency' => (
      accent: AppColors.accent,
      icon: Icons.visibility_outlined,
    ),
    'arena' ||
    'points' => (accent: AppColors.warn, icon: Icons.emoji_events_outlined),
    'no_dark_patterns' => (
      accent: AppColors.warn,
      icon: Icons.report_problem_outlined,
    ),
    'p2p' => (accent: AppColors.warn, icon: Icons.groups_2_outlined),
    'value' || 'trading' => (
      accent: AppModuleAccents.trade,
      icon: Icons.trending_up_rounded,
    ),
    _ => (accent: AppColors.primary, icon: Icons.lock_outline_rounded),
  };
}

({Color accent, IconData icon}) _visualForGoal(OnboardingUserGoalDraft goal) {
  return switch (goal) {
    OnboardingUserGoalDraft.tradeCrypto => (
      accent: AppColors.primary,
      icon: Icons.trending_up_rounded,
    ),
    OnboardingUserGoalDraft.saveRegularly => (
      accent: AppColors.buy,
      icon: Icons.repeat_rounded,
    ),
    OnboardingUserGoalDraft.p2pExchange => (
      accent: AppModuleAccents.p2p,
      icon: Icons.groups_2_outlined,
    ),
    OnboardingUserGoalDraft.predictEvents => (
      accent: AppColors.accent,
      icon: Icons.query_stats_rounded,
    ),
    OnboardingUserGoalDraft.arenaChallenges => (
      accent: AppModuleAccents.arena,
      icon: Icons.emoji_events_outlined,
    ),
    OnboardingUserGoalDraft.earnRewards => (
      accent: AppColors.primary,
      icon: Icons.card_giftcard_rounded,
    ),
  };
}
