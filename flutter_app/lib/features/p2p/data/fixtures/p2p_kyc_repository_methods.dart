part of '../repositories/mock_p2p_repository.dart';

mixin _MockP2PRepositoryKycMethods on _MockP2PRepositoryBase {
  @override
  P2PKycRequirementsSnapshot getKycRequirements() {
    return P2PKycRequirementsSnapshot(
      endpoint: '/api/mobile/p2p/p2p-kyc-requirements',
      actionDraft:
          'POST /p2p/* workflow action where applicable; POST /kyc/submission-step',
      supportedStates: const [
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
      supportRoute: ContextualSupportContracts.supportRouteFor(
        ContextualSupportFlow.kyc,
        referenceId: 'p2p-kyc-requirements',
        sourceRoute: '/p2p/kyc/requirements',
        issueLabel: 'P2P KYC verification support',
      ),
      parentRoute: '/p2p',
      emptyTitle: 'Chưa có tier KYC P2P',
      contractNotes: 'P2P requires escrow, fraud, KYC, payment-state clarity.',
    );
  }

  @override
  P2PKycStatusSnapshot getKycStatus() {
    return P2PKycStatusSnapshot(
      endpoint: '/api/mobile/p2p/p2p-kyc-status',
      actionDraft:
          'POST /p2p/* workflow action where applicable; POST /kyc/submission-step',
      supportedStates: const [
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
      supportRoute: ContextualSupportContracts.supportRouteFor(
        ContextualSupportFlow.kyc,
        referenceId: 'p2p-kyc-pending-tier-2',
        sourceRoute: '/p2p/kyc/status',
        issueLabel: 'P2P KYC status support',
      ),
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
    return P2PSelfieVerificationSnapshot(
      endpoint: '/api/mobile/p2p/p2p-kyc-selfie',
      actionDraft:
          'POST /p2p/* workflow action where applicable; POST /kyc/submission-step',
      supportedStates: const [
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
      supportRoute: ContextualSupportContracts.supportRouteFor(
        ContextualSupportFlow.kyc,
        referenceId: 'p2p-kyc-selfie',
        sourceRoute: '/p2p/kyc/selfie',
        issueLabel: 'P2P selfie verification support',
      ),
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
}
