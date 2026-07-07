// Smoke test for MockTradeRepository: exercises every method on the
// TradeRepository interface against the mock implementation and asserts
// each call succeeds (doesn't throw) and returns a plausible result.
//
// This complements the existing page/controller tests (which each exercise
// 1-2 methods indirectly) by providing direct, centralized coverage of the
// mock repository itself.
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/trade/data/trade_repository.dart';

void main() {
  const repo = MockTradeRepository();

  group('MockTradeRepository smoke test', () {
    group('core trading getters', () {
      test('getTrade / getOrdersHistory / getOrderReceipt', () {
        expect(repo.getTrade(), isA<TradeScreenSnapshot>());
        expect(repo.getTrade(pairId: 'ethusdt'), isA<TradeScreenSnapshot>());
        expect(repo.getOrdersHistory(), isA<TradeOrdersHistorySnapshot>());
        expect(repo.getOrderReceipt(), isA<TradeOrderReceiptSnapshot>());
      });

      test('getTradeSettings / getTradePositions / getTradeExport', () {
        expect(repo.getTradeSettings(), isA<TradeSettingsSnapshot>());
        final positions = repo.getTradePositions();
        expect(positions, isA<TradePositionsSnapshot>());
        expect(positions.positions, hasLength(6));
        expect(repo.getTradeExport(), isA<TradeExportSnapshot>());
      });

      test(
        'getAdvancedChart / getConvert / getFutures / getFuturesLeverage',
        () {
          expect(repo.getAdvancedChart(), isA<TradeAdvancedChartSnapshot>());
          expect(
            repo.getAdvancedChart(pairId: 'ethusdt'),
            isA<TradeAdvancedChartSnapshot>(),
          );
          expect(repo.getConvert(), isA<TradeConvertSnapshot>());
          final futures = repo.getFutures();
          expect(futures, isA<TradeFuturesSnapshot>());
          expect(futures.positions, hasLength(2));
          expect(
            repo.getFutures(pairId: 'ethusdt'),
            isA<TradeFuturesSnapshot>(),
          );
          expect(
            repo.getFuturesLeverage(),
            isA<TradeFuturesLeverageSnapshot>(),
          );
          expect(
            repo.getFuturesLeverage(pairId: 'ethusdt'),
            isA<TradeFuturesLeverageSnapshot>(),
          );
        },
      );

      test(
        'getTradingBots / getRiskManagement / getExecutionQuality / getAdvancedTools',
        () {
          final bots = repo.getTradingBots();
          expect(bots, isA<TradeBotsSnapshot>());
          expect(bots.activeBots, hasLength(3));
          expect(repo.getRiskManagement(), isA<TradeRiskManagementSnapshot>());
          expect(
            repo.getExecutionQuality(),
            isA<TradeExecutionQualitySnapshot>(),
          );
          expect(repo.getAdvancedTools(), isA<TradeAdvancedToolsSnapshot>());
        },
      );

      test('getMarginTrading / getTraderProfile / getAdvancedTradingDemo', () {
        expect(repo.getMarginTrading(), isA<TradeMarginTradingSnapshot>());
        expect(
          repo.getMarginTrading(pairId: 'ethusdt', pairRouteVariant: true),
          isA<TradeMarginTradingSnapshot>(),
        );
        expect(repo.getTraderProfile(), isA<TradeTraderProfileSnapshot>());
        expect(
          repo.getTraderProfile(traderId: 'trader002'),
          isA<TradeTraderProfileSnapshot>(),
        );
        expect(
          repo.getAdvancedTradingDemo(),
          isA<TradeAdvancedTradingDemoSnapshot>(),
        );
      });
    });

    group('copy trading getters', () {
      test(
        'getCopyTrading / getCopyTradingV2 / getCopyCardDemo / getCopyEducation',
        () {
          expect(repo.getCopyTrading(), isA<TradeCopyTradingSnapshot>());
          expect(repo.getCopyTradingV2(), isA<TradeCopyTradingV2Snapshot>());
          expect(repo.getCopyCardDemo(), isA<TradeCopyCardDemoSnapshot>());
          expect(repo.getCopyEducation(), isA<TradeCopyEducationSnapshot>());
        },
      );

      test('getActiveCopies / getCopySettings / getCopyNotifications', () {
        expect(repo.getActiveCopies(), isA<TradeActiveCopiesSnapshot>());
        expect(repo.getCopySettings(), isA<TradeCopySettingsSnapshot>());
        expect(
          repo.getCopyNotifications(),
          isA<TradeCopyNotificationsSnapshot>(),
        );
      });

      test(
        'getProviderApplication / getCopyProviderDetail / getPreCopyAssessment',
        () {
          expect(
            repo.getProviderApplication(),
            isA<TradeProviderApplicationSnapshot>(),
          );
          expect(
            repo.getCopyProviderDetail(),
            isA<TradeCopyProviderDetailSnapshot>(),
          );
          expect(
            repo.getCopyProviderDetail(providerId: 'provider002'),
            isA<TradeCopyProviderDetailSnapshot>(),
          );
          expect(
            repo.getPreCopyAssessment(),
            isA<TradePreCopyAssessmentSnapshot>(),
          );
          expect(
            repo.getPreCopyAssessment(providerId: 'provider002'),
            isA<TradePreCopyAssessmentSnapshot>(),
          );
        },
      );

      test(
        'getCopyConfiguration / getCopyConfirmation / getCopyPerformance',
        () {
          expect(
            repo.getCopyConfiguration(),
            isA<TradeCopyConfigurationSnapshot>(),
          );
          expect(
            repo.getCopyConfiguration(providerId: 'provider002'),
            isA<TradeCopyConfigurationSnapshot>(),
          );
          expect(
            repo.getCopyConfirmation(),
            isA<TradeCopyConfirmationSnapshot>(),
          );
          expect(
            repo.getCopyConfirmation(providerId: 'provider002'),
            isA<TradeCopyConfirmationSnapshot>(),
          );
          expect(
            repo.getCopyPerformance(),
            isA<TradeCopyPerformanceSnapshot>(),
          );
          expect(
            repo.getCopyPerformance(copyId: 'copy002'),
            isA<TradeCopyPerformanceSnapshot>(),
          );
        },
      );

      test(
        'getPerformanceAttribution / getProviderComparison / getCopyAuditLog',
        () {
          expect(
            repo.getPerformanceAttribution(),
            isA<TradePerformanceAttributionSnapshot>(),
          );
          expect(
            repo.getPerformanceAttribution(copyId: 'copy002'),
            isA<TradePerformanceAttributionSnapshot>(),
          );
          expect(
            repo.getProviderComparison(),
            isA<TradeProviderComparisonSnapshot>(),
          );
          expect(repo.getCopyAuditLog(), isA<TradeCopyAuditLogSnapshot>());
          expect(
            repo.getCopyAuditLog(copyId: 'copy002'),
            isA<TradeCopyAuditLogSnapshot>(),
          );
        },
      );

      test(
        'getPortfolioRiskAnalysis / getProviderLeaderboard / getSafetyEducation',
        () {
          expect(
            repo.getPortfolioRiskAnalysis(),
            isA<TradePortfolioRiskAnalysisSnapshot>(),
          );
          expect(
            repo.getProviderLeaderboard(),
            isA<TradeProviderLeaderboardSnapshot>(),
          );
          expect(
            repo.getSafetyEducation(),
            isA<TradeSafetyEducationSnapshot>(),
          );
        },
      );

      test(
        'getProviderGovernance / getDisputeResolution / getCopySafetyCenter',
        () {
          expect(
            repo.getProviderGovernance(),
            isA<TradeProviderGovernanceSnapshot>(),
          );
          expect(
            repo.getDisputeResolution(),
            isA<TradeDisputeResolutionSnapshot>(),
          );
          expect(
            repo.getCopySafetyCenter(),
            isA<TradeCopySafetyCenterSnapshot>(),
          );
        },
      );
    });

    group('regulatory / compliance getters', () {
      test(
        'getRegulatoryDisclosures / getMarketDataAnalytics / getMarginTradingHub',
        () {
          expect(
            repo.getRegulatoryDisclosures(),
            isA<TradeRegulatoryDisclosuresSnapshot>(),
          );
          expect(
            repo.getMarketDataAnalytics(),
            isA<TradeMarketDataAnalyticsSnapshot>(),
          );
          expect(
            repo.getMarginTradingHub(),
            isA<TradeMarginTradingHubSnapshot>(),
          );
          expect(
            repo.getLiveMarketDataAnalytics(),
            isA<TradeMarketDataAnalyticsSnapshot>(),
          );
          expect(
            repo.getAdvancedAnalytics(),
            isA<TradeAdvancedAnalyticsSnapshot>(),
          );
        },
      );

      test(
        'getTransactionReporting / getRegulatoryReportsDashboard / getArmIntegrationStatus',
        () {
          expect(
            repo.getTransactionReporting(),
            isA<TradeTransactionReportingSnapshot>(),
          );
          expect(
            repo.getRegulatoryReportsDashboard(),
            isA<TradeRegulatoryReportsDashboardSnapshot>(),
          );
          expect(
            repo.getArmIntegrationStatus(),
            isA<TradeArmIntegrationStatusSnapshot>(),
          );
        },
      );

      test(
        'getBestExecutionReports / getExecutionVenueAnalysis / getSlippageMonitoring',
        () {
          expect(
            repo.getBestExecutionReports(),
            isA<TradeBestExecutionReportsSnapshot>(),
          );
          expect(
            repo.getExecutionVenueAnalysis(),
            isA<TradeExecutionVenueAnalysisSnapshot>(),
          );
          expect(
            repo.getSlippageMonitoring(),
            isA<TradeSlippageMonitoringSnapshot>(),
          );
        },
      );

      test(
        'getClientCategorization / getProductGovernance / getTargetMarketDefinition',
        () {
          expect(
            repo.getClientCategorization(),
            isA<TradeClientCategorizationSnapshot>(),
          );
          expect(
            repo.getProductGovernance(),
            isA<TradeProductGovernanceSnapshot>(),
          );
          expect(
            repo.getTargetMarketDefinition(),
            isA<TradeTargetMarketDefinitionSnapshot>(),
          );
          expect(
            repo.getTargetMarketDefinition(productId: 'prod-2'),
            isA<TradeTargetMarketDefinitionSnapshot>(),
          );
        },
      );

      test(
        'getClientMoneyProtection / getCassReconciliation / getInvestorCompensation',
        () {
          expect(
            repo.getClientMoneyProtection(),
            isA<TradeClientMoneyProtectionSnapshot>(),
          );
          expect(
            repo.getCassReconciliation(),
            isA<TradeCassReconciliationSnapshot>(),
          );
          expect(
            repo.getInvestorCompensation(),
            isA<TradeInvestorCompensationSnapshot>(),
          );
        },
      );

      test(
        'getExAnteCosts / getRiyCalculator / getExPostCostsReport / getKidGenerator',
        () {
          expect(repo.getExAnteCosts(), isA<TradeExAnteCostsSnapshot>());
          expect(repo.getRiyCalculator(), isA<TradeRiyCalculatorSnapshot>());
          expect(
            repo.getExPostCostsReport(),
            isA<TradeExPostCostsReportSnapshot>(),
          );
          expect(repo.getKidGenerator(), isA<TradeKidGeneratorSnapshot>());
        },
      );

      test(
        'getPerformanceScenarios / getRiskIndicatorExplainer / getComplaintsHandling',
        () {
          expect(
            repo.getPerformanceScenarios(),
            isA<TradePerformanceScenariosSnapshot>(),
          );
          expect(
            repo.getRiskIndicatorExplainer(),
            isA<TradeRiskIndicatorSnapshot>(),
          );
          expect(
            repo.getComplaintsHandling(),
            isA<TradeComplaintsHandlingSnapshot>(),
          );
        },
      );

      test(
        'getComplaintSubmission / getComplaintTracking / getOmbudsmanReferral',
        () {
          expect(
            repo.getComplaintSubmission(),
            isA<TradeComplaintSubmissionSnapshot>(),
          );
          expect(
            repo.getComplaintTracking(),
            isA<TradeComplaintTrackingSnapshot>(),
          );
          expect(
            repo.getComplaintTracking(complaintId: 'case-003'),
            isA<TradeComplaintTrackingSnapshot>(),
          );
          expect(
            repo.getOmbudsmanReferral(),
            isA<TradeOmbudsmanReferralSnapshot>(),
          );
        },
      );

      test('getAuditTrail / getRegulatoryInspectionReady', () {
        expect(repo.getAuditTrail(), isA<TradeAuditTrailSnapshot>());
        expect(
          repo.getRegulatoryInspectionReady(),
          isA<TradeRegulatoryInspectionSnapshot>(),
        );
      });
    });

    group('bot getters', () {
      test(
        'getBotTermsOfService / getBotRiskDisclosure / getBotSuitabilityAssessment',
        () {
          expect(repo.getBotTermsOfService(), isA<TradeBotTermsSnapshot>());
          expect(
            repo.getBotRiskDisclosure(),
            isA<TradeBotRiskDisclosureSnapshot>(),
          );
          expect(
            repo.getBotSuitabilityAssessment(),
            isA<TradeBotSuitabilityAssessmentSnapshot>(),
          );
        },
      );

      test(
        'getBotRiskDashboard / getBotEmergencyStop / getBotSecuritySettings',
        () {
          expect(
            repo.getBotRiskDashboard(),
            isA<TradeBotRiskDashboardSnapshot>(),
          );
          expect(
            repo.getBotEmergencyStop(),
            isA<TradeBotEmergencyStopSnapshot>(),
          );
          expect(
            repo.getBotSecuritySettings(),
            isA<TradeBotSecuritySettingsSnapshot>(),
          );
        },
      );

      test(
        'getBotHistory / getBotPerformanceAnalytics / getBotBacktesting',
        () {
          final history = repo.getBotHistory();
          expect(history, isA<TradeBotHistorySnapshot>());
          expect(history.trades, hasLength(7));
          expect(
            repo.getBotPerformanceAnalytics(),
            isA<TradeBotPerformanceAnalyticsSnapshot>(),
          );
          expect(repo.getBotBacktesting(), isA<TradeBotBacktestingSnapshot>());
        },
      );

      test(
        'getBotStrategyCompare / getBotOptimization / getBotPortfolioDashboard',
        () {
          expect(
            repo.getBotStrategyCompare(),
            isA<TradeBotStrategyCompareSnapshot>(),
          );
          expect(
            repo.getBotOptimization(),
            isA<TradeBotOptimizationSnapshot>(),
          );
          expect(
            repo.getBotPortfolioDashboard(),
            isA<TradeBotPortfolioDashboardSnapshot>(),
          );
        },
      );

      test(
        'getBotDrawdownAnalyzer / getBotEquityCurve / getBotGuide / getBotFaq',
        () {
          expect(
            repo.getBotDrawdownAnalyzer(),
            isA<TradeBotDrawdownAnalyzerSnapshot>(),
          );
          expect(repo.getBotEquityCurve(), isA<TradeBotEquityCurveSnapshot>());
          expect(repo.getBotGuide(), isA<TradeBotGuideSnapshot>());
          expect(repo.getBotFaq(), isA<TradeBotFaqSnapshot>());
        },
      );

      test('getBotTaxReporting / getBotApiDocumentation', () {
        expect(repo.getBotTaxReporting(), isA<TradeBotTaxReportingSnapshot>());
        expect(
          repo.getBotApiDocumentation(),
          isA<TradeBotApiDocumentationSnapshot>(),
        );
      });
    });

    group('write / action methods', () {
      test('patchTradeSettings', () {
        final settings = repo.getTradeSettings().settings;
        final result = repo.patchTradeSettings(settings);
        expect(result, isA<TradeSettings>());
        expect(result.defaultOrderType, 'limit');
      });

      test('patchCopySettings', () {
        final snapshot = repo.getCopySettings();
        final updated = snapshot.settings.copyWith(defaultCopyRatio: 60);
        final result = repo.patchCopySettings(updated);
        expect(result, isA<TradeCopySettingsSaveResult>());
        expect(result.status, 'saved');
      });

      test('previewCopyConfiguration', () {
        final found = repo.getCopyConfiguration(providerId: 'provider001');
        final preview = repo.previewCopyConfiguration(found.defaultDraft);
        expect(preview, isA<TradeCopyConfigurationPreview>());
        expect(preview.status, 'ready');
      });

      test('submitCopyConfirmation', () {
        final found = repo.getCopyConfirmation(providerId: 'ct001');
        final accepted = repo.submitCopyConfirmation(
          TradeCopyConfirmationRequest(
            providerId: 'ct001',
            configuration: found.configuration,
            acceptedConsentIds: found.consentItems
                .map((item) => item.id)
                .toList(),
          ),
        );
        expect(accepted, isA<TradeCopyConfirmationResult>());
      });

      test('submitProviderApplication', () {
        final snapshot = repo.getProviderApplication();
        final result = repo.submitProviderApplication(snapshot.defaultDraft);
        expect(result, isA<TradeProviderApplicationResult>());
        expect(result.status, 'submitted');
      });

      test('createCopyAuditExport', () {
        final result = repo.createCopyAuditExport(
          const TradeCopyAuditExportRequest(
            copyId: 'copy001',
            format: 'csv',
            filterId: 'all',
            searchQuery: '',
          ),
        );
        expect(result, isA<TradeCopyAuditExportResult>());
      });

      test('submitDisputeComplaint', () {
        final result = repo.submitDisputeComplaint(
          const TradeDisputeComplaintDraft(
            complaintType: 'execution_issue',
            providerId: 'trader-2',
            subject: 'Excessive slippage',
            description: 'Provider executed at a materially different price.',
          ),
        );
        expect(result, isA<TradeDisputeSubmissionResult>());
        expect(result.status, 'submitted');
      });

      test('createTradeExport', () {
        final result = repo.createTradeExport(
          const TradeExportRequest(
            format: 'csv',
            period: '30d',
            includeIds: ['spot', 'fees'],
          ),
        );
        expect(result, isA<TradeExportResult>());
      });

      test('createBotTaxReportExport', () {
        final result = repo.createBotTaxReportExport(
          const TradeBotTaxReportExportRequest(
            year: '2025',
            reportTypeIds: ['irs-8949', 'turbotax'],
            costBasisMethod: 'FIFO',
          ),
        );
        expect(result, isA<TradeBotTaxReportExportResult>());
      });

      test('createExPostCostsReportExport', () {
        final result = repo.createExPostCostsReportExport();
        expect(result, isA<TradeExPostCostsReportExportResult>());
        expect(
          repo.createExPostCostsReportExport(year: 2024),
          isA<TradeExPostCostsReportExportResult>(),
        );
      });

      test('previewConvert / submitConvert', () {
        const request = TradeConvertRequest(
          fromSymbol: 'USDT',
          toSymbol: 'BTC',
          amount: 500,
          slippagePct: .5,
          mode: 'market',
        );
        expect(repo.previewConvert(request), isA<TradeConvertQuote>());
        expect(repo.submitConvert(request), isA<TradeConvertReceipt>());
      });

      test('previewFuturesOrder / submitFuturesOrder', () {
        const draft = TradeFuturesOrderDraft(
          pairId: 'btcusdt',
          side: TradeFuturesSide.long,
          type: TradeFuturesOrderType.market,
          margin: 500,
          leverage: 10,
        );
        expect(repo.previewFuturesOrder(draft), isA<TradeFuturesPreview>());
        expect(repo.submitFuturesOrder(draft), isA<TradeFuturesReceipt>());
      });

      test('previewFuturesLeverage / submitFuturesLeverage', () {
        expect(
          repo.previewFuturesLeverage(
            const TradeFuturesLeverageRequest(pairId: 'btcusdt', leverage: 10),
          ),
          isA<TradeFuturesLeveragePreview>(),
        );
        expect(
          repo.submitFuturesLeverage(
            const TradeFuturesLeverageRequest(pairId: 'btcusdt', leverage: 50),
          ),
          isA<TradeFuturesLeverageReceipt>(),
        );
      });

      test('submitBotAction / createTradingBot', () {
        final action = repo.submitBotAction(
          const TradeBotActionRequest(botId: 'bot1', action: 'pause'),
        );
        expect(action, isA<TradeBotActionResult>());
        final created = repo.createTradingBot(
          const TradeBotCreateRequest(
            strategyId: 'dca',
            params: {'pair': 'BTC/USDT'},
          ),
        );
        expect(created, isA<TradeBotCreateResult>());
      });

      test('submitBotEmergencyStop', () {
        final result = repo.submitBotEmergencyStop(
          const TradeBotEmergencyStopDraft(
            reasonId: 'crash',
            closePositions: true,
            confirmed: true,
          ),
        );
        expect(result, isA<TradeBotEmergencyStopResult>());
      });

      test('patchBotSecuritySettings', () {
        final result = repo.patchBotSecuritySettings(
          const TradeBotSecuritySettingsDraft(twoFaEnabled: false),
        );
        expect(result, isA<TradeBotSecuritySettingsResult>());
        expect(result.status, 'saved');
      });

      test('createBotHistoryExport', () {
        final export = repo.createBotHistoryExport(
          const TradeBotHistoryExportRequest(format: 'csv'),
        );
        expect(export, isA<TradeBotHistoryExportResult>());
      });

      test('runBotBacktest', () {
        final result = repo.runBotBacktest(
          const TradeBotBacktestRequest(
            strategyId: 'grid',
            pair: 'BTC/USDT',
            dateRangeId: '6m',
            initialCapital: 1000,
          ),
        );
        expect(result, isA<TradeBotBacktestResult>());
      });

      test('runBotOptimization', () {
        final result = repo.runBotOptimization(
          const TradeBotOptimizationRequest(
            targetId: 'sharpe',
            gridCount: 25,
            gridRangePct: 35,
          ),
        );
        expect(result, isA<TradeBotOptimizationResult>());
      });

      test('submitOcoOrder', () {
        final result = repo.submitOcoOrder(
          const TradeOcoOrderDraft(
            symbol: 'BTC/USDT',
            side: TradeOrderSide.buy,
            quantity: .015,
            limitPrice: 69000,
            takeProfitPrice: 72000,
            stopPrice: 66000,
          ),
        );
        expect(result, isA<TradeOcoOrderResult>());
        expect(result.status, isNotEmpty);
      });

      test('calculatePositionSize', () {
        final result = repo.calculatePositionSize(
          const TradePositionSizeRequest(
            accountBalance: 50000,
            riskPct: 1,
            entryPrice: 69000,
            stopPrice: 67500,
          ),
        );
        expect(result, isA<TradePositionSizeResult>());
        expect(result.suggestedAmount, greaterThan(0));
      });

      test('updateSlippageSettings', () {
        final current = repo.getExecutionQuality().slippageSettings;
        final result = repo.updateSlippageSettings(current);
        expect(result, isA<TradeSlippageSettings>());
      });

      test('amendOrder', () {
        final result = repo.amendOrder(
          const TradeOrderAmendmentRequest(
            orderId: 'ord001',
            newPrice: 69000,
            newAmount: .02,
          ),
        );
        expect(result, isA<TradeOrderAmendmentResult>());
        expect(result.queuePositionPreserved, isTrue);
      });

      test('submitAdvancedToolAction', () {
        final result = repo.submitAdvancedToolAction(
          const TradeAdvancedToolActionRequest(
            toolId: 'bulk',
            action: 'cancel',
            orderIds: ['o1', 'o2'],
          ),
        );
        expect(result, isA<TradeAdvancedToolActionResult>());
      });

      test('submitCopyTradingAction', () {
        final result = repo.submitCopyTradingAction(
          const TradeCopyActionRequest(providerId: 'ct001', action: 'follow'),
        );
        expect(result, isA<TradeCopyActionResult>());
      });

      test('previewOrder / submitOrder', () {
        const draft = TradeOrderDraft(
          pairId: 'btcusdt',
          side: TradeOrderSide.buy,
          type: TradeOrderType.limit,
          price: 67543.21,
          amount: .1,
        );
        final preview = repo.previewOrder(draft);
        expect(preview, isA<TradeOrderPreview>());
        expect(preview.total, closeTo(6754.321, .001));
        final receipt = repo.submitOrder(draft);
        expect(receipt, isA<TradeOrderReceipt>());
      });

      test('submitOrderAction', () {
        final result = repo.submitOrderAction(
          orderId: 'ord-open-001',
          action: 'cancel',
        );
        expect(result, isA<TradeOrderActionResult>());
        expect(result.status, 'success');
      });
    });
  });
}
