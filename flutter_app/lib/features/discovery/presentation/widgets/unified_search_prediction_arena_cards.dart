part of '../pages/unified_search_page.dart';

class _PredictionResultCard extends StatelessWidget {
  const _PredictionResultCard({required this.event});

  final DiscoveryPredictionEventDraft event;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: UnifiedSearchPage.resultKey('prediction', event.id),
      onTap: () => context.go(event.route),
      padding: AppSpacing.discoveryCardPadding,
      borderColor: AppModuleAccents.predictions.withValues(alpha: .18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _ModuleBadge(
            label: 'Prediction Market',
            icon: Icons.track_changes_rounded,
            color: AppModuleAccents.predictions,
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            event.title,
            style: AppTextStyles.body.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              Text(
                '${event.topOutcome} ${event.chance}%',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.buy,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(width: AppSpacing.x4),
              Text(
                'Vol ${event.volumeLabel}',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
              const Spacer(),
              _InlineCta(
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

class _ArenaModeResultCard extends StatelessWidget {
  const _ArenaModeResultCard({required this.mode});

  final DiscoveryArenaModeDraft mode;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: UnifiedSearchPage.resultKey('arenaMode', mode.id),
      onTap: () => context.go(mode.route),
      padding: AppSpacing.discoveryCardPadding,
      borderColor: AppModuleAccents.arena.withValues(alpha: .18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const _ModuleBadge(
                label: 'Open Arena',
                icon: Icons.bolt_rounded,
                color: AppModuleAccents.arena,
              ),
              if (mode.fairPlay) ...[
                const SizedBox(width: AppSpacing.x3),
                Text(
                  'Fair Play',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.buy,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            mode.title,
            style: AppTextStyles.body.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            mode.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              Expanded(
                child: Text(
                  '${mode.activeChallenges} challenges · ${mode.cloneCount} clones',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
              const _InlineCta(
                label: 'Xem mode',
                color: AppModuleAccents.arena,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
