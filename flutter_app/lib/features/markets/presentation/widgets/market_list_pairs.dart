import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
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
        height: 46,
        padding: const EdgeInsets.symmetric(horizontal: 20),
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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            _CoinAvatar(pair: pair),
            const SizedBox(width: 12),
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
                      height: 1.15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    pair.quoteAsset,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text3,
                      fontSize: 12,
                      height: 1.1,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 70,
              height: 32,
              child: CustomPaint(
                painter: MarketListSparklinePainter(
                  values: pair.sparklineData,
                  color: color,
                ),
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 74,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    marketListFormatPrice(pair.price),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.body.copyWith(
                      fontWeight: AppTextStyles.bold,
                      height: 1.1,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: positive ? AppColors.buy15 : AppColors.sell15,
                      borderRadius: AppRadii.smRadius,
                    ),
                    child: Text(
                      marketListFormatPct(pair.change24h),
                      style: AppTextStyles.micro.copyWith(
                        color: color,
                        fontSize: 12,
                        fontWeight: AppTextStyles.bold,
                        height: 1,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Tooltip(
              message: favorite ? 'Bỏ yêu thích' : 'Thêm vào yêu thích',
              child: Semantics(
                button: true,
                label: favorite
                    ? 'Bỏ yêu thích ${pair.baseAsset}'
                    : 'Thêm vào yêu thích ${pair.baseAsset}',
                child: InkResponse(
                  onTap: onFavoriteToggle,
                  radius: 18,
                  child: SizedBox(
                    width: 28,
                    height: 32,
                    child: Icon(
                      favorite ? Icons.star_rounded : Icons.star_border_rounded,
                      color: favorite ? marketListArenaAccent : AppColors.text3,
                      size: 18,
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
      width: 34,
      height: 34,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: pair.logoColor.withValues(alpha: 0.15),
        border: Border.all(
          color: pair.logoColor.withValues(alpha: 0.30),
          width: 1.5,
        ),
        shape: BoxShape.circle,
      ),
      child: Text(
        pair.baseAsset.substring(
          0,
          pair.baseAsset.length < 3 ? pair.baseAsset.length : 3,
        ),
        style: AppTextStyles.caption.copyWith(
          color: pair.logoColor,
          fontSize: 12,
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
    );
  }
}
