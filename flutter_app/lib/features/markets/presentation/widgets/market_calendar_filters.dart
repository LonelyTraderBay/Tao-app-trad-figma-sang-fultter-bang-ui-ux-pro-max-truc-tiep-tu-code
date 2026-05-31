import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
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
              height: 2,
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
            const SizedBox(width: 8),
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
    final cfg = marketCalendarImpactConfig(impact);
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
