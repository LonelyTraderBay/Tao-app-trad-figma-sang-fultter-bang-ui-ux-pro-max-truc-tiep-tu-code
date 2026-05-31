import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/markets/presentation/controllers/market_controller.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/market_depth_common.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

class MarketDepthWhaleAlertsView extends StatelessWidget {
  const MarketDepthWhaleAlertsView({required this.snapshot, super.key});

  final MarketDepthSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _WhaleWarningCard(),
        const SizedBox(height: 16),
        const MarketDepthSectionHeader(
          label: 'Lệnh lớn gần đây',
          accentColor: AppColors.warn,
        ),
        const SizedBox(height: 16),
        for (final order in snapshot.whaleOrders) ...[
          _WhaleOrderCard(order: order, baseAsset: snapshot.pair.baseAsset),
          if (order != snapshot.whaleOrders.last) const SizedBox(height: 16),
        ],
        const SizedBox(height: 16),
        _WhaleSummary(orders: snapshot.whaleOrders),
      ],
    );
  }
}

class _WhaleWarningCard extends StatelessWidget {
  const _WhaleWarningCard();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: AppColors.warn15,
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppColors.warn,
            size: 18,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cảnh báo cá voi',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Các lệnh lớn bất thường trong sổ lệnh BTC/USDT. Không phải tín hiệu giao dịch, chỉ mang tính tham khảo.',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WhaleOrderCard extends StatelessWidget {
  const _WhaleOrderCard({required this.order, required this.baseAsset});

  final MarketWhaleOrder order;
  final String baseAsset;

  @override
  Widget build(BuildContext context) {
    final buy = order.side == MarketOrderSide.buy;
    final color = buy ? AppColors.buy : AppColors.sell;
    return VitCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color.withValues(alpha: .1),
              borderRadius: AppRadii.mdRadius,
            ),
            child: const Icon(Icons.waves_rounded, color: AppColors.text2),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: .12),
                        borderRadius: AppRadii.smRadius,
                      ),
                      child: Text(
                        buy ? 'MUA' : 'BÁN',
                        style: AppTextStyles.micro.copyWith(
                          color: color,
                          fontWeight: AppTextStyles.bold,
                          height: 1,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      order.timeAgo,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  '${order.quantity.toStringAsFixed(4)} $baseAsset',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '@ \$${formatMarketDepthPrice(order.price)}  ≈ ${formatMarketDepthCompact(order.usdValue, prefix: r'$')}',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WhaleSummary extends StatelessWidget {
  const _WhaleSummary({required this.orders});

  final List<MarketWhaleOrder> orders;

  @override
  Widget build(BuildContext context) {
    final buyOrders = [
      for (final order in orders)
        if (order.side == MarketOrderSide.buy) order,
    ];
    final sellOrders = [
      for (final order in orders)
        if (order.side == MarketOrderSide.sell) order,
    ];
    return Row(
      children: [
        Expanded(
          child: _WhaleSummaryCard(
            count: buyOrders.length,
            label: 'Lệnh mua lớn',
            total: buyOrders.fold<double>(
              0,
              (sum, order) => sum + order.usdValue,
            ),
            color: AppColors.buy,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _WhaleSummaryCard(
            count: sellOrders.length,
            label: 'Lệnh bán lớn',
            total: sellOrders.fold<double>(
              0,
              (sum, order) => sum + order.usdValue,
            ),
            color: AppColors.sell,
          ),
        ),
      ],
    );
  }
}

class _WhaleSummaryCard extends StatelessWidget {
  const _WhaleSummaryCard({
    required this.count,
    required this.label,
    required this.total,
    required this.color,
  });

  final int count;
  final String label;
  final double total;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Text(
            '$count',
            style: AppTextStyles.baseMedium.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: 2),
          Text(
            formatMarketDepthCompact(total, prefix: r'$'),
            style: AppTextStyles.micro.copyWith(
              color: color,
              fontWeight: AppTextStyles.medium,
            ),
          ),
        ],
      ),
    );
  }
}
