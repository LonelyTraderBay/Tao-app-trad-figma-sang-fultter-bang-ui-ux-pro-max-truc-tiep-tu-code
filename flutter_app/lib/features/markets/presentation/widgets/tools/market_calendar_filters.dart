import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/markets/domain/entities/market_entities.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tools/market_calendar_common.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/markets_spacing_tokens.dart';

class MarketCalendarViewTabs extends StatelessWidget {
  const MarketCalendarViewTabs({
    super.key,
    required this.activeView,
    required this.onChanged,
  });

  final String activeView;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitTabBar(
      variant: VitTabBarVariant.segment,
      activeKey: activeView,
      onChanged: onChanged,
      tabs: [
        VitTabItem(
          key: 'list',
          label: 'Danh sách',
          widgetKey: MarketCalendarKeys.listTab,
        ),
        VitTabItem(
          key: 'calendar',
          label: 'Lịch',
          widgetKey: MarketCalendarKeys.calendarTab,
        ),
      ],
    );
  }
}

class MarketCalendarStatsSummary extends StatelessWidget {
  const MarketCalendarStatsSummary({super.key, required this.stats});

  final MarketCalendarStats stats;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _MiniStat(
            label: 'Sắp diễn ra',
            value: stats.upcoming.toString(),
            color: marketCalendarPrimary,
          ),
        ),
        const SizedBox(width: MarketsSpacingTokens.marketCalendarStatsGap),
        Expanded(
          child: _MiniStat(
            label: 'Tác động cao',
            value: stats.highImpact.toString(),
            color: AppColors.sell,
          ),
        ),
        const SizedBox(width: MarketsSpacingTokens.marketCalendarStatsGap),
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
    // card-tile: allow-start — fixed surface, not horizontal strip tile
    return VitCard(
      height: MarketsSpacingTokens.marketCalendarMiniStatHeight,
      padding: MarketsSpacingTokens.marketCalendarMiniStatPadding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: AppTextStyles.sectionTitle.copyWith(
              color: color,
              height: MarketsSpacingTokens.marketSectorLineHeightTight,
            ),
          ),
          const SizedBox(
            height: MarketsSpacingTokens.marketCalendarMiniStatValueGap,
          ),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class MarketCalendarTypeFilters extends StatelessWidget {
  const MarketCalendarTypeFilters({
    super.key,
    required this.active,
    required this.onSelected,
  });

  final MarketCalendarTypeFilter active;
  final ValueChanged<MarketCalendarTypeFilter> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        children: [
          for (final filter in marketCalendarTypeFilters) ...[
            VitFilterChip(
              key: MarketCalendarKeys.typeFilter(filter.label),
              label: filter.label,
              active: filter.label == active.label,
              color: marketCalendarPrimary,
              padding: MarketsSpacingTokens.marketCalendarFilterChipPadding,
              onTap: () => onSelected(filter),
            ),
            const SizedBox(width: MarketsSpacingTokens.marketCalendarFilterGap),
          ],
        ],
      ),
    );
  }
}

class MarketCalendarImpactFilters extends StatelessWidget {
  const MarketCalendarImpactFilters({
    super.key,
    required this.activeImpact,
    required this.onSelected,
  });

  final MarketCalendarImpact? activeImpact;
  final ValueChanged<MarketCalendarImpact> onSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final impact in MarketCalendarImpact.values) ...[
          _ImpactChip(
            key: MarketCalendarKeys.impactFilter(impact),
            impact: impact,
            active: activeImpact == impact,
            onTap: () => onSelected(impact),
          ),
          const SizedBox(width: MarketsSpacingTokens.marketCalendarFilterGap),
        ],
      ],
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
    final cfg = marketCalendarImpactConfig(impact);
    return VitChoicePill(
      label: cfg.label,
      selected: active,
      onTap: onTap,
      accentColor: cfg.color,
      padding: MarketsSpacingTokens.marketCalendarImpactChipPadding,
      leading: Icon(
        Icons.circle,
        size: MarketsSpacingTokens.marketCalendarImpactDot,
      ),
    );
  }
}
