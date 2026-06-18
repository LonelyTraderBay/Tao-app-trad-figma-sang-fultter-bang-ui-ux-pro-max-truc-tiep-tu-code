import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/markets/domain/entities/market_entities.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/comparison_tool_common.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

class ComparisonSelectedTokensStrip extends StatelessWidget {
  const ComparisonSelectedTokensStrip({
    super.key,
    required this.selectedPairs,
    required this.canAdd,
    required this.canRemove,
    required this.onAdd,
    required this.onRemove,
  });

  final List<MarketPair> selectedPairs;
  final bool canAdd;
  final bool canRemove;
  final VoidCallback onAdd;
  final ValueChanged<String> onRemove;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSpacing.comparisonToolStripHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemCount: selectedPairs.length + (canAdd ? 1 : 0),
        separatorBuilder: (_, _) =>
            const SizedBox(width: AppSpacing.comparisonToolStripGap),
        itemBuilder: (context, index) {
          if (index == selectedPairs.length) {
            return InkWell(
              key: ComparisonToolKeys.addToken,
              onTap: onAdd,
              borderRadius: AppRadii.cardRadius,
              child: Material(
                color: AppColors.transparent,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: comparisonToolPrimary.withValues(alpha: .38),
                  ),
                  borderRadius: AppRadii.cardRadius,
                ),
                child: SizedBox(
                  width: AppSpacing.comparisonToolAddWidth,
                  height: AppSpacing.comparisonToolStripHeight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.add_rounded,
                        color: AppColors.text3,
                        size: AppSpacing.comparisonToolAddIcon,
                      ),
                      const SizedBox(width: AppSpacing.comparisonToolAddGap),
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'Th\u00C3\u00AAm',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text3,
                              height: AppSpacing.marketLineHeightTight,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          final pair = selectedPairs[index];
          return Material(
            key: ComparisonToolKeys.token(pair.id),
            color: AppColors.surface,
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: AppColors.cardBorder),
              borderRadius: AppRadii.cardRadius,
            ),
            child: SizedBox(
              height: AppSpacing.comparisonToolStripHeight,
              child: Padding(
                padding: AppSpacing.comparisonToolTokenPadding,
                child: Row(
                  children: [
                    ComparisonAvatar(
                      pair: pair,
                      size: AppSpacing.comparisonToolTokenAvatar,
                    ),
                    const SizedBox(
                      width: AppSpacing.comparisonToolTokenTextGap,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pair.baseAsset,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text1,
                            fontWeight: AppTextStyles.bold,
                            height: AppSpacing.marketLineHeightTight,
                          ),
                        ),
                        const SizedBox(
                          height: AppSpacing.comparisonToolTokenMetricGap,
                        ),
                        Text(
                          comparisonFormatPercent(pair.change24h),
                          style: AppTextStyles.micro.copyWith(
                            color: pair.change24h >= 0
                                ? AppColors.buy
                                : AppColors.sell,
                            fontWeight: AppTextStyles.bold,
                            height: AppSpacing.marketLineHeightTight,
                          ),
                        ),
                      ],
                    ),
                    if (canRemove) ...[
                      const SizedBox(width: AppSpacing.comparisonToolRemoveGap),
                      InkWell(
                        key: ComparisonToolKeys.removeToken(pair.id),
                        onTap: () => onRemove(pair.id),
                        child: const Icon(
                          Icons.close_rounded,
                          color: AppColors.text3,
                          size: AppSpacing.comparisonToolRemoveIcon,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class ComparisonTokenPickerCard extends StatelessWidget {
  const ComparisonTokenPickerCard({
    super.key,
    required this.snapshot,
    required this.selectedIds,
    required this.controller,
    required this.onChanged,
    required this.onClose,
    required this.onTokenSelected,
  });

  final MarketComparisonSnapshot snapshot;
  final List<String> selectedIds;
  final TextEditingController controller;
  final VoidCallback onChanged;
  final VoidCallback onClose;
  final ValueChanged<String> onTokenSelected;

  @override
  Widget build(BuildContext context) {
    final search = controller.text.trim().toLowerCase();
    final availablePairs = [
      for (final pair in snapshot.marketPairs)
        if (!selectedIds.contains(pair.id) &&
            (search.isEmpty ||
                pair.baseAsset.toLowerCase().contains(search) ||
                pair.symbol.toLowerCase().contains(search)))
          pair,
    ];

    return VitCard(
      key: ComparisonToolKeys.picker,
      padding: AppSpacing.comparisonToolPickerPadding,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Chọn token so sánh',
                  style: AppTextStyles.body.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              InkWell(
                onTap: onClose,
                borderRadius: AppRadii.smRadius,
                child: const Icon(
                  Icons.close_rounded,
                  color: AppColors.text3,
                  size: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.comparisonToolPickerGap),
          Material(
            key: ComparisonToolKeys.pickerSearch,
            color: AppColors.surface2,
            borderRadius: AppRadii.smRadius,
            child: SizedBox(
              height: AppSpacing.comparisonToolPickerSearchHeight,
              child: Padding(
                padding: AppSpacing.comparisonToolPickerSearchPadding,
                child: Row(
                  children: [
                    const Icon(
                      Icons.search_rounded,
                      color: AppColors.text3,
                      size: AppSpacing.comparisonToolPickerIcon,
                    ),
                    const SizedBox(
                      width: AppSpacing.comparisonToolPickerSearchIconGap,
                    ),
                    Expanded(
                      child: TextField(
                        controller: controller,
                        onChanged: (_) => onChanged(),
                        autofocus: true,
                        cursorColor: comparisonToolPrimary,
                        style: AppTextStyles.caption,
                        decoration: InputDecoration.collapsed(
                          hintText: 'Tìm BTC, ETH...',
                          hintStyle: AppTextStyles.caption.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.comparisonToolPickerGap),
          if (search.isEmpty)
            Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                spacing: AppSpacing.comparisonToolPickerQuickGap,
                runSpacing: AppSpacing.comparisonToolPickerQuickGap,
                children: [
                  for (final id in snapshot.popularPairIds)
                    if (!selectedIds.contains(id))
                      Builder(
                        builder: (context) {
                          final pair = comparisonFindPair(
                            snapshot.marketPairs,
                            id,
                          );
                          if (pair == null) return const SizedBox.shrink();
                          return _PickerQuickChip(
                            pair: pair,
                            onTap: () => onTokenSelected(id),
                          );
                        },
                      ),
                ],
              ),
            ),
          const SizedBox(height: AppSpacing.comparisonToolPickerListGap),
          ConstrainedBox(
            constraints: const BoxConstraints(
              maxHeight: AppSpacing.comparisonToolPickerListMaxHeight,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  for (final pair in availablePairs)
                    _PickerRow(
                      pair: pair,
                      onTap: () => onTokenSelected(pair.id),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PickerQuickChip extends StatelessWidget {
  const _PickerQuickChip({required this.pair, required this.onTap});

  final MarketPair pair;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: ComparisonToolKeys.pickerQuickToken(pair.id),
      onTap: onTap,
      borderRadius: AppRadii.smRadius,
      child: Material(
        color: pair.logoColor.withValues(alpha: .12),
        borderRadius: AppRadii.smRadius,
        child: SizedBox(
          height: AppSpacing.comparisonToolPickerQuickHeight,
          child: Padding(
            padding: AppSpacing.comparisonToolPickerQuickPadding,
            child: Center(
              child: Text(
                pair.baseAsset,
                style: AppTextStyles.caption.copyWith(
                  color: pair.logoColor,
                  fontWeight: AppTextStyles.bold,
                  height: AppSpacing.marketLineHeightTight,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PickerRow extends StatelessWidget {
  const _PickerRow({required this.pair, required this.onTap});

  final MarketPair pair;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: ComparisonToolKeys.pickerToken(pair.id),
      onTap: onTap,
      borderRadius: AppRadii.smRadius,
      child: SizedBox(
        height: AppSpacing.comparisonToolPickerRowHeight,
        child: Padding(
          padding: AppSpacing.comparisonToolPickerRowPadding,
          child: Row(
            children: [
              ComparisonAvatar(
                pair: pair,
                size: AppSpacing.comparisonToolPickerRowAvatar,
              ),
              const SizedBox(width: AppSpacing.comparisonToolPickerRowGap),
              Expanded(
                child: Text(
                  pair.baseAsset,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.medium,
                  ),
                ),
              ),
              Flexible(
                child: Text(
                  '\$${comparisonFormatPrice(pair.price)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
