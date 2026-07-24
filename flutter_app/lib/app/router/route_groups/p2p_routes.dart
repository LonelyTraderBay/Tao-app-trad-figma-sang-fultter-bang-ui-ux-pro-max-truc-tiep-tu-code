import 'package:vit_trade_flutter/app/router/route_error_page.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/features/p2p/presentation/pages/security/p2p_security_center_page.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/pages/security/p2p_2fa_settings_page.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/pages/security/p2p_device_management_page.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/pages/security/p2p_anti_phishing_code_page.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/pages/security/p2p_login_history_page.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/pages/security/p2p_suspicious_activity_page.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/pages/security/p2p_e2e_info_page.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/pages/security/p2p_fraud_prevention_page.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/pages/security/p2p_aml_screening_page.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/pages/security/p2p_limit_tracker_page.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/pages/security/p2p_compliance_overview_page.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/pages/security/p2p_large_transaction_justification_page.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/pages/security/p2p_risk_assessment_page.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/pages/security/p2p_achievements_page.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/pages/security/p2p_blacklist_add_page.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/pages/security/p2p_blacklist_page.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/pages/security/p2p_source_of_funds_page.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/pages/security/p2p_tax_reporting_page.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/pages/security/p2p_transaction_limits_page.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/pages/dispute/p2p_insurance_fund_page.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/pages/dispute/p2p_insurance_certificate_page.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/pages/security/p2p_contribution_history_page.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/pages/dispute/p2p_claim_detail_page.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/pages/dispute/p2p_insurance_policy_page.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/pages/dispute/p2p_insurance_score_page.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/pages/dispute/p2p_dispute_page.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/pages/dispute/p2p_dispute_detail_page.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/pages/dispute/p2p_dispute_evidence_page.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/pages/dispute/p2p_dispute_resolution_page.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/pages/dispute/p2p_disputes_page.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/pages/security/p2p_report_merchant_page.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/pages/security/p2p_reviews_page.dart';
import 'package:vit_trade_flutter/features/profile/presentation/pages/security_page.dart';

import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';

