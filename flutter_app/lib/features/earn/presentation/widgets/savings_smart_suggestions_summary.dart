import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/earn/domain/entities/earn_entities.dart';
import 'package:vit_trade_flutter/features/earn/presentation/widgets/savings_smart_suggestions_common.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

class SavingsSmartSummary extends StatelessWidget {
  const SavingsSmartSummary({super.key, required this.snapshot});

  final SavingsSmartSuggestionsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: SavingsSmartSuggestionsKeys.summary,
      variant: VitCardVariant.hero,
      radius: VitCardRadius.lg,
      padding: AppSpacing.earnCardPaddingX5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.auto_awesome_rounded,
                color: AppColors.warn,
                size: AppSpacing.iconMd,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  snapshot.heroLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.base.copyWith(color: AppColors.text2),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Gợi ý chưa xử lý',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                    Text(
                      '${snapshot.pendingCount}',
                      style: AppTextStyles.numericDisplay3xl,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Tiềm năng APY tăng',
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                  Text(
                    snapshot.potentialApyGainLabel,
                    style: AppTextStyles.sectionTitle.copyWith(
                      color: AppColors.buy,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x5),
          Row(
            children: [
              Expanded(
                child: SavingsSmartSummaryMetric(
                  label: 'Ưu tiên cao',
                  value: '${snapshot.highPriorityCount}',
                  valueColor: AppColors.sell,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: SavingsSmartSummaryMetric(
                  label: 'Xu hướng',
                  value: '${snapshot.upTrendCount} tăng',
                  icon: Icons.trending_up_rounded,
                  valueColor: AppColors.buy,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: SavingsSmartSummaryMetric(
                  label: 'Tín hiệu',
                  value: '${snapshot.signalCount}',
                  valueColor: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SavingsSmartSummaryMetric extends StatelessWidget {
  const SavingsSmartSummaryMetric({
    super.key,
    required this.label,
    required this.value,
    this.icon,
    this.valueColor = AppColors.text1,
  });

  final String label;
  final String value;
  final IconData? icon;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return VitCardStat(
      padding: AppSpacing.earnCardPaddingX3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x2),
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, color: valueColor, size: AppSpacing.iconSm),
                const SizedBox(width: AppSpacing.x1),
              ],
              Flexible(
                child: Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: savingsSmartCaptionBold.copyWith(
                    color: valueColor,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SavingsSmartTabs extends StatelessWidget {
  const SavingsSmartTabs({
    super.key,
    required this.tabs,
    required this.active,
    required this.onChanged,
  });

  final List<SavingsPreferenceTabDraft> tabs;
  final String active;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitTabBar(
      variant: VitTabBarVariant.underline,
      activeKey: active,
      onChanged: onChanged,
      tabs: [for (final tab in tabs) VitTabItem(key: tab.id, label: tab.label)],
    );
  }
}

class SavingsSmartPriorityFilters extends StatelessWidget {
  const SavingsSmartPriorityFilters({
    super.key,
    required this.filters,
    required this.active,
    required this.onChanged,
  });

  final List<SavingsPreferenceTabDraft> filters;
  final String active;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const ClampingScrollPhysics(),
      child: Row(
        children: [
          for (final filter in filters) ...[
            SavingsSmartFilterChip(
              key: SavingsSmartSuggestionsKeys.filter(filter.id),
              label: filter.label,
              active: filter.id == active,
              tone: savingsSmartFilterTone(filter.id),
              onTap: () => onChanged(filter.id),
            ),
            if (filter != filters.last) const SizedBox(width: AppSpacing.x3),
          ],
        ],
      ),
    );
  }
}

class SavingsSmartFilterChip extends StatelessWidget {
  const SavingsSmartFilterChip({
    super.key,
    required this.label,
    required this.active,
    required this.tone,
    required this.onTap,
  });

  final String label;
  final bool active;
  final Color tone;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitChoicePill(
      label: label,
      selected: active,
      onTap: onTap,
      accentColor: tone,
      padding: AppSpacing.earnWidePillPadding,
    );
  }
}
