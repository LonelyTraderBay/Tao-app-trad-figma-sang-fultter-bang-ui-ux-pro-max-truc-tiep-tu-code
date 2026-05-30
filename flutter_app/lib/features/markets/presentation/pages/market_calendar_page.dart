import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_asset_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/market_controller_providers.dart';

const _marketPrimary = AppColors.primary;

class MarketCalendarPage extends ConsumerStatefulWidget {
  const MarketCalendarPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc017_calendar_scroll_content');
  static const listTabKey = Key('sc017_calendar_list_tab');
  static const calendarTabKey = Key('sc017_calendar_grid_tab');

  static Key typeFilterKey(String label) => Key('sc017_type_$label');

  static Key impactFilterKey(MarketCalendarImpact impact) =>
      Key('sc017_impact_${impact.name}');

  static Key eventKey(String id) => Key('sc017_event_$id');

  static Key dayKey(int day) => Key('sc017_calendar_day_$day');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<MarketCalendarPage> createState() => _MarketCalendarPageState();
}

class _MarketCalendarPageState extends ConsumerState<MarketCalendarPage> {
  String _view = 'list';
  _CalendarTypeFilter _typeFilter = _typeFilters.first;
  MarketCalendarImpact? _impactFilter;
  String? _expandedId;

  void _setType(_CalendarTypeFilter filter) {
    setState(() {
      _typeFilter = filter;
      _expandedId = null;
    });
  }

