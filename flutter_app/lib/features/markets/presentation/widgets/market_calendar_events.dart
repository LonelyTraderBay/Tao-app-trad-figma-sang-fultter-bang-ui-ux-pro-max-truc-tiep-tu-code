import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/markets/domain/entities/market_entities.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/market_calendar_common.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

class MarketCalendarEventGroups extends StatelessWidget {
  const MarketCalendarEventGroups({
    super.key,
    required this.events,
    required this.expandedId,
    required this.onToggle,
  });

  final List<MarketCalendarEvent> events;
  final String? expandedId;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    final groups = marketCalendarGroupEvents(events);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final group in groups) ...[
          _DateHeader(event: group.events.first),
          const SizedBox(height: 8),
          for (final event in group.events) ...[
            _EventCard(
              key: MarketCalendarKeys.event(event.id),
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
          marketCalendarFormatEventDate(event.dateIso),
          style: AppTextStyles.body.copyWith(
            color: AppColors.text1,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          marketCalendarRelativeLabel(event.dateIso),
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
    final type = marketCalendarEventTypeConfig(event.type);
    final impact = marketCalendarImpactConfig(event.impact);
    final days = marketCalendarDaysUntil(event.dateIso);

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
                            marketCalendarFormatEventTime(event.dateIso),
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
