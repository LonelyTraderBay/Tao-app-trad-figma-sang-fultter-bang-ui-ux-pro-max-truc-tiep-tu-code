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

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(isHigher ? 10 : 8, 8, 10, 8),
      decoration: BoxDecoration(color: bg, borderRadius: AppRadii.inputRadius),
      child: Row(
        children: [
          Icon(
            isHigher ? Icons.warning_amber_rounded : Icons.check_rounded,
            color: color,
            size: 11,
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.micro.copyWith(
                color: color,
                fontSize: 9,
                fontWeight: AppTextStyles.bold,
                height: 1,
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
      padding: const EdgeInsets.fromLTRB(16, 21, 16, 16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Total Variance',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontSize: 13,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
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
                style: AppTextStyles.baseMedium.copyWith(
                  color: higher ? _reportRed : _reportGreen,
                  fontSize: 18,
                  height: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(12, 13, 12, 12),
            decoration: BoxDecoration(
              color: _reportPanel2,
              borderRadius: AppRadii.inputRadius,
            ),
            child: Text(
              text,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text2,
                fontSize: 10,
                height: 1.35,
              ),
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
    return Row(
      children: [
        Container(
          width: 4,
          height: 14,
          decoration: BoxDecoration(
            color: _reportPrimary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 7),
        Text(
          text,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text2,
            fontSize: 11,
            fontWeight: AppTextStyles.bold,
            height: 1,
          ),
        ),
      ],
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child, required this.padding});

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: _reportPanel,
        border: Border.all(color: _reportBorder.withValues(alpha: .72)),
        borderRadius: AppRadii.cardRadius,
      ),
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
