import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/widgets/prediction_portfolio_common.dart';

class PredictionPortfolioTabs extends StatelessWidget {
  const PredictionPortfolioTabs({
    required this.activeTab,
    required this.activeCount,
    required this.closedCount,
    required this.historyCount,
    required this.onChanged,
    super.key,
  });

  final PredictionPortfolioTab activeTab;
  final int activeCount;
  final int closedCount;
  final int historyCount;
  final ValueChanged<PredictionPortfolioTab> onChanged;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      (tab: PredictionPortfolioTab.active, label: 'Active', count: activeCount),
      (tab: PredictionPortfolioTab.closed, label: 'Closed', count: closedCount),
      (
        tab: PredictionPortfolioTab.history,
        label: 'History',
        count: historyCount,
      ),
    ];

    return SizedBox(
      height: AppSpacing.predictionPortfolioTabsHeight,
      child: DecoratedBox(
        decoration: const ShapeDecoration(
          color: AppColors.surface3,
          shape: RoundedRectangleBorder(borderRadius: AppRadii.lgRadius),
        ),
        child: Padding(
          padding: AppSpacing.predictionPortfolioTabsPadding,
          child: Row(
            children: [
              for (final item in tabs)
                Expanded(
                  child: PredictionPortfolioTabButton(
                    key: switch (item.tab) {
                      PredictionPortfolioTab.active =>
                        predictionPortfolioActiveTabKey,
                      PredictionPortfolioTab.closed =>
                        predictionPortfolioClosedTabKey,
                      PredictionPortfolioTab.history =>
                        predictionPortfolioHistoryTabKey,
                    },
                    label: item.label,
                    count: item.count,
                    active: activeTab == item.tab,
                    onTap: () => onChanged(item.tab),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class PredictionPortfolioTabButton extends StatelessWidget {
  const PredictionPortfolioTabButton({
    required this.label,
    required this.count,
    required this.active,
    required this.onTap,
    super.key,
  });

  final String label;
  final int count;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.cardRadius,
      child: TweenAnimationBuilder<Color?>(
        duration: const Duration(milliseconds: 160),
        tween: ColorTween(
          end: active ? AppColors.surface : AppColors.transparent,
        ),
        builder: (context, color, child) {
          return DecoratedBox(
            decoration: ShapeDecoration(
              color: color ?? AppColors.transparent,
              shape: const RoundedRectangleBorder(
                borderRadius: AppRadii.cardRadius,
              ),
            ),
            child: child,
          );
        },
        child: Align(
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.badge.copyWith(
                    color: active ? AppColors.text1 : AppColors.text3,
                    fontWeight: active
                        ? AppTextStyles.bold
                        : AppTextStyles.normal,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.predictionPortfolioTabLabelGap),
              PredictionPortfolioCountBadge(count: count, active: active),
            ],
          ),
        ),
      ),
    );
  }
}

class PredictionPortfolioCountBadge extends StatelessWidget {
  const PredictionPortfolioCountBadge({
    required this.count,
    required this.active,
    super.key,
  });

  final int count;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: active
            ? predictionPortfolioPrimary.withValues(alpha: .18)
            : AppColors.surface2,
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.badgeRadius),
      ),
      child: Padding(
        padding: AppSpacing.predictionPortfolioCountBadgePadding,
        child: Text(
          '$count',
          style: AppTextStyles.numericMicro.copyWith(
            color: active ? predictionPortfolioPrimary : AppColors.text3,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}
