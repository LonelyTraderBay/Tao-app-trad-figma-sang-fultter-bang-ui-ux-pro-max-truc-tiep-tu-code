part of '../pages/dca_performance_compare_page.dart';

class _TopTabs extends StatelessWidget {
  const _TopTabs({required this.activeTab, required this.onChanged});

  final _CompareTab activeTab;
  final ValueChanged<_CompareTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          _TopTab(
            label: 'So sanh',
            tab: _CompareTab.compare,
            active: activeTab == _CompareTab.compare,
            onChanged: onChanged,
          ),
          _TopTab(
            label: 'Kich ban',
            tab: _CompareTab.scenarios,
            active: activeTab == _CompareTab.scenarios,
            onChanged: onChanged,
          ),
          _TopTab(
            label: 'Phan tich',
            tab: _CompareTab.analysis,
            active: activeTab == _CompareTab.analysis,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _TopTab extends StatelessWidget {
  const _TopTab({
    required this.label,
    required this.tab,
    required this.active,
    required this.onChanged,
  });

  final String label;
  final _CompareTab tab;
  final bool active;
  final ValueChanged<_CompareTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        key: DCAPerformanceComparePage.tabKey(tab.name),
        behavior: HitTestBehavior.opaque,
        onTap: () => onChanged(tab),
        child: Padding(
          padding: const EdgeInsets.only(top: AppSpacing.x4),
          child: Column(
            children: [
              Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: active ? AppColors.primary : AppColors.text3,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.x4),
              AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                height: AppSpacing.dcaPerformanceCompareTabIndicatorHeight,
                width: active
                    ? AppSpacing.dcaPerformanceCompareTabIndicatorWidth
                    : 0,
                decoration: BoxDecoration(
                  color: active ? AppColors.primary : AppColors.transparent,
                  borderRadius: AppRadii.xsRadius,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StrategyCard extends StatelessWidget {
  const _StrategyCard({
    required this.title,
    required this.value,
    required this.invested,
    required this.returnPercent,
    required this.color,
  });

  final String title;
  final String value;
  final String invested;
  final double returnPercent;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: color.withValues(alpha: 0.28),
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.sectionTitle.copyWith(color: color),
          ),
          const SizedBox(height: AppSpacing.x4),
          _SmallMetric(label: 'Invested', value: invested),
          const SizedBox(height: AppSpacing.x2),
          _SmallMetric(
            label: 'Return',
            value: _formatSignedPercent(returnPercent),
            valueColor: color,
          ),
        ],
      ),
    );
  }
}

class _WinnerBanner extends StatelessWidget {
  const _WinnerBanner({required this.snapshot});

  final DcaPerformanceCompareSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final dcaWins = snapshot.winner == DcaPerformanceWinner.dca;
    final color = dcaWins ? AppColors.buy : AppColors.primary;
    return VitCard(
      borderColor: color.withValues(alpha: 0.28),
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.bolt_rounded, color: color, size: AppSpacing.iconMd),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dcaWins ? 'DCA Strategy Wins' : 'Lump Sum Wins',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x2),
                Text.rich(
                  TextSpan(
                    text: 'Outperformed by ',
                    children: [
                      TextSpan(
                        text:
                            '${snapshot.advantagePercent.abs().toStringAsFixed(2)}%',
                        style: TextStyle(
                          color: color,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                      const TextSpan(text: ' in this period'),
                    ],
                  ),
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
