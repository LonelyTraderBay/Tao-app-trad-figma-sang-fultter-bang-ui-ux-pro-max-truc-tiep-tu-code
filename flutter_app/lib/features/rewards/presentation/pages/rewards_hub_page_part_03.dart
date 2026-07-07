part of 'rewards_hub_page.dart';

class _ProgressSection extends StatelessWidget {
  const _ProgressSection({
    required this.summary,
    required this.leaderboard,
    required this.onLeaderboardTap,
  });

  final RewardSummaryDraft summary;
  final List<RewardLeaderboardDraft> leaderboard;
  final VoidCallback onLeaderboardTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: VitSectionHeader(
                title: 'Tiến trình & Phần thưởng',
                icon: Icons.workspace_premium_outlined,
                iconColor: AppModuleAccents.rewards,
                accentColor: AppModuleAccents.rewards,
                bottomGap: AppSpacing.pageRhythmStandardInnerGap,
              ),
            ),
            Text(
              summary.tierLabel,
              style: AppTextStyles.micro.copyWith(
                color: AppModuleAccents.rewards,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
        VitCard(
          padding: AppSpacing.arenaPaddingX4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const VitAccentIconBox(
                    icon: Icons.workspace_premium_outlined,
                    color: AppModuleAccents.rewards,
                  ),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          summary.tierLabel,
                          style: AppTextStyles.baseMedium.copyWith(
                            color: AppColors.text1,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                        Text(
                          'Cần thêm points để lên hạng Vàng',
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${_formatRewardPoints(summary.currentPoints)} pts',
                    style: AppTextStyles.caption.copyWith(
                      color: AppModuleAccents.rewards,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
              const _ProgressBar(value: .56, color: AppModuleAccents.rewards),
              const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
              Text(
                'Bảng xếp hạng',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: VitStatusPill(
                  key: RewardsHubPage.leaderboardKey,
                  label: 'Tất cả',
                  icon: Icons.chevron_right_rounded,
                  status: VitStatusPillStatus.purple,
                  size: VitStatusPillSize.sm,
                  onTap: onLeaderboardTap,
                ),
              ),
              const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
              for (final entry in leaderboard) ...[
                _LeaderboardRow(entry: entry),
                if (entry != leaderboard.last)
                  const Divider(
                    height: AppSpacing.arenaPointsDividerHeight,
                    color: AppColors.divider,
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _LeaderboardRow extends StatelessWidget {
  const _LeaderboardRow({required this.entry});

  final RewardLeaderboardDraft entry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.arenaPointsLeaderboardRowPadding,
      child: Row(
        children: [
          SizedBox(
            width: AppSpacing.x6,
            child: Text(
              '#${entry.rank}',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.warn,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              entry.name,
              style: AppTextStyles.caption.copyWith(color: AppColors.text1),
            ),
          ),
          Text(
            entry.pointsLabel,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.medium,
            ),
          ),
        ],
      ),
    );
  }
}

class _RewardsDisclaimer extends StatelessWidget {
  const _RewardsDisclaimer({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: AppSpacing.arenaPaddingX4,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.shield_outlined,
            color: AppModuleAccents.rewards,
            size: AppSpacing.arenaPointsCheckInIcon,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                height: AppSpacing.arenaPointsBodyLineHeight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.value, required this.color});

  final double value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final safeValue = value.clamp(0.0, 1.0).toDouble();
    return ClipRRect(
      borderRadius: AppRadii.xsRadius,
      child: SizedBox(
        height: AppSpacing.x3,
        child: ColoredBox(
          color: AppColors.surface3,
          child: Align(
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: safeValue,
              child: ColoredBox(color: color),
            ),
          ),
        ),
      ),
    );
  }
}

class _TinyStat extends StatelessWidget {
  const _TinyStat({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    this.alignEnd = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: alignEnd
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: AppSpacing.arenaPointsMicroIcon),
        const SizedBox(width: AppSpacing.x2),
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text2),
        ),
        const SizedBox(width: AppSpacing.x1),
        Flexible(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: AppSpacing.x2,
          height: AppSpacing.x2,
          child: DecoratedBox(
            decoration: ShapeDecoration(
              color: color,
              shape: const CircleBorder(),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.x1),
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
      ],
    );
  }
}

class _MiniBadge extends StatelessWidget {
  const _MiniBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: color,
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.xsRadius),
      ),
      child: Padding(
        padding: AppSpacing.arenaPointsMiniBadgePadding,
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.bg,
            fontWeight: AppTextStyles.bold,
            height: AppSpacing.arenaPointsBadgeLineHeight,
          ),
        ),
      ),
    );
  }
}

Color _accentColor(RewardAccentKind kind) {
  return switch (kind) {
    RewardAccentKind.daily => AppColors.primary,
    RewardAccentKind.weekly => AppModuleAccents.rewards,
    RewardAccentKind.flash => AppColors.sell,
    RewardAccentKind.learn => AppColors.buy,
    RewardAccentKind.achievement => AppColors.warn,
    RewardAccentKind.arena => AppColors.buy,
    RewardAccentKind.p2p => AppColors.primarySoft,
    RewardAccentKind.referral => AppColors.buy,
    RewardAccentKind.neutral => AppColors.text2,
  };
}

IconData _accentIcon(RewardAccentKind kind) {
  return switch (kind) {
    RewardAccentKind.daily => Icons.local_fire_department_outlined,
    RewardAccentKind.weekly => Icons.calendar_view_week_outlined,
    RewardAccentKind.flash => Icons.bolt_outlined,
    RewardAccentKind.learn => Icons.school_outlined,
    RewardAccentKind.achievement => Icons.emoji_events_outlined,
    RewardAccentKind.arena => Icons.shield_outlined,
    RewardAccentKind.p2p => Icons.handshake_outlined,
    RewardAccentKind.referral => Icons.group_add_outlined,
    RewardAccentKind.neutral => Icons.task_alt_outlined,
  };
}

VitTaskCardStatus _vitTaskCardStatus(RewardTaskStatus status) {
  return switch (status) {
    RewardTaskStatus.active => VitTaskCardStatus.active,
    RewardTaskStatus.completed => VitTaskCardStatus.completed,
    RewardTaskStatus.claimed => VitTaskCardStatus.claimed,
  };
}
