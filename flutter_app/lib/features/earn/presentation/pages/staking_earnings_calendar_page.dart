import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
import 'package:vit_trade_flutter/app/providers/earn_controller_providers.dart';

class StakingEarningsCalendarPage extends ConsumerStatefulWidget {
  const StakingEarningsCalendarPage({super.key, this.shellRenderMode});

  static const summaryKey = Key('sc361_summary_card');
  static const notificationKey = Key('sc361_notification_toggle');
  static const exportKey = Key('sc361_export_button');
  static const tabsKey = Key('sc361_tabs');
  static const calendarCardKey = Key('sc361_calendar_card');
  static const nextMonthKey = Key('sc361_next_month');
  static const previousMonthKey = Key('sc361_previous_month');
  static const legendKey = Key('sc361_legend_card');
  static const infoKey = Key('sc361_info_banner');
  static const listKey = Key('sc361_upcoming_list');

  static Key dayKey(int day) => Key('sc361_day_$day');
  static Key eventKey(String id) => Key('sc361_event_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<StakingEarningsCalendarPage> createState() =>
      _StakingEarningsCalendarPageState();
}

class _StakingEarningsCalendarPageState
    extends ConsumerState<StakingEarningsCalendarPage> {
  String _tab = 'calendar';
  bool _notificationsEnabled = true;
  late DateTime _visibleMonth;

  @override
  void initState() {
    super.initState();
    final snapshot = ref
        .read(stakingEarningsCalendarRepositoryProvider)
        .getCalendar();
    _visibleMonth = DateTime(snapshot.currentYear, snapshot.currentMonth);
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(stakingEarningsCalendarRepositoryProvider)
        .getCalendar();
    final today = DateTime.parse(snapshot.todayIso);
    final upcoming = _upcomingEvents(snapshot.events, today);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-361 StakingEarningsCalendarPage',
      child: Material(
        color: AppColors.bg,
        child: Column(
          children: [
            VitHeader(
              title: snapshot.title,
              showBack: true,
              onBack: () => context.go(snapshot.backRoute),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(bottom: bottomInset),
                child: VitPageContent(
                  padding: VitContentPadding.compact,
                  gap: VitContentGap.defaultGap,
                  children: [
                    _SummaryCard(
                      snapshot: snapshot,
                      upcomingCount: upcoming.length,
                      notificationsEnabled: _notificationsEnabled,
                      onToggleNotifications: _toggleNotifications,
                      onExport: _exportCalendar,
                    ),
                    _CalendarTabs(
                      key: StakingEarningsCalendarPage.tabsKey,
                      tabs: snapshot.tabs,
                      active: _tab,
                      onChanged: (tab) {
                        HapticFeedback.selectionClick();
                        setState(() => _tab = tab);
                      },
                    ),
                    if (_tab == 'calendar') ...[
                      _CalendarCard(
                        snapshot: snapshot,
                        visibleMonth: _visibleMonth,
                        today: today,
                        onPrevious: _previousMonth,
                        onNext: _nextMonth,
                      ),
                      const _LegendCard(),
                    ] else
                      _UpcomingList(events: upcoming),
                    _InfoBanner(snapshot: snapshot),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleNotifications() {
    HapticFeedback.selectionClick();
    setState(() => _notificationsEnabled = !_notificationsEnabled);
  }

  void _exportCalendar() {
    HapticFeedback.selectionClick();
    if (Scaffold.maybeOf(context) == null) return;
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;
    messenger.showSnackBar(
      const SnackBar(content: Text('Xuất lịch nhận lãi (.ics) sẽ sớm ra mắt')),
    );
  }

  void _previousMonth() {
    HapticFeedback.selectionClick();
    setState(() {
      _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month - 1);
    });
  }

  void _nextMonth() {
    HapticFeedback.selectionClick();
    setState(() {
      _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month + 1);
    });
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.snapshot,
    required this.upcomingCount,
    required this.notificationsEnabled,
    required this.onToggleNotifications,
    required this.onExport,
  });

  final StakingEarningsCalendarSnapshot snapshot;
  final int upcomingCount;
  final bool notificationsEnabled;
  final VoidCallback onToggleNotifications;
  final VoidCallback onExport;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingEarningsCalendarPage.summaryKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sắp nhận (30 ngày tới)',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x2),
                    Text(
                      '+${_formatUsd(snapshot.totalUpcomingUsd)}',
                      style: AppTextStyles.sectionTitle.copyWith(
                        color: AppColors.buy,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ],
                ),
              ),
              _SummaryActionButton(
                key: StakingEarningsCalendarPage.notificationKey,
                icon: notificationsEnabled
                    ? Icons.notifications_none_rounded
                    : Icons.notifications_off_outlined,
                active: notificationsEnabled,
                onTap: onToggleNotifications,
              ),
              const SizedBox(width: AppSpacing.x2),
              _SummaryActionButton(
                key: StakingEarningsCalendarPage.exportKey,
                icon: Icons.file_download_outlined,
                onTap: onExport,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              const Icon(
                Icons.calendar_today_rounded,
                color: AppColors.text3,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  '$upcomingCount sự kiện sắp tới'
                  '${notificationsEnabled ? ' · Nhận thông báo trước 24h' : ''}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryActionButton extends StatelessWidget {
  const _SummaryActionButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.active = false,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final color = active ? AppColors.buy : AppColors.text1;
    return Material(
      color: active ? AppColors.buy10 : AppColors.surface3,
      borderRadius: AppRadii.xlRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.xlRadius,
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(
              color: active ? AppColors.buy20 : AppColors.cardBorder,
            ),
            borderRadius: AppRadii.xlRadius,
          ),
          child: SizedBox(
            width: AppSpacing.buttonCompact,
            height: AppSpacing.buttonCompact,
            child: Icon(icon, color: color, size: AppSpacing.iconMd),
          ),
        ),
      ),
    );
  }
}

class _CalendarTabs extends StatelessWidget {
  const _CalendarTabs({
    super.key,
    required this.tabs,
    required this.active,
    required this.onChanged,
  });

  final List<StakingAnalyticsTabDraft> tabs;
  final String active;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 53,
      child: ColoredBox(
        color: AppColors.surface,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x7),
            child: VitTabBar(
              variant: VitTabBarVariant.underline,
              tabs: [
                for (final tab in tabs)
                  VitTabItem(key: tab.id, label: tab.label),
              ],
              activeKey: active,
              onChanged: onChanged,
            ),
          ),
        ),
      ),
    );
  }
}

