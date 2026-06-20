part of '../pages/arena_leaderboard_page.dart';

class _LeaderboardBody extends StatelessWidget {
  const _LeaderboardBody({
    required this.activeTab,
    required this.snapshot,
    required this.onCreator,
  });

  final _LeaderboardTab activeTab;
  final ArenaLeaderboardSnapshot snapshot;
  final ValueChanged<String> onCreator;

  @override
  Widget build(BuildContext context) {
    if (activeTab != _LeaderboardTab.creators) {
      return _CompactLeaderboardState(activeTab: activeTab);
    }

    return Column(
      children: [
        _Podium(entries: snapshot.podium),
        _EntrySection(
          title: 'Top Creators',
          accentColor: AppColors.accent,
          entries: snapshot.topCreators,
          onCreator: onCreator,
        ),
        const SizedBox(height: AppSpacing.x3),
        _EntrySection(
          title: 'Rising Creators',
          accentColor: AppColors.warn,
          entries: snapshot.risingCreators,
          onCreator: onCreator,
          rising: true,
        ),
      ],
    );
  }
}

class _Podium extends StatelessWidget {
  const _Podium({required this.entries});

  final List<ArenaLeaderboardEntryDraft> entries;

  @override
  Widget build(BuildContext context) {
    final first = entries.firstWhere((entry) => entry.rank == 1);
    final second = entries.firstWhere((entry) => entry.rank == 2);
    final third = entries.firstWhere((entry) => entry.rank == 3);

    return Padding(
      padding: _leaderboardPodiumPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: _PodiumItem(entry: second, size: _leaderboardPodiumSideSize),
          ),
          Expanded(
            child: _PodiumItem(
              entry: first,
              size: _leaderboardPodiumWinnerSize,
              crown: true,
            ),
          ),
          Expanded(
            child: _PodiumItem(entry: third, size: _leaderboardPodiumSideSize),
          ),
        ],
      ),
    );
  }
}

class _PodiumItem extends StatelessWidget {
  const _PodiumItem({
    required this.entry,
    required this.size,
    this.crown = false,
  });

  final ArenaLeaderboardEntryDraft entry;
  final double size;
  final bool crown;

  @override
  Widget build(BuildContext context) {
    final color = _rankColor(entry.rank);
    return Column(
      children: [
        if (crown) ...[
          const Icon(Icons.workspace_premium_rounded, color: AppColors.warn),
          const SizedBox(height: AppSpacing.x1),
        ],
        SizedBox(
          width: size,
          height: size,
          child: DecoratedBox(
            decoration: ShapeDecoration(
              color: AppColors.surface2,
              shape: RoundedRectangleBorder(
                borderRadius: crown ? AppRadii.cardRadius : AppRadii.mdRadius,
                side: BorderSide(
                  color: color,
                  width: _leaderboardPodiumBorderWidth,
                ),
              ),
              shadows: crown
                  ? [
                      BoxShadow(
                        color: AppColors.warn.withValues(alpha: .24),
                        blurRadius: _leaderboardPodiumShadowBlur,
                        spreadRadius: _leaderboardPodiumShadowSpread,
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: Icon(
                _leaderboardIcon(entry.icon),
                color: color,
                size: _leaderboardPodiumIcon,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.x2),
        Text(
          '#${entry.rank}',
          style: AppTextStyles.caption.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            height: _leaderboardLineHeight,
          ),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          entry.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text1,
            fontWeight: AppTextStyles.bold,
            height: _leaderboardLineHeight,
          ),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          entry.value,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.buy,
            fontWeight: AppTextStyles.bold,
            height: _leaderboardLineHeight,
          ),
        ),
      ],
    );
  }
}

class _EntrySection extends StatelessWidget {
  const _EntrySection({
    required this.title,
    required this.accentColor,
    required this.entries,
    required this.onCreator,
    this.rising = false,
  });

  final String title;
  final Color accentColor;
  final List<ArenaLeaderboardEntryDraft> entries;
  final ValueChanged<String> onCreator;
  final bool rising;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SectionLabel(title: title, accentColor: accentColor),
        const SizedBox(height: AppSpacing.x2),
        VitCard(
          clip: true,
          padding: AppSpacing.zeroInsets,
          density: VitDensity.compact,
          child: Column(
            children: [
              for (final entry in entries) ...[
                _LeaderboardRow(
                  entry: entry,
                  rising: rising,
                  onTap: entry.creatorId == null
                      ? null
                      : () => onCreator(entry.creatorId!),
                ),
                if (entry != entries.last)
                  const Divider(
                    height: _leaderboardDividerHeight,
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

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.title, required this.accentColor});

  final String title;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: _leaderboardSectionMarkerWidth,
          height: _leaderboardSectionMarkerHeight,
          child: DecoratedBox(
            decoration: ShapeDecoration(
              color: accentColor,
              shape: const RoundedRectangleBorder(
                borderRadius: AppRadii.xsRadius,
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Text(
          title,
          style: AppTextStyles.baseMedium.copyWith(
            color: AppColors.text1,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}
