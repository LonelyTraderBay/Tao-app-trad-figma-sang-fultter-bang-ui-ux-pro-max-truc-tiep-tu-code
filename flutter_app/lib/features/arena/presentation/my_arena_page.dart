import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_module_accents.dart';
import '../../../app/theme/app_radii.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/device_metrics.dart';
import '../../../shared/layout/shell_render_mode.dart';
import '../../../shared/layout/vit_header.dart';
import '../../../shared/layout/vit_page_content.dart';
import '../../../shared/layout/vit_page_layout.dart';
import '../../../shared/widgets/widgets.dart';
import '../data/arena_repository.dart';

const _arenaAccent = AppModuleAccents.arena;

enum _MyArenaTab { myRooms, joined, savedModes, drafts, history }

enum MyArenaContractScope { profile, arena }

class MyArenaPage extends ConsumerStatefulWidget {
  const MyArenaPage({
    super.key,
    this.shellRenderMode,
    this.contractScope = MyArenaContractScope.profile,
  });

  static const contentKey = Key('sc168_my_arena_content');
  static const createChallengeKey = Key('sc168_create_challenge');
  static const pointsDetailKey = Key('sc168_points_detail');
  static const leaderboardKey = Key('sc168_leaderboard');
  static const discoverKey = Key('sc168_discover');
  static const reportsKey = Key('sc168_reports');
  static const blockedKey = Key('sc168_blocked');
  static const safetyKey = Key('sc168_safety');
  static const tabsScrollKey = Key('sc168_tabs_scroll');

  static Key tabKey(String id) => Key('sc168_tab_$id');
  static Key challengeKey(String id) => Key('sc168_challenge_$id');
  static Key modeKey(String id) => Key('sc168_mode_$id');

  final ShellRenderMode? shellRenderMode;
  final MyArenaContractScope contractScope;

  @override
  ConsumerState<MyArenaPage> createState() => _MyArenaPageState();
}

class _MyArenaPageState extends ConsumerState<MyArenaPage> {
  _MyArenaTab _activeTab = _MyArenaTab.myRooms;

