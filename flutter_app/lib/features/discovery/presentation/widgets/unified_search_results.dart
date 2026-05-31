part of '../pages/unified_search_page.dart';

class _ResultsState extends StatelessWidget {
  const _ResultsState({required this.snapshot});

  final UnifiedSearchSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final results = snapshot.results;
    if (results.isEmpty) {
      return VitEmptyState(
        key: UnifiedSearchPage.emptyKey,
        icon: Icons.search_rounded,
        title: 'Không tìm thấy kết quả',
        message:
            'Không có kết quả cho "${snapshot.query}". Thử từ khóa khác hoặc xem gợi ý.',
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text.rich(
          TextSpan(
            text: 'Tìm thấy ',
            children: [
              TextSpan(
                text: '${results.totalCount}',
                style: const TextStyle(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              TextSpan(text: ' kết quả cho "${snapshot.query}"'),
            ],
          ),
          style: AppTextStyles.caption.copyWith(color: AppColors.text2),
        ),
        const SizedBox(height: AppSpacing.x4),
        if (results.predictions.isNotEmpty) ...[
          _ResultSection(
            icon: Icons.track_changes_rounded,
            label: 'Prediction Events',
            count: results.predictions.length,
            color: AppModuleAccents.predictions,
            children: [
              for (final event in results.predictions)
                _PredictionResultCard(event: event),
            ],
          ),
          const SizedBox(height: AppSpacing.x5),
        ],
        if (results.arenaModes.isNotEmpty) ...[
          _ResultSection(
            icon: Icons.bolt_rounded,
            label: 'Arena Modes',
            count: results.arenaModes.length,
            color: AppModuleAccents.arena,
            children: [
              for (final mode in results.arenaModes)
                _ArenaModeResultCard(mode: mode),
            ],
          ),
          const SizedBox(height: AppSpacing.x5),
        ],
        if (results.arenaRooms.isNotEmpty) ...[
          _ResultSection(
            icon: Icons.groups_rounded,
            label: 'Arena Rooms',
            count: results.arenaRooms.length,
            color: AppModuleAccents.arena,
            children: [
              for (final room in results.arenaRooms)
                _ArenaRoomResultCard(room: room),
            ],
          ),
          const SizedBox(height: AppSpacing.x5),
        ],
        if (results.creators.isNotEmpty) ...[
          _ResultSection(
            icon: Icons.person_rounded,
            label: 'Creators',
            count: results.creators.length,
            color: AppColors.buy,
            children: [
              for (final creator in results.creators)
                _CreatorResultCard(creator: creator),
            ],
          ),
          const SizedBox(height: AppSpacing.x5),
        ],
        if (results.tradingPairs.isNotEmpty) ...[
          _ResultSection(
            icon: Icons.bar_chart_rounded,
            label: 'Trading Pairs',
            count: results.tradingPairs.length,
            color: AppModuleAccents.markets,
            children: [
              for (final pair in results.tradingPairs)
                _TradingPairResultCard(pair: pair),
            ],
          ),
          const SizedBox(height: AppSpacing.x5),
        ],
        _BoundaryDisclosure(notes: snapshot.contractNotes),
      ],
    );
  }
}

class _ResultSection extends StatelessWidget {
  const _ResultSection({
    required this.icon,
    required this.label,
    required this.count,
    required this.color,
    required this.children,
  });

  final IconData icon;
  final String label;
  final int count;
  final Color color;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Container(
              width: AppSpacing.buttonCompact,
              height: AppSpacing.buttonCompact,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: color.withValues(alpha: .12),
                borderRadius: AppRadii.mdRadius,
              ),
              child: Icon(icon, color: color, size: 16),
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.base.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
            _CountBadge(count: count),
          ],
        ),
        const SizedBox(height: AppSpacing.x3),
        ...children.expand(
          (child) => [child, const SizedBox(height: AppSpacing.x3)],
        ),
      ],
    );
  }
}

class _PredictionResultCard extends StatelessWidget {
  const _PredictionResultCard({required this.event});

  final DiscoveryPredictionEventDraft event;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: UnifiedSearchPage.resultKey('prediction', event.id),
      onTap: () => context.go(event.route),
      padding: const EdgeInsets.all(AppSpacing.x4),
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
      padding: const EdgeInsets.all(AppSpacing.x4),
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

class _ArenaRoomResultCard extends StatelessWidget {
  const _ArenaRoomResultCard({required this.room});

  final DiscoveryArenaRoomDraft room;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: UnifiedSearchPage.resultKey('arenaRoom', room.id),
      onTap: () => context.go(room.route),
      padding: const EdgeInsets.all(AppSpacing.x4),
      borderColor: AppModuleAccents.arena.withValues(alpha: .18),
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
              Text(
                room.format,
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
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
                '${room.entryPoints} pts entry',
                style: AppTextStyles.caption.copyWith(
                  color: AppModuleAccents.arena,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(width: AppSpacing.x4),
              Text(
                '${room.slotsFilled}/${room.slotsTotal} slots (${room.fillPercent}%)',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              Text(
                room.creatorName,
                style: AppTextStyles.micro.copyWith(color: AppColors.text2),
              ),
              const Spacer(),
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

class _CreatorResultCard extends StatelessWidget {
  const _CreatorResultCard({required this.creator});

  final DiscoveryCreatorDraft creator;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: UnifiedSearchPage.resultKey('creator', creator.id),
      onTap: () => context.go(creator.route),
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        children: [
          _InitialsAvatar(initials: creator.initials),
          const SizedBox(width: AppSpacing.x4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        creator.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                    if (creator.fairPlayBadge) ...[
                      const SizedBox(width: AppSpacing.x2),
                      const Icon(
                        Icons.shield_rounded,
                        color: AppColors.buy,
                        size: 13,
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  'Trust ${creator.trustScore}% · ${creator.modesCreated} modes',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          const _InlineCta(label: 'Xem creator', color: AppColors.text2),
        ],
      ),
    );
  }
}

class _TradingPairResultCard extends StatelessWidget {
  const _TradingPairResultCard({required this.pair});

  final DiscoveryTradingPairDraft pair;

  @override
  Widget build(BuildContext context) {
    final changeColor = pair.change24h >= 0 ? AppColors.buy : AppColors.sell;
    final sign = pair.change24h >= 0 ? '+' : '';

    return VitCard(
      key: UnifiedSearchPage.resultKey('pair', pair.id),
      onTap: () => context.go(pair.route),
      padding: const EdgeInsets.all(AppSpacing.x4),
      borderColor: AppModuleAccents.markets.withValues(alpha: .14),
      child: Row(
        children: [
          const _ModuleBadge(
            label: 'Spot Trading',
            icon: Icons.bar_chart_rounded,
            color: AppModuleAccents.markets,
          ),
          const SizedBox(width: AppSpacing.x4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pair.symbol,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  '${pair.baseAsset}/${pair.quoteAsset}',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                pair.priceLabel,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontFeatures: AppTextStyles.tabularFigures,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.x1),
              Text(
                '$sign${pair.change24h.toStringAsFixed(2)}%',
                style: AppTextStyles.micro.copyWith(
                  color: changeColor,
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
