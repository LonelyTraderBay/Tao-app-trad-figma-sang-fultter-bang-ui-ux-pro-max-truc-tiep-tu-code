import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/earn/domain/entities/earn_entities.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

final class StakingCustodyKeys {
  const StakingCustodyKeys._();

  static const hero = Key('sc375_custody_hero');
  static const custodian = Key('sc375_custodian_card');
  static const segregation = Key('sc375_segregation_card');
  static const hotCold = Key('sc375_hot_cold_card');
  static const reconciliation = Key('sc375_reconciliation_card');
  static const transparency = Key('sc375_transparency_card');
  static const auditTrailButton = Key('sc375_audit_trail_button');
  static const feedback = Key('sc375_feedback');
  static const footer = Key('sc375_footer');
}

class StakingCustodyMetricTile extends StatelessWidget {
  const StakingCustodyMetricTile({
    super.key,
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.baseMedium.copyWith(height: 1.25),
          ),
        ],
      ),
    );
  }
}

class StakingCustodyLegendRow extends StatelessWidget {
  const StakingCustodyLegendRow({super.key, required this.item});

  final StakingCustodyLegendDraft item;

  @override
  Widget build(BuildContext context) {
    final color = stakingCustodyToneColor(item.tone);
    return VitCard(
      variant: VitCardVariant.inner,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            stakingCustodyIconFor(item.iconKey),
            color: color,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.label,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  item.description,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    height: 1.4,
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

class StakingCustodyStorageTile extends StatelessWidget {
  const StakingCustodyStorageTile({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });

  final IconData icon;
  final String title;
  final String description;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: color.withValues(alpha: 0.18),
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: AppSpacing.iconSm),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: color,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            description,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text2,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class StakingCustodyReconciliationLogCard extends StatelessWidget {
  const StakingCustodyReconciliationLogCard({super.key, required this.log});

  final StakingReconciliationLogDraft log;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  log.dateLabel,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
              const StakingCustodyMatchStatus(),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              Expanded(
                child: StakingCustodyReconciliationMetric(
                  label: 'On-chain',
                  value: stakingCustodyFormatUsd(log.onChainUsd),
                  color: AppColors.text1,
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: StakingCustodyReconciliationMetric(
                  label: 'Custodian',
                  value: stakingCustodyFormatUsd(log.custodyUsd),
                  color: AppColors.text1,
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: StakingCustodyReconciliationMetric(
                  label: 'Discrepancy',
                  value: stakingCustodyFormatUsd(log.discrepancyUsd),
                  color: AppColors.buy,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class StakingCustodyReconciliationMetric extends StatelessWidget {
  const StakingCustodyReconciliationMetric({
    super.key,
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class StakingCustodyMatchStatus extends StatelessWidget {
  const StakingCustodyMatchStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.buy,
            shape: BoxShape.circle,
          ),
          child: SizedBox(width: 6, height: 6),
        ),
        const SizedBox(width: AppSpacing.x1),
        Text(
          'Matched',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.buy,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}

class StakingCustodyAddressRow extends StatelessWidget {
  const StakingCustodyAddressRow({super.key, required this.address});

  final StakingTransparencyAddressDraft address;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  address.label,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  address.address,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x2),
          Text(
            'View ->',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.primarySoft,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class StakingCustodyActionButton extends StatelessWidget {
  const StakingCustodyActionButton({
    super.key,
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface3,
      borderRadius: AppRadii.lgRadius,
      child: InkWell(
        borderRadius: AppRadii.lgRadius,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x4,
            vertical: AppSpacing.x3,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class StakingCustodyLargeIconBox extends StatelessWidget {
  const StakingCustodyLargeIconBox({
    super.key,
    required this.icon,
    required this.color,
  });

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        border: Border.all(color: color.withValues(alpha: 0.32), width: 1.5),
        borderRadius: AppRadii.xlRadius,
      ),
      child: SizedBox(
        width: 64,
        height: 64,
        child: Icon(icon, color: color, size: 34),
      ),
    );
  }
}

class StakingCustodySmallPill extends StatelessWidget {
  const StakingCustodySmallPill({
    super.key,
    required this.label,
    required this.color,
  });

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: AppRadii.mdRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x2,
          vertical: AppSpacing.x1,
        ),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}

class StakingCustodyFooterNote extends StatelessWidget {
  const StakingCustodyFooterNote({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingCustodyKeys.footer,
      variant: VitCardVariant.inner,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: AppTextStyles.micro.copyWith(
          color: AppColors.text3,
          height: 1.5,
        ),
      ),
    );
  }
}

class StakingCustodyPieChart extends StatelessWidget {
  const StakingCustodyPieChart({
    super.key,
    required this.allocations,
    required this.size,
    required this.donut,
  });

  final List<StakingCustodyAllocationDraft> allocations;
  final double size;
  final bool donut;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: StakingCustodyPieChartPainter(
          allocations: allocations,
          donut: donut,
        ),
        child: Center(
          child: donut
              ? DecoratedBox(
                  decoration: const BoxDecoration(
                    color: AppColors.cardBg,
                    shape: BoxShape.circle,
                  ),
                  child: SizedBox(width: size * 0.48, height: size * 0.48),
                )
              : null,
        ),
      ),
    );
  }
}

class StakingCustodyPieChartPainter extends CustomPainter {
  const StakingCustodyPieChartPainter({
    required this.allocations,
    required this.donut,
  });

  final List<StakingCustodyAllocationDraft> allocations;
  final bool donut;

  @override
  void paint(Canvas canvas, Size size) {
    final total = allocations.fold<int>(0, (sum, item) => sum + item.value);
    final rect = Offset.zero & size;
    var start = -math.pi / 2;
    final paint = Paint()..style = PaintingStyle.fill;

    for (final allocation in allocations) {
      final sweep = (allocation.value / total) * math.pi * 2;
      paint.color = stakingCustodyToneColor(allocation.tone);
      canvas.drawArc(rect.deflate(8), start, sweep, true, paint);
      start += sweep;
    }

    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = AppColors.borderSolid;
    canvas.drawCircle(
      size.center(Offset.zero),
      size.shortestSide / 2 - 8,
      stroke,
    );

    if (donut) {
      final holePaint = Paint()
        ..style = PaintingStyle.fill
        ..color = AppColors.cardBg;
      canvas.drawCircle(
        size.center(Offset.zero),
        size.shortestSide * 0.24,
        holePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant StakingCustodyPieChartPainter oldDelegate) {
    return oldDelegate.allocations != allocations || oldDelegate.donut != donut;
  }
}

IconData stakingCustodyIconFor(String iconKey) {
  return switch (iconKey) {
    'building' => Icons.account_balance_outlined,
    'lock' => Icons.lock_outline_rounded,
    'shield' => Icons.shield_outlined,
    _ => Icons.circle_outlined,
  };
}

Color stakingCustodyToneColor(EarnRiskLevel tone) {
  return switch (tone) {
    EarnRiskLevel.low => AppColors.buy,
    EarnRiskLevel.medium => AppColors.warn,
    EarnRiskLevel.high => AppColors.accent,
  };
}

String stakingCustodyFormatUsd(double amount) {
  if (amount >= 1000000000) {
    return '\$${(amount / 1000000000).toStringAsFixed(2)}B';
  }
  if (amount >= 1000000) {
    return '\$${(amount / 1000000).toStringAsFixed(2)}M';
  }
  if (amount == 0) return '\$0.00';
  return '\$${amount.toStringAsFixed(2)}';
}
