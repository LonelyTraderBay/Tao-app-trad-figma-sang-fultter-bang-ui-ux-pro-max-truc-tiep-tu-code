part of '../pages/unified_search_page.dart';

class _ArenaRoomResultCard extends StatelessWidget {
  const _ArenaRoomResultCard({required this.room});

  final DiscoveryArenaRoomDraft room;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: UnifiedSearchPage.resultKey('arenaRoom', room.id),
      onTap: () => context.go(room.route),
      padding: LaunchpadSpacingTokens.discoveryCardPadding,
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
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Text(
            room.title,
            style: AppTextStyles.body.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
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
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
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
      padding: LaunchpadSpacingTokens.discoveryCardPadding,
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
      padding: LaunchpadSpacingTokens.discoveryCardPadding,
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
