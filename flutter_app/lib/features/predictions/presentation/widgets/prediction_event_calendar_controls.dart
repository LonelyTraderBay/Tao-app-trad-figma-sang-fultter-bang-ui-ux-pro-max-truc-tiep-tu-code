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

    return Material(
      color: AppColors.surface,
      child: SizedBox(
        height: VitDensity.compact.controlHeight,
        child: Stack(
          children: [
            Row(
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
                          AnimatedSize(
                            duration: const Duration(milliseconds: 160),
                            child: Material(
                              color: _predictionPrimary,
                              borderRadius: AppRadii.hairlineRadius,
                              child: SizedBox(
                                height: AppSpacing.dividerHairline,
                                width: activeTab == item.tab
                                    ? AppSpacing
                                          .predictionCalendarTabIndicatorWidth
                                    : 0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            const Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: SizedBox(
                height: AppSpacing.dividerHairline,
                child: ColoredBox(color: AppColors.border),
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
      spacing: AppSpacing.x2,
      runSpacing: AppSpacing.x2,
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
        child: Material(
          color: AppColors.transparent,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: selected ? AppColors.transparent : AppColors.border,
            ),
            borderRadius: AppRadii.mdRadius,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.x3,
              vertical: AppSpacing.x1,
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
      ),
    );
  }
}