  void _toggleImpact(MarketCalendarImpact impact) {
    setState(() {
      _impactFilter = _impactFilter == impact ? null : impact;
      _expandedId = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final query = MarketCalendarQuery(
      type: _typeFilter.type,
      impact: _impactFilter,
    );
    final snapshot = ref
        .watch(marketControllerProvider)
        .getMarketCalendar(query: query);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomChrome = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final bottomInset =
        bottomChrome +
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame ? 54 : 20);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-017 MarketCalendarPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: 'Lịch sự kiện',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.markets),
            ),
            _ViewTabs(
              activeView: _view,
              onChanged: (value) => setState(() => _view = value),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  key: MarketCalendarPage.contentKey,
                  padding: EdgeInsets.only(bottom: bottomInset),
                  child: VitPageContent(
                    padding: VitContentPadding.relaxed,
                    customGap: 16,
                    children: [
                      _StatsSummary(stats: snapshot.stats),
                      _TypeFilters(active: _typeFilter, onSelected: _setType),
                      _ImpactFilters(
                        activeImpact: _impactFilter,
                        onSelected: _toggleImpact,
                      ),
                      if (_view == 'list')
                        _CalendarEventGroups(
                          events: snapshot.events,
                          expandedId: _expandedId,
                          onToggle: (id) => setState(() {
                            _expandedId = _expandedId == id ? null : id;
                          }),
                        )
                      else
                        _MonthCalendar(
                          events: snapshot.events,
                          onEventDaySelected: (event) => setState(() {
                            _view = 'list';
                            _expandedId = event.id;
                          }),
                        ),
                      if (snapshot.events.isEmpty)
                        const VitEmptyState(
                          icon: Icons.calendar_month_rounded,
                          title: 'Không có sự kiện phù hợp',
                          message: 'Thử đổi loại sự kiện hoặc mức tác động.',
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ViewTabs extends StatelessWidget {
  const _ViewTabs({required this.activeView, required this.onChanged});

  final String activeView;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: SizedBox(
        height: 54,
        child: Row(
          children: [
            _UnderlineViewTab(
              key: MarketCalendarPage.listTabKey,
              label: 'Danh sách',
              value: 'list',
              active: activeView == 'list',
              onChanged: onChanged,
            ),
            _UnderlineViewTab(
              key: MarketCalendarPage.calendarTabKey,
              label: 'Lịch',
              value: 'calendar',
              active: activeView == 'calendar',
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}

class _UnderlineViewTab extends StatelessWidget {
  const _UnderlineViewTab({
    super.key,
    required this.label,
    required this.value,
    required this.active,
    required this.onChanged,
  });

  final String label;
  final String value;
  final bool active;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () => onChanged(value),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Center(
                child: Text(
                  label,
                  style: AppTextStyles.caption.copyWith(
                    color: active ? _marketPrimary : AppColors.text3,
                    fontWeight: AppTextStyles.medium,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 2,
              child: FractionallySizedBox(
                widthFactor: active ? 1 : 0,
                alignment: Alignment.center,
                child: const ColoredBox(color: _marketPrimary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatsSummary extends StatelessWidget {
  const _StatsSummary({required this.stats});

  final MarketCalendarStats stats;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _MiniStat(
            label: 'Sắp diễn ra',
            value: stats.upcoming.toString(),
            color: _marketPrimary,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _MiniStat(
            label: 'Tác động cao',
            value: stats.highImpact.toString(),
            color: AppColors.sell,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _MiniStat(
            label: 'Tuần này',
            value: stats.thisWeek.toString(),
            color: AppColors.buy,
          ),
        ),
      ],
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      height: 73,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: AppTextStyles.sectionTitle.copyWith(
              color: color,
              fontSize: 22,
              height: 1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text3,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

class _TypeFilters extends StatelessWidget {
  const _TypeFilters({required this.active, required this.onSelected});

  final _CalendarTypeFilter active;
  final ValueChanged<_CalendarTypeFilter> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        children: [
          for (final filter in _typeFilters) ...[
            _FilterChipButton(
              key: MarketCalendarPage.typeFilterKey(filter.label),
              label: filter.label,
              active: filter.label == active.label,
              activeColor: _marketPrimary,
              onTap: () => onSelected(filter),
            ),
            const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }
}

class _ImpactFilters extends StatelessWidget {
  const _ImpactFilters({required this.activeImpact, required this.onSelected});

  final MarketCalendarImpact? activeImpact;
  final ValueChanged<MarketCalendarImpact> onSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final impact in MarketCalendarImpact.values) ...[
          _ImpactChip(
            key: MarketCalendarPage.impactFilterKey(impact),
            impact: impact,
            active: activeImpact == impact,
            onTap: () => onSelected(impact),
          ),
          const SizedBox(width: 8),
        ],
      ],
    );
  }
}

class _FilterChipButton extends StatelessWidget {
  const _FilterChipButton({
    super.key,
    required this.label,
    required this.active,
    required this.activeColor,
    required this.onTap,
  });

  final String label;
  final bool active;
  final Color activeColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.cardRadius,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        constraints: const BoxConstraints(minHeight: 36),
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
        decoration: BoxDecoration(
          color: active
              ? activeColor.withValues(alpha: .18)
              : AppColors.surface2,
          border: Border.all(
            color: active
                ? activeColor.withValues(alpha: .55)
                : AppColors.transparent,
          ),
          borderRadius: AppRadii.cardRadius,
        ),
        child: Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: active ? activeColor : AppColors.text3,
            fontWeight: AppTextStyles.medium,
          ),
        ),
      ),
    );
  }
}

class _ImpactChip extends StatelessWidget {
  const _ImpactChip({
    super.key,
    required this.impact,
    required this.active,
    required this.onTap,
  });

  final MarketCalendarImpact impact;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cfg = _impactConfig(impact);
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.smRadius,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: active
              ? cfg.color.withValues(alpha: .14)
              : AppColors.transparent,
          border: Border.all(
            color: active
                ? cfg.color.withValues(alpha: .38)
                : AppColors.borderSolid,
          ),
          borderRadius: AppRadii.smRadius,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: cfg.color,
                shape: BoxShape.circle,
              ),
              child: const SizedBox(width: 6, height: 6),
            ),
            const SizedBox(width: 6),
            Text(
              cfg.label,
              style: AppTextStyles.micro.copyWith(
                color: active ? cfg.color : AppColors.text3,
                fontWeight: AppTextStyles.medium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CalendarEventGroups extends StatelessWidget {
  const _CalendarEventGroups({
    required this.events,
    required this.expandedId,
    required this.onToggle,
  });

  final List<MarketCalendarEvent> events;
  final String? expandedId;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    final groups = _groupEvents(events);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final group in groups) ...[
          _DateHeader(event: group.events.first),
          const SizedBox(height: 8),
          for (final event in group.events) ...[
            _EventCard(
              key: MarketCalendarPage.eventKey(event.id),
              event: event,
              expanded: expandedId == event.id,
              onTap: () => onToggle(event.id),
            ),
            const SizedBox(height: 8),
          ],
          const SizedBox(height: 8),
        ],
      ],
    );
  }
}

class _DateHeader extends StatelessWidget {
  const _DateHeader({required this.event});

  final MarketCalendarEvent event;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          _formatEventDate(event.dateIso),
          style: AppTextStyles.body.copyWith(
            color: AppColors.text1,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          _relativeLabel(event.dateIso),
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
      ],
    );
  }
}

class _EventCard extends StatelessWidget {
  const _EventCard({
    super.key,
    required this.event,
    required this.expanded,
    required this.onTap,
  });

  final MarketCalendarEvent event;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final type = _eventTypeConfig(event.type);
    final impact = _impactConfig(event.impact);
    final days = _daysUntil(event.dateIso);

    return VitCard(
      borderColor: event.impact == MarketCalendarImpact.high
          ? AppColors.sell20
          : null,
      clip: true,
      onTap: onTap,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: type.color.withValues(alpha: .13),
                    borderRadius: AppRadii.smRadius,
                  ),
                  child: Icon(type.icon, color: type.color, size: 18),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: [
                          if (event.symbol != null)
                            _TinyBadge(
                              label: event.symbol!,
                              color: event.symbolColor ?? type.color,
                            ),
                          _TinyBadge(label: type.label, color: type.color),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        event.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.medium,
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.access_time_rounded,
                            color: AppColors.text3,
                            size: 13,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            _formatEventTime(event.dateIso),
                            style: AppTextStyles.micro.copyWith(
                              color: AppColors.text3,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              '• ${impact.label}${event.confirmed ? '' : '  • Chưa xác nhận'}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.micro.copyWith(
                                color: event.confirmed
                                    ? impact.color
                                    : AppColors.warn,
                                fontWeight: AppTextStyles.medium,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  days == 0 ? 'Hôm nay' : '${days}d',
                  style: AppTextStyles.caption.copyWith(
                    color: days <= 1
                        ? AppColors.sell
                        : days <= 3
                        ? AppColors.warn
                        : AppColors.text2,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ],
            ),
          ),
          if (expanded)
            DecoratedBox(
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: AppColors.divider)),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.description,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                        height: 1.5,
                      ),
                    ),
                    if (event.source != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Nguồn: ${event.source}',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _TinyBadge extends StatelessWidget {
  const _TinyBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: .13),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            height: 1,
          ),
        ),
      ),
    );
  }
}

