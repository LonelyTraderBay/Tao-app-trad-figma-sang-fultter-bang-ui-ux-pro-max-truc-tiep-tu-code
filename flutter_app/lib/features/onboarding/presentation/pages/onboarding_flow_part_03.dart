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
    final accent = _accentForGoal(goal.id);

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
              _SmallIconBadge(
                icon: _iconForGoal(goal.id),
                color: accent,
                background: _backgroundForGoal(goal.id),
              ),
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
          const _SmallIconBadge(
            icon: Icons.arrow_outward_rounded,
            color: AppColors.primary,
            background: AppColors.primary12,
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: color,
          size: icon == Icons.circle
              ? OnboardingSpacingTokens.onboardingBulletDotIcon
              : OnboardingSpacingTokens.onboardingBulletIcon,
        ),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
        ),
      ],
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

Color _accentForId(String id) {
  return switch (id) {
    'security' || 'wallet' || 'safety' => AppColors.buy,
    'smart' || 'prediction' || 'transparency' => AppColors.accent,
    'arena' || 'points' || 'no_dark_patterns' || 'p2p' => AppColors.warn,
    'value' || 'trading' => AppModuleAccents.trade,
    _ => AppColors.primary,
  };
}

Color _backgroundForId(String id) {
  return switch (id) {
    'security' || 'wallet' || 'safety' => AppColors.buy15,
    'smart' || 'prediction' || 'transparency' => AppColors.accent15,
    'arena' || 'points' || 'no_dark_patterns' || 'p2p' => AppColors.warn15,
    _ => AppColors.primary12,
  };
}

IconData _iconForId(String id) {
  return switch (id) {
    'security' || 'safety' => Icons.shield_outlined,
    'smart' => Icons.bolt_rounded,
    'wallet' => Icons.account_balance_wallet_outlined,
    'p2p' => Icons.groups_2_outlined,
    'prediction' => Icons.query_stats_rounded,
    'arena' || 'points' => Icons.emoji_events_outlined,
    'value' || 'trading' => Icons.trending_up_rounded,
    'transparency' => Icons.visibility_outlined,
    'no_dark_patterns' => Icons.report_problem_outlined,
    _ => Icons.lock_outline_rounded,
  };
}

Color _accentForGoal(OnboardingUserGoalDraft goal) {
  return switch (goal) {
    OnboardingUserGoalDraft.saveRegularly => AppColors.buy,
    OnboardingUserGoalDraft.predictEvents => AppColors.accent,
    OnboardingUserGoalDraft.arenaChallenges => AppModuleAccents.arena,
    OnboardingUserGoalDraft.p2pExchange => AppModuleAccents.p2p,
    _ => AppColors.primary,
  };
}

Color _backgroundForGoal(OnboardingUserGoalDraft goal) {
  return switch (goal) {
    OnboardingUserGoalDraft.saveRegularly => AppColors.buy15,
    OnboardingUserGoalDraft.predictEvents => AppColors.accent15,
    OnboardingUserGoalDraft.arenaChallenges ||
    OnboardingUserGoalDraft.p2pExchange => AppColors.warn15,
    _ => AppColors.primary12,
  };
}

IconData _iconForGoal(OnboardingUserGoalDraft goal) {
  return switch (goal) {
    OnboardingUserGoalDraft.tradeCrypto => Icons.trending_up_rounded,
    OnboardingUserGoalDraft.saveRegularly => Icons.repeat_rounded,
    OnboardingUserGoalDraft.p2pExchange => Icons.groups_2_outlined,
    OnboardingUserGoalDraft.predictEvents => Icons.query_stats_rounded,
    OnboardingUserGoalDraft.arenaChallenges => Icons.emoji_events_outlined,
    OnboardingUserGoalDraft.earnRewards => Icons.card_giftcard_rounded,
  };
}
