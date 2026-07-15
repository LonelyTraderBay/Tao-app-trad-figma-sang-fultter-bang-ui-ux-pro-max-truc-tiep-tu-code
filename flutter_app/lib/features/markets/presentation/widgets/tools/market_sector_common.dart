import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/accent_tone_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_asset_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/features/markets/presentation/controllers/market_controller.dart';

const marketSectorPrimary = AppColors.primary;
const marketSectorAccent = AppColors.accent;

const marketSectorsContentKey = Key('sc011_market_sectors_scroll_content');
const marketSectorDetailContentKey = Key('sc011_market_sector_detail_content');
const marketSectorTimeframe24hKey = Key('sc011_timeframe_24h');
const marketSectorTimeframe7dKey = Key('sc011_timeframe_7d');
const marketSectorTimeframe30dKey = Key('sc011_timeframe_30d');
const marketSectorSortPerformanceKey = Key('sc011_sort_performance');
const marketSectorSortMarketCapKey = Key('sc011_sort_market_cap');
const marketSectorSortCoinCountKey = Key('sc011_sort_coin_count');
const marketSectorComparisonKey = Key('sc011_sector_comparison');

Key marketSectorKey(String id) => Key('sc011_sector_$id');

Key marketSectorTimeframeKey(String value) {
  return switch (value) {
    '7d' => marketSectorTimeframe7dKey,
    '30d' => marketSectorTimeframe30dKey,
    _ => marketSectorTimeframe24hKey,
  };
}

Key marketSectorSortKey(String id) {
  return switch (id) {
    'market_cap' => marketSectorSortMarketCapKey,
    'coin_count' => marketSectorSortCoinCountKey,
    _ => marketSectorSortPerformanceKey,
  };
}

List<MarketSector> visibleMarketSectors(
  MarketSectorsSnapshot snapshot, {
  required String sort,
  required String timeframe,
}) {
  final sorted = snapshot.sectors.toList();
  switch (sort) {
    case 'market_cap':
      sorted.sort((a, b) => b.totalMarketCap.compareTo(a.totalMarketCap));
    case 'coin_count':
      sorted.sort((a, b) => b.coinCount.compareTo(a.coinCount));
    case 'performance':
    default:
      sorted.sort(
        (a, b) => marketSectorChangeFor(
          b,
          timeframe,
        ).compareTo(marketSectorChangeFor(a, timeframe)),
      );
  }
  return sorted;
}

double marketSectorChangeFor(MarketSector sector, String timeframe) {
  return switch (timeframe) {
    '7d' => sector.change7d,
    '30d' => sector.change30d,
    _ => sector.change24h,
  };
}

MarketSector? findMarketSector(List<MarketSector> sectors, String? id) {
  if (id == null || id.isEmpty) return null;
  for (final sector in sectors) {
    if (sector.id == id) return sector;
  }
  return null;
}

List<MarketSectorCoin> coinsForMarketSector(
  MarketSector sector,
  MarketSectorsSnapshot snapshot,
) {
  return [
    for (final symbol in sector.topCoins)
      _coinForSymbol(symbol, sector, snapshot),
  ];
}

MarketSectorCoin _coinForSymbol(
  String symbol,
  MarketSector sector,
  MarketSectorsSnapshot snapshot,
) {
  for (final pair in snapshot.marketPairs) {
    if (pair.baseAsset == symbol) {
      return MarketSectorCoin(
        id: pair.baseAsset.toLowerCase(),
        symbol: symbol,
        name: pair.baseAsset,
        priceLabel: formatMarketSectorPrice(pair.price),
        change24h: pair.change24h,
        color: AppAssetColors.forSymbol(pair.baseAsset),
      );
    }
  }

  return MarketSectorCoin(
    id: symbol.toLowerCase(),
    symbol: symbol,
    name: sector.name,
    priceLabel: '--',
    change24h: sector.change24h,
    color: sector.color.resolve(),
  );
}

final class MarketSectorCoin {
  const MarketSectorCoin({
    required this.id,
    required this.symbol,
    required this.name,
    required this.priceLabel,
    required this.change24h,
    required this.color,
  });

  final String id;
  final String symbol;
  final String name;
  final String priceLabel;
  final double change24h;
  final Color color;
}

String formatMarketSectorBillions(double value) {
  final billions = value / 1000000000;
  return '\$${formatMarketSectorNumber(billions, 2)}B';
}

String formatMarketSectorPercent(double value) {
  final sign = value >= 0 ? '+' : '';
  return '$sign${value.toStringAsFixed(2)}%';
}

String formatMarketSectorDominance(double value) {
  return value < 1 ? value.toStringAsFixed(2) : value.toStringAsFixed(1);
}

String formatMarketSectorPrice(double value) {
  if (value <= 0) return '--';
  if (value >= 1000) return '\$${formatMarketSectorNumber(value, 2)}';
  if (value < 1) return '\$${value.toStringAsFixed(4)}';
  return '\$${value.toStringAsFixed(2)}';
}

String formatMarketSectorNumber(double value, int fractionDigits) {
  final fixed = value.toStringAsFixed(fractionDigits);
  final parts = fixed.split('.');
  final integer = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < integer.length; i++) {
    final remaining = integer.length - i;
    buffer.write(integer[i]);
    if (remaining > 1 && remaining % 3 == 1) {
      buffer.write(',');
    }
  }
  if (parts.length == 1 || fractionDigits == 0) return buffer.toString();
  return '${buffer.toString()}.${parts.last}';
}
