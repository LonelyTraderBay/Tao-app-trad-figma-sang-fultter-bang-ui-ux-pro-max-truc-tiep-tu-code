import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

const liveMarketPanel = AppColors.surface;
const liveMarketPanel2 = AppColors.surface2;
const liveMarketSurface3 = AppColors.surfaceNavyDeep;
const liveMarketBorder = AppColors.borderSolid;
const liveMarketPrimary = AppColors.primary;
const liveMarketGreen = AppColors.buy;
const liveMarketRed = AppColors.sell;
const liveMarketPurple = AppColors.accent;
const liveMarketAmber = AppColors.caution;

class LiveMarketLiveDot extends StatelessWidget {
  const LiveMarketLiveDot({super.key});

  @override
  Widget build(BuildContext context) {
    return const VitStatusPill(
      label: 'LIVE',
      status: VitStatusPillStatus.success,
      size: VitStatusPillSize.sm,
      pulse: true,
      outline: true,
    );
  }
}

class LiveMarketCardHeader extends StatelessWidget {
  const LiveMarketCardHeader({
    required this.icon,
    required this.color,
    required this.title,
    this.trailing,
    this.badge,
    this.badgeColor,
    super.key,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String? trailing;
  final String? badge;
  final Color? badgeColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: AppSpacing.liveMarketHeaderIcon),
        const SizedBox(width: AppSpacing.rowGap),
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.body.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
        if (trailing != null)
          Text(
            trailing!,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          )
        else if (badge != null)
          LiveMarketChip(label: badge!, color: badgeColor ?? liveMarketGreen),
      ],
    );
  }
}

class LiveMarketCard extends StatelessWidget {
  const LiveMarketCard({
    required this.child,
    super.key,
    this.padding = AppSpacing.cardPadding,
    this.height,
    this.constraints,
    this.variant = VitCardVariant.standard,
    this.radius = VitCardRadius.standard,
    this.borderColor,
    this.background,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double? height;
  final BoxConstraints? constraints;
  final VitCardVariant variant;
  final VitCardRadius radius;
  final Color? borderColor;
  final Widget? background;

  @override
  Widget build(BuildContext context) {
    // card-tile: allow-start — fixed surface, not horizontal strip tile
    return VitCard(
      variant: variant,
      radius: radius,
      padding: padding,
      height: height,
      constraints: constraints,
      borderColor: borderColor ?? liveMarketBorder.withValues(alpha: .72),
      background: background,
      clip: background != null,
      child: child,
    );
  }
}

class LiveMarketMetricBox extends StatelessWidget {
  const LiveMarketMetricBox({
    required this.label,
    required this.value,
    this.color = AppColors.text1,
    this.bg = liveMarketPanel2,
    super.key,
  });

  final String label;
  final String value;
  final Color color;
  final Color bg;

  @override
  Widget build(BuildContext context) {
    // card-tile: allow-start — fixed surface, not horizontal strip tile
    return VitCard(
      variant: bg == liveMarketPanel2
          ? VitCardVariant.inner
          : VitCardVariant.ghost,
      constraints: const BoxConstraints(
        minHeight: AppSpacing.liveMarketMetricMinHeight,
      ),
      padding: AppSpacing.liveMarketMetricPadding,
      background: bg == liveMarketPanel2 ? null : ColoredBox(color: bg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LiveMarketMutedLabel(label, align: TextAlign.center),
          const SizedBox(height: AppSpacing.rowGap),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class LiveMarketChip extends StatelessWidget {
  const LiveMarketChip({required this.label, required this.color, super.key});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitAccentPill(label: label, accentColor: color);
  }
}

class LiveMarketMutedLabel extends StatelessWidget {
  const LiveMarketMutedLabel(this.text, {this.align, super.key});

  final String text;
  final TextAlign? align;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align,
      style: AppTextStyles.micro.copyWith(color: AppColors.text3),
    );
  }
}

class LiveMarketInfoStrip extends StatelessWidget {
  const LiveMarketInfoStrip({
    this.bg = liveMarketSurface3,
    this.color = liveMarketPrimary,
    super.key,
  });

  final Color bg;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return LiveMarketCard(
      variant: VitCardVariant.ghost,
      borderColor: AppColors.transparent,
      padding: AppSpacing.liveMarketInfoPadding,
      background: ColoredBox(color: bg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            color: color,
            size: AppSpacing.liveMarketInlineIcon,
          ),
          const SizedBox(width: AppSpacing.rowGap),
          Expanded(
            child: Text(
              'OI tang + gia tang = bullish strong. OI tang + gia giam = bearish momentum. OI giam = positions dong.',
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ),
        ],
      ),
    );
  }
}

class LiveMarketRatioBar extends StatelessWidget {
  const LiveMarketRatioBar({required this.longPct, super.key});

  final double longPct;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: AppRadii.pillRadius,
      child: SizedBox(
        height: AppSpacing.liveMarketRatioBarHeight,
        child: Row(
          children: [
            Expanded(
              flex: (longPct * 10).round(),
              child: const ColoredBox(color: liveMarketGreen),
            ),
            Expanded(
              flex: ((100 - longPct) * 10).round(),
              child: const ColoredBox(color: liveMarketRed),
            ),
          ],
        ),
      ),
    );
  }
}

String formatLiveMarketMillions(double value) {
  return '\$${(value / 1000000).toStringAsFixed(2)}M';
}

String formatLiveMarketCompactUsd(double value) {
  if (value >= 1000000000) {
    return '\$${(value / 1000000000).toStringAsFixed(2)}B';
  }
  if (value >= 1000000) return '\$${(value / 1000000).toStringAsFixed(1)}M';
  if (value >= 1000) return '\$${(value / 1000).toStringAsFixed(0)}K';
  return '\$${value.toStringAsFixed(0)}';
}

String formatLiveMarketMoney(double value) {
  final fixed = value.toStringAsFixed(2);
  final parts = fixed.split('.');
  final buffer = StringBuffer();
  for (var i = 0; i < parts.first.length; i++) {
    final remaining = parts.first.length - i;
    buffer.write(parts.first[i]);
    if (remaining > 1 && remaining % 3 == 1) buffer.write(',');
  }
  return '${buffer.toString()}.${parts.last}';
}

String formatLiveMarketInt(int value) {
  final raw = value.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < raw.length; i++) {
    final remaining = raw.length - i;
    buffer.write(raw[i]);
    if (remaining > 1 && remaining % 3 == 1) buffer.write(',');
  }
  return buffer.toString();
}
