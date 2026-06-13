import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/transaction_reporting_common.dart';

class TransactionReportsSection extends StatelessWidget {
  const TransactionReportsSection({
    required this.reports,
    required this.query,
    required this.onViewXml,
    required this.onRetry,
    required this.onCopy,
    super.key,
  });

  final List<TradeTransactionReport> reports;
  final String query;
  final ValueChanged<TradeTransactionReport> onViewXml;
  final ValueChanged<TradeTransactionReport> onRetry;
  final ValueChanged<TradeTransactionReport> onCopy;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '${reports.length} Reports',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text3,
            fontWeight: AppTextStyles.bold,
            height: 1,
          ),
        ),
        const SizedBox(height: 12),
        if (reports.isEmpty)
          _EmptyReports(query: query)
        else
          for (final report in reports) ...[
            _ReportCard(
              report: report,
              onViewXml: () => onViewXml(report),
              onRetry: () => onRetry(report),
              onCopy: () => onCopy(report),
            ),
            if (report != reports.last) const SizedBox(height: 12),
          ],
      ],
    );
  }
}

class _ReportCard extends StatelessWidget {
  const _ReportCard({
    required this.report,
    required this.onViewXml,
    required this.onRetry,
    required this.onCopy,
  });

  final TradeTransactionReport report;
  final VoidCallback onViewXml;
  final VoidCallback onRetry;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    final status = transactionReportStatusConfig(report.status);
    final sla = transactionReportSlaConfig(report.slaStatus);
    final sideColor = report.side == 'buy'
        ? transactionReportGreen
        : transactionReportRed;

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
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
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: status.color.withValues(alpha: .13),
              borderRadius: AppRadii.cardRadius,
            ),
            child: Icon(status.icon, color: status.color, size: 19),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  report.instrument,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.text1,
                                    fontWeight: AppTextStyles.bold,
                                    height: 1,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 7),
                              _SmallPill(
                                label: report.side.toUpperCase(),
                                color: sideColor,
                              ),
                            ],
                          ),
                          const SizedBox(height: 7),
                          Text(
                            '${report.transactionId} - ${report.tradingVenue}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.micro.copyWith(
                              color: AppColors.text3,
                              height: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _SmallPill(label: status.label, color: status.color),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _DetailValue(
                        label: 'Qty',
                        value: formatTransactionReportAmount(report.quantity),
                      ),
                    ),
                    Expanded(
                      child: _DetailValue(
                        label: 'Value',
                        value: formatTransactionReportUsd(report.value),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 7),
                Row(
                  children: [
                    Expanded(
                      child: _DetailValue(
                        label: 'ARM',
                        value: report.armProvider,
                      ),
                    ),
                    Expanded(
                      child: _DetailValue(
                        label: 'Type',
                        value: report.reportType.toUpperCase(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: sla.color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      sla.label,
                      style: AppTextStyles.micro.copyWith(
                        color: sla.color,
                        fontWeight: AppTextStyles.bold,
                        height: 1,
                      ),
                    ),
                  ],
                ),
                if (report.errorMessage != null) ...[
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.fromLTRB(9, 8, 9, 8),
                    decoration: BoxDecoration(
                      color: transactionReportRed.withValues(alpha: .10),
                      border: Border.all(
                        color: transactionReportRed.withValues(alpha: .28),
                      ),
                      borderRadius: AppRadii.smRadius,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.warning_amber_rounded,
                          color: transactionReportRed,
                          size: 13,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            report.errorMessage!,
                            style: AppTextStyles.micro.copyWith(
                              color: transactionReportRed,
                              height: 1.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _ActionChip(
                      label: 'View XML',
                      icon: Icons.visibility_outlined,
                      onTap: onViewXml,
                    ),
                    if (report.status == 'failed')
                      _ActionChip(
                        label: 'Retry',
                        icon: Icons.refresh_rounded,
                        color: AppColors.primary,
                        onTap: onRetry,
                      ),
                    if (report.messageId != null)
                      _ActionChip(
                        label: 'Copy ID',
                        icon: Icons.copy_rounded,
                        onTap: onCopy,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailValue extends StatelessWidget {
  const _DetailValue({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            height: 1,
          ),
        ),
        Flexible(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
              height: 1,
            ),
          ),
        ),
      ],
    );
  }
}

class _ActionChip extends StatelessWidget {
  const _ActionChip({
    required this.label,
    required this.icon,
    required this.onTap,
    this.color = AppColors.text2,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(9),
      child: Container(
        height: 30,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: color == AppColors.text2 ? .08 : .14),
          borderRadius: BorderRadius.circular(9),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 13),
            const SizedBox(width: 6),
            Text(
              label,
              style: AppTextStyles.micro.copyWith(
                color: color,
                fontWeight: AppTextStyles.bold,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SmallPill extends StatelessWidget {
  const _SmallPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .13),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
    );
  }
}

class _EmptyReports extends StatelessWidget {
  const _EmptyReports({required this.query});

  final String query;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 42, horizontal: 16),
      decoration: BoxDecoration(
        color: transactionReportPanel,
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        children: [
          Icon(
            Icons.storage_outlined,
            color: AppColors.text3.withValues(alpha: .5),
            size: 48,
          ),
          const SizedBox(height: 12),
          Text(
            'No reports found',
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: 6),
          Text(
            query.isEmpty
                ? 'Reports will appear here automatically'
                : 'Try a different search term',
            textAlign: TextAlign.center,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