  @override
  Widget build(BuildContext context) {
    final repository = ref.watch(arenaRepositoryProvider);
    final snapshot = switch (widget.contractScope) {
      MyArenaContractScope.profile => repository.getMyArena(),
      MyArenaContractScope.arena => repository.getArenaMy(),
    };
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 78
            : DeviceMetrics.nativeBottomChrome + 24) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: widget.contractScope == MyArenaContractScope.arena
          ? 'SC-205 MyArenaPage'
          : 'SC-168 MyArenaPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: 'Sân chơi của tôi',
              subtitle: 'Quản lý · Open Arena',
              showBack: true,
              onBack: _close,
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  key: MyArenaPage.contentKey,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(bottom: bottomInset),
                  child: VitPageContent(
                    padding: VitContentPadding.relaxed,
                    customGap: AppSpacing.x5,
                    children: [
                      _PointsHero(
                        stats: snapshot.stats,
                        onDetails: () => _go(AppRoutePaths.arenaPoints),
                        onEarn: () => _go('/rewards'),
                      ),
                      _StatsGrid(stats: snapshot.stats),
                      VitCtaButton(
                        key: MyArenaPage.createChallengeKey,
                        onPressed: () => _go(AppRoutePaths.arenaStudio),
                        leading: const Icon(Icons.auto_awesome_rounded),
                        child: const Text('Tạo challenge mới'),
                      ),
                      _QuickLinks(
                        onLeaderboard: () =>
                            _go(AppRoutePaths.arenaLeaderboard),
                        onDiscover: () => _go(AppRoutePaths.arena),
                      ),
                      _ArenaTabs(
                        activeTab: _activeTab,
                        onChanged: (tab) => setState(() => _activeTab = tab),
                      ),
                      _TabContent(
                        tab: _activeTab,
                        snapshot: snapshot,
                        onChallenge: (id) =>
                            _go(AppRoutePaths.arenaChallenge(id)),
                        onMode: (id) => _go(AppRoutePaths.arenaMode(id)),
                        onStudio: () => _go(AppRoutePaths.arenaStudio),
                        onDiscover: () => _go(AppRoutePaths.arena),
                      ),
                      _CreatedModesSection(
                        snapshot: snapshot,
                        onTap: () => _go(AppRoutePaths.arenaStudio),
                      ),
                      _RewardAnalyticsSection(
                        history: snapshot.rewardHistory,
                        onViewChallenge: () =>
                            _go(AppRoutePaths.arenaChallenge('sample')),
                      ),
                      _SafetySection(
                        onReports: () => _go(AppRoutePaths.arenaMyReports),
                        onBlocked: () => _go(AppRoutePaths.arenaBlocked),
                        onSafety: () => _go(AppRoutePaths.arenaSafety),
                      ),
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
    context.go(
      widget.contractScope == MyArenaContractScope.arena
          ? AppRoutePaths.arena
          : AppRoutePaths.profile,
    );
  }
}

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
                const SizedBox(height: AppSpacing.x3),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      formatArenaPoints(stats.currentBalance),
                      style: AppTextStyles.heroNumber.copyWith(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        height: 1,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.x2),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Text(
                        'pts',
                        style: AppTextStyles.base.copyWith(
                          color: AppColors.text3,
                          fontWeight: AppTextStyles.medium,
                          height: 1,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.divider),
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
                  height: 36,
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
              width: 8,
              height: 8,
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
        const SizedBox(height: AppSpacing.x2),
        Text(
          value,
          style: AppTextStyles.base.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
            height: 1,
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
        const SizedBox(height: AppSpacing.x4),
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
      constraints: const BoxConstraints(minHeight: 116),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: item.color.withValues(alpha: .14),
                  borderRadius: AppRadii.mdRadius,
                ),
                child: Icon(item.icon, color: item.color, size: 17),
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
          const SizedBox(height: AppSpacing.x4),
          Text(
            item.value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.sectionTitle.copyWith(
              color: item.color,
              fontSize: 23,
              fontWeight: FontWeight.w900,
              fontFeatures: AppTextStyles.tabularFigures,
              height: 1,
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
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
      color: Colors.transparent,
      borderRadius: AppRadii.inputRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.inputRadius,
        child: Container(
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.surface2,
            border: Border.all(color: AppColors.cardBorder),
            borderRadius: AppRadii.inputRadius,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: AppColors.text2, size: 14),
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
      color: Colors.transparent,
      borderRadius: AppRadii.inputRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.inputRadius,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          height: 36,
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
              Icon(config.icon, color: color, size: 14),
              const SizedBox(width: AppSpacing.x2),
              Text(
                config.label,
                style: AppTextStyles.micro.copyWith(
                  color: color,
                  fontWeight: AppTextStyles.bold,
                  height: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TabContent extends StatelessWidget {
  const _TabContent({
    required this.tab,
    required this.snapshot,
    required this.onChallenge,
    required this.onMode,
    required this.onStudio,
    required this.onDiscover,
  });

  final _MyArenaTab tab;
  final MyArenaSnapshot snapshot;
  final ValueChanged<String> onChallenge;
  final ValueChanged<String> onMode;
  final VoidCallback onStudio;
  final VoidCallback onDiscover;

  @override
  Widget build(BuildContext context) {
    return switch (tab) {
      _MyArenaTab.myRooms => _ChallengeListCard(
        challenges: snapshot.myRooms,
        emptyTitle: 'Chưa có phòng đang mở',
        emptyActionLabel: 'Tạo challenge',
        onEmptyAction: onStudio,
        onChallenge: onChallenge,
      ),
      _MyArenaTab.joined => _ChallengeListCard(
        challenges: snapshot.joinedChallenges,
        emptyTitle: 'Chưa tham gia challenge',
        emptyActionLabel: 'Khám phá Arena',
        onEmptyAction: onDiscover,
        onChallenge: onChallenge,
      ),
      _MyArenaTab.savedModes => _SavedModesList(
        modes: snapshot.savedModes,
        onMode: onMode,
        onDiscover: onDiscover,
      ),
      _MyArenaTab.drafts => _DraftList(
        drafts: snapshot.drafts,
        onStudio: onStudio,
      ),
      _MyArenaTab.history => _ChallengeListCard(
        challenges: snapshot.history,
        emptyTitle: 'Chưa có lịch sử',
        emptyActionLabel: 'Khám phá Arena',
        onEmptyAction: onDiscover,
        onChallenge: onChallenge,
      ),
    };
  }
}

class _ChallengeListCard extends StatelessWidget {
  const _ChallengeListCard({
    required this.challenges,
    required this.emptyTitle,
    required this.emptyActionLabel,
    required this.onEmptyAction,
    required this.onChallenge,
  });

  final List<ArenaChallengeDraft> challenges;
  final String emptyTitle;
  final String emptyActionLabel;
  final VoidCallback onEmptyAction;
  final ValueChanged<String> onChallenge;

  @override
  Widget build(BuildContext context) {
    if (challenges.isEmpty) {
      return _EmptyCard(
        icon: Icons.auto_awesome_rounded,
        title: emptyTitle,
        actionLabel: emptyActionLabel,
        onAction: onEmptyAction,
      );
    }

    return VitCard(
      clip: true,
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          for (var i = 0; i < challenges.length; i++)
            _ChallengeRow(
              challenge: challenges[i],
              showDivider: i < challenges.length - 1,
              onTap: () => onChallenge(challenges[i].id),
            ),
        ],
      ),
    );
  }
}

class _ChallengeRow extends StatelessWidget {
  const _ChallengeRow({
    required this.challenge,
    required this.showDivider,
    required this.onTap,
  });

  final ArenaChallengeDraft challenge;
  final bool showDivider;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final statusColor = _stateColor(challenge.state);
    return Material(
      key: MyArenaPage.challengeKey(challenge.id),
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x4,
            vertical: 13,
          ),
          decoration: BoxDecoration(
            border: showDivider
                ? const Border(bottom: BorderSide(color: AppColors.divider))
                : null,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      challenge.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.body.copyWith(
                        fontWeight: AppTextStyles.bold,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x2),
                    Wrap(
                      spacing: AppSpacing.x2,
                      runSpacing: AppSpacing.x1,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        _MetaText(challenge.format),
                        const _MetaDot(),
                        _MetaText(
                          '${challenge.slotsFilled}/${challenge.slotsTotal}',
                        ),
                        const _MetaDot(),
                        Text(
                          '${formatArenaPoints(challenge.entryPoints)} pts',
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.warn,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _ArenaStatusPill(
                    label: _stateLabel(challenge.state),
                    color: statusColor,
                  ),
                  const SizedBox(height: AppSpacing.x2),
                  Text(
                    'Xem',
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text2,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SavedModesList extends StatelessWidget {
  const _SavedModesList({
    required this.modes,
    required this.onMode,
    required this.onDiscover,
  });

  final List<ArenaModeDraft> modes;
  final ValueChanged<String> onMode;
  final VoidCallback onDiscover;

  @override
  Widget build(BuildContext context) {
    if (modes.isEmpty) {
      return _EmptyCard(
        icon: Icons.bookmark_border_rounded,
        title: 'Chưa lưu mode nào',
        actionLabel: 'Khám phá mode',
        onAction: onDiscover,
      );
    }

    return VitCard(
      clip: true,
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          for (var i = 0; i < modes.length; i++)
            Material(
              key: MyArenaPage.modeKey(modes[i].id),
              type: MaterialType.transparency,
              child: InkWell(
                onTap: () => onMode(modes[i].id),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.x4,
                    vertical: 13,
                  ),
                  decoration: BoxDecoration(
                    border: i < modes.length - 1
                        ? const Border(
                            bottom: BorderSide(color: AppColors.divider),
                          )
                        : null,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              modes[i].title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.body.copyWith(
                                fontWeight: AppTextStyles.bold,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.x2),
                            Wrap(
                              spacing: AppSpacing.x2,
                              runSpacing: AppSpacing.x1,
                              children: [
                                _MetaText(modes[i].creatorName),
                                const _MetaDot(),
                                _MetaText('${modes[i].cloneCount} clone'),
                                const _MetaDot(),
                                _MetaText(
                                  '${modes[i].activeChallenges} active',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.x3),
                      if (modes[i].fairPlay)
                        const _ArenaStatusPill(
                          label: 'Fair play',
                          color: AppColors.buy,
                        ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _DraftList extends StatelessWidget {
  const _DraftList({required this.drafts, required this.onStudio});

  final List<ArenaDraftChallenge> drafts;
  final VoidCallback onStudio;

  @override
  Widget build(BuildContext context) {
    if (drafts.isEmpty) {
      return _EmptyCard(
        icon: Icons.edit_note_rounded,
        title: 'Không có bản nháp',
        actionLabel: 'Tạo mới',
        onAction: onStudio,
      );
    }

    return VitCard(
      clip: true,
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          for (var i = 0; i < drafts.length; i++)
            Material(
              type: MaterialType.transparency,
              child: InkWell(
                onTap: onStudio,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.x4,
                    vertical: 13,
                  ),
                  decoration: BoxDecoration(
                    border: i < drafts.length - 1
                        ? const Border(
                            bottom: BorderSide(color: AppColors.divider),
                          )
                        : null,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: AppColors.surface2,
                          borderRadius: AppRadii.mdRadius,
                        ),
                        child: const Icon(
                          Icons.edit_note_rounded,
                          color: AppColors.text2,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.x3),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              drafts[i].title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.body.copyWith(
                                fontWeight: AppTextStyles.bold,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.x2),
                            Row(
                              children: [
                                _MetaText(drafts[i].format),
                                const _MetaDot(),
                                _MetaText(drafts[i].updatedAt),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.x3),
                      Text(
                        '${formatArenaPoints(drafts[i].entryPoints)} pts',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.warn,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _CreatedModesSection extends StatelessWidget {
  const _CreatedModesSection({required this.snapshot, required this.onTap});

  final MyArenaSnapshot snapshot;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitModuleSectionHeader(
          title: 'Mode đã tạo (${snapshot.stats.modesCreated})',
          accentColor: AppColors.accent,
        ),
        const SizedBox(height: AppSpacing.x3),
        VitCard(
          onTap: onTap,
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Row(
            children: [
              _ActionIcon(
                icon: Icons.bar_chart_rounded,
                color: AppColors.accent,
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${snapshot.stats.modesCreated} mode đã tạo',
                      style: AppTextStyles.body.copyWith(
                        fontWeight: AppTextStyles.bold,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x2),
                    Text(
                      'Quản lý modes và xem thống kê',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.text3,
                size: 20,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RewardAnalyticsSection extends StatelessWidget {
  const _RewardAnalyticsSection({
    required this.history,
    required this.onViewChallenge,
  });

  final ArenaRewardHistory history;
  final VoidCallback onViewChallenge;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const VitModuleSectionHeader(
          title: 'Phân tích phần thưởng',
          accentColor: AppColors.warn,
        ),
        const SizedBox(height: AppSpacing.x3),
        VitCard(
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.query_stats_rounded,
                    color: AppColors.warn,
                    size: 18,
                  ),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: Text(
                      'Phân tích phần thưởng',
                      style: AppTextStyles.body.copyWith(
                        fontWeight: AppTextStyles.bold,
                        height: 1.2,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.x4),
              Row(
                children: [
                  Expanded(
                    child: _RewardMetric(
                      value: '${history.totalReceipts}',
                      label: 'Tổng lần nhận',
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: _RewardMetric(
                      value: '+${history.averageReceiveRate}%',
                      label: 'Tỉ lệ nhận TB',
                      color: AppColors.buy,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: _RewardMetric(
                      value: formatArenaPoints(history.largestReceipt),
                      label: 'Lớn nhất',
                      color: AppColors.warn,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.x5),
              Text(
                'TỈ LỆ THẮNG THEO LOẠI CHIA THƯỞNG',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.x3),
              for (var i = 0; i < history.distribution.length; i++) ...[
                _DistributionRow(
                  item: history.distribution[i],
                  color: _distributionColor(i),
                ),
                if (i < history.distribution.length - 1)
                  const SizedBox(height: AppSpacing.x3),
              ],
              const SizedBox(height: AppSpacing.x5),
              InkWell(
                onTap: onViewChallenge,
                borderRadius: AppRadii.smRadius,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.x2),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Lịch sử nhận thưởng gần đây',
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text2,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: AppColors.text3,
                        size: 18,
                      ),
                    ],
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

class _RewardMetric extends StatelessWidget {
  const _RewardMetric({
    required this.value,
    required this.label,
    required this.color,
  });

  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x4,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        children: [
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.base.copyWith(
              color: color,
              fontWeight: FontWeight.w900,
              fontFeatures: AppTextStyles.tabularFigures,
              height: 1,
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _DistributionRow extends StatelessWidget {
  const _DistributionRow({required this.item, required this.color});

  final ArenaRewardDistribution item;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final ratio = item.total == 0 ? 0.0 : item.wins / item.total;
    return Row(
      children: [
        SizedBox(
          width: 112,
          child: Text(
            item.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.bold,
              height: 1,
            ),
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: AppRadii.xsRadius,
            child: LinearProgressIndicator(
              minHeight: 10,
              value: ratio,
              backgroundColor: AppColors.surface3,
              color: color,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        SizedBox(
          width: 30,
          child: Text(
            '${item.wins}/${item.total}',
            textAlign: TextAlign.right,
            style: AppTextStyles.micro.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
              height: 1,
            ),
          ),
        ),
      ],
    );
  }
}

class _SafetySection extends StatelessWidget {
  const _SafetySection({
    required this.onReports,
    required this.onBlocked,
    required this.onSafety,
  });

  final VoidCallback onReports;
  final VoidCallback onBlocked;
  final VoidCallback onSafety;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const VitModuleSectionHeader(
          title: 'An toàn & quản lý',
          accentColor: AppColors.buy,
        ),
        const SizedBox(height: AppSpacing.x3),
        _SafetyActionCard(
          key: MyArenaPage.reportsKey,
          icon: Icons.outlined_flag_rounded,
          title: 'Báo cáo của tôi',
          subtitle: 'Theo dõi tiến trình xử lý báo cáo',
          color: AppColors.sell,
          onTap: onReports,
        ),
        const SizedBox(height: AppSpacing.x3),
        _SafetyActionCard(
          key: MyArenaPage.blockedKey,
          icon: Icons.block_rounded,
          title: 'Người dùng đã chặn',
          subtitle: 'Quản lý danh sách chặn',
          color: AppColors.warn,
          onTap: onBlocked,
        ),
        const SizedBox(height: AppSpacing.x3),
        _SafetyActionCard(
          key: MyArenaPage.safetyKey,
          icon: Icons.shield_outlined,
          title: 'An toàn & quy tắc',
          subtitle: 'Quy tắc cộng đồng, cách báo cáo',
          color: AppColors.buy,
          onTap: onSafety,
        ),
      ],
    );
  }
}

class _SafetyActionCard extends StatelessWidget {
  const _SafetyActionCard({
    super.key,
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
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.text3,
            size: 20,
          ),
        ],
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
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onRules,
            borderRadius: AppRadii.smRadius,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.x3,
                vertical: AppSpacing.x2,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.menu_book_outlined,
                    color: AppColors.primary,
                    size: 16,
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Text(
                    'Quy t\u1EAFc c\u1ED9ng \u0111\u1ED3ng',
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.primary,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ],
              ),
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

class _EmptyCard extends StatelessWidget {
  const _EmptyCard({
    required this.icon,
    required this.title,
    required this.actionLabel,
    required this.onAction,
  });

  final IconData icon;
  final String title;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        children: [
          Icon(icon, color: _arenaAccent, size: 26),
          const SizedBox(height: AppSpacing.x3),
          Text(
            title,
            style: AppTextStyles.body.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          _AccentPillButton(
            icon: Icons.add_rounded,
            label: actionLabel,
            color: _arenaAccent,
            onTap: onAction,
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
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: AppRadii.mdRadius,
      ),
      child: Icon(icon, color: color, size: 18),
    );
  }
}

class _ArenaStatusPill extends StatelessWidget {
  const _ArenaStatusPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x2,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .14),
        border: Border.all(color: color.withValues(alpha: .22)),
        borderRadius: AppRadii.smRadius,
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
    );
  }
}

class _AccentPillButton extends StatelessWidget {
  const _AccentPillButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: AppRadii.inputRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.inputRadius,
        child: Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x4),
          decoration: BoxDecoration(
            color: color.withValues(alpha: .12),
            border: Border.all(color: color.withValues(alpha: .22)),
            borderRadius: AppRadii.inputRadius,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 15),
              const SizedBox(width: AppSpacing.x2),
              Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: color,
                  fontWeight: AppTextStyles.bold,
                  height: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TextIconButton extends StatelessWidget {
  const _TextIconButton({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.smRadius,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x2,
          vertical: AppSpacing.x2,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 14),
            const SizedBox(width: AppSpacing.x1),
            Text(
              label,
              style: AppTextStyles.micro.copyWith(
                color: color,
                fontWeight: AppTextStyles.medium,
              ),
            ),
          ],
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

String _stateLabel(ArenaChallengeState state) {
  return switch (state) {
    ArenaChallengeState.open => 'Đang mở',
    ArenaChallengeState.full => 'Đã đầy',
    ArenaChallengeState.live => 'Đang diễn ra',
    ArenaChallengeState.pendingResult => 'Chờ kết quả',
    ArenaChallengeState.resolved => 'Hoàn tất',
    ArenaChallengeState.canceled => 'Đã hủy',
  };
}

Color _stateColor(ArenaChallengeState state) {
  return switch (state) {
    ArenaChallengeState.open => AppColors.primary,
    ArenaChallengeState.full => AppColors.warn,
    ArenaChallengeState.live => AppColors.buy,
    ArenaChallengeState.pendingResult => AppColors.accent,
    ArenaChallengeState.resolved => AppColors.buy,
    ArenaChallengeState.canceled => AppColors.sell,
  };
}

Color _distributionColor(int index) {
  return switch (index % 5) {
    0 => AppColors.warn,
    1 => AppColors.sell,
    2 => AppColors.buy,
    3 => AppColors.primary,
    _ => AppColors.accent,
  };
}
