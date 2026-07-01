import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/markets/presentation/controllers/market_controller.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/market_sector_common.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

class MarketSectorControls extends StatelessWidget {
  const MarketSectorControls({
    required this.timeframes,
    required this.activeTimeframe,
    required this.sortOptions,
    required this.activeSort,
    required this.onTimeframeSelected,
    required this.onSortSelected,
    super.key,
  });

  final List<String> timeframes;
  final String activeTimeframe;
  final List<MarketSortOption> sortOptions;
  final String activeSort;
  final ValueChanged<String> onTimeframeSelected;
  final ValueChanged<String> onSortSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            for (final timeframe in timeframes) ...[
              _ChipButton(
                key: marketSectorTimeframeKey(timeframe),
                label: timeframe,
                active: timeframe == activeTimeframe,
                onTap: () => onTimeframeSelected(timeframe),
              ),
              if (timeframe != timeframes.last)
                const SizedBox(width: AppSpacing.marketSectorControlChipGap),
            ],
          ],
        ),
        const SizedBox(width: AppSpacing.marketSectorControlGroupGap),
        Expanded(
          child: SizedBox(
            height: AppSpacing.marketSectorControlHeight,
            child: ListView.separated(
              reverse: true,
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              itemCount: sortOptions.length,
              separatorBuilder: (_, _) =>
                  const SizedBox(width: AppSpacing.marketSectorControlChipGap),
              itemBuilder: (context, index) {
                final option = sortOptions[sortOptions.length - 1 - index];
                return _ChipButton(
                  key: marketSectorSortKey(option.id),
                  label: option.label,
                  active: option.id == activeSort,
                  onTap: () => onSortSelected(option.id),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _ChipButton extends StatelessWidget {
  const _ChipButton({
    required this.label,
    required this.active,
    required this.onTap,
    super.key,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: active ? VitCardVariant.inner : VitCardVariant.ghost,
      radius: VitCardRadius.standard,
      borderColor: active
          ? marketSectorPrimary.withValues(alpha: 0.38)
          : AppColors.borderSolid,
      height: AppSpacing.marketSectorControlHeight,
      padding: AppSpacing.marketSectorControlChipPadding,
      onTap: onTap,
      child: Center(
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(
            color: active ? marketSectorPrimary : AppColors.text2,
            fontWeight: AppTextStyles.bold,
            height: AppSpacing.marketSectorLineHeightTight,
          ),
        ),
      ),
    );
  }
}
