part of 'trade_entities.dart';

final class TradeExportSnapshot {
  const TradeExportSnapshot({
    required this.trade,
    required this.stats,
    required this.formats,
    required this.periods,
    required this.includes,
    required this.supportedStates,
    required this.lastUpdatedLabel,
  });

  final TradeScreenSnapshot trade;
  final TradeExportStats stats;
  final List<TradeExportFormat> formats;
  final List<TradeExportPeriod> periods;
  final List<TradeExportInclude> includes;
  final List<TradeScreenState> supportedStates;
  final String lastUpdatedLabel;
}

final class TradeExportStats {
  const TradeExportStats({
    required this.totalTrades,
    required this.totalVolume,
    required this.totalFees,
    required this.netPnl,
  });

  final int totalTrades;
  final double totalVolume;
  final double totalFees;
  final double netPnl;
}

final class TradeExportFormat {
  const TradeExportFormat({
    required this.id,
    required this.label,
    required this.description,
  });

  final String id;
  final String label;
  final String description;
}

final class TradeExportPeriod {
  const TradeExportPeriod({required this.id, required this.label});

  final String id;
  final String label;
}

final class TradeExportInclude {
  const TradeExportInclude({
    required this.id,
    required this.label,
    required this.checked,
  });

  final String id;
  final String label;
  final bool checked;

  TradeExportInclude copyWith({bool? checked}) {
    return TradeExportInclude(
      id: id,
      label: label,
      checked: checked ?? this.checked,
    );
  }
}

final class TradeExportRequest {
  const TradeExportRequest({
    required this.format,
    required this.period,
    required this.includeIds,
  });

  final String format;
  final String period;
  final List<String> includeIds;
}

final class TradeExportResult {
  const TradeExportResult({
    required this.exportId,
    required this.format,
    required this.status,
    required this.downloadUrl,
  });

  final String exportId;
  final String format;
  final String status;
  final String downloadUrl;
}

final class TradeConvertSnapshot {
  const TradeConvertSnapshot({
    required this.trade,
    required this.assets,
    required this.favoritePairs,
    required this.history,
    required this.slippageOptions,
    required this.fromAsset,
    required this.toAsset,
    required this.rateLabel,
    required this.countdownLabel,
    required this.minUsd,
    required this.maxUsd,
    required this.supportedStates,
    required this.lastUpdatedLabel,
  });

  final TradeScreenSnapshot trade;
  final List<TradeConvertAsset> assets;
  final List<TradeConvertFavoritePair> favoritePairs;
  final List<TradeConvertHistoryRecord> history;
  final List<double> slippageOptions;
  final TradeConvertAsset fromAsset;
  final TradeConvertAsset toAsset;
  final String rateLabel;
  final String countdownLabel;
  final double minUsd;
  final double maxUsd;
  final List<TradeScreenState> supportedStates;
  final String lastUpdatedLabel;
}

final class TradeConvertAsset {
  const TradeConvertAsset({
    required this.symbol,
    required this.name,
    required this.balance,
    required this.priceUsd,
    required this.colorHex,
  });

  final String symbol;
  final String name;
  final double balance;
  final double priceUsd;
  final int colorHex;
}

final class TradeConvertFavoritePair {
  const TradeConvertFavoritePair({
    required this.fromSymbol,
    required this.toSymbol,
  });

  final String fromSymbol;
  final String toSymbol;

  String get label => '$fromSymbol/$toSymbol';
}

final class TradeConvertHistoryRecord {
  const TradeConvertHistoryRecord({
    required this.id,
    required this.fromSymbol,
    required this.toSymbol,
    required this.fromAmount,
    required this.toAmount,
    required this.feeUsd,
    required this.rate,
    required this.timeLabel,
    required this.status,
  });

  final String id;
  final String fromSymbol;
  final String toSymbol;
  final double fromAmount;
  final double toAmount;
  final double feeUsd;
  final double rate;
  final String timeLabel;
  final String status;
}

final class TradeConvertRequest {
  const TradeConvertRequest({
    required this.fromSymbol,
    required this.toSymbol,
    required this.amount,
    required this.slippagePct,
    required this.mode,
  });

  final String fromSymbol;
  final String toSymbol;
  final double amount;
  final double slippagePct;
  final String mode;
}

final class TradeConvertQuote {
  const TradeConvertQuote({
    required this.fromSymbol,
    required this.toSymbol,
    required this.fromAmount,
    required this.toAmount,
    required this.feeUsd,
    required this.rate,
    required this.quoteLabel,
    required this.validSeconds,
    required this.canSubmit,
  });

  final String fromSymbol;
  final String toSymbol;
  final double fromAmount;
  final double toAmount;
  final double feeUsd;
  final double rate;
  final String quoteLabel;
  final int validSeconds;
  final bool canSubmit;
}

final class TradeConvertReceipt {
  const TradeConvertReceipt({
    required this.convertId,
    required this.quote,
    required this.status,
  });

  final String convertId;
  final TradeConvertQuote quote;
  final String status;
}
