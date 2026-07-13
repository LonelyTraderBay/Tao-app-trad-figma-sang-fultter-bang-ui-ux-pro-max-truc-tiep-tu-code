part of '../pages/cass_reconciliation_page.dart';

class _RecordCard extends StatelessWidget {
  const _RecordCard({required this.record});

  final TradeCassReconciliationRecord record;

  @override
  Widget build(BuildContext context) {
    final tone = _toneFor(record.status);
    return VitCard(
      key: CassReconciliationPage.recordKey(record.id),
      density: VitDensity.compact,
      padding: AppSpacing.cardPaddingCompact,
      borderColor: _cassBorder.withValues(alpha: .72),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // card-tile: allow-start — fixed surface, not horizontal strip tile
              VitCard(
                width: _recordIconTile,
                height: _recordIconTile,
                variant: VitCardVariant.inner,
                density: VitDensity.compact,
                padding: AppSpacing.zeroInsets,
                borderColor: tone.color.withValues(alpha: .24),
                alignment: Alignment.center,
                child: Icon(tone.icon, color: tone.color, size: AppSpacing.x4),
              ),
              const SizedBox(width: _cassSpace),
              Expanded(
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
                        const SizedBox(width: _cassTinySpace),
                        VitAccentPill(
                          label: tone.label,
                          accentColor: tone.color,
                        ),
                      ],
                    ),
                    if (record.notes != null) ...[
                      const SizedBox(height: _cassTinySpace),
                      Text(
                        record.notes!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                          height: _cassLineTight,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: _cassSpace),
          Row(
            children: [
              Expanded(
                child: _MetricBox(
                  label: 'Client Ledger',
                  value: _formatUsd(record.clientLedger),
                ),
              ),
              const SizedBox(width: _cassTinySpace),
              Expanded(
                child: _MetricBox(
                  label: 'Bank Balance',
                  value: _formatUsd(record.bankBalance),
                ),
              ),
              const SizedBox(width: _cassTinySpace),
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
    return VitCard(
      variant: VitCardVariant.inner,
      density: VitDensity.compact,
      padding: AppSpacing.cardPaddingCompact,
      borderColor: background.withValues(alpha: .24),
      background: ColoredBox(color: background),
      clip: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: _cassLineTight,
            ),
          ),
          const SizedBox(height: _cassTinySpace),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: valueColor,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
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
      onPressed: () {
        HapticFeedback.selectionClick();
        showVitNoticeSheet(
          context: context,
          title: 'Sắp ra mắt',
          message: 'Xuất báo cáo đối chiếu CASS sẽ sớm ra mắt',
        );
      },
      variant: VitCtaButtonVariant.secondary,
      height: _exportButtonHeight,
      leading: const Icon(Icons.download_rounded, size: AppSpacing.x4),
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
    return VitSectionHeader(
      title: text,
      bottomGap: AppSpacing.pageRhythmStandardInnerGap,
      variant: VitSectionHeaderVariant.accentBar,
      accentColor: _cassPrimary,
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
