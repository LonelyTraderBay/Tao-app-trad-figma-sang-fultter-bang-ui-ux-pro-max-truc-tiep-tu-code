part of '../repositories/mock_trade_repository.dart';

mixin _MockTradeRepositoryMethodsPart06 on _MockTradeRepositoryBase {
  @override
  TradeBotTaxReportingSnapshot getBotTaxReporting() {
    return const TradeBotTaxReportingSnapshot(
      taxYears: ['2026', '2025', '2024', '2023'],
      defaultYear: '2025',
      defaultCostBasisMethod: 'FIFO',
      summary: _botTaxSummary,
      reportTypes: _botTaxReportTypes,
      breakdown: _botTaxBreakdown,
      taxNotes: _botTaxNotes,
      endpoint: '/api/mobile/trade/trade-bots-tax-reporting',
      actionDraft:
          'POST /trade/order-preview + POST /trade/orders; '
          'POST /bots/create|pause|stop|optimize where applicable; '
          'POST /exports',
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
  TradeBotApiDocumentationSnapshot getBotApiDocumentation() {
    return const TradeBotApiDocumentationSnapshot(
      tabs: [
        TradeBotApiTab(id: 'endpoints', label: 'endpoints'),
        TradeBotApiTab(id: 'websocket', label: 'websocket'),
        TradeBotApiTab(id: 'examples', label: 'examples'),
      ],
      defaultView: 'endpoints',
      defaultLanguage: 'javascript',
      endpoints: _botApiEndpoints,
      websocketUrl: 'wss://ws.tradingplatform.com/bots?apiKey=YOUR_API_KEY',
      websocketEvents: _botApiWebSocketEvents,
      codeExamples: _botApiCodeExamples,
      rateLimits: _botApiRateLimits,
      authenticationHeader: 'Authorization: Bearer YOUR_API_KEY',
      endpoint: '/api/mobile/trade/trade-bots-api-documentation',
      actionDraft:
          'POST /trade/order-preview + POST /trade/orders; '
          'POST /bots/create|pause|stop|optimize where applicable',
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
  TradeSettings patchTradeSettings(TradeSettings settings) {
    return settings;
  }

  @override
  TradeCopySettingsSaveResult patchCopySettings(TradeCopySettings settings) {
    return TradeCopySettingsSaveResult(status: 'saved', settings: settings);
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
  TradeProviderApplicationResult submitProviderApplication(
    TradeProviderApplicationDraft draft,
  ) {
    return const TradeProviderApplicationResult(
      applicationId: 'CPA-069-DEMO',
      status: 'submitted',
      reviewWindow: '2-3 ngày làm việc',
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

  @override
  TradeDisputeSubmissionResult submitDisputeComplaint(
    TradeDisputeComplaintDraft draft,
  ) {
    return const TradeDisputeSubmissionResult(
      caseId: 'case-003',
      status: 'submitted',
      message: 'Complaint submitted successfully',
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
  TradeBotTaxReportExportResult createBotTaxReportExport(
    TradeBotTaxReportExportRequest request,
  ) {
    return TradeBotTaxReportExportResult(
      status: request.reportTypeIds.isEmpty ? 'blocked' : 'ready',
      year: request.year,
      reportCount: request.reportTypeIds.length,
      exportId:
          'BOT-TAX-${request.year}-${request.costBasisMethod.toUpperCase()}',
    );
  }

  @override
  TradeExPostCostsReportExportResult createExPostCostsReportExport({
    int year = 2025,
  }) {
    return TradeExPostCostsReportExportResult(
      status: 'ready',
      year: year,
      downloadUrl: '/exports/ex-post-cost-report-$year.pdf',
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

  @override
  TradeFuturesPreview previewFuturesOrder(TradeFuturesOrderDraft draft) {
    final futures = getFutures(pairId: draft.pairId);
    final price = draft.limitPrice ?? futures.markPrice;
    final positionSize = draft.margin * draft.leverage;
    final liquidationDistance = 90 / draft.leverage;
    final liquidationPrice = draft.side == TradeFuturesSide.long
        ? price * (1 - liquidationDistance / 100)
        : price * (1 + liquidationDistance / 100);
    return TradeFuturesPreview(
      positionSize: positionSize,
      contractQty: price <= 0 ? 0 : positionSize / price,
      liquidationPrice: liquidationPrice,
      openFee: positionSize * .0002,
      canOpen: draft.margin > 0 && draft.margin <= 5000,
    );
  }

  @override
  TradeFuturesReceipt submitFuturesOrder(TradeFuturesOrderDraft draft) {
    return TradeFuturesReceipt(
      orderId: 'FUT-DEMO-057',
      preview: previewFuturesOrder(draft),
      status: 'submitted',
    );
  }

  @override
  TradeFuturesLeveragePreview previewFuturesLeverage(
    TradeFuturesLeverageRequest request,
  ) {
    final leverage = request.leverage.clamp(1, 100).toInt();
    final risk = _futuresLeverageRisk(leverage);
    final positionSize = request.exampleMargin * leverage;
    final onePercent = positionSize * .01;
    return TradeFuturesLeveragePreview(
      leverage: leverage,
      riskLabel: risk.label,
      riskLevel: risk.level,
      riskColorHex: risk.colorHex,
      positionSize: positionSize,
      liquidationDistancePct: 90 / leverage,
      openFee: positionSize * .0002,
      profitAtOnePct: onePercent,
      lossAtOnePct: onePercent,
      warningText: _futuresLeverageWarning(leverage),
      showRiskTips: leverage > 20,
    );
  }

  @override
  TradeFuturesLeverageReceipt submitFuturesLeverage(
    TradeFuturesLeverageRequest request,
  ) {
    return TradeFuturesLeverageReceipt(
      adjustmentId: 'LEV-DEMO-058',
      pairId: request.pairId,
      preview: previewFuturesLeverage(request),
      status: 'submitted',
    );
  }

  @override
  TradeBotActionResult submitBotAction(TradeBotActionRequest request) {
    return TradeBotActionResult(
      botId: request.botId,
      action: request.action,
      status: 'accepted',
    );
  }

  @override
  TradeBotEmergencyStopResult submitBotEmergencyStop(
    TradeBotEmergencyStopDraft draft,
  ) {
    final snapshot = getBotEmergencyStop();
    return TradeBotEmergencyStopResult(
      status: draft.confirmed ? 'accepted' : 'rejected',
      stoppedBotCount: draft.confirmed ? snapshot.bots.length : 0,
      redirectPath: snapshot.completionPath,
    );
  }

  @override
  TradeBotSecuritySettingsResult patchBotSecuritySettings(
    TradeBotSecuritySettingsDraft draft,
  ) {
    return TradeBotSecuritySettingsResult(
      status: 'saved',
      twoFaEnabled: draft.twoFaEnabled,
    );
  }

  @override
  TradeBotHistoryExportResult createBotHistoryExport(
    TradeBotHistoryExportRequest request,
  ) {
    return TradeBotHistoryExportResult(
      status: 'ready',
      downloadUrl: '/exports/BOT-HISTORY-123.${request.format}',
    );
  }

  @override
  TradeBotBacktestResult runBotBacktest(TradeBotBacktestRequest request) {
    return const TradeBotBacktestResult(
      status: 'queued',
      reportId: 'BOT-BACKTEST-125',
      progress: 0,
    );
  }

  @override
  TradeBotOptimizationResult runBotOptimization(
    TradeBotOptimizationRequest request,
  ) {
    return const TradeBotOptimizationResult(
      status: 'queued',
      jobId: 'BOT-OPT-127',
      estimatedMinutes: 3,
    );
  }

  @override
  TradeBotCreateResult createTradingBot(TradeBotCreateRequest request) {
    return TradeBotCreateResult(
      botId: 'BOT-DEMO-059',
      strategyId: request.strategyId,
      status: 'created',
    );
  }

  @override
  TradeOcoOrderResult submitOcoOrder(TradeOcoOrderDraft draft) {
    return TradeOcoOrderResult(
      orderId: 'OCO-DEMO-060',
      symbol: draft.symbol,
      status: 'submitted',
    );
  }

  @override
  TradePositionSizeResult calculatePositionSize(
    TradePositionSizeRequest request,
  ) {
    final riskAmount = request.accountBalance * request.riskPct / 100;
    final perUnitRisk = (request.entryPrice - request.stopPrice).abs();
    final suggestedAmount = perUnitRisk <= 0 ? 0.0 : riskAmount / perUnitRisk;
    return TradePositionSizeResult(
      riskAmount: riskAmount,
      perUnitRisk: perUnitRisk,
      suggestedAmount: suggestedAmount,
      notional: suggestedAmount * request.entryPrice,
    );
  }

  @override
  TradeSlippageSettings updateSlippageSettings(TradeSlippageSettings settings) {
    return settings;
  }

  @override
  TradeOrderAmendmentResult amendOrder(TradeOrderAmendmentRequest request) {
    return TradeOrderAmendmentResult(
      orderId: request.orderId,
      status: 'modified',
      queuePositionPreserved: true,
    );
  }

  @override
  TradeAdvancedToolActionResult submitAdvancedToolAction(
    TradeAdvancedToolActionRequest request,
  ) {
    return TradeAdvancedToolActionResult(
      toolId: request.toolId,
      action: request.action,
      status: 'accepted',
      affectedCount: request.orderIds.isEmpty ? 1 : request.orderIds.length,
    );
  }

  @override
  TradeCopyActionResult submitCopyTradingAction(
    TradeCopyActionRequest request,
  ) {
    return TradeCopyActionResult(
      providerId: request.providerId,
      action: request.action,
      status: 'accepted',
    );
  }

  @override
  TradeOrderPreview previewOrder(TradeOrderDraft draft) {
    final total = draft.price * draft.amount;
    const feeRate = .00085;
    final fee = total * feeRate;
    return TradeOrderPreview(
      total: total,
      fee: fee,
      feeRate: feeRate,
      estimatedReceive: total - fee,
    );
  }

  @override
  TradeOrderReceipt submitOrder(TradeOrderDraft draft) {
    return TradeOrderReceipt(
      orderId: 'ORD-DEMO-048',
      preview: previewOrder(draft),
      status: 'submitted',
    );
  }

  @override
  TradeOrderActionResult submitOrderAction({
    required String orderId,
    required String action,
  }) {
    return TradeOrderActionResult(
      orderId: orderId,
      action: action,
      status: 'success',
    );
  }
}
