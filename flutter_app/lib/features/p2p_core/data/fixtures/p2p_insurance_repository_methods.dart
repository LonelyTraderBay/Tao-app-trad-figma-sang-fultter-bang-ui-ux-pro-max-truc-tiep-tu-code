part of '../repositories/mock_p2p_repository.dart';

mixin _MockP2PRepositoryInsuranceMethods on _MockP2PRepositoryBase {
  @override
  Future<P2PInsuranceCertificateSnapshot> getInsuranceCertificate() async {
    await _simulateNetwork();
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
  Future<P2PInsuranceScoreSnapshot> getInsuranceScore() async {
    await _simulateNetwork();
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
  Future<P2PInsurancePolicySnapshot> getInsurancePolicy() async {
    await _simulateNetwork();
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
  Future<P2PContributionHistorySnapshot> getContributionHistory() async {
    await _simulateNetwork();
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
  Future<P2PClaimDetailSnapshot> getClaimDetail(String claimId) async {
    await _simulateNetwork();
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
      supportRoute: ContextualSupportContracts.supportRouteFor(
        ContextualSupportFlow.p2pOrder,
        referenceId: claim.claimCode,
        sourceRoute: '/p2p/insurance/claim/$claimId',
        issueLabel: 'P2P claim support for ${claim.claimCode}',
      ),
      emptyTitle: 'Không tìm thấy claim bảo hiểm',
      contractNotes: 'P2P requires escrow, fraud, KYC, payment-state clarity.',
      highRiskContractId: HighRiskFlowContractIds.p2pEscrowOrder,
    );
  }

  @override
  Future<P2PInsuranceFundSnapshot> getInsuranceFund() async {
    await _simulateNetwork();
    return const P2PInsuranceFundSnapshot(
      endpoint: '/api/mobile/p2p/p2p-insurance',
      legacyEndpoint: '/api/mobile/p2p/p2p-insurance-fund',
      actionDraft: 'POST /p2p/* workflow action where applicable',
      supportedStates: [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
      ],
      totalFund: 523000000,
      activeClaims: 3,
      totalContributed: 780000000,
      totalPaid: 257000000,
      userCoveragePct: 85,
      tierName: 'Pro',
      contributionRate: '0.1%',
      outstandingClaimsAmount: 83000000,
      solvencyRatio: 6.3,
      healthStatus: 'Khỏe mạnh',
      lastAuditDate: '28/02/2026',
      auditorName: 'Deloitte Vietnam',
      nextAuditDate: '31/03/2026',
      maxClaimPerPeriod: 100000000,
      approvalRate: 78.5,
      avgResolutionHours: 36,
      eligibilityItems: _p2pInsuranceEligibilityItems,
      coverageTiers: _p2pInsuranceCoverageTiers,
      notificationPrefs: _p2pInsuranceNotificationPrefs,
      claims: _p2pInsuranceClaims,
      chartPoints: _p2pInsuranceChartPoints,
      certificateRoute: '/p2p/insurance/certificate',
      contributionHistoryRoute: '/p2p/insurance/contribution-history',
      emptyTitle: 'Chưa có yêu cầu bồi thường',
      contractNotes: 'P2P requires escrow, fraud, KYC, payment-state clarity.',
    );
  }
}
