part of 'app_router.dart';

final class AppRoutePaths {
  const AppRoutePaths._();

  static const String root = '/';
  static const String authLogin = '/auth/login';
  static const String authRegister = '/auth/register';
  static const String authOtp = '/auth/otp';
  static const String auth2faSetup = '/auth/2fa-setup';
  static const String authForgotPassword = '/auth/forgot-password';
  static const String authResetPassword = '/auth/reset-password';
  static const String home = '/home';
  static const String search = '/search';
  static const String topics = '/topics';
  static const String topicCrypto = '/topic/crypto';
  static const String referral = '/referral';
  static const String referralHistory = '/referral/history';
  static const String referralRewards = '/referral/rewards';
  static const String referralRules = '/referral/rules';
  static String referralFriend(String friendId) => '/referral/friend/$friendId';
  static const String enterpriseStates = '/enterprise-states';
  static const String unifiedPortfolio = '/unified-portfolio';
  static const String crossModuleAnalytics = '/cross-module-analytics';
  static const String smartAlerts = '/smart-alerts';
  static const String taxReports = '/tax-reports';
  static const String routeChecker = '/dev/route-checker';
  static const String performanceMonitor = '/dev/performance-monitor';
  static const String devShowcase = '/dev/showcase';
  static const String devDesignSystem = '/dev/design-system';
  static const String devDcaOverview = '/dev/dca-overview';
  static const String demoCopyCard = '/demo/copy-card';
  static const String earn = '/earn';
  static const String earnStaking = '/earn/staking';
  static const String earnStakingTerms = '/earn/staking/terms';
  static const String earnStakingRiskDisclosure =
      '/earn/staking/risk-disclosure';
  static const String earnStakingWithdrawalPolicy =
      '/earn/staking/withdrawal-policy';
  static const String earnStakingTaxGuide = '/earn/staking/tax-guide';
  static const String earnStakingRiskAssessment =
      '/earn/staking/risk-assessment';
  static const String earnDashboard = '/earn/dashboard';
  static const String earnAnalytics = '/earn/analytics';
  static const String earnCalendar = '/earn/calendar';
  static const String earnHistory = '/earn/history';
  static const String earnValidatorSelection = '/earn/validator-selection';
  static const String earnAutoCompound = '/earn/auto-compound';
  static const String earnLiquidStaking = '/earn/liquid-staking';
  static const String earnInsurance = '/earn/insurance';
  static const String earnAdvancedOrders = '/earn/advanced-orders';
  static const String earnMultiChain = '/earn/multi-chain';
  static const String earnInstitutional = '/earn/institutional';
  static const String earnGuide = '/earn/guide';
  static const String earnFAQ = '/earn/faq';
  static const String earnNotifications = '/earn/notifications';
  static const String earnRecommendations = '/earn/recommendations';
  static const String earnRegulatoryFramework = '/earn/regulatory-framework';
  static const String earnAuditReports = '/earn/audit-reports';
  static const String earnCustody = '/earn/custody';
  static const String earnSuitabilityAssessment =
      '/earn/suitability-assessment';
  static const String earnInsuranceFundTransparency =
      '/earn/insurance-fund-transparency';
  static const String earnTransactionReporting = '/earn/transaction-reporting';
  static const String earnApiDocumentation = '/earn/api-documentation';
  static const String earnProofOfReserves = '/earn/proof-of-reserves';
  static const String earnRiskDashboard = '/earn/risk-dashboard';
  static const String earnSlashingHistory = '/earn/slashing-history';
  static const String earnValidatorHealthMonitor =
      '/earn/validator-health-monitor';
  static const String earnRiskScoreCalculator = '/earn/risk-score-calculator';
  static const String earnEmergencyActions = '/earn/emergency-actions';
  static const String earnContingencyPlan = '/earn/contingency-plan';
  static const String earnSocialFeed = '/earn/social-feed';
  static const String earnCommunityGovernance = '/earn/community-governance';
  static const String earnProposals = '/earn/proposals';
  static const String earnVoting = '/earn/voting';
  static String earnVotingProposal(String proposalId) =>
      '/earn/voting/$proposalId';
  static const String earnVotingProposalRoute = '/earn/voting/:proposalId';
  static const String earnForum = '/earn/forum';
  static const String earnWebhooks = '/earn/webhooks';
  static const String earnDataExport = '/earn/data-export';
  static const String earnThirdPartyIntegrations =
      '/earn/third-party-integrations';
  static const String earnDeveloperConsole = '/earn/developer-console';
  static const String earnSavings = '/earn/savings';
  static const String earnSavingsPortfolio = '/earn/savings/portfolio';
  static const String earnSavingsHistory = '/earn/savings/history';
  static const String earnSavingsGuide = '/earn/savings/guide';
  static const String earnSavingsFAQ = '/earn/savings/faq';
  static const String earnSavingsNotifications = '/earn/savings/notifications';
  static const String earnSavingsRecommendations =
      '/earn/savings/recommendations';
  static const String earnSavingsRiskAssessment =
      '/earn/savings/risk-assessment';
  static const String earnSavingsComparison = '/earn/savings/comparison';
  static const String earnSavingsAutoCompound = '/earn/savings/auto-compound';
  static const String earnSavingsGoals = '/earn/savings/goals';
  static const String earnSavingsAnalytics = '/earn/savings/analytics';
  static const String earnSavingsRebalance = '/earn/savings/rebalance';
  static const String earnSavingsNotificationPreferences =
      '/earn/savings/notification-preferences';
  static const String earnSavingsDca = '/earn/savings/dca';
  static const String earnSavingsSmartSuggestions =
      '/earn/savings/smart-suggestions';
  static const String earnSavingsExport = '/earn/savings/export';
  static const String earnSavingsBacktest = '/earn/savings/backtest';
  static const String earnSavingsAutoPilot = '/earn/savings/autopilot';
  static const String earnSavingsLadder = '/earn/savings/ladder';
  static const String earnSavingsWhatIf = '/earn/savings/whatif';
  static const String earnSavingsProductSample = '/earn/savings/product/sample';
  static const String earnSavingsRedeemPos001 = '/earn/savings/redeem/pos001';
  static const String earnSavingsReceipt = '/earn/savings/receipt';
  static const String notifications = '/notifications';
  static const String support = '/support';
  static const String supportAnnouncements = '/support/announcements';
  static const String launchpad = '/launchpad';
  static const String launchpadPortfolio = '/launchpad/portfolio';
  static const String launchpadPerformance = '/launchpad/performance';
  static const String launchpadStaking = '/launchpad/staking';
  static const String launchpadBatchClaim = '/launchpad/batch-claim';
  static const String launchpadClaimReceiptPos001 =
      '/launchpad/claim-receipt/pos001';
  static const String launchpadIdoBridgeSample = '/launchpad/idobridge/sample';
  static const String launchpadBridgeCompare = '/launchpad/bridge-compare';
  static const String launchpadBridgeOrderTx001 =
      '/launchpad/bridge-order/tx001';
  static const String launchpadContractSample = '/launchpad/contract/sample';
  static const String launchpadReceiptSub001 = '/launchpad/receipt/sub001';
  static const String launchpadSample = '/launchpad/sample';
  static const String launchpadNotifSound = '/launchpad/notif-sound';
  static const String launchpadEventLog = '/launchpad/event-log';
  static const String launchpadAbiDiff = '/launchpad/abi-diff/contract001';
  static const String launchpadAddressBook = '/launchpad/address-book';
  static const String launchpadWebhooks = '/launchpad/webhooks';
  static const String launchpadGasTracker = '/launchpad/gas-tracker';
  static const String launchpadRebalance = '/launchpad/rebalance';
  static const String launchpadMultisig = '/launchpad/multisig';
  static const String launchpadSwapAggregator = '/launchpad/swap-aggregator';
  static const String launchpadLimitOrders = '/launchpad/limit-orders';
  static const String launchpadDcaBuilder = '/launchpad/dca-builder';
  static const String launchpadRiskAnalytics = '/launchpad/risk-analytics';
  static const String news = '/news';
  static const String markets = '/markets';
  static const String marketsOverview = '/markets/overview';
  static const String marketsMovers = '/markets/movers';
  static const String marketsSectors = '/markets/sectors';
  static const String marketsWatchlist = '/markets/watchlist';
  static const String marketsHeatmap = '/markets/heatmap';
  static const String marketsAlerts = '/markets/alerts';
  static const String marketsScreener = '/markets/screener';
  static const String marketsCompare = '/markets/compare';
  static const String marketsCalendar = '/markets/calendar';
  static const String marketsDerivatives = '/markets/derivatives';
  static const String marketsDepth = '/markets/depth';
  static const String marketsSocialSentiment = '/markets/social-sentiment';
  static const String marketsPortfolioTracker = '/markets/portfolio-tracker';
  static const String marketsNews = '/markets/news';
  static const String marketsAdvancedCharts = '/markets/advanced-charts';
  static const String marketsUnlocks = '/markets/unlocks';
  static const String marketsSignals = '/markets/signals';
  static const String marketsCorrelations = '/markets/correlations';
  static const String marketsPredictions = '/markets/predictions';
  static const String marketsPredictionsSearch = '/markets/predictions/search';
  static const String marketsPredictionsBreaking =
      '/markets/predictions/breaking';
  static const String marketsPredictionsPortfolio =
      '/markets/predictions/portfolio';
  static String marketsPredictionEvent(String eventId) =>
      '/markets/predictions/event/$eventId';
  static String marketsPredictionReceipt(String receiptId) =>
      '/markets/predictions/receipt/$receiptId';
  static const String marketsPredictionsRewards =
      '/markets/predictions/rewards';
  static const String marketsPredictionsLeaderboard =
      '/markets/predictions/leaderboard';
  static const String marketsPredictionsActivity =
      '/markets/predictions/activity';
  static const String marketsPredictionsRiskCalculator =
      '/markets/predictions/risk-calculator';
  static const String marketsPredictionsMarketMaker =
      '/markets/predictions/market-maker';
  static const String marketsPredictionsPortfolioAnalyzer =
      '/markets/predictions/portfolio-analyzer';
  static const String marketsPredictionsEventCalendar =
      '/markets/predictions/event-calendar';
  static const String marketsPredictionsSocial = '/markets/predictions/social';
  static String marketsPredictionsAdvancedChart(String eventId) =>
      '/markets/predictions/advanced-chart/$eventId';
  static const String marketsPredictionsTournaments =
      '/markets/predictions/tournaments';
  static String marketsPredictionTournament(String tournamentId) =>
      '/markets/predictions/tournament/$tournamentId';
  static const String marketsPredictionsDataIntegration =
      '/markets/predictions/data-integration';
  static String pairDetail(String pairId) => '/pair/$pairId';
  static String pairInfo(String pairId) => '/pair/$pairId/info';
  static String pairDepth(String pairId) => '/pair/$pairId/depth';
  static String tradeAdvancedChart(String pairId) =>
      '/trade/advanced-chart/$pairId';
  static String tradePair(String pairId) => '/trade/$pairId';
  static String tradeFutures(String pairId) => '/trade/$pairId/futures';
  static String tradeFuturesLeverage(String pairId) =>
      '/trade/$pairId/futures/leverage';
  static const String tradeOrderReceipt = '/trade/order-receipt';
  static const String tradeOrdersHistory = '/trade/orders-history';
  static const String tradeSettings = '/trade/settings';
  static const String tradePositions = '/trade/positions';
  static const String tradeExport = '/trade/export';
  static const String tradeConvert = '/trade/convert';
  static const String tradeBots = '/trade/bots';
  static const String tradeBotTermsOfService = '/trade/bots/terms-of-service';
  static const String tradeBotRiskDisclosure = '/trade/bots/risk-disclosure';
  static const String tradeBotSuitabilityAssessment =
      '/trade/bots/suitability-assessment';
  static const String tradeBotRiskDashboard = '/trade/bots/risk-dashboard';
  static const String tradeBotEmergencyStop = '/trade/bots/emergency-stop';
  static const String tradeBotSecuritySettings =
      '/trade/bots/security-settings';
  static const String tradeBotHistory = '/trade/bots/history';
  static const String tradeBotPerformanceAnalytics =
      '/trade/bots/performance-analytics';
  static const String tradeBotBacktesting = '/trade/bots/backtesting';
  static const String tradeBotStrategyCompare = '/trade/bots/strategy-compare';
  static const String tradeBotOptimization = '/trade/bots/optimization';
  static const String tradeBotPortfolioDashboard =
      '/trade/bots/portfolio-dashboard';
  static const String tradeBotDrawdownAnalyzer =
      '/trade/bots/drawdown-analyzer';
  static const String tradeBotEquityCurve = '/trade/bots/equity-curve';
  static const String tradeBotGuide = '/trade/bots/guide';
  static const String tradeBotFaq = '/trade/bots/faq';
  static const String tradeBotTaxReporting = '/trade/bots/tax-reporting';
  static const String tradeBotApiDocumentation =
      '/trade/bots/api-documentation';
  static const String tradeRiskManagement = '/trade/risk-management';
  static const String tradeExecutionQuality = '/trade/execution-quality';
  static const String tradeAdvancedTools = '/trade/advanced-tools';
  static const String tradeCopyTrading = '/trade/copy-trading';
  static const String tradeCopyEducation = '/trade/copy-trading/education';
  static const String tradeCopyActive = '/trade/copy-trading/active';
  static const String tradeCopySettings = '/trade/copy-trading/settings';
  static const String tradeCopyNotifications =
      '/trade/copy-trading/notifications';
  static const String tradeCopyComparison = '/trade/copy-trading/comparison';
  static const String tradeCopyProviderApply = '/trade/copy-provider-apply';
  static String tradeCopyProvider(String providerId, {String? backPath}) {
    final path = '/trade/copy-provider/$providerId';
    if (backPath == null || backPath.isEmpty) return path;
    return '$path?back=${Uri.encodeComponent(backPath)}';
  }

