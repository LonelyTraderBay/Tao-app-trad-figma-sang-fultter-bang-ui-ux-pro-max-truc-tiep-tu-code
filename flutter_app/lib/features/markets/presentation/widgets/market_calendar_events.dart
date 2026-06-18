import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
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
          const SizedBox(height: AppSpacing.marketCalendarGroupGap),
          for (final event in group.events) ...[
            _EventCard(
              key: MarketCalendarKeys.event(event.id),
              event: event,
              expanded: expandedId == event.id,
              onTap: () => onToggle(event.id),
            ),
            const SizedBox(height: AppSpacing.marketCalendarGroupGap),
          ],
          const SizedBox(height: AppSpacing.marketCalendarGroupGap),
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
        const SizedBox(width: AppSpacing.marketCalendarDateHeaderGap),
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
            padding: AppSpacing.marketCalendarEventCardPadding,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Material(
                  color: type.color.withValues(alpha: .13),
                  borderRadius: AppRadii.smRadius,
                  child: SizedBox.square(
                    dimension: AppSpacing.marketCalendarEventIcon,
                    child: Icon(
                      type.icon,
                      color: type.color,
                      size: AppSpacing.marketCalendarEventIconGlyph,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.marketCalendarEventIconGap),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: AppSpacing.marketCalendarBadgeSpacing,
                        runSpacing: AppSpacing.marketCalendarBadgeRunSpacing,
                        children: [
                          if (event.symbol != null)
                            _TinyBadge(
                              label: event.symbol!,
                              color: event.symbolColor ?? type.color,
                            ),
                          _TinyBadge(label: type.label, color: type.color),
                        ],
                      ),
                      const SizedBox(
                        height: AppSpacing.marketCalendarEventTitleGap,
                      ),
                      Text(
                        event.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.medium,
                          height: AppSpacing.marketCalendarEventTitleLineHeight,
                        ),
                      ),
                      const SizedBox(
                        height: AppSpacing.marketCalendarEventMetaGap,
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.access_time_rounded,
                            color: AppColors.text3,
                            size: AppSpacing.marketCalendarEventTimeIcon,
                          ),
                          const SizedBox(
                            width: AppSpacing.marketCalendarEventTimeGap,
                          ),
                          Text(
                            marketCalendarFormatEventTime(event.dateIso),
                            style: AppTextStyles.micro.copyWith(
                              color: AppColors.text3,
                            ),
                          ),
                          const SizedBox(
                            width: AppSpacing.marketCalendarEventImpactGap,
                          ),
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
                const SizedBox(
                  width: AppSpacing.marketCalendarEventCountdownGap,
                ),
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(
                  height: AppSpacing.dividerHairline,
                  color: AppColors.divider,
                ),
                Padding(
                  padding: AppSpacing.marketCalendarEventExpandedPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.description,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text2,
                          height: AppSpacing
                              .marketCalendarEventDescriptionLineHeight,
                        ),
                      ),
                      if (event.source != null) ...[
                        const SizedBox(
                          height: AppSpacing.marketCalendarEventSourceGap,
                        ),
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
              ],
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
    return VitAccentPill(label: label, accentColor: color);
  }
}
