part of '../pages/ex_ante_costs_page.dart';

class _Scenarios extends StatelessWidget {
  const _Scenarios({
    required this.snapshot,
    required this.holdingPeriod,
    required this.onChanged,
  });

  final TradeExAnteCostsSnapshot snapshot;
  final int holdingPeriod;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final total =
        snapshot.oneOffCosts +
        (snapshot.recurringCosts * holdingPeriod) +
        (snapshot.incidentalCosts * holdingPeriod);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionLabel('Cost Scenarios by Holding Period'),
        const SizedBox(height: 12),
        Row(
          children: [
            for (final period in const [1, 3, 5]) ...[
              Expanded(
                child: _PeriodButton(
                  label: '$period ${period == 1 ? 'Year' : 'Years'}',
                  selected: holdingPeriod == period,
                  onPressed: () => onChanged(period),
                ),
              ),
              if (period != 5) const SizedBox(width: 8),
            ],
          ],
        ),
        const SizedBox(height: 12),
        _Card(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Total Costs Over $holdingPeriod '
                '${holdingPeriod == 1 ? 'Year' : 'Years'}',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontSize: 14,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: 12),
              _ScenarioRow(label: 'One-off Costs', value: snapshot.oneOffCosts),
              _ScenarioRow(
                label: 'Recurring Costs ($holdingPeriod years)',
                value: snapshot.recurringCosts * holdingPeriod,
              ),
              _ScenarioRow(
                label: 'Incidental Costs (estimated)',
                value: snapshot.incidentalCosts * holdingPeriod,
              ),
              Container(
                margin: const EdgeInsets.only(top: 4),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _costRed.withValues(alpha: .13),
                  borderRadius: AppRadii.smRadius,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Total',
                        style: AppTextStyles.caption.copyWith(
                          color: _costRed,
                          fontSize: 12,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                    Text(
                      _formatEur(total),
                      style: AppTextStyles.baseMedium.copyWith(
                        color: _costRed,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _QuickLinks extends StatelessWidget {
  const _QuickLinks();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _QuickLinkButton(
            key: ExAnteCostsPage.exPostKey,
            icon: Icons.description_outlined,
            label: 'Ex-Post Report',
            color: _costPrimary,
            onPressed: () =>
                context.go(AppRoutePaths.tradeCopyExPostCostsReport),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _QuickLinkButton(
            key: ExAnteCostsPage.kidKey,
            icon: Icons.bar_chart_rounded,
            label: 'View KID',
            color: _costGreen,
            onPressed: () => context.go(AppRoutePaths.tradeCopyKidGenerator),
          ),
        ),
      ],
    );
  }
}

class _QuickLinkButton extends StatelessWidget {
  const _QuickLinkButton({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return VitCtaButton(
      onPressed: onPressed,
      variant: VitCtaButtonVariant.secondary,
      height: 44,
      leading: Icon(icon, color: color),
      trailing: const Icon(Icons.chevron_right_rounded),
      child: Text(label),
    );
  }
}

class _FullWidthButton extends StatelessWidget {
  const _FullWidthButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return VitCtaButton(
      onPressed: onPressed,
      variant: VitCtaButtonVariant.secondary,
      height: 44,
      leading: Icon(icon),
      child: Text(label),
    );
  }
}

class _MetricBox extends StatelessWidget {
  const _MetricBox({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 9),
      decoration: BoxDecoration(
        color: _costPanel2,
        borderRadius: AppRadii.inputRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 9,
              height: 1,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: AppTextStyles.caption.copyWith(
              color: valueColor,
              fontSize: 14,
              fontWeight: AppTextStyles.bold,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _WarningBox extends StatelessWidget {
  const _WarningBox({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 11, 12, 10),
      decoration: BoxDecoration(
        color: _costAmber.withValues(alpha: .13),
        borderRadius: AppRadii.inputRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline_rounded, color: _costAmber, size: 14),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.micro.copyWith(
                color: _costAmber,
                fontSize: 10,
                fontWeight: AppTextStyles.bold,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PeriodButton extends StatelessWidget {
  const _PeriodButton({
    required this.label,
    required this.selected,
    required this.onPressed,
  });

  final String label;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: selected ? _costPrimary : _costPanel2,
          foregroundColor: selected ? AppColors.onAccent : AppColors.text2,
          shape: const StadiumBorder(),
        ),
        onPressed: onPressed,
        child: Text(label, style: AppTextStyles.micro.copyWith(fontSize: 12)),
      ),
    );
  }
}

class _ScenarioRow extends StatelessWidget {
  const _ScenarioRow({required this.label, required this.value});

  final String label;
  final double value;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: _costPanel2,
        borderRadius: AppRadii.smRadius,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text3,
                fontSize: 11,
              ),
            ),
          ),
          Text(
            _formatEur(value),
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontSize: 12,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}
