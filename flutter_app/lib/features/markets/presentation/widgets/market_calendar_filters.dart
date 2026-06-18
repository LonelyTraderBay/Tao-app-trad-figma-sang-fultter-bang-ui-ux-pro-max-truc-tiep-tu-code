import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/markets/domain/entities/market_entities.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/market_calendar_common.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

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
    return Material(
      color: AppColors.surface,
      child: SizedBox(
        height: AppSpacing.marketCalendarViewTabHeight,
        child: Row(
          children: [
            _UnderlineViewTab(
              key: MarketCalendarKeys.listTab,
              label: 'Danh sách',
              value: 'list',
              active: activeView == 'list',
              onChanged: onChanged,
            ),
            _UnderlineViewTab(
              key: MarketCalendarKeys.calendarTab,
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
                    color: active ? marketCalendarPrimary : AppColors.text3,
                    fontWeight: AppTextStyles.medium,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: AppSpacing.marketCalendarViewUnderlineHeight,
              child: FractionallySizedBox(
                widthFactor: active ? 1 : 0,
                alignment: Alignment.center,
                child: const ColoredBox(color: marketCalendarPrimary),
              ),
            ),
          ],
        ),
      ),
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
        const SizedBox(width: AppSpacing.marketCalendarStatsGap),
        Expanded(
          child: _MiniStat(
            label: 'Tác động cao',
            value: stats.highImpact.toString(),
            color: AppColors.sell,
          ),
        ),
        const SizedBox(width: AppSpacing.marketCalendarStatsGap),
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
      height: AppSpacing.marketCalendarMiniStatHeight,
      padding: AppSpacing.marketCalendarMiniStatPadding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: AppTextStyles.sectionTitle.copyWith(
              color: color,
              height: AppSpacing.marketSectorLineHeightTight,
            ),
          ),
          const SizedBox(height: AppSpacing.marketCalendarMiniStatValueGap),
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
            _FilterChipButton(
              key: MarketCalendarKeys.typeFilter(filter.label),
              label: filter.label,
              active: filter.label == active.label,
              activeColor: marketCalendarPrimary,
              onTap: () => onSelected(filter),
            ),
            const SizedBox(width: AppSpacing.marketCalendarFilterGap),
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
          const SizedBox(width: AppSpacing.marketCalendarFilterGap),
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
    final shape = RoundedRectangleBorder(
      borderRadius: AppRadii.cardRadius,
      side: BorderSide(
        color: active
            ? activeColor.withValues(alpha: .55)
            : AppColors.transparent,
      ),
    );

    return Material(
      color: active ? activeColor.withValues(alpha: .18) : AppColors.surface2,
      shape: shape,
      child: InkWell(
        onTap: onTap,
        customBorder: shape,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: AppSpacing.marketCalendarFilterChipHeight,
          ),
          child: Padding(
            padding: AppSpacing.marketCalendarFilterChipPadding,
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: active ? activeColor : AppColors.text3,
                fontWeight: AppTextStyles.medium,
              ),
            ),
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
    final cfg = marketCalendarImpactConfig(impact);
    final shape = RoundedRectangleBorder(
      borderRadius: AppRadii.smRadius,
      side: BorderSide(
        color: active
            ? cfg.color.withValues(alpha: .38)
            : AppColors.borderSolid,
      ),
    );

    return Material(
      color: active ? cfg.color.withValues(alpha: .14) : AppColors.transparent,
      shape: shape,
      child: InkWell(
        onTap: onTap,
        customBorder: shape,
        child: Padding(
          padding: AppSpacing.marketCalendarImpactChipPadding,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Material(
                color: cfg.color,
                shape: const CircleBorder(),
                child: const SizedBox.square(
                  dimension: AppSpacing.marketCalendarImpactDot,
                ),
              ),
              const SizedBox(width: AppSpacing.marketCalendarBadgeSpacing),
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
      ),
    );
  }
}
