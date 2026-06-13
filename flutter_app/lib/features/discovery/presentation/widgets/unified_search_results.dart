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
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              TextSpan(text: ' kết quả cho "${snapshot.query}"'),
            ],
          ),
          style: AppTextStyles.caption.copyWith(color: AppColors.text2),
        ),
        const Padding(padding: EdgeInsets.only(top: AppSpacing.x4)),
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
          const Padding(padding: EdgeInsets.only(top: AppSpacing.x5)),
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
          const Padding(padding: EdgeInsets.only(top: AppSpacing.x5)),
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
          const Padding(padding: EdgeInsets.only(top: AppSpacing.x5)),
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
          const Padding(padding: EdgeInsets.only(top: AppSpacing.x5)),
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
          const Padding(padding: EdgeInsets.only(top: AppSpacing.x5)),
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
        const Padding(padding: EdgeInsets.only(top: AppSpacing.x3)),
        ...children.expand(
          (child) => [
            child,
            const Padding(padding: EdgeInsets.only(top: AppSpacing.x3)),
          ],
        ),
      ],
    );
  }
}
