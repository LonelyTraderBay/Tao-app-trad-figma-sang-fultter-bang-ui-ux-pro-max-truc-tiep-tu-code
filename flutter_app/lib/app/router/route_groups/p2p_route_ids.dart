final class P2PRoutePaths {
  const P2PRoutePaths._();

  static const String p2p = '/p2p';
  static const String p2pExpress = '/p2p/express';
  static const String p2pExpressConfirm = '/p2p/express/confirm';
  static String p2pOrder(String orderId) => '/p2p/order/$orderId';
  static String p2pOrderTimeline(String orderId) =>
      '/p2p/order/timeline/$orderId';
  static String p2pOrderRate(String orderId) => '/p2p/order/rate/$orderId';
  static String p2pOrderCancel(String orderId) => '/p2p/order/cancel/$orderId';
  static String p2pOrderProof(String orderId) => '/p2p/order/proof/$orderId';
  static String p2pChat(String orderId) => '/p2p/chat/$orderId';
  static String p2pDispute(String orderId) => '/p2p/dispute/$orderId';
  static String p2pDisputeDetail(String disputeId) =>
      '/p2p/dispute/detail/$disputeId';
  static String p2pDisputeEvidence(String disputeId) =>
      '/p2p/dispute/evidence/$disputeId';
  static String p2pDisputeResolution(String disputeId) =>
      '/p2p/dispute/resolution/$disputeId';
  static const String p2pDisputes = '/p2p/disputes';
  static String p2pAdAnalytics(String adId) => '/p2p/ad-analytics/$adId';
  static String p2pAd(String adId) => '/p2p/ad/$adId';
  static const String p2pMyAds = '/p2p/my-ads';
  static const String p2pCreate = '/p2p/create';
  static const String p2pMerchantApply = '/p2p/merchant-apply';
  static const String p2pTradingLevel = '/p2p/trading-level';
  static const String p2pReviews = '/p2p/reviews';
  static const String p2pPaymentMethodAdd = '/p2p/payment-method/add';
  static const String p2pPaymentMethods = '/p2p/payment-methods';
  static String p2pPaymentMethodVerification(String methodId) =>
      '/p2p/payment-method/verification/$methodId';
  static String p2pPaymentMethodOwnership(String methodId) =>
      '/p2p/payment-method/ownership/$methodId';
  static const String p2pPaymentMethodCoolingPeriod =
      '/p2p/payment-method/cooling-period';
  static const String p2pPaymentMethodHistory = '/p2p/payment-method/history';
  static const String p2pInsurance = '/p2p/insurance';
  static const String p2pInsuranceFundAlias = '/p2p/insurance-fund';
  static const String p2pInsuranceCertificate = '/p2p/insurance/certificate';
  static const String p2pInsuranceScore = '/p2p/insurance/score';
  static const String p2pInsurancePolicy = '/p2p/insurance/policy';
  static const String p2pContributionHistory =
      '/p2p/insurance/contribution-history';
  static String p2pClaim(String claimId) => '/p2p/insurance/claim/$claimId';
  static const String p2pEscrowBalance = '/p2p/escrow/balance';
  static String p2pEscrow(String orderId) => '/p2p/escrow/$orderId';
  static const String p2pKycRequirements = '/p2p/kyc/requirements';
  static const String p2pKycVerify = '/p2p/kyc/verify';
  static const String p2pKycStatus = '/p2p/kyc/status';
  static const String p2pKycIdentity = '/p2p/kyc/identity';
  static const String p2pKycAddress = '/p2p/kyc/address';
  static const String p2pKycSelfie = '/p2p/kyc/selfie';
  static const String p2pKycVideo = '/p2p/kyc/video';
  static const String p2pKycFaceMatch = '/p2p/kyc/face-match';
  static const String p2pSecurityCenter = '/p2p/security/center';
  static const String p2pSecurity2fa = '/p2p/security/2fa';
  static const String p2pSecurityDevices = '/p2p/security/devices';
  static const String p2pSecurityAntiPhishing = '/p2p/security/anti-phishing';
  static const String p2pSecurityLoginHistory = '/p2p/security/login-history';
  static const String p2pSecuritySuspiciousActivity =
      '/p2p/security/suspicious-activity';
  static const String p2pSecurityWhitelist = '/p2p/security/whitelist';
  static const String settingsSecurityBiometric =
      '/settings/security/biometric';
  static const String settingsSecurityChangePassword =
      '/settings/security/change-password';
  static String p2pMerchant(String merchantId) => '/p2p/merchant/$merchantId';
  static String p2pReport(String merchantId) => '/p2p/report/$merchantId';
  static const String p2pBlacklist = '/p2p/blacklist';
  static const String p2pBlacklistAdd = '/p2p/blacklist/add';
  static const String p2pGuide = '/p2p/guide';
  static const String p2pSettings = '/p2p/settings';
  static const String p2pSettingsNotifications = '/p2p/settings/notifications';
  static const String p2pE2EInfo = '/p2p/e2e-info';
  static const String p2pFraudPrevention = '/p2p/fraud-prevention';
  static const String p2pWallet = '/p2p/wallet';
  static const String p2pWalletTransfer = '/p2p/wallet/transfer';
  static const String p2pWalletFundLockHistory =
      '/p2p/wallet/fund-lock-history';
  static const String p2pWalletHistory = '/p2p/wallet/history';
  static const String p2pLimits = '/p2p/limits';
  static const String p2pLimitsTracker = '/p2p/limits/tracker';
  static const String p2pComplianceOverview = '/p2p/compliance/overview';
  static const String p2pComplianceAmlScreening =
      '/p2p/compliance/aml-screening';
  static const String p2pComplianceSourceOfFunds =
      '/p2p/compliance/source-of-funds';
  static const String p2pComplianceLargeTransaction =
      '/p2p/compliance/large-transaction';
  static const String p2pComplianceRiskAssessment =
      '/p2p/compliance/risk-assessment';
  static const String p2pTaxReporting = '/p2p/tax-reporting';
  static String p2pTaxReportDetailed(String year) =>
      '/p2p/tax-report/detailed/$year';
  static const String p2pOrderBook = '/p2p/order-book';
  static const String p2pDashboard = '/p2p/dashboard';
  static const String p2pAchievements = '/p2p/achievements';
  static const String p2pMyOrders = '/p2p/my-orders';
}

