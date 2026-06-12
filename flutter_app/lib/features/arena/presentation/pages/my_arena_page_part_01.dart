part of 'my_arena_page.dart';

class _PointsHero extends StatelessWidget {
  const _PointsHero({
    required this.stats,
    required this.onDetails,
    required this.onEarn,
  });

  final MyArenaStats stats;
  final VoidCallback onDetails;
  final VoidCallback onEarn;

  @override
  Widget build(BuildContext context) {
    return VitModuleHeroCard(
      accentColor: _arenaAccent,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.contentPad,
              AppSpacing.contentPad,
              AppSpacing.contentPad,
              AppSpacing.x4,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Arena Points',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text3,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                    _TextIconButton(
                      key: MyArenaPage.pointsDetailKey,
                      icon: Icons.visibility_outlined,
                      label: 'Chi tiết',
                      color: AppColors.text3,
                      onTap: onDetails,
                    ),
                  ],
                ),
                const Padding(padding: EdgeInsets.only(top: AppSpacing.x3)),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      formatArenaPoints(stats.currentBalance),
                      style: AppTextStyles.heroNumber.copyWith(
                        fontWeight: AppTextStyles.heavy,
                        height: AppSpacing.myArenaBalanceLineHeight,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.x2),
                    Padding(
                      padding: AppSpacing.myArenaBalanceSuffixPadding,
                      child: Text(
                        'pts',
                        style: AppTextStyles.base.copyWith(
                          color: AppColors.text3,
                          fontWeight: AppTextStyles.medium,
                          height: AppSpacing.myArenaBalanceLineHeight,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(
            height: AppSpacing.myArenaDividerHeight,
            color: AppColors.divider,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.contentPad,
              AppSpacing.x4,
              AppSpacing.contentPad,
              AppSpacing.contentPad,
            ),
            child: Row(
              children: [
                Expanded(
                  child: _PointsDelta(
                    label: 'Đã nhận',
                    value: '+${formatArenaPoints(stats.pointsEarned)}',
                    color: AppColors.buy,
                  ),
                ),
                const SizedBox(
                  height: AppSpacing.myArenaPointsDeltaDividerHeight,
                  child: VerticalDivider(
                    width: AppSpacing.x5,
                    color: AppColors.divider,
                  ),
                ),
                Expanded(
                  child: _PointsDelta(
                    label: 'Đã dùng',
                    value: '-${formatArenaPoints(stats.pointsSpent)}',
                    color: AppColors.sell,
                  ),
                ),
                const SizedBox(width: AppSpacing.x4),
                _AccentPillButton(
                  icon: Icons.redeem_rounded,
                  label: 'Kiếm Points',
                  color: AppColors.accent,
                  onTap: onEarn,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PointsDelta extends StatelessWidget {
  const _PointsDelta({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              height: AppSpacing.myArenaDeltaDot,
              width: AppSpacing.myArenaDeltaDot,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: AppSpacing.x2),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  fontWeight: AppTextStyles.medium,
                ),
              ),
            ),
          ],
        ),
        const Padding(padding: EdgeInsets.only(top: AppSpacing.x2)),
        Text(
          value,
          style: AppTextStyles.base.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
            height: AppSpacing.myArenaBalanceLineHeight,
          ),
        ),
      ],
    );
  }
}

class _StatsGrid extends StatelessWidget {
  const _StatsGrid({required this.stats});

  final MyArenaStats stats;

  @override
  Widget build(BuildContext context) {
    final items = [
      _StatItem(
        label: 'Đang chơi',
        value: '${stats.activeChallenges}',
        subtitle: 'challenges đang hoạt động',
        icon: Icons.flash_on_rounded,
        color: AppColors.primary,
      ),
      _StatItem(
        label: 'Mode đã tạo',
        value: '${stats.modesCreated}',
        subtitle: 'modes trong cộng đồng',
        icon: Icons.auto_awesome_rounded,
        color: AppColors.accent,
      ),
      _StatItem(
        label: 'Điểm Creator',
        value: '${stats.creatorScore}%',
        subtitle: 'dựa trên đánh giá',
        icon: Icons.star_border_rounded,
        color: AppColors.buy,
      ),
      _StatItem(
        label: 'Xếp hạng',
        value: '#${stats.rank}',
        subtitle: 'trên leaderboard',
        icon: Icons.emoji_events_outlined,
        color: AppColors.warn,
      ),
    ];

    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _ArenaStatCard(item: items[0])),
            const SizedBox(width: AppSpacing.x4),
            Expanded(child: _ArenaStatCard(item: items[1])),
          ],
        ),
        const Padding(padding: EdgeInsets.only(top: AppSpacing.x4)),
        Row(
          children: [
            Expanded(child: _ArenaStatCard(item: items[2])),
            const SizedBox(width: AppSpacing.x4),
            Expanded(child: _ArenaStatCard(item: items[3])),
          ],
        ),
      ],
    );
  }
}