class _CalendarCard extends StatelessWidget {
  const _CalendarCard({
    required this.snapshot,
    required this.visibleMonth,
    required this.today,
    required this.onPrevious,
    required this.onNext,
  });

  final StakingEarningsCalendarSnapshot snapshot;
  final DateTime visibleMonth;
  final DateTime today;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final firstDay = DateTime(visibleMonth.year, visibleMonth.month);
    final daysInMonth = DateTime(
      visibleMonth.year,
      visibleMonth.month + 1,
      0,
    ).day;
    final blanks = firstDay.weekday == DateTime.sunday
        ? 6
        : firstDay.weekday - 1;

    return VitCard(
      key: StakingEarningsCalendarPage.calendarCardKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        children: [
          Row(
            children: [
              _MonthButton(
                key: StakingEarningsCalendarPage.previousMonthKey,
                icon: Icons.chevron_left_rounded,
                onTap: onPrevious,
              ),
              Expanded(
                child: Text(
                  _monthLabel(snapshot, visibleMonth),
                  textAlign: TextAlign.center,
                  style: AppTextStyles.baseMedium.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              _MonthButton(
                key: StakingEarningsCalendarPage.nextMonthKey,
                icon: Icons.chevron_right_rounded,
                onTap: onNext,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              for (final label in const [
                'T2',
                'T3',
                'T4',
                'T5',
                'T6',
                'T7',
                'CN',
              ])
                Expanded(
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          GridView.count(
            crossAxisCount: 7,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: AppSpacing.x1,
            crossAxisSpacing: AppSpacing.x1,
            children: [
              for (var i = 0; i < blanks; i++) const SizedBox.shrink(),
              for (var day = 1; day <= daysInMonth; day++)
                _DayCell(
                  key: StakingEarningsCalendarPage.dayKey(day),
                  day: day,
                  events: _eventsForDay(snapshot.events, visibleMonth, day),
                  today:
                      day == today.day &&
                      visibleMonth.month == today.month &&
                      visibleMonth.year == today.year,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MonthButton extends StatelessWidget {
  const _MonthButton({super.key, required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface3,
      borderRadius: AppRadii.xlRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.xlRadius,
        child: SizedBox(
          width: AppSpacing.buttonCompact,
          height: AppSpacing.buttonCompact,
          child: Icon(icon, color: AppColors.text1, size: AppSpacing.iconMd),
        ),
      ),
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    super.key,
    required this.day,
    required this.events,
    required this.today,
  });

  final int day;
  final List<StakingCalendarEventDraft> events;
  final bool today;

  @override
  Widget build(BuildContext context) {
    final hasEvents = events.isNotEmpty;
    final borderColor = today
        ? AppColors.primary
        : hasEvents
        ? AppColors.cardBorder
        : AppColors.transparent;
    final bgColor = today
        ? AppColors.primary12
        : hasEvents
        ? AppColors.surface3
        : AppColors.transparent;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: AppRadii.lgRadius,
        border: Border.all(color: borderColor),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$day',
              style: AppTextStyles.caption.copyWith(
                color: today ? AppColors.primarySoft : AppColors.text1,
                fontWeight: today ? AppTextStyles.bold : AppTextStyles.medium,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
            if (hasEvents) ...[
              const SizedBox(height: AppSpacing.x1),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (final event in events.take(3)) ...[
                    _EventDot(color: _eventColor(event.type)),
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

class _LegendCard extends StatelessWidget {
  const _LegendCard();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingEarningsCalendarPage.legendKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Loại sự kiện:',
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: AppSpacing.x3),
          Wrap(
            spacing: AppSpacing.x7,
            runSpacing: AppSpacing.x3,
            children: [
              _LegendItem(
                color: _eventColor(StakingCalendarEventType.dailyReward),
                label: 'Nhận lãi',
              ),
              _LegendItem(
                color: _eventColor(StakingCalendarEventType.maturity),
                label: 'Đến hạn',
              ),
              _LegendItem(
                color: _eventColor(StakingCalendarEventType.autoCompound),
                label: 'Tái đầu tư',
              ),
              _LegendItem(
                color: _eventColor(StakingCalendarEventType.rateChange),
                label: 'Thay đổi APY',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 148,
      child: Row(
        children: [
          _EventDot(color: color),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ),
        ],
      ),
    );
  }
}

class _EventDot extends StatelessWidget {
  const _EventDot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSpacing.x2,
      height: AppSpacing.x2,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _UpcomingList extends StatelessWidget {
  const _UpcomingList({required this.events});

  final List<StakingCalendarEventDraft> events;

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) {
      return const VitEmptyState(
        icon: Icons.calendar_today_rounded,
        title: 'Không có sự kiện nào',
        message: 'Lịch nhận lãi sẽ hiển thị khi bạn có vị thế staking.',
      );
    }

    return VitPageSection(
      key: StakingEarningsCalendarPage.listKey,
      label: 'Sự kiện sắp tới',
      accentColor: AppColors.primary,
      children: [
        for (final event in events)
          _EventCard(
            key: StakingEarningsCalendarPage.eventKey(event.id),
            event: event,
          ),
      ],
    );
  }
}

class _EventCard extends StatelessWidget {
  const _EventCard({super.key, required this.event});

  final StakingCalendarEventDraft event;

  @override
  Widget build(BuildContext context) {
    final color = _eventColor(event.type);

    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Row(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.14),
              borderRadius: AppRadii.lgRadius,
            ),
            child: SizedBox(
              width: AppSpacing.buttonCompact + AppSpacing.x2,
              height: AppSpacing.buttonCompact + AppSpacing.x2,
              child: Icon(_eventIcon(event.type), color: color, size: 19),
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        _eventLabel(event.type),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.baseMedium.copyWith(
                          color: AppColors.text1,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.x2),
                    _TimingPill(dateIso: event.dateIso),
                  ],
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  event.product,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  '${_formatDate(event.dateIso)} · ${event.description}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          _EventValue(event: event),
        ],
      ),
    );
  }
}

class _TimingPill extends StatelessWidget {
  const _TimingPill({required this.dateIso});

  final String dateIso;

  @override
  Widget build(BuildContext context) {
    final days = DateTime.parse(
      dateIso,
    ).difference(DateTime(2026, 3, 7)).inDays;
    final label = switch (days) {
      0 => 'Hôm nay',
      1 => 'Ngày mai',
      _ when days > 1 && days <= 7 => '$days ngày nữa',
      _ => null,
    };
    if (label == null) return const SizedBox.shrink();

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.primary12,
        borderRadius: AppRadii.smRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x2,
          vertical: 3,
        ),
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.primarySoft,
            fontWeight: AppTextStyles.bold,
            height: 1,
          ),
        ),
      ),
    );
  }
}

class _EventValue extends StatelessWidget {
  const _EventValue({required this.event});

  final StakingCalendarEventDraft event;

  @override
  Widget build(BuildContext context) {
    if (event.type == StakingCalendarEventType.rateChange) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '${event.newRate?.toStringAsFixed(1) ?? '-'}%',
            style: AppTextStyles.baseMedium.copyWith(
              color: AppColors.warn,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
          Text(
            'từ ${event.oldRate?.toStringAsFixed(1) ?? '-'}%',
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          '+${_formatAmount(event.amount ?? 0)} ${event.asset}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.buy,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          _formatUsd(event.usdValue ?? 0),
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
      ],
    );
  }
}

class _InfoBanner extends StatelessWidget {
  const _InfoBanner({required this.snapshot});

  final StakingEarningsCalendarSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingEarningsCalendarPage.infoKey,
      variant: VitCardVariant.inner,
      borderColor: AppColors.primary30,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.calendar_month_rounded,
            color: AppColors.primarySoft,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snapshot.infoTitle,
                  style: AppTextStyles.baseMedium.copyWith(
                    color: AppColors.text1,
                  ),
                ),
                const SizedBox(height: AppSpacing.x2),
                for (final bullet in snapshot.infoBullets)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.x1),
                    child: Text(
                      bullet,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                        height: 1.35,
                      ),
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

List<StakingCalendarEventDraft> _upcomingEvents(
  List<StakingCalendarEventDraft> events,
  DateTime today,
) {
  final list =
      [
        for (final event in events)
          if (!DateTime.parse(event.dateIso).isBefore(today)) event,
      ]..sort(
        (a, b) =>
            DateTime.parse(a.dateIso).compareTo(DateTime.parse(b.dateIso)),
      );
  return list.take(10).toList();
}

List<StakingCalendarEventDraft> _eventsForDay(
  List<StakingCalendarEventDraft> events,
  DateTime month,
  int day,
) {
  return [
    for (final event in events)
      if (_isSameCalendarDay(DateTime.parse(event.dateIso), month, day)) event,
  ];
}

bool _isSameCalendarDay(DateTime date, DateTime month, int day) {
  return date.year == month.year &&
      date.month == month.month &&
      date.day == day;
}

String _monthLabel(
  StakingEarningsCalendarSnapshot snapshot,
  DateTime visibleMonth,
) {
  if (visibleMonth.year == snapshot.currentYear &&
      visibleMonth.month == snapshot.currentMonth) {
    return snapshot.currentMonthLabel;
  }
  return 'Tháng ${visibleMonth.month} ${visibleMonth.year}';
}

Color _eventColor(StakingCalendarEventType type) {
  return switch (type) {
    StakingCalendarEventType.dailyReward => AppColors.buy,
    StakingCalendarEventType.maturity => AppColors.primary,
    StakingCalendarEventType.autoCompound => AppColors.accent,
    StakingCalendarEventType.rateChange => AppColors.warn,
  };
}

IconData _eventIcon(StakingCalendarEventType type) {
  return switch (type) {
    StakingCalendarEventType.dailyReward => Icons.attach_money_rounded,
    StakingCalendarEventType.maturity => Icons.schedule_rounded,
    StakingCalendarEventType.autoCompound => Icons.trending_up_rounded,
    StakingCalendarEventType.rateChange => Icons.show_chart_rounded,
  };
}

String _eventLabel(StakingCalendarEventType type) {
  return switch (type) {
    StakingCalendarEventType.dailyReward => 'Nhận lãi',
    StakingCalendarEventType.maturity => 'Đến hạn',
    StakingCalendarEventType.autoCompound => 'Tái đầu tư',
    StakingCalendarEventType.rateChange => 'Thay đổi APY',
  };
}

String _formatDate(String dateIso) {
  final date = DateTime.parse(dateIso);
  const weekdays = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];
  return '${weekdays[date.weekday - 1]}, ${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
}

String _formatUsd(double value) {
  final fixed = value.toStringAsFixed(2);
  final parts = fixed.split('.');
  final raw = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < raw.length; i++) {
    final position = raw.length - i;
    buffer.write(raw[i]);
    if (position > 1 && position % 3 == 1) buffer.write(',');
  }
  return '\$${buffer.toString()}.${parts.last}';
}

String _formatAmount(double value) {
  final decimals = value < 1
      ? 2
      : value >= 10
      ? 2
      : 4;
  final fixed = value.toStringAsFixed(decimals);
  final parts = fixed.split('.');
  final raw = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < raw.length; i++) {
    final position = raw.length - i;
    buffer.write(raw[i]);
    if (position > 1 && position % 3 == 1) buffer.write(',');
  }
  return '${buffer.toString()}.${parts.last}';
}
