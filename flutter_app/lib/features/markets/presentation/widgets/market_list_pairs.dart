import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/markets/domain/entities/market_entities.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/market_list_common.dart';

class MarketListColumnHeader extends StatelessWidget {
  const MarketListColumnHeader({super.key, required this.lastUpdatedLabel});

  final String lastUpdatedLabel;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Cập nhật $lastUpdatedLabel',
      child: Container(
        height: AppSpacing.marketColumnHeaderHeight,
        padding: AppSpacing.marketColumnHeaderPadding,
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.divider)),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 38,
              child: Text(
                'Cặp giao dịch',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ),
            Expanded(
              flex: 26,
              child: Text(
                'Biểu đồ',
                textAlign: TextAlign.center,
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ),
            Expanded(
              flex: 36,
              child: Text(
                'Giá / Thay đổi',
                textAlign: TextAlign.right,
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MarketListPairList extends StatelessWidget {
  const MarketListPairList({
    super.key,
    required this.pairs,
    required this.favoriteIds,
    required this.onFavoriteToggle,
    required this.onNavigate,
  });

  final List<MarketPair> pairs;
  final Set<String> favoriteIds;
  final ValueChanged<String> onFavoriteToggle;
  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final pair in pairs)
          _MarketPairRow(
            key: MarketListKeys.pair(pair.id),
            pair: pair,
            favorite: favoriteIds.contains(pair.id),
            onFavoriteToggle: () => onFavoriteToggle(pair.id),
            onTap: () => onNavigate('/pair/${pair.id}'),
          ),
      ],
    );
  }
}

class _MarketPairRow extends StatelessWidget {
  const _MarketPairRow({
    super.key,
    required this.pair,
    required this.favorite,
    required this.onFavoriteToggle,
    required this.onTap,
  });

  final MarketPair pair;
  final bool favorite;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final positive = pair.change24h >= 0;
    final color = positive ? AppColors.buy : AppColors.sell;

    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.divider)),
        ),
        padding: AppSpacing.marketPairRowPadding,
        child: Row(
          children: [
            _CoinAvatar(pair: pair),
            const SizedBox(width: AppSpacing.marketPairGap),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pair.baseAsset,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.body.copyWith(
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.marketPairMicroGap),
                  Text(
                    pair.quoteAsset,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text3,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: AppSpacing.marketPairSparklineWidth,
              height: AppSpacing.marketPairSparklineHeight,
              child: CustomPaint(
                painter: MarketListSparklinePainter(
                  values: pair.sparklineData,
                  color: color,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.marketPairGap),
            SizedBox(
              width: AppSpacing.marketPairPriceColumnWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    marketListFormatPrice(pair.price),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.body.copyWith(
                      fontWeight: AppTextStyles.bold,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.marketPairPriceGap),
                  Container(
                    padding: AppSpacing.marketPairChangePadding,
                    decoration: BoxDecoration(
                      color: positive ? AppColors.buy15 : AppColors.sell15,
                      borderRadius: AppRadii.smRadius,
                    ),
                    child: Text(
                      marketListFormatPct(pair.change24h),
                      style: AppTextStyles.badge.copyWith(
                        color: color,
                        fontWeight: AppTextStyles.bold,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.marketPairFavoriteGap),
            Tooltip(
              message: favorite ? 'Bỏ yêu thích' : 'Thêm vào yêu thích',
              child: Semantics(
                button: true,
                label: favorite
                    ? 'Bỏ yêu thích ${pair.baseAsset}'
                    : 'Thêm vào yêu thích ${pair.baseAsset}',
                child: InkResponse(
                  onTap: onFavoriteToggle,
                  radius: AppSpacing.marketPairFavoriteRadius,
                  child: SizedBox(
                    width: AppSpacing.marketPairFavoriteWidth,
                    height: AppSpacing.marketPairFavoriteHeight,
                    child: Icon(
                      favorite ? Icons.star_rounded : Icons.star_border_rounded,
                      color: favorite ? marketListArenaAccent : AppColors.text3,
                      size: AppSpacing.marketPairFavoriteIcon,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CoinAvatar extends StatelessWidget {
  const _CoinAvatar({required this.pair});

  final MarketPair pair;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSpacing.marketPairAvatar,
      height: AppSpacing.marketPairAvatar,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: pair.logoColor.withValues(alpha: 0.15),
        border: Border.all(
          color: pair.logoColor.withValues(alpha: 0.30),
          width: AppSpacing.marketPairAvatarBorder,
        ),
        shape: BoxShape.circle,
      ),
      child: Text(
        pair.baseAsset.substring(
          0,
          pair.baseAsset.length < 3 ? pair.baseAsset.length : 3,
        ),
        style: AppTextStyles.badge.copyWith(
          color: pair.logoColor,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}
