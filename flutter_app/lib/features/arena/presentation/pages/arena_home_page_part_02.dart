part of 'arena_home_page.dart';

class _FeaturedModesSection extends StatelessWidget {
  const _FeaturedModesSection({
    required this.modes,
    required this.onViewAll,
    required this.onMode,
  });

  final List<ArenaModeDraft> modes;
  final VoidCallback onViewAll;
  final ValueChanged<String> onMode;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitModuleSectionHeader(
          title: 'Mode nổi bật',
          accentColor: AppColors.primary,
          actionLabel: 'Xem tất cả',
          onAction: onViewAll,
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          'Được cộng đồng yêu thích',
          style: AppTextStyles.caption.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x4),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              for (final item in modes) ...[
                SizedBox(
                  width: AppSpacing.arenaHomeModeCardWidth,
                  child: _ModeCard(mode: item, onTap: () => onMode(item.id)),
                ),
                if (item != modes.last) const SizedBox(width: AppSpacing.x3),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _ModeCard extends StatelessWidget {
  const _ModeCard({required this.mode, required this.onTap});

  final ArenaModeDraft mode;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: ArenaHomePage.modeKey(mode.id),
      onTap: onTap,
      padding: AppSpacing.arenaPaddingX4,
      constraints: const BoxConstraints(
        minHeight: AppSpacing.arenaHomeModeCardMinHeight,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _ActionIcon(
                icon: _templateIcon(_kindForMode(mode.templateId)),
                color: AppColors.primary,
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Text(
                  mode.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: AppTextStyles.bold,
                    height: AppSpacing.arenaHomeModeTitleLineHeight,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            mode.creatorName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontWeight: AppTextStyles.medium,
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              _MetaText('${mode.cloneCount} clone'),
              const _MetaDot(),
              _MetaText('${mode.completionRate}%'),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Wrap(
            spacing: AppSpacing.x2,
            runSpacing: AppSpacing.x2,
            children: [
              if (mode.fairPlay)
                const VitStatusPill(
                  label: 'Fair Play',
                  status: VitStatusPillStatus.success,
                  size: VitStatusPillSize.sm,
                ),
              for (final tag in mode.tags.take(2))
                VitStatusPill(
                  label: tag,
                  status: VitStatusPillStatus.neutral,
                  size: VitStatusPillSize.sm,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LiveRoomsSection extends StatelessWidget {
  const _LiveRoomsSection({required this.rooms, required this.onRoom});

  final List<ArenaChallengeDraft> rooms;
  final ValueChanged<String> onRoom;

  @override
  Widget build(BuildContext context) {
    final activeCount = rooms
        .where((item) => item.state != ArenaChallengeState.resolved)
        .length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const Expanded(
              child: VitModuleSectionHeader(
                title: 'Phòng đang mở',
                accentColor: AppColors.warn,
              ),
            ),
            VitStatusPill(
              label: '$activeCount live',
              status: VitStatusPillStatus.success,
              size: VitStatusPillSize.sm,
              pulse: true,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          'Tham gia ngay hoặc xem',
          style: AppTextStyles.caption.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x4),
        VitCard(
          clip: true,
          padding: AppSpacing.zeroInsets,
          child: Column(
            children: [
              for (var i = 0; i < rooms.length; i++) ...[
                _RoomRow(room: rooms[i], onTap: () => onRoom(rooms[i].id)),
                if (i < rooms.length - 1)
                  const Divider(
                    height: AppSpacing.arenaHomeDividerHeight,
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

class _RoomRow extends StatelessWidget {
  const _RoomRow({required this.room, required this.onTap});

  final ArenaChallengeDraft room;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final progress = room.slotsTotal == 0
        ? 0.0
        : (room.slotsFilled / room.slotsTotal).clamp(0.0, 1.0).toDouble();
    final color = _challengeStateColor(room.state);

    return InkWell(
      key: ArenaHomePage.roomKey(room.id),
      onTap: onTap,
      child: Padding(
        padding: AppSpacing.arenaPaddingX4,
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        room.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.body.copyWith(
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x1),
                      Row(
                        children: [
                          Flexible(child: _MetaText(room.format)),
                          const _MetaDot(),
                          const _MetaText('Công khai'),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.x3),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _challengeStateLabel(room.state),
                      style: AppTextStyles.micro.copyWith(
                        color: color,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      '${room.entryPoints} pts',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.warn,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.x3),
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: AppRadii.xsRadius,
                    child: LinearProgressIndicator(
                      minHeight: AppSpacing.arenaHomeRoomProgressHeight,
                      value: progress,
                      backgroundColor: AppColors.surface3,
                      color: color,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.x3),
                Text(
                  '${room.slotsFilled}/${room.slotsTotal}',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CreatorSpotlightSection extends StatelessWidget {
  const _CreatorSpotlightSection({
    required this.creators,
    required this.onCreator,
  });

  final List<ArenaCreatorDraft> creators;
  final ValueChanged<String> onCreator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const VitModuleSectionHeader(
          title: 'Creator nổi bật',
          accentColor: AppColors.buy,
        ),
        const SizedBox(height: AppSpacing.x4),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              for (final creator in creators) ...[
                SizedBox(
                  width: AppSpacing.arenaHomeCreatorCardWidth,
                  child: _CreatorCard(
                    creator: creator,
                    onTap: () => onCreator(creator.id),
                  ),
                ),
                if (creator != creators.last)
                  const SizedBox(width: AppSpacing.x3),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _CreatorCard extends StatelessWidget {
  const _CreatorCard({required this.creator, required this.onTap});

  final ArenaCreatorDraft creator;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: ArenaHomePage.creatorKey(creator.id),
      onTap: onTap,
      padding: AppSpacing.arenaPaddingX4,
      constraints: const BoxConstraints(
        minHeight: AppSpacing.arenaHomeCreatorCardMinHeight,
      ),
      child: Column(
        children: [
          SizedBox(
            width: AppSpacing.arenaHomeCreatorAvatar,
            height: AppSpacing.arenaHomeCreatorAvatar,
            child: DecoratedBox(
              decoration: const ShapeDecoration(
                color: AppColors.surface2,
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadii.cardRadius,
                  side: BorderSide(color: AppColors.cardBorder),
                ),
              ),
              child: const Icon(
                Icons.person_rounded,
                color: AppColors.warn,
                size: AppSpacing.arenaHomeCreatorIcon,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            creator.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            '${creator.modesCreated} modes · ${creator.totalChallenges} challenges',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x3),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: AppSpacing.x1,
            runSpacing: AppSpacing.x1,
            children: [
              if (creator.fairPlay)
                const VitStatusPill(
                  label: 'Fair Play',
                  status: VitStatusPillStatus.success,
                  size: VitStatusPillSize.sm,
                ),
              VitStatusPill(
                label: '${creator.trustScore}% Trust',
                status: VitStatusPillStatus.info,
                size: VitStatusPillSize.sm,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PredictionBridge extends StatelessWidget {
  const _PredictionBridge({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      onTap: onTap,
      borderColor: AppColors.accent20,
      padding: AppSpacing.arenaPaddingX4,
      child: Row(
        children: [
          _ActionIcon(
            icon: Icons.track_changes_rounded,
            color: AppColors.accent,
          ),
          const SizedBox(width: AppSpacing.x4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'MARKET CONTEXT ONLY',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.accent,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x2),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Bối cảnh thị trường',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.body.copyWith(
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                    const VitStatusPill(
                      label: 'Prediction Market',
                      status: VitStatusPillStatus.purple,
                      size: VitStatusPillSize.sm,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  'Theo dõi các prediction events liên quan',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  'Xem Prediction Markets',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.accent,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.accent,
            size: AppSpacing.arenaHomeBridgeChevron,
          ),
        ],
      ),
    );
  }
}
