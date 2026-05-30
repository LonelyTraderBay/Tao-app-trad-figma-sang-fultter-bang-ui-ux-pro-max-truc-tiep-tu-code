import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/copy_trading_card_demo_primitives.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

final class CopyTradingCardDemoUiKeys {
  const CopyTradingCardDemoUiKeys._();

  static Key cardKey(String id) => Key('sc401_card_$id');
}

class CopyTradingVariantSection extends StatelessWidget {
  const CopyTradingVariantSection({
    super.key,
    required this.variant,
    required this.metrics,
  });

  final TradeCopyCardVariantDraft variant;
  final TradeCopyCardMetrics metrics;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                variant.title,
                style: AppTextStyles.baseMedium.copyWith(
                  fontSize: 18,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
            if (variant.badge != null) ...[
              const SizedBox(width: AppSpacing.x3),
              CopyTradingBadge(label: variant.badge!),
            ],
          ],
        ),
        const SizedBox(height: AppSpacing.x4),
        _CopyCard(variantId: variant.id, metrics: metrics),
        const SizedBox(height: AppSpacing.x3),
        VitCard(
          variant: VitCardVariant.standard,
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                variant.notesTitle,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.x2),
              for (final item in variant.notes)
                CopyTradingIconLine(
                  icon: Icons.check_circle_rounded,
                  text: item,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CopyCard extends StatelessWidget {
  const _CopyCard({required this.variantId, required this.metrics});

  final String variantId;
  final TradeCopyCardMetrics metrics;

  @override
  Widget build(BuildContext context) {
    return switch (variantId) {
      'hero' => _HeroCopyCard(metrics: metrics),
      'tabular' => _TabularCopyCard(metrics: metrics),
      _ => _CompactCopyCard(metrics: metrics),
    };
  }
}

class _HeroCopyCard extends StatelessWidget {
  const _HeroCopyCard({required this.metrics});

  final TradeCopyCardMetrics metrics;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: CopyTradingCardDemoUiKeys.cardKey('hero'),
      variant: VitCardVariant.standard,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x5),
      borderColor: AppColors.borderSolid,
      child: Column(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border.all(color: AppColors.cardBorder),
              borderRadius: AppRadii.cardLargeRadius,
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.x5),
              child: Column(
                children: [
                  Text(
                    'ASSET UNDER MANAGEMENT',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text2,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x3),
                  Text(
                    formatCopyTradingUsd(metrics.aumUsd),
                    textAlign: TextAlign.center,
                    style: AppTextStyles.heroNumber.copyWith(fontSize: 33),
                  ),
                  const SizedBox(height: AppSpacing.x3),
                  CopyTradingTrendPill(value: metrics.aumTrendPercent),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              Expanded(
                child: _SecondaryMetric(
                  icon: Icons.people_alt_outlined,
                  label: 'TRADERS',
                  value: '${metrics.traders}',
                ),
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: _SecondaryMetric(
                  icon: Icons.group_add_outlined,
                  label: 'COPIERS',
                  value: formatCopyTradingCompact(metrics.copiers),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Text(
            'Updated ${metrics.lastUpdated}',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _TabularCopyCard extends StatelessWidget {
  const _TabularCopyCard({required this.metrics});

  final TradeCopyCardMetrics metrics;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: CopyTradingCardDemoUiKeys.cardKey('tabular'),
      variant: VitCardVariant.standard,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        children: [
          _CopyCardHeader(),
          const SizedBox(height: AppSpacing.x4),
          const Divider(height: 1, color: AppColors.divider),
          _TableMetricRow(
            label: 'Total AUM',
            value: formatCopyTradingUsd(metrics.aumUsd),
            trailing: CopyTradingTrendSmall(value: metrics.aumTrendPercent),
          ),
          _TableMetricRow(
            label: 'Active Traders',
            value: '${metrics.traders}',
            icon: Icons.people_alt_outlined,
          ),
          _TableMetricRow(
            label: 'Total Copiers',
            value: formatCopyTradingCompact(metrics.copiers),
            icon: Icons.group_add_outlined,
            showDivider: false,
          ),
          const Divider(height: 1, color: AppColors.divider),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Last updated: ${metrics.lastUpdated}',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
              CopyTradingSmallButton(label: 'View Details', onTap: () {}),
            ],
          ),
        ],
      ),
    );
  }
}

class _CompactCopyCard extends StatelessWidget {
  const _CompactCopyCard({required this.metrics});

  final TradeCopyCardMetrics metrics;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: CopyTradingCardDemoUiKeys.cardKey('compact'),
      variant: VitCardVariant.standard,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        children: [
          _CopyCardHeader(),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              Expanded(
                child: _CompactMetric(
                  label: 'TRADERS',
                  value: '${metrics.traders}',
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _CompactMetric(
                  label: 'COPIERS',
                  value: formatCopyTradingCompact(metrics.copiers),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _CompactMetric(
                  label: 'AUM',
                  value: formatCopyTradingUsd(metrics.aumUsd),
                  emphasized: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CopyCardHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: AppRadii.inputRadius,
          ),
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.x4),
            child: Icon(
              Icons.dashboard_customize_outlined,
              color: AppColors.navCenterIcon,
              size: 22,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.x4),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Copy Trading',
                style: AppTextStyles.baseMedium.copyWith(
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.x1),
              Text(
                'Sao chép trader chuyên nghiệp',
                style: AppTextStyles.caption.copyWith(color: AppColors.text2),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SecondaryMetric extends StatelessWidget {
  const _SecondaryMetric({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 15),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  label,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text2,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            value,
            style: AppTextStyles.sectionTitle.copyWith(
              fontSize: 27,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class _TableMetricRow extends StatelessWidget {
  const _TableMetricRow({
    required this.label,
    required this.value,
    this.icon,
    this.trailing,
    this.showDivider = true,
  });

  final String label;
  final String value;
  final IconData? icon;
  final Widget? trailing;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: showDivider
            ? const Border(bottom: BorderSide(color: AppColors.divider))
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.x4),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: AppColors.text2, size: 16),
              const SizedBox(width: AppSpacing.x2),
            ],
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  fontWeight: AppTextStyles.medium,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  value,
                  style: AppTextStyles.baseMedium.copyWith(
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
                if (trailing != null) ...[
                  const SizedBox(height: AppSpacing.x1),
                  trailing!,
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CompactMetric extends StatelessWidget {
  const _CompactMetric({
    required this.label,
    required this.value,
    this.emphasized = false,
  });

  final String label;
  final String value;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.bg,
        border: emphasized ? Border.all(color: AppColors.primary40) : null,
        borderRadius: AppRadii.inputRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x3),
        child: Column(
          children: [
            Text(
              label,
              style: AppTextStyles.micro.copyWith(
                color: emphasized ? AppColors.primary : AppColors.text2,
                fontWeight: AppTextStyles.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.x2),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                value,
                style: AppTextStyles.baseMedium.copyWith(
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
