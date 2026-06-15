import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_sparkline.dart';

enum VitTrendDirection { positive, negative, neutral }

extension VitTrendDirectionColors on VitTrendDirection {
  Color get foreground {
    return switch (this) {
      VitTrendDirection.positive => AppColors.buy,
      VitTrendDirection.negative => AppColors.sell,
      VitTrendDirection.neutral => AppColors.text3,
    };
  }

  Color get background {
    return switch (this) {
      VitTrendDirection.positive => AppColors.buy10,
      VitTrendDirection.negative => AppColors.sell10,
      VitTrendDirection.neutral => AppColors.surface2,
    };
  }
}

class VitMarketPairRow extends StatelessWidget {
  const VitMarketPairRow({
    super.key,
    required this.leading,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.changeLabel,
    required this.trend,
    this.sparkline,
    this.onTap,
    this.showSparkline = true,
  });

  final Widget leading;
  final String title;
  final String subtitle;
  final String price;
  final String changeLabel;
  final VitTrendDirection trend;
  final List<double>? sparkline;
  final VoidCallback? onTap;
  final bool showSparkline;

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.homeSectionHorizontalPadding,
        vertical: AppSpacing.homeSectionVerticalPadding,
      ),
      child: Row(
        children: [
          leading,
          const SizedBox(width: AppSpacing.homeMarketIconGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: AppTextStyles.medium,
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: AppSpacing.x1)),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          if (showSparkline && sparkline != null) ...[
            SizedBox(
              width: AppSpacing.homeSparklineWidth,
              height: AppSpacing.homeSparklineHeight,
              child: VitSparkline(values: sparkline!, color: trend.foreground),
            ),
            const SizedBox(width: AppSpacing.homeMarketIconGap),
          ],
          SizedBox(
            width: AppSpacing.homeRankedValueColumnWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  price,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: AppTextStyles.medium,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: AppSpacing.x1)),
                Text(
                  changeLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: trend.foreground,
                    fontWeight: AppTextStyles.medium,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    if (onTap == null) return content;
    return InkWell(onTap: onTap, child: content);
  }
}

class VitRankedAssetRow extends StatelessWidget {
  const VitRankedAssetRow({
    super.key,
    required this.rank,
    required this.leading,
    required this.title,
    required this.badgeLabel,
    required this.trend,
    this.highlightRank = false,
    this.onTap,
  });

  final int rank;
  final Widget leading;
  final String title;
  final String badgeLabel;
  final VitTrendDirection trend;
  final bool highlightRank;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.homeSectionHorizontalPadding,
        vertical: AppSpacing.homeSectionVerticalPadding,
      ),
      child: Row(
        children: [
          SizedBox(
            width: AppSpacing.homeRankedRowRankChipWidth,
            child: Text(
              '$rank',
              textAlign: TextAlign.center,
              style: AppTextStyles.caption.copyWith(
                color: highlightRank ? AppColors.warn : AppColors.text3,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.homeMarketIconGap),
          const SizedBox(width: AppSpacing.homeMarketIconGap),
          leading,
          const SizedBox(width: AppSpacing.homeMarketIconGap),
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.body.copyWith(
                fontWeight: AppTextStyles.medium,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.homeRankedRowBadgePaddingHorizontal,
              vertical: AppSpacing.homeRankedRowBadgePaddingVertical,
            ),
            decoration: BoxDecoration(
              color: trend.background,
              borderRadius: AppRadii.xsRadius,
            ),
            child: Text(
              badgeLabel,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: trend.foreground,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
        ],
      ),
    );

    if (onTap == null) return content;
    return InkWell(onTap: onTap, child: content);
  }
}
