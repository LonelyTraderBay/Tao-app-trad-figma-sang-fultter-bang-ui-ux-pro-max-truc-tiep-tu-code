part of '../pages/p2p_achievements_page.dart';

class _ProgressLine extends StatelessWidget {
  const _ProgressLine({
    required this.label,
    required this.value,
    required this.progress,
    required this.color,
    required this.minHeight,
  });

  final String label;
  final String value;
  final double progress;
  final Color color;
  final double minHeight;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ),
            Text(
              value,
              style: AppTextStyles.micro.copyWith(
                color: color,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x2),
        ClipRRect(
          borderRadius: AppRadii.xsRadius,
          child: LinearProgressIndicator(
            value: progress.clamp(0, 1),
            minHeight: minHeight,
            backgroundColor: AppColors.surface2,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}

class _RewardPill extends StatelessWidget {
  const _RewardPill({
    required this.reward,
    required this.color,
    required this.unlocked,
  });

  final String reward;
  final Color color;
  final bool unlocked;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      constraints: const BoxConstraints(
        maxWidth: AppSpacing.p2pTrustProgressRewardMaxWidth,
      ),
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.standard,
      background: ColoredBox(
        color: unlocked ? AppColors.buy10 : AppColors.surface2,
      ),
      padding: AppSpacing.p2pTrustProgressTinyPillPadding,
      clip: true,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.star_border_rounded,
            color: color,
            size: AppSpacing.p2pTrustProgressTinyIcon,
          ),
          const SizedBox(width: AppSpacing.x1),
          Flexible(
            child: Text(
              reward,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.micro.copyWith(
                color: color,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TradingLevelLink extends StatelessWidget {
  const _TradingLevelLink({required this.snapshot});

  final P2PAchievementsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PAchievementsPage.tradingLevelKey,
      radius: VitCardRadius.large,
      padding: AppSpacing.p2pTrustProgressCardPadding,
      onTap: () {
        HapticFeedback.selectionClick();
        context.go(snapshot.tradingLevelRoute);
      },
      child: Row(
        children: [
          const _AchievementIconBubble(
            icon: Icons.trending_up_rounded,
            color: AppColors.primary,
            showBadge: false,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Xem cấp bậc giao dịch',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  'Nâng cấp để mở thêm quyền lợi',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.text3,
            size: AppSpacing.iconMd,
          ),
        ],
      ),
    );
  }
}

IconData _achievementIcon(String iconKey) {
  return switch (iconKey) {
    'bolt' => Icons.bolt_rounded,
    'target' => Icons.track_changes_rounded,
    'medal' => Icons.workspace_premium_outlined,
    'trend' => Icons.trending_up_rounded,
    'shield' => Icons.shield_outlined,
    'star' => Icons.star_border_rounded,
    'users' => Icons.groups_2_outlined,
    _ => Icons.emoji_events_outlined,
  };
}

Color _toneColor(String toneKey) {
  return switch (toneKey) {
    'success' => AppColors.buy,
    'warning' => AppModuleAccents.p2p,
    'accent' => AppColors.accent,
    'highlight' => AppColors.sell,
    'orange' => AppColors.primary,
    _ => AppColors.primary,
  };
}
