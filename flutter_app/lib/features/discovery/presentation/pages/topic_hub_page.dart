import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/features/discovery/data/discovery_repository.dart';

class TopicHubPage extends ConsumerStatefulWidget {
  const TopicHubPage({
    super.key,
    this.initialTopicId = 'crypto',
    this.useDetailEndpoint = false,
    this.shellRenderMode,
  });

  static const contentKey = Key('sc284_topic_hub_content');
  static const topicRailKey = Key('sc284_topic_hub_rail');
  static const offlineKey = Key('sc284_topic_hub_offline');
  static const heroKey = Key('sc284_topic_hub_hero');
  static const predictionsSectionKey = Key('sc284_topic_hub_predictions');
  static const roomsSectionKey = Key('sc284_topic_hub_rooms');
  static const modesSectionKey = Key('sc284_topic_hub_modes');
  static const creatorsSectionKey = Key('sc284_topic_hub_creators');
  static const createRoomKey = Key('sc284_topic_hub_create_room');
  static const disclosureKey = Key('sc284_topic_hub_disclosure');
  static const searchActionKey = Key('sc284_topic_hub_search_action');

  static Key topicKey(String id) => Key('sc284_topic_$id');
  static Key predictionKey(String id) => Key('sc284_prediction_$id');
  static Key roomKey(String id) => Key('sc284_room_$id');
  static Key modeKey(String id) => Key('sc284_mode_$id');
  static Key creatorKey(String id) => Key('sc284_creator_$id');

  final String initialTopicId;
  final bool useDetailEndpoint;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<TopicHubPage> createState() => _TopicHubPageState();
}

class _TopicHubPageState extends ConsumerState<TopicHubPage> {
  late String _selectedTopicId;

  @override
  void initState() {
    super.initState();
    _selectedTopicId = widget.initialTopicId;
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(discoveryRepositoryProvider)
        .getTopicHub(
          topicId: _selectedTopicId,
          detailEndpoint: widget.useDetailEndpoint,
        );
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x6
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-284 TopicHubPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: snapshot.title,
              showBack: true,
              onBack: () => context.go(AppRoutePaths.home),
              trailing: VitIconButton(
                key: TopicHubPage.searchActionKey,
                icon: Icons.search_rounded,
                tooltip: 'Tìm kiếm',
                variant: VitIconButtonVariant.defaultAction,
                onPressed: () => context.go(snapshot.searchRoute),
              ),
            ),
            _TopicRail(
              topics: snapshot.topics,
              selectedTopicId: snapshot.selectedTopic.id,
              onSelect: (topicId) {
                HapticFeedback.selectionClick();
                setState(() => _selectedTopicId = topicId);
              },
            ),
            Padding(
              key: TopicHubPage.offlineKey,
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.contentPad,
                AppSpacing.x4,
                AppSpacing.contentPad,
                AppSpacing.x2,
              ),
              child: VitOfflineBanner(
                message: snapshot.staleMessage,
                detail: snapshot.staleDetail,
              ),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  key: TopicHubPage.contentKey,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.contentPad,
                    AppSpacing.x2,
                    AppSpacing.contentPad,
                    bottomInset,
                  ),
                  child: _TopicContent(snapshot: snapshot),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopicRail extends StatelessWidget {
  const _TopicRail({
    required this.topics,
    required this.selectedTopicId,
    required this.onSelect,
  });

  final List<DiscoveryTopicDraft> topics;
  final String selectedTopicId;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: SingleChildScrollView(
        key: TopicHubPage.topicRailKey,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.contentPad,
          vertical: AppSpacing.x4,
        ),
        child: Row(
          children: [
            for (final topic in topics) ...[
              _TopicChip(
                topic: topic,
                active: topic.id == selectedTopicId,
                onTap: () => onSelect(topic.id),
              ),
              const SizedBox(width: AppSpacing.x3),
            ],
          ],
        ),
      ),
    );
  }
}

class _TopicChip extends StatelessWidget {
  const _TopicChip({
    required this.topic,
    required this.active,
    required this.onTap,
  });

