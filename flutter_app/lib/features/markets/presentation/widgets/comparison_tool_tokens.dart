import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
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
      height: 52,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemCount: selectedPairs.length + (canAdd ? 1 : 0),
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          if (index == selectedPairs.length) {
            return InkWell(
              key: ComparisonToolKeys.addToken,
              onTap: onAdd,
              borderRadius: AppRadii.cardRadius,
              child: Container(
                width: 82,
                height: 52,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: comparisonToolPrimary.withValues(alpha: .38),
                    style: BorderStyle.solid,
                  ),
                  borderRadius: AppRadii.cardRadius,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.add_rounded,
                      color: AppColors.text3,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Thêm',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                        fontSize: 12,
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final pair = selectedPairs[index];
          return Container(
            key: ComparisonToolKeys.token(pair.id),
            height: 52,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border.all(color: AppColors.cardBorder),
              borderRadius: AppRadii.cardRadius,
            ),
            child: Row(
              children: [
                ComparisonAvatar(pair: pair, size: 28),
                const SizedBox(width: 9),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pair.baseAsset,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontSize: 13,
                        fontWeight: AppTextStyles.bold,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      comparisonFormatPercent(pair.change24h),
                      style: AppTextStyles.micro.copyWith(
                        color: pair.change24h >= 0
                            ? AppColors.buy
                            : AppColors.sell,
                        fontWeight: AppTextStyles.bold,
                        height: 1,
                      ),
                    ),
                  ],
                ),
                if (canRemove) ...[
                  const SizedBox(width: 8),
                  InkWell(
                    key: ComparisonToolKeys.removeToken(pair.id),
                    onTap: () => onRemove(pair.id),
                    child: const Icon(
                      Icons.close_rounded,
                      color: AppColors.text3,
                      size: 14,
                    ),
                  ),
                ],
              ],
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
      padding: const EdgeInsets.all(16),
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
          const SizedBox(height: 12),
          Container(
            key: ComparisonToolKeys.pickerSearch,
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.surface2,
              borderRadius: AppRadii.smRadius,
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.search_rounded,
                  color: AppColors.text3,
                  size: 15,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: controller,
                    onChanged: (_) => onChanged(),
                    autofocus: true,
                    cursorColor: comparisonToolPrimary,
                    style: AppTextStyles.caption.copyWith(fontSize: 12),
                    decoration: InputDecoration.collapsed(
                      hintText: 'Tìm BTC, ETH...',
                      hintStyle: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          if (search.isEmpty)
            Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
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
          const SizedBox(height: 10),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 190),
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
      child: Container(
        height: 34,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: pair.logoColor.withValues(alpha: .12),
          borderRadius: AppRadii.smRadius,
        ),
        child: Text(
          pair.baseAsset,
          style: AppTextStyles.caption.copyWith(
            color: pair.logoColor,
            fontSize: 12,
            fontWeight: AppTextStyles.bold,
            height: 1,
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
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            ComparisonAvatar(pair: pair, size: 26),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                pair.baseAsset,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.medium,
                ),
              ),
            ),
            Text(
              '\$${comparisonFormatPrice(pair.price)}',
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
