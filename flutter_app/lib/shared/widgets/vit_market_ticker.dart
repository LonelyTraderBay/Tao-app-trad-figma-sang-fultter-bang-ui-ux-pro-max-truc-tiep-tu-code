import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_card.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_market_rows.dart';

class VitMarketTickerData {
  const VitMarketTickerData({
    required this.title,
    required this.price,
    required this.changeLabel,
    required this.trend,
    this.leading,
    this.onTap,
  });

  final String title;
  final String price;
  final String changeLabel;
  final VitTrendDirection trend;
  final Widget? leading;
  final VoidCallback? onTap;
}

class VitMarketTickerStrip extends StatelessWidget {
  const VitMarketTickerStrip({super.key, required this.items});

  final List<VitMarketTickerData> items;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        children: [
          for (var index = 0; index < items.length; index++) ...[
            VitMarketTickerCard(data: items[index]),
            if (index < items.length - 1)
              const SizedBox(width: AppSpacing.homeMarketTickerStripGap),
          ],
        ],
      ),
    );
  }
}

class VitMarketTickerCard extends StatelessWidget {
  const VitMarketTickerCard({super.key, required this.data});

  final VitMarketTickerData data;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSpacing.homeMarketTickerCardWidth,
      child: VitCard(
        onTap: data.onTap,
        borderColor: data.trend.foreground.withValues(alpha: .24),
        padding: AppSpacing.homeMarketTickerCardPadding,
        constraints: const BoxConstraints(
          minHeight: AppSpacing.homeMarketTickerCardMinHeight,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (data.leading != null) ...[
                  data.leading!,
                  const SizedBox(width: AppSpacing.x2),
                ],
                Expanded(
                  child: Text(
                    data.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.x2),
            Text(
              data.price,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.medium,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
            const SizedBox(height: AppSpacing.x1),
            DecoratedBox(
              decoration: BoxDecoration(
                color: data.trend.background,
                borderRadius: AppRadii.xsRadius,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.x2,
                  vertical: AppSpacing.x1,
                ),
                child: Text(
                  data.changeLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: data.trend.foreground,
                    fontWeight: AppTextStyles.bold,
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
