part of '../pages/slippage_monitoring_page.dart';

class _SidePill extends StatelessWidget {
  const _SidePill({required this.side});

  final String side;

  @override
  Widget build(BuildContext context) {
    final buy = side == 'buy';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
        color: (buy ? _slipGreen : _slipRed).withValues(alpha: .14),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        side.toUpperCase(),
        style: AppTextStyles.micro.copyWith(
          color: buy ? _slipGreen : _slipRed,
          fontSize: 9,
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
    );
  }
}

class _SeverityPill extends StatelessWidget {
  const _SeverityPill({required this.style});

  final _SeverityStyle style;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
      decoration: BoxDecoration(
        color: style.color.withValues(alpha: .13),
        borderRadius: AppRadii.mdRadius,
      ),
      child: Text(
        style.label,
        style: AppTextStyles.micro.copyWith(
          color: style.color,
          fontSize: 10,
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
    );
  }
}

class _SwitchVisual extends StatelessWidget {
  const _SwitchVisual({required this.enabled});

  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 24,
      decoration: BoxDecoration(
        color: enabled ? _slipPrimary : _slipPanel2,
        borderRadius: BorderRadius.circular(999),
      ),
      alignment: enabled ? Alignment.centerRight : Alignment.centerLeft,
      padding: const EdgeInsets.all(4),
      child: const DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.onAccent,
          shape: BoxShape.circle,
        ),
        child: SizedBox(width: 16, height: 16),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 16,
          decoration: BoxDecoration(
            color: _slipPrimary,
            borderRadius: BorderRadius.circular(999),
          ),
        ),
        const SizedBox(width: 7),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontSize: 11,
              fontWeight: AppTextStyles.bold,
              height: 1,
            ),
          ),
        ),
      ],
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
      left: 20,
      right: 20,
      top: MediaQuery.paddingOf(context).top + 18,
      child: Material(
        color: AppColors.transparent,
        child: VitCard(
          variant: VitCardVariant.inner,
          padding: const EdgeInsets.fromLTRB(12, 9, 8, 9),
          borderColor: _slipBorder,
          child: Row(
            children: [
              const Icon(
                Icons.check_circle_outline,
                color: _slipGreen,
                size: 18,
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  text,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontSize: 12,
                  ),
                ),
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                onPressed: onClose,
                icon: const Icon(Icons.close_rounded, size: 18),
                color: AppColors.text3,
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