  final DiscoveryTopicDraft topic;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final accent = _accentForTopic(topic);
    return InkWell(
      key: TopicHubPage.topicKey(topic.id),
      onTap: onTap,
      borderRadius: AppRadii.lgRadius,
      child: Container(
        height: AppSpacing.buttonCompact + AppSpacing.x2,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x4),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? accent.withValues(alpha: .14) : AppColors.surface2,
          border: Border.all(
            color: active ? accent.withValues(alpha: .44) : Colors.transparent,
            width: 1.5,
          ),
          borderRadius: AppRadii.lgRadius,
        ),
        child: Text(
          topic.label,
          style: AppTextStyles.caption.copyWith(
            color: active ? accent : AppColors.text2,
            fontWeight: active ? AppTextStyles.bold : AppTextStyles.medium,
          ),
        ),
      ),
    );
  }
}

class _TopicContent extends StatelessWidget {
  const _TopicContent({required this.snapshot});

  final TopicHubSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    if (!snapshot.hasContent) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _TopicHero(snapshot: snapshot),
          VitEmptyState(
            title: 'Chưa có nội dung cho ${snapshot.selectedTopic.label}',
            message: 'Hãy quay lại sau hoặc chọn chủ đề khác',
            icon: Icons.search_rounded,
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _TopicHero(snapshot: snapshot),
        const SizedBox(height: AppSpacing.x5),
        _PredictionSection(snapshot: snapshot),
        const SizedBox(height: AppSpacing.x5),
        _ArenaRoomsSection(snapshot: snapshot),
        const SizedBox(height: AppSpacing.x5),
        _ModesSection(snapshot: snapshot),
        const SizedBox(height: AppSpacing.x5),
        _CreatorsSection(snapshot: snapshot),
        const SizedBox(height: AppSpacing.x5),
        _CreateRoomCard(snapshot: snapshot),
        const SizedBox(height: AppSpacing.x5),
        _DisclosureCard(notes: snapshot.contractNotes),
      ],
    );
  }
}

class _TopicHero extends StatelessWidget {
  const _TopicHero({required this.snapshot});

