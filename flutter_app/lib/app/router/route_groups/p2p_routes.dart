import 'package:vit_trade_flutter/app/router/route_error_page.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/features/p2p/presentation/pages/hub/p2p_express_page.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/pages/hub/p2p_home_page.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/pages/orders/p2p_escrow_balance_page.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/pages/orders/p2p_escrow_detail_page.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/pages/security/p2p_address_proof_page.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/pages/merchant/p2p_identity_verification_page.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/pages/merchant/p2p_kyc_requirements_page.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/pages/merchant/p2p_kyc_status_page.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/pages/merchant/p2p_selfie_verification_page.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/pages/merchant/p2p_video_verification_page.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/pages/security/p2p_security_center_page.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/pages/security/p2p_2fa_settings_page.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/pages/security/p2p_device_management_page.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/pages/security/p2p_anti_phishing_code_page.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/pages/security/p2p_login_history_page.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/pages/security/p2p_suspicious_activity_page.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/pages/security/p2p_e2e_info_page.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/pages/security/p2p_fraud_prevention_page.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/pages/orders/p2p_fund_lock_history_page.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/pages/security/p2p_aml_screening_page.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/pages/security/p2p_limit_tracker_page.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/pages/security/p2p_compliance_overview_page.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/pages/security/p2p_large_transaction_justification_page.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/pages/security/p2p_risk_assessment_page.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/pages/ads/p2p_order_book_page.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/pages/hub/p2p_dashboard_page.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/pages/security/p2p_achievements_page.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/pages/security/p2p_blacklist_add_page.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/pages/security/p2p_blacklist_page.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/pages/hub/p2p_guide_page.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/pages/hub/p2p_notifications_settings_page.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/pages/hub/p2p_settings_page.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/pages/security/p2p_source_of_funds_page.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/pages/security/p2p_tax_reporting_page.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/pages/security/p2p_transaction_limits_page.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/pages/wallet/p2p_wallet_page.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/pages/wallet/p2p_wallet_transfer_page.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/pages/dispute/p2p_insurance_fund_page.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/pages/dispute/p2p_insurance_certificate_page.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/pages/security/p2p_contribution_history_page.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/pages/dispute/p2p_claim_detail_page.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/pages/dispute/p2p_insurance_policy_page.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/pages/dispute/p2p_insurance_score_page.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/pages/hub/p2p_express_confirm_page.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/pages/orders/p2p_order_timeline_page.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/pages/orders/p2p_order_rate_page.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/pages/orders/p2p_order_cancel_page.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/pages/orders/p2p_order_proof_page.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/pages/orders/p2p_order_page.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/pages/orders/p2p_chat_page.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/pages/dispute/p2p_dispute_page.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/pages/dispute/p2p_dispute_detail_page.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/pages/dispute/p2p_dispute_evidence_page.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/pages/dispute/p2p_dispute_resolution_page.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/pages/dispute/p2p_disputes_page.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/pages/ads/p2p_ad_analytics_page.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/pages/ads/p2p_ad_detail_page.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/pages/ads/p2p_my_ads_page.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/pages/ads/p2p_create_ad_page.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/pages/merchant/p2p_merchant_apply_page.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/pages/merchant/p2p_merchant_profile_page.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/pages/orders/p2p_my_orders_page.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/pages/payment/p2p_payment_method_cooling_period_page.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/pages/payment/p2p_payment_method_history_page.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/pages/payment/p2p_payment_method_add_page.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/pages/payment/p2p_payment_methods_page.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/pages/payment/p2p_payment_method_ownership_page.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/pages/payment/p2p_payment_method_verification_page.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/pages/security/p2p_report_merchant_page.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/pages/security/p2p_reviews_page.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/pages/hub/p2p_trading_level_page.dart';
import 'package:vit_trade_flutter/features/profile/presentation/pages/security_page.dart';

import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';

