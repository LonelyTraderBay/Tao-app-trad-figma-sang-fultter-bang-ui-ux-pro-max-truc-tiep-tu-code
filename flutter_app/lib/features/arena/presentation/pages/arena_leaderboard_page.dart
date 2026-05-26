import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
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

enum _LeaderboardTab { creators, players, teams }

class ArenaLeaderboardPage extends ConsumerStatefulWidget {
  const ArenaLeaderboardPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc194_leaderboard_content');
  static const creatorRowKey = Key('sc194_creator_row');
  static const risingCreatorKey = Key('sc194_rising_creator');
  static const rulesKey = Key('sc194_rules');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<ArenaLeaderboardPage> createState() =>
      _ArenaLeaderboardPageState();
}

class _ArenaLeaderboardPageState extends ConsumerState<ArenaLeaderboardPage> {
  _LeaderboardTab _activeTab = _LeaderboardTab.creators;
  String _activeMetric = 'fair_play';
  String _activeSeason = 'monthly';

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(arenaRepositoryProvider).getArenaLeaderboard();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x6
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-194 ArenaLeaderboardPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: 'Arena Leaderboard',
              subtitle: 'Bảng xếp hạng · Open Arena',
              showBack: true,
              onBack: _close,
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  key: ArenaLeaderboardPage.contentKey,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(bottom: bottomInset),
                  child: VitPageContent(
                    padding: VitContentPadding.compact,
                    customGap: AppSpacing.x5,
                    children: [
                      _MyRankCard(myRank: snapshot.myRank),
                      _MainTabs(
                        activeTab: _activeTab,
                        onChanged: (tab) {
                          HapticFeedback.selectionClick();
                          setState(() => _activeTab = tab);
                        },
                      ),
                      _MetricChips(
                        chips: snapshot.metricChips,
                        activeMetric: _activeMetric,
                        onChanged: (metric) {
                          HapticFeedback.selectionClick();
                          setState(() => _activeMetric = metric);
                        },
                      ),
                      _SeasonFilters(
                        filters: snapshot.seasonFilters,
                        activeSeason: _activeSeason,
                        onChanged: (season) {
                          HapticFeedback.selectionClick();
                          setState(() => _activeSeason = season);
                        },
                      ),
                      _LeaderboardBody(
                        activeTab: _activeTab,
                        snapshot: snapshot,
                        onCreator: (id) => _go(AppRoutePaths.arenaCreator(id)),
                      ),
                      _ArenaFooter(
                        disclaimer: snapshot.disclaimer,
                        onRules: () => _go(AppRoutePaths.arenaGuide),
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
    context.go(AppRoutePaths.arena);
  }
}

class _MyRankCard extends StatelessWidget {
  const _MyRankCard({required this.myRank});

  final ArenaLeaderboardMyRankDraft myRank;

  @override
  Widget build(BuildContext context) {
    return VitModuleHeroCard(
      accentColor: AppColors.accent,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: const BoxDecoration(
              color: AppColors.accent12,
              borderRadius: AppRadii.mdRadius,
            ),
            child: const Icon(
              Icons.emoji_events_outlined,
              color: AppColors.accent,
              size: 22,
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
      physics: const BouncingScrollPhysics(),
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
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.smRadius,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x3,
            vertical: AppSpacing.x2,
          ),
          decoration: BoxDecoration(
            color: active ? accentColor.withValues(alpha: .12) : AppColors.bg,
            border: Border.all(
              color: active
                  ? accentColor.withValues(alpha: .32)
                  : AppColors.borderSolid,
            ),
            borderRadius: AppRadii.smRadius,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: active ? accentColor : AppColors.text2,
                size: 13,
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: active ? accentColor : AppColors.text2,
                  fontWeight: AppTextStyles.medium,
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
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.smRadius,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x3,
            vertical: AppSpacing.x2,
          ),
          decoration: BoxDecoration(
            color: active ? AppColors.primary12 : Colors.transparent,
            borderRadius: AppRadii.smRadius,
          ),
          child: Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: active ? AppColors.primary : AppColors.text3,
              fontWeight: AppTextStyles.medium,
              height: 1,
            ),
          ),
        ),
      ),
    );
  }
}

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
        const SizedBox(height: AppSpacing.x4),
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
      padding: const EdgeInsets.only(top: AppSpacing.x2, bottom: AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(child: _PodiumItem(entry: second, size: 54)),
          Expanded(child: _PodiumItem(entry: first, size: 70, crown: true)),
          Expanded(child: _PodiumItem(entry: third, size: 54)),
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
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: AppColors.surface2,
            border: Border.all(color: color, width: 2),
            borderRadius: crown ? AppRadii.cardRadius : AppRadii.mdRadius,
            boxShadow: crown
                ? [
                    BoxShadow(
                      color: AppColors.warn.withValues(alpha: .24),
                      blurRadius: 18,
                      spreadRadius: -2,
                    ),
                  ]
                : null,
          ),
          child: Icon(_leaderboardIcon(entry.icon), color: color, size: 26),
        ),
        const SizedBox(height: AppSpacing.x2),
        Text(
          '#${entry.rank}',
          style: AppTextStyles.caption.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            height: 1,
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
            height: 1,
          ),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          entry.value,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.buy,
            fontWeight: AppTextStyles.bold,
            height: 1,
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
          padding: EdgeInsets.zero,
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
                  const Divider(height: 1, color: AppColors.divider),
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
        Container(
          width: 4,
          height: 16,
          decoration: BoxDecoration(
            color: accentColor,
            borderRadius: AppRadii.xsRadius,
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

class _LeaderboardRow extends StatelessWidget {
  const _LeaderboardRow({
    required this.entry,
    required this.rising,
    this.onTap,
  });

  final ArenaLeaderboardEntryDraft entry;
  final bool rising;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: rising
          ? ArenaLeaderboardPage.risingCreatorKey
          : ArenaLeaderboardPage.creatorRowKey,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x4,
          vertical: AppSpacing.x4,
        ),
        child: Row(
          children: [
            if (!rising) ...[
              SizedBox(
                width: 28,
                child: Text(
                  '${entry.rank}',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.text3,
                    fontWeight: AppTextStyles.bold,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
            ],
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: (rising ? AppColors.warn : AppColors.accent).withValues(
                  alpha: .14,
                ),
                borderRadius: AppRadii.mdRadius,
              ),
              child: Icon(
                _leaderboardIcon(entry.icon),
                color: rising ? AppColors.warn : AppColors.accent,
                size: 20,
              ),
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    entry.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.baseMedium.copyWith(
                      color: AppColors.text1,
                    ),
                  ),
                  if (entry.subtitle.isNotEmpty)
                    Row(
                      children: [
                        if (entry.fairPlay) ...[
                          const Icon(
                            Icons.shield_outlined,
                            color: AppColors.buy,
                            size: 10,
                          ),
                          const SizedBox(width: AppSpacing.x1),
                        ],
                        Flexible(
                          child: Text(
                            entry.subtitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.micro.copyWith(
                              color: entry.fairPlay
                                  ? AppColors.buy
                                  : AppColors.text3,
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.x3),
            if (rising)
              Row(
                children: [
                  const Icon(
                    Icons.local_fire_department_outlined,
                    color: AppColors.warn,
                    size: 13,
                  ),
                  const SizedBox(width: AppSpacing.x1),
                  Text(
                    entry.value,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.warn,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ],
              )
            else
              Text(
                entry.value,
                style: AppTextStyles.baseMedium.copyWith(
                  color: AppColors.buy,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _CompactLeaderboardState extends StatelessWidget {
  const _CompactLeaderboardState({required this.activeTab});

  final _LeaderboardTab activeTab;

  @override
  Widget build(BuildContext context) {
    final label = activeTab == _LeaderboardTab.players ? 'Players' : 'Teams';
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        children: [
          Icon(
            activeTab == _LeaderboardTab.players
                ? Icons.groups_rounded
                : Icons.diversity_3_rounded,
            color: AppColors.text3,
            size: 30,
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            label,
            style: AppTextStyles.baseMedium.copyWith(color: AppColors.text1),
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            'Bảng xếp hạng đang dùng cùng bộ lọc Fair Play và mùa.',
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _ArenaFooter extends StatelessWidget {
  const _ArenaFooter({required this.disclaimer, required this.onRules});

  final String disclaimer;
  final VoidCallback onRules;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          type: MaterialType.transparency,
          child: InkWell(
            key: ArenaLeaderboardPage.rulesKey,
            onTap: onRules,
            borderRadius: AppRadii.smRadius,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.x2,
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
                    'Quy tắc cộng đồng',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.primary,
                      fontWeight: AppTextStyles.medium,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.x3),
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
                  disclaimer,
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

Color _rankColor(int rank) {
  return switch (rank) {
    1 => AppColors.warn,
    2 => AppColors.text2,
    3 => AppColors.primaryDark,
    _ => AppColors.text3,
  };
}

IconData _leaderboardIcon(ArenaLeaderboardIconKind icon) {
  return switch (icon) {
    ArenaLeaderboardIconKind.trophy => Icons.emoji_events_outlined,
    ArenaLeaderboardIconKind.shield => Icons.shield_outlined,
    ArenaLeaderboardIconKind.trending => Icons.trending_up_rounded,
    ArenaLeaderboardIconKind.winRate => Icons.workspace_premium_outlined,
    ArenaLeaderboardIconKind.activity => Icons.bolt_rounded,
    ArenaLeaderboardIconKind.completion => Icons.verified_outlined,
    ArenaLeaderboardIconKind.target => Icons.gps_fixed_rounded,
    ArenaLeaderboardIconKind.game => Icons.videogame_asset_rounded,
    ArenaLeaderboardIconKind.magic => Icons.auto_fix_high_rounded,
    ArenaLeaderboardIconKind.crown => Icons.workspace_premium_rounded,
    ArenaLeaderboardIconKind.player => Icons.person_rounded,
    ArenaLeaderboardIconKind.team => Icons.groups_rounded,
  };
}