  final TopicHubSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final topic = snapshot.selectedTopic;
    final accent = _accentForTopic(topic);
    return VitCard(
      key: TopicHubPage.heroKey,
      variant: VitCardVariant.inner,
      padding: const EdgeInsets.all(AppSpacing.x4),
      borderColor: accent.withValues(alpha: .22),
      child: Column(
        children: [
          Row(
            children: [
              _HeroIcon(topic: topic),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      topic.label,
                      style: AppTextStyles.pageTitle.copyWith(fontSize: 28),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      topic.summary,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              Expanded(
                child: _HeroStat(
                  value: snapshot.predictions.length,
                  label: 'Events',
                  color: AppModuleAccents.predictions,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _HeroStat(
                  value: snapshot.arenaRooms.length,
                  label: 'Rooms',
                  color: AppModuleAccents.arena,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _HeroStat(
                  value: snapshot.arenaModes.length,
                  label: 'Modes',
                  color: AppColors.buy,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _HeroStat(
                  value: snapshot.creators.length,
                  label: 'Creators',
                  color: AppModuleAccents.markets,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroIcon extends StatelessWidget {
  const _HeroIcon({required this.topic});

  final DiscoveryTopicDraft topic;

  @override
  Widget build(BuildContext context) {
    final accent = _accentForTopic(topic);
    return Container(
      width: AppSpacing.ctaHeight,
      height: AppSpacing.ctaHeight,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: accent.withValues(alpha: .14),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Icon(_iconForTopic(topic), color: accent, size: 23),
    );
  }
}

class _HeroStat extends StatelessWidget {
  const _HeroStat({
    required this.value,
    required this.label,
    required this.color,
  });

  final int value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.x3),
      decoration: const BoxDecoration(
        color: AppColors.surface2,
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        children: [
          Text(
            '$value',
            style: AppTextStyles.base.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            label,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }
}

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
              InkWell(
                onTap: onAction,
                borderRadius: AppRadii.smRadius,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.x2,
                    vertical: AppSpacing.x1,
                  ),
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

class _PredictionEventCard extends StatelessWidget {
  const _PredictionEventCard({required this.event});

  final DiscoveryPredictionEventDraft event;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: TopicHubPage.predictionKey(event.id),
      onTap: () => context.go(event.route),
      padding: const EdgeInsets.all(AppSpacing.x4),
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
          const SizedBox(height: AppSpacing.x2),
          Text(
            event.title,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontSize: 13,
              height: 1.32,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
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
      padding: const EdgeInsets.all(AppSpacing.x4),
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
          const SizedBox(height: AppSpacing.x3),
          Text(
            room.title,
            style: AppTextStyles.body.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
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
      padding: const EdgeInsets.all(AppSpacing.x4),
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
    return InkWell(
      key: TopicHubPage.creatorKey(creator.id),
      onTap: () => context.go(creator.route),
      borderRadius: AppRadii.lgRadius,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x4,
          vertical: AppSpacing.x3,
        ),
        decoration: BoxDecoration(
          color: AppColors.surface2,
          border: Border.all(color: AppColors.borderSolid),
          borderRadius: AppRadii.lgRadius,
        ),
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
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontSize: 9,
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

class _CreateRoomCard extends StatelessWidget {
  const _CreateRoomCard({required this.snapshot});

  final TopicHubSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: TopicHubPage.createRoomKey,
      padding: const EdgeInsets.all(AppSpacing.x4),
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
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x4),
                child: const Text('Tạo room'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Padding(
            padding: const EdgeInsets.only(left: AppSpacing.x7),
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
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Text(
        'Lưu ý: Prediction Markets sử dụng USDT thật (vị thế thực). Arena Challenges chỉ dùng Arena Points (không phải tài sản tài chính). Topic Hub là trang khám phá, 2 module hoàn toàn riêng biệt.\n$notes',
        textAlign: TextAlign.center,
        style: AppTextStyles.micro.copyWith(color: AppColors.text3),
      ),
    );
  }
}

class _TinySectionIcon extends StatelessWidget {
  const _TinySectionIcon({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSpacing.x6,
      height: AppSpacing.x6,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.withValues(alpha: .14),
        borderRadius: AppRadii.mdRadius,
      ),
      child: Icon(icon, color: color, size: 16),
    );
  }
}

class _SmallAccentIcon extends StatelessWidget {
  const _SmallAccentIcon({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSpacing.buttonCompact,
      height: AppSpacing.buttonCompact,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.withValues(alpha: .13),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Icon(icon, color: color, size: 18),
    );
  }
}

List<Widget> _withSectionGaps(List<Widget> children) {
  if (children.isEmpty) return const [];
  return [
    for (var i = 0; i < children.length; i++) ...[
      if (i > 0) const SizedBox(height: AppSpacing.x3),
      children[i],
    ],
  ];
}

class _ModuleBadge extends StatelessWidget {
  const _ModuleBadge({
    required this.label,
    required this.icon,
    required this.color,
  });

  final String label;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x1,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        border: Border.all(color: color.withValues(alpha: .24)),
        borderRadius: AppRadii.smRadius,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 10),
          const SizedBox(width: AppSpacing.x1),
          Text(
            label,
            style: AppTextStyles.micro.copyWith(
              color: color,
              fontSize: 9,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusMini extends StatelessWidget {
  const _StatusMini({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x2,
        vertical: AppSpacing.x1,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: AppRadii.xsRadius,
      ),
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontSize: 9,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

class _CountPill extends StatelessWidget {
  const _CountPill({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x2,
        vertical: AppSpacing.x1,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface2,
        borderRadius: AppRadii.smRadius,
      ),
      child: Text(
        '$count',
        style: AppTextStyles.micro.copyWith(
          color: AppColors.text3,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

class _InlineCta extends StatelessWidget {
  const _InlineCta({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(width: AppSpacing.x1),
        Icon(Icons.arrow_forward_rounded, color: color, size: 11),
      ],
    );
  }
}

class _CreatorAvatar extends StatelessWidget {
  const _CreatorAvatar({required this.initials});

  final String initials;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppModuleAccents.arena.withValues(alpha: .16),
        borderRadius: AppRadii.smRadius,
      ),
      child: Text(
        initials,
        style: AppTextStyles.micro.copyWith(
          color: AppModuleAccents.arena,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

Color _accentForTopic(DiscoveryTopicDraft topic) {
  return switch (topic.id) {
    'crypto' => AppModuleAccents.arena,
    'macro' => AppModuleAccents.predictions,
    'sports' => AppColors.buy,
    'tech' || 'ai' => AppModuleAccents.markets,
    _ => AppColors.text2,
  };
}

IconData _iconForTopic(DiscoveryTopicDraft topic) {
  return switch (topic.iconKey) {
    'fire' => Icons.local_fire_department_rounded,
    'bank' => Icons.account_balance_rounded,
    'arena' => Icons.bolt_rounded,
    'price' => Icons.swap_vert_rounded,
    'news' => Icons.article_rounded,
    _ => Icons.auto_awesome_rounded,
  };
}
