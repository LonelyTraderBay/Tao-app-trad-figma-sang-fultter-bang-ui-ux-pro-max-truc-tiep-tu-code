part of 'rewards_hub_page.dart';

class _CheckInSection extends StatelessWidget {
  const _CheckInSection({required this.checkIns});

  final List<RewardCheckInDraft> checkIns;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: const VitSectionHeader(
                title: 'Check-in hằng ngày',
                icon: Icons.calendar_month_outlined,
                iconColor: AppModuleAccents.rewards,
                accentColor: AppModuleAccents.rewards,
                bottomGap: AppSpacing.pageRhythmStandardInnerGap,
              ),
            ),
            Text(
              '4/7',
              style: AppTextStyles.micro.copyWith(
                color: AppModuleAccents.rewards,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
        VitCard(
          padding: ArenaSpacingTokens.arenaPaddingX3,
          child: Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const ClampingScrollPhysics(),
                child: Row(
                  children: [
                    for (final item in checkIns) ...[
                      SizedBox(
                        width: AppSpacing.x7 + AppSpacing.x4,
                        child: _CheckInTile(item: item),
                      ),
                      if (item != checkIns.last)
                        const SizedBox(width: AppSpacing.cardTileInnerGap),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
              Row(
                children: [
                  const Icon(
                    Icons.info_outline_rounded,
                    color: AppColors.text3,
                    size: ArenaSpacingTokens.arenaPointsMicroIcon,
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Expanded(
                    child: Text(
                      '7 ngày liên tiếp: +250 Arena Points',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CheckInTile extends StatelessWidget {
  const _CheckInTile({required this.item});

  final RewardCheckInDraft item;

  @override
  Widget build(BuildContext context) {
    final active = item.claimed || item.today;
    final color = item.today ? AppModuleAccents.rewards : AppColors.buy;

    return DecoratedBox(
      decoration: ShapeDecoration(
        color: active ? color.withValues(alpha: .13) : AppColors.surface2,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: active ? color.withValues(alpha: .30) : AppColors.cardBorder,
          ),
          borderRadius: AppRadii.cardRadius,
        ),
      ),
      child: Padding(
        padding: ArenaSpacingTokens.arenaPointsCheckInTilePadding,
        child: Column(
          children: [
            Text(
              item.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.micro.copyWith(
                color: item.today ? AppModuleAccents.rewards : AppColors.text3,
              ),
            ),
            const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
            Icon(
              item.claimed ? Icons.check_circle_outline : Icons.circle_outlined,
              color: color,
              size: ArenaSpacingTokens.arenaPointsCheckInIcon,
            ),
            const SizedBox(height: AppSpacing.x1),
            Text(
              item.reward,
              style: AppTextStyles.micro.copyWith(
                color: color,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReferralBanner extends StatelessWidget {
  const _ReferralBanner({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitModuleHeroCard(
      key: RewardsHubPage.referralKey,
      accentColor: AppColors.buy,
      onTap: onTap,
      padding: ArenaSpacingTokens.arenaPaddingX4,
      child: Row(
        children: [
          const VitAccentIconBox(
            icon: Icons.group_add_outlined,
            color: AppColors.buy,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mời bạn bè, cùng nhận thưởng',
                  style: AppTextStyles.baseMedium.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  '+200 Arena Points mỗi lượt mời',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.buy,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.buy,
            size: ArenaSpacingTokens.arenaPointsChevron,
          ),
        ],
      ),
    );
  }
}

class _TaskSection extends StatelessWidget {
  const _TaskSection({
    required this.completionLabel,
    required this.filters,
    required this.activeFilter,
    required this.tasks,
    required this.onFilter,
  });

  final String completionLabel;
  final List<String> filters;
  final String activeFilter;
  final List<RewardTaskDraft> tasks;
  final ValueChanged<String> onFilter;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: VitSectionHeader(
                title: 'Nhiệm vụ',
                icon: Icons.task_alt_outlined,
                iconColor: AppColors.primary,
                accentColor: AppColors.primary,
                bottomGap: AppSpacing.pageRhythmStandardInnerGap,
              ),
            ),
            Text(
              completionLabel,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.primary,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const ClampingScrollPhysics(),
          child: Row(
            children: [
              for (final filter in filters) ...[
                VitFilterChip(
                  key: filter == activeFilter
                      ? RewardsHubPage.activeFilterKey(filter)
                      : RewardsHubPage.filterKey(filter),
                  label: filter,
                  active: filter == activeFilter,
                  onTap: () => onFilter(filter),
                  color: AppModuleAccents.rewards,
                ),
                if (filter != filters.last)
                  const SizedBox(width: AppSpacing.x2),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        if (tasks.isEmpty)
          const VitEmptyState(
            icon: Icons.redeem_outlined,
            title: 'Không có nhiệm vụ nào',
            message: 'Chọn danh mục khác hoặc quay lại sau.',
          )
        else
          Column(
            children: [
              for (final task in tasks) ...[
                VitTaskCard(
                  key: RewardsHubPage.taskKey(task.id),
                  title: task.title,
                  subtitle: task.subtitle,
                  progress: task.progress,
                  rewardLabel: task.rewardLabel,
                  status: _vitTaskCardStatus(task.status),
                  accentColor: _accentColor(task.kind),
                  icon: _accentIcon(task.kind),
                ),
                if (task != tasks.last)
                  const SizedBox(height: AppSpacing.taskCardListGap),
              ],
            ],
          ),
      ],
    );
  }
}

class _BonusSection extends StatelessWidget {
  const _BonusSection({required this.rows});

  final List<RewardBonusDraft> rows;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: const VitSectionHeader(
                title: 'Khu vực Bonus',
                icon: Icons.auto_awesome_outlined,
                iconColor: AppColors.warn,
                accentColor: AppColors.warn,
                bottomGap: AppSpacing.pageRhythmStandardInnerGap,
              ),
            ),
            Text(
              '1 lượt quay',
              style: AppTextStyles.micro.copyWith(
                color: AppColors.warn,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
        VitCard(
          padding: AppSpacing.zeroInsets,
          clip: true,
          child: Column(
            children: [
              for (final row in rows) ...[
                _BonusRow(row: row),
                if (row != rows.last)
                  const Divider(
                    height: ArenaSpacingTokens.arenaPointsDividerHeight,
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

class _BonusRow extends StatelessWidget {
  const _BonusRow({required this.row});

  final RewardBonusDraft row;

  @override
  Widget build(BuildContext context) {
    final color = _accentColor(row.kind);
    return Padding(
      padding: ArenaSpacingTokens.arenaPaddingX4,
      child: Row(
        children: [
          VitAccentIconBox(icon: _accentIcon(row.kind), color: color),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  row.title,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  row.subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Text(
            row.rewardLabel,
            style: AppTextStyles.micro.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}
