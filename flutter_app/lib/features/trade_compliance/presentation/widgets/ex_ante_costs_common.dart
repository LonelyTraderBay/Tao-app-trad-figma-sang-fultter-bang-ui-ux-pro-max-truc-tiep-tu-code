part of '../pages/ex_ante_costs_page.dart';

class _Card extends StatelessWidget {
  const _Card({required this.child, required this.padding});

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      padding: padding,
      borderColor: _costBorder.withValues(alpha: .72),
      child: child,
    );
  }
}

String _formatEur(double value) {
  final fixed = value.round().toString();
  final buffer = StringBuffer();
  for (var index = 0; index < fixed.length; index += 1) {
    if (index > 0 && (fixed.length - index) % 3 == 0) {
      buffer.write(',');
    }
    buffer.write(fixed[index]);
  }
  return '€${buffer.toString()}';
}
