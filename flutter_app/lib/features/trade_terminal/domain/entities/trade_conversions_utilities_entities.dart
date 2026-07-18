part of 'trade_terminal_entities.dart';

/// Read-model for the Trade Export screen (available formats, periods, and
/// fields to include).
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

/// Aggregate trade stats (count, volume, fees, net PnL) shown on the
/// export screen.
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

/// A selectable export file format (e.g. CSV, PDF).
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

/// A selectable export date-range period.
final class TradeExportPeriod {
  const TradeExportPeriod({required this.id, required this.label});

  final String id;
  final String label;
}

/// A toggleable field/section to include in the export.
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

/// Request to generate a trade export for a given format/period/fields.
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

/// Result of generating a trade export, including its download URL.
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

/// Read-model for the Convert (asset swap) screen: available assets,
/// favorites, history, and the current quote inputs.
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

/// An asset available for conversion, with its balance and USD price.
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

/// A user's saved favorite from/to conversion pair.
final class TradeConvertFavoritePair {
  const TradeConvertFavoritePair({
    required this.fromSymbol,
    required this.toSymbol,
  });

  final String fromSymbol;
  final String toSymbol;

  String get label => '$fromSymbol/$toSymbol';
}

/// A completed conversion record shown in convert history.
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

/// Request to convert one asset amount into another.
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

  // Value equality (GD4 Cụm F3): `previewConvert` is now `Future<T>`
  // (ADR-001), watched behind a `FutureProvider.family` keyed on this
  // request — value equality lets a request rebuilt with the same on-screen
  // values (e.g. an unrelated rebuild that doesn't change the amount)
  // resolve to the same cache entry instead of a new one each time (khuôn
  // PERF-HN1, xem `TradeOrderDraft`/`TradeFuturesOrderDraft`).
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TradeConvertRequest &&
          other.fromSymbol == fromSymbol &&
          other.toSymbol == toSymbol &&
          other.amount == amount &&
          other.slippagePct == slippagePct &&
          other.mode == mode);

  @override
  int get hashCode =>
      Object.hash(fromSymbol, toSymbol, amount, slippagePct, mode);
}

/// Quoted conversion rate/fee for a pending convert request, with
/// validity window — financial write path, see ADR-001.
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

/// Receipt returned after submitting a conversion — financial write path,
/// see ADR-001.
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
