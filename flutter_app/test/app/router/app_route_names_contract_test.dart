import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';

void main() {
  test('defines stable route names for ported screens', () {
    expect(AppRouteNames.sc001Login, 'sc001Login');
    expect(AppRouteNames.sc002Register, 'sc002Register');
    expect(AppRouteNames.sc003Otp, 'sc003Otp');
    expect(AppRouteNames.sc004TwoFaSetup, 'sc004TwoFaSetup');
    expect(AppRouteNames.sc005ForgotPassword, 'sc005ForgotPassword');
    expect(AppRouteNames.sc006ResetPassword, 'sc006ResetPassword');
    expect(AppRouteNames.sc007Home, 'sc007Home');
    expect(AppRouteNames.sc008MarketList, 'sc008MarketList');
    expect(AppRouteNames.sc009MarketOverview, 'sc009MarketOverview');
    expect(AppRouteNames.sc010MarketMovers, 'sc010MarketMovers');
    expect(AppRouteNames.sc011MarketSectors, 'sc011MarketSectors');
    expect(AppRouteNames.sc012Watchlist, 'sc012Watchlist');
    expect(AppRouteNames.sc013MarketHeatmap, 'sc013MarketHeatmap');
    expect(AppRouteNames.sc014PriceAlerts, 'sc014PriceAlerts');
    expect(AppRouteNames.sc015MarketScreener, 'sc015MarketScreener');
    expect(AppRouteNames.sc016ComparisonTool, 'sc016ComparisonTool');
    expect(AppRouteNames.sc017MarketCalendar, 'sc017MarketCalendar');
    expect(AppRouteNames.sc018DerivativesOverview, 'sc018DerivativesOverview');
    expect(AppRouteNames.sc019MarketDepth, 'sc019MarketDepth');
    expect(AppRouteNames.sc020SocialSentiment, 'sc020SocialSentiment');
    expect(AppRouteNames.sc021PortfolioTracker, 'sc021PortfolioTracker');
    expect(AppRouteNames.sc022MarketNews, 'sc022MarketNews');
    expect(AppRouteNames.sc023AdvancedCharts, 'sc023AdvancedCharts');
    expect(AppRouteNames.sc024TokenUnlocks, 'sc024TokenUnlocks');
    expect(AppRouteNames.sc025SocialSignals, 'sc025SocialSignals');
    expect(AppRouteNames.sc026MarketCorrelations, 'sc026MarketCorrelations');
    expect(AppRouteNames.sc027PredictionsHome, 'sc027PredictionsHome');
    expect(AppRouteNames.sc028PredictionsSearch, 'sc028PredictionsSearch');
    expect(AppRouteNames.sc029PredictionsBreaking, 'sc029PredictionsBreaking');
    expect(
      AppRouteNames.sc030PredictionEventDetail,
      'sc030PredictionEventDetail',
    );
    expect(
      AppRouteNames.sc031PredictionsPortfolio,
      'sc031PredictionsPortfolio',
    );
    expect(AppRouteNames.sc032PredictionsRewards, 'sc032PredictionsRewards');
    expect(
      AppRouteNames.sc033PredictionsLeaderboard,
      'sc033PredictionsLeaderboard',
    );
    expect(
      AppRouteNames.sc034PredictionsGlobalActivity,
      'sc034PredictionsGlobalActivity',
    );
    expect(
      AppRouteNames.sc035PredictionOrderReceipt,
      'sc035PredictionOrderReceipt',
    );
    expect(
      AppRouteNames.sc036PredictionRiskCalculator,
      'sc036PredictionRiskCalculator',
    );
    expect(
      AppRouteNames.sc037PredictionMarketMaker,
      'sc037PredictionMarketMaker',
    );
    expect(
      AppRouteNames.sc038PredictionPortfolioAnalyzer,
      'sc038PredictionPortfolioAnalyzer',
    );
    expect(
      AppRouteNames.sc039PredictionEventCalendar,
      'sc039PredictionEventCalendar',
    );
    expect(AppRouteNames.sc040PredictionSocial, 'sc040PredictionSocial');
    expect(
      AppRouteNames.sc041PredictionAdvancedChart,
      'sc041PredictionAdvancedChart',
    );
    expect(
      AppRouteNames.sc042PredictionTournaments,
      'sc042PredictionTournaments',
    );
    expect(
      AppRouteNames.sc043PredictionDataIntegration,
      'sc043PredictionDataIntegration',
    );
    expect(AppRouteNames.sc044PairDetail, 'sc044PairDetail');
    expect(AppRouteNames.sc045TokenInfo, 'sc045TokenInfo');
    expect(AppRouteNames.sc046PairDepth, 'sc046PairDepth');
    expect(AppRouteNames.sc047News, 'sc047News');
    expect(AppRouteNames.sc048Trade, 'sc048Trade');
    expect(AppRouteNames.sc049TradePair, 'sc049TradePair');
    expect(AppRouteNames.sc050OrdersHistory, 'sc050OrdersHistory');
    expect(AppRouteNames.sc051OrderReceipt, 'sc051OrderReceipt');
    expect(AppRouteNames.sc052TradeSettings, 'sc052TradeSettings');
    expect(AppRouteNames.sc053PositionDashboard, 'sc053PositionDashboard');
    expect(AppRouteNames.sc054TradeHistoryExport, 'sc054TradeHistoryExport');
    expect(AppRouteNames.sc055AdvancedChart, 'sc055AdvancedChart');
    expect(AppRouteNames.sc056Convert, 'sc056Convert');
    expect(AppRouteNames.sc057Futures, 'sc057Futures');
    expect(AppRouteNames.sc058Leverage, 'sc058Leverage');
    expect(AppRouteNames.sc059TradingBots, 'sc059TradingBots');
    expect(AppRouteNames.sc060RiskManagement, 'sc060RiskManagement');
    expect(AppRouteNames.sc061ExecutionQuality, 'sc061ExecutionQuality');
    expect(AppRouteNames.sc062AdvancedTools, 'sc062AdvancedTools');
    expect(AppRouteNames.sc063CopyTrading, 'sc063CopyTrading');
    expect(AppRouteNames.sc064CopyTradingV2, 'sc064CopyTradingV2');
    expect(AppRouteNames.sc065CopyEducation, 'sc065CopyEducation');
    expect(AppRouteNames.sc066ActiveCopies, 'sc066ActiveCopies');
    expect(AppRouteNames.sc067CopySettings, 'sc067CopySettings');
    expect(AppRouteNames.sc068CopyNotifications, 'sc068CopyNotifications');
    expect(AppRouteNames.sc069ProviderApplication, 'sc069ProviderApplication');
    expect(AppRouteNames.sc070CopyProviderDetail, 'sc070CopyProviderDetail');
    expect(AppRouteNames.sc071PreCopyAssessment, 'sc071PreCopyAssessment');
    expect(AppRouteNames.sc072CopyConfiguration, 'sc072CopyConfiguration');
    expect(AppRouteNames.sc073CopyConfirmation, 'sc073CopyConfirmation');
    expect(AppRouteNames.sc074CopyPerformance, 'sc074CopyPerformance');
    expect(
      AppRouteNames.sc075PerformanceAttribution,
      'sc075PerformanceAttribution',
    );
    expect(AppRouteNames.sc076ProviderComparison, 'sc076ProviderComparison');
    expect(AppRouteNames.sc077CopyAuditLog, 'sc077CopyAuditLog');
    expect(
      AppRouteNames.sc078PortfolioRiskAnalysis,
      'sc078PortfolioRiskAnalysis',
    );
    expect(AppRouteNames.sc079ProviderLeaderboard, 'sc079ProviderLeaderboard');
    expect(AppRouteNames.sc080SafetyEducation, 'sc080SafetyEducation');
    expect(AppRouteNames.sc081ProviderGovernance, 'sc081ProviderGovernance');
    expect(AppRouteNames.sc082DisputeResolution, 'sc082DisputeResolution');
    expect(AppRouteNames.sc083CopySafetyCenter, 'sc083CopySafetyCenter');
    expect(
      AppRouteNames.sc084RegulatoryDisclosures,
      'sc084RegulatoryDisclosures',
    );
    expect(AppRouteNames.sc085MarginTrading, 'sc085MarginTrading');
    expect(AppRouteNames.sc086MarginTradingPair, 'sc086MarginTradingPair');
    expect(AppRouteNames.sc087TraderProfile, 'sc087TraderProfile');
    expect(AppRouteNames.sc088AdvancedTradingDemo, 'sc088AdvancedTradingDemo');
    expect(AppRouteNames.sc089MarketDataAnalytics, 'sc089MarketDataAnalytics');
    expect(AppRouteNames.sc090MarginTradingHub, 'sc090MarginTradingHub');
    expect(
      AppRouteNames.sc091LiveMarketDataAnalytics,
      'sc091LiveMarketDataAnalytics',
    );
    expect(AppRouteNames.sc092AdvancedAnalytics, 'sc092AdvancedAnalytics');
    expect(
      AppRouteNames.sc093TransactionReporting,
      'sc093TransactionReporting',
    );
    expect(
      AppRouteNames.sc094RegulatoryReportsDashboard,
      'sc094RegulatoryReportsDashboard',
    );
    expect(
      AppRouteNames.sc095ArmIntegrationStatus,
      'sc095ArmIntegrationStatus',
    );
    expect(
      AppRouteNames.sc096BestExecutionReports,
      'sc096BestExecutionReports',
    );
    expect(
      AppRouteNames.sc097ExecutionVenueAnalysis,
      'sc097ExecutionVenueAnalysis',
    );
    expect(AppRouteNames.sc098SlippageMonitoring, 'sc098SlippageMonitoring');
    expect(
      AppRouteNames.sc099ClientCategorization,
      'sc099ClientCategorization',
    );
    expect(AppRouteNames.sc100ProductGovernance, 'sc100ProductGovernance');
    expect(
      AppRouteNames.sc101TargetMarketDefinition,
      'sc101TargetMarketDefinition',
    );
    expect(
      AppRouteNames.sc102ClientMoneyProtection,
      'sc102ClientMoneyProtection',
    );
    expect(AppRouteNames.sc103CassReconciliation, 'sc103CassReconciliation');
    expect(
      AppRouteNames.sc104InvestorCompensation,
      'sc104InvestorCompensation',
    );
    expect(AppRouteNames.sc105ExAnteCosts, 'sc105ExAnteCosts');
    expect(AppRouteNames.sc106RiyCalculator, 'sc106RiyCalculator');
    expect(AppRouteNames.sc107ExPostCostsReport, 'sc107ExPostCostsReport');
    expect(AppRouteNames.sc108KidGenerator, 'sc108KidGenerator');
    expect(
      AppRouteNames.sc109PerformanceScenarios,
      'sc109PerformanceScenarios',
    );
    expect(
      AppRouteNames.sc110RiskIndicatorExplainer,
      'sc110RiskIndicatorExplainer',
    );
    expect(AppRouteNames.sc111ComplaintsHandling, 'sc111ComplaintsHandling');
    expect(AppRouteNames.sc112ComplaintSubmission, 'sc112ComplaintSubmission');
    expect(AppRouteNames.sc113ComplaintTracking, 'sc113ComplaintTracking');
    expect(AppRouteNames.sc114OmbudsmanReferral, 'sc114OmbudsmanReferral');
    expect(AppRouteNames.sc115AuditTrail, 'sc115AuditTrail');
    expect(
      AppRouteNames.sc116RegulatoryInspectionReady,
      'sc116RegulatoryInspectionReady',
    );
    expect(AppRouteNames.sc117BotTermsOfService, 'sc117BotTermsOfService');
    expect(AppRouteNames.sc118BotRiskDisclosure, 'sc118BotRiskDisclosure');
    expect(
      AppRouteNames.sc119BotSuitabilityAssessment,
      'sc119BotSuitabilityAssessment',
    );
    expect(AppRouteNames.sc120BotRiskDashboard, 'sc120BotRiskDashboard');
    expect(AppRouteNames.sc121BotEmergencyStop, 'sc121BotEmergencyStop');
    expect(AppRouteNames.sc122BotSecuritySettings, 'sc122BotSecuritySettings');
    expect(AppRouteNames.sc123BotHistory, 'sc123BotHistory');
    expect(
      AppRouteNames.sc124BotPerformanceAnalytics,
      'sc124BotPerformanceAnalytics',
    );
    expect(AppRouteNames.sc125BotBacktesting, 'sc125BotBacktesting');
    expect(AppRouteNames.sc126BotStrategyCompare, 'sc126BotStrategyCompare');
    expect(AppRouteNames.sc127BotOptimization, 'sc127BotOptimization');
    expect(
      AppRouteNames.sc128BotPortfolioDashboard,
      'sc128BotPortfolioDashboard',
    );
    expect(AppRouteNames.sc129BotDrawdownAnalyzer, 'sc129BotDrawdownAnalyzer');
    expect(AppRouteNames.sc130BotEquityCurve, 'sc130BotEquityCurve');
    expect(AppRouteNames.sc131BotGuide, 'sc131BotGuide');
    expect(AppRouteNames.sc132BotFaq, 'sc132BotFaq');
    expect(AppRouteNames.sc133BotTaxReporting, 'sc133BotTaxReporting');
    expect(AppRouteNames.sc134BotApiDocumentation, 'sc134BotApiDocumentation');
    expect(AppRouteNames.sc135Wallet, 'sc135Wallet');
    expect(AppRouteNames.sc136TxHistory, 'sc136TxHistory');
    expect(AppRouteNames.sc137Deposit, 'sc137Deposit');
    expect(AppRouteNames.sc138DepositUsdt, 'sc138DepositUsdt');
    expect(AppRouteNames.sc139Withdraw, 'sc139Withdraw');
    expect(AppRouteNames.sc140WithdrawUsdt, 'sc140WithdrawUsdt');
    expect(AppRouteNames.sc141TransactionDetail, 'sc141TransactionDetail');
    expect(AppRouteNames.sc142PortfolioAnalytics, 'sc142PortfolioAnalytics');
    expect(AppRouteNames.sc143AddressAdd, 'sc143AddressAdd');
    expect(AppRouteNames.sc144AddressBook, 'sc144AddressBook');
    expect(AppRouteNames.sc145BuyCrypto, 'sc145BuyCrypto');
    expect(AppRouteNames.sc146Transfer, 'sc146Transfer');
    expect(AppRouteNames.sc147AssetDetail, 'sc147AssetDetail');
    expect(AppRouteNames.sc148MultiManager, 'sc148MultiManager');
    expect(AppRouteNames.sc149GasOptimizer, 'sc149GasOptimizer');
    expect(AppRouteNames.sc150TokenApproval, 'sc150TokenApproval');
    expect(AppRouteNames.sc151HealthScore, 'sc151HealthScore');
    expect(AppRouteNames.sc152PendingDeposits, 'sc152PendingDeposits');
    expect(AppRouteNames.sc153WithdrawLimits, 'sc153WithdrawLimits');
    expect(AppRouteNames.sc154DustConverter, 'sc154DustConverter');
    expect(AppRouteNames.sc155NetworkStatus, 'sc155NetworkStatus');
    expect(AppRouteNames.sc156Profile, 'sc156Profile');
    expect(AppRouteNames.sc157EditProfile, 'sc157EditProfile');
    expect(AppRouteNames.sc158Security, 'sc158Security');
    expect(AppRouteNames.sc159Kyc, 'sc159Kyc');
    expect(AppRouteNames.sc160Settings, 'sc160Settings');
    expect(AppRouteNames.sc161ActivityLog, 'sc161ActivityLog');
    expect(AppRouteNames.sc162ApiKeyCreate, 'sc162ApiKeyCreate');
    expect(AppRouteNames.sc163ApiManagement, 'sc163ApiManagement');
    expect(AppRouteNames.sc164Vip, 'sc164Vip');
    expect(AppRouteNames.sc165DeviceManagement, 'sc165DeviceManagement');
    expect(AppRouteNames.sc166SubAccount, 'sc166SubAccount');
    expect(AppRouteNames.sc167ProfilePredictions, 'sc167ProfilePredictions');
    expect(AppRouteNames.sc168MyArena, 'sc168MyArena');
    expect(AppRouteNames.sc169Dca, 'sc169Dca');
    expect(AppRouteNames.sc170DcaRebalanceConfig, 'sc170DcaRebalanceConfig');
    expect(
      AppRouteNames.sc171DcaRebalanceDashboard,
      'sc171DcaRebalanceDashboard',
    );
    expect(AppRouteNames.sc172DcaScheduleConfig, 'sc172DcaScheduleConfig');
    expect(
      AppRouteNames.sc173DcaScheduleAnalytics,
      'sc173DcaScheduleAnalytics',
    );
    expect(
      AppRouteNames.sc174DcaPortfolioOptimizer,
      'sc174DcaPortfolioOptimizer',
    );
    expect(AppRouteNames.sc175DcaDynamicAmount, 'sc175DcaDynamicAmount');
    expect(AppRouteNames.sc176DcaBacktester, 'sc176DcaBacktester');
    expect(AppRouteNames.sc177DcaMultiAsset, 'sc177DcaMultiAsset');
    expect(
      AppRouteNames.sc178DcaPerformanceCompare,
      'sc178DcaPerformanceCompare',
    );
    expect(AppRouteNames.sc179DcaSmartRules, 'sc179DcaSmartRules');
    expect(AppRouteNames.sc180AdminHome, 'sc180AdminHome');
    expect(AppRouteNames.sc181AnalyticsDashboard, 'sc181AnalyticsDashboard');
    expect(AppRouteNames.sc182AbTestDashboard, 'sc182AbTestDashboard');
    expect(AppRouteNames.sc183FunnelDashboard, 'sc183FunnelDashboard');
    expect(AppRouteNames.sc184ArenaHome, 'sc184ArenaHome');
    expect(AppRouteNames.sc185ArenaStudio, 'sc185ArenaStudio');
    expect(AppRouteNames.sc186ArenaSmartRules, 'sc186ArenaSmartRules');
    expect(AppRouteNames.sc187ArenaPresetLibrary, 'sc187ArenaPresetLibrary');
    expect(AppRouteNames.sc188ArenaGovernanceGate, 'sc188ArenaGovernanceGate');
    expect(AppRouteNames.sc201ArenaPointsLedger, 'sc201ArenaPointsLedger');
    expect(AppRouteNames.sc202ArenaReportCase, 'sc202ArenaReportCase');
    expect(AppRouteNames.sc203ArenaBlockedUsers, 'sc203ArenaBlockedUsers');
    expect(AppRouteNames.sc204MyArenaReports, 'sc204MyArenaReports');
    expect(AppRouteNames.sc205MyArena, 'sc205MyArena');
    expect(
      AppRouteNames.sc206ArenaProductionReady,
      'sc206ArenaProductionReady',
    );
    expect(
      AppRouteNames.sc207ArenaPredictionBridgeFoundation,
      'sc207ArenaPredictionBridgeFoundation',
    );
    expect(
      AppRouteNames.sc208ConnectedEcosystemProduction,
      'sc208ConnectedEcosystemProduction',
    );
    expect(AppRouteNames.sc209ArenaGuide, 'sc209ArenaGuide');
    expect(AppRouteNames.sc210P2PExpressConfirm, 'sc210P2PExpressConfirm');
    expect(AppRouteNames.sc211P2PExpress, 'sc211P2PExpress');
    expect(AppRouteNames.sc212P2POrderTimeline, 'sc212P2POrderTimeline');
    expect(AppRouteNames.sc213P2POrderRate, 'sc213P2POrderRate');
    expect(AppRouteNames.sc214P2POrderCancel, 'sc214P2POrderCancel');
    expect(AppRouteNames.sc215P2POrderProof, 'sc215P2POrderProof');
    expect(AppRouteNames.sc216P2POrder, 'sc216P2POrder');
    expect(AppRouteNames.sc217P2PChat, 'sc217P2PChat');
    expect(AppRouteNames.sc218P2PDisputeDetail, 'sc218P2PDisputeDetail');
    expect(AppRouteNames.sc219P2PDisputeEvidence, 'sc219P2PDisputeEvidence');
    expect(
      AppRouteNames.sc220P2PDisputeResolution,
      'sc220P2PDisputeResolution',
    );
    expect(AppRouteNames.sc221P2PDispute, 'sc221P2PDispute');
    expect(AppRouteNames.sc222P2PDisputes, 'sc222P2PDisputes');
    expect(AppRouteNames.sc223P2PAdAnalytics, 'sc223P2PAdAnalytics');
    expect(AppRouteNames.sc224P2PAdDetail, 'sc224P2PAdDetail');
    expect(AppRouteNames.sc225P2PMyAds, 'sc225P2PMyAds');
    expect(AppRouteNames.sc226P2PCreateAd, 'sc226P2PCreateAd');
    expect(AppRouteNames.sc227P2PMerchantApply, 'sc227P2PMerchantApply');
    expect(AppRouteNames.sc228P2PMerchantProfile, 'sc228P2PMerchantProfile');
    expect(AppRouteNames.sc229P2PReportMerchant, 'sc229P2PReportMerchant');
    expect(AppRouteNames.sc230P2PTradingLevel, 'sc230P2PTradingLevel');
    expect(AppRouteNames.sc250P2PAddressProof, 'sc250P2PAddressProof');
    expect(
      AppRouteNames.sc251P2PSelfieVerification,
      'sc251P2PSelfieVerification',
    );
    expect(
      AppRouteNames.sc252P2PVideoVerification,
      'sc252P2PVideoVerification',
    );
    expect(AppRouteNames.sc253P2PSecurityCenter, 'sc253P2PSecurityCenter');
    expect(AppRouteNames.sc254P2P2FASettings, 'sc254P2P2FASettings');
    expect(AppRouteNames.sc255P2PDeviceManagement, 'sc255P2PDeviceManagement');
    expect(AppRouteNames.sc256P2PAntiPhishingCode, 'sc256P2PAntiPhishingCode');
    expect(AppRouteNames.sc257P2PLoginHistory, 'sc257P2PLoginHistory');
    expect(
      AppRouteNames.sc258P2PSuspiciousActivity,
      'sc258P2PSuspiciousActivity',
    );
    expect(AppRouteNames.sc259P2PE2EInfo, 'sc259P2PE2EInfo');
    expect(AppRouteNames.sc260P2PFraudPrevention, 'sc260P2PFraudPrevention');
    expect(AppRouteNames.sc261P2PWalletTransfer, 'sc261P2PWalletTransfer');
    expect(AppRouteNames.sc262P2PFundLockHistory, 'sc262P2PFundLockHistory');
    expect(
      AppRouteNames.sc263P2PWalletHistoryAlias,
      'sc263P2PWalletHistoryAlias',
    );
  });
}