List<RouteBase> p2pRoutes(ShellRenderMode shellRenderMode) {
  return [
    GoRoute(
      path: AppRoutePaths.p2pExpress,
      name: AppRouteNames.sc211P2PExpress,
      builder: (_, _) => P2PExpressPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.p2pExpressConfirm,
      name: AppRouteNames.sc210P2PExpressConfirm,
      builder: (_, state) => P2PExpressConfirmPage(
        shellRenderMode: shellRenderMode,
        tradeType: parseP2PTradeType(state.uri.queryParameters['type']),
        asset: state.uri.queryParameters['asset'] ?? 'USDT',
        fiatAmount: parseP2PAmount(state.uri.queryParameters['fiat']),
        cryptoAmount: parseP2PAmount(state.uri.queryParameters['crypto']),
        adId: state.uri.queryParameters['adId'],
        paymentMethod: state.uri.queryParameters['payment'],
      ),
    ),
    GoRoute(
      path: '/p2p/order/timeline/:orderId',
      name: AppRouteNames.sc212P2POrderTimeline,
      builder: (_, state) => P2POrderTimelinePage(
        orderId: requireRouteParam(state, 'orderId'),
        shellRenderMode: shellRenderMode,
      ),
    ),
    GoRoute(
      path: '/p2p/order/rate/:orderId',
      name: AppRouteNames.sc213P2POrderRate,
      builder: (_, state) => P2POrderRatePage(
        orderId: requireRouteParam(state, 'orderId'),
        shellRenderMode: shellRenderMode,
      ),
    ),
    GoRoute(
      path: '/p2p/order/cancel/:orderId',
      name: AppRouteNames.sc214P2POrderCancel,
      builder: (_, state) => P2POrderCancelPage(
        orderId: requireRouteParam(state, 'orderId'),
        shellRenderMode: shellRenderMode,
      ),
    ),
    GoRoute(
      path: '/p2p/order/proof/:orderId',
      name: AppRouteNames.sc215P2POrderProof,
      builder: (_, state) => P2POrderProofPage(
        orderId: requireRouteParam(state, 'orderId'),
        shellRenderMode: shellRenderMode,
      ),
    ),
    GoRoute(
      path: '/p2p/order/:orderId',
      name: AppRouteNames.sc216P2POrder,
      builder: (_, state) => P2POrderPage(
        orderId: requireRouteParam(state, 'orderId'),
        shellRenderMode: shellRenderMode,
      ),
    ),
    GoRoute(
      path: '/p2p/chat/:orderId',
      name: AppRouteNames.sc217P2PChat,
      builder: (_, state) => P2PChatPage(
        orderId: requireRouteParam(state, 'orderId'),
        shellRenderMode: shellRenderMode,
      ),
    ),
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
      path: '/p2p/ad-analytics/:adId',
      name: AppRouteNames.sc223P2PAdAnalytics,
      builder: (_, state) => P2PAdAnalyticsPage(
        adId: requireRouteParam(state, 'adId'),
        shellRenderMode: shellRenderMode,
      ),
    ),
    GoRoute(
      path: '/p2p/ad/:adId',
      name: AppRouteNames.sc224P2PAdDetail,
      builder: (_, state) => P2PAdDetailPage(
        adId: requireRouteParam(state, 'adId'),
        shellRenderMode: shellRenderMode,
      ),
    ),
    GoRoute(
      path: AppRoutePaths.p2pMyAds,
      name: AppRouteNames.sc225P2PMyAds,
      builder: (_, _) => P2PMyAdsPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.p2pCreate,
      name: AppRouteNames.sc226P2PCreateAd,
      builder: (_, _) => P2PCreateAdPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.p2pMerchantApply,
      name: AppRouteNames.sc227P2PMerchantApply,
      builder: (_, _) => P2PMerchantApplyPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: '/p2p/merchant/:merchantId',
      name: AppRouteNames.sc228P2PMerchantProfile,
      builder: (_, state) => P2PMerchantProfilePage(
        merchantId: requireRouteParam(state, 'merchantId'),
        shellRenderMode: shellRenderMode,
      ),
    ),
    GoRoute(
      path: AppRoutePaths.p2pEscrowBalance,
      name: AppRouteNames.sc245P2PEscrowBalance,
      builder: (_, state) => P2PEscrowBalancePage(
        initialAsset: p2pAssetFromQuery(state.uri.queryParameters['asset']),
        shellRenderMode: shellRenderMode,
      ),
    ),
    GoRoute(
      path: '/p2p/escrow/:orderId',
      name: AppRouteNames.sc246P2PEscrowDetail,
      builder: (_, state) => P2PEscrowDetailPage(
        orderId: requireRouteParam(state, 'orderId'),
        shellRenderMode: shellRenderMode,
      ),
    ),
    GoRoute(
      path: AppRoutePaths.p2pKycRequirements,
      name: AppRouteNames.sc247P2PKycRequirements,
      builder: (_, _) =>
          P2PKycRequirementsPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.p2pKycStatus,
      name: AppRouteNames.sc248P2PKycStatus,
      builder: (_, _) => P2PKycStatusPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.p2pKycIdentity,
      name: AppRouteNames.sc249P2PIdentityVerification,
      builder: (_, _) =>
          P2PIdentityVerificationPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.p2pKycAddress,
      name: AppRouteNames.sc250P2PAddressProof,
      builder: (_, _) => P2PAddressProofPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.p2pKycVerify,
      name: AppRouteNames.sc402P2PKycVerify,
      builder: (_, _) =>
          P2PIdentityVerificationPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.p2pKycFaceMatch,
      name: AppRouteNames.sc403P2PKycFaceMatch,
      builder: (_, _) =>
          P2PSelfieVerificationPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.p2pKycSelfie,
      name: AppRouteNames.sc251P2PSelfieVerification,
      builder: (_, _) =>
          P2PSelfieVerificationPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.p2pKycVideo,
      name: AppRouteNames.sc252P2PVideoVerification,
      builder: (_, _) =>
          P2PVideoVerificationPage(shellRenderMode: shellRenderMode),
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
      path: AppRoutePaths.p2pTradingLevel,
      name: AppRouteNames.sc230P2PTradingLevel,
      builder: (_, _) => P2PTradingLevelPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.p2pReviews,
      name: AppRouteNames.sc231P2PReviews,
      builder: (_, _) => P2PReviewsPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.p2pPaymentMethodAdd,
      name: AppRouteNames.sc232P2PPaymentMethodAdd,
      builder: (_, state) => P2PPaymentMethodAddPage(
        initialType: state.uri.queryParameters['type'] == 'ewallet'
            ? P2PPaymentAddType.ewallet
            : P2PPaymentAddType.bank,
        shellRenderMode: shellRenderMode,
      ),
    ),
    GoRoute(
      path: '/p2p/payment-method/verification/:methodId',
      name: AppRouteNames.sc233P2PPaymentMethodVerification,
      builder: (_, state) => P2PPaymentMethodVerificationPage(
        methodId: requireRouteParam(state, 'methodId'),
        shellRenderMode: shellRenderMode,
      ),
    ),
    GoRoute(
      path: '/p2p/payment-method/ownership/:methodId',
      name: AppRouteNames.sc234P2PPaymentMethodOwnership,
      builder: (_, state) => P2PPaymentMethodOwnershipPage(
        methodId: requireRouteParam(state, 'methodId'),
        shellRenderMode: shellRenderMode,
      ),
    ),
    GoRoute(
      path: AppRoutePaths.p2pPaymentMethodCoolingPeriod,
      name: AppRouteNames.sc235P2PPaymentMethodCoolingPeriod,
      builder: (_, _) =>
          P2PPaymentMethodCoolingPeriodPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.p2pPaymentMethodHistory,
      name: AppRouteNames.sc236P2PPaymentMethodHistory,
      builder: (_, _) =>
          P2PPaymentMethodHistoryPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.p2pPaymentMethods,
      name: AppRouteNames.sc237P2PPaymentMethods,
      builder: (_, _) =>
          P2PPaymentMethodsPage(shellRenderMode: shellRenderMode),
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
      path: AppRoutePaths.p2pGuide,
      name: AppRouteNames.sc280P2PGuide,
      builder: (_, _) => P2PGuidePage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.p2pSettings,
      name: AppRouteNames.sc279P2PSettings,
      builder: (_, _) => P2PSettingsPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.p2pSettingsNotifications,
      name: AppRouteNames.sc278P2PNotificationsSettings,
      builder: (_, _) =>
          P2PNotificationsSettingsPage(shellRenderMode: shellRenderMode),
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
      path: AppRoutePaths.p2pWallet,
      name: AppRouteNames.sc264P2PWallet,
      builder: (_, _) => P2PWalletPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.p2pWalletTransfer,
      name: AppRouteNames.sc261P2PWalletTransfer,
      builder: (_, state) {
        final query = state.uri.queryParameters;
        return P2PWalletTransferPage(
          initialAsset: p2pAssetFromQuery(query['asset']),
          initialType: p2pWalletTransferTypeFromQuery(query),
          shellRenderMode: shellRenderMode,
        );
      },
    ),
    GoRoute(
      path: AppRoutePaths.p2pWalletFundLockHistory,
      name: AppRouteNames.sc262P2PFundLockHistory,
      builder: (_, _) =>
          P2PFundLockHistoryPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.p2pWalletHistory,
      name: AppRouteNames.sc263P2PWalletHistoryAlias,
      builder: (_, _) => P2PFundLockHistoryPage(
        walletHistoryAlias: true,
        shellRenderMode: shellRenderMode,
      ),
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
      path: AppRoutePaths.p2pOrderBook,
      name: AppRouteNames.sc273P2POrderBook,
      builder: (_, _) => P2POrderBookPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.p2pDashboard,
      name: AppRouteNames.sc274P2PDashboard,
      builder: (_, _) => P2PDashboardPage(shellRenderMode: shellRenderMode),
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
    GoRoute(
      path: AppRoutePaths.p2p,
      name: AppRouteNames.sc282P2PHome,
      builder: (_, _) => P2PHomePage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.p2pMyOrders,
      name: AppRouteNames.sc281P2PMyOrders,
      builder: (_, _) => P2PMyOrdersPage(shellRenderMode: shellRenderMode),
    ),
  ];
}

String p2pAssetFromQuery(String? value) {
  final asset = value?.toUpperCase();
  return switch (asset) {
    'BTC' || 'VND' || 'USDT' => asset!,
    _ => 'USDT',
  };
}

String p2pWalletTransferTypeFromQuery(Map<String, String> query) {
  return switch (query['direction']) {
    'to-main' => 'withdraw',
    'from-main' => 'deposit',
    _ => query['type'] == 'withdraw' ? 'withdraw' : 'deposit',
  };
}
