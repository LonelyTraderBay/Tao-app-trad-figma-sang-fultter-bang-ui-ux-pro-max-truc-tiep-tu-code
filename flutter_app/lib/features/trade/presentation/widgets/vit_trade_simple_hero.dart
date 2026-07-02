import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/shared/widgets/vit_trade_instrument_hero.dart';

/// Beginner hero — large glow card matching Home portfolio rhythm.
class VitTradeSimpleHero extends StatelessWidget {
  const VitTradeSimpleHero({
    super.key,
    required this.symbol,
    required this.priceLabel,
    required this.changePct,
    this.highLabel,
    this.lowLabel,
    this.volumeLabel,
  });

  final String symbol;
  final String priceLabel;
  final double changePct;
  final String? highLabel;
  final String? lowLabel;
  final String? volumeLabel;

  @override
  Widget build(BuildContext context) {
    return VitTradeInstrumentHero(
      symbol: symbol,
      priceLabel: priceLabel,
      changePct: changePct,
      highLabel: highLabel,
      lowLabel: lowLabel,
      volumeLabel: volumeLabel,
      density: VitTradeInstrumentHeroDensity.standard,
    );
  }
}
