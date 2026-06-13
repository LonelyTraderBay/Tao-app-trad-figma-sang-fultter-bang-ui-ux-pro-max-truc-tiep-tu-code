import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/transaction_reporting_common.dart';

class TransactionReportingStatsGrid extends StatelessWidget {
  const TransactionReportingStatsGrid({required this.stats, super.key});

  final TradeTransactionReportingStats stats;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            label: 'Total Today',
            value: '${stats.total}',
            caption: '${stats.confirmed} confirmed',
            color: AppColors.primary,
            icon: Icons.description_outlined,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            label: 'Avg Latency',
            value: '${stats.avgLatencySeconds}s',
            caption: 'Under 60s SLA',
            color: transactionReportGreen,
            icon: Icons.bolt_rounded,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            label: 'SLA Compliance',
            value: '${(stats.onTime / stats.total * 100).toStringAsFixed(0)}%',
            caption: '${stats.onTime}/${stats.total} on-time',
            color: transactionReportGreen,
            icon: Icons.trending_up_rounded,
          ),
        ),
      ],
    );
  }
}

class TransactionReportingStatsTab extends StatelessWidget {
  const TransactionReportingStatsTab({required this.stats, super.key});

  final TradeTransactionReportingStats stats;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Reporting Statistics',
          style: AppTextStyles.badge.copyWith(
            color: AppColors.text3,
            height: 1,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: transactionReportPanel,
            border: Border.all(
              color: transactionReportBorder.withValues(alpha: .7),
            ),
            borderRadius: AppRadii.cardRadius,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _StatColumn(
                  title: "Today's Volume",
                  rows: [
                    ('MiFID II Reports', '${stats.mifidReports}'),
                    ('EMIR Reports', '${stats.emirReports}'),
                    (
                      'Total Value',
                      formatTransactionReportUsd(stats.totalValue),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: _StatColumn(
                  title: 'ARM Providers',
                  rows: stats.providerCounts.entries
                      .map((entry) => (entry.key, '${entry.value}'))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 44,
          child: FilledButton.icon(
            key: transactionReportingActionKey('dashboard-primary'),
            onPressed: () =>
                context.go(AppRoutePaths.tradeCopyRegulatoryReportsDashboard),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onAccent,
              shape: RoundedRectangleBorder(borderRadius: AppRadii.mdRadius),
            ),
            icon: const Icon(Icons.bar_chart_rounded, size: 17),
            label: const Text('View Full Dashboard'),
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.caption,
    required this.color,
    required this.icon,
  });

  final String label;
  final String value;
  final String caption;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 94,
      padding: const EdgeInsets.fromLTRB(12, 12, 10, 11),
      decoration: BoxDecoration(
        color: transactionReportPanel,
        border: Border.all(
          color: transactionReportBorder.withValues(alpha: .65),
        ),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 9),
                Text(
                  value,
                  style: AppTextStyles.amountSm.copyWith(
                    color: AppColors.text1,
                    height: 1,
                  ),
                ),
                const Spacer(),
                Text(
                  caption,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: color, height: 1),
                ),
              ],
            ),
          ),
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: color.withValues(alpha: .12),
              borderRadius: AppRadii.smRadius,
            ),
            child: Icon(icon, color: color, size: 17),
          ),
        ],
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  const _StatColumn({required this.title, required this.rows});

  final String title;
  final List<(String, String)> rows;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: AppTextStyles.badge.copyWith(
            color: AppColors.text3,
            height: 1,
          ),
        ),
        const SizedBox(height: 11),
        for (final row in rows) ...[
          Row(
            children: [
              Expanded(
                child: Text(
                  row.$1,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.captionSm.copyWith(
                    color: AppColors.text2,
                    height: 1,
                  ),
                ),
              ),
              Text(
                row.$2,
                style: AppTextStyles.numericCode.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                  height: 1,
                ),
              ),
            ],
          ),
          if (row != rows.last) const SizedBox(height: 12),
        ],
      ],
    );
  }
}
