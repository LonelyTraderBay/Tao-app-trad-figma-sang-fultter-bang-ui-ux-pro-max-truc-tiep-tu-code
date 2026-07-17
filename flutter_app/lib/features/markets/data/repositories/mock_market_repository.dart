import 'package:vit_trade_flutter/core/utils/accent_tone.dart';
import 'package:vit_trade_flutter/features/markets/domain/entities/market_entities.dart';
import 'package:vit_trade_flutter/features/markets/domain/repositories/market_repository.dart';

part '../fixtures/mock_market_shared_fixtures.dart';
part '../fixtures/mock_market_overview_methods.dart';
part '../fixtures/mock_market_screening_methods.dart';
part '../fixtures/mock_market_calendar_derivatives_methods.dart';
part '../fixtures/mock_market_social_sentiment_methods.dart';
part '../fixtures/mock_market_portfolio_news_methods.dart';
part '../fixtures/mock_market_token_detail_methods.dart';

mixin _MockMarketRepositoryBase implements MarketRepository {}

final class MockMarketRepository
    with
        _MockMarketRepositoryBase,
        _MockMarketRepositoryOverviewMethods,
        _MockMarketRepositoryScreeningMethods,
        _MockMarketRepositoryCalendarDerivativesMethods,
        _MockMarketRepositorySocialSentimentMethods,
        _MockMarketRepositoryPortfolioNewsMethods,
        _MockMarketRepositoryTokenDetailMethods {
  const MockMarketRepository();
}
