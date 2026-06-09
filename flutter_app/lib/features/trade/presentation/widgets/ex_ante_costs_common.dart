part of '../pages/ex_ante_costs_page.dart';

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 14,
          decoration: BoxDecoration(
            color: _costPrimary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 7),
        Text(
          text,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text2,
            fontSize: 11,
            fontWeight: AppTextStyles.bold,
            height: 1,
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
