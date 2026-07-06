part of '../repositories/mock_trade_repository.dart';

mixin _MockTradeRepositoryCopyConfigurationMethods on _MockTradeRepositoryBase {
  @override
  TradeCopyConfigurationSnapshot getCopyConfiguration({
    String providerId = 'provider001',
  }) {
    final detail = getCopyProviderDetail(providerId: providerId);
    final defaultDraft = TradeCopyConfigurationDraft(
      providerId: providerId,
      copyCapital: 5000,
      copyMode: TradeCopyConfigurationMode.fixed,
      positionSizing: TradePositionSizingMethod.percentage,
      copyRatio: 50,
      useCustomStopLoss: false,
      customStopLoss: 10,
      useCustomTakeProfit: false,
      customTakeProfit: 20,
      useTrailingStop: false,
      trailingStopPercent: 5,
    );

    return TradeCopyConfigurationSnapshot(
      providerId: providerId,
      provider: detail.provider,
      defaultDraft: defaultDraft,
      totalPortfolio: 25000,
      currentCopyAllocation: 8000,
      availableCapital: 17000,
      feePreview: _copyConfigurationFeePreview(defaultDraft),
      validations: _copyConfigurationValidations(defaultDraft, detail.provider),
      lastUpdatedLabel: 'realtime-refresh',
      supportedStates: const [
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.realtimeRefresh,
      ],
    );
  }

  @override
  TradeCopyConfirmationSnapshot getCopyConfirmation({
    String providerId = 'provider001',
  }) {
    final configuration = getCopyConfiguration(providerId: providerId);
    return TradeCopyConfirmationSnapshot(
      providerId: providerId,
      provider: configuration.provider,
      configuration: configuration.defaultDraft,
      feePreview: configuration.feePreview,
      scenarios: _copyScenarioProjections(
        configuration.defaultDraft,
        configuration.feePreview,
      ),
      maxLossAmount: configuration.defaultDraft.useCustomStopLoss
          ? configuration.defaultDraft.copyCapital *
                configuration.defaultDraft.customStopLoss /
                100
          : configuration.defaultDraft.copyCapital,
      consentItems: _copyConfirmationConsents,
      coolingOffHours: 24,
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
  TradeCopyPerformanceSnapshot getCopyPerformance({String copyId = 'copy001'}) {
    return TradeCopyPerformanceSnapshot(
      copyId: copyId,
      initialCapital: 5000,
      yourReturnPct: 13,
      providerReturnPct: 15.6,
      yourCurrentValue: 5650,
      providerTheoreticalValue: 5780,
      performanceGapPct: 2.6,
      avgSlippagePct: .68,
      providerAvgSlippagePct: .48,
      totalCosts: 290,
      equityCurve: _copyPerformanceEquityCurve,
      slippageBuckets: _copyPerformanceSlippageBuckets,
      costAttribution: _copyPerformanceCostAttribution,
      tradeComparisons: _copyPerformanceTrades,
      metrics: _copyPerformanceMetrics,
      lastUpdatedLabel: 'realtime-refresh',
      supportedStates: const [
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.realtimeRefresh,
      ],
    );
  }

  @override
  TradePerformanceAttributionSnapshot getPerformanceAttribution({
    String copyId = 'copy001',
  }) {
    return TradePerformanceAttributionSnapshot(
      copyId: copyId,
      totalReturnPct: 9.2,
      alphaPct: -4.1,
      beta: 1.15,
      rSquared: .72,
      returns: _performanceAttributionReturns,
      drawdowns: _performanceAttributionDrawdowns,
      monteCarloPaths: _performanceAttributionProjectionPaths,
      correlationPoints: _performanceAttributionCorrelation,
      marketContributionPct: 13.4,
      skillContributionPct: -4.1,
      maxDrawdownPct: -8.7,
      avgDrawdownPct: -3.2,
      medianProjection: 5630,
      worstProjection: 4920,
      bestProjection: 6425,
      lastUpdatedLabel: 'realtime-refresh',
      supportedStates: const [
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.realtimeRefresh,
      ],
    );
  }

  @override
  TradeCopyAuditLogSnapshot getCopyAuditLog({String copyId = 'copy001'}) {
    int countFor(TradeCopyAuditEventType type) =>
        _copyAuditEvents.where((event) => event.type == type).length;

    return TradeCopyAuditLogSnapshot(
      copyId: copyId,
      complianceTitle: 'MiFID II Compliant Audit Trail',
      complianceDescription:
          'Tất cả hành động được ghi log và lưu trữ 5 năm. Bạn có thể export bất cứ lúc nào.',
      tabs: [
        TradeCopyAuditTab(
          id: 'all',
          label: 'Tất cả',
          badge: _copyAuditEvents.length,
        ),
        TradeCopyAuditTab(
          id: 'trade',
          label: 'Trades',
          badge: countFor(TradeCopyAuditEventType.trade),
          type: TradeCopyAuditEventType.trade,
        ),
        TradeCopyAuditTab(
          id: 'config',
          label: 'Config',
          badge: countFor(TradeCopyAuditEventType.config),
          type: TradeCopyAuditEventType.config,
        ),
        TradeCopyAuditTab(
          id: 'risk',
          label: 'Risk',
          badge: countFor(TradeCopyAuditEventType.risk),
          type: TradeCopyAuditEventType.risk,
        ),
        TradeCopyAuditTab(
          id: 'system',
          label: 'System',
          badge: countFor(TradeCopyAuditEventType.system),
          type: TradeCopyAuditEventType.system,
        ),
      ],
      events: _copyAuditEvents,
      exportFormats: _copyAuditExportFormats,
      retentionYears: 5,
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
  TradePortfolioRiskAnalysisSnapshot getPortfolioRiskAnalysis() {
    return const TradePortfolioRiskAnalysisSnapshot(
      totalExposure: 8000,
      var95: -273,
      var99: -424,
      diversificationScore: 93,
      assetExposures: _portfolioRiskAssets,
      riskAlerts: [
        'BTC chiếm 35% (khuyến nghị <30%)',
        'High correlation: CryptoKing ↔ cryptoKing (1.00)',
        'High correlation: SwingMaster ↔ swingMaster (1.00)',
      ],
      tabs: [
        TradePortfolioRiskTab(id: 'exposure', label: 'Exposure'),
        TradePortfolioRiskTab(id: 'correlation', label: 'Correlation'),
        TradePortfolioRiskTab(id: 'var', label: 'VaR'),
        TradePortfolioRiskTab(id: 'scenarios', label: 'Stress Test'),
      ],
      scenarios: _portfolioRiskScenarios,
      lastUpdatedLabel: 'realtime-refresh',
      supportedStates: [
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.realtimeRefresh,
      ],
    );
  }

  @override
  TradeCopyConfigurationPreview previewCopyConfiguration(
    TradeCopyConfigurationDraft draft,
  ) {
    final detail = getCopyProviderDetail(providerId: draft.providerId);
    final validations = _copyConfigurationValidations(draft, detail.provider);
    return TradeCopyConfigurationPreview(
      providerId: draft.providerId,
      status:
          validations.any(
            (item) => item.level == TradeCopyConfigurationValidationLevel.error,
          )
          ? 'blocked'
          : 'ready',
      draft: draft,
      feePreview: _copyConfigurationFeePreview(draft),
      validations: validations,
    );
  }

  @override
  TradeCopyConfirmationResult submitCopyConfirmation(
    TradeCopyConfirmationRequest request,
  ) {
    final accepted = request.acceptedConsentIds.toSet();
    final missingRequiredConsent = _copyConfirmationConsents.any(
      (item) => item.required && !accepted.contains(item.id),
    );
    return TradeCopyConfirmationResult(
      providerId: request.providerId,
      status: missingRequiredConsent ? 'blocked' : 'pending_cooling_off',
      auditTrailId: 'AUD-COPY-073-${request.providerId.toUpperCase()}',
      coolingOffHours: missingRequiredConsent ? 0 : 24,
      activeCopiesPath: '/trade/copy-trading/active',
    );
  }

  @override
  TradeCopyAuditExportResult createCopyAuditExport(
    TradeCopyAuditExportRequest request,
  ) {
    return TradeCopyAuditExportResult(
      exportId: 'EXP-COPY-AUDIT-077-${request.copyId.toUpperCase()}',
      format: request.format,
      status: 'ready',
      downloadUrl: '/exports/copy-audit-${request.copyId}.${request.format}',
    );
  }
}
