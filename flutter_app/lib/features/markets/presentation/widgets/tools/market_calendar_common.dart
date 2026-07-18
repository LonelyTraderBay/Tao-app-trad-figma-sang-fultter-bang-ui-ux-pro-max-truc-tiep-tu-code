import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_asset_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/features/markets/domain/entities/market_entities.dart';

const marketCalendarPrimary = AppColors.primary;

final class MarketCalendarKeys {
  const MarketCalendarKeys._();

  static const content = Key('sc017_calendar_scroll_content');
  static const listTab = Key('sc017_calendar_list_tab');
  static const calendarTab = Key('sc017_calendar_grid_tab');

  static Key typeFilter(String label) => Key('sc017_type_$label');

  static Key impactFilter(MarketCalendarImpact impact) =>
      Key('sc017_impact_${impact.name}');

  static Key event(String id) => Key('sc017_event_$id');

  static Key day(int day) => Key('sc017_calendar_day_$day');
}

final class MarketCalendarGroup {
  const MarketCalendarGroup({required this.key, required this.events});

  final String key;
  final List<MarketCalendarEvent> events;
}

List<MarketCalendarGroup> marketCalendarGroupEvents(
  List<MarketCalendarEvent> events,
) {
  final groups = <String, List<MarketCalendarEvent>>{};
  for (final event in events) {
    final date = DateTime.parse(event.dateIso).toLocal();
    final key =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    groups.putIfAbsent(key, () => []).add(event);
  }
  return [
    for (final entry in groups.entries)
      MarketCalendarGroup(
        key: entry.key,
        events: [...entry.value]
          ..sort(
            (a, b) =>
                DateTime.parse(a.dateIso).compareTo(DateTime.parse(b.dateIso)),
          ),
      ),
  ];
}

String marketCalendarFormatEventDate(String dateIso) {
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

// Giờ hiển thị theo múi giờ máy người dùng — nhất quán với cách trang nhóm
// sự kiện theo ngày local (grid tháng + list đều .toLocal()); vì vậy KHÔNG
// gắn nhãn múi giờ (nhãn 'UTC' cũ sai: số là giờ local nhưng dán mác UTC).
String marketCalendarFormatEventTime(String dateIso) {
  final date = DateTime.parse(dateIso).toLocal();
  final hour = date.hour.toString().padLeft(2, '0');
  final minute = date.minute.toString().padLeft(2, '0');
  return '$hour:$minute';
}

String marketCalendarRelativeLabel(String dateIso) {
  final days = marketCalendarDaysUntil(dateIso);
  if (days < 0) return '${days.abs()} ngày trước';
  if (days == 0) return 'Hôm nay';
  if (days == 1) return 'Ngày mai';
  return '$days ngày nữa';
}

int marketCalendarDaysUntil(String dateIso) {
  final now = DateTime.utc(2026, 3, 11, 12);
  final eventDate = DateTime.parse(dateIso).toUtc();
  return (eventDate.difference(now).inMilliseconds /
          Duration.millisecondsPerDay)
      .ceil();
}

final class MarketCalendarTypeFilter {
  const MarketCalendarTypeFilter(this.label, this.type);

  final String label;
  final MarketCalendarEventType? type;
}

const List<MarketCalendarTypeFilter> marketCalendarTypeFilters = [
  MarketCalendarTypeFilter('Tất cả', null),
  MarketCalendarTypeFilter('Token Unlock', MarketCalendarEventType.unlock),
  MarketCalendarTypeFilter('Nâng cấp', MarketCalendarEventType.upgrade),
  MarketCalendarTypeFilter('Airdrop', MarketCalendarEventType.airdrop),
  MarketCalendarTypeFilter('Đốt token', MarketCalendarEventType.burn),
  MarketCalendarTypeFilter('Niêm yết', MarketCalendarEventType.listing),
  MarketCalendarTypeFilter('Báo cáo', MarketCalendarEventType.report),
  MarketCalendarTypeFilter('Hội nghị', MarketCalendarEventType.conference),
];

final class MarketCalendarEventTypeConfig {
  const MarketCalendarEventTypeConfig({
    required this.label,
    required this.color,
    required this.icon,
  });

  final String label;
  final Color color;
  final IconData icon;
}

MarketCalendarEventTypeConfig marketCalendarEventTypeConfig(
  MarketCalendarEventType type,
) {
  return switch (type) {
    MarketCalendarEventType.unlock => const MarketCalendarEventTypeConfig(
      label: 'Token Unlock',
      color: AppColors.caution,
      icon: Icons.lock_open_rounded,
    ),
    MarketCalendarEventType.upgrade => const MarketCalendarEventTypeConfig(
      label: 'Nâng cấp',
      color: marketCalendarPrimary,
      icon: Icons.arrow_upward_rounded,
    ),
    MarketCalendarEventType.halving => const MarketCalendarEventTypeConfig(
      label: 'Halving',
      color: AppColors.accent,
      icon: Icons.bolt_rounded,
    ),
    MarketCalendarEventType.airdrop => const MarketCalendarEventTypeConfig(
      label: 'Airdrop',
      color: AppColors.buy,
      icon: Icons.card_giftcard_rounded,
    ),
    MarketCalendarEventType.listing => const MarketCalendarEventTypeConfig(
      label: 'Niêm yết',
      color: AppAssetColors.cyanChain,
      icon: Icons.receipt_long_rounded,
    ),
    MarketCalendarEventType.fork => const MarketCalendarEventTypeConfig(
      label: 'Fork',
      color: AppColors.sell,
      icon: Icons.call_split_rounded,
    ),
    MarketCalendarEventType.burn => const MarketCalendarEventTypeConfig(
      label: 'Đốt token',
      color: AppColors.riskHigh,
      icon: Icons.local_fire_department_rounded,
    ),
    MarketCalendarEventType.conference => const MarketCalendarEventTypeConfig(
      label: 'Hội nghị',
      color: AppAssetColors.indigoChain,
      icon: Icons.mic_rounded,
    ),
    MarketCalendarEventType.report => const MarketCalendarEventTypeConfig(
      label: 'Báo cáo',
      color: AppColors.text3,
      icon: Icons.bar_chart_rounded,
    ),
  };
}

final class MarketCalendarImpactConfig {
  const MarketCalendarImpactConfig({required this.label, required this.color});

  final String label;
  final Color color;
}

MarketCalendarImpactConfig marketCalendarImpactConfig(
  MarketCalendarImpact impact,
) {
  return switch (impact) {
    MarketCalendarImpact.high => const MarketCalendarImpactConfig(
      label: 'Cao',
      color: AppColors.sell,
    ),
    MarketCalendarImpact.medium => const MarketCalendarImpactConfig(
      label: 'Trung bình',
      color: AppColors.warn,
    ),
    MarketCalendarImpact.low => const MarketCalendarImpactConfig(
      label: 'Thấp',
      color: AppColors.buy,
    ),
  };
}