class _StatItem {
  const _StatItem({
    required this.label,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;
}

class _ArenaStatCard extends StatelessWidget {
  const _ArenaStatCard({required this.item});

  final _StatItem item;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.md,
      padding: const EdgeInsets.all(AppSpacing.x4),
      constraints: const BoxConstraints(
        minHeight: AppSpacing.myArenaStatCardMinHeight,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: AppSpacing.myArenaStatIconBox,
                width: AppSpacing.myArenaStatIconBox,
                decoration: BoxDecoration(
                  color: item.color.withValues(alpha: .14),
                  borderRadius: AppRadii.mdRadius,
                ),
                child: Icon(
                  item.icon,
                  color: item.color,
                  size: AppSpacing.myArenaStatIcon,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Text(
                  item.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ],
          ),
          const Padding(padding: EdgeInsets.only(top: AppSpacing.x4)),
          Text(
            item.value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.sectionTitle.copyWith(
              color: item.color,
              fontWeight: AppTextStyles.heavy,
              fontFeatures: AppTextStyles.tabularFigures,
              height: AppSpacing.myArenaBalanceLineHeight,
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: AppSpacing.x2)),
          Text(
            item.subtitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _QuickLinks extends StatelessWidget {
  const _QuickLinks({required this.onLeaderboard, required this.onDiscover});

  final VoidCallback onLeaderboard;
  final VoidCallback onDiscover;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _QuickLinkButton(
            key: MyArenaPage.leaderboardKey,
            icon: Icons.emoji_events_outlined,
            label: 'Leaderboard',
            onTap: onLeaderboard,
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: _QuickLinkButton(
            key: MyArenaPage.discoverKey,
            icon: Icons.bolt_rounded,
            label: 'Khám phá',
            onTap: onDiscover,
          ),
        ),
      ],
    );
  }
}

class _QuickLinkButton extends StatelessWidget {
  const _QuickLinkButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      borderRadius: AppRadii.inputRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.inputRadius,
        child: Container(
          height: AppSpacing.myArenaQuickLinkHeight,
          decoration: BoxDecoration(
            color: AppColors.surface2,
            border: Border.all(color: AppColors.cardBorder),
            borderRadius: AppRadii.inputRadius,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: AppColors.text2,
                size: AppSpacing.myArenaQuickLinkIcon,
              ),
              const SizedBox(width: AppSpacing.x2),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text2,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ArenaTabs extends StatelessWidget {
  const _ArenaTabs({required this.activeTab, required this.onChanged});

  final _MyArenaTab activeTab;
  final ValueChanged<_MyArenaTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: MyArenaPage.tabsScrollKey,
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          for (final tab in _tabConfigs) ...[
            _ArenaTabPill(
              config: tab,
              active: tab.tab == activeTab,
              onTap: () => onChanged(tab.tab),
            ),
            if (tab != _tabConfigs.last) const SizedBox(width: AppSpacing.x2),
          ],
        ],
      ),
    );
  }
}

class _TabConfig {
  const _TabConfig({
    required this.tab,
    required this.id,
    required this.label,
    required this.icon,
  });

  final _MyArenaTab tab;
  final String id;
  final String label;
  final IconData icon;
}

const _tabConfigs = [
  _TabConfig(
    tab: _MyArenaTab.myRooms,
    id: 'my_rooms',
    label: 'Phòng của tôi',
    icon: Icons.star_border_rounded,
  ),
  _TabConfig(
    tab: _MyArenaTab.joined,
    id: 'joined',
    label: 'Đã tham gia',
    icon: Icons.group_outlined,
  ),
  _TabConfig(
    tab: _MyArenaTab.savedModes,
    id: 'saved_modes',
    label: 'Mode đã lưu',
    icon: Icons.bookmark_border_rounded,
  ),
  _TabConfig(
    tab: _MyArenaTab.drafts,
    id: 'drafts',
    label: 'Bản nháp',
    icon: Icons.edit_note_rounded,
  ),
  _TabConfig(
    tab: _MyArenaTab.history,
    id: 'history',
    label: 'Lịch sử',
    icon: Icons.history_rounded,
  ),
];

class _ArenaTabPill extends StatelessWidget {
  const _ArenaTabPill({
    required this.config,
    required this.active,
    required this.onTap,
  });

  final _TabConfig config;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = active ? _arenaAccent : AppColors.text2;
    return Material(
      key: MyArenaPage.tabKey(config.id),
      color: AppColors.transparent,
      borderRadius: AppRadii.inputRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.inputRadius,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          height: AppSpacing.myArenaTabHeight,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x4),
          decoration: BoxDecoration(
            color: active ? AppColors.warn08 : AppColors.surface2,
            border: Border.all(
              color: active ? AppColors.warningBorder : AppColors.cardBorder,
            ),
            borderRadius: AppRadii.inputRadius,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(config.icon, color: color, size: AppSpacing.myArenaTabIcon),
              const SizedBox(width: AppSpacing.x2),
              Text(
                config.label,
                style: AppTextStyles.micro.copyWith(
                  color: color,
                  fontWeight: AppTextStyles.bold,
                  height: AppSpacing.myArenaBalanceLineHeight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
