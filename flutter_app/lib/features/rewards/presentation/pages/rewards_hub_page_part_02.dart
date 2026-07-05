part of 'rewards_hub_page.dart';

class _CheckInSection extends StatelessWidget {
  const _CheckInSection({required this.checkIns});

  final List<RewardCheckInDraft> checkIns;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _SectionTitle(
          title: 'Check-in hằng ngày',
          icon: Icons.calendar_month_outlined,
          trailing: '4/7',
          color: AppModuleAccents.rewards,
        ),
        const SizedBox(height: AppSpacing.x2),
        VitCard(
          padding: AppSpacing.arenaPaddingX3,
          child: Column(
            children: [
              Row(
                children: [
                  for (final item in checkIns) ...[
                    Expanded(child: _CheckInTile(item: item)),
                    if (item != checkIns.last)
                      const SizedBox(width: AppSpacing.x2),
                  ],
                ],
              ),
              const SizedBox(height: AppSpacing.x3),
              Row(
                children: [
                  const Icon(
                    Icons.info_outline_rounded,
                    color: AppColors.text3,
                    size: AppSpacing.arenaPointsMicroIcon,
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
        padding: AppSpacing.arenaPointsCheckInTilePadding,
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
            const SizedBox(height: AppSpacing.x2),
            Icon(
              item.claimed ? Icons.check_circle_outline : Icons.circle_outlined,
              color: color,
              size: AppSpacing.arenaPointsCheckInIcon,
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
      padding: AppSpacing.arenaPaddingX4,
      child: Row(
        children: [
          const _AccentIcon(icon: Icons.group_add_outlined, color: AppColors.buy),
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
            size: AppSpacing.arenaPointsChevron,
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
        _SectionTitle(
          title: 'Nhiệm vụ',
          trailing: completionLabel,
          icon: Icons.task_alt_outlined,
          color: AppColors.primary,
        ),
        const SizedBox(height: AppSpacing.x2),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const ClampingScrollPhysics(),
          child: Row(
            children: [
              for (final filter in filters) ...[
                _FilterButton(
                  label: filter,
                  active: filter == activeFilter,
                  onTap: () => onFilter(filter),
                ),
                if (filter != filters.last)
                  const SizedBox(width: AppSpacing.x2),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.x3),
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
                _TaskCard(task: task),
                if (task != tasks.last) const SizedBox(height: AppSpacing.x3),
              ],
            ],
          ),
      ],
    );
  }
}

class _FilterButton extends StatelessWidget {
  const _FilterButton({
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: VitCard(
        key: RewardsHubPage.filterKey(label),
        onTap: onTap,
        variant: VitCardVariant.ghost,
        radius: VitCardRadius.standard,
        child: DecoratedBox(
          key: active ? RewardsHubPage.activeFilterKey(label) : null,
          decoration: ShapeDecoration(
            color: active ? AppColors.primary12 : AppColors.surface2,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: active ? AppColors.primary30 : AppColors.borderSolid,
              ),
              borderRadius: AppRadii.smRadius,
            ),
          ),
          child: Padding(
            padding: AppSpacing.arenaPointsFilterPadding,
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: active ? AppColors.primary : AppColors.text2,
                fontWeight: AppTextStyles.medium,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TaskCard extends StatelessWidget {
  const _TaskCard({required this.task});

  final RewardTaskDraft task;

  @override
  Widget build(BuildContext context) {
    final color = _accentColor(task.kind);

    return VitCard(
      key: RewardsHubPage.taskKey(task.id),
      constraints: const BoxConstraints(
        minHeight: AppSpacing.buttonHero + AppSpacing.x7 + AppSpacing.x5,
      ),
      padding: AppSpacing.arenaPaddingX4,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _AccentIcon(icon: _accentIcon(task.kind), color: color),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        task.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.x2),
                    _TaskStatusPill(status: task.status),
                  ],
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  task.subtitle,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
                const SizedBox(height: AppSpacing.x5),
                _ProgressBar(value: task.progress, color: color),
                const SizedBox(height: AppSpacing.x3),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        task.rewardLabel,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.micro.copyWith(
                          color: task.status == RewardTaskStatus.claimed
                              ? AppColors.buy
                              : AppColors.warn,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                    Text(
                      '${(task.progress * 100).round()}%',
                      style: AppTextStyles.micro.copyWith(
                        color: color,
                        fontWeight: AppTextStyles.bold,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
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
        const _SectionTitle(
          title: 'Khu vực Bonus',
          trailing: '1 lượt quay',
          icon: Icons.auto_awesome_outlined,
          color: AppColors.warn,
        ),
        const SizedBox(height: AppSpacing.x2),
        VitCard(
          padding: AppSpacing.zeroInsets,
          clip: true,
          child: Column(
            children: [
              for (final row in rows) ...[
                _BonusRow(row: row),
                if (row != rows.last)
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

class _BonusRow extends StatelessWidget {
  const _BonusRow({required this.row});

  final RewardBonusDraft row;

  @override
  Widget build(BuildContext context) {
    final color = _accentColor(row.kind);
    return Padding(
      padding: AppSpacing.arenaPaddingX4,
      child: Row(
        children: [
          _AccentIcon(icon: _accentIcon(row.kind), color: color),
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
