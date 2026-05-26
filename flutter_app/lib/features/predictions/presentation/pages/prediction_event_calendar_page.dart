import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/features/predictions/data/predictions_repository.dart';

const _predictionPrimary = AppColors.primary;

enum _CalendarTab { calendar, upcoming, notifications }

class PredictionEventCalendarPage extends ConsumerStatefulWidget {
  const PredictionEventCalendarPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc039_event_calendar_content');
  static const filterButtonKey = Key('sc039_filter_button');
  static const calendarTabKey = Key('sc039_tab_calendar');
  static const upcomingTabKey = Key('sc039_tab_upcoming');
  static const notificationsTabKey = Key('sc039_tab_notifications');

  static Key categoryKey(String category) => Key('sc039_category_$category');
  static Key eventKey(String id) => Key('sc039_event_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<PredictionEventCalendarPage> createState() =>
      _PredictionEventCalendarPageState();
}

class _PredictionEventCalendarPageState
    extends ConsumerState<PredictionEventCalendarPage> {
  _CalendarTab _activeTab = _CalendarTab.calendar;
  bool _showFilter = false;
  String? _category;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(predictionsRepositoryProvider)
        .getEventCalendar(category: _category);
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
      semanticLabel: 'SC-039 PredictionEventCalendarPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: 'Event Calendar',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.marketsPredictions),
              trailing: _FilterButton(
                active: _showFilter,
                onTap: () => setState(() => _showFilter = !_showFilter),
              ),
            ),
            _EventCalendarTabBar(
              activeTab: _activeTab,
              onChanged: (tab) => setState(() => _activeTab = tab),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  key: PredictionEventCalendarPage.contentKey,
                  padding: EdgeInsets.only(bottom: bottomInset),
                  child: VitPageContent(
                    padding: VitContentPadding.relaxed,
                    customGap: 16,
                    children: [
                      if (_showFilter)
                        _CategoryFilters(
                          snapshot: snapshot,
                          selectedCategory: _category,
                          onChanged: (category) =>
                              setState(() => _category = category),
                        ),
                      ...switch (_activeTab) {
                        _CalendarTab.calendar => [
                          _StatsCard(snapshot: snapshot),
                          for (final month in snapshot.months)
                            _MonthSection(month: month),
                        ],
                        _CalendarTab.upcoming => [
                          _UpcomingSection(snapshot: snapshot),
                        ],
                        _CalendarTab.notifications => [
                          _NotificationSettings(),
                          _WatchingSection(snapshot: snapshot),
                          const _NotificationInfo(),
                        ],
                      },
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

class _FilterButton extends StatelessWidget {
  const _FilterButton({required this.active, required this.onTap});

  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 38,
      height: 38,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: active ? _predictionPrimary : AppColors.surface3,
          border: Border.all(color: AppColors.border),
          borderRadius: AppRadii.mdRadius,
        ),
        child: IconButton(
          key: PredictionEventCalendarPage.filterButtonKey,
          onPressed: onTap,
          padding: EdgeInsets.zero,
          icon: const Icon(
            Icons.filter_alt_outlined,
            color: AppColors.text1,
            size: 20,
          ),
        ),
      ),
    );
  }
}

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
        height: 54,
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
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 160),
                        height: 2,
                        width: activeTab == item.tab ? 116 : 0,
                        decoration: BoxDecoration(
                          color: _predictionPrimary,
                          borderRadius: BorderRadius.circular(1),
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
      spacing: 8,
      runSpacing: 8,
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
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            border: Border.all(
              color: selected ? Colors.transparent : AppColors.border,
            ),
            borderRadius: AppRadii.mdRadius,
          ),
          child: Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: selected ? Colors.white : AppColors.text1,
              fontWeight: AppTextStyles.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}

class _StatsCard extends StatelessWidget {
  const _StatsCard({required this.snapshot});

