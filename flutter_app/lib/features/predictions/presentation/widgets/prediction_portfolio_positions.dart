import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
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
          if (index != positions.length - 1) const SizedBox(height: 10),
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
      padding: const EdgeInsets.fromLTRB(14, 14, 12, 26),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: .12),
              borderRadius: AppRadii.mdRadius,
            ),
            child: Icon(
              isWon
                  ? Icons.check_circle_outline_rounded
                  : isOpen
                  ? Icons.schedule_rounded
                  : Icons.cancel_outlined,
              color: statusColor,
              size: 19,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontSize: 12,
                    height: 1.28,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
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
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                        fontSize: 10,
                        height: 1.2,
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
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: PredictionPortfolioSmallMetric(
                        label: 'Avg:',
                        value: '\$${position.avgPrice.toStringAsFixed(2)}',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: PredictionPortfolioSmallMetric(
                        label: 'Current:',
                        value: '\$${position.currentPrice.toStringAsFixed(2)}',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
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
                    const SizedBox(width: 8),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(
                            position.pnl >= 0
                                ? Icons.arrow_outward_rounded
                                : Icons.south_east_rounded,
                            color: pnlColor,
                            size: 13,
                          ),
                          const SizedBox(width: 3),
                          Flexible(
                            child: Text(
                              '${formatPredictionPortfolioSignedMoney(position.pnl)} '
                              '(${position.pnlPct.toStringAsFixed(1)}%)',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.end,
                              style: AppTextStyles.micro.copyWith(
                                color: pnlColor,
                                fontSize: 12,
                                height: 1.2,
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
          const SizedBox(width: 8),
          const Padding(
            padding: EdgeInsets.only(top: 18),
            child: Icon(
              Icons.chevron_right_rounded,
              color: AppColors.text3,
              size: 18,
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
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            fontSize: 10,
            height: 1.2,
          ),
        ),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: strong ? AppColors.text1 : AppColors.text2,
              fontSize: strong ? 12 : 10,
              height: 1.2,
              fontWeight: strong ? AppTextStyles.bold : AppTextStyles.normal,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ),
      ],
    );
  }
}
