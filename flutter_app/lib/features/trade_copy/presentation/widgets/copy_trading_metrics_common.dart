part of '../pages/copy_trading_page.dart';

class _Disclaimer extends StatelessWidget {
  const _Disclaimer({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: AppSpacing.x2),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: AppTextStyles.micro.copyWith(
          color: AppColors.text3,
          height: _copyTextLineHeight,
        ),
      ),
    );
  }
}

String _formatCompact(double value, {String prefix = ''}) {
  final abs = value.abs();
  if (abs >= 1000000) {
    return '$prefix${(value / 1000000).toStringAsFixed(2)}M';
  }
  if (abs >= 1000) {
    return '$prefix${(value / 1000).toStringAsFixed(1)}K';
  }
  return '$prefix${value.toStringAsFixed(0)}';
}

String _formatCompactNumber(int value) => formatTradeCompactNumber(value);
