part of 'dca_rebalance_config_page.dart';

class _PreviewRow extends StatelessWidget {
  const _PreviewRow({required this.preview});

  final DcaRebalanceTradePreview preview;

  @override
  Widget build(BuildContext context) {
    final color = switch (preview.action) {
      DcaRebalanceTradeAction.buy => AppColors.buy,
      DcaRebalanceTradeAction.sell => AppColors.sell,
      DcaRebalanceTradeAction.hold => AppColors.text3,
    };
    final label = switch (preview.action) {
      DcaRebalanceTradeAction.buy => 'Mua',
      DcaRebalanceTradeAction.sell => 'Bán',
      DcaRebalanceTradeAction.hold => 'Giữ',
    };
    return DecoratedBox(
      decoration: const ShapeDecoration(
        color: AppColors.surface2,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.inputRadius),
      ),
      child: Padding(
        padding: AppSpacing.dcaPaddingX4,
        child: Row(
          children: [
            Text(
              preview.symbol,
              style: AppTextStyles.base.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
            const SizedBox(width: AppSpacing.x3),
            Text(
              '${preview.currentPercent.toStringAsFixed(0)}% → ${preview.targetPercent.toStringAsFixed(0)}%',
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
            const SizedBox(width: AppSpacing.x4),
            Text(
              '$label \$${preview.tradeAmountUsd.toStringAsFixed(0)}',
              style: AppTextStyles.caption.copyWith(
                color: color,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.icon,
    required this.title,
    this.trailing,
  });

  final IconData icon;
  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _AccentIcon(icon: icon, color: AppColors.accent),
        const SizedBox(width: AppSpacing.x4),
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.baseMedium.copyWith(color: AppColors.text1),
          ),
        ),
        ?trailing,
      ],
    );
  }
}

class _AccentIcon extends StatelessWidget {
  const _AccentIcon({
    required this.icon,
    this.color = AppModuleAccents.trade,
    this.muted = false,
  });

  final IconData icon;
  final Color color;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSpacing.iconLg,
      height: AppSpacing.iconLg,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: muted ? AppColors.surface2 : color.withValues(alpha: .15),
          shape: const RoundedRectangleBorder(
            borderRadius: AppRadii.inputRadius,
          ),
        ),
        child: Icon(icon, color: color, size: AppSpacing.dcaRebalanceIcon),
      ),
    );
  }
}