final class P2PRouteNames {
  const P2PRouteNames._();

  static const String sc210P2PExpressConfirm = 'sc210P2PExpressConfirm';
  static const String sc211P2PExpress = 'sc211P2PExpress';
  static const String sc212P2POrderTimeline = 'sc212P2POrderTimeline';
  static const String sc213P2POrderRate = 'sc213P2POrderRate';
  static const String sc214P2POrderCancel = 'sc214P2POrderCancel';
  static const String sc215P2POrderProof = 'sc215P2POrderProof';
  static const String sc216P2POrder = 'sc216P2POrder';
  static const String sc217P2PChat = 'sc217P2PChat';
  static const String sc218P2PDisputeDetail = 'sc218P2PDisputeDetail';
  static const String sc219P2PDisputeEvidence = 'sc219P2PDisputeEvidence';
  static const String sc220P2PDisputeResolution = 'sc220P2PDisputeResolution';
  static const String sc221P2PDispute = 'sc221P2PDispute';
  static const String sc222P2PDisputes = 'sc222P2PDisputes';
  static const String sc223P2PAdAnalytics = 'sc223P2PAdAnalytics';
  static const String sc224P2PAdDetail = 'sc224P2PAdDetail';
  static const String sc225P2PMyAds = 'sc225P2PMyAds';
  static const String sc226P2PCreateAd = 'sc226P2PCreateAd';
  static const String sc227P2PMerchantApply = 'sc227P2PMerchantApply';
  static const String sc228P2PMerchantProfile = 'sc228P2PMerchantProfile';
  static const String sc229P2PReportMerchant = 'sc229P2PReportMerchant';
  static const String sc230P2PTradingLevel = 'sc230P2PTradingLevel';
  static const String sc231P2PReviews = 'sc231P2PReviews';
  static const String sc232P2PPaymentMethodAdd = 'sc232P2PPaymentMethodAdd';
  static const String sc233P2PPaymentMethodVerification =
      'sc233P2PPaymentMethodVerification';
  static const String sc234P2PPaymentMethodOwnership =
      'sc234P2PPaymentMethodOwnership';
  static const String sc235P2PPaymentMethodCoolingPeriod =
      'sc235P2PPaymentMethodCoolingPeriod';
  static const String sc236P2PPaymentMethodHistory =
      'sc236P2PPaymentMethodHistory';
  static const String sc237P2PPaymentMethods = 'sc237P2PPaymentMethods';
  static const String sc238P2PInsuranceFund = 'sc238P2PInsuranceFund';
  static const String sc239P2PInsuranceCertificate =
      'sc239P2PInsuranceCertificate';
  static const String sc240P2PInsuranceScore = 'sc240P2PInsuranceScore';
  static const String sc241P2PInsurancePolicy = 'sc241P2PInsurancePolicy';
  static const String sc242P2PContributionHistory =
      'sc242P2PContributionHistory';
  static const String sc243P2PClaimDetail = 'sc243P2PClaimDetail';
  static const String sc244P2PInsuranceFundAlias = 'sc244P2PInsuranceFundAlias';
  static const String sc245P2PEscrowBalance = 'sc245P2PEscrowBalance';
  static const String sc246P2PEscrowDetail = 'sc246P2PEscrowDetail';
  static const String sc247P2PKycRequirements = 'sc247P2PKycRequirements';
  static const String sc248P2PKycStatus = 'sc248P2PKycStatus';
  static const String sc249P2PIdentityVerification =
      'sc249P2PIdentityVerification';
  static const String sc250P2PAddressProof = 'sc250P2PAddressProof';
  static const String sc251P2PSelfieVerification = 'sc251P2PSelfieVerification';
  static const String sc252P2PVideoVerification = 'sc252P2PVideoVerification';
  static const String sc253P2PSecurityCenter = 'sc253P2PSecurityCenter';
  static const String sc254P2P2FASettings = 'sc254P2P2FASettings';
  static const String sc255P2PDeviceManagement = 'sc255P2PDeviceManagement';
  static const String sc256P2PAntiPhishingCode = 'sc256P2PAntiPhishingCode';
  static const String sc257P2PLoginHistory = 'sc257P2PLoginHistory';
  static const String sc258P2PSuspiciousActivity = 'sc258P2PSuspiciousActivity';
  static const String sc259P2PE2EInfo = 'sc259P2PE2EInfo';
  static const String sc260P2PFraudPrevention = 'sc260P2PFraudPrevention';
  static const String sc261P2PWalletTransfer = 'sc261P2PWalletTransfer';
  static const String sc262P2PFundLockHistory = 'sc262P2PFundLockHistory';
  static const String sc263P2PWalletHistoryAlias = 'sc263P2PWalletHistoryAlias';
  static const String sc264P2PWallet = 'sc264P2PWallet';
  static const String sc265P2PLimitTracker = 'sc265P2PLimitTracker';
  static const String sc266P2PTransactionLimits = 'sc266P2PTransactionLimits';
  static const String sc267P2PComplianceOverview = 'sc267P2PComplianceOverview';
  static const String sc268P2PAmlScreening = 'sc268P2PAmlScreening';
  static const String sc269P2PSourceOfFunds = 'sc269P2PSourceOfFunds';
  static const String sc270P2PLargeTransaction = 'sc270P2PLargeTransaction';
  static const String sc271P2PRiskAssessment = 'sc271P2PRiskAssessment';
  static const String sc272P2PTaxReporting = 'sc272P2PTaxReporting';
  static const String sc273P2POrderBook = 'sc273P2POrderBook';
  static const String sc274P2PDashboard = 'sc274P2PDashboard';
  static const String sc275P2PAchievements = 'sc275P2PAchievements';
  static const String sc276P2PBlacklistAdd = 'sc276P2PBlacklistAdd';
  static const String sc277P2PBlacklist = 'sc277P2PBlacklist';
  static const String sc278P2PNotificationsSettings =
      'sc278P2PNotificationsSettings';
  static const String sc279P2PSettings = 'sc279P2PSettings';
  static const String sc280P2PGuide = 'sc280P2PGuide';
  static const String sc281P2PMyOrders = 'sc281P2PMyOrders';
  static const String sc282P2PHome = 'sc282P2PHome';
  static const String sc402P2PKycVerify = 'sc402P2PKycVerify';
  static const String sc403P2PKycFaceMatch = 'sc403P2PKycFaceMatch';
  static const String sc404P2PWhitelistMode = 'sc404P2PWhitelistMode';
  static const String sc405SettingsSecurityBiometric =
      'sc405SettingsSecurityBiometric';
  static const String sc406SettingsSecurityChangePassword =
      'sc406SettingsSecurityChangePassword';
  static const String sc407P2PTaxReportDetail = 'sc407P2PTaxReportDetail';
}
