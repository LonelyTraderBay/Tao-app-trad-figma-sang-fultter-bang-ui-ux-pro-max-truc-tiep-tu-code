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
      child: VitTabBar(
        variant: VitTabBarVariant.underline,
        activeKey: activeTab.name,
        onChanged: (key) => onChanged(_CalendarTab.values.byName(key)),
        tabs: [
          for (final item in tabs)
            VitTabItem(
              key: item.tab.name,
              label: item.label,
              widgetKey: item.key,
            ),
        ],
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
    return VitChoicePill(
      label: label,
      selected: selected,
      onTap: onTap,
      accentColor: _predictionPrimary,
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x1,
      ),
    );
  }
}
