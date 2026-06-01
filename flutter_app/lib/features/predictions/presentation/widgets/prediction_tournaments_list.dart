part of '../pages/prediction_tournaments_page.dart';

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
