part of '../pages/ex_post_costs_report_page.dart';

class _VarianceNote {
  const _VarianceNote({required this.amount, required this.kind});

  factory _VarianceNote.lower(double amount) {
    return _VarianceNote(amount: amount, kind: _VarianceNoteKind.lower);
  }

  factory _VarianceNote.higher(double amount) {
    return _VarianceNote(amount: amount, kind: _VarianceNoteKind.higher);
  }

  final double amount;
  final _VarianceNoteKind kind;
}

enum _VarianceNoteKind { lower, higher }

class _VarianceNoteView extends StatelessWidget {
  const _VarianceNoteView({required this.note});

  final _VarianceNote note;

  @override
  Widget build(BuildContext context) {
    final isHigher = note.kind == _VarianceNoteKind.higher;
    final color = isHigher ? _reportAmber : AppColors.text1;
    final bg = isHigher
        ? _reportAmber.withValues(alpha: .12)
        : AppColors.transparent;
    final text = isHigher
        ? '${_formatEur(note.amount)} higher (better performance)'
        : '${_formatEur(note.amount)} lower than estimated';

    return VitCard(
      variant: VitCardVariant.ghost,
      width: double.infinity,
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: AppSpacing.x2,
        vertical: isHigher ? AppSpacing.x2 : AppSpacing.x1,
      ),
      borderColor: isHigher ? _reportAmber.withValues(alpha: .26) : null,
      background: ColoredBox(color: bg),
      child: Row(
        children: [
          Icon(
            isHigher ? Icons.warning_amber_rounded : Icons.check_rounded,
            color: color,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.micro.copyWith(
                color: color,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VarianceCard extends StatelessWidget {
  const _VarianceCard({required this.report});

  final TradeExPostCostReport report;

  @override
  Widget build(BuildContext context) {
    final variance = report.variance;
    final higher = variance > 0;
    final text = higher
        ? 'Actual costs were ${_formatEur(variance.abs())} higher than '
              'estimated, mainly due to higher performance fees.'
        : variance < 0
        ? 'Actual costs were ${_formatEur(variance.abs())} lower than '
              'estimated, mainly due to lower transaction costs.'
        : 'Actual costs matched estimates exactly.';

    return _Card(
      padding: VitDensity.compact.cardPadding,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Total Variance',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              Text(
                '${higher
                    ? '+'
                    : variance < 0
                    ? '-'
                    : ''}'
                '${_formatEur(variance.abs())}',
                style: AppTextStyles.amountSm.copyWith(
                  color: higher ? _reportRed : _reportGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x2),
          VitCard(
            variant: VitCardVariant.inner,
            width: double.infinity,
            padding: const EdgeInsetsDirectional.symmetric(
              horizontal: AppSpacing.x3,
              vertical: AppSpacing.x2,
            ),
            child: Text(
              text,
              style: AppTextStyles.micro.copyWith(color: AppColors.text2),
            ),
          ),
        ],
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
      variant: VitSectionHeaderVariant.accentBar,
      accentColor: _reportPrimary,
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child, required this.padding});

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: padding,
      borderColor: _reportBorder.withValues(alpha: .72),
      child: child,
    );
  }
}

String _formatEur(double value) {
  final rounded = value.round();
  final absolute = rounded.abs().toString();
  final buffer = StringBuffer();
  for (var index = 0; index < absolute.length; index += 1) {
    if (index > 0 && (absolute.length - index) % 3 == 0) {
      buffer.write(',');
    }
    buffer.write(absolute[index]);
  }
  final sign = rounded < 0 ? '-' : '';
  return '$sign€${buffer.toString()}';
}
