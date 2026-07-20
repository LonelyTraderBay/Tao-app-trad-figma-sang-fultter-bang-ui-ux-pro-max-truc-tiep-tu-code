part of '../repositories/mock_trade_bots_repository.dart';

mixin _MockTradeBotsRepositoryLifecycleRiskMethods
    on _MockTradeBotsRepositoryBase {
  @override
  Future<TradeBotsSnapshot> getTradingBots() async {
    await _simulateNetwork();
    return const TradeBotsSnapshot(
      trade: _botLifecycleTradeSnapshot,
      strategies: _botStrategies,
      activeBots: _activeBots,
      lastUpdatedLabel: 'realtime-refresh',
      highRiskContractId: HighRiskFlowContractIds.tradeBots,
      supportedStates: [
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
  Future<TradeBotTermsSnapshot> getBotTermsOfService() async {
    await _simulateNetwork();
    return const TradeBotTermsSnapshot(
      infoTitle: 'Yêu cầu đồng ý điều khoản',
      infoDescription:
          'Bạn phải đọc và chấp nhận các điều khoản này trước khi dùng Bot '
          'giao dịch. Cuộn xuống cuối trang để bật nút chấp nhận.',
      title: 'Điều khoản dịch vụ Bot giao dịch',
      lastUpdatedLabel: 'Cập nhật lần cuối: 08/03/2026',
      sections: _botTermsSections,
      acceptSectionLabel: 'Chấp nhận điều khoản',
      scrollWarning:
          'Vui lòng cuộn xuống cuối điều khoản để bật nút chấp nhận.',
      agreementTitle:
          'Tôi đã đọc và đồng ý với Điều khoản dịch vụ Bot giao dịch',
      agreementDescription:
          'Khi đánh dấu ô này, bạn xác nhận đã hiểu rõ rủi ro của giao dịch '
          'tự động và chấp nhận các điều khoản nêu trên.',
      disabledCta: 'Đọc điều khoản để tiếp tục',
      enabledCta: 'Chấp nhận & Tiếp tục',
      complianceTitle: 'Tuân thủ quy định',
      complianceDescription:
          'Các điều khoản này tuân thủ MiFID II (EU), quy định SEC (Mỹ), '
          'hướng dẫn FCA (Anh) và các quy định tài chính hiện hành khác. '
          'Việc chấp nhận được ghi nhận và có thể kiểm tra lại.',
      endpoint: '/api/mobile/trade/trade-bots-terms-of-service',
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
  Future<TradeBotRiskDisclosureSnapshot> getBotRiskDisclosure() async {
    await _simulateNetwork();
    return const TradeBotRiskDisclosureSnapshot(
      highRiskTitle: 'CẢNH BÁO RỦI RO CAO',
      highRiskBody:
          'Bot giao dịch là sản phẩm tài chính phức tạp, tiềm ẩn rủi ro thua '
          'lỗ đáng kể. Bạn có thể mất toàn bộ khoản đầu tư. Chỉ dùng số vốn '
          'bạn chấp nhận mất hoàn toàn.',
      pastPerformanceTitle: 'Miễn trừ trách nhiệm về hiệu suất quá khứ',
      pastPerformanceBody:
          'Kết quả kiểm thử chiến lược và hiệu suất quá khứ không đảm bảo '
          'kết quả tương lai. Điều kiện thị trường thay đổi, chiến lược hiệu '
          'quả trong quá khứ vẫn có thể thất bại trong tương lai. Luôn giả '
          'định hiệu suất thực tế sẽ kém hơn kết quả kiểm thử do trượt giá, '
          'phí và độ trễ thực thi.',
      riskSectionLabel: 'Các hạng mục rủi ro',
      categories: _botRiskCategories,
      additionalWarningsLabel: 'Cảnh báo bổ sung',
      additionalWarnings: _botRiskWarnings,
      regulatoryNoticeLabel: 'Thông báo về quy định',
      regulatoryTitle: 'Tuân thủ MiFID II / ESMA / SEC',
      regulatoryBody:
          'Bot giao dịch được xếp vào nhóm sản phẩm tài chính phức tạp theo '
          'quy định châu Âu (MiFID II) và Mỹ (SEC). Bạn phải hoàn tất đánh '
          'giá mức độ phù hợp để đảm bảo hiểu rõ rủi ro trước khi dùng dịch '
          'vụ này.',
      regulatoryNotes: [
        'Cư dân EU: Áp dụng giới hạn đòn bẩy ESMA và bảo vệ số dư âm',
        'Cư dân Mỹ: Có thể bị hạn chế theo trạng thái nhà đầu tư đủ điều kiện',
        'Cư dân Anh: Yêu cầu bài kiểm tra phù hợp FCA cho sản phẩm phức tạp',
      ],
      acknowledgmentLabel: 'Xác nhận',
      acknowledgmentTitle:
          'Tôi xác nhận và chấp nhận toàn bộ rủi ro đã công bố ở trên',
      acknowledgmentDescription:
          'Tôi hiểu rằng Bot giao dịch có rủi ro cao, tôi có thể mất toàn bộ '
          'khoản đầu tư, và hiệu suất quá khứ không đảm bảo kết quả tương '
          'lai. Tôi chấp nhận hoàn toàn trách nhiệm với quyết định giao dịch '
          'của mình.',
      disabledCta: 'Xác nhận rủi ro để tiếp tục',
      enabledCta: 'Tôi đã hiểu rủi ro - Tiếp tục',
      helpTitle: 'Cần hỗ trợ hiểu rõ rủi ro?',
      helpDescription:
          'Nếu bạn chưa hiểu rõ các rủi ro này, chúng tôi khuyên bạn nên '
          'tham khảo cố vấn tài chính trước khi tiếp tục.',
      helpCta: 'Xem hướng dẫn giáo dục về rủi ro ->',
      nextPath: '/trade/bots/suitability-assessment',
      endpoint: '/api/mobile/trade/trade-bots-risk-disclosure',
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
  Future<TradeBotSuitabilityAssessmentSnapshot>
  getBotSuitabilityAssessment() async {
    await _simulateNetwork();
    return const TradeBotSuitabilityAssessmentSnapshot(
      questions: _botSuitabilityQuestions,
      infoTitle: 'Vì sao chúng tôi hỏi:',
      infoDescription:
          'Các câu hỏi này giúp xác định Bot giao dịch có phù hợp với mức '
          'kinh nghiệm và khả năng chấp nhận rủi ro của bạn không. Trả lời '
          'trung thực để có kết quả chính xác.',
      pass: TradeBotSuitabilityOutcomeCopy(
        outcome: TradeBotSuitabilityOutcome.pass,
        title: 'Phù hợp để dùng Bot giao dịch',
        message:
            'Dựa trên câu trả lời của bạn, bạn có đủ kiến thức và khả năng '
            'chấp nhận rủi ro để dùng Bot giao dịch.',
        recommendations: [
          'Bạn có thể dùng mọi chiến lược bot (DCA, Grid, Momentum, Martingale)',
          'Vẫn nên bắt đầu với số tiền nhỏ (\$100-500)',
          'Theo dõi hiệu suất hằng ngày và điều chỉnh tham số khi cần',
        ],
        ctaLabel: 'Tiếp tục đến Bot giao dịch',
      ),
      warning: TradeBotSuitabilityOutcomeCopy(
        outcome: TradeBotSuitabilityOutcome.warning,
        title: 'Nên thận trọng',
        message:
            'Bạn có một số kinh nghiệm, nhưng chúng tôi khuyên bạn nên bắt '
            'đầu với số tiền nhỏ và chiến lược đơn giản hơn như DCA. Tránh '
            'các chiến lược rủi ro cao như Martingale.',
        recommendations: [
          'Chỉ bắt đầu với DCA Bot - tránh Grid và Martingale',
          'Dùng số tiền nhỏ (tối đa \$50-200 mỗi bot)',
          'Hoàn thành hướng dẫn Bot Guide trước khi tạo bot đầu tiên',
        ],
        ctaLabel: 'Tiếp tục đến Bot giao dịch',
      ),
      fail: TradeBotSuitabilityOutcomeCopy(
        outcome: TradeBotSuitabilityOutcome.fail,
        title: 'Không khuyến nghị',
        message:
            'Dựa trên câu trả lời của bạn, Bot giao dịch có thể chưa phù hợp '
            'với bạn ở thời điểm này. Chúng tôi khuyên bạn nên tích luỹ thêm '
            'kinh nghiệm và kiến thức giao dịch trước khi dùng chiến lược tự '
            'động.',
        recommendations: [
          'Không khuyến nghị tiếp tục ở thời điểm này',
          'Tích luỹ thêm kinh nghiệm giao dịch thủ công trước (3-6 tháng)',
          'Xem lại tài liệu giáo dục và làm lại bài đánh giá sau',
        ],
        ctaLabel: 'Xem tài liệu giáo dục',
      ),
      regulatoryTitle: 'Tuân thủ quy định (MiFID II)',
      regulatoryDescription:
          'Đánh giá mức độ phù hợp này là bắt buộc theo quy định châu Âu '
          'đối với sản phẩm tài chính phức tạp. Câu trả lời của bạn đã được '
          'ghi nhận cho mục đích tuân thủ.',
      completionPath: '/trade/bots',
      endpoint: '/api/mobile/trade/trade-bots-suitability-assessment',
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
  Future<TradeBotRiskDashboardSnapshot> getBotRiskDashboard() async {
    await _simulateNetwork();
    return const TradeBotRiskDashboardSnapshot(
      riskScore: 68,
      riskLabel: 'Rủi ro trung bình',
      riskMessage:
          'Phát hiện rủi ro ở mức vừa phải. Cân nhắc giảm khối lượng vị thế '
          'hoặc dừng các bot rủi ro cao.',
      currentDrawdown: -15.2,
      maxDrawdownLimit: -20,
      dailyLoss: -127,
      dailyLossLimit: -500,
      totalExposure: 2500,
      maxExposure: 5000,
      var95: 178,
      runningBots: 3,
      drawdownPoints: _botRiskDrawdownPoints,
      exposures: _botRiskExposures,
      varHistory: _botRiskVarHistory,
      safetyControls: _botRiskSafetyControls,
      emergencyPath: '/trade/bots/emergency-stop',
      endpoint: '/api/mobile/trade/trade-bots-risk-dashboard',
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
  Future<TradeBotEmergencyStopSnapshot> getBotEmergencyStop() async {
    await _simulateNetwork();
    return const TradeBotEmergencyStopSnapshot(
      warningTitle: 'DỪNG KHẨN CẤP',
      warningDescription:
          'Thao tác này sẽ dừng ngay lập tức mọi bot đang chạy và huỷ các '
          'lệnh đang chờ. Chỉ dùng trong tình huống khẩn cấp (thị trường '
          'sập, sự cố kỹ thuật, hoạt động trái phép).',
      bots: _botEmergencyStopBots,
      reasons: _botEmergencyStopReasons,
      closePositionsTitle:
          'Đóng luôn toàn bộ vị thế đang mở (bán theo giá thị trường)',
      closePositionsDescription:
          'CẢNH BÁO: Thao tác này sẽ bán toàn bộ tài sản đang nắm giữ theo '
          'giá thị trường. Chỉ dùng khi bạn cần thoát vị thế ngay lập tức. '
          'Có thể phát sinh trượt giá.',
      confirmationTitle: 'Tôi hiểu đây là hành động không thể hoàn tác',
      confirmationDescription:
          'Mọi bot đang chạy sẽ dừng ngay lập tức. Lệnh đang chờ sẽ bị huỷ. '
          'Hành động này không thể hoàn tác. Tôi chịu hoàn toàn trách nhiệm '
          'với quyết định này.',
      supportTitle: 'Đội hỗ trợ sẽ được thông báo',
      supportDescription:
          'Đội bảo mật của chúng tôi sẽ tự động được thông báo về lần dừng '
          'khẩn cấp này để xem xét và hỗ trợ. Bạn sẽ nhận email xác nhận '
          'trong vòng 5 phút.',
      completionPath: '/trade/bots',
      endpoint: '/api/mobile/trade/trade-bots-emergency-stop',
      actionDraft:
          'POST /trade/order-preview + POST /trade/orders; '
          'POST /bots/create|pause|stop|optimize where applicable',
      supportedStates: [
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
  Future<TradeBotSecuritySettingsSnapshot> getBotSecuritySettings() async {
    await _simulateNetwork();
    return const TradeBotSecuritySettingsSnapshot(
      twoFaEnabled: true,
      apiKeys: _botSecurityApiKeys,
      ipWhitelist: _botSecurityIpWhitelist,
      recentActivity: _botSecurityRecentActivity,
      securityTips: _botSecurityTips,
      generatedApiKeyPreview: 'sk_live_vittrade_demo_122',
      endpoint: '/api/mobile/trade/trade-bots-security-settings',
      actionDraft:
          'POST /trade/order-preview + POST /trade/orders; '
          'POST /bots/create|pause|stop|optimize where applicable; '
          'PATCH /user/settings or module settings',
      supportedStates: [
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
  Future<TradeBotHistorySnapshot> getBotHistory() async {
    await _simulateNetwork();
    return const TradeBotHistorySnapshot(
      trades: _botHistoryTrades,
      endpoint: '/api/mobile/trade/trade-bots-history',
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
  Future<TradeBotPerformanceAnalyticsSnapshot>
  getBotPerformanceAnalytics() async {
    await _simulateNetwork();
    return const TradeBotPerformanceAnalyticsSnapshot(
      metrics: TradeBotPerformanceMetrics(
        totalPnl: 199.30,
        winRate: 68.2,
        sharpeRatio: 1.87,
        avgWin: 12.30,
        avgLoss: -8.50,
        profitFactor: 2.14,
        totalTrades: 96,
        bestTrade: 42.80,
        worstTrade: -24.50,
      ),
      pnlPoints: _botPerformancePnlPoints,
      winLossPoints: _botPerformanceWinLossPoints,
      strategyPerformance: _botStrategyPerformance,
      durationDistribution: _botDurationDistribution,
      endpoint: '/api/mobile/trade/trade-bots-performance-analytics',
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
  Future<TradeBotActionResult> submitBotAction(
    TradeBotActionRequest request,
  ) async {
    await _simulateNetwork();
    return TradeBotActionResult(
      botId: request.botId,
      action: request.action,
      status: 'accepted',
    );
  }

  @override
  Future<TradeBotEmergencyStopResult> submitBotEmergencyStop(
    TradeBotEmergencyStopDraft draft,
  ) async {
    await _simulateNetwork();
    return TradeBotEmergencyStopResult(
      status: draft.confirmed ? 'accepted' : 'rejected',
      stoppedBotCount: draft.confirmed ? _botEmergencyStopBots.length : 0,
      redirectPath: '/trade/bots',
    );
  }

  @override
  Future<TradeBotSecuritySettingsResult> patchBotSecuritySettings(
    TradeBotSecuritySettingsDraft draft,
  ) async {
    await _simulateNetwork();
    return TradeBotSecuritySettingsResult(
      status: 'saved',
      twoFaEnabled: draft.twoFaEnabled,
    );
  }

  @override
  Future<TradeBotHistoryExportResult> createBotHistoryExport(
    TradeBotHistoryExportRequest request,
  ) async {
    await _simulateNetwork();
    return TradeBotHistoryExportResult(
      status: 'ready',
      downloadUrl: '/exports/BOT-HISTORY-123.${request.format}',
    );
  }

  @override
  Future<TradeBotCreateResult> createTradingBot(
    TradeBotCreateRequest request,
  ) async {
    await _simulateNetwork();
    return TradeBotCreateResult(
      botId: 'BOT-DEMO-059',
      strategyId: request.strategyId,
      status: 'created',
    );
  }
}
