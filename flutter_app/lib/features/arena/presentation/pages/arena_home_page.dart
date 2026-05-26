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
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/features/arena/data/arena_repository.dart';

const _arenaAccent = AppModuleAccents.arena;

class ArenaHomePage extends ConsumerStatefulWidget {
  const ArenaHomePage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc184_arena_home_content');
  static const createChallengeKey = Key('sc184_create_challenge');
  static const exploreModeKey = Key('sc184_explore_mode');
  static const searchKey = Key('sc184_search');
  static const quickGuideKey = Key('sc184_quick_guide');
  static const quickRewardsKey = Key('sc184_quick_rewards');
  static const quickLeaderboardKey = Key('sc184_quick_leaderboard');
  static const quickMyArenaKey = Key('sc184_quick_my_arena');
  static const verifiedTeaserKey = Key('sc184_verified_teaser');

  static Key templateKey(String id) => Key('sc184_template_$id');
  static Key modeKey(String id) => Key('sc184_mode_$id');
  static Key roomKey(String id) => Key('sc184_room_$id');
  static Key creatorKey(String id) => Key('sc184_creator_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<ArenaHomePage> createState() => _ArenaHomePageState();
}

class _ArenaHomePageState extends ConsumerState<ArenaHomePage> {
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey _templatesAnchorKey = GlobalKey();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(arenaRepositoryProvider).getArenaHome();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 78
            : DeviceMetrics.nativeBottomChrome + 24) +
        MediaQuery.paddingOf(context).bottom;

