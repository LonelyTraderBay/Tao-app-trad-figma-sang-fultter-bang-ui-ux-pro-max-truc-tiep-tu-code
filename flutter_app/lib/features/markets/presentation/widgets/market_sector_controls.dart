import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
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
              IntrinsicWidth(
                child: VitChoicePill(
                  key: marketSectorTimeframeKey(timeframe),
                  label: timeframe,
                  selected: timeframe == activeTimeframe,
                  onTap: () => onTimeframeSelected(timeframe),
                  accentColor: marketSectorPrimary,
                  height: AppSpacing.marketSectorControlHeight,
                  padding: AppSpacing.marketSectorControlChipPadding,
                ),
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
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              reverse: true,
              child: Row(
                children: [
                  for (final option in sortOptions.reversed) ...[
                    IntrinsicWidth(
                      child: VitChoicePill(
                        key: marketSectorSortKey(option.id),
                        label: option.label,
                        selected: option.id == activeSort,
                        onTap: () => onSortSelected(option.id),
                        accentColor: marketSectorPrimary,
                        height: AppSpacing.marketSectorControlHeight,
                        padding: AppSpacing.marketSectorControlChipPadding,
                      ),
                    ),
                    if (option != sortOptions.first)
                      const SizedBox(
                        width: AppSpacing.marketSectorControlChipGap,
                      ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
