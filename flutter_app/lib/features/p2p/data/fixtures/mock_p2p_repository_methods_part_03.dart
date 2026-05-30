part of '../repositories/mock_p2p_repository.dart';

mixin _MockP2PRepositoryMethodsPart03 on _MockP2PRepositoryBase {
  @override
  P2PInsuranceCertificateSnapshot getInsuranceCertificate() {
    return const P2PInsuranceCertificateSnapshot(
      endpoint: '/api/mobile/p2p/p2p-insurance-certificate',
      actionDraft: 'POST /p2p/* workflow action where applicable',
      supportedStates: [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
      ],
      certId: 'CERT-PRO-2026-78400',
      holderName: 'Nguyễn Văn Minh',
      holderId: 'UID-8847291',
      tierName: 'Pro',
      coveragePct: 85,
      maxCoveragePerClaim: 100000000,
      maxCoveragePer30Days: 100000000,
      contributionRate: '0.1%',
      issueDate: '01/01/2026',
      validUntil: '31/12/2026',
      totalContributed: 238200,
      totalTransactions: 128,
      claimWindowDays: 7,
      reviewSla: '48 giờ',
      payoutSla: '72 giờ',
      auditor: 'Deloitte Vietnam',
      lastAuditDate: '28/02/2026',
      coveredCases: _p2pInsuranceCertificateCoveredCases,
      exclusions: _p2pInsuranceCertificateExclusions,
      disclosure:
          'Chứng nhận này xác nhận quyền lợi bảo hiểm P2P của bạn theo điều khoản hiện hành. Mức bảo hiểm có thể thay đổi khi tier merchant thay đổi.',
      parentRoute: '/p2p/insurance',
      emptyTitle: 'Chưa có chứng nhận bảo hiểm',
      contractNotes: 'P2P requires escrow, fraud, KYC, payment-state clarity.',
    );
  }

  @override
  P2PInsuranceScoreSnapshot getInsuranceScore() {
    return const P2PInsuranceScoreSnapshot(
      endpoint: '/api/mobile/p2p/p2p-insurance-score',
      actionDraft: 'POST /p2p/* workflow action where applicable',
      supportedStates: [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
      ],
      overallScore: 78,
      maxScore: 100,
      grade: 'A',
      gradeLabel: 'Tốt',
      gradeDescription: 'Bảo vệ mạnh - đang ở tier Pro',
      currentTier: 'Pro',
      factors: _p2pInsuranceScoreFactors,
      quickActions: _p2pInsuranceScoreQuickActions,
      tierRequirements: _p2pInsuranceScoreTiers,
      disclosure:
          'Điểm bảo vệ được tính dựa trên nhiều yếu tố và cập nhật hằng ngày. Điểm không ảnh hưởng đến khả năng giao dịch, chỉ xác định mức bảo hiểm khi xảy ra sự cố.',
      parentRoute: '/p2p/insurance',
      emptyTitle: 'Chưa có điểm bảo vệ',
      contractNotes: 'P2P requires escrow, fraud, KYC, payment-state clarity.',
    );
  }

  @override
  P2PInsurancePolicySnapshot getInsurancePolicy() {
    return const P2PInsurancePolicySnapshot(
      endpoint: '/api/mobile/p2p/p2p-insurance-policy',
      actionDraft: 'POST /p2p/* workflow action where applicable',
      supportedStates: [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
      ],
      title: 'Điều khoản & Chính sách',
      subtitle: 'Quỹ Bảo Hiểm P2P',
      version: '2.1',
      lastUpdated: '01/03/2026',
      notice:
          'Vui lòng đọc kỹ các điều khoản trước khi sử dụng dịch vụ bảo hiểm P2P. Bằng việc gửi yêu cầu bồi thường, bạn xác nhận đã đọc và đồng ý với toàn bộ điều khoản này.',
      sections: _p2pInsurancePolicySections,
      privacyNotice:
          'Tài liệu này tuân thủ quy định bảo vệ dữ liệu cá nhân và được lưu trữ an toàn. Mọi thắc mắc vui lòng liên hệ support@platform.com.',
      parentRoute: '/p2p/insurance',
      emptyTitle: 'Chưa có điều khoản bảo hiểm',
      contractNotes: 'P2P requires escrow, fraud, KYC, payment-state clarity.',
    );
  }

  @override
  P2PContributionHistorySnapshot getContributionHistory() {
    return const P2PContributionHistorySnapshot(
      endpoint: '/api/mobile/p2p/p2p-insurance-contribution-history',
      actionDraft: 'POST /p2p/* workflow action where applicable',
      supportedStates: [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
      ],
      contributions: _p2pContributionHistoryItems,
      contributionRateLabel: '0.1%',
      parentRoute: '/p2p/insurance',
      emptyTitle: 'Chưa có lịch sử đóng góp',
      contractNotes: 'P2P requires escrow, fraud, KYC, payment-state clarity.',
    );
  }

  @override
  P2PClaimDetailSnapshot getClaimDetail(String claimId) {
    final claim =
        _p2pClaimDetails[claimId] ??
        _p2pClaimDetails[claimId == 'sample' ? 'ic001' : 'ic001']!;
    return P2PClaimDetailSnapshot(
      endpoint: '/api/mobile/p2p/p2p-insurance-claim-sample',
      actionDraft: 'POST /p2p/* workflow action where applicable',
      supportedStates: const [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
        P2PScreenState.submitting,
        P2PScreenState.success,
      ],
      claim: claim,
      benchmarks: _p2pClaimBenchmarks,
      reasonShares: _p2pClaimReasonShares,
      parentRoute: '/p2p/insurance',
      orderRoute: '/p2p/order/${claim.orderId.replaceFirst('P2P-', '')}',
      supportRoute: '/support/help',
      emptyTitle: 'Không tìm thấy claim bảo hiểm',
      contractNotes: 'P2P requires escrow, fraud, KYC, payment-state clarity.',
    );
  }

  @override
  P2PEscrowBalanceSnapshot getEscrowBalance({String asset = 'USDT'}) {
    final selectedAsset = _p2pEscrowOrders.containsKey(asset) ? asset : 'USDT';
    return P2PEscrowBalanceSnapshot(
      endpoint: '/api/mobile/p2p/p2p-escrow-balance',
      actionDraft: 'POST /p2p/* workflow action where applicable',
      supportedStates: const [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
      ],
      selectedAsset: selectedAsset,
      assets: _p2pEscrowAssets,
      ordersByAsset: _p2pEscrowOrders,
      title: 'Escrow Balance',
      subtitle: 'Escrow · P2P',
      infoTitle: 'Escrow là gì?',
      infoBody:
          'Khi bạn bán crypto, số tiền sẽ bị khóa trong escrow cho đến khi buyer thanh toán và bạn release. Điều này đảm bảo an toàn cho cả hai bên.',
      helpTitle: 'Khi nào tiền được giải phóng?',
      helpBullets: _p2pEscrowHelpBullets,
      parentRoute: '/p2p',
      emptyTitle: 'Không có tiền trong escrow',
      emptySubtitle: '$selectedAsset của bạn chưa bị khóa trong đơn hàng nào',
      contractNotes:
          'High-risk action: preview + confirm + audit trail required. P2P requires escrow, fraud, KYC, payment-state clarity.',
    );
  }

  @override
  P2PEscrowDetailSnapshot getEscrowDetail(String orderId) {
    final order = getOrder(orderId).order;
    return P2PEscrowDetailSnapshot(
      endpoint: '/api/mobile/p2p/p2p-escrow-$orderId',
      actionDraft: 'POST /p2p/* workflow action where applicable',
      supportedStates: const [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
      ],
      orderId: orderId,
      order: order,
      statusLabel: 'Đang khóa — Bảo vệ giao dịch',
      statusToneKey: 'warn',
      escrowAddress: _p2pEscrowAddress,
      explorerRoute: 'https://bscscan.com/address/$_p2pEscrowAddress',
      signers: _p2pEscrowSigners,
      timeline: _p2pEscrowTimeline,
      securityTitle: 'Bảo vệ bởi VitTrade Escrow',
      securityBody:
          'Coin được khóa trong smart contract đa chữ ký (2/3 multisig). Không bên nào có thể đơn phương rút coin. Nếu phát sinh tranh chấp, VitTrade sẽ đóng vai trò tài (arbiter).',
      parentRoute: '/p2p/order/$orderId',
      emptyTitle: 'Không tìm thấy escrow',
      contractNotes:
          'High-risk action: preview + confirm + audit trail required. P2P requires escrow, fraud, KYC, payment-state clarity.',
    );
  }

  @override
  P2PKycRequirementsSnapshot getKycRequirements() {
    return const P2PKycRequirementsSnapshot(
      endpoint: '/api/mobile/p2p/p2p-kyc-requirements',
      actionDraft:
          'POST /p2p/* workflow action where applicable; POST /kyc/submission-step',
      supportedStates: [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
        P2PScreenState.submitting,
        P2PScreenState.success,
      ],
      currentTier: 1,
      pendingTier: null,
      tiers: _p2pKycTiers,
      heroTitle: 'P2P KYC Verification',
      heroBody:
          'P2P yêu cầu xác minh riêng để đảm bảo an toàn giao dịch. Chọn tier phù hợp với nhu cầu của bạn.',
      noticeTitle: 'Lưu ý quan trọng',
      noticeBody:
          'KYC P2P độc lập với KYC nền tảng chính. Bạn cần hoàn thành xác minh riêng để sử dụng P2P Trading.',
      supportTitle: 'Cần hỗ trợ?',
      supportBody:
          'Nếu bạn gặp khó khăn trong quá trình xác minh, vui lòng liên hệ bộ phận hỗ trợ.',
      verifyRouteBase: '/p2p/kyc/verify',
      supportRoute: '/support',
      parentRoute: '/p2p',
      emptyTitle: 'Chưa có tier KYC P2P',
      contractNotes: 'P2P requires escrow, fraud, KYC, payment-state clarity.',
    );
  }

  @override
  P2PKycStatusSnapshot getKycStatus() {
    return const P2PKycStatusSnapshot(
      endpoint: '/api/mobile/p2p/p2p-kyc-status',
      actionDraft:
          'POST /p2p/* workflow action where applicable; POST /kyc/submission-step',
      supportedStates: [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
        P2PScreenState.submitting,
        P2PScreenState.success,
      ],
      tier: 2,
      tierName: 'Intermediate',
      overallStatus: P2PKycVerificationStatus.pending,
      submittedAt: '2026-03-04 14:30',
      steps: _p2pKycStatusSteps,
      infoBody:
          'Chúng tôi đang xem xét hồ sơ của bạn. Bạn sẽ nhận được thông báo qua email khi hoàn tất.',
      supportTitle: 'Cần hỗ trợ?',
      supportBody:
          'Nếu bạn có thắc mắc về quá trình xác minh, vui lòng liên hệ Support.',
      parentRoute: '/p2p/kyc/requirements',
      supportRoute: '/support',
      emptyTitle: 'Chưa có hồ sơ KYC P2P',
      contractNotes: 'P2P requires escrow, fraud, KYC, payment-state clarity.',
    );
  }

  @override
  P2PIdentityVerificationSnapshot getIdentityVerification() {
    return const P2PIdentityVerificationSnapshot(
      endpoint: '/api/mobile/p2p/p2p-kyc-identity',
      actionDraft:
          'POST /p2p/* workflow action where applicable; POST /kyc/submission-step',
      supportedStates: [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
        P2PScreenState.submitting,
        P2PScreenState.success,
      ],
      heroTitle: 'Xác minh danh tính',
      heroBody:
          'Upload CMND/CCCD/Passport để xác minh. Quá trình xử lý tự động qua OCR.',
      documentTypes: _p2pIdentityDocumentTypes,
      guidelines: _p2pIdentityGuidelines,
      securityNotes: _p2pIdentitySecurityNotes,
      parentRoute: '/p2p/kyc/status',
      nextRoute: '/p2p/kyc/face-match',
      emptyTitle: 'Chưa chọn loại giấy tờ',
      contractNotes: 'P2P requires escrow, fraud, KYC, payment-state clarity.',
    );
  }

  @override
  P2PAddressProofSnapshot getAddressProof() {
    return const P2PAddressProofSnapshot(
      endpoint: '/api/mobile/p2p/p2p-kyc-address',
      actionDraft:
          'POST /p2p/* workflow action where applicable; POST /kyc/submission-step',
      supportedStates: [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
        P2PScreenState.submitting,
        P2PScreenState.success,
      ],
      heroTitle: 'Xác minh địa chỉ',
      heroBody:
          'Upload tài liệu chứng minh địa chỉ cư trú của bạn. Yêu cầu cho Tier 2+.',
      documentTypes: _p2pAddressDocumentTypes,
      requirements: _p2pAddressRequirements,
      securityNotes: _p2pAddressSecurityNotes,
      extractedName: 'NGUYỄN VĂN A',
      extractedAddress: '123 Đường Láng, Đống Đa, Hà Nội',
      extractedDate: '15/02/2026',
      parentRoute: '/p2p/kyc/status',
      submitRoute: '/p2p/kyc/status',
      emptyTitle: 'Chưa chọn tài liệu địa chỉ',
      contractNotes: 'P2P requires escrow, fraud, KYC, payment-state clarity.',
    );
  }

  @override
  P2PSelfieVerificationSnapshot getSelfieVerification() {
    return const P2PSelfieVerificationSnapshot(
      endpoint: '/api/mobile/p2p/p2p-kyc-selfie',
      actionDraft:
          'POST /p2p/* workflow action where applicable; POST /kyc/submission-step',
      supportedStates: [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
        P2PScreenState.submitting,
        P2PScreenState.success,
      ],
      heroTitle: 'Selfie với ID',
      heroBody:
          'Chụp ảnh selfie cầm ID card để xác minh danh tính. Bao gồm liveness detection.',
      sampleTitle: 'Ảnh mẫu selfie với ID',
      sampleBody: 'Giữ ID cạnh khuôn mặt',
      guidelines: _p2pSelfieGuidelines,
      tips: _p2pSelfieTips,
      livenessActions: _p2pSelfieLivenessActions,
      matchScore: '96.5%',
      livenessScore: '98.2%',
      parentRoute: '/p2p/kyc/status',
      statusRoute: '/p2p/kyc/status',
      supportRoute: '/support',
      emptyTitle: 'Chưa có selfie verification',
      contractNotes: 'P2P requires escrow, fraud, KYC, payment-state clarity.',
    );
  }

  @override
  P2PVideoVerificationSnapshot getVideoVerification() {
    return const P2PVideoVerificationSnapshot(
      endpoint: '/api/mobile/p2p/p2p-kyc-video',
      actionDraft:
          'POST /p2p/* workflow action where applicable; POST /kyc/submission-step',
      supportedStates: [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
        P2PScreenState.submitting,
        P2PScreenState.success,
      ],
      heroTitle: 'Video KYC Call',
      heroBody:
          'Gọi video với agent để xác minh danh tính. Yêu cầu cho Tier 3.',
      preparationItems: _p2pVideoPreparationItems,
      timeSlots: _p2pVideoTimeSlots,
      parentRoute: '/p2p/kyc/status',
      statusRoute: '/p2p/kyc/status',
      emptyTitle: 'Chưa chọn khung giờ video KYC',
      contractNotes: 'P2P requires escrow, fraud, KYC, payment-state clarity.',
    );
  }

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
}
