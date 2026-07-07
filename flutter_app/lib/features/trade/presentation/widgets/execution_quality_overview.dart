import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/execution_quality_common.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

class ExecutionQualityIntroCard extends StatelessWidget {
  const ExecutionQualityIntroCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ExecutionQualityPanel(
      borderColor: executionQualityPrimary.withValues(alpha: .30),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ExecutionQualityIconTile(
            icon: Icons.bolt_rounded,
            color: executionQualityPrimary,
            size: AppSpacing.tradeToolIconTileSm,
          ),
          const SizedBox(width: AppSpacing.tradeToolCardGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Phase 2: Execution Quality',
                  style: AppTextStyles.baseMedium.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                Text(
                  '3 công cụ đảm bảo execution tối ưu: bảo vệ khỏi slippage xấu, transparency về routing, và modify orders không mất queue position.',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    height: 1.55,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ExecutionQualityFeatureCard extends StatelessWidget {
  const ExecutionQualityFeatureCard({
    required this.feature,
    required this.onTap,
    super.key,
  });

  final TradeExecutionFeature feature;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = Color(feature.colorHex);
    return VitCard(
      key: executionQualityFeatureKey(feature.id),
      onTap: onTap,
      padding: AppSpacing.tradeToolRiskIntroPadding,
      variant: VitCardVariant.inner,
      child: Row(
        children: [
          ExecutionQualityIconTile(
            icon: _iconFor(feature.id),
            color: color,
            size: AppSpacing.tradeToolIconTileMd,
          ),
          const SizedBox(width: AppSpacing.tradeToolCardGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  feature.title,
                  style: AppTextStyles.caption.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  feature.description,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.tradeToolInlineGap),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.text3,
            size: 20,
          ),
        ],
      ),
    );
  }

  IconData _iconFor(String id) {
    return switch (id) {
      'execution' => Icons.bar_chart_rounded,
      'amendment' => Icons.edit_rounded,
      _ => Icons.shield_rounded,
    };
  }
}

class ExecutionQualityBenefitsCard extends StatelessWidget {
  const ExecutionQualityBenefitsCard({super.key});

  static const _items = [
    (
      Icons.security_rounded,
      'Slippage giảm 25 bps',
      'Trung bình từ 0.15% xuống 0.025%',
    ),
    (Icons.diamond_rounded, 'Best execution', 'Smart routing qua 3+ venues'),
    (
      Icons.flash_on_rounded,
      'Modify nhanh hơn',
      'Amend thay vì cancel + replace',
    ),
    (
      Icons.query_stats_rounded,
      'Full transparency',
      'Chi tiết mọi fill + quality score',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ExecutionQualityPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Execution Quality Improvements',
            style: AppTextStyles.caption.copyWith(
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.tradeToolCardGap),
          for (final item in _items) ...[
            _BenefitItem(icon: item.$1, title: item.$2, description: item.$3),
            if (item != _items.last)
              const SizedBox(height: AppSpacing.tradeToolCardGap),
          ],
        ],
      ),
    );
  }
}

class ExecutionQualityProgressCard extends StatelessWidget {
  const ExecutionQualityProgressCard({required this.items, super.key});

  final List<TradeRiskStatusItem> items;

  @override
  Widget build(BuildContext context) {
    return ExecutionQualityPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Phase 2 Progress',
            style: AppTextStyles.caption.copyWith(
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.tradeToolCardGap),
          for (final item in items) ...[
            Row(
              children: [
                Expanded(
                  child: Text(
                    item.label,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                    ),
                  ),
                ),
                ExecutionQualityStatusPill(complete: item.complete),
              ],
            ),
            if (item != items.last)
              const SizedBox(height: AppSpacing.tradeToolInlineGap),
          ],
        ],
      ),
    );
  }
}

class ExecutionQualityParityCard extends StatelessWidget {
  const ExecutionQualityParityCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ExecutionQualityPanel(
      borderColor: AppColors.buy.withValues(alpha: .30),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.check_circle_rounded,
            color: AppColors.buy,
            size: 18,
          ),
          const SizedBox(width: AppSpacing.tradeToolIconGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tier-1 Exchange Parity Achieved',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.buy,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  'Phase 1 + Phase 2 = 100% feature parity với Binance/Coinbase Pro cho execution quality. Order amendment + slippage protection là standard features trên các sàn hàng đầu.',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BenefitItem extends StatelessWidget {
  const _BenefitItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: executionQualityPrimary, size: 18),
        const SizedBox(width: AppSpacing.tradeToolIconGap),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.medium,
                ),
              ),
              const SizedBox(height: AppSpacing.tradeToolMicroGap),
              Text(
                description,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
