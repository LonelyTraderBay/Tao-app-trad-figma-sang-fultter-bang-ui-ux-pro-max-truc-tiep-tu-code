import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/markets/domain/entities/market_entities.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/market_calendar_common.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

class MarketCalendarMonthGrid extends StatelessWidget {
  const MarketCalendarMonthGrid({
    super.key,
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
      padding: AppSpacing.marketCalendarMonthPadding,
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
          const SizedBox(height: AppSpacing.marketCalendarMonthTitleGap),
          GridView.count(
            crossAxisCount: AppSpacing.marketCalendarGridColumns,
            mainAxisSpacing: AppSpacing.marketCalendarGridSpacing,
            crossAxisSpacing: AppSpacing.marketCalendarGridSpacing,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: AppSpacing.marketCalendarGridAspect,
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
                  key: MarketCalendarKeys.day(day),
                  day: day,
                  events: eventsByDay[day] ?? const [],
                  onEventDaySelected: onEventDaySelected,
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.marketCalendarMonthDividerTopGap),
          const Divider(
            height: AppSpacing.dividerHairline,
            color: AppColors.divider,
          ),
          const SizedBox(height: AppSpacing.marketCalendarMonthLegendTopGap),
          Wrap(
            spacing: AppSpacing.marketCalendarLegendSpacing,
            runSpacing: AppSpacing.marketCalendarLegendRunSpacing,
            children: [
              for (final type in [
                MarketCalendarEventType.unlock,
                MarketCalendarEventType.upgrade,
                MarketCalendarEventType.airdrop,
                MarketCalendarEventType.burn,
                MarketCalendarEventType.report,
              ])
                _LegendItem(config: marketCalendarEventTypeConfig(type)),
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
      child: Material(
        color: isToday
            ? marketCalendarPrimary.withValues(alpha: .12)
            : hasEvents
            ? AppColors.surface2
            : AppColors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadii.smRadius,
          side: BorderSide(
            color: isToday
                ? marketCalendarPrimary.withValues(alpha: .35)
                : AppColors.transparent,
            width: AppSpacing.marketCalendarDayBorderWidth,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              day.toString(),
              style: AppTextStyles.caption.copyWith(
                color: isToday ? marketCalendarPrimary : AppColors.text1,
                fontWeight: isToday ? AppTextStyles.bold : AppTextStyles.medium,
              ),
            ),
            if (hasEvents) ...[
              const SizedBox(height: AppSpacing.marketCalendarGridSpacing),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (final event in events.take(3)) ...[
                    Material(
                      color: hasHigh
                          ? AppColors.sell
                          : marketCalendarEventTypeConfig(event.type).color,
                      shape: const CircleBorder(),
                      child: const SizedBox.square(
                        dimension: AppSpacing.marketCalendarEventDot,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.marketCalendarEventDotGap),
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

  final MarketCalendarEventTypeConfig config;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: config.color,
          shape: const CircleBorder(),
          child: const SizedBox.square(
            dimension: AppSpacing.marketCalendarLegendDot,
          ),
        ),
        const SizedBox(width: AppSpacing.marketCalendarLegendGap),
        Text(
          config.label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
      ],
    );
  }
}
