import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/markets/domain/entities/market_entities.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/market_list_common.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

class MarketListTopMovers extends StatelessWidget {
  const MarketListTopMovers({super.key, required this.pairs});

  final List<MarketPair> pairs;

  @override
  Widget build(BuildContext context) {
    final gainers = pairs.where((pair) => pair.change24h > 0).toList()
      ..sort((a, b) => b.change24h.compareTo(a.change24h));
    final losers = pairs.where((pair) => pair.change24h < 0).toList()
      ..sort((a, b) => a.change24h.compareTo(b.change24h));

    return Row(
      children: [
        Expanded(
          child: _MoverCard(
            title: 'Tăng mạnh',
            icon: Icons.trending_up_rounded,
            color: AppColors.buy,
            pairs: gainers.take(3).toList(),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _MoverCard(
            title: 'Giảm mạnh',
            icon: Icons.trending_down_rounded,
            color: AppColors.sell,
            pairs: losers.take(3).toList(),
          ),
        ),
      ],
    );
  }
}

class _MoverCard extends StatelessWidget {
  const _MoverCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.pairs,
  });

  final String title;
  final IconData icon;
  final Color color;
  final List<MarketPair> pairs;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      height: 130,
      borderColor: color.withValues(alpha: 0.18),
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 11),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 14),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: color,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          for (final pair in pairs) ...[
            Row(
              children: [
                Expanded(
                  child: Text(
                    pair.baseAsset,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                      height: 1.25,
                    ),
                  ),
                ),
                Text(
                  marketListFormatPct(pair.change24h),
                  style: AppTextStyles.caption.copyWith(
                    color: color,
                    fontWeight: AppTextStyles.bold,
                    height: 1.25,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ],
            ),
            if (pair != pairs.last) const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}
