part of '../pages/arena_creator_page.dart';

class _CompactStateCard extends StatelessWidget {
  const _CompactStateCard({
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: AppSpacing.arenaCreatorEmptyPadding,
      child: Column(
        children: [
          Icon(
            icon,
            color: AppColors.text3,
            size: AppSpacing.arenaCreatorEmptyIcon,
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyles.baseMedium.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _PolicyLink extends StatelessWidget {
  const _PolicyLink({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: VitCard(
        key: ArenaCreatorPage.policyKey,
        onTap: onTap,
        variant: VitCardVariant.ghost,
        radius: VitCardRadius.sm,
        padding: AppSpacing.arenaCreatorPolicyPadding,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.info_outline_rounded,
              color: AppColors.accent,
              size: AppSpacing.arenaCreatorInlineIcon,
            ),
            const SizedBox(width: AppSpacing.x2),
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.accent,
                fontWeight: AppTextStyles.medium,
              ),
            ),
            const SizedBox(width: AppSpacing.x1),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.accent,
              size: AppSpacing.arenaCreatorInlineIcon,
            ),
          ],
        ),
      ),
    );
  }
}

Color _metricColor(ArenaCreatorTrustMetricKind kind) {
  return switch (kind) {
    ArenaCreatorTrustMetricKind.fairPlay => AppColors.buy,
    ArenaCreatorTrustMetricKind.disputeRate => AppColors.buy,
    ArenaCreatorTrustMetricKind.completion => AppColors.primary,
    ArenaCreatorTrustMetricKind.communityRating => AppColors.warn,
  };
}

IconData _metricIcon(ArenaCreatorTrustMetricKind kind) {
  return switch (kind) {
    ArenaCreatorTrustMetricKind.fairPlay => Icons.shield_outlined,
    ArenaCreatorTrustMetricKind.disputeRate => Icons.flag_outlined,
    ArenaCreatorTrustMetricKind.completion => Icons.verified_outlined,
    ArenaCreatorTrustMetricKind.communityRating => Icons.star_outline_rounded,
  };
}