class _MonthCalendar extends StatelessWidget {
  const _MonthCalendar({
    required this.events,
    required this.onEventDaySelected,
  });

  final List<MarketCalendarEvent> events;
  final ValueChanged<MarketCalendarEvent> onEventDaySelected;

  @override
  Widget build(BuildContext context) {
    final eventsByDay = <int, List<MarketCalendarEvent>>{};
    for (final event in events) {
      final day = DateTime.parse(event.dateIso).toLocal().day;
      eventsByDay.putIfAbsent(day, () => []).add(event);
    }

    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tháng 3, 2026',
            style: AppTextStyles.body.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 7,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1,
            children: [
              for (final label in ['CN', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7'])
                Center(
                  child: Text(
                    label,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      fontWeight: AppTextStyles.medium,
                    ),
                  ),
                ),
              for (var day = 1; day <= 31; day++)
                _CalendarDay(
                  key: MarketCalendarPage.dayKey(day),
                  day: day,
                  events: eventsByDay[day] ?? const [],
                  onEventDaySelected: onEventDaySelected,
                ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, color: AppColors.divider),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              for (final type in [
                MarketCalendarEventType.unlock,
                MarketCalendarEventType.upgrade,
                MarketCalendarEventType.airdrop,
                MarketCalendarEventType.burn,
                MarketCalendarEventType.report,
              ])
                _LegendItem(config: _eventTypeConfig(type)),
            ],
          ),
        ],
      ),
    );
  }
}