  static String tradeCopyProviderAssessment(String providerId) =>
      '/trade/copy-provider/$providerId/assessment';

  static String tradeCopyProviderConfiguration(
    String providerId, {
    String? backPath,
  }) {
    final path = '/trade/copy-provider/$providerId/configuration';
    if (backPath == null || backPath.isEmpty) return path;
    return '$path?back=${Uri.encodeComponent(backPath)}';
  }

  static String tradeCopyProviderConfirmation(String providerId) =>
      '/trade/copy-provider/$providerId/confirmation';

  static String tradeCopyPerformance(String copyId) =>
      '/trade/copy-performance/$copyId';

  static String tradeCopyPerformanceAttribution(String copyId) =>
      '/trade/copy-performance/$copyId/attribution';

  static String tradeCopyAuditLog(String copyId) =>
      '/trade/copy-audit-log/$copyId';

  static const String tradeCopyRiskAnalysis =
      '/trade/copy-trading/risk-analysis';
  static const String tradeCopyLeaderboard = '/trade/copy-trading/leaderboard';
  static const String tradeCopySafety = '/trade/copy-trading/safety';
  static const String tradeCopyProviderGovernance =
      '/trade/copy-provider-governance';
  static const String tradeCopyDisputeResolution =
      '/trade/copy-dispute-resolution';
  static const String tradeCopySafetyCenter = '/trade/copy-safety-center';
  static const String tradeCopyRegulatoryDisclosures =
      '/trade/copy-regulatory-disclosures';
  static const String tradeCopyTransactionReporting =
      '/trade/copy-trading/transaction-reporting';
  static const String tradeCopyRegulatoryReportsDashboard =
      '/trade/copy-trading/regulatory-reports-dashboard';
  static const String tradeCopyArmIntegrationStatus =
      '/trade/copy-trading/arm-integration-status';
  static const String tradeCopyBestExecutionReports =
      '/trade/copy-trading/best-execution-reports';
  static const String tradeCopyExecutionVenueAnalysis =
      '/trade/copy-trading/execution-venue-analysis';
  static const String tradeCopySlippageMonitoring =
      '/trade/copy-trading/slippage-monitoring';
  static const String tradeCopyClientCategorization =
      '/trade/copy-trading/client-categorization';
  static const String tradeCopyClientOptUpRequest =
      '/trade/copy-trading/client-opt-up-request';
  static const String tradeCopyRegulatoryDisclosuresAlias =
      '/trade/copy-trading/regulatory-disclosures';
  static const String tradeCopyProductGovernance =
      '/trade/copy-trading/product-governance';
  static const String tradeCopyTargetMarketDefinition =
      '/trade/copy-trading/target-market-definition';
  static String tradeCopyTargetMarketDefinitionForProduct(String productId) =>
      '$tradeCopyTargetMarketDefinition/$productId';
  static const String tradeCopyClientMoneyProtection =
      '/trade/copy-trading/client-money-protection';
  static const String tradeCopyCassReconciliation =
      '/trade/copy-trading/cass-reconciliation';
  static const String tradeCopyInvestorCompensation =
      '/trade/copy-trading/investor-compensation';
  static const String tradeCopyExAnteCosts =
      '/trade/copy-trading/ex-ante-costs';
  static const String tradeCopyRiyCalculator =
      '/trade/copy-trading/riy-calculator';
  static const String tradeCopyExPostCostsReport =
      '/trade/copy-trading/ex-post-costs-report';
  static const String tradeCopyKidGenerator =
      '/trade/copy-trading/kid-generator';
  static const String tradeCopyPerformanceScenarios =
      '/trade/copy-trading/performance-scenarios';
  static const String tradeCopyRiskIndicatorExplainer =
      '/trade/copy-trading/risk-indicator-explainer';
  static const String tradeCopyComplaintsHandling =
      '/trade/copy-trading/complaints-handling';
  static const String tradeCopyComplaintSubmission =
      '/trade/copy-trading/complaint-submission';
  static const String tradeCopyComplaintTrackingBase =
      '/trade/copy-trading/complaint-tracking';
  static String tradeCopyComplaintTracking(String complaintId) =>
      '/trade/copy-trading/complaint-tracking/$complaintId';
  static const String tradeCopyOmbudsmanReferral =
      '/trade/copy-trading/ombudsman-referral';
  static const String tradeCopyAuditTrail = '/trade/copy-trading/audit-trail';
  static const String tradeCopyRegulatoryInspectionReady =
      '/trade/copy-trading/regulatory-inspection-ready';
  static const String settingsSecurity = '/settings/security';
  static const String tradeMargin = '/trade/margin';
  static const String tradeMarginBtcusdt = '/trade/margin/btcusdt';
  static const String tradeMarginAdvancedDemo = '/trade/margin/advanced-demo';
  static const String tradeMarginMarketDataAnalytics =
      '/trade/margin/market-data-analytics';
  static const String tradeMarginHub = '/trade/margin/hub';
  static const String tradeMarginLiveMarketDataAnalytics =
      '/trade/margin/live-market-data-analytics';
  static const String tradeMarginAdvancedAnalytics =
      '/trade/margin/advanced-analytics';
  static String tradeTrader(String traderId) => '/trade/trader/$traderId';

