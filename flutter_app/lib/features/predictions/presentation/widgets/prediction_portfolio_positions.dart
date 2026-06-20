import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/predictions/domain/entities/predictions_entities.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/widgets/prediction_portfolio_common.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

class PredictionPortfolioPositionsList extends StatelessWidget {
  const PredictionPortfolioPositionsList({
    required this.snapshot,
    required this.positions,
    this.emptyTitle = 'No active positions',
    this.emptySubtitle = 'Start trading to build your portfolio',
    super.key,
  });

  final PredictionPortfolioSnapshot snapshot;
  final List<PredictionPortfolioPositionDraft> positions;
  final String emptyTitle;
  final String emptySubtitle;

  @override
  Widget build(BuildContext context) {
    if (positions.isEmpty) {
      return VitEmptyState(
        icon: Icons.work_outline_rounded,
        title: emptyTitle,
        message: emptySubtitle,
      );
    }

    return Column(
      children: [
        for (var index = 0; index < positions.length; index += 1) ...[
          PredictionPortfolioPositionCard(
            key: predictionPortfolioPositionKey(positions[index].id),
            position: positions[index],
            event: snapshot.eventFor(positions[index].eventId),
          ),
          if (index != positions.length - 1)
            const SizedBox(height: AppSpacing.predictionPortfolioListGap),
        ],
      ],
    );
  }
}

class PredictionPortfolioPositionCard extends StatelessWidget {
  const PredictionPortfolioPositionCard({
    required this.position,
    required this.event,
    super.key,
  });

  final PredictionPortfolioPositionDraft position;
  final PredictionEventDraft event;

  @override
  Widget build(BuildContext context) {
    final isOpen = position.status == PredictionPortfolioPositionStatus.open;
    final isWon = position.status == PredictionPortfolioPositionStatus.won;
    final statusColor = isWon
        ? AppColors.buy
        : isOpen
        ? AppColors.warn
        : AppColors.sell;
    final statusLabel = isWon
        ? 'Won'
        : isOpen
        ? 'Open'
        : 'Lost';
    final outcomeColor = position.outcome == 'No'
        ? AppColors.sell
        : AppColors.buy;
    final pnlColor = position.pnl >= 0 ? AppColors.buy : AppColors.sell;

    return VitCard(
      onTap: () => context.go(AppRoutePaths.marketsPredictionEvent(event.id)),
      padding: AppSpacing.predictionPortfolioPositionCardPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: AppSpacing.predictionPortfolioPositionIconBox,
            height: AppSpacing.predictionPortfolioPositionIconBox,
            child: DecoratedBox(
              decoration: ShapeDecoration(
                color: statusColor.withValues(alpha: .12),
                shape: const RoundedRectangleBorder(
                  borderRadius: AppRadii.mdRadius,
                ),
              ),
              child: Icon(
                isWon
                    ? Icons.check_circle_outline_rounded
                    : isOpen
                    ? Icons.schedule_rounded
                    : Icons.cancel_outlined,
                color: statusColor,
                size: AppSpacing.predictionPortfolioPositionIcon,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.predictionPortfolioPositionGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.badge.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(
                  height: AppSpacing.predictionPortfolioPositionTitleGap,
                ),
                Wrap(
                  spacing: AppSpacing.predictionPortfolioChipGap,
                  runSpacing: AppSpacing.predictionPortfolioChipRunGap,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    PredictionPortfolioTinyBadge(
                      label: position.outcome,
                      color: outcomeColor,
                      background: outcomeColor.withValues(alpha: .12),
                    ),
                    Text(
                      '${formatPredictionPortfolioShares(position.shares)} shares @ '
                      '\$${position.avgPrice.toStringAsFixed(2)}',
                      style: AppTextStyles.numericMicro.copyWith(
                        color: AppColors.text3,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                    PredictionPortfolioTinyBadge(
                      label: statusLabel,
                      color: statusColor,
                      background: statusColor.withValues(alpha: .12),
                    ),
                  ],
                ),
                const SizedBox(
                  height: AppSpacing.predictionPortfolioPositionMetricsGap,
                ),
                Row(
                  children: [
                    Expanded(
                      child: PredictionPortfolioSmallMetric(
                        label: 'Avg:',
                        value: '\$${position.avgPrice.toStringAsFixed(2)}',
                      ),
                    ),
                    const SizedBox(
                      width: AppSpacing.predictionPortfolioPositionMetricsGap,
                    ),
                    Expanded(
                      child: PredictionPortfolioSmallMetric(
                        label: 'Current:',
                        value: '\$${position.currentPrice.toStringAsFixed(2)}',
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: AppSpacing.predictionPortfolioPositionRowsGap,
                ),
                Row(
                  children: [
                    Expanded(
                      child: PredictionPortfolioSmallMetric(
                        label: 'Value:',
                        value: formatPredictionPortfolioMoney(
                          position.currentValue,
                        ),
                        strong: true,
                      ),
                    ),
                    const SizedBox(
                      width: AppSpacing.predictionPortfolioPositionMetricsGap,
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(
                            position.pnl >= 0
                                ? Icons.arrow_outward_rounded
                                : Icons.south_east_rounded,
                            color: pnlColor,
                            size: AppSpacing.predictionPortfolioPnlArrowIcon,
                          ),
                          const SizedBox(
                            width: AppSpacing.predictionPortfolioPnlArrowGap,
                          ),
                          Flexible(
                            child: Text(
                              '${formatPredictionPortfolioSignedMoney(position.pnl)} '
                              '(${position.pnlPct.toStringAsFixed(1)}%)',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.end,
                              style: AppTextStyles.badge.copyWith(
                                color: pnlColor,
                                fontWeight: AppTextStyles.bold,
                                fontFeatures: AppTextStyles.tabularFigures,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.predictionPortfolioTrailingGap),
          const Padding(
            padding: AppSpacing.predictionPortfolioTrailingIconPadding,
            child: Icon(
              Icons.chevron_right_rounded,
              color: AppColors.text3,
              size: AppSpacing.predictionPortfolioTrailingIcon,
            ),
          ),
        ],
      ),
    );
  }
}

class PredictionPortfolioSmallMetric extends StatelessWidget {
  const PredictionPortfolioSmallMetric({
    required this.label,
    required this.value,
    this.strong = false,
    super.key,
  });

  final String label;
  final String value;
  final bool strong;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: AppTextStyles.numericMicro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(width: AppSpacing.predictionPortfolioMetricGap),
        Flexible(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: (strong ? AppTextStyles.badge : AppTextStyles.numericMicro)
                .copyWith(
                  color: strong ? AppColors.text1 : AppColors.text2,
                  fontWeight: strong
                      ? AppTextStyles.bold
                      : AppTextStyles.normal,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
          ),
        ),
      ],
    );
  }
}