class _CalendarDay extends StatelessWidget {
  const _CalendarDay({
    super.key,
    required this.day,
    required this.events,
    required this.onEventDaySelected,
  });

  final int day;
  final List<MarketCalendarEvent> events;
  final ValueChanged<MarketCalendarEvent> onEventDaySelected;

  @override
  Widget build(BuildContext context) {
    final isToday = day == 11;
    final hasEvents = events.isNotEmpty;
    final hasHigh = events.any(
      (event) => event.impact == MarketCalendarImpact.high,
    );

    return InkWell(
      onTap: hasEvents ? () => onEventDaySelected(events.first) : null,
      borderRadius: AppRadii.smRadius,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isToday
              ? _marketPrimary.withValues(alpha: .12)
              : hasEvents
              ? AppColors.surface2
              : AppColors.transparent,
          border: Border.all(
            color: isToday
                ? _marketPrimary.withValues(alpha: .35)
                : AppColors.transparent,
            width: 1.5,
          ),
          borderRadius: AppRadii.smRadius,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              day.toString(),
              style: AppTextStyles.caption.copyWith(
                color: isToday ? _marketPrimary : AppColors.text1,
                fontWeight: isToday ? AppTextStyles.bold : AppTextStyles.medium,
              ),
            ),
            if (hasEvents) ...[
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (final event in events.take(3)) ...[
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: hasHigh
                            ? AppColors.sell
                            : _eventTypeConfig(event.type).color,
                        shape: BoxShape.circle,
                      ),
                      child: const SizedBox(width: 4, height: 4),
                    ),
                    const SizedBox(width: 2),
                  ],
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.config});

  final _EventTypeConfig config;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: config.color,
            shape: BoxShape.circle,
          ),
          child: const SizedBox(width: 8, height: 8),
        ),
        const SizedBox(width: 5),
        Text(
          config.label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
      ],
    );
  }
}

final class _CalendarGroup {
  const _CalendarGroup({required this.key, required this.events});

  final String key;
  final List<MarketCalendarEvent> events;
}

List<_CalendarGroup> _groupEvents(List<MarketCalendarEvent> events) {
  final groups = <String, List<MarketCalendarEvent>>{};
  for (final event in events) {
    final date = DateTime.parse(event.dateIso).toLocal();
    final key =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    groups.putIfAbsent(key, () => []).add(event);
  }
  return [
    for (final entry in groups.entries)
      _CalendarGroup(
        key: entry.key,
        events: [...entry.value]
          ..sort(
            (a, b) =>
                DateTime.parse(a.dateIso).compareTo(DateTime.parse(b.dateIso)),
          ),
      ),
  ];
}

String _formatEventDate(String dateIso) {
  final date = DateTime.parse(dateIso).toLocal();
  const months = [
    'Th1',
    'Th2',
    'Th3',
    'Th4',
    'Th5',
    'Th6',
    'Th7',
    'Th8',
    'Th9',
    'Th10',
    'Th11',
    'Th12',
  ];
  return '${date.day} ${months[date.month - 1]}';
}

String _formatEventTime(String dateIso) {
  final date = DateTime.parse(dateIso).toLocal();
  final hour = date.hour.toString().padLeft(2, '0');
  final minute = date.minute.toString().padLeft(2, '0');
  return '$hour:$minute UTC';
}

String _relativeLabel(String dateIso) {
  final days = _daysUntil(dateIso);
  if (days < 0) return '${days.abs()} ngày trước';
  if (days == 0) return 'Hôm nay';
  if (days == 1) return 'Ngày mai';
  return '$days ngày nữa';
}

