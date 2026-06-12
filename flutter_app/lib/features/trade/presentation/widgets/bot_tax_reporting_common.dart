part of '../pages/bot_tax_reporting_page.dart';

class _RadioDot extends StatelessWidget {
  const _RadioDot({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 16,
      height: 16,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: selected ? _taxPrimary : _taxOptionBorder,
            width: 2,
          ),
        ),
        child: Center(
          child: selected
              ? const SizedBox(
                  width: 8,
                  height: 8,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: _taxPrimary,
                      shape: BoxShape.circle,
                    ),
                  ),
                )
              : null,
        ),
      ),
    );
  }
}

class _CheckBox extends StatelessWidget {
  const _CheckBox({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.ghost,
      width: 24,
      height: 24,
      alignment: Alignment.center,
      borderColor: selected ? _taxPrimary : _taxOptionBorder,
      child: selected
          ? const Icon(Icons.check_circle_rounded, color: _taxPrimary, size: 16)
          : const SizedBox.shrink(),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({
    required this.text,
    required this.color,
    required this.background,
  });

  final String text;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return VitStatusPill(
      label: text,
      status: color == AppColors.buy
          ? VitStatusPillStatus.success
          : VitStatusPillStatus.warning,
      size: VitStatusPillSize.sm,
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child, required this.padding});

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return VitCard(padding: padding, child: child);
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(
          width: 4,
          height: 15,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: _taxPrimary,
              borderRadius: AppRadii.smRadius,
            ),
          ),
        ),
        const SizedBox(width: 7),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontWeight: AppTextStyles.bold,
            height: 1,
          ),
        ),
      ],
    );
  }
}

String _formatInt(int value) {
  final raw = value.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < raw.length; i++) {
    final remaining = raw.length - i;
    buffer.write(raw[i]);
    if (remaining > 1 && remaining % 3 == 1) buffer.write(',');
  }
  return buffer.toString();
}

String _formatUsd(double value) => '\$${value.abs().toStringAsFixed(2)}';

String _formatSignedUsd(double value) {
  final sign = value < 0 ? '\$-' : '\$';
  return '$sign${value.abs().toStringAsFixed(2)}';
}
