part of '../pages/prediction_tournaments_page.dart';

class PredictionTournamentDetailPage extends ConsumerWidget {
  const PredictionTournamentDetailPage({
    super.key,
    required this.tournamentId,
    this.shellRenderMode,
  });

  static const contentKey = Key('sc042_tournament_detail_content');
  static const missingKey = Key('sc042_tournament_detail_missing');

  final String tournamentId;
  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref
        .watch(predictionsReadModelControllerProvider)
        .getTournaments();
    final tournament = _findTournament(snapshot.tournaments, tournamentId);
    final mode = shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome +
                  AppSpacing.predictionTournamentBottomInsetVisual
            : DeviceMetrics.nativeBottomChrome +
                  AppSpacing.predictionTournamentBottomInsetNative) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-042 PredictionTournamentDetailPage',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: tournament?.name ?? 'Tournament',
            showBack: true,
            onBack: () =>
                context.go(AppRoutePaths.marketsPredictionsTournaments),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  key: contentKey,
                  physics: const BouncingScrollPhysics(),
                  padding: AppSpacing.predictionTournamentScrollPadding(
                    bottomInset,
                  ),
                  child: VitPageContent(
                    padding: VitContentPadding.relaxed,
                    customGap: AppSpacing.predictionTournamentContentGap,
                    children: [
                      if (tournament == null)
                        const _EmptyStateCard(
                          key: missingKey,
                          icon: Icons.emoji_events_outlined,
                          title: 'Tournament not found',
                          message: 'Return to the tournament list to continue.',
                        )
                      else ...[
                        _TournamentDetailHero(tournament: tournament),
                        _TournamentStatsGrid(tournament: tournament),
                        const _TournamentInfoCard(),
                        if (tournament.isJoined)
                          _FinalLeaderboard(entries: snapshot.leaderboard),
                      ],
                    ],
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

PredictionTournamentDraft? _findTournament(
  List<PredictionTournamentDraft> tournaments,
  String tournamentId,
) {
  for (final tournament in tournaments) {
    if (tournament.id == tournamentId) return tournament;
  }
  return null;
}

class _TournamentDetailHero extends StatelessWidget {
  const _TournamentDetailHero({required this.tournament});

  final PredictionTournamentDraft tournament;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: AppSpacing.predictionTournamentCardPadding,
      borderColor: _predictionPrimary.withValues(alpha: .28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _StatusPill(
                status: tournament.status,
                color: _statusColor(tournament.status),
              ),
              const Spacer(),
              _CategoryChip(label: tournament.category),
            ],
          ),
          const SizedBox(height: AppSpacing.predictionTournamentDetailHeroGap),
          Text(
            tournament.name,
            style: AppTextStyles.sectionTitle.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(
            height: AppSpacing.predictionTournamentDetailDescriptionGap,
          ),
          Text(
            tournament.description,
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
          if (tournament.isJoined && tournament.myRank != null) ...[
            const SizedBox(
              height: AppSpacing.predictionTournamentDetailHeroGap,
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.buy.withValues(alpha: .08),
                borderRadius: AppRadii.cardRadius,
              ),
              child: Padding(
                padding: AppSpacing.predictionTournamentInfoPadding,
                child: Row(
                  children: [
                    Text(
                      'Your rank',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                      ),
                    ),
                    const Spacer(),
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
            ),
          ],
        ],
      ),
    );
  }
}
