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
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.bg,
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: SizedBox(
        height: 52,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              _HeaderButton(icon: Icons.chevron_left_rounded, onTap: onBack),
              const Spacer(),
              InkWell(
                onTap: onPairTap,
                borderRadius: AppRadii.cardRadius,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: pair.logoColor.withValues(alpha: .15),
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          pair.baseAsset,
                          style: AppTextStyles.micro.copyWith(
                            color: pair.logoColor,
                            fontWeight: AppTextStyles.bold,
                            fontSize: 10,
                          ),
                        ),
                      ),
                      const SizedBox(width: 9),
                      Text(
                        pair.symbol,
                        style: AppTextStyles.base.copyWith(
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                      const SizedBox(width: 5),
                      const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: AppColors.text2,
                        size: 17,
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: 76,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _HeaderSmallIcon(
                      onTap: onFavorite,
                      icon: Icon(
                        favorite
                            ? Icons.star_rounded
                            : Icons.star_border_rounded,
                        color: AppColors.caution,
                        size: 24,
                      ),
                    ),
                    const _HeaderSmallIcon(
                      icon: Icon(
                        Icons.share_outlined,
                        color: AppColors.text3,
                        size: 22,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderSmallIcon extends StatelessWidget {
  const _HeaderSmallIcon({required this.icon, this.onTap});

  final Widget icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 34,
      height: 38,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadii.mdRadius,
          child: Center(child: icon),
        ),
      ),
    );
  }
}

class _HeaderButton extends StatelessWidget {
  const _HeaderButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 38,
      height: 38,
      child: Material(
        color: AppColors.surface,
        borderRadius: AppRadii.mdRadius,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadii.mdRadius,
          child: Icon(icon, color: AppColors.text1, size: 22),
        ),
      ),
    );
  }
}

class _PriceOverview extends StatelessWidget {
  const _PriceOverview({required this.pair});

  final MarketPair pair;

  @override
  Widget build(BuildContext context) {
    final positive = pair.change24h >= 0;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 14),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
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
                  style: AppTextStyles.heroNumber.copyWith(
                    fontFamily: 'monospace',
                    fontSize: 31,
                    height: 1.1,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
                decoration: BoxDecoration(
                  color: positive ? AppColors.buy15 : AppColors.sell15,
                  borderRadius: AppRadii.smRadius,
                ),
                child: Text(
                  '${positive ? '▲' : '▼'} ${pair.change24h.abs().toStringAsFixed(2)}%',
                  style: AppTextStyles.caption.copyWith(
                    color: positive ? AppColors.buy : AppColors.sell,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
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
        const SizedBox(height: 2),
        Text(
          value,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            fontFamily: 'monospace',
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}
