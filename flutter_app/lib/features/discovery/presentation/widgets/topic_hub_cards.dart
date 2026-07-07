part of '../pages/topic_hub_page.dart';

class _PredictionEventCard extends StatelessWidget {
  const _PredictionEventCard({required this.event});

  final DiscoveryPredictionEventDraft event;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: TopicHubPage.predictionKey(event.id),
      onTap: () => context.go(event.route),
      padding: AppSpacing.discoveryCardPadding,
      borderColor: AppModuleAccents.predictions.withValues(alpha: .16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const _ModuleBadge(
                label: 'Prediction Market',
                icon: Icons.track_changes_rounded,
                color: AppModuleAccents.predictions,
              ),
              if (event.isTrending) ...[
                const SizedBox(width: AppSpacing.x3),
                Text(
                  'Trending',
                  style: AppTextStyles.micro.copyWith(
                    color: AppModuleAccents.arena,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            event.title,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              height: AppSpacing.discoveryPredictionTitleLineHeight,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Row(
            children: [
              Text(
                '${event.topOutcome} ${event.chance}%',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.buy,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: Text(
                  'Vol ${event.volumeLabel}',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
              const _InlineCta(
                label: 'Xem thị trường',
                color: AppModuleAccents.predictions,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ArenaRoomCard extends StatelessWidget {
  const _ArenaRoomCard({required this.room});

  final DiscoveryArenaRoomDraft room;

  @override
  Widget build(BuildContext context) {
    final statusColor = room.statusLabel == 'Live'
        ? AppColors.buy
        : AppModuleAccents.arena;
    return VitCard(
      key: TopicHubPage.roomKey(room.id),
      onTap: () => context.go(room.route),
      padding: AppSpacing.discoveryCardPadding,
      borderColor: AppModuleAccents.arena.withValues(alpha: .16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const _ModuleBadge(
                label: 'Arena Points only',
                icon: Icons.stars_rounded,
                color: AppModuleAccents.arena,
              ),
              const SizedBox(width: AppSpacing.x3),
              _StatusMini(label: room.statusLabel, color: statusColor),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Text(
            room.title,
            style: AppTextStyles.body.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            children: [
              Text(
                '${room.entryPoints} pts',
                style: AppTextStyles.micro.copyWith(
                  color: AppModuleAccents.arena,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: Text(
                  '${room.slotsFilled}/${room.slotsTotal} (${room.fillPercent}%) · ${room.creatorName}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
              const _InlineCta(
                label: 'Xem room',
                color: AppModuleAccents.arena,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ArenaModeCard extends StatelessWidget {
  const _ArenaModeCard({required this.mode});

  final DiscoveryArenaModeDraft mode;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: TopicHubPage.modeKey(mode.id),
      onTap: () => context.go(mode.route),
      padding: AppSpacing.discoveryCardPadding,
      child: Row(
        children: [
          _SmallAccentIcon(
            icon: Icons.bolt_rounded,
            color: AppModuleAccents.arena,
          ),
          const SizedBox(width: AppSpacing.x4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        mode.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                    if (mode.fairPlay) ...[
                      const SizedBox(width: AppSpacing.x2),
                      const Icon(
                        Icons.shield_rounded,
                        color: AppColors.buy,
                        size: 12,
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  '${mode.activeChallenges} challenges · ${mode.cloneCount} clones',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          const _InlineCta(label: 'Xem mode', color: AppModuleAccents.arena),
        ],
      ),
    );
  }
}

class _CreatorChip extends StatelessWidget {
  const _CreatorChip({required this.creator});

  final DiscoveryCreatorDraft creator;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: TopicHubPage.creatorKey(creator.id),
      onTap: () => context.go(creator.route),
      variant: VitCardVariant.inner,
      borderColor: AppColors.borderSolid,
      padding: AppSpacing.discoveryPillPadding,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _CreatorAvatar(initials: creator.initials),
          const SizedBox(width: AppSpacing.x3),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                creator.name,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              Text(
                'Trust ${creator.trustScore}%',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CreateRoomCard extends StatelessWidget {
  const _CreateRoomCard({required this.snapshot});

  final TopicHubSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: TopicHubPage.createRoomKey,
      padding: AppSpacing.discoveryCardPadding,
      borderColor: AppModuleAccents.arena.withValues(alpha: .22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _SmallAccentIcon(
                icon: Icons.bolt_rounded,
                color: AppModuleAccents.arena,
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tạo room Arena theo chủ đề',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      'Tạo thách đấu Arena Points liên quan đến ${snapshot.selectedTopic.label}',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              VitCtaButton(
                onPressed: () => context.go(snapshot.createArenaRoute),
                fullWidth: false,
                height: AppSpacing.buttonCompact,
                padding: AppSpacing.discoveryChipHorizontalPadding,
                child: const Text('Tạo room'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Padding(
            padding: AppSpacing.discoveryLeftIndentedCopyPadding,
            child: Text(
              'Chủ đề chỉ là bối cảnh. Room Arena không ảnh hưởng vị thế Prediction Markets.',
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ),
        ],
      ),
    );
  }
}

class _DisclosureCard extends StatelessWidget {
  const _DisclosureCard({required this.notes});

  final String notes;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: TopicHubPage.disclosureKey,
      variant: VitCardVariant.inner,
      padding: AppSpacing.discoveryCardPadding,
      child: Text(
        'Lưu ý: Prediction Markets sử dụng USDT thật (vị thế thực). Arena Challenges chỉ dùng Arena Points (không phải tài sản tài chính). Topic Hub là trang khám phá, 2 module hoàn toàn riêng biệt.\n$notes',
        textAlign: TextAlign.center,
        style: AppTextStyles.micro.copyWith(color: AppColors.text3),
      ),
    );
  }
}
