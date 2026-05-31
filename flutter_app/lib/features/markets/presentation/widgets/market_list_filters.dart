import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/markets/domain/entities/market_entities.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/market_list_common.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

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
      padding: const EdgeInsets.all(12),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
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
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemCount: categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 9),
        itemBuilder: (context, index) {
          final category = categories[index];
          return _FilterChipButton(
            key: MarketListKeys.category(category),
            label: category,
            active: category == activeCategory,
            activeColor: marketListPrimary,
            minHeight: 36,
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
    this.minHeight = 34,
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
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.cardRadius,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          constraints: BoxConstraints(minHeight: minHeight),
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
          decoration: BoxDecoration(
            color: active
                ? activeColor.withValues(alpha: 0.16)
                : AppColors.transparent,
            border: Border.all(
              color: active
                  ? activeColor.withValues(alpha: 0.42)
                  : AppColors.transparent,
            ),
            borderRadius: AppRadii.cardRadius,
          ),
          child: Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: active ? activeColor : AppColors.text2,
              fontWeight: AppTextStyles.medium,
              height: 1.1,
            ),
          ),
        ),
      ),
    );
  }
}
