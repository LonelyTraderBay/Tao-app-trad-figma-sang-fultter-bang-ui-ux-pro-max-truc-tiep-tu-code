part of 'savings_ladder_page.dart';

class _SmallPill extends StatelessWidget {
  const _SmallPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: .14),
      borderRadius: AppRadii.xsRadius,
      child: Padding(
        padding: AppSpacing.earnSmallPillPadding,
        child: Text(label, style: _microBold.copyWith(color: color)),
      ),
    );
  }
}

class _RoundIcon extends StatelessWidget {
  const _RoundIcon({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: AppSpacing.savingsLadderRoundIcon,
      child: Material(
        color: color.withValues(alpha: .12),
        borderRadius: AppRadii.mdRadius,
        child: Icon(icon, color: color, size: AppSpacing.iconSm),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value, this.color});

  final String label;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.earnVerticalPaddingX1,
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(color: AppColors.text3),
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: _captionBold.copyWith(
                color: color ?? AppColors.text1,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Disclaimer extends StatelessWidget {
  const _Disclaimer({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.ghost,
      borderColor: AppColors.warningBorder,
      density: VitDensity.compact,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.warn,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                height: _disclaimerLineHeight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyTab extends StatelessWidget {
  const _EmptyTab({required this.icon, required this.title, required this.cta});

  final IconData icon;
  final String title;
  final String cta;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.large,
      density: VitDensity.compact,
      child: Column(
        children: [
          Icon(icon, color: AppColors.text3, size: AppSpacing.iconLg),
          const SizedBox(height: AppSpacing.x2),
          Text(
            title,
            textAlign: TextAlign.center,
            style: _captionBold.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: AppSpacing.x2),
          VitCtaButton(fullWidth: false, onPressed: () {}, child: Text(cta)),
        ],
      ),
    );
  }
}

SavingsLadderTemplateDraft _templateById(
  SavingsLadderSnapshot snapshot,
  SavingsLadderPreset id,
) {
  return snapshot.templates.firstWhere(
    (template) => template.id == id,
    orElse: () => snapshot.templates.first,
  );
}

List<SavingsLadderRungDraft> _generateRungs(
  SavingsLadderTemplateDraft template,
  int amountUsd,
) {
  if (template.intervals.isEmpty) return const [];
  return [
    for (var i = 0; i < template.intervals.length; i++)
      SavingsLadderRungDraft(
        id: 'rung-${i + 1}',
        product: template.intervals[i].product,
        asset: template.intervals[i].asset,
        colorKey: template.intervals[i].colorKey,
        lockDays: template.intervals[i].lockDays,
        apyPct: template.intervals[i].apyPct,
        amountUsd:
            (amountUsd * template.intervals[i].allocationPct / 100 * 100)
                .round() /
            100,
        startDate: _today,
        maturityDate: _addDays(_today, template.intervals[i].lockDays + i * 30),
        autoRenew: true,
      ),
  ];
}

double _totalAllocated(List<SavingsLadderRungDraft> rungs) {
  return rungs.fold<double>(0, (total, rung) => total + rung.amountUsd);
}

double _weightedApy(List<SavingsLadderRungDraft> rungs) {
  final total = _totalAllocated(rungs);
  if (total <= 0) return 0;
  return rungs.fold<double>(
        0,
        (sum, rung) => sum + (rung.apyPct * rung.amountUsd),
      ) /
      total;
}

double _annualInterest(List<SavingsLadderRungDraft> rungs) {
  return rungs.fold<double>(
    0,
    (sum, rung) => sum + rung.amountUsd * rung.apyPct / 100,
  );
}

double _interestForTerm(SavingsLadderRungDraft rung) {
  return rung.amountUsd * rung.apyPct / 100 * rung.lockDays / 365;
}

int _liquidityScore(List<SavingsLadderRungDraft> rungs) {
  final total = _totalAllocated(rungs);
  if (rungs.isEmpty || total <= 0) return 0;
  final uniqueDays = rungs.map((rung) => rung.lockDays).toSet().length;
  final shortTermUsd = rungs
      .where((rung) => rung.lockDays <= 30)
      .fold<double>(0, (sum, rung) => sum + rung.amountUsd);
  final diversityScore = math.min(uniqueDays / 3 * 40, 40);
  final shortTermScore = math.min((shortTermUsd / total * 100) / 40 * 30, 30);
  final spreadScore = math.min(rungs.length / 6 * 30, 30);
  return (diversityScore + shortTermScore + spreadScore).round();
}

String _addDays(String from, int days) {
  final parts = from.split('/').map(int.parse).toList();
  final date = DateTime(parts[2], parts[1], parts[0]).add(Duration(days: days));
  return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
}

String _money(num value) {
  final fixed = value.toStringAsFixed(2);
  final parts = fixed.split('.');
  final whole = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    if (i > 0 && (whole.length - i) % 3 == 0) buffer.write(',');
    buffer.write(whole[i]);
  }
  return '\$$buffer.${parts.last}';
}

String _compactAmount(int value) {
  if (value >= 1000) return '${value ~/ 1000}K';
  return '$value';
}

IconData _iconFor(String key) {
  return switch (key) {
    'calendar' => Icons.calendar_today_rounded,
    'bars' => Icons.bar_chart_rounded,
    'layers' => Icons.layers_rounded,
    'sliders' => Icons.tune_rounded,
    _ => Icons.savings_outlined,
  };
}

Color _toneColor(EarnRiskLevel tone) {
  return switch (tone) {
    EarnRiskLevel.low => AppColors.buy,
    EarnRiskLevel.medium => AppColors.primary,
    EarnRiskLevel.high => AppColors.accent,
  };
}

Color _colorFor(String colorKey) {
  return switch (colorKey) {
    'buy' => AppColors.buy,
    'primary' => AppColors.primary,
    'warn' => AppColors.warn,
    'accent' => AppColors.accent,
    'sell' => AppColors.sell,
    _ => AppColors.text3,
  };
}

Color _liquidityColor(int score) {
  if (score >= 70) return AppColors.buy;
  if (score >= 40) return AppColors.warn;
  return AppColors.sell;
}
