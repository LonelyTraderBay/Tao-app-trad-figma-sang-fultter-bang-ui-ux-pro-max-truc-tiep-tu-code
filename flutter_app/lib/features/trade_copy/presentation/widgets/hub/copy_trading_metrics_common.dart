part of '../../pages/hub/copy_trading_page.dart';

class _Disclaimer extends StatelessWidget {
  const _Disclaimer({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: AppSpacing.x2),
      child: VitRiskDisclaimerNote(message: text, height: _copyTextLineHeight),
    );
  }
}

String _formatCompact(double value, {String prefix = ''}) =>
    VitFormat.compactSuffix(value, prefix: prefix);

String _formatCompactNumber(int value) => formatTradeCompactNumber(value);