  static const String dca = '/dca';
  static const String dcaPortfolioOptimizer = '/dca/portfolio-optimizer';
  static const String dcaDynamicAmount = '/dca/dynamic-amount';
  static const String dcaRebalanceConfig = '/dca/rebalance/config';
  static const String dcaRebalanceDashboard = '/dca/rebalance/config001';
  static String dcaRebalanceEdit(String configId) =>
      '/dca/rebalance/$configId/edit';
  static String dcaRebalanceHistory(String configId) =>
      '/dca/rebalance/$configId/history';
  static const String dcaScheduleConfig = '/dca/schedule/config';
  static const String dcaScheduleAnalytics = '/dca/schedule/config001';
  static const String dcaBacktester = '/dca/backtester';
  static const String dcaMultiAsset = '/dca/multi-asset';
  static const String dcaPerformanceCompare = '/dca/performance-compare';
  static const String dcaSmartRules = '/dca/smart-rules';
  static const String admin = '/admin';
  static const String adminAnalytics = '/admin/analytics';
  static const String adminAbtests = '/admin/abtests';
  static const String adminFunnels = '/admin/funnels';
  static const String adminSettings = '/admin/settings';
  static const String profilePredictions = '/profile/predictions';
  static const String rewards = '/rewards';
  static const String p2p = '/p2p';
  static const String p2pExpress = '/p2p/express';
  static const String p2pExpressConfirm = '/p2p/express/confirm';
  static String p2pOrder(String orderId) => '/p2p/order/$orderId';
  static String p2pOrderTimeline(String orderId) =>
      '/p2p/order/timeline/$orderId';
  static String p2pOrderRate(String orderId) => '/p2p/order/rate/$orderId';
  static String p2pOrderCancel(String orderId) => '/p2p/order/cancel/$orderId';
  static String p2pOrderProof(String orderId) => '/p2p/order/proof/$orderId';
  static String p2pChat(String orderId) => '/p2p/chat/$orderId';
  static String p2pDispute(String orderId) => '/p2p/dispute/$orderId';
  static String p2pDisputeDetail(String disputeId) =>
      '/p2p/dispute/detail/$disputeId';
  static String p2pDisputeEvidence(String disputeId) =>
      '/p2p/dispute/evidence/$disputeId';
  static String p2pDisputeResolution(String disputeId) =>
      '/p2p/dispute/resolution/$disputeId';
  static const String p2pDisputes = '/p2p/disputes';
  static String p2pAdAnalytics(String adId) => '/p2p/ad-analytics/$adId';
  static String p2pAd(String adId) => '/p2p/ad/$adId';
  static const String p2pMyAds = '/p2p/my-ads';
  static const String p2pCreate = '/p2p/create';
  static const String p2pMerchantApply = '/p2p/merchant-apply';
  static const String p2pTradingLevel = '/p2p/trading-level';
  static const String p2pReviews = '/p2p/reviews';
  static const String p2pPaymentMethodAdd = '/p2p/payment-method/add';
  static const String p2pPaymentMethods = '/p2p/payment-methods';
  static String p2pPaymentMethodVerification(String methodId) =>
      '/p2p/payment-method/verification/$methodId';
  static String p2pPaymentMethodOwnership(String methodId) =>
      '/p2p/payment-method/ownership/$methodId';
  static const String p2pPaymentMethodCoolingPeriod =
      '/p2p/payment-method/cooling-period';
  static const String p2pPaymentMethodHistory = '/p2p/payment-method/history';
  static const String p2pInsurance = '/p2p/insurance';
  static const String p2pInsuranceFundAlias = '/p2p/insurance-fund';
  static const String p2pInsuranceCertificate = '/p2p/insurance/certificate';
  static const String p2pInsuranceScore = '/p2p/insurance/score';
  static const String p2pInsurancePolicy = '/p2p/insurance/policy';
  static const String p2pContributionHistory =
      '/p2p/insurance/contribution-history';
  static String p2pClaim(String claimId) => '/p2p/insurance/claim/$claimId';
  static const String p2pEscrowBalance = '/p2p/escrow/balance';
  static String p2pEscrow(String orderId) => '/p2p/escrow/$orderId';
  static const String p2pKycRequirements = '/p2p/kyc/requirements';
  static const String p2pKycVerify = '/p2p/kyc/verify';
  static const String p2pKycStatus = '/p2p/kyc/status';
  static const String p2pKycIdentity = '/p2p/kyc/identity';
  static const String p2pKycAddress = '/p2p/kyc/address';
  static const String p2pKycSelfie = '/p2p/kyc/selfie';
  static const String p2pKycVideo = '/p2p/kyc/video';
  static const String p2pKycFaceMatch = '/p2p/kyc/face-match';
  static const String p2pSecurityCenter = '/p2p/security/center';
  static const String p2pSecurity2fa = '/p2p/security/2fa';
  static const String p2pSecurityDevices = '/p2p/security/devices';
  static const String p2pSecurityAntiPhishing = '/p2p/security/anti-phishing';
  static const String p2pSecurityLoginHistory = '/p2p/security/login-history';
  static const String p2pSecuritySuspiciousActivity =
      '/p2p/security/suspicious-activity';
  static const String p2pSecurityWhitelist = '/p2p/security/whitelist';
  static const String settingsSecurityBiometric =
      '/settings/security/biometric';
  static const String settingsSecurityChangePassword =
      '/settings/security/change-password';
  static String p2pMerchant(String merchantId) => '/p2p/merchant/$merchantId';
  static String p2pReport(String merchantId) => '/p2p/report/$merchantId';
  static const String p2pBlacklist = '/p2p/blacklist';
  static const String p2pBlacklistAdd = '/p2p/blacklist/add';
  static const String p2pGuide = '/p2p/guide';
  static const String p2pSettings = '/p2p/settings';
  static const String p2pSettingsNotifications = '/p2p/settings/notifications';
  static const String p2pE2EInfo = '/p2p/e2e-info';
  static const String p2pFraudPrevention = '/p2p/fraud-prevention';
  static const String p2pWallet = '/p2p/wallet';
  static const String p2pWalletTransfer = '/p2p/wallet/transfer';
  static const String p2pWalletFundLockHistory =
      '/p2p/wallet/fund-lock-history';
  static const String p2pWalletHistory = '/p2p/wallet/history';
  static const String p2pLimits = '/p2p/limits';
  static const String p2pLimitsTracker = '/p2p/limits/tracker';
  static const String p2pComplianceOverview = '/p2p/compliance/overview';
  static const String p2pComplianceAmlScreening =
      '/p2p/compliance/aml-screening';
  static const String p2pComplianceSourceOfFunds =
      '/p2p/compliance/source-of-funds';
  static const String p2pComplianceLargeTransaction =
      '/p2p/compliance/large-transaction';
  static const String p2pComplianceRiskAssessment =
      '/p2p/compliance/risk-assessment';
  static const String p2pTaxReporting = '/p2p/tax-reporting';
  static String p2pTaxReportDetailed(String year) =>
      '/p2p/tax-report/detailed/$year';
  static const String p2pOrderBook = '/p2p/order-book';
  static const String p2pDashboard = '/p2p/dashboard';
  static const String p2pAchievements = '/p2p/achievements';
  static const String p2pMyOrders = '/p2p/my-orders';
  static const String supportHelp = '/support/help';
  static const String arena = '/arena';
  static const String arenaGuide = '/arena/guide';
  static const String arenaStudio = '/arena/studio';
  static const String arenaStudioSmartRules = '/arena/studio/smart-rules';
  static const String arenaStudioPresets = '/arena/studio/presets';
  static const String arenaStudioGovernance = '/arena/studio/governance';
  static const String arenaLeaderboard = '/arena/leaderboard';
  static const String arenaVerified = '/arena/verified';
  static const String arenaPoints = '/arena/points';
  static const String arenaFlowMap = '/arena/flow-map';
  static const String arenaSafety = '/arena/safety';
  static const String arenaBlocked = '/arena/blocked';
  static const String arenaMyReports = '/arena/my-reports';
  static const String arenaMy = '/arena/my';
  static const String arenaProduction = '/arena/production';
  static const String arenaBridge = '/arena/bridge';
  static const String arenaEcosystem = '/arena/ecosystem';
  static String arenaReportCase(String caseId) => '/arena/report/$caseId';
  static String arenaChallenge(String challengeId) =>
      '/arena/challenge/$challengeId';
  static String arenaJoin(String challengeId) => '/arena/join/$challengeId';
  static const String arenaResolution = '/arena/resolution';
  static const String arenaLedger = '/arena/ledger';
  static String arenaLedgerEntry(String entryId) =>
      '/arena/ledger/entry/$entryId';
  static String arenaMode(String modeId) => '/arena/mode/$modeId';
  static String arenaCreator(String creatorId) => '/arena/creator/$creatorId';
  static String arenaTrust(String userId) => '/arena/trust/$userId';
  static const String trade = '/trade';
  static const String wallet = '/wallet';
  static const String walletHistory = '/wallet/history';
  static const String walletDeposit = '/wallet/deposit';
  static String walletDepositAsset(String asset) => '/wallet/deposit/$asset';
  static const String walletWithdraw = '/wallet/withdraw';
  static String walletWithdrawAsset(String asset) => '/wallet/withdraw/$asset';
  static String walletTransaction(String transactionId) =>
      '/wallet/transaction/$transactionId';
  static const String walletPortfolioAnalytics = '/wallet/portfolio-analytics';
  static const String walletAddressBook = '/wallet/address-book';
  static const String walletAddressBookAdd = '/wallet/address-book/add';
  static const String walletBuyCrypto = '/wallet/buy-crypto';
  static const String walletTransfer = '/wallet/transfer';
  static String walletAsset(String assetId) => '/wallet/asset/$assetId';
  static const String walletMultiManager = '/wallet/multi-manager';
  static const String walletGasOptimizer = '/wallet/gas-optimizer';
  static const String walletTokenApproval = '/wallet/token-approval';
  static const String walletHealthScore = '/wallet/health-score';
  static const String walletPendingDeposits = '/wallet/pending-deposits';
  static const String walletLimits = '/wallet/limits';
  static const String walletDustConverter = '/wallet/dust-converter';
  static const String walletNetworkStatus = '/wallet/network-status';
  static const String profile = '/profile';
  static const String profileEdit = '/profile/edit';
  static const String profileKyc = '/profile/kyc';
  static const String profileSecurity = '/profile/security';
  static const String profileVip = '/profile/vip';
  static const String profileApi = '/profile/api';
  static const String profileApiCreate = '/profile/api/create';
  static const String profileDevices = '/profile/devices';
  static const String profileSubAccounts = '/profile/sub-accounts';
  static const String profileSettings = '/profile/settings';
  static const String profileActivity = '/profile/activity';
  static const String profileArena = '/profile/arena';
  static const String onboarding = '/onboarding';
}

const String _initialRouteFromEnvironment = String.fromEnvironment(
  'INITIAL_ROUTE',
);

String get _defaultInitialLocation => _initialRouteFromEnvironment.isEmpty
    ? AppRoutePaths.home
    : _initialRouteFromEnvironment;
