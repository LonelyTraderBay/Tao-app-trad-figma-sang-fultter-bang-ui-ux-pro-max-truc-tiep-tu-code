import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/transaction_reporting_common.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

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
            height: AppSpacing.transactionReportingLineHeightTight,
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
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
            if (report != reports.last) const SizedBox(height: AppSpacing.x4),
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

    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.md,
      padding: AppSpacing.transactionReportingReportCardPadding,
      borderColor: transactionReportBorder.withValues(alpha: .7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          VitCard(
            variant: VitCardVariant.inner,
            radius: VitCardRadius.md,
            width: AppSpacing.searchBarCompactHeight,
            height: AppSpacing.searchBarCompactHeight,
            borderColor: status.color.withValues(alpha: .24),
            alignment: Alignment.center,
            child: Icon(
              status.icon,
              color: status.color,
              size: AppSpacing.transactionReportingStatusIcon,
            ),
          ),
          const SizedBox(width: AppSpacing.x4),
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
                                    height: AppSpacing
                                        .transactionReportingLineHeightTight,
                                  ),
                                ),
                              ),
                              const SizedBox(width: AppSpacing.x3),
                              _SmallPill(
                                label: report.side.toUpperCase(),
                                color: sideColor,
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.x3),
                          Text(
                            '${report.transactionId} - ${report.tradingVenue}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.micro.copyWith(
                              color: AppColors.text3,
                              height: AppSpacing
                                  .transactionReportingLineHeightTight,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _SmallPill(label: status.label, color: status.color),
                  ],
                ),
                const SizedBox(height: AppSpacing.x4),
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
                const SizedBox(height: AppSpacing.x3),
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
                const SizedBox(height: AppSpacing.rowGapRegular),
                Row(
                  children: [
                    Icon(Icons.circle, color: sla.color, size: AppSpacing.x3),
                    const SizedBox(width: AppSpacing.x2),
                    Text(
                      sla.label,
                      style: AppTextStyles.micro.copyWith(
                        color: sla.color,
                        fontWeight: AppTextStyles.bold,
                        height: AppSpacing.transactionReportingLineHeightTight,
                      ),
                    ),
                  ],
                ),
                if (report.errorMessage != null) ...[
                  const SizedBox(height: AppSpacing.rowGapRegular),
                  VitCard(
                    variant: VitCardVariant.inner,
                    radius: VitCardRadius.sm,
                    padding: AppSpacing.transactionReportingErrorPadding,
                    borderColor: transactionReportRed.withValues(alpha: .28),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.warning_amber_rounded,
                          color: transactionReportRed,
                          size: AppSpacing.transactionReportingErrorIcon,
                        ),
                        const SizedBox(width: AppSpacing.x2),
                        Expanded(
                          child: Text(
                            report.errorMessage!,
                            style: AppTextStyles.micro.copyWith(
                              color: transactionReportRed,
                              height: AppSpacing
                                  .transactionReportingErrorLineHeight,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.rowGapRegular),
                Wrap(
                  spacing: AppSpacing.x3,
                  runSpacing: AppSpacing.x3,
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
            height: AppSpacing.transactionReportingLineHeightTight,
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
              height: AppSpacing.transactionReportingLineHeightTight,
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
    return VitCtaButton(
      onPressed: onTap,
      variant: color == AppColors.primary
          ? VitCtaButtonVariant.secondary
          : VitCtaButtonVariant.ghost,
      fullWidth: false,
      height: AppSpacing.buttonCompact,
      padding: AppSpacing.transactionReportingActionPadding,
      leading: Icon(icon, size: AppSpacing.iconSm),
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(fontWeight: AppTextStyles.bold),
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
    return VitAccentPill(label: label, accentColor: color);
  }
}

class _EmptyReports extends StatelessWidget {
  const _EmptyReports({required this.query});

  final String query;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.md,
      child: VitEmptyState(
        icon: Icons.storage_outlined,
        title: 'No reports found',
        message: query.isEmpty
            ? 'Reports will appear here automatically'
            : 'Try a different search term',
      ),
    );
  }
}
