part of '../repositories/mock_p2p_repository.dart';

mixin _MockP2PRepositorySecurityMethods on _MockP2PRepositoryBase {
  @override
  P2PSecurityCenterSnapshot getSecurityCenter() {
    return const P2PSecurityCenterSnapshot(
      endpoint: '/api/mobile/p2p/p2p-security-center',
      actionDraft:
          'POST /p2p/* workflow action where applicable; PATCH /user/settings or module settings',
      supportedStates: [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
      ],
      score: 90,
      maxScore: 100,
      scoreLabel: 'Xuất sắc',
      scoreSubtitle: 'Điểm bảo mật P2P của bạn',
      scoreBody: 'Tài khoản P2P của bạn được bảo vệ rất tốt. Tiếp tục duy trì!',
      features: _p2pSecurityFeatures,
      quickActions: _p2pSecurityQuickActions,
      recentEvents: _p2pSecurityRecentEvents,
      parentRoute: '/p2p',
      settingsRoute: '/p2p/settings',
      loginHistoryRoute: '/p2p/security/login-history',
      emptyTitle: 'Chưa có cảnh báo bảo mật P2P',
      contractNotes: 'P2P requires escrow, fraud, KYC, payment-state clarity.',
    );
  }

  @override
  P2PTwoFactorSettingsSnapshot getTwoFactorSettings() {
    return const P2PTwoFactorSettingsSnapshot(
      endpoint: '/api/mobile/p2p/p2p-security-2fa',
      actionDraft:
          'POST /auth/verify-factor; POST /p2p/* workflow action where applicable; PATCH /user/settings or module settings',
      supportedStates: [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
      ],
      methods: _p2pTwoFactorMethods,
      thresholds: _p2pTwoFactorThresholds,
      recommendation:
          'Nên bật ít nhất 2 phương thức 2FA và đặt threshold thấp để đảm bảo an toàn cho tài khoản P2P.',
      parentRoute: '/p2p/security/center',
      emptyTitle: 'Chưa có cấu hình 2FA P2P',
      contractNotes:
          'High-risk action: preview + confirm + audit trail required. P2P requires escrow, fraud, KYC, payment-state clarity.',
    );
  }

  @override
  P2PDeviceManagementSnapshot getDeviceManagement() {
    return const P2PDeviceManagementSnapshot(
      endpoint: '/api/mobile/p2p/p2p-security-devices',
      actionDraft:
          'POST /p2p/* workflow action where applicable; PATCH /user/settings or module settings',
      supportedStates: [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
      ],
      devices: _p2pTrustedDevices,
      infoTitle: 'Thiết bị tin cậy',
      infoBody:
          'Đánh dấu thiết bị tin cậy để giảm số lần xác thực 2FA. Chỉ đánh dấu thiết bị cá nhân của bạn.',
      securityTips: _p2pDeviceSecurityTips,
      parentRoute: '/p2p/security/center',
      emptyTitle: 'Chưa có thiết bị P2P đã đăng nhập',
      contractNotes:
          'P2P requires escrow, fraud, KYC, payment-state clarity. Reference/admin surface; gate behind internal role or dev flag.',
    );
  }

  @override
  P2PAntiPhishingCodeSnapshot getAntiPhishingCode() {
    return const P2PAntiPhishingCodeSnapshot(
      endpoint: '/api/mobile/p2p/p2p-security-anti-phishing',
      actionDraft:
          'POST /p2p/* workflow action where applicable; PATCH /user/settings or module settings',
      supportedStates: [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
      ],
      hasCode: true,
      currentCode: 'SECURE2026',
      statusTitle: 'Anti-Phishing Code đã bật',
      statusBody: 'Mọi email P2P chính thức sẽ chứa code này',
      explainerTitle: 'Anti-Phishing Code là gì?',
      explainerBody:
          'Đây là mã bảo mật cá nhân xuất hiện trong mọi email chính thức từ VitTrade. Nếu email không có code này, đó là email giả mạo.',
      benefits: _p2pAntiPhishingBenefits,
      examples: _p2pAntiPhishingExamples,
      warningTitle: 'Cảnh báo quan trọng',
      warnings: _p2pAntiPhishingWarnings,
      parentRoute: '/p2p/security/center',
      emptyTitle: 'Chưa có Anti-Phishing Code P2P',
      contractNotes: 'P2P requires escrow, fraud, KYC, payment-state clarity.',
    );
  }

  @override
  P2PLoginHistorySnapshot getLoginHistory() {
    return const P2PLoginHistorySnapshot(
      endpoint: '/api/mobile/p2p/p2p-security-login-history',
      actionDraft:
          'POST /auth/login; POST /p2p/* workflow action where applicable; PATCH /user/settings or module settings',
      supportedStates: [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
        P2PScreenState.submitting,
        P2PScreenState.success,
      ],
      events: _p2pLoginHistoryEvents,
      warningBody: 'Nếu không phải bạn, vui lòng đổi mật khẩu và bật 2FA ngay.',
      infoTitle: 'Lưu ý bảo mật',
      securityTips: _p2pLoginHistorySecurityTips,
      parentRoute: '/p2p/security/center',
      emptyTitle: 'Không có lịch sử đăng nhập',
      contractNotes: 'P2P requires escrow, fraud, KYC, payment-state clarity.',
    );
  }

  @override
  P2PSuspiciousActivitySnapshot getSuspiciousActivity() {
    return const P2PSuspiciousActivitySnapshot(
      endpoint: '/api/mobile/p2p/p2p-security-suspicious-activity',
      actionDraft:
          'POST /p2p/* workflow action where applicable; PATCH /user/settings or module settings',
      supportedStates: [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
      ],
      alerts: _p2pSuspiciousAlerts,
      summarySubtitle: 'Xem lại hoạt động đáng ngờ',
      parentRoute: '/p2p/security/center',
      emptyTitle: 'Không có hoạt động đáng ngờ',
      contractNotes: 'P2P requires escrow, fraud, KYC, payment-state clarity.',
    );
  }

  @override
  P2PE2EInfoSnapshot getE2EInfo() {
    return const P2PE2EInfoSnapshot(
      endpoint: '/api/mobile/p2p/p2p-e2e-info',
      actionDraft: 'POST /p2p/* workflow action where applicable',
      supportedStates: [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
      ],
      heroTitle: 'End-to-End Encryption',
      heroSubtitle: 'Bảo mật cấp quân sự',
      localLabel: 'Bạn',
      partnerLabel: 'M',
      diagramCaption: 'Chỉ bạn và đối tác mới đọc được tin nhắn',
      infoItems: _p2pE2EInfoItems,
      fingerprint: '7F3A 92D1 B5E8 4C6F\nA1D3 8B2C E9F4 5A7D',
      fingerprintHint: 'So khớp mã này với đối tác để xác minh kết nối an toàn',
      steps: _p2pE2ESteps,
      serverNote:
          'VitTrade sử dụng kiến trúc Zero-Knowledge. Máy chủ chỉ lưu trữ tin nhắn đã mã hóa và không có khả năng giải mã nội dung.',
      parentRoute: '/p2p/chat/p2p001',
      emptyTitle: 'Chưa có thông tin mã hóa P2P',
      contractNotes: 'P2P requires escrow, fraud, KYC, payment-state clarity.',
    );
  }

  @override
  P2PFraudPreventionSnapshot getFraudPrevention() {
    return const P2PFraudPreventionSnapshot(
      endpoint: '/api/mobile/p2p/p2p-fraud-prevention',
      actionDraft: 'POST /p2p/* workflow action where applicable',
      supportedStates: [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
      ],
      patterns: _p2pFraudPatterns,
      checklist: _p2pFraudChecklist,
      emergencyActions: _p2pFraudEmergencyActions,
      disclosure:
          'Thông tin phòng chống gian lận mang tính chất giáo dục. Nếu bạn đã bị lừa đảo, hãy gửi claim bảo hiểm trong vòng 7 ngày và liên hệ hỗ trợ ngay.',
      parentRoute: '/p2p',
      emptyTitle: 'Chưa có nội dung phòng chống gian lận',
      contractNotes: 'P2P requires escrow, fraud, KYC, payment-state clarity.',
    );
  }
}
