part of '../pages/advanced_tools_demo_page.dart';

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.complete});

  final bool complete;

  @override
  Widget build(BuildContext context) {
    return VitStatusPill(
      label: complete ? 'Complete' : 'Pending',
      status: complete
          ? VitStatusPillStatus.success
          : VitStatusPillStatus.warning,
      icon: complete ? Icons.check_rounded : Icons.schedule_rounded,
      size: VitStatusPillSize.sm,
    );
  }
}

class _GradientButton extends StatelessWidget {
  const _GradientButton({
    super.key,
    required this.label,
    required this.icon,
    required this.colors,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final List<Color> colors;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCtaButton(
      onPressed: onTap,
      variant: _ctaVariantFor(colors),
      height: _toolsButtonHeight,
      leading: Icon(icon),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.control.copyWith(
          color: AppColors.onAccent,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

class _IconTile extends StatelessWidget {
  const _IconTile({
    required this.icon,
    required this.color,
    required this.size,
  });

  final IconData icon;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    // card-tile: allow-start — fixed surface, not horizontal strip tile
    return VitCard(
      width: size,
      height: size,
      alignment: Alignment.center,
      variant: VitCardVariant.inner,
      radius: VitCardRadius.standard,
      density: VitDensity.compact,
      borderColor: color.withValues(alpha: .28),
      child: Icon(icon, color: color, size: size * .5),
    );
  }
}

class _Panel extends StatelessWidget {
  const _Panel({
    super.key,
    required this.child,
    this.borderColor = AppColors.cardBorder,
    this.onTap,
  });

  final Widget child;
  final Color borderColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      padding: AppSpacing.cardPaddingCompact,
      variant: VitCardVariant.inner,
      borderColor: borderColor,
      onTap: onTap,
      child: child,
    );
  }
}

class _SheetFrame extends StatelessWidget {
  const _SheetFrame({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return VitSheetPanel(
      title: title,
      child: SingleChildScrollView(child: child),
    );
  }
}

class _SheetRow extends StatelessWidget {
  const _SheetRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.tradeToolSheetRowPadding,
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(color: AppColors.text3),
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SuccessToast extends StatelessWidget {
  const _SuccessToast({required this.message, required this.onClose});

  final String message;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      child: VitCard(
        padding: AppSpacing.tradeToolToastPadding,
        variant: VitCardVariant.inner,
        borderColor: AppColors.buy.withValues(alpha: .38),
        child: Row(
          children: [
            const Icon(
              Icons.check_circle_rounded,
              color: AppColors.buy,
              size: AppSpacing.tradeToolBodyIcon,
            ),
            const SizedBox(width: _toolsSpace),
            Expanded(
              child: Text(
                message,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.onAccent,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
            VitIconButton(
              icon: Icons.close_rounded,
              tooltip: 'Close success message',
              onPressed: onClose,
              variant: VitIconButtonVariant.transparent,
              size: VitIconButtonSize.sm,
            ),
          ],
        ),
      ),
    );
  }
}

VitCtaButtonVariant _ctaVariantFor(List<Color> colors) {
  final first = colors.first;
  if (first == AppColors.buy) return VitCtaButtonVariant.success;
  if (first == AppColors.caution) return VitCtaButtonVariant.warning;
  if (first == AppColors.sell) return VitCtaButtonVariant.danger;
  return VitCtaButtonVariant.primary;
}

String _formatMoney(double value) {
  if (value >= 1000) {
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
  return value.toStringAsFixed(2);
}
