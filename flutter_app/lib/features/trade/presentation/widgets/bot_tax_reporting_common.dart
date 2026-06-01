part of '../pages/bot_tax_reporting_page.dart';

class _RadioDot extends StatelessWidget {
  const _RadioDot({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16,
      height: 16,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? _taxPrimary : _taxOptionBorder,
          width: 2,
        ),
      ),
      child: selected
          ? Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: _taxPrimary,
                shape: BoxShape.circle,
              ),
            )
          : null,
    );
  }
}

class _CheckBox extends StatelessWidget {
  const _CheckBox({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: selected ? _taxPrimary : AppColors.transparent,
        border: Border.all(
          color: selected ? _taxPrimary : _taxOptionBorder,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(7),
      ),
      child: selected
          ? const Icon(
              Icons.check_circle_rounded,
              color: AppColors.onAccent,
              size: 16,
            )
          : null,
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontSize: 11,
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child, required this.padding});

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: _taxPanel,
        border: Border.all(color: AppColors.cardBorder),
        borderRadius: AppRadii.cardRadius,
      ),
      child: child,
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 15,
          decoration: BoxDecoration(
            color: _taxPrimary,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 7),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontSize: 12,
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
