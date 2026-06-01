part of '../pages/copy_audit_log_page.dart';

class _SummarySection extends StatelessWidget {
  const _SummarySection({required this.events});

  final List<TradeCopyAuditEvent> events;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            'Thống kê tổng quan',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text2,
              fontSize: 12,
              fontWeight: AppTextStyles.bold,
              height: 1,
            ),
          ),
        ),
        const SizedBox(height: 13),
        Row(
          children: [
            Expanded(
              child: _SummaryCard(
                label: 'Total Events',
                value: '${events.length}',
                color: AppColors.text1,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _SummaryCard(
                label: 'Trades',
                value: '${_count(events, TradeCopyAuditEventType.trade)}',
                color: _auditPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _SummaryCard(
                label: 'Config Changes',
                value: '${_count(events, TradeCopyAuditEventType.config)}',
                color: _auditPurple,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _SummaryCard(
                label: 'Risk Alerts',
                value: '${_count(events, TradeCopyAuditEventType.risk)}',
                color: AppColors.sell,
              ),
            ),
          ],
        ),
      ],
    );
  }

  static int _count(
    List<TradeCopyAuditEvent> events,
    TradeCopyAuditEventType type,
  ) {
    return events.where((event) => event.type == type).length;
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 69,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: _auditPanel,
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 10,
              height: 1,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: AppTextStyles.sectionTitle.copyWith(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.w800,
              height: 1,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExportFormatButton extends StatelessWidget {
  const _ExportFormatButton({
    super.key,
    required this.format,
    required this.onTap,
  });

  final TradeCopyAuditExportFormat format;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.inputRadius,
      child: Container(
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: _auditChip,
          borderRadius: AppRadii.inputRadius,
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    format.label,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontSize: 13,
                      fontWeight: AppTextStyles.bold,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    format.description,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      fontSize: 10,
                      height: 1.1,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.file_download_outlined,
              color: AppColors.text3,
              size: 17,
            ),
          ],
        ),
      ),
    );
  }
}

bool _hasVisibleMetadata(TradeCopyAuditEvent event) {
  final metadata = event.metadata;
  if (metadata == null) return false;
  if (event.type == TradeCopyAuditEventType.config) {
    return metadata.oldValue != null || metadata.newValue != null;
  }
  return metadata.providerPrice != null ||
      metadata.yourPrice != null ||
      metadata.slippagePct != null ||
      metadata.pnl != null;
}

IconData _eventIcon(TradeCopyAuditEvent event) {
  return switch (event.type) {
    TradeCopyAuditEventType.trade => Icons.show_chart_rounded,
    TradeCopyAuditEventType.config => Icons.settings_outlined,
    TradeCopyAuditEventType.risk => Icons.error_outline_rounded,
    TradeCopyAuditEventType.system => Icons.check_circle_outline_rounded,
  };
}

Color _eventColor(TradeCopyAuditEvent event) {
  if (event.severity == TradeCopyAuditSeverity.critical) {
    return AppColors.sell;
  }
  if (event.severity == TradeCopyAuditSeverity.warning) {
    return _auditAmber;
  }
  return switch (event.type) {
    TradeCopyAuditEventType.trade => _auditPrimary,
    TradeCopyAuditEventType.config => _auditPurple,
    TradeCopyAuditEventType.risk => AppColors.sell,
    TradeCopyAuditEventType.system => _auditGreen,
  };
}

String _eventTypeLabel(TradeCopyAuditEventType type) {
  return switch (type) {
    TradeCopyAuditEventType.trade => 'TRADE',
    TradeCopyAuditEventType.config => 'CONFIG',
    TradeCopyAuditEventType.risk => 'RISK',
    TradeCopyAuditEventType.system => 'SYSTEM',
  };
}

String _formatUsd(double value) {
  return '\$${_formatNumber(value.round())}';
}

String _formatSignedUsd(double value) {
  final sign = value >= 0 ? '+' : '-';
  return '$sign\$${_formatNumber(value.abs().round())}';
}

String _formatNumber(int value) {
  final chars = value.toString().split('').reversed.toList();
  final groups = <String>[];
  for (var i = 0; i < chars.length; i += 3) {
    groups.add(chars.skip(i).take(3).toList().reversed.join());
  }
  return groups.reversed.join(',');
}
