part of '../pages/prediction_event_calendar_page.dart';

class _EventCalendarTabBar extends StatelessWidget {
  const _EventCalendarTabBar({
    required this.activeTab,
    required this.onChanged,
  });

  final _CalendarTab activeTab;
  final ValueChanged<_CalendarTab> onChanged;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      (
        key: PredictionEventCalendarPage.calendarTabKey,
        tab: _CalendarTab.calendar,
        label: 'Lich',
      ),
      (
        key: PredictionEventCalendarPage.upcomingTabKey,
        tab: _CalendarTab.upcoming,
        label: 'Sap toi',
      ),
      (
        key: PredictionEventCalendarPage.notificationsTabKey,
        tab: _CalendarTab.notifications,
        label: 'Thong bao',
      ),
    ];

    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: SizedBox(
        height: AppSpacing.predictionCalendarTabsHeight,
        child: Row(
          children: [
            for (final item in tabs)
              Expanded(
                child: InkWell(
                  key: item.key,
                  onTap: () => onChanged(item.tab),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(
                            item.label,
                            style: AppTextStyles.caption.copyWith(
                              color: activeTab == item.tab
                                  ? _predictionPrimary
                                  : AppColors.text3,
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                        ),
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 160),
                        height: AppSpacing.predictionCalendarTabIndicatorHeight,
                        width: activeTab == item.tab
                            ? AppSpacing.predictionCalendarTabIndicatorWidth
                            : 0,
                        decoration: BoxDecoration(
                          color: _predictionPrimary,
                          borderRadius: AppRadii.hairlineRadius,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _CategoryFilters extends StatelessWidget {
  const _CategoryFilters({
    required this.snapshot,
    required this.selectedCategory,
    required this.onChanged,
  });

  final PredictionEventCalendarSnapshot snapshot;
  final String? selectedCategory;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.predictionCalendarFilterGap,
      runSpacing: AppSpacing.predictionCalendarFilterGap,
      children: [
        _CategoryChip(
          label: 'Tat ca',
          selected: selectedCategory == null,
          onTap: () => onChanged(null),
        ),
        for (final category in snapshot.categories)
          _CategoryChip(
            key: PredictionEventCalendarPage.categoryKey(category),
            label: category,
            selected: selectedCategory == category,
            onTap: () => onChanged(category),
          ),
      ],
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? _predictionPrimary : AppColors.bg,
      borderRadius: AppRadii.mdRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.mdRadius,
        child: Container(
          padding: AppSpacing.predictionCalendarFilterChipPadding,
          decoration: BoxDecoration(
            border: Border.all(
              color: selected ? AppColors.transparent : AppColors.border,
            ),
            borderRadius: AppRadii.mdRadius,
          ),
          child: Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: selected ? AppColors.onAccent : AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ),
    );
  }
}
