import 'package:vit_trade_flutter/features/trade_terminal/domain/entities/trade_terminal_entities.dart';

/// Data contract for the futures leverage and margin trading screens.
/// Financial submit paths are async per ADR-001 (see [SpotTradeRepository]).
abstract interface class TradeFuturesMarginRepository {
  Future<TradeFuturesSnapshot> getFutures({String pairId = 'btcusdt'});
  Future<TradeFuturesLeverageSnapshot> getFuturesLeverage({
    String pairId = 'btcusdt',
  });
  Future<TradeMarginTradingSnapshot> getMarginTrading({
    String pairId = 'btcusdt',
    bool pairRouteVariant = false,
  });
  Future<TradeMarginTradingHubSnapshot> getMarginTradingHub();
  Future<TradeFuturesPreview> previewFuturesOrder(TradeFuturesOrderDraft draft);

  /// Đường ghi tài chính là async theo ADR-001 (xem [SpotTradeRepository]).
  Future<TradeFuturesReceipt> submitFuturesOrder(TradeFuturesOrderDraft draft);
  Future<TradeFuturesLeveragePreview> previewFuturesLeverage(
    TradeFuturesLeverageRequest request,
  );
  Future<TradeFuturesLeverageReceipt> submitFuturesLeverage(
    TradeFuturesLeverageRequest request,
  );
}
