import 'package:flutter/material.dart';

final class AppAssetColors {
  const AppAssetColors._();

  static const Color btc = Color(0xFFF7931A);
  static const Color eth = Color(0xFF627EEA);
  static const Color bnb = Color(0xFFF3BA2F);
  static const Color sol = Color(0xFF9945FF);
  static const Color xrp = Color(0xFF00AAE4);
  static const Color ada = Color(0xFF0033AD);
  static const Color dot = Color(0xFFE6007A);
  static const Color matic = Color(0xFF8247E5);
  static const Color avax = Color(0xFFE84142);
  static const Color link = Color(0xFF2A5ADA);
  static const Color uni = Color(0xFFFF007A);
  static const Color atom = Color(0xFF2E3148);
  static const Color near = Color(0xFF00C1DE);
  static const Color arb = Color(0xFF28A0F0);
  static const Color op = Color(0xFFFF0420);
  static const Color apt = Color(0xFF2A2A2A);
  static const Color inj = Color(0xFF00F2FE);
  static const Color sei = Color(0xFF9B1C1C);
  static const Color stx = Color(0xFF5546FF);
  static const Color wld = Color(0xFF1D1D1B);
  static const Color usdt = Color(0xFF26A17B);
  static const Color other = Color(0xFF1B2440);

  static const Color neutralChain = Color(0xFF6B7280);
  static const Color cyanChain = Color(0xFF06B6D4);
  static const Color skyChain = Color(0xFF0EA5E9);
  static const Color skySoftChain = Color(0xFF93C5FD);
  static const Color blueSoftChain = Color(0xFF60A5FA);
  static const Color blueBrightChain = Color(0xFF4DA2FF);
  static const Color skyBrightChain = Color(0xFF38BDF8);
  static const Color tealChain = Color(0xFF14B8A6);
  static const Color tealBrightChain = Color(0xFF00BFA5);
  static const Color indigoChain = Color(0xFF6366F1);
  static const Color indigoDeepChain = Color(0xFF29296E);
  static const Color violetDeepChain = Color(0xFF6B21A8);
  static const Color violetBrightChain = Color(0xFF7B2BF9);
  static const Color violetMidChain = Color(0xFF7B3FE4);
  static const Color pinkChain = Color(0xFFEC4899);
  static const Color pinkSoftChain = Color(0xFFF472B6);
  static const Color violetChain = Color(0xFFA855F7);
  static const Color slateSoftChain = Color(0xFFCBD5E1);
  static const Color goldChain = Color(0xFFC3A634);
  static const Color orangeChain = Color(0xFFFF4F00);
  static const Color brownChain = Color(0xFF6B4A22);

  static const Map<String, Color> registry = {
    'ADA': ada,
    'APT': apt,
    'ARB': arb,
    'ATOM': atom,
    'AVAX': avax,
    'BNB': bnb,
    'BTC': btc,
    'DOT': dot,
    'ETH': eth,
    'INJ': inj,
    'LINK': link,
    'MATIC': matic,
    'NEAR': near,
    'OP': op,
    'SEI': sei,
    'SOL': sol,
    'STX': stx,
    'UNI': uni,
    'USDT': usdt,
    'WLD': wld,
    'XRP': xrp,
  };

  static const Map<String, String> aliases = {
    'ARBITRUM': 'ARB',
    'APTOS': 'APT',
    'AVALANCHE': 'AVAX',
    'BINANCE': 'BNB',
    'BITCOIN': 'BTC',
    'COSMOS': 'ATOM',
    'ETHEREUM': 'ETH',
    'OPTIMISM': 'OP',
    'POLYGON': 'MATIC',
    'UNISWAP': 'UNI',
  };

  static Color forSymbol(String symbol, {Color? fallback}) {
    final normalized = symbol.trim().toUpperCase();
    final canonical = aliases[normalized] ?? normalized;
    return registry[canonical] ?? fallback ?? neutralChain;
  }
}