  final PredictionEventCalendarSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Expanded(
            child: _StatCell(
              label: 'Total',
              value: '${snapshot.events.length}',
            ),
          ),
          Expanded(
            child: _StatCell(
              label: 'Watching',
              value: '${snapshot.watchingCount}',
              color: _predictionPrimary,
            ),
          ),
          Expanded(
            child: _StatCell(
              label: 'This Month',
              value: '${snapshot.thisMonthCount}',
              color: AppColors.buy,
            ),
          ),
        ],
      ),
    );
  }
}

class _MonthSection extends StatelessWidget {
  const _MonthSection({required this.month});

  final PredictionCalendarMonthDraft month;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: month.label,
      accentColor: _predictionPrimary,
      children: [
        for (final event in month.events) _CalendarEventCard(event: event),
      ],
    );
  }
}

class _CalendarEventCard extends StatelessWidget {
  const _CalendarEventCard({required this.event, this.urgent = false});

  final PredictionCalendarEventDraft event;
  final bool urgent;

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(event.status);
    final statusBg = _statusBackground(event.status);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: PredictionEventCalendarPage.eventKey(event.id),
        onTap: () => context.go(AppRoutePaths.marketsPredictionEvent(event.id)),
        borderRadius: AppRadii.cardRadius,
        child: VitCard(
          borderColor: urgent ? AppColors.warningBorder : AppColors.border,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (event.isWatching) ...[
                    const Icon(
                      Icons.star_rounded,
                      color: AppColors.warn,
                      size: 17,
                    ),
                    const SizedBox(width: 6),
                  ] else if (urgent) ...[
                    const Icon(
                      Icons.warning_amber_rounded,
                      color: AppColors.warn,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                  ],
                  Expanded(
                    child: Text(
                      event.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.body.copyWith(
                        fontWeight: AppTextStyles.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: statusBg,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _statusLabel(event.status),
                      style: AppTextStyles.micro.copyWith(
                        color: statusColor,
                        fontWeight: AppTextStyles.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _EventMetric(
                      label: 'Resolution',
                      value: _shortDate(event.resolutionDate),
                    ),
                  ),
                  Expanded(
                    child: _EventMetric(
                      label: 'Probability',
                      value: '${event.probability}%',
                      valueColor: _predictionPrimary,
                    ),
                  ),
                  Expanded(
                    child: _EventMetric(
                      label: 'Volume',
                      value: _formatVolume(event.volume),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(
                    Icons.access_time_rounded,
                    color: AppColors.text3,
                    size: 12,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    _daysUntil(event.resolutionDate),
                    style: AppTextStyles.micro.copyWith(
                      color: urgent ? AppColors.warn : AppColors.text3,
                      fontSize: 11,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.searchBg,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      event.category,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text2,
                        fontSize: 10,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.text3,
                    size: 16,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _UpcomingSection extends StatelessWidget {
  const _UpcomingSection({required this.snapshot});

  final PredictionEventCalendarSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Su kien sap dien ra',
      accentColor: _predictionPrimary,
      children: [
        for (final event in snapshot.upcomingEvents)
          _CalendarEventCard(event: event, urgent: _isUrgent(event)),
      ],
    );
  }
}

class _NotificationSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const settings = [
      (
        label: 'Resolution Reminder',
        desc: 'Thong bao truoc khi su kien chot ket qua',
      ),
      (label: 'Price Alert', desc: 'Canh bao khi xac suat thay doi lon'),
      (
        label: 'New Events',
        desc: 'Thong bao su kien moi theo danh muc quan tam',
      ),
    ];
    return VitPageSection(
      label: 'Cai dat thong bao',
      accentColor: _predictionPrimary,
      children: [
        VitCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              for (var i = 0; i < settings.length; i += 1)
                _NotificationSettingRow(
                  label: settings[i].label,
                  description: settings[i].desc,
                  showDivider: i < settings.length - 1,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _WatchingSection extends StatelessWidget {
  const _WatchingSection({required this.snapshot});

  final PredictionEventCalendarSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Dang theo doi',
      accentColor: _predictionPrimary,
      children: [
        for (final event in snapshot.watchingEvents)
          VitCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      color: AppColors.warn,
                      size: 17,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        event.title,
                        style: AppTextStyles.body.copyWith(
                          fontWeight: AppTextStyles.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: Text(
                    event.category,
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: _EventMetric(
                        label: 'Resolution',
                        value: _shortDate(event.resolutionDate),
                      ),
                    ),
                    Expanded(
                      child: _EventMetric(
                        label: 'Notify Before',
                        value: event.notifyBefore ?? 'Not set',
                        valueColor: _predictionPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 38,
                  width: double.infinity,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.bg,
                      border: Border.all(color: AppColors.border),
                      borderRadius: AppRadii.mdRadius,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.notifications_none_rounded,
                          color: AppColors.text1,
                          size: 15,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Chinh sua thong bao',
                          style: AppTextStyles.caption.copyWith(
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _NotificationInfo extends StatelessWidget {
  const _NotificationInfo();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: AppColors.primary15,
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: _predictionPrimary,
            size: 15,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Thong bao giup ban khong bo lo su kien quan trong. Ban se nhan canh bao qua app va email.',
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text2,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationSettingRow extends StatelessWidget {
  const _NotificationSettingRow({
    required this.label,
    required this.description,
    required this.showDivider,
  });

  final String label;
  final String description;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: showDivider
            ? const Border(bottom: BorderSide(color: AppColors.border))
            : null,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.caption.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          const _TogglePill(),
        ],
      ),
    );
  }
}

class _TogglePill extends StatelessWidget {
  const _TogglePill();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 28,
      decoration: BoxDecoration(
        color: _predictionPrimary,
        borderRadius: AppRadii.inputRadius,
      ),
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.all(2),
      child: Container(
        width: 24,
        height: 24,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class _StatCell extends StatelessWidget {
  const _StatCell({
    required this.label,
    required this.value,
    this.color = AppColors.text1,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: AppTextStyles.baseMedium.copyWith(
            color: color,
            fontSize: 20,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _EventMetric extends StatelessWidget {
  const _EventMetric({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            fontSize: 10,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: AppTextStyles.caption.copyWith(
            color: valueColor,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

bool _isUrgent(PredictionCalendarEventDraft event) {
  final days = event.resolutionDate
      .difference(DateTime.utc(2026, 5, 20))
      .inDays;
  return days >= 0 && days <= 7;
}

Color _statusColor(PredictionCalendarEventStatus status) {
  return switch (status) {
    PredictionCalendarEventStatus.active => AppColors.buy,
    PredictionCalendarEventStatus.upcoming => AppColors.warn,
    PredictionCalendarEventStatus.resolving => _predictionPrimary,
    PredictionCalendarEventStatus.resolved => AppColors.text3,
  };
}

Color _statusBackground(PredictionCalendarEventStatus status) {
  return switch (status) {
    PredictionCalendarEventStatus.active => AppColors.buy10,
    PredictionCalendarEventStatus.upcoming => AppColors.warn10,
    PredictionCalendarEventStatus.resolving => AppColors.primary08,
    PredictionCalendarEventStatus.resolved => const Color(0x146B7280),
  };
}

String _statusLabel(PredictionCalendarEventStatus status) {
  return switch (status) {
    PredictionCalendarEventStatus.active => 'ACTIVE',
    PredictionCalendarEventStatus.upcoming => 'UPCOMING',
    PredictionCalendarEventStatus.resolving => 'RESOLVING',
    PredictionCalendarEventStatus.resolved => 'RESOLVED',
  };
}

String _shortDate(DateTime date) {
  const months = [
    'thg 1',
    'thg 2',
    'thg 3',
    'thg 4',
    'thg 5',
    'thg 6',
    'thg 7',
    'thg 8',
    'thg 9',
    'thg 10',
    'thg 11',
    'thg 12',
  ];
  return '${date.day} ${months[date.month - 1]}';
}

String _daysUntil(DateTime date) {
  final days = date.difference(DateTime.utc(2026, 5, 20)).inDays;
  if (days < 0) return 'Da qua';
  if (days == 0) return 'Hom nay';
  if (days == 1) return '1 ngay';
  if (days < 30) return '$days ngay';
  return '${days ~/ 30} thang';
}

String _formatVolume(double value) =>
    '\$${(value / 1000000).toStringAsFixed(1)}M';
