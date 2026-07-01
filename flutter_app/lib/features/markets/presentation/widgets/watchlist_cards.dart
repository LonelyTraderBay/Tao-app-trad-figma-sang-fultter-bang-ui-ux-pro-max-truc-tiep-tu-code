part of '../pages/watchlist_page.dart';

class _WatchlistCard extends StatelessWidget {
  const _WatchlistCard({
    required this.item,
    required this.onPairTap,
    required this.onTradeTap,
    required this.onNoteTap,
    required this.onRemoveTap,
  });

  final _WatchlistItem item;
  final VoidCallback onPairTap;
  final VoidCallback onTradeTap;
  final VoidCallback onNoteTap;
  final VoidCallback onRemoveTap;

  @override
  Widget build(BuildContext context) {
    final pair = item.pair;
    final entry = item.entry;
    final positive = pair.change24h >= 0;
    final changeColor = positive ? AppColors.buy : AppColors.sell;

    return VitCard(
      key: WatchlistPage.cardKey(pair.id),
      padding: VitDensity.compact.cardPadding,
      child: Column(
        children: [
          Row(
            children: [
              VitCard(
                key: WatchlistPage.pairLinkKey(pair.id),
                onTap: onPairTap,
                variant: VitCardVariant.ghost,
                radius: VitCardRadius.standard,
                padding: EdgeInsets.zero,
                borderColor: AppColors.transparent,
                clip: true,
                child: _AssetAvatar(pair: pair),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: VitCard(
                  onTap: onPairTap,
                  variant: VitCardVariant.ghost,
                  radius: VitCardRadius.standard,
                  padding: EdgeInsets.zero,
                  borderColor: AppColors.transparent,
                  child: Padding(
                    padding: const EdgeInsetsDirectional.symmetric(
                      vertical: AppSpacing.x1,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(pair.baseAsset, style: AppTextStyles.baseMedium),
                        const SizedBox(height: AppSpacing.x1),
                        Text(
                          pair.symbol,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _formatUsd(pair.price),
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x1),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        positive
                            ? Icons.trending_up_rounded
                            : Icons.trending_down_rounded,
                        color: changeColor,
                        size: AppSpacing.iconSm,
                      ),
                      const SizedBox(width: AppSpacing.x1),
                      Text(
                        _formatPercent(pair.change24h),
                        style: AppTextStyles.caption.copyWith(
                          color: changeColor,
                          fontWeight: AppTextStyles.bold,
                          fontFeatures: AppTextStyles.tabularFigures,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x2),
          SizedBox(
            height: _watchlistSparklineExtent,
            child: VitSparkline(values: pair.sparklineData, color: changeColor),
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              Expanded(
                child: _WatchlistStat(
                  label: '24h High',
                  value: _formatUsd(pair.high24h),
                  color: AppColors.buy,
                ),
              ),
              Expanded(
                child: _WatchlistStat(
                  label: '24h Low',
                  value: _formatUsd(pair.low24h),
                  color: AppColors.sell,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          const Divider(
            height: AppSpacing.dividerHairline,
            color: AppColors.divider,
          ),
          if (entry.note != null) ...[
            const SizedBox(height: AppSpacing.x3),
            _NotePill(note: entry.note!),
          ],
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              Expanded(
                child: _ActionButton(
                  key: WatchlistPage.tradeKey(pair.id),
                  label: 'Giao dịch',
                  background: _marketPrimary,
                  foreground: AppColors.onAccent,
                  onTap: onTradeTap,
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              _ActionButton(
                key: WatchlistPage.noteKey(entry.id),
                label: entry.note == null ? 'Thêm ghi chú' : 'Sửa ghi chú',
                background: AppColors.surface2,
                foreground: AppColors.text2,
                onTap: onNoteTap,
              ),
              const SizedBox(width: AppSpacing.x2),
              VitCard(
                key: WatchlistPage.removeKey(entry.id),
                onTap: onRemoveTap,
                variant: VitCardVariant.ghost,
                radius: VitCardRadius.standard,
                padding: EdgeInsets.zero,
                width: AppSpacing.watchlistRemoveButton,
                height: AppSpacing.watchlistRemoveButton,
                borderColor: AppColors.transparent,
                clip: true,
                child: const DecoratedBox(
                  decoration: ShapeDecoration(
                    color: AppColors.sell10,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadii.mdRadius,
                    ),
                  ),
                  child: Icon(
                    Icons.delete_outline_rounded,
                    color: AppColors.sell,
                    size: AppSpacing.iconSm,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AssetAvatar extends StatelessWidget {
  const _AssetAvatar({required this.pair});

  final MarketPair pair;

  @override
  Widget build(BuildContext context) {
    return VitAssetAvatar(
      label: pair.baseAsset,
      accentColor: pair.logoColor,
      size: AppSpacing.watchlistAvatar,
      radius: AppRadii.pillRadius,
    );
  }
}

class _WatchlistStat extends StatelessWidget {
  const _WatchlistStat({
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
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          value,
          style: AppTextStyles.caption.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _NotePill extends StatelessWidget {
  const _NotePill({required this.note});

  final String note;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _marketPrimary.withValues(alpha: 0.07),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadii.mdRadius,
        side: BorderSide(color: _marketPrimary.withValues(alpha: 0.14)),
      ),
      child: SizedBox(
        height: VitDensity.compact.controlHeight,
        child: Padding(
          padding: const EdgeInsetsDirectional.symmetric(
            horizontal: AppSpacing.x3,
          ),
          child: Row(
            children: [
              const Icon(
                Icons.edit_note_rounded,
                color: _marketPrimary,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  note,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(color: _marketPrimary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    super.key,
    required this.label,
    required this.background,
    required this.foreground,
    required this.onTap,
  });

  final String label;
  final Color background;
  final Color foreground;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      onTap: onTap,
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.standard,
      padding: EdgeInsets.zero,
      borderColor: AppColors.transparent,
      clip: true,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: background,
          shape: const RoundedRectangleBorder(borderRadius: AppRadii.mdRadius),
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: AppSpacing.watchlistActionMinWidth,
            minHeight: VitDensity.compact.controlHeight,
          ),
          child: Padding(
            padding: const EdgeInsetsDirectional.symmetric(
              horizontal: AppSpacing.x3,
            ),
            child: Center(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: foreground,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