List<RouteBase> p2pRoutes(ShellRenderMode shellRenderMode) {
  return [
    GoRoute(
      path: '/p2p/dispute/detail/:disputeId',
      name: AppRouteNames.sc218P2PDisputeDetail,
      builder: (_, state) => P2PDisputeDetailPage(
        disputeId: requireRouteParam(state, 'disputeId'),
        shellRenderMode: shellRenderMode,
      ),
    ),
    GoRoute(
      path: '/p2p/dispute/evidence/:disputeId',
      name: AppRouteNames.sc219P2PDisputeEvidence,
      builder: (_, state) => P2PDisputeEvidencePage(
        disputeId: requireRouteParam(state, 'disputeId'),
        shellRenderMode: shellRenderMode,
      ),
    ),
    GoRoute(
      path: '/p2p/dispute/resolution/:disputeId',
      name: AppRouteNames.sc220P2PDisputeResolution,
      builder: (_, state) => P2PDisputeResolutionPage(
        disputeId: requireRouteParam(state, 'disputeId'),
        shellRenderMode: shellRenderMode,
      ),
    ),
    GoRoute(
      path: '/p2p/dispute/:orderId',
      name: AppRouteNames.sc221P2PDispute,
      builder: (_, state) => P2PDisputePage(
        orderId: requireRouteParam(state, 'orderId'),
        shellRenderMode: shellRenderMode,
      ),
    ),
    GoRoute(
      path: AppRoutePaths.p2pDisputes,
      name: AppRouteNames.sc222P2PDisputes,
      builder: (_, _) => P2PDisputesPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.p2pSecurityCenter,
      name: AppRouteNames.sc253P2PSecurityCenter,
      builder: (_, _) =>
          P2PSecurityCenterPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.p2pSecurity2fa,
      name: AppRouteNames.sc254P2P2FASettings,
      builder: (_, _) => P2P2FASettingsPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.p2pSecurityDevices,
      name: AppRouteNames.sc255P2PDeviceManagement,
      builder: (_, _) =>
          P2PDeviceManagementPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.p2pSecurityAntiPhishing,
      name: AppRouteNames.sc256P2PAntiPhishingCode,
      builder: (_, _) =>
          P2PAntiPhishingCodePage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.p2pSecurityLoginHistory,
      name: AppRouteNames.sc257P2PLoginHistory,
      builder: (_, _) => P2PLoginHistoryPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.p2pSecuritySuspiciousActivity,
      name: AppRouteNames.sc258P2PSuspiciousActivity,
      builder: (_, _) =>
          P2PSuspiciousActivityPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.p2pSecurityWhitelist,
      name: AppRouteNames.sc404P2PWhitelistMode,
      builder: (_, _) => P2PWhitelistModePage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.settingsSecurityBiometric,
      name: AppRouteNames.sc405SettingsSecurityBiometric,
      builder: (_, _) => SecurityPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.settingsSecurityChangePassword,
      name: AppRouteNames.sc406SettingsSecurityChangePassword,
      builder: (_, _) => SecurityPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: '/p2p/report/:merchantId',
      name: AppRouteNames.sc229P2PReportMerchant,
      builder: (_, state) => P2PReportMerchantPage(
        merchantId: requireRouteParam(state, 'merchantId'),
        shellRenderMode: shellRenderMode,
      ),
    ),
    GoRoute(
      path: AppRoutePaths.p2pReviews,
      name: AppRouteNames.sc231P2PReviews,
      builder: (_, _) => P2PReviewsPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.p2pInsurance,
      name: AppRouteNames.sc238P2PInsuranceFund,
      builder: (_, _) => P2PInsuranceFundPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.p2pInsuranceFundAlias,
      name: AppRouteNames.sc244P2PInsuranceFundAlias,
      builder: (_, _) => P2PInsuranceFundPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.p2pInsuranceCertificate,
      name: AppRouteNames.sc239P2PInsuranceCertificate,
      builder: (_, _) =>
          P2PInsuranceCertificatePage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.p2pInsuranceScore,
      name: AppRouteNames.sc240P2PInsuranceScore,
      builder: (_, _) =>
          P2PInsuranceScorePage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.p2pInsurancePolicy,
      name: AppRouteNames.sc241P2PInsurancePolicy,
      builder: (_, _) =>
          P2PInsurancePolicyPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.p2pContributionHistory,
      name: AppRouteNames.sc242P2PContributionHistory,
      builder: (_, _) =>
          P2PContributionHistoryPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: '/p2p/insurance/claim/:claimId',
      name: AppRouteNames.sc243P2PClaimDetail,
      builder: (_, state) => P2PClaimDetailPage(
        claimId: requireRouteParam(state, 'claimId'),
        shellRenderMode: shellRenderMode,
      ),
    ),
    GoRoute(
      path: AppRoutePaths.p2pBlacklistAdd,
      name: AppRouteNames.sc276P2PBlacklistAdd,
      builder: (_, _) => P2PBlacklistAddPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.p2pBlacklist,
      name: AppRouteNames.sc277P2PBlacklist,
      builder: (_, _) => P2PBlacklistPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.p2pE2EInfo,
      name: AppRouteNames.sc259P2PE2EInfo,
      builder: (_, _) => P2PE2EInfoPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.p2pFraudPrevention,
      name: AppRouteNames.sc260P2PFraudPrevention,
      builder: (_, _) =>
          P2PFraudPreventionPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.p2pLimits,
      name: AppRouteNames.sc266P2PTransactionLimits,
      builder: (_, _) =>
          P2PTransactionLimitsPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.p2pLimitsTracker,
      name: AppRouteNames.sc265P2PLimitTracker,
      builder: (_, _) => P2PLimitTrackerPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.p2pComplianceOverview,
      name: AppRouteNames.sc267P2PComplianceOverview,
      builder: (_, _) =>
          P2PComplianceOverviewPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.p2pComplianceAmlScreening,
      name: AppRouteNames.sc268P2PAmlScreening,
      builder: (_, _) => P2PAmlScreeningPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.p2pComplianceSourceOfFunds,
      name: AppRouteNames.sc269P2PSourceOfFunds,
      builder: (_, _) => P2PSourceOfFundsPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.p2pComplianceLargeTransaction,
      name: AppRouteNames.sc270P2PLargeTransaction,
      builder: (_, state) {
        final amount = double.tryParse(
          state.uri.queryParameters['amount'] ?? '',
        );
        return P2PLargeTransactionJustificationPage(
          amount: amount ?? 100000000,
          shellRenderMode: shellRenderMode,
        );
      },
    ),
    GoRoute(
      path: AppRoutePaths.p2pComplianceRiskAssessment,
      name: AppRouteNames.sc271P2PRiskAssessment,
      builder: (_, _) =>
          P2PRiskAssessmentPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.p2pTaxReporting,
      name: AppRouteNames.sc272P2PTaxReporting,
      builder: (_, _) => P2PTaxReportingPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.p2pAchievements,
      name: AppRouteNames.sc275P2PAchievements,
      builder: (_, _) => P2PAchievementsPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: '/p2p/tax-report/detailed/:year',
      name: AppRouteNames.sc407P2PTaxReportDetail,
      builder: (_, state) => P2PTaxReportingPage(
        initialYear: int.tryParse(state.pathParameters['year'] ?? ''),
        shellRenderMode: shellRenderMode,
      ),
    ),
  ];
}
