part of '../pages/performance_scenarios_page.dart';

class _WarningNotice extends StatelessWidget {
  const _WarningNotice();

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 70),
      padding: const EdgeInsets.fromLTRB(13, 12, 13, 12),
      decoration: BoxDecoration(
        color: _scenarioAmber.withValues(alpha: .09),
        border: Border.all(color: _scenarioAmber.withValues(alpha: .38)),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Icon(
              Icons.warning_amber_rounded,
              color: _scenarioAmber,
              size: 16,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Not a Guarantee',
                  style: AppTextStyles.caption.copyWith(
                    color: _scenarioAmber,
                    fontSize: 11,
                    fontWeight: AppTextStyles.bold,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'These scenarios are illustrations based on past '
                  'performance and statistical models. Actual results may '
                  'differ significantly.',
                  style: AppTextStyles.micro.copyWith(
                    color: _scenarioAmber,
                    fontSize: 10,
                    fontWeight: AppTextStyles.medium,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InvestmentCard extends StatelessWidget {
  const _InvestmentCard({required this.investment});

  final double investment;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.fromLTRB(16, 17, 16, 18),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Example Investment',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 11,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _formatEur(investment),
            style: AppTextStyles.heroNumber.copyWith(
              color: AppColors.text1,
              fontSize: 28,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _HoldingPeriodSelector extends StatelessWidget {
  const _HoldingPeriodSelector({
    required this.periods,
    required this.selectedPeriod,
    required this.onChanged,
  });

  final List<int> periods;
  final int selectedPeriod;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final period in periods) ...[
          Expanded(
            child: SizedBox(
              height: 32,
              child: TextButton(
                key: PerformanceScenariosPage.periodKey(period),
                onPressed: () => onChanged(period),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  backgroundColor: selectedPeriod == period
                      ? _scenarioPrimary
                      : _scenarioPanel2,
                  foregroundColor: selectedPeriod == period
                      ? AppColors.onAccent
                      : AppColors.text2,
                  shape: const StadiumBorder(),
                ),
                child: Text(
                  '$period ${period == 1 ? 'Year' : 'Years'}',
                  style: AppTextStyles.caption.copyWith(
                    color: selectedPeriod == period
                        ? AppColors.onAccent
                        : AppColors.text2,
                    fontSize: 12,
                    fontWeight: selectedPeriod == period
                        ? AppTextStyles.bold
                        : AppTextStyles.medium,
                    height: 1,
                  ),
                ),
              ),
            ),
          ),
          if (period != periods.last) const SizedBox(width: 8),
        ],
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 15,
          decoration: BoxDecoration(
            color: _scenarioPrimary,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 7),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontSize: 12,
            fontWeight: AppTextStyles.bold,
            height: 1,
          ),
        ),
      ],
    );
  }
}
