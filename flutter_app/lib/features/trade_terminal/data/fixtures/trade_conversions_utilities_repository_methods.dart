part of '../repositories/mock_trade_terminal_repository.dart';

mixin _MockTradeTerminalRepositoryConversionsUtilitiesMethods
    on _MockTradeTerminalRepositoryBase {
  @override
  TradeExportSnapshot getTradeExport() {
    return TradeExportSnapshot(
      trade: getTrade(),
      stats: const TradeExportStats(
        totalTrades: 847,
        totalVolume: 2458300,
        totalFees: 2340.56,
        netPnl: 12456.78,
      ),
      formats: _tradeExportFormats,
      periods: _tradeExportPeriods,
      includes: _tradeExportIncludes,
      lastUpdatedLabel: 'success',
      supportedStates: const [
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.submitting,
        TradeScreenState.success,
        TradeScreenState.realtimeRefresh,
      ],
    );
  }

  @override
  TradeConvertSnapshot getConvert() {
    return TradeConvertSnapshot(
      trade: getTrade(),
      assets: _convertAssets,
      favoritePairs: _convertFavoritePairs,
      history: _convertHistory,
      slippageOptions: const [.5, 1, 2],
      fromAsset: _convertAssetBySymbol('USDT'),
      toAsset: _convertAssetBySymbol('BTC'),
      rateLabel: '1 USDT = 0.000015 BTC',
      countdownLabel: '14s',
      minUsd: 10,
      maxUsd: 500000,
      lastUpdatedLabel: 'realtime-refresh',
      supportedStates: const [
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.submitting,
        TradeScreenState.success,
        TradeScreenState.realtimeRefresh,
      ],
    );
  }

  @override
  TradeExportResult createTradeExport(TradeExportRequest request) {
    return TradeExportResult(
      exportId: 'EXP-TRADE-054',
      format: request.format,
      status: 'ready',
      downloadUrl: '/exports/EXP-TRADE-054.${request.format}',
    );
  }

  @override
  TradeConvertQuote previewConvert(TradeConvertRequest request) {
    final fromAsset = _convertAssetBySymbol(request.fromSymbol);
    final toAsset = _convertAssetBySymbol(request.toSymbol);
    final grossRate = fromAsset.priceUsd / toAsset.priceUsd;
    const feeRate = .001;
    final effectiveRate = grossRate * (1 - feeRate);
    final toAmount = request.amount <= 0 ? 0.0 : request.amount * effectiveRate;
    final feeUsd = request.amount <= 0
        ? 0.0
        : request.amount * fromAsset.priceUsd * feeRate;
    final ratePrecision = toAsset.priceUsd >= 1000 ? 6 : 4;
    return TradeConvertQuote(
      fromSymbol: fromAsset.symbol,
      toSymbol: toAsset.symbol,
      fromAmount: request.amount,
      toAmount: toAmount,
      feeUsd: feeUsd,
      rate: effectiveRate,
      quoteLabel:
          '1 ${fromAsset.symbol} = ${effectiveRate.toStringAsFixed(ratePrecision)} ${toAsset.symbol}',
      validSeconds: 14,
      canSubmit: request.amount * fromAsset.priceUsd >= 10,
    );
  }

  @override
  TradeConvertReceipt submitConvert(TradeConvertRequest request) {
    return TradeConvertReceipt(
      convertId: 'CVT-DEMO-056',
      quote: previewConvert(request),
      status: 'submitted',
    );
  }
}
