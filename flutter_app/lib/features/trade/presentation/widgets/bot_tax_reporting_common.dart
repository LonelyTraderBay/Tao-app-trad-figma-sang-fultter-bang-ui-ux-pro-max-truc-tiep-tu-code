part of '../pages/bot_tax_reporting_page.dart';

class _RadioDot extends StatelessWidget {
  const _RadioDot({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Icon(
      selected
          ? Icons.radio_button_checked_rounded
          : Icons.radio_button_unchecked_rounded,
      color: selected ? _taxPrimary : _taxOptionBorder,
      size: TradeSpacingTokens.tradeBotSelectionDot,
    );
  }
}

class _CheckBox extends StatelessWidget {
  const _CheckBox({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    // card-tile: allow-start — fixed surface, not horizontal strip tile
    return VitCard(
      variant: VitCardVariant.ghost,
      width: TradeSpacingTokens.tradeBotCheckbox,
      height: TradeSpacingTokens.tradeBotCheckbox,
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
  const _Card({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return VitCard(density: VitDensity.compact, child: child);
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
