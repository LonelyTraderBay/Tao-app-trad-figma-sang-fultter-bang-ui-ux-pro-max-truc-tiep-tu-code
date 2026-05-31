import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/predictions/domain/entities/predictions_entities.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/widgets/prediction_portfolio_common.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

class PredictionPortfolioOpenOrdersSection extends StatelessWidget {
  const PredictionPortfolioOpenOrdersSection({
    required this.snapshot,
    required this.orders,
    required this.onCancel,
    super.key,
  });

  final PredictionPortfolioSnapshot snapshot;
  final List<PredictionPortfolioOrderDraft> orders;
  final ValueChanged<String> onCancel;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Open Orders',
      accentColor: AppColors.warn,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Pending limit orders awaiting fill',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '${orders.length}',
              style: AppTextStyles.micro.copyWith(
                color: AppColors.warn,
                fontWeight: AppTextStyles.bold,
              ),
            ),
            const SizedBox(width: 6),
            const Icon(
              Icons.help_outline_rounded,
              color: AppColors.text3,
              size: 13,
            ),
          ],
        ),
        for (var index = 0; index < orders.length; index += 1) ...[
          PredictionPortfolioOpenOrderCard(
            key: predictionPortfolioOpenOrderKey(orders[index].id),
            order: orders[index],
            event: snapshot.eventFor(orders[index].eventId),
            onCancel: () => onCancel(orders[index].id),
          ),
        ],
      ],
    );
  }
}

class PredictionPortfolioOpenOrderCard extends StatelessWidget {
  const PredictionPortfolioOpenOrderCard({
    required this.order,
    required this.event,
    required this.onCancel,
    super.key,
  });

  final PredictionPortfolioOrderDraft order;
  final PredictionEventDraft event;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final isBuy = order.side == 'buy';
    final color = isBuy ? AppColors.buy : AppColors.sell;
    final fillPct = order.shares == 0 ? 0.0 : (order.filled / order.shares);

    return VitCard(
      padding: const EdgeInsets.all(12),
      child: InkWell(
        onTap: () =>
            context.go(AppRoutePaths.marketsPredictionReceipt(order.receiptId)),
        borderRadius: AppRadii.cardRadius,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: color.withValues(alpha: .12),
                borderRadius: AppRadii.mdRadius,
              ),
              child: Icon(Icons.attach_money_rounded, color: color, size: 17),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontSize: 12,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      PredictionPortfolioTinyBadge(
                        label: '${order.side.toUpperCase()} ${order.outcome}',
                        color: color,
                        background: color.withValues(alpha: .12),
                      ),
                      Text(
                        '${formatPredictionPortfolioShares(order.shares)} @ '
                        '\$${order.price.toStringAsFixed(2)}',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text2,
                          fontSize: 10,
                          fontFeatures: AppTextStyles.tabularFigures,
                        ),
                      ),
                      Text(
                        'Filled: ${(fillPct * 100).round()}%',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: SizedBox(
                      height: 5,
                      child: LinearProgressIndicator(
                        value: fillPct,
                        backgroundColor: AppColors.surface3,
                        valueColor: AlwaysStoppedAnimation<Color>(color),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.text3,
                  size: 14,
                ),
                const SizedBox(height: 8),
                InkWell(
                  key: predictionPortfolioCancelOrderKey(order.id),
                  onTap: onCancel,
                  borderRadius: AppRadii.mdRadius,
                  child: Container(
                    height: 32,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: AppColors.sell10,
                      border: Border.all(color: AppColors.sell20),
                      borderRadius: AppRadii.mdRadius,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.close_rounded,
                          color: AppColors.sell,
                          size: 12,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Cancel',
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.sell,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
