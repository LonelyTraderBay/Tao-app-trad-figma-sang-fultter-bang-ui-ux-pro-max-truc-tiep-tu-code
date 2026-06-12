import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/earn/domain/entities/earn_entities.dart';
import 'package:vit_trade_flutter/features/earn/presentation/widgets/staking_validator_selection_common.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

class StakingValidatorSelectionSearchAndFilter extends StatelessWidget {
  const StakingValidatorSelectionSearchAndFilter({
    super.key,
    required this.controller,
    required this.filterActive,
    required this.onQueryChanged,
    required this.onFilter,
  });

  final TextEditingController controller;
  final bool filterActive;
  final ValueChanged<String> onQueryChanged;
  final VoidCallback onFilter;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.surface3,
              borderRadius: AppRadii.xlRadius,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x4),
              child: Row(
                children: [
                  const Icon(
                    Icons.search_rounded,
                    color: AppColors.text3,
                    size: AppSpacing.stakingValidatorSelectionSearchIcon,
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Expanded(
                    child: TextField(
                      key: StakingValidatorSelectionKeys.search,
                      controller: controller,
                      onChanged: onQueryChanged,
                      style: AppTextStyles.body,
                      decoration: InputDecoration(
                        hintText: 'Tìm validator...',
                        hintStyle: AppTextStyles.caption.copyWith(
                          color: AppColors.text3,
                          fontWeight: AppTextStyles.bold,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.x2),
        Material(
          color: filterActive ? AppColors.primary : AppColors.surface3,
          borderRadius: AppRadii.xlRadius,
          child: InkWell(
            key: StakingValidatorSelectionKeys.filterButton,
            onTap: onFilter,
            borderRadius: AppRadii.xlRadius,
            child: SizedBox(
              width: AppSpacing.buttonStandard,
              height: AppSpacing.buttonStandard,
              child: Icon(
                Icons.filter_alt_outlined,
                color: filterActive ? AppColors.onAccent : AppColors.text1,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class StakingValidatorSelectionFilterPanel extends StatelessWidget {
  const StakingValidatorSelectionFilterPanel({
    super.key,
    required this.sort,
    required this.tier,
    required this.onSortChanged,
    required this.onTierChanged,
    required this.onClear,
  });

  final StakingValidatorSort sort;
  final StakingValidatorTier? tier;
  final ValueChanged<StakingValidatorSort> onSortChanged;
  final ValueChanged<StakingValidatorTier?> onTierChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Bộ lọc & Sắp xếp',
                  style: AppTextStyles.baseMedium,
                ),
              ),
              TextButton(onPressed: onClear, child: const Text('Xóa')),
            ],
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            'Sắp xếp theo',
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: AppSpacing.x2),
          Wrap(
            spacing: AppSpacing.x2,
            runSpacing: AppSpacing.x2,
            children: [
              for (final value in StakingValidatorSort.values)
                _FilterChip(
                  label: stakingValidatorSortLabel(value),
                  selected: sort == value,
                  onTap: () => onSortChanged(value),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Text(
            'Tier',
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: AppSpacing.x2),
          Wrap(
            spacing: AppSpacing.x2,
            runSpacing: AppSpacing.x2,
            children: [
              _FilterChip(
                label: 'Tất cả',
                selected: tier == null,
                onTap: () => onTierChanged(null),
              ),
              for (final value in StakingValidatorTier.values)
                _FilterChip(
                  label: stakingValidatorTierLabel(value),
                  selected: tier == value,
                  onTap: () => onTierChanged(value),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.primary12 : AppColors.surface2,
      borderRadius: AppRadii.smRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.smRadius,
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(
              color: selected ? AppColors.primary30 : AppColors.cardBorder,
            ),
            borderRadius: AppRadii.smRadius,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.x3,
              vertical: AppSpacing.x2,
            ),
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: selected ? AppColors.primarySoft : AppColors.text2,
                fontWeight: AppTextStyles.medium,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class StakingValidatorSelectionResultsHeader extends StatelessWidget {
  const StakingValidatorSelectionResultsHeader({
    super.key,
    required this.count,
    required this.total,
    required this.filtered,
    required this.sort,
    required this.onClear,
  });

  final int count;
  final int total;
  final bool filtered;
  final StakingValidatorSort sort;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            filtered
                ? '$count validators (đã lọc từ $total)'
                : '$count validators',
            key: StakingValidatorSelectionKeys.resultCount,
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
        ),
        if (filtered)
          TextButton(onPressed: onClear, child: const Text('Xóa'))
        else
          Text(
            'Sắp xếp: ${stakingValidatorSortShortLabel(sort)}',
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
      ],
    );
  }
}
