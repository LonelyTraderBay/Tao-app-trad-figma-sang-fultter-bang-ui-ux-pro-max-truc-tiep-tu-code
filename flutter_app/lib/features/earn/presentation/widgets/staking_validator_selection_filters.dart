import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/earn/domain/entities/earn_entities.dart';
import 'package:vit_trade_flutter/features/earn/presentation/widgets/staking_validator_selection_common.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/earn_spacing_tokens.dart';

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
            decoration: const ShapeDecoration(
              color: AppColors.surface3,
              shape: RoundedRectangleBorder(borderRadius: AppRadii.xlRadius),
            ),
            child: Padding(
              padding: EarnSpacingTokens.earnHorizontalPaddingX4,
              child: Row(
                children: [
                  const Icon(
                    Icons.search_rounded,
                    color: AppColors.text3,
                    size: EarnSpacingTokens.stakingValidatorSelectionSearchIcon,
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
        VitIconButton(
          key: StakingValidatorSelectionKeys.filterButton,
          icon: Icons.filter_alt_outlined,
          tooltip: 'Bo loc validator',
          onPressed: onFilter,
          variant: filterActive
              ? VitIconButtonVariant.primary
              : VitIconButtonVariant.ghost,
          size: VitIconButtonSize.lg,
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
      padding: EarnSpacingTokens.earnCardPaddingX4,
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
              VitCtaButton(
                onPressed: onClear,
                variant: VitCtaButtonVariant.ghost,
                fullWidth: false,
                height: AppSpacing.buttonCompact,
                child: const Text('Xóa'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            'Sắp xếp theo',
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Wrap(
            spacing: AppSpacing.x2,
            runSpacing: AppSpacing.x2,
            children: [
              for (final value in StakingValidatorSort.values)
                VitChoicePill(
                  label: stakingValidatorSortLabel(value),
                  selected: sort == value,
                  onTap: () => onSortChanged(value),
                  accentColor: AppColors.primarySoft,
                  padding: EarnSpacingTokens.earnWidePillPadding,
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          Text(
            'Tier',
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Wrap(
            spacing: AppSpacing.x2,
            runSpacing: AppSpacing.x2,
            children: [
              VitChoicePill(
                label: 'Tất cả',
                selected: tier == null,
                onTap: () => onTierChanged(null),
                accentColor: AppColors.primarySoft,
                padding: EarnSpacingTokens.earnWidePillPadding,
              ),
              for (final value in StakingValidatorTier.values)
                VitChoicePill(
                  label: stakingValidatorTierLabel(value),
                  selected: tier == value,
                  onTap: () => onTierChanged(value),
                  accentColor: AppColors.primarySoft,
                  padding: EarnSpacingTokens.earnWidePillPadding,
                ),
            ],
          ),
        ],
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
          VitCtaButton(
            onPressed: onClear,
            variant: VitCtaButtonVariant.ghost,
            fullWidth: false,
            height: AppSpacing.buttonCompact,
            child: const Text('Xóa'),
          )
        else
          Text(
            'Sắp xếp: ${stakingValidatorSortShortLabel(sort)}',
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
      ],
    );
  }
}
