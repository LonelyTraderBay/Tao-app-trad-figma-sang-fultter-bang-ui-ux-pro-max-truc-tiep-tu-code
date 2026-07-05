part of '../pages/p2p_achievements_page.dart';

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.snapshot});

  final P2PAchievementsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final progressPct = (snapshot.overallProgress * 100).round();

    return VitCard(
      key: P2PAchievementsPage.summaryKey,
      radius: VitCardRadius.large,
      borderColor: AppColors.primary20,
      padding: AppSpacing.p2pTrustProgressHeroPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const _AchievementIconBubble(
                icon: Icons.emoji_events_outlined,
                color: AppModuleAccents.p2p,
                large: true,
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Thành tích đạt được',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text2,
                        fontWeight: AppTextStyles.medium,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      '${snapshot.unlockedCount}/${snapshot.achievements.length}',
                      style: AppTextStyles.amountMd.copyWith(
                        height: AppSpacing.p2pTrustProgressAmountLineHeight,
                        fontWeight: AppTextStyles.bold,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          _ProgressLine(
            label: 'Tiến trình tổng',
            value: '$progressPct%',
            progress: snapshot.overallProgress,
            color: AppModuleAccents.p2p,
            minHeight: AppSpacing.p2pTrustProgressSummaryProgressHeight,
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              Expanded(
                child: _SummaryMetric(
                  value: '+${snapshot.totalReputationPoints}',
                  label: 'Điểm uy tín',
                  color: AppModuleAccents.p2p,
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: _SummaryMetric(
                  value: '${snapshot.unlockedBadgeCount}',
                  label: 'Huy hiệu',
                  color: AppColors.buy,
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: _SummaryMetric(
                  value: 'Lv.${snapshot.currentLevel}',
                  label: 'Cấp hiện tại',
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryMetric extends StatelessWidget {
  const _SummaryMetric({
    required this.value,
    required this.label,
    required this.color,
  });

  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface2,
      borderRadius: AppRadii.cardRadius,
      child: Padding(
        padding: AppSpacing.p2pTrustProgressSummaryMetricPadding,
        child: Column(
          children: [
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: AppTextStyles.baseMedium.copyWith(
                color: color,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
            const SizedBox(height: AppSpacing.x1),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ],
        ),
      ),
    );
  }
}

class _AchievementCategory extends StatelessWidget {
  const _AchievementCategory({required this.snapshot, required this.category});

  final P2PAchievementsSnapshot snapshot;
  final P2PAchievementCategoryDraft category;

  @override
  Widget build(BuildContext context) {
    final achievements = snapshot.achievementsFor(category.id);
    final unlocked = achievements.where((item) => item.unlocked).length;
    if (achievements.isEmpty) return const SizedBox.shrink();

    return Column(
      key: P2PAchievementsPage.categoryKey(category.id),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text(
              category.label,
              style: AppTextStyles.sectionTitle.copyWith(
                fontWeight: AppTextStyles.bold,
              ),
            ),
            const SizedBox(width: AppSpacing.x2),
            VitStatusPill(
              label: '$unlocked/${achievements.length}',
              status: VitStatusPillStatus.neutral,
              size: VitStatusPillSize.sm,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x3),
        for (var index = 0; index < achievements.length; index++) ...[
          _AchievementCard(achievement: achievements[index]),
          if (index != achievements.length - 1)
            const SizedBox(height: AppSpacing.x3),
        ],
      ],
    );
  }
}

class _AchievementCard extends StatelessWidget {
  const _AchievementCard({required this.achievement});

  final P2PAchievementDraft achievement;

  @override
  Widget build(BuildContext context) {
    final color = _toneColor(achievement.toneKey);
    final textColor = achievement.unlocked ? AppColors.text1 : AppColors.text3;

    return VitCard(
      key: P2PAchievementsPage.achievementKey(achievement.id),
      radius: VitCardRadius.large,
      padding: AppSpacing.p2pTrustProgressCardPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _AchievementIconBubble(
            icon: achievement.unlocked
                ? _achievementIcon(achievement.iconKey)
                : Icons.lock_outline_rounded,
            color: achievement.unlocked ? color : AppColors.surface3,
            locked: !achievement.unlocked,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        achievement.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.caption.copyWith(
                          color: textColor,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                    if (achievement.unlockedAt != null) ...[
                      const SizedBox(width: AppSpacing.x2),
                      Text(
                        achievement.unlockedAt!,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                          fontFeatures: AppTextStyles.tabularFigures,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  achievement.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
                if (!achievement.unlocked) ...[
                  const SizedBox(height: AppSpacing.x2),
                  _ProgressLine(
                    label: achievement.currentValueLabel,
                    value: achievement.progressLabel,
                    progress: achievement.progress,
                    color: color,
                    minHeight: AppSpacing.p2pTrustProgressCardProgressHeight,
                  ),
                ],
                const SizedBox(height: AppSpacing.x2),
                Align(
                  alignment: Alignment.centerLeft,
                  child: _RewardPill(
                    reward: achievement.reward,
                    color: achievement.unlocked
                        ? AppColors.buy
                        : AppColors.text3,
                    unlocked: achievement.unlocked,
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

class _AchievementIconBubble extends StatelessWidget {
  const _AchievementIconBubble({
    required this.icon,
    required this.color,
    this.large = false,
    this.locked = false,
    this.showBadge = true,
  });

  final IconData icon;
  final Color color;
  final bool large;
  final bool locked;
  final bool showBadge;

  @override
  Widget build(BuildContext context) {
    final size = large
        ? AppSpacing.p2pTrustProgressIconBoxLarge
        : AppSpacing.p2pTrustProgressIconBox;
    final iconSize = large
        ? AppSpacing.p2pTrustProgressIconLarge
        : AppSpacing.p2pTrustProgressIcon;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Material(
          color: color.withValues(alpha: locked ? .34 : .22),
          borderRadius: AppRadii.smRadius,
          child: SizedBox(
            width: size,
            height: size,
            child: Icon(
              icon,
              color: locked ? AppColors.text3 : color,
              size: iconSize,
            ),
          ),
        ),
        if (!large && !locked && showBadge)
          Positioned(
            right: AppSpacing.p2pTrustProgressBadgeInset,
            bottom: AppSpacing.p2pTrustProgressBadgeInset,
            child: SizedBox.square(
              dimension: AppSpacing.p2pTrustProgressBadgeSize,
              child: Material(
                color: AppColors.buy,
                shape: const CircleBorder(
                  side: BorderSide(
                    color: AppColors.surface,
                    width: AppSpacing.p2pTrustProgressBadgeBorderWidth,
                  ),
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: AppColors.onAccent,
                  size: AppSpacing.p2pTrustProgressBadgeIcon,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
