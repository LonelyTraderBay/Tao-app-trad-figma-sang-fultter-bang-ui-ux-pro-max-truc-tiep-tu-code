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
        height: AppSpacing.predictionTournamentTabsHeight,
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
                            ),
                          ),
                        ),
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 160),
                        height:
                            AppSpacing.predictionTournamentTabIndicatorHeight,
                        width: activeTab == item.tab
                            ? AppSpacing.predictionTournamentTabIndicatorWidth
                            : 0,
                        decoration: BoxDecoration(
                          color: _predictionPrimary,
                          borderRadius: AppRadii.hairlineRadius,
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
            const Icon(
              Icons.bolt_rounded,
              size: AppSpacing.predictionTournamentFeaturedIcon,
              color: AppColors.warn,
            ),
            const SizedBox(
              width: AppSpacing.predictionTournamentFeaturedIconGap,
            ),
            Text(
              'Featured',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.predictionTournamentFeaturedCardGap),
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
        padding: AppSpacing.predictionTournamentCardPadding,
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
                              size: AppSpacing.predictionTournamentTitleIcon,
                            ),
                            const SizedBox(
                              width:
                                  AppSpacing.predictionTournamentTitleIconGap,
                            ),
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
                      const SizedBox(
                        height: AppSpacing.predictionTournamentDescriptionGap,
                      ),
                      Text(
                        tournament.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.numericMicro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.predictionTournamentStatusGap),
                _StatusPill(status: tournament.status, color: statusColor),
              ],
            ),
            if (tournament.isJoined && tournament.myRank != null) ...[
              const SizedBox(height: AppSpacing.predictionTournamentRankGap),
              Container(
                height: AppSpacing.predictionTournamentRankHeight,
                padding: AppSpacing.predictionTournamentRankPadding,
                decoration: BoxDecoration(
                  color: AppColors.buy.withValues(alpha: .08),
                  borderRadius: AppRadii.cardRadius,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Your rank',
                        style: AppTextStyles.numericMicro.copyWith(
                          color: AppColors.text2,
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
            const SizedBox(height: AppSpacing.predictionTournamentStatsGap),
            _TournamentStatsGrid(tournament: tournament),
            const SizedBox(
              height: AppSpacing.predictionTournamentDividerTopGap,
            ),
            const Divider(
              color: AppColors.border,
              height: AppSpacing.predictionTournamentDividerHeight,
            ),
            const SizedBox(
              height: AppSpacing.predictionTournamentDividerBottomGap,
            ),
            Row(
              children: [
                _CategoryChip(label: tournament.category),
                const Spacer(),
                Text(
                  tournament.isJoined ? 'Joined' : 'View Details',
                  style: AppTextStyles.numericMicro.copyWith(
                    color: tournament.isJoined
                        ? AppColors.buy
                        : AppColors.text3,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(
                  width: AppSpacing.predictionTournamentChevronGap,
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.text3,
                  size: AppSpacing.predictionTournamentChevron,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
