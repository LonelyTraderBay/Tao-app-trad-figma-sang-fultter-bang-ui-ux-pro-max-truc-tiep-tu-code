import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/markets/domain/entities/market_entities.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tools/market_calendar_common.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/markets_spacing_tokens.dart';

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
      padding: MarketsSpacingTokens.marketCalendarMonthPadding,
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
          const SizedBox(
            height: MarketsSpacingTokens.marketCalendarMonthTitleGap,
          ),
          GridView.count(
            crossAxisCount: MarketsSpacingTokens.marketCalendarGridColumns,
            mainAxisSpacing: MarketsSpacingTokens.marketCalendarGridSpacing,
            crossAxisSpacing: MarketsSpacingTokens.marketCalendarGridSpacing,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: MarketsSpacingTokens.marketCalendarGridAspect,
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
          const SizedBox(
            height: MarketsSpacingTokens.marketCalendarMonthDividerTopGap,
          ),
          const Divider(
            height: AppSpacing.dividerHairline,
            color: AppColors.divider,
          ),
          const SizedBox(
            height: MarketsSpacingTokens.marketCalendarMonthLegendTopGap,
          ),
          Wrap(
            spacing: MarketsSpacingTokens.marketCalendarLegendSpacing,
            runSpacing: MarketsSpacingTokens.marketCalendarLegendRunSpacing,
            children: [
              for (final type in [
                MarketCalendarEventType.unlock,
                MarketCalendarEventType.upgrade,
                MarketCalendarEventType.airdrop,
                MarketCalendarEventType.burn,
                MarketCalendarEventType.report,
              ])
                VitLegendItem(
                  label: marketCalendarEventTypeConfig(type).label,
                  color: marketCalendarEventTypeConfig(type).color,
                  dotSize: MarketsSpacingTokens.marketCalendarLegendDot,
                ),
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

    return VitCard(
      variant: isToday || hasEvents
          ? VitCardVariant.inner
          : VitCardVariant.ghost,
      radius: VitCardRadius.standard,
      borderColor: isToday
          ? marketCalendarPrimary.withValues(alpha: .35)
          : AppColors.transparent,
      padding: EdgeInsets.zero,
      onTap: hasEvents ? () => onEventDaySelected(events.first) : null,
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
            const SizedBox(
              height: MarketsSpacingTokens.marketCalendarGridSpacing,
            ),
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
                      dimension: MarketsSpacingTokens.marketCalendarEventDot,
                    ),
                  ),
                  const SizedBox(
                    width: MarketsSpacingTokens.marketCalendarEventDotGap,
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }
}
