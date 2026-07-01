import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/features/markets/domain/entities/market_entities.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/market_list_common.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

const double _marketCategoryCompactHeight = AppSpacing.buttonCompact;
const double _marketCategoryCompactGap = AppSpacing.x2;
const EdgeInsets _marketFilterCompactPadding =
    AppSpacing.marketListFilterCompactPadding;

class MarketListSortSheet extends StatelessWidget {
  const MarketListSortSheet({
    super.key,
    required this.sortOptions,
    required this.activeSort,
    required this.onSelected,
  });

  final List<MarketSortOption> sortOptions;
  final String activeSort;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: AppSpacing.marketFilterSheetPadding,
      child: Wrap(
        spacing: AppSpacing.marketFilterGap,
        runSpacing: AppSpacing.marketFilterGap,
        children: [
          for (final option in sortOptions)
            _FilterChipButton(
              label: option.label,
              active: option.id == activeSort,
              onTap: () => onSelected(option.id),
            ),
        ],
      ),
    );
  }
}

class MarketListCategoryTabs extends StatelessWidget {
  const MarketListCategoryTabs({
    super.key,
    required this.categories,
    required this.activeCategory,
    required this.onSelected,
  });

  final List<String> categories;
  final String activeCategory;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _marketCategoryCompactHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemCount: categories.length,
        separatorBuilder: (_, _) =>
            const SizedBox(width: _marketCategoryCompactGap),
        itemBuilder: (context, index) {
          final category = categories[index];
          return _FilterChipButton(
            key: MarketListKeys.category(category),
            label: category,
            active: category == activeCategory,
            activeColor: marketListPrimary,
            minHeight: _marketCategoryCompactHeight,
            onTap: () => onSelected(category),
          );
        },
      ),
    );
  }
}

class _FilterChipButton extends StatelessWidget {
  const _FilterChipButton({
    super.key,
    required this.label,
    required this.active,
    required this.onTap,
    this.activeColor = marketListPrimary,
    this.minHeight = _marketCategoryCompactHeight,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;
  final Color activeColor;
  final double minHeight;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: active,
      label: label,
      child: VitChoicePill(
        label: label,
        selected: active,
        onTap: onTap,
        accentColor: activeColor,
        height: minHeight,
        padding: _marketFilterCompactPadding,
      ),
    );
  }
}
