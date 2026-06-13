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
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              InkWell(
                key: WatchlistPage.pairLinkKey(pair.id),
                onTap: onPairTap,
                borderRadius: AppRadii.lgRadius,
                child: _AssetAvatar(pair: pair),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: InkWell(
                  onTap: onPairTap,
                  borderRadius: AppRadii.smRadius,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pair.baseAsset,
                          style: AppTextStyles.baseMedium.copyWith(height: 1.2),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          pair.symbol,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text3,
                            height: 1,
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
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        positive
                            ? Icons.trending_up_rounded
                            : Icons.trending_down_rounded,
                        color: changeColor,
                        size: 15,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        _formatPercent(pair.change24h),
                        style: AppTextStyles.caption.copyWith(
                          color: changeColor,
                          fontWeight: AppTextStyles.bold,
                          fontFeatures: AppTextStyles.tabularFigures,
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 6),
          SizedBox(
            height: 42,
            child: CustomPaint(
              painter: _WatchlistSparklinePainter(
                values: pair.sparklineData,
                color: changeColor,
              ),
              child: const SizedBox.expand(),
            ),
          ),
          const SizedBox(height: 10),
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
          const SizedBox(height: 10),
          const Divider(height: 1, color: AppColors.divider),
          if (entry.note != null) ...[
            const SizedBox(height: 12),
            _NotePill(note: entry.note!),
          ],
          const SizedBox(height: 12),
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
              const SizedBox(width: 8),
              _ActionButton(
                key: WatchlistPage.noteKey(entry.id),
                label: entry.note == null ? 'Thêm ghi chú' : 'Sửa ghi chú',
                background: AppColors.surface2,
                foreground: AppColors.text2,
                onTap: onNoteTap,
              ),
              const SizedBox(width: 8),
              InkWell(
                key: WatchlistPage.removeKey(entry.id),
                onTap: onRemoveTap,
                borderRadius: AppRadii.mdRadius,
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: AppColors.sell10,
                    borderRadius: AppRadii.mdRadius,
                  ),
                  child: const Icon(
                    Icons.delete_outline_rounded,
                    color: AppColors.sell,
                    size: 18,
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
    return Container(
      width: 44,
      height: 44,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: pair.logoColor.withValues(alpha: 0.16),
        shape: BoxShape.circle,
      ),
      child: Text(
        pair.baseAsset.length <= 3
            ? pair.baseAsset
            : pair.baseAsset.substring(0, 3),
        style: AppTextStyles.micro.copyWith(
          color: pair.logoColor,
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
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
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text3,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: AppTextStyles.caption.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
            height: 1,
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
    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: _marketPrimary.withValues(alpha: 0.07),
        border: Border.all(color: _marketPrimary.withValues(alpha: 0.14)),
        borderRadius: AppRadii.mdRadius,
      ),
      child: Row(
        children: [
          const Icon(Icons.edit_note_rounded, color: _marketPrimary, size: 16),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              note,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: _marketPrimary,
                height: 1,
              ),
            ),
          ),
        ],
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
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.mdRadius,
      child: Container(
        height: 38,
        constraints: const BoxConstraints(minWidth: 102),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: background,
          borderRadius: AppRadii.mdRadius,
        ),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(
            color: foreground,
            fontWeight: AppTextStyles.bold,
            height: 1,
          ),
        ),
      ),
    );
  }
}