int _daysUntil(String dateIso) {
  final now = DateTime.utc(2026, 3, 11, 12);
  final eventDate = DateTime.parse(dateIso).toUtc();
  return (eventDate.difference(now).inMilliseconds /
          Duration.millisecondsPerDay)
      .ceil();
}

final class _CalendarTypeFilter {
  const _CalendarTypeFilter(this.label, this.type);

  final String label;
  final MarketCalendarEventType? type;
}

const List<_CalendarTypeFilter> _typeFilters = [
  _CalendarTypeFilter('Tất cả', null),
  _CalendarTypeFilter('Token Unlock', MarketCalendarEventType.unlock),
  _CalendarTypeFilter('Nâng cấp', MarketCalendarEventType.upgrade),
  _CalendarTypeFilter('Airdrop', MarketCalendarEventType.airdrop),
  _CalendarTypeFilter('Đốt token', MarketCalendarEventType.burn),
  _CalendarTypeFilter('Niêm yết', MarketCalendarEventType.listing),
  _CalendarTypeFilter('Báo cáo', MarketCalendarEventType.report),
  _CalendarTypeFilter('Hội nghị', MarketCalendarEventType.conference),
];

final class _EventTypeConfig {
  const _EventTypeConfig({
    required this.label,
    required this.color,
    required this.icon,
  });

  final String label;
  final Color color;
  final IconData icon;
}

_EventTypeConfig _eventTypeConfig(MarketCalendarEventType type) {
  return switch (type) {
    MarketCalendarEventType.unlock => const _EventTypeConfig(
      label: 'Token Unlock',
      color: AppColors.caution,
      icon: Icons.lock_open_rounded,
    ),
    MarketCalendarEventType.upgrade => const _EventTypeConfig(
      label: 'Nâng cấp',
      color: _marketPrimary,
      icon: Icons.arrow_upward_rounded,
    ),
    MarketCalendarEventType.halving => const _EventTypeConfig(
      label: 'Halving',
      color: AppColors.accent,
      icon: Icons.bolt_rounded,
    ),
    MarketCalendarEventType.airdrop => const _EventTypeConfig(
      label: 'Airdrop',
      color: AppColors.buy,
      icon: Icons.card_giftcard_rounded,
    ),
    MarketCalendarEventType.listing => const _EventTypeConfig(
      label: 'Niêm yết',
      color: AppAssetColors.cyanChain,
      icon: Icons.receipt_long_rounded,
    ),
    MarketCalendarEventType.fork => const _EventTypeConfig(
      label: 'Fork',
      color: AppColors.sell,
      icon: Icons.call_split_rounded,
    ),
    MarketCalendarEventType.burn => const _EventTypeConfig(
      label: 'Đốt token',
      color: AppColors.riskHigh,
      icon: Icons.local_fire_department_rounded,
    ),
    MarketCalendarEventType.conference => const _EventTypeConfig(
      label: 'Hội nghị',
      color: AppAssetColors.indigoChain,
      icon: Icons.mic_rounded,
    ),
    MarketCalendarEventType.report => const _EventTypeConfig(
      label: 'Báo cáo',
      color: AppColors.text3,
      icon: Icons.bar_chart_rounded,
    ),
  };
}

final class _ImpactConfig {
  const _ImpactConfig({required this.label, required this.color});

  final String label;
  final Color color;
}

_ImpactConfig _impactConfig(MarketCalendarImpact impact) {
  return switch (impact) {
    MarketCalendarImpact.high => const _ImpactConfig(
      label: 'Cao',
      color: AppColors.sell,
    ),
    MarketCalendarImpact.medium => const _ImpactConfig(
      label: 'Trung bình',
      color: AppColors.warn,
    ),
    MarketCalendarImpact.low => const _ImpactConfig(
      label: 'Thấp',
      color: AppColors.buy,
    ),
  };
}