class _PillButton extends StatelessWidget {
  const _PillButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.enabled = true,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      onTap: enabled ? onTap : null,
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.standard,
      padding: EdgeInsets.zero,
      borderColor: AppColors.transparent,
      clip: true,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 150),
        opacity: enabled ? 1 : .45,
        child: DecoratedBox(
          decoration: const ShapeDecoration(
            color: AppColors.accent10,
            shape: RoundedRectangleBorder(borderRadius: AppRadii.inputRadius),
          ),
          child: Padding(
            padding: AppSpacing.dcaPrimaryChipPadding,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  color: AppColors.accent,
                  size: AppSpacing.dcaRebalanceIconSm,
                ),
                const SizedBox(width: AppSpacing.x2),
                Text(
                  label,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.accent,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LegendRow extends StatelessWidget {
  const _LegendRow({required this.target});

  final DcaRebalanceTarget target;

  @override
  Widget build(BuildContext context) {
    final accent = _accentColor(target.accent);
    return Row(
      children: [
        SizedBox(
          width: AppSpacing.x4,
          height: AppSpacing.x4,
          child: DecoratedBox(
            decoration: ShapeDecoration(
              color: accent,
              shape: const RoundedRectangleBorder(
                borderRadius: AppRadii.xsRadius,
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: Text(
            target.symbol,
            style: AppTextStyles.baseMedium.copyWith(color: AppColors.text1),
          ),
        ),
        Text(
          '${target.targetPercent.toStringAsFixed(0)}%',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}

class _CoinBadge extends StatelessWidget {
  const _CoinBadge({required this.symbol, required this.accent});

  final String symbol;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSpacing.dcaRebalanceTileIconBox,
      height: AppSpacing.dcaRebalanceTileIconBox,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: accent.withValues(alpha: .12),
          shape: CircleBorder(
            side: BorderSide(color: accent.withValues(alpha: .35)),
          ),
        ),
        child: Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Padding(
              padding: AppSpacing.dcaPaddingX2,
              child: Text(
                symbol.length > 3 ? symbol.substring(0, 3) : symbol,
                style: AppTextStyles.caption.copyWith(
                  color: accent,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _IconBadgeButton extends StatelessWidget {
  const _IconBadgeButton({
    required this.icon,
    required this.onTap,
    required this.color,
    this.neutral = false,
  });

  final IconData icon;
  final VoidCallback onTap;
  final Color color;
  final bool neutral;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      onTap: onTap,
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.standard,
      padding: EdgeInsets.zero,
      width: AppSpacing.iconLg,
      height: AppSpacing.iconLg,
      borderColor: AppColors.transparent,
      clip: true,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: neutral ? AppColors.surface : color.withValues(alpha: .12),
          shape: const CircleBorder(),
        ),
        child: Icon(icon, color: color, size: AppSpacing.dcaRebalanceIcon),
      ),
    );
  }
}

class _TogglePill extends StatelessWidget {
  const _TogglePill({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      checked: value,
      child: VitCard(
        onTap: () => onChanged(!value),
        variant: VitCardVariant.ghost,
        radius: VitCardRadius.standard,
        padding: EdgeInsets.zero,
        width: AppSpacing.dcaRebalanceToggleWidth,
        height: _dcaRebalanceToggleHeight,
        borderColor: AppColors.transparent,
        clip: true,
        child: DecoratedBox(
          decoration: ShapeDecoration(
            color: value ? AppColors.buy : AppColors.borderSolid,
            shape: const RoundedRectangleBorder(
              borderRadius: AppRadii.xlRadius,
            ),
          ),
          child: Padding(
            padding: AppSpacing.dcaPaddingX1,
            child: AnimatedAlign(
              duration: const Duration(milliseconds: 160),
              alignment: value ? Alignment.centerRight : Alignment.centerLeft,
              child: const SizedBox(
                width: AppSpacing.dcaRebalanceToggleThumb,
                height: _dcaRebalanceToggleThumb,
                child: DecoratedBox(
                  decoration: ShapeDecoration(
                    color: AppColors.text1,
                    shape: CircleBorder(),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TokenSlider extends StatelessWidget {
  const _TokenSlider({
    super.key,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.accent,
    required this.onChanged,
  });

  final double value;
  final double min;
  final double max;
  final int divisions;
  final Color accent;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight: AppSpacing.x1,
        activeTrackColor: accent,
        inactiveTrackColor: AppColors.surface3,
        thumbColor: AppColors.text1,
        overlayColor: accent.withValues(alpha: .12),
        thumbShape: const RoundSliderThumbShape(
          enabledThumbRadius: AppSpacing.x3,
        ),
        overlayShape: const RoundSliderOverlayShape(
          overlayRadius: AppSpacing.x5,
        ),
      ),
      child: Slider(
        value: value.clamp(min, max).toDouble(),
        min: min,
        max: max,
        divisions: divisions,
        onChanged: onChanged,
      ),
    );
  }
}

class _FinePrint extends StatelessWidget {
  const _FinePrint(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.micro.copyWith(color: AppColors.text3),
    );
  }
}

class _DonutPainter extends CustomPainter {
  const _DonutPainter({required this.targets});

  final List<DcaRebalanceTarget> targets;

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = AppSpacing.x5;
    final radius = (math.min(size.width, size.height) - stroke) / 2;
    final center = Offset(size.width / 2, size.height / 2);
    final basePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..color = AppColors.surface3;
    canvas.drawCircle(center, radius, basePaint);

    var start = -math.pi / 2;
    final total = targets.fold<double>(
      0,
      (sum, target) => sum + target.targetPercent,
    );
    if (total <= 0) return;
    for (final target in targets) {
      final sweep = math.pi * 2 * (target.targetPercent / total);
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.round
        ..color = _accentColor(target.accent);
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        start,
        math.max(0, sweep - .05),
        false,
        paint,
      );
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutPainter oldDelegate) {
    return oldDelegate.targets != targets;
  }
}

Color _accentColor(DcaRebalanceAccent accent) {
  return switch (accent) {
    DcaRebalanceAccent.primary => AppColors.primary,
    DcaRebalanceAccent.accent => AppColors.accent,
    DcaRebalanceAccent.success => AppColors.buy,
    DcaRebalanceAccent.warning => AppColors.warn,
  };
}

IconData _strategyIcon(DcaRebalanceOptionIcon icon) {
  return switch (icon) {
    DcaRebalanceOptionIcon.zap => Icons.flash_on_rounded,
    DcaRebalanceOptionIcon.clock => Icons.schedule_rounded,
    DcaRebalanceOptionIcon.combine => Icons.account_tree_rounded,
  };
}

String _driftLabel(double value) {
  if (value <= 3) return 'Rất chặt';
  if (value <= 8) return 'Chặt';
  if (value <= 15) return 'Trung bình';
  if (value <= 30) return 'Lỏng';
  return 'Rất lỏng';
}
