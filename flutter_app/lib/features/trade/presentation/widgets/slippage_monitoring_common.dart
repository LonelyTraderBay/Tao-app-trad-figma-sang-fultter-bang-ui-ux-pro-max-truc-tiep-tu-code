part of '../pages/slippage_monitoring_page.dart';

class _SidePill extends StatelessWidget {
  const _SidePill({required this.side});

  final String side;

  @override
  Widget build(BuildContext context) {
    final buy = side == 'buy';
    return VitStatusPill(
      label: side.toUpperCase(),
      status: buy ? VitStatusPillStatus.success : VitStatusPillStatus.error,
      size: VitStatusPillSize.sm,
    );
  }
}

class _SeverityPill extends StatelessWidget {
  const _SeverityPill({required this.style});

  final _SeverityStyle style;

  @override
  Widget build(BuildContext context) {
    return VitStatusPill(
      label: style.label,
      icon: style.icon,
      status: switch (style.label) {
        'Critical' => VitStatusPillStatus.error,
        'Warning' => VitStatusPillStatus.warning,
        _ => VitStatusPillStatus.success,
      },
      size: VitStatusPillSize.sm,
    );
  }
}

class _SwitchVisual extends StatelessWidget {
  const _SwitchVisual({required this.enabled});

  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return VitTogglePill(
      enabled: enabled,
      activeColor: _slipPrimary,
      inactiveColor: _slipPanel2,
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitSectionHeader(
      title: text,
      bottomGap: AppSpacing.pageRhythmStandardInnerGap,
      variant: VitSectionHeaderVariant.accentBar,
      accentColor: _slipPrimary,
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child, required this.padding});

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      padding: padding,
      borderColor: _slipBorder.withValues(alpha: .72),
      child: child,
    );
  }
}

class _NoticePanel extends StatelessWidget {
  const _NoticePanel({required this.text, required this.onClose});

  final String text;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: AppSpacing.contentPad,
      right: AppSpacing.contentPad,
      top: MediaQuery.paddingOf(context).top + AppSpacing.tradeToolBodyIcon,
      child: Material(
        color: AppColors.transparent,
        child: VitCard(
          variant: VitCardVariant.inner,
          density: VitDensity.compact,
          padding: AppSpacing.cardPaddingCompact,
          borderColor: _slipBorder,
          child: Row(
            children: [
              const Icon(
                Icons.check_circle_outline,
                color: _slipGreen,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Text(
                  text,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text1),
                ),
              ),
              VitIconButton(
                icon: Icons.close_rounded,
                tooltip: 'Dismiss slippage notice',
                onPressed: onClose,
                size: VitIconButtonSize.sm,
                variant: VitIconButtonVariant.transparent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SeverityStyle {
  const _SeverityStyle({
    required this.color,
    required this.label,
    required this.icon,
  });

  final Color color;
  final String label;
  final IconData icon;
}

_SeverityStyle _severityStyle(String severity) {
  return switch (severity) {
    'critical' => const _SeverityStyle(
      color: _slipRed,
      label: 'Critical',
      icon: Icons.cancel_outlined,
    ),
    'warning' => const _SeverityStyle(
      color: _slipAmber,
      label: 'Warning',
      icon: Icons.warning_amber_rounded,
    ),
    _ => const _SeverityStyle(
      color: _slipGreen,
      label: 'Normal',
      icon: Icons.check_circle_outline,
    ),
  };
}

String _formatPrice(double value) {
  if (value < 1000 && value != value.roundToDouble()) {
    return '\$${value.toStringAsFixed(1)}';
  }
  return '\$${_formatInt(value)}';
}

String _formatInt(num value) {
  final text = value.round().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < text.length; i++) {
    final indexFromEnd = text.length - i;
    buffer.write(text[i]);
    if (indexFromEnd > 1 && indexFromEnd % 3 == 1) {
      buffer.write(',');
    }
  }
  return buffer.toString();
}
