part of '../repositories/mock_trade_regulatory_repository.dart';

mixin _MockTradeRegulatoryRepositoryDisputesMethods
    on _MockTradeRegulatoryRepositoryBase {
  @override
  Future<TradeComplaintsHandlingSnapshot> getComplaintsHandling() async {
    await _simulateNetwork();
    return const TradeComplaintsHandlingSnapshot(
      activeCount: 1,
      resolvedCount: 1,
      averageResolutionDays: 12,
      categories: _complaintCategories,
      timeline: _complaintTimeline,
      complaints: _complaints,
      processSteps: _complaintProcessSteps,
      ombudsman: TradeOmbudsmanInfo(
        description:
            'The Financial Ombudsman Service is a free, independent service '
            'that settles complaints between consumers and businesses that '
            'provide financial services.',
        phone: '0800 023 4567',
        website: 'www.financial-ombudsman.org.uk',
      ),
      endpoint: '/api/mobile/trade/trade-copy-trading-complaints-handling',
      actionDraft:
          'POST /trade/order-preview + POST /trade/orders; '
          'POST /copy-trading/follow|configure|stop where applicable',
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
  Future<TradeComplaintSubmissionSnapshot> getComplaintSubmission() async {
    await _simulateNetwork();
    return const TradeComplaintSubmissionSnapshot(
      processTitle: 'Complaint Process',
      processDescription:
          "We'll acknowledge your complaint within 5 business days and "
          'provide a final response within 8 weeks.',
      categories: [
        'Trade Execution',
        'Account Management',
        'Payments & Withdrawals',
        'Customer Service',
        'Fees & Charges',
        'Other',
      ],
      subjectMinLength: 10,
      subjectMaxLength: 100,
      descriptionMinLength: 50,
      descriptionMaxLength: 2000,
      termsIntro:
          'I confirm that the information provided is accurate and I understand:',
      terms: [
        'We will respond within 8 weeks',
        'I can refer to the Financial Ombudsman if not satisfied',
        'My complaint will be investigated fairly',
      ],
      confirmationComplaintId: 'COMP-2026-NEW',
      endpoint: '/api/mobile/trade/trade-copy-trading-complaint-submission',
      actionDraft:
          'POST /trade/order-preview + POST /trade/orders; '
          'POST /copy-trading/follow|configure|stop where applicable',
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
  Future<TradeComplaintTrackingSnapshot> getComplaintTracking({
    String? complaintId,
  }) async {
    await _simulateNetwork();
    return TradeComplaintTrackingSnapshot(
      complaintId: complaintId ?? 'undefined',
      statusLabel: 'Under Review',
      submittedLabel: 'Feb 15, 2026',
      responseDueLabel: 'Apr 12, 2026',
      daysRemaining: 34,
      deadlineNotice:
          'We must provide a final response by April 12, 2026 '
          '(8 weeks from submission).',
      timeline: _complaintTrackingTimeline,
      actions: _complaintTrackingActions,
      endpoint: '/api/mobile/trade/trade-copy-trading-complaint-tracking',
      actionDraft:
          'POST /trade/order-preview + POST /trade/orders; '
          'POST /copy-trading/follow|configure|stop where applicable',
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
  Future<TradeOmbudsmanReferralSnapshot> getOmbudsmanReferral() async {
    await _simulateNetwork();
    return const TradeOmbudsmanReferralSnapshot(
      infoTitle: 'Free & Independent',
      infoDescription:
          'The Financial Ombudsman Service (FOS) is a free service that '
          'settles complaints between consumers and financial businesses.',
      eligibility: _ombudsmanEligibility,
      contacts: _ombudsmanContacts,
      processSteps: _ombudsmanProcessSteps,
      ctaLabel: 'Visit FOS Website',
      externalUrl: 'https://www.financial-ombudsman.org.uk',
      endpoint: '/api/mobile/trade/trade-copy-trading-ombudsman-referral',
      actionDraft:
          'POST /trade/order-preview + POST /trade/orders; '
          'POST /copy-trading/follow|configure|stop where applicable',
      supportedStates: [
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.realtimeRefresh,
      ],
    );
  }
}
