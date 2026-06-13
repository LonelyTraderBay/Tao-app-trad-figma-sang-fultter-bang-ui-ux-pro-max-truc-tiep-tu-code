part of '../pages/cass_reconciliation_page.dart';

class _RecordCard extends StatelessWidget {
  const _RecordCard({required this.record});

  final TradeCassReconciliationRecord record;

  @override
  Widget build(BuildContext context) {
    final tone = _toneFor(record.status);
    return VitCard(
      key: CassReconciliationPage.recordKey(record.id),
      padding: const EdgeInsets.fromLTRB(16, 17, 16, 16),
      borderColor: _cassBorder.withValues(alpha: .72),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: tone.color.withValues(alpha: .13),
                  borderRadius: AppRadii.inputRadius,
                ),
                child: Icon(tone.icon, color: tone.color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              record.displayDate,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.text1,
                                fontWeight: AppTextStyles.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          _StatusPill(label: tone.label, color: tone.color),
                        ],
                      ),
                      if (record.notes != null) ...[
                        const SizedBox(height: 9),
                        Text(
                          record.notes!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                            height: 1,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 9),
          Row(
            children: [
              Expanded(
                child: _MetricBox(
                  label: 'Client Ledger',
                  value: _formatUsd(record.clientLedger),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _MetricBox(
                  label: 'Bank Balance',
                  value: _formatUsd(record.bankBalance),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _MetricBox(
                  label: 'Difference',
                  value: _formatUsd(record.difference.abs()),
                  valueColor: record.difference == 0 ? _cassGreen : tone.color,
                  background: record.difference == 0
                      ? _cassGreen.withValues(alpha: .13)
                      : tone.color.withValues(alpha: .13),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricBox extends StatelessWidget {
  const _MetricBox({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
    this.background = _cassPanel2,
  });

  final String label;
  final String value;
  final Color valueColor;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 47,
      padding: const EdgeInsets.fromLTRB(8, 9, 8, 8),
      decoration: BoxDecoration(
        color: background,
        borderRadius: AppRadii.inputRadius,
      ),
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
          const Spacer(),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.captionSm.copyWith(
              color: valueColor,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .13),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

class _ExportButton extends StatelessWidget {
  const _ExportButton();

  @override
  Widget build(BuildContext context) {
    return VitCtaButton(
      key: CassReconciliationPage.exportKey,
      onPressed: () {},
      variant: VitCtaButtonVariant.secondary,
      height: 44,
      leading: const Icon(Icons.download_rounded, size: 16),
      child: Text(
        'Export Reconciliation Report (CSV)',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.caption.copyWith(
          color: AppColors.text1,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 14,
          decoration: BoxDecoration(
            color: _cassPrimary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 7),
        Text(
          text,
          style: AppTextStyles.captionSm.copyWith(
            color: AppColors.text2,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}

_RecordTone _toneFor(TradeCassReconciliationStatus status) {
  return switch (status) {
    TradeCassReconciliationStatus.matched => const _RecordTone(
      label: 'Matched',
      color: _cassGreen,
      icon: Icons.check_circle_outline_rounded,
    ),
    TradeCassReconciliationStatus.discrepancyResolved => const _RecordTone(
      label: 'Resolved',
      color: _cassAmber,
      icon: Icons.check_circle_outline_rounded,
    ),
    TradeCassReconciliationStatus.discrepancy => const _RecordTone(
      label: 'Discrepancy',
      color: _cassRed,
      icon: Icons.warning_amber_rounded,
    ),
  };
}

final class _RecordTone {
  const _RecordTone({
    required this.label,
    required this.color,
    required this.icon,
  });

  final String label;
  final Color color;
  final IconData icon;
}

String _formatUsd(double value) {
  final fixed = value.toStringAsFixed(2);
  final parts = fixed.split('.');
  final whole = parts.first;
  final buffer = StringBuffer();
  for (var index = 0; index < whole.length; index += 1) {
    if (index > 0 && (whole.length - index) % 3 == 0) {
      buffer.write(',');
    }
    buffer.write(whole[index]);
  }
  return '\$${buffer.toString()}.${parts.last}';
}
