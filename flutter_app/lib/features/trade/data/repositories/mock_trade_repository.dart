import 'package:vit_trade_flutter/core/product_flow/contextual_support_contract.dart';
import 'package:vit_trade_flutter/core/product_flow/high_risk_flow_contract.dart';
import 'package:vit_trade_flutter/features/trade/domain/entities/trade_entities.dart';
import 'package:vit_trade_flutter/features/trade/domain/repositories/trade_repository.dart';

part '../fixtures/trade_advanced_tools_repository_methods.dart';
part '../fixtures/trade_advanced_tools_repository_fixtures.dart';
part '../fixtures/trade_bot_backtest_portfolio_repository_methods.dart';
part '../fixtures/trade_bot_backtest_portfolio_repository_fixtures.dart';
part '../fixtures/trade_bot_guide_docs_repository_fixtures.dart';
part '../fixtures/trade_bot_lifecycle_risk_repository_methods.dart';
part '../fixtures/trade_bot_lifecycle_risk_repository_fixtures.dart';
part '../fixtures/trade_conversions_utilities_repository_methods.dart';
part '../fixtures/trade_conversions_utilities_repository_fixtures.dart';
part '../fixtures/trade_copy_configuration_repository_methods.dart';
part '../fixtures/trade_copy_configuration_repository_fixtures.dart';
part '../fixtures/trade_copy_lifecycle_repository_methods.dart';
part '../fixtures/trade_copy_lifecycle_repository_fixtures.dart';
part '../fixtures/trade_copy_provider_discovery_repository_methods.dart';
part '../fixtures/trade_copy_provider_discovery_repository_fixtures.dart';
part '../fixtures/trade_core_spot_repository_methods.dart';
part '../fixtures/trade_core_spot_repository_fixtures.dart';
part '../fixtures/trade_execution_analytics_repository_methods.dart';
part '../fixtures/trade_execution_analytics_repository_fixtures.dart';
part '../fixtures/trade_futures_leverage_repository_methods.dart';
part '../fixtures/trade_futures_leverage_repository_fixtures.dart';
part '../fixtures/trade_regulatory_costs_repository_methods.dart';
part '../fixtures/trade_regulatory_costs_repository_fixtures.dart';
part '../fixtures/trade_regulatory_disclosures_repository_methods.dart';
part '../fixtures/trade_regulatory_disclosures_repository_fixtures.dart';
part '../fixtures/trade_regulatory_disputes_repository_methods.dart';
part '../fixtures/trade_regulatory_disputes_repository_fixtures.dart';

mixin _MockTradeRepositoryBase implements TradeRepository {}

final class MockTradeRepository
    with
        _MockTradeRepositoryBase,
        _MockTradeRepositoryAdvancedToolsMethods,
        _MockTradeRepositoryBotBacktestPortfolioMethods,
        _MockTradeRepositoryBotLifecycleRiskMethods,
        _MockTradeRepositoryConversionsUtilitiesMethods,
        _MockTradeRepositoryCopyConfigurationMethods,
        _MockTradeRepositoryCopyLifecycleMethods,
        _MockTradeRepositoryCopyProviderDiscoveryMethods,
        _MockTradeRepositoryCoreSpotMethods,
        _MockTradeRepositoryExecutionAnalyticsMethods,
        _MockTradeRepositoryFuturesLeverageMethods,
        _MockTradeRepositoryRegulatoryCostsMethods,
        _MockTradeRepositoryRegulatoryDisclosuresMethods,
        _MockTradeRepositoryRegulatoryDisputesMethods {
  const MockTradeRepository();
}
