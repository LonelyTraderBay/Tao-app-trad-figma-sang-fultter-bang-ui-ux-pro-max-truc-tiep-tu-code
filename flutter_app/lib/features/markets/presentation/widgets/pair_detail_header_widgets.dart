part of '../pages/pair_detail_page.dart';

class _PairHeader extends StatelessWidget {
  const _PairHeader({
    required this.pair,
    required this.favorite,
    required this.onBack,
    required this.onPairTap,
    required this.onFavorite,
  });

  final MarketPair pair;
  final bool favorite;
  final VoidCallback onBack;
  final VoidCallback onPairTap;
  final VoidCallback onFavorite;

  @override
  Widget build(BuildContext context) {
    return VitTopChrome(
      type: VitTopChromeType.instrument,
      leading: SizedBox(
        width: AppSpacing.pairHeaderLeadingWidth,
        child: Align(
          alignment: Alignment.centerLeft,
          child: VitHeaderActionButton(
            type: VitHeaderActionType.back,
            tone: VitHeaderActionTone.transparent,
            onPressed: onBack,
          ),
        ),
      ),
      body: Center(
        child: Semantics(
          button: true,
          label: 'Ch\u1ECDn c\u1EB7p giao d\u1ECBch ${pair.symbol}',
          child: VitCard(
            variant: VitCardVariant.ghost,
            radius: VitCardRadius.standard,
            padding: AppSpacing.pairHeaderSymbolPadding,
            onTap: onPairTap,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                VitAssetAvatar(
                  label: pair.baseAsset,
                  accentColor: pair.logoColor,
                  size: AppSpacing.pairHeaderLogo,
                  radius: AppRadii.pillRadius,
                ),
                const SizedBox(width: AppSpacing.pairHeaderSymbolGap),
                Flexible(
                  child: Text(
                    pair.symbol,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.base.copyWith(
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.pairHeaderChevronGap),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.text2,
                  size: AppSpacing.pairHeaderChevron,
                ),
              ],
            ),
          ),
        ),
      ),
      trailing: SizedBox(
        width: AppSpacing.pairHeaderTrailingWidth,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            VitHeaderActionButton(
              type: favorite
                  ? VitHeaderActionType.favoriteOn
                  : VitHeaderActionType.favoriteOff,
              tooltip: favorite
                  ? 'B\u1ECF theo d\u00F5i ${pair.symbol}'
                  : 'Theo d\u00F5i ${pair.symbol}',
              onPressed: onFavorite,
            ),
            const SizedBox(width: AppSpacing.pairHeaderTrailingGap),
            const VitHeaderActionButton(
              type: VitHeaderActionType.share,
              onPressed: _noop,
            ),
          ],
        ),
      ),
    );
  }
}

void _noop() {}

class _PriceOverview extends StatelessWidget {
  const _PriceOverview({required this.pair});

  final MarketPair pair;

  @override
  Widget build(BuildContext context) {
    final positive = pair.change24h >= 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: AppSpacing.pairPriceOverviewPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Text(
                      _formatPrice(pair.price),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.amountLg.copyWith(
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.pairPriceChangeGap),
                  VitAccentPill(
                    label:
                        '${positive ? '\u25B2' : '\u25BC'} ${pair.change24h.abs().toStringAsFixed(2)}%',
                    accentColor: positive ? AppColors.buy : AppColors.sell,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.x2),
              Row(
                children: [
                  Expanded(
                    child: _PriceStat(
                      label: '24h Cao',
                      value: _formatPrice(pair.high24h),
                      color: AppColors.buy,
                    ),
                  ),
                  Expanded(
                    child: _PriceStat(
                      label: '24h Thap',
                      value: _formatPrice(pair.low24h),
                      color: AppColors.sell,
                    ),
                  ),
                  Expanded(
                    child: _PriceStat(
                      label: 'KL 24h',
                      value: '${_formatCompact(pair.volume24h)}B',
                      color: AppColors.text2,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const Divider(
          color: AppColors.divider,
          height: AppSpacing.dividerHairline,
        ),
      ],
    );
  }
}

class _PriceStat extends StatelessWidget {
  const _PriceStat({
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
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          value,
          style: AppTextStyles.numericMicro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}
