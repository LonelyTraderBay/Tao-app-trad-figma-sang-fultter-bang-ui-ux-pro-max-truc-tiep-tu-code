import 'package:vit_trade_flutter/features/trade_terminal/domain/entities/trade_terminal_entities.dart';

abstract interface class TradeFuturesMarginRepository {
  TradeFuturesSnapshot getFutures({String pairId = 'btcusdt'});
  TradeFuturesLeverageSnapshot getFuturesLeverage({String pairId = 'btcusdt'});
  TradeMarginTradingSnapshot getMarginTrading({
    String pairId = 'btcusdt',
    bool pairRouteVariant = false,
  });
  TradeMarginTradingHubSnapshot getMarginTradingHub();
  TradeFuturesPreview previewFuturesOrder(TradeFuturesOrderDraft draft);
  TradeFuturesReceipt submitFuturesOrder(TradeFuturesOrderDraft draft);
  TradeFuturesLeveragePreview previewFuturesLeverage(
    TradeFuturesLeverageRequest request,
  );
  TradeFuturesLeverageReceipt submitFuturesLeverage(
    TradeFuturesLeverageRequest request,
  );
}