    final hasSearch = _query.trim().length >= 2;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-184 ArenaHomePage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: 'Open Arena',
              subtitle: 'Sân chơi cộng đồng',
              showBack: true,
              onBack: _close,
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  key: ArenaHomePage.contentKey,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(bottom: bottomInset),
                  child: VitPageContent(
                    padding: VitContentPadding.compact,
                    customGap: AppSpacing.x5,
                    children: [
                      _IntroBlock(
                        controller: _searchController,
                        query: _query,
                        pendingNotifications: snapshot.pendingNotifications,
                        onChanged: (value) => setState(() => _query = value),
                        onClear: () => setState(() => _query = ''),
                        onGuide: () => _go(AppRoutePaths.arenaGuide),
                        onRewards: () => _go('/rewards?tab=arena'),
                        onLeaderboard: () =>
                            _go(AppRoutePaths.arenaLeaderboard),
                        onMyArena: () => _go(AppRoutePaths.profileArena),
                      ),
                      if (hasSearch)
                        _SearchResults(
                          query: _query,
                          snapshot: snapshot,
                          onMode: (id) => _go(AppRoutePaths.arenaMode(id)),
                          onRoom: (id) => _go(AppRoutePaths.arenaChallenge(id)),
                          onCreator: (id) =>
                              _go(AppRoutePaths.arenaCreator(id)),
                        )
                      else ...[
                        _HeroCard(
                          onCreate: () => _go(AppRoutePaths.arenaStudio),
                          onExplore: _scrollToTemplates,
                        ),
                        _TemplateSection(
                          anchorKey: _templatesAnchorKey,
                          templates: snapshot.templates,
                          onTap: (_) => _go(AppRoutePaths.arenaStudio),
                        ),
                        _FeaturedModesSection(
                          modes: snapshot.featuredModes,
                          onViewAll: () => _go(AppRoutePaths.arenaLeaderboard),
                          onMode: (id) => _go(AppRoutePaths.arenaMode(id)),
                        ),
                        _LiveRoomsSection(
                          rooms: snapshot.liveRooms,
                          onRoom: (id) => _go(AppRoutePaths.arenaChallenge(id)),
                        ),
                        _CreatorSpotlightSection(
                          creators: snapshot.creators,
                          onCreator: (id) =>
                              _go(AppRoutePaths.arenaCreator(id)),
                        ),
                        _PredictionBridge(
                          onTap: () => _go(AppRoutePaths.marketsPredictions),
                        ),
                        _VerifiedTeaser(
                          onTap: () => _go(AppRoutePaths.arenaVerified),
                        ),
                      ],
                      _ArenaFooter(
                        onRules: () => _go(AppRoutePaths.arenaSafety),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _go(String route) {
    HapticFeedback.selectionClick();
    context.go(route);
  }

  void _close() {
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(AppRoutePaths.home);
  }

  void _scrollToTemplates() {
    final context = _templatesAnchorKey.currentContext;
    if (context == null) return;
    Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }
}

class _IntroBlock extends StatelessWidget {
  const _IntroBlock({
    required this.controller,
    required this.query,
    required this.pendingNotifications,
    required this.onChanged,
    required this.onClear,
    required this.onGuide,
    required this.onRewards,
    required this.onLeaderboard,
    required this.onMyArena,
  });

  final TextEditingController controller;
  final String query;
  final int pendingNotifications;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  final VoidCallback onGuide;
  final VoidCallback onRewards;
  final VoidCallback onLeaderboard;
  final VoidCallback onMyArena;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Tạo mode chơi, mở phòng và thách đấu bằng Arena Points',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.text2,
                  height: 1.35,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.x3),
            const VitStatusPill(
              label: 'Points only',
              status: VitStatusPillStatus.orange,
              size: VitStatusPillSize.sm,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x4),
        VitSearchBar(
          key: ArenaHomePage.searchKey,
          controller: controller,
          placeholder: 'Tìm mode, creator hoặc challenge...',
          variant: VitSearchBarVariant.compact,
          onChanged: onChanged,
          onClear: onClear,
        ),
        const SizedBox(height: AppSpacing.x4),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              _QuickChip(
                key: ArenaHomePage.quickGuideKey,
                icon: Icons.menu_book_outlined,
                label: 'Hướng dẫn',
                onTap: onGuide,
              ),
              _QuickChip(
                key: ArenaHomePage.quickRewardsKey,
                icon: Icons.card_giftcard_rounded,
                label: 'Kiếm Points',
                onTap: onRewards,
              ),
              _QuickChip(
                key: ArenaHomePage.quickLeaderboardKey,
                icon: Icons.emoji_events_outlined,
                label: 'Leaderboard',
                onTap: onLeaderboard,
              ),
              _QuickChip(
                key: ArenaHomePage.quickMyArenaKey,
                icon: Icons.star_border_rounded,
                label: 'Sân chơi của tôi',
                count: pendingNotifications,
                onTap: onMyArena,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _QuickChip extends StatelessWidget {
  const _QuickChip({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.count = 0,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.x3),
      child: Material(
        color: Colors.transparent,
        borderRadius: AppRadii.inputRadius,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadii.inputRadius,
          child: Container(
            height: 36,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x3),
            decoration: BoxDecoration(
              color: AppColors.surface2,
              border: Border.all(color: AppColors.cardBorder),
              borderRadius: AppRadii.inputRadius,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: AppColors.text2, size: 13),
                const SizedBox(width: AppSpacing.x2),
                Text(
                  label,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text2,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
                if (count > 0) ...[
                  const SizedBox(width: AppSpacing.x2),
                  _MiniCountBadge(count: count),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.onCreate, required this.onExplore});

  final VoidCallback onCreate;
  final VoidCallback onExplore;

  @override
  Widget build(BuildContext context) {
    return VitModuleHeroCard(
      accentColor: _arenaAccent,
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Open Arena',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text3,
              fontWeight: AppTextStyles.medium,
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            'Tạo sân chơi',
            style: AppTextStyles.heroNumber.copyWith(
              fontSize: 31,
              fontWeight: FontWeight.w900,
              height: 1.05,
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              const VitStatusPill(
                label: 'Tự đặt luật · Mời bạn bè',
                icon: Icons.auto_awesome_rounded,
                status: VitStatusPillStatus.purple,
                size: VitStatusPillSize.sm,
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Text(
                  'room riêng',
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
          const SizedBox(height: AppSpacing.x5),
          Row(
            children: [
              Expanded(
                child: VitCtaButton(
                  key: ArenaHomePage.createChallengeKey,
                  onPressed: onCreate,
                  leading: const Icon(Icons.auto_awesome_rounded),
                  child: const Text('Tạo challenge'),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: VitCtaButton(
                  key: ArenaHomePage.exploreModeKey,
                  onPressed: onExplore,
                  variant: VitCtaButtonVariant.secondary,
                  leading: const Icon(Icons.search_rounded),
                  child: const Text('Khám phá mode'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TemplateSection extends StatelessWidget {
  const _TemplateSection({
    required this.anchorKey,
    required this.templates,
    required this.onTap,
  });

  final Key anchorKey;
  final List<ArenaTemplateDraft> templates;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: anchorKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const VitModuleSectionHeader(
          title: 'Templates',
          accentColor: AppColors.accent,
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          'Chọn template để bắt đầu tạo challenge',
          style: AppTextStyles.caption.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x4),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: templates.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: AppSpacing.x3,
            mainAxisSpacing: AppSpacing.x3,
            mainAxisExtent: 134,
          ),
          itemBuilder: (context, index) {
            final template = templates[index];
            final accent = _templateColor(template.kind);
            return VitCard(
              key: ArenaHomePage.templateKey(template.id),
              onTap: () => onTap(template.id),
              padding: const EdgeInsets.all(AppSpacing.x4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _ActionIcon(
                        icon: _templateIcon(template.kind),
                        color: accent,
                      ),
                      const SizedBox(width: AppSpacing.x3),
                      Expanded(
                        child: Text(
                          template.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.body.copyWith(
                            fontWeight: AppTextStyles.bold,
                            height: 1.15,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.x4),
                  Text(
                    template.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      height: 1.3,
                    ),
                  ),
                  const Spacer(),
                  Wrap(
                    spacing: AppSpacing.x3,
                    runSpacing: AppSpacing.x1,
                    children: [
                      for (final tag in template.tags.take(2))
                        Text(
                          tag,
                          style: AppTextStyles.micro.copyWith(
                            color: accent,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

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
                  width: 220,
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
      padding: const EdgeInsets.all(AppSpacing.x4),
      constraints: const BoxConstraints(minHeight: 132),
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
                    height: 1.15,
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
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              for (var i = 0; i < rooms.length; i++) ...[
                _RoomRow(room: rooms[i], onTap: () => onRoom(rooms[i].id)),
                if (i < rooms.length - 1)
                  const Divider(height: 1, color: AppColors.divider),
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
        padding: const EdgeInsets.all(AppSpacing.x4),
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
                      minHeight: 6,
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
                  width: 140,
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
      padding: const EdgeInsets.all(AppSpacing.x4),
      constraints: const BoxConstraints(minHeight: 148),
      child: Column(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.surface2,
              border: Border.all(color: AppColors.cardBorder),
              borderRadius: AppRadii.cardRadius,
            ),
            child: const Icon(
              Icons.person_rounded,
              color: AppColors.warn,
              size: 22,
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
      padding: const EdgeInsets.all(AppSpacing.x4),
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
            size: 18,
          ),
        ],
      ),
    );
  }
}

class _VerifiedTeaser extends StatelessWidget {
  const _VerifiedTeaser({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: .72,
      child: VitCard(
        key: ArenaHomePage.verifiedTeaserKey,
        onTap: onTap,
        padding: const EdgeInsets.all(AppSpacing.x4),
        child: Row(
          children: [
            _ActionIcon(
              icon: Icons.lock_outline_rounded,
              color: AppColors.accent,
            ),
            const SizedBox(width: AppSpacing.x4),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Verified Challenges',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.body.copyWith(
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                      ),
                      const VitStatusPill(
                        label: 'Future',
                        status: VitStatusPillStatus.purple,
                        size: VitStatusPillSize.sm,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.x2),
                  Text(
                    'Sẽ mở trong tương lai cho challenge xác thực cao hơn',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ArenaFooter extends StatelessWidget {
  const _ArenaFooter({required this.onRules});

  final VoidCallback onRules;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton.icon(
          onPressed: onRules,
          icon: const Icon(Icons.menu_book_outlined, size: 16),
          label: const Text('Quy tắc cộng đồng'),
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
            textStyle: AppTextStyles.micro.copyWith(
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        VitCard(
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.shield_outlined,
                color: AppColors.accent,
                size: 17,
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Text(
                  'Arena Points chỉ dùng trong Open Arena, không phải tài sản tài chính. Không thỏa thuận giao dịch ngoài nền tảng.',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    height: 1.35,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SearchResults extends StatelessWidget {
  const _SearchResults({
    required this.query,
    required this.snapshot,
    required this.onMode,
    required this.onRoom,
    required this.onCreator,
  });

  final String query;
  final ArenaHomeSnapshot snapshot;
  final ValueChanged<String> onMode;
  final ValueChanged<String> onRoom;
  final ValueChanged<String> onCreator;

  @override
  Widget build(BuildContext context) {
    final normalized = query.trim().toLowerCase();
    final modes = snapshot.featuredModes
        .where(
          (item) =>
              item.title.toLowerCase().contains(normalized) ||
              item.creatorName.toLowerCase().contains(normalized) ||
              item.tags.any((tag) => tag.toLowerCase().contains(normalized)),
        )
        .toList();
    final rooms = snapshot.liveRooms
        .where(
          (item) =>
              item.title.toLowerCase().contains(normalized) ||
              item.format.toLowerCase().contains(normalized),
        )
        .toList();
    final creators = snapshot.creators
        .where((item) => item.name.toLowerCase().contains(normalized))
        .toList();
    final total = modes.length + rooms.length + creators.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          total == 0
              ? 'Không tìm thấy kết quả cho "$query"'
              : '$total kết quả cho "$query"',
          style: AppTextStyles.caption.copyWith(color: AppColors.text2),
        ),
        const SizedBox(height: AppSpacing.x4),
        if (modes.isNotEmpty) ...[
          VitModuleSectionHeader(
            title: 'Modes (${modes.length})',
            accentColor: AppColors.primary,
          ),
          const SizedBox(height: AppSpacing.x3),
          for (final mode in modes) ...[
            _SearchRow(
              icon: _templateIcon(_kindForMode(mode.templateId)),
              title: mode.title,
              subtitle: '${mode.creatorName} · ${mode.cloneCount} clone',
              color: AppColors.primary,
              onTap: () => onMode(mode.id),
            ),
            const SizedBox(height: AppSpacing.x3),
          ],
        ],
        if (rooms.isNotEmpty) ...[
          VitModuleSectionHeader(
            title: 'Phòng (${rooms.length})',
            accentColor: AppColors.warn,
          ),
          const SizedBox(height: AppSpacing.x3),
          for (final room in rooms) ...[
            _SearchRow(
              icon: Icons.groups_2_outlined,
              title: room.title,
              subtitle:
                  '${room.format} · ${room.slotsFilled}/${room.slotsTotal}',
              color: _challengeStateColor(room.state),
              onTap: () => onRoom(room.id),
            ),
            const SizedBox(height: AppSpacing.x3),
          ],
        ],
        if (creators.isNotEmpty) ...[
          VitModuleSectionHeader(
            title: 'Creators (${creators.length})',
            accentColor: AppColors.buy,
          ),
          const SizedBox(height: AppSpacing.x3),
          for (final creator in creators) ...[
            _SearchRow(
              icon: Icons.person_rounded,
              title: creator.name,
              subtitle:
                  '${creator.modesCreated} modes · ${creator.trustScore}% trust',
              color: AppColors.buy,
              onTap: () => onCreator(creator.id),
            ),
            const SizedBox(height: AppSpacing.x3),
          ],
        ],
        if (total == 0)
          const VitEmptyState(
            title: 'Không tìm thấy kết quả',
            message: 'Thử tìm với từ khóa khác hoặc xóa bộ lọc',
            icon: Icons.search_rounded,
          ),
      ],
    );
  }
}

class _SearchRow extends StatelessWidget {
  const _SearchRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        children: [
          _ActionIcon(icon: icon, color: color),
          const SizedBox(width: AppSpacing.x4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.text3,
            size: 18,
          ),
        ],
      ),
    );
  }
}

class _ActionIcon extends StatelessWidget {
  const _ActionIcon({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: AppRadii.mdRadius,
        border: Border.all(color: color.withValues(alpha: .18)),
      ),
      child: Icon(icon, color: color, size: 17),
    );
  }
}

class _MiniCountBadge extends StatelessWidget {
  const _MiniCountBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 16),
      height: 16,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x1),
      decoration: BoxDecoration(
        color: AppColors.sell,
        borderRadius: AppRadii.xsRadius,
      ),
      alignment: Alignment.center,
      child: Text(
        count > 99 ? '99+' : '$count',
        style: AppTextStyles.micro.copyWith(
          color: Colors.white,
          fontSize: 9,
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
    );
  }
}

class _MetaText extends StatelessWidget {
  const _MetaText(this.value);

  final String value;

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: AppTextStyles.micro.copyWith(color: AppColors.text3),
    );
  }
}

class _MetaDot extends StatelessWidget {
  const _MetaDot();

  @override
  Widget build(BuildContext context) {
    return Text(
      '·',
      style: AppTextStyles.micro.copyWith(color: AppColors.text3),
    );
  }
}

IconData _templateIcon(ArenaTemplateKind kind) {
  return switch (kind) {
    ArenaTemplateKind.prediction => Icons.track_changes_rounded,
    ArenaTemplateKind.closestGuess => Icons.pin_outlined,
    ArenaTemplateKind.teamBattle => Icons.sports_mma_rounded,
    ArenaTemplateKind.bracket => Icons.emoji_events_outlined,
    ArenaTemplateKind.vote => Icons.how_to_vote_outlined,
    ArenaTemplateKind.proof => Icons.verified_user_outlined,
  };
}

Color _templateColor(ArenaTemplateKind kind) {
  return switch (kind) {
    ArenaTemplateKind.prediction => AppColors.sell,
    ArenaTemplateKind.closestGuess => AppColors.primary,
    ArenaTemplateKind.teamBattle => AppColors.accent,
    ArenaTemplateKind.bracket => AppColors.warn,
    ArenaTemplateKind.vote => AppColors.buy,
    ArenaTemplateKind.proof => AppColors.text2,
  };
}

ArenaTemplateKind _kindForMode(String templateId) {
  return switch (templateId) {
    'team_battle' => ArenaTemplateKind.teamBattle,
    'community_vote' => ArenaTemplateKind.vote,
    _ => ArenaTemplateKind.closestGuess,
  };
}

String _challengeStateLabel(ArenaChallengeState state) {
  return switch (state) {
    ArenaChallengeState.open => 'Chờ tham gia',
    ArenaChallengeState.full => 'Đã đầy',
    ArenaChallengeState.live => 'Đang diễn ra',
    ArenaChallengeState.pendingResult => 'Chờ kết quả',
    ArenaChallengeState.resolved => 'Hoàn tất',
    ArenaChallengeState.canceled => 'Đã hủy',
  };
}

Color _challengeStateColor(ArenaChallengeState state) {
  return switch (state) {
    ArenaChallengeState.open => AppColors.primary,
    ArenaChallengeState.full => AppColors.warn,
    ArenaChallengeState.live => AppColors.warn,
    ArenaChallengeState.pendingResult => AppColors.accent,
    ArenaChallengeState.resolved => AppColors.buy,
    ArenaChallengeState.canceled => AppColors.sell,
  };
}
