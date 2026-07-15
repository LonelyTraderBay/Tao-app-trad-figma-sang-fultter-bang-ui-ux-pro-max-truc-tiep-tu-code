import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_spacing.dart';

/// Shared checked/unchecked radio icon for trade-bots single-select rows.
///
/// Picks between the filled and outline radio icon based on [selected],
/// coloring it with [activeColor] when selected and [inactiveColor]
/// otherwise.
class TradeBotRadioIcon extends StatelessWidget {
  const TradeBotRadioIcon({
    super.key,
    required this.selected,
    required this.activeColor,
    required this.inactiveColor,
    this.size = AppSpacing.contentPad,
  });

  final bool selected;
  final Color activeColor;
  final Color inactiveColor;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Icon(
      selected
          ? Icons.radio_button_checked_rounded
          : Icons.radio_button_unchecked_rounded,
      color: selected ? activeColor : inactiveColor,
      size: size,
    );
  }
}
