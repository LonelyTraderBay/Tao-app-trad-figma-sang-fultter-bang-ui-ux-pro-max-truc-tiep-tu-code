import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radii.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/device_metrics.dart';
import '../../../shared/layout/shell_render_mode.dart';
import '../../../shared/layout/vit_header.dart';
import '../../../shared/layout/vit_page_content.dart';
import '../../../shared/layout/vit_page_layout.dart';
import '../../../shared/widgets/widgets.dart';
import '../data/predictions_repository.dart';

const _predictionPrimary = AppColors.primary;

enum _TournamentTab { active, mine, ended }

class PredictionTournamentsPage extends ConsumerStatefulWidget {
  const PredictionTournamentsPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc042_tournaments_content');
  static const activeTabKey = Key('sc042_tab_active');
  static const mineTabKey = Key('sc042_tab_mine');
  static const endedTabKey = Key('sc042_tab_ended');

  static Key tournamentKey(String id) => Key('sc042_tournament_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<PredictionTournamentsPage> createState() =>
      _PredictionTournamentsPageState();
}

class _PredictionTournamentsPageState
    extends ConsumerState<PredictionTournamentsPage> {
  _TournamentTab _activeTab = _TournamentTab.active;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(predictionsRepositoryProvider).getTournaments();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomChrome = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final bottomInset =
        bottomChrome +
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame ? 54 : 20);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-042 PredictionTournamentsPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: 'Tournaments',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.marketsPredictions),
            ),
            _TournamentTabBar(
              activeTab: _activeTab,
              onChanged: (tab) => setState(() => _activeTab = tab),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  key: PredictionTournamentsPage.contentKey,
                  padding: EdgeInsets.only(bottom: bottomInset),
                  child: VitPageContent(
                    padding: VitContentPadding.relaxed,
                    customGap: 16,
                    children: switch (_activeTab) {
                      _TournamentTab.active => [
                        for (final tournament
                            in snapshot.activeTournaments.where(
                              (item) => item.featured,
                            ))
                          _FeaturedTournamentBlock(tournament: tournament),
                        _TournamentSection(
                          label: 'Tat ca giai dau',
                          tournaments: snapshot.activeTournaments
                              .where((item) => !item.featured)
                              .toList(),
                        ),
                        _TournamentSection(
                          label: 'Sap dien ra',
                          tournaments: snapshot.upcomingTournaments,
                        ),
                        const _TournamentInfoCard(),
                      ],
                      _TournamentTab.mine => [
                        _MyTournamentStats(snapshot: snapshot),
                        _TournamentSection(
                          label: 'Giai dau dang tham gia',
                          tournaments: snapshot.myTournaments,
                          empty: const _EmptyTournamentsCard(),
                        ),
                      ],
                      _TournamentTab.ended => [
                        _TournamentSection(
                          label: 'Giai dau da ket thuc',
                          tournaments: snapshot.pastTournaments,
                          empty: const _NoPastTournamentsCard(),
                        ),
                        if (snapshot.pastTournaments.isNotEmpty)
                          _FinalLeaderboard(entries: snapshot.leaderboard),
                      ],
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TournamentTabBar extends StatelessWidget {
  const _TournamentTabBar({required this.activeTab, required this.onChanged});

  final _TournamentTab activeTab;
  final ValueChanged<_TournamentTab> onChanged;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      (
        key: PredictionTournamentsPage.activeTabKey,
        tab: _TournamentTab.active,
        label: 'Dang dien ra',
      ),
      (
        key: PredictionTournamentsPage.mineTabKey,
        tab: _TournamentTab.mine,
        label: 'Cua toi',
      ),
      (
        key: PredictionTournamentsPage.endedTabKey,
        tab: _TournamentTab.ended,
        label: 'Ket thuc',
      ),
    ];

    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: SizedBox(
        height: 54,
        child: Row(
          children: [
            for (final item in tabs)
              Expanded(
                child: InkWell(
                  key: item.key,
                  onTap: () => onChanged(item.tab),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(
                            item.label,
                            style: AppTextStyles.caption.copyWith(
                              color: activeTab == item.tab
                                  ? _predictionPrimary
                                  : AppColors.text3,
                              fontWeight: AppTextStyles.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 160),
                        height: 2,
                        width: activeTab == item.tab ? 116 : 0,
                        decoration: BoxDecoration(
                          color: _predictionPrimary,
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _FeaturedTournamentBlock extends StatelessWidget {
  const _FeaturedTournamentBlock({required this.tournament});

  final PredictionTournamentDraft tournament;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Icon(Icons.bolt_rounded, size: 16, color: AppColors.warn),
            const SizedBox(width: 7),
            Text(
              'Featured',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 9),
        _TournamentCard(tournament: tournament),
      ],
    );
  }
}

class _TournamentSection extends StatelessWidget {
  const _TournamentSection({
    required this.label,
    required this.tournaments,
    this.empty,
  });

  final String label;
  final List<PredictionTournamentDraft> tournaments;
  final Widget? empty;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: label,
      accentColor: _predictionPrimary,
      children: [
        if (tournaments.isEmpty)
          empty ?? const SizedBox.shrink()
        else
          for (final tournament in tournaments)
            _TournamentCard(tournament: tournament),
      ],
    );
  }
}

class _TournamentCard extends StatelessWidget {
  const _TournamentCard({required this.tournament});

  final PredictionTournamentDraft tournament;

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(tournament.status);
    final isFeatured = tournament.featured;

    return VitCard(
      key: PredictionTournamentsPage.tournamentKey(tournament.id),
      padding: EdgeInsets.zero,
      borderColor: isFeatured
          ? _predictionPrimary.withValues(alpha: .32)
          : AppColors.border,
      onTap: () =>
          context.go(AppRoutePaths.marketsPredictionTournament(tournament.id)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (isFeatured) ...[
                            const Icon(
                              Icons.star_rounded,
                              color: AppColors.warn,
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                          ],
                          Expanded(
                            child: Text(
                              tournament.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.body.copyWith(
                                fontWeight: AppTextStyles.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        tournament.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                _StatusPill(status: tournament.status, color: statusColor),
              ],
            ),
            if (tournament.isJoined && tournament.myRank != null) ...[
              const SizedBox(height: 14),
              Container(
                height: 35,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: AppColors.buy.withValues(alpha: .08),
                  borderRadius: AppRadii.cardRadius,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Your rank',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text2,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    Text(
                      '#${tournament.myRank} - ${tournament.myScore} pts',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.buy,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 14),
            _TournamentStatsGrid(tournament: tournament),
            const SizedBox(height: 13),
            const Divider(color: AppColors.border, height: 1),
            const SizedBox(height: 12),
            Row(
              children: [
                _CategoryChip(label: tournament.category),
                const Spacer(),
                Text(
                  tournament.isJoined ? 'Joined' : 'View Details',
                  style: AppTextStyles.micro.copyWith(
                    color: tournament.isJoined
                        ? AppColors.buy
                        : AppColors.text3,
                    fontWeight: AppTextStyles.bold,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.text3,
                  size: 16,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TournamentStatsGrid extends StatelessWidget {
  const _TournamentStatsGrid({required this.tournament});

  final PredictionTournamentDraft tournament;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 8,
      crossAxisSpacing: 16,
      childAspectRatio: 4.6,
      children: [
        _StatCell(
          icon: Icons.attach_money_rounded,
          label: 'Prize Pool',
          value: _formatMoney(tournament.prizePool),
          valueColor: AppColors.buy,
        ),
        _StatCell(
          icon: Icons.groups_2_outlined,
          label: 'Participants',
          value: '${tournament.participants}/${tournament.maxParticipants}',
        ),
        _StatCell(
          icon: Icons.schedule_rounded,
          label: 'Duration',
          value: tournament.timeLabel,
        ),
        _StatCell(
          icon: Icons.track_changes_rounded,
          label: 'Entry Fee',
          value: tournament.entryFee == 0 ? 'Free' : '\$${tournament.entryFee}',
        ),
      ],
    );
  }
}

class _StatCell extends StatelessWidget {
  const _StatCell({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: AppColors.text3, size: 12),
            const SizedBox(width: 7),
            Text(
              label,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                fontSize: 10,
                height: 1.2,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Center(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.baseMedium.copyWith(
              color: valueColor,
              fontWeight: AppTextStyles.bold,
              fontSize: 15,
              height: 1.2,
            ),
          ),
        ),
      ],
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.status, required this.color});

  final TournamentStatus status;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .14),
        borderRadius: AppRadii.smRadius,
      ),
      child: Text(
        _statusLabel(status),
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontWeight: AppTextStyles.bold,
          fontSize: 10,
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: AppRadii.smRadius,
      ),
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(color: AppColors.text2),
      ),
    );
  }
}

class _TournamentInfoCard extends StatelessWidget {
  const _TournamentInfoCard();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: _predictionPrimary.withValues(alpha: .18),
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: _predictionPrimary,
            size: 14,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Tournaments are skill-based competitions. Prizes distributed based on prediction accuracy. Read rules carefully before joining.',
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text2,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MyTournamentStats extends StatelessWidget {
  const _MyTournamentStats({required this.snapshot});

  final PredictionTournamentsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final bestRank = snapshot.myTournaments
        .map((item) => item.myRank ?? 999)
        .reduce((a, b) => a < b ? a : b);
    return VitCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tournament Stats',
            style: AppTextStyles.body.copyWith(fontWeight: AppTextStyles.bold),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _CenteredMetric(
                  label: 'Joined',
                  value: '${snapshot.myTournaments.length}',
                ),
              ),
              Expanded(
                child: _CenteredMetric(
                  label: 'Best Rank',
                  value: '#$bestRank',
                  color: AppColors.buy,
                ),
              ),
              const Expanded(
                child: _CenteredMetric(
                  label: 'Total Prizes',
                  value: '\$2,400',
                  color: AppColors.warn,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CenteredMetric extends StatelessWidget {
  const _CenteredMetric({
    required this.label,
    required this.value,
    this.color = AppColors.text1,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: 4),
        Text(value, style: AppTextStyles.sectionTitle.copyWith(color: color)),
      ],
    );
  }
}

class _EmptyTournamentsCard extends StatelessWidget {
  const _EmptyTournamentsCard();

  @override
  Widget build(BuildContext context) {
    return const _EmptyStateCard(
      icon: Icons.emoji_events_outlined,
      title: 'Chua tham gia giai dau nao',
      message: 'Xem tab "Dang dien ra" de tham gia',
    );
  }
}

class _NoPastTournamentsCard extends StatelessWidget {
  const _NoPastTournamentsCard();

  @override
  Widget build(BuildContext context) {
    return const _EmptyStateCard(
      icon: Icons.calendar_today_outlined,
      title: 'Chua co giai dau ket thuc',
    );
  }
}

class _EmptyStateCard extends StatelessWidget {
  const _EmptyStateCard({
    required this.icon,
    required this.title,
    this.message,
  });

  final IconData icon;
  final String title;
  final String? message;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 26),
      child: Column(
        children: [
          Icon(icon, color: AppColors.text3, size: 44),
          const SizedBox(height: 10),
          Text(
            title,
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
          if (message != null) ...[
            const SizedBox(height: 4),
            Text(
              message!,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ],
        ],
      ),
    );
  }
}

class _FinalLeaderboard extends StatelessWidget {
  const _FinalLeaderboard({required this.entries});

  final List<PredictionTournamentLeaderboardEntry> entries;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Final Leaderboard - Macro Economics Pro',
      accentColor: _predictionPrimary,
      children: [
        for (final entry in entries) _LeaderboardEntryCard(entry: entry),
      ],
    );
  }
}

class _LeaderboardEntryCard extends StatelessWidget {
  const _LeaderboardEntryCard({required this.entry});

  final PredictionTournamentLeaderboardEntry entry;

  @override
  Widget build(BuildContext context) {
    final ranked = entry.rank <= 3;
    return VitCard(
      variant: ranked ? VitCardVariant.inner : VitCardVariant.standard,
      borderColor: ranked
          ? AppColors.buy.withValues(alpha: .18)
          : AppColors.border,
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          SizedBox(
            width: 32,
            child: Icon(
              entry.rank == 1
                  ? Icons.emoji_events_rounded
                  : ranked
                  ? Icons.workspace_premium_rounded
                  : Icons.tag_rounded,
              color: _rankColor(entry.rank),
              size: entry.rank == 1 ? 21 : 18,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.name,
                  style: AppTextStyles.caption.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${entry.score} points',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          Text(
            _formatMoney(entry.prize),
            style: AppTextStyles.caption.copyWith(
              color: AppColors.buy,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

Color _statusColor(TournamentStatus status) {
  return switch (status) {
    TournamentStatus.active => AppColors.buy,
    TournamentStatus.upcoming => AppColors.warn,
    TournamentStatus.ended => AppColors.text3,
  };
}

String _statusLabel(TournamentStatus status) {
  return switch (status) {
    TournamentStatus.active => 'ACTIVE',
    TournamentStatus.upcoming => 'UPCOMING',
    TournamentStatus.ended => 'ENDED',
  };
}

Color _rankColor(int rank) {
  return switch (rank) {
    1 => AppColors.warn,
    2 => const Color(0xFF9CA3AF),
    3 => const Color(0xFFD97706),
    _ => AppColors.text2,
  };
}

String _formatMoney(int value) {
  final raw = value.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < raw.length; i += 1) {
    if (i > 0 && (raw.length - i) % 3 == 0) {
      buffer.write(',');
    }
    buffer.write(raw[i]);
  }
  return '\$${buffer.toString()}';
}
