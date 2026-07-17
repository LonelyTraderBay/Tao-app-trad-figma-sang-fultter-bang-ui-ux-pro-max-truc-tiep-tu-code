import 'package:vit_trade_flutter/features/trade_terminal/domain/entities/trade_terminal_entities.dart';

/// Data contract for the futures leverage and margin trading screens.
/// Financial submit paths are async per ADR-001 (see [SpotTradeRepository]).
abstract interface class TradeFuturesMarginRepository {
  TradeFuturesSnapshot getFutures({String pairId = 'btcusdt'});
  TradeFuturesLeverageSnapshot getFuturesLeverage({String pairId = 'btcusdt'});
  TradeMarginTradingSnapshot getMarginTrading({
    String pairId = 'btcusdt',
    bool pairRouteVariant = false,
  });
  TradeMarginTradingHubSnapshot getMarginTradingHub();
  TradeFuturesPreview previewFuturesOrder(TradeFuturesOrderDraft draft);

  /// Đường ghi tài chính là async theo ADR-001 (xem [SpotTradeRepository]).
  Future<TradeFuturesReceipt> submitFuturesOrder(TradeFuturesOrderDraft draft);
  TradeFuturesLeveragePreview previewFuturesLeverage(
    TradeFuturesLeverageRequest request,
  );
  Future<TradeFuturesLeverageReceipt> submitFuturesLeverage(
    TradeFuturesLeverageRequest request,
  );
}
