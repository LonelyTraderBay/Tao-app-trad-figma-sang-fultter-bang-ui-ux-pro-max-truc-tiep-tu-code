part of '../pages/arena_leaderboard_page.dart';

class _MyRankCard extends StatelessWidget {
  const _MyRankCard({required this.myRank});

  final ArenaLeaderboardMyRankDraft myRank;

  @override
  Widget build(BuildContext context) {
    return VitModuleHeroCard(
      accentColor: AppColors.accent,
      density: VitDensity.compact,
      child: Row(
        children: [
          SizedBox(
            width: _leaderboardMyRankIconBox,
            height: _leaderboardMyRankIconBox,
            child: const DecoratedBox(
              decoration: ShapeDecoration(
                color: AppColors.accent12,
                shape: RoundedRectangleBorder(borderRadius: AppRadii.mdRadius),
              ),
              child: Center(
                child: Icon(
                  Icons.emoji_events_outlined,
                  color: AppColors.accent,
                  size: _leaderboardMyRankIcon,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Hạng của bạn',
                  style: AppTextStyles.baseMedium.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  myRank.summary,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '#${myRank.rank}',
                style: AppTextStyles.sectionTitle.copyWith(
                  color: AppColors.accent,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
              Text(
                myRank.pointsLabel,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.warn,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MainTabs extends StatelessWidget {
  const _MainTabs({required this.activeTab, required this.onChanged});

  final _LeaderboardTab activeTab;
  final ValueChanged<_LeaderboardTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitTabBar(
      variant: VitTabBarVariant.segment,
      activeKey: activeTab.name,
      onChanged: (key) => onChanged(
        _LeaderboardTab.values.firstWhere(
          (tab) => tab.name == key,
          orElse: () => _LeaderboardTab.creators,
        ),
      ),
      tabs: const [
        VitTabItem(key: 'creators', label: 'Creators'),
        VitTabItem(key: 'players', label: 'Players'),
        VitTabItem(key: 'teams', label: 'Teams'),
      ],
    );
  }
}

class _MetricChips extends StatelessWidget {
  const _MetricChips({
    required this.chips,
    required this.activeMetric,
    required this.onChanged,
  });

  final List<ArenaLeaderboardFilterDraft> chips;
  final String activeMetric;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const ClampingScrollPhysics(),
      child: Row(
        children: [
          for (final chip in chips) ...[
            _FilterChipButton(
              label: chip.label,
              icon: _leaderboardIcon(chip.icon),
              active: chip.id == activeMetric,
              accentColor: AppColors.accent,
              onTap: () => onChanged(chip.id),
            ),
            if (chip != chips.last) const SizedBox(width: AppSpacing.x2),
          ],
        ],
      ),
    );
  }
}

class _SeasonFilters extends StatelessWidget {
  const _SeasonFilters({
    required this.filters,
    required this.activeSeason,
    required this.onChanged,
  });

  final List<ArenaLeaderboardFilterDraft> filters;
  final String activeSeason;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final filter in filters) ...[
          _SeasonButton(
            label: filter.label,
            active: filter.id == activeSeason,
            onTap: () => onChanged(filter.id),
          ),
          if (filter != filters.last) const SizedBox(width: AppSpacing.x2),
        ],
      ],
    );
  }
}

class _FilterChipButton extends StatelessWidget {
  const _FilterChipButton({
    required this.label,
    required this.icon,
    required this.active,
    required this.accentColor,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool active;
  final Color accentColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitChoicePill(
      label: label,
      selected: active,
      onTap: onTap,
      accentColor: accentColor,
      padding: _leaderboardFilterPadding,
      leading: Icon(icon, size: _leaderboardFilterIcon),
    );
  }
}

class _SeasonButton extends StatelessWidget {
  const _SeasonButton({
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitChoicePill(
      label: label,
      selected: active,
      onTap: onTap,
      accentColor: AppColors.primary,
      padding: _leaderboardFilterPadding,
    );
  }
}
