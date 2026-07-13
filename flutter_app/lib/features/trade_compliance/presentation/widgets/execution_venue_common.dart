part of '../pages/execution_venue_analysis_page.dart';

class _Card extends StatelessWidget {
  const _Card({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      borderColor: _venueBorder.withValues(alpha: .72),
      child: child,
    );
  }
}

String _formatSpeed(double value) {
  if (value == .3 || value == .4 || value == .5) {
    return value.toStringAsFixed(1);
  }
  return value.toStringAsFixed(2);
}

String _formatInt(num value) => formatTradeInt(value.round());

String _formatUsd(double value) => formatTradeUsdWhole(value);
