part of '../pages/topic_hub_page.dart';

class _PredictionSection extends StatelessWidget {
  const _PredictionSection({required this.snapshot});

  final TopicHubSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return _SectionShell(
      key: TopicHubPage.predictionsSectionKey,
      icon: Icons.track_changes_rounded,
      title: 'Prediction Events',
      count: snapshot.predictions.length,
      color: AppModuleAccents.predictions,
      actionLabel: 'Xem tất cả',
      onAction: () => context.go(snapshot.predictionsRoute),
      children: [
        for (final event in snapshot.predictions.take(4))
          _PredictionEventCard(event: event),
      ],
    );
  }
}

class _ArenaRoomsSection extends StatelessWidget {
  const _ArenaRoomsSection({required this.snapshot});

  final TopicHubSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return _SectionShell(
      key: TopicHubPage.roomsSectionKey,
      icon: Icons.emoji_events_rounded,
      title: 'Live Arena Rooms',
      count: snapshot.arenaRooms.length,
      color: AppModuleAccents.arena,
      actionLabel: 'Xem tất cả',
      onAction: () => context.go(snapshot.arenaRoute),
      children: [
        for (final room in snapshot.arenaRooms.take(4))
          _ArenaRoomCard(room: room),
      ],
    );
  }
}

class _ModesSection extends StatelessWidget {
  const _ModesSection({required this.snapshot});

  final TopicHubSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return _SectionShell(
      key: TopicHubPage.modesSectionKey,
      icon: Icons.bolt_rounded,
      title: 'Featured Modes',
      count: snapshot.arenaModes.length,
      color: AppColors.buy,
      children: [
        for (final mode in snapshot.arenaModes.take(4))
          _ArenaModeCard(mode: mode),
      ],
    );
  }
}

class _CreatorsSection extends StatelessWidget {
  const _CreatorsSection({required this.snapshot});

  final TopicHubSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return _SectionShell(
      key: TopicHubPage.creatorsSectionKey,
      icon: Icons.groups_rounded,
      title: 'Top Creators',
      count: snapshot.creators.length,
      color: AppModuleAccents.markets,
      children: [
        Wrap(
          spacing: AppSpacing.x3,
          runSpacing: AppSpacing.x3,
          children: [
            for (final creator in snapshot.creators.take(6))
              _CreatorChip(creator: creator),
          ],
        ),
      ],
    );
  }
}

class _SectionShell extends StatelessWidget {
  const _SectionShell({
    super.key,
    required this.icon,
    required this.title,
    required this.count,
    required this.color,
    required this.children,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final int count;
  final Color color;
  final List<Widget> children;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    if (count == 0) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            _TinySectionIcon(icon: icon, color: color),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  _CountPill(count: count),
                ],
              ),
            ),
            if (actionLabel != null && onAction != null)
              VitCard(
                onTap: onAction,
                variant: VitCardVariant.ghost,
                radius: VitCardRadius.sm,
                borderColor: AppColors.transparent,
                padding: AppSpacing.discoveryInlineActionPadding,
                child: Padding(
                  padding: EdgeInsets.zero,
                  child: _InlineCta(label: actionLabel!, color: color),
                ),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.x3),
        ..._withSectionGaps(children),
      ],
    );
  }
}
