# VitTrade UI Fullscreen Density Audit

Generated from `flutter_app/tool/ui_fullscreen_density_audit.dart`.

```text
total_routed_screens=414
P1_density_refactor=0
P1_fullscreen_tool_visual_qa=5
P2_visual_density_review=29
P3_followup_review=21
Pass_or_low_signal=359
```

## Priority Counts

| Priority | Count |
| --- | ---: |
| `P1_density_refactor` | 0 |
| `P1_fullscreen_tool_visual_qa` | 5 |
| `P2_visual_density_review` | 29 |
| `P3_followup_review` | 21 |
| `Pass_or_low_signal` | 359 |

## Flagged Routes

| Priority | Score | Feature | Page | Route | Reason | Page file |
| --- | ---: | --- | --- | --- | --- | --- |
| P1_fullscreen_tool_visual_qa | 16 | enterprise_states | EnterpriseStatesPage | `AppRoutePaths.enterpriseStates` | body Tool; few dense sections/cards=2 | `flutter_app/lib/features/enterprise_states/presentation/pages/enterprise_states_page.dart` |
| P1_fullscreen_tool_visual_qa | 14 | p2p | P2PChatPage | `'/p2p/chat/:orderId'` | body Tool; few dense sections/cards=2 | `flutter_app/lib/features/p2p/presentation/pages/p2p_chat_page.dart` |
| P2_visual_density_review | 13 | arena | ArenaBlockedUsersPage | `AppRoutePaths.arenaBlocked` | body B; few dense sections/cards=2 | `flutter_app/lib/features/arena/presentation/pages/arena_blocked_users_page.dart` |
| P2_visual_density_review | 13 | arena | VerifiedChallengesPage | `AppRoutePaths.arenaVerified` | body B; few dense sections/cards=1 | `flutter_app/lib/features/arena/presentation/pages/verified_challenges_page.dart` |
| P2_visual_density_review | 13 | predictions | PredictionsSearchPage | `AppRoutePaths.marketsPredictionsSearch` | body B; custom>12 by 1; few dense sections/cards=1 | `flutter_app/lib/features/predictions/presentation/pages/predictions_search_page.dart` |
| P2_visual_density_review | 13 | profile | ProfilePage | `AppRoutePaths.profile` | body B | `flutter_app/lib/features/profile/presentation/pages/profile_page.dart` |
| P1_fullscreen_tool_visual_qa | 13 | trade | AdvancedChartPage | `'/trade/advanced-chart/:pairId'` | body Tool | `flutter_app/lib/features/trade/presentation/pages/advanced_chart_page.dart` |
| P2_visual_density_review | 12 | arena | ArenaResolutionCenterPage | `AppRoutePaths.arenaResolution` | body B; few dense sections/cards=1 | `flutter_app/lib/features/arena/presentation/pages/arena_resolution_center_page.dart` |
| P2_visual_density_review | 12 | auth | ForgotPasswordPage | `AppRoutePaths.authForgotPassword` | body B; few dense sections/cards=0 | `flutter_app/lib/features/auth/presentation/pages/forgot_password_page.dart` |
| P2_visual_density_review | 12 | auth | OTPPage | `AppRoutePaths.authOtp` | body B; few dense sections/cards=0 | `flutter_app/lib/features/auth/presentation/pages/otp_page.dart` |
| P2_visual_density_review | 12 | auth | RegisterPage | `AppRoutePaths.authRegister` | body B; few dense sections/cards=0 | `flutter_app/lib/features/auth/presentation/pages/register_page.dart` |
| P2_visual_density_review | 12 | auth | ResetPasswordPage | `AppRoutePaths.authResetPassword` | body B; few dense sections/cards=0 | `flutter_app/lib/features/auth/presentation/pages/reset_password_page.dart` |
| P2_visual_density_review | 12 | dca | DCARebalanceDashboard | `AppRoutePaths.dcaRebalanceDashboard` | body B; few dense sections/cards=2 | `flutter_app/lib/features/dca/presentation/pages/dca_rebalance_dashboard_page.dart` |
| P2_visual_density_review | 12 | dca | DCARebalanceDashboard | `'/dca/rebalance/:configId/history'` | body B; few dense sections/cards=2 | `flutter_app/lib/features/dca/presentation/pages/dca_rebalance_dashboard_page.dart` |
| P2_visual_density_review | 12 | dca | DCAScheduleAnalytics | `AppRoutePaths.dcaScheduleAnalytics` | body B; few dense sections/cards=2 | `flutter_app/lib/features/dca/presentation/pages/dca_schedule_analytics_page.dart` |
| P2_visual_density_review | 12 | markets | PriceAlertsPage | `AppRoutePaths.marketsAlerts` | body B; few dense sections/cards=2 | `flutter_app/lib/features/markets/presentation/pages/price_alerts_page.dart` |
| P2_visual_density_review | 12 | p2p | P2PComplianceOverviewPage | `AppRoutePaths.p2pComplianceOverview` | body B; few dense sections/cards=1 | `flutter_app/lib/features/p2p/presentation/pages/p2p_compliance_overview_page.dart` |
| P2_visual_density_review | 12 | p2p | P2PDisputeResolutionPage | `'/p2p/dispute/resolution/:disputeId'` | body B; few dense sections/cards=1 | `flutter_app/lib/features/p2p/presentation/pages/p2p_dispute_resolution_page.dart` |
| P2_visual_density_review | 12 | p2p | P2POrderTimelinePage | `'/p2p/order/timeline/:orderId'` | body B; few dense sections/cards=2 | `flutter_app/lib/features/p2p/presentation/pages/p2p_order_timeline_page.dart` |
| P2_visual_density_review | 12 | p2p | P2PRiskAssessmentPage | `AppRoutePaths.p2pComplianceRiskAssessment` | body B; few dense sections/cards=1 | `flutter_app/lib/features/p2p/presentation/pages/p2p_risk_assessment_page.dart` |
| P2_visual_density_review | 12 | profile | EditProfilePage | `AppRoutePaths.profileEdit` | body B; few dense sections/cards=2 | `flutter_app/lib/features/profile/presentation/pages/edit_profile_page.dart` |
| P2_visual_density_review | 12 | referral | ReferralFriendDetailPage | `'/referral/friend/:friendId'` | body B; few dense sections/cards=0 | `flutter_app/lib/features/referral/presentation/pages/referral_friend_detail_page.dart` |
| P2_visual_density_review | 12 | referral | ReferralHistoryPage | `AppRoutePaths.referralHistory` | body B; few dense sections/cards=2 | `flutter_app/lib/features/referral/presentation/pages/referral_history_page.dart` |
| P2_visual_density_review | 12 | support | AnnouncementsPage | `AppRoutePaths.supportAnnouncements` | body B; few dense sections/cards=1 | `flutter_app/lib/features/support/presentation/pages/announcements_page.dart` |
| P1_fullscreen_tool_visual_qa | 12 | trade | FuturesPage | `'/trade/:pairId/futures'` | body Tool | `flutter_app/lib/features/trade/presentation/pages/futures_page.dart` |
| P2_visual_density_review | 12 | trade | LiveMarketDataAnalyticsPage | `AppRoutePaths.tradeMarginLiveMarketDataAnalytics` | body B; few dense sections/cards=2 | `flutter_app/lib/features/trade/presentation/pages/live_market_data_analytics_page.dart` |
| P1_fullscreen_tool_visual_qa | 12 | trade | TradingBotsPage | `AppRoutePaths.tradeBots` | body Tool | `flutter_app/lib/features/trade/presentation/pages/trading_bots_page.dart` |
| P2_visual_density_review | 12 | wallet | WalletMultiManagerPage | `AppRoutePaths.walletMultiManager` | body B; few dense sections/cards=0 | `flutter_app/lib/features/wallet/presentation/pages/wallet_multi_manager_page.dart` |
| P2_visual_density_review | 10 | profile | SecurityPage | `AppRoutePaths.settingsSecurityBiometric` | body B | `flutter_app/lib/features/profile/presentation/pages/security_page.dart` |
| P2_visual_density_review | 10 | profile | SecurityPage | `AppRoutePaths.settingsSecurityChangePassword` | body B | `flutter_app/lib/features/profile/presentation/pages/security_page.dart` |
| P2_visual_density_review | 10 | profile | SecurityPage | `AppRoutePaths.settingsSecurity` | body B | `flutter_app/lib/features/profile/presentation/pages/security_page.dart` |
| P2_visual_density_review | 10 | profile | SecurityPage | `AppRoutePaths.profileSecurity` | body B | `flutter_app/lib/features/profile/presentation/pages/security_page.dart` |
| P2_visual_density_review | 10 | profile | SettingsPage | `AppRoutePaths.profileSettings` | body B | `flutter_app/lib/features/profile/presentation/pages/settings_page.dart` |
| P2_visual_density_review | 10 | profile | SubAccountPage | `AppRoutePaths.profileSubAccounts` | body B | `flutter_app/lib/features/profile/presentation/pages/sub_account_page.dart` |
| P3_followup_review | 9 | auth | LoginPage | `AppRoutePaths.authLogin` | body B; few dense sections/cards=0 | `flutter_app/lib/features/auth/presentation/pages/login_page.dart` |
| P3_followup_review | 9 | profile | ActivityLogPage | `AppRoutePaths.profileActivity` | body B; custom>6 by 1 | `flutter_app/lib/features/profile/presentation/pages/activity_log_page.dart` |
| P3_followup_review | 9 | wallet | TransactionHistoryPage | `AppRoutePaths.walletHistory` | body B | `flutter_app/lib/features/wallet/presentation/pages/transaction_history_page.dart` |
| P3_followup_review | 9 | wallet | WalletPage | `AppRoutePaths.wallet` | body B | `flutter_app/lib/features/wallet/presentation/pages/wallet_page.dart` |
| P3_followup_review | 8 | arena | ArenaChallengeDetailPage | `'/arena/challenge/:challengeId'` | body B | `flutter_app/lib/features/arena/presentation/pages/arena_challenge_detail_page.dart` |
| P3_followup_review | 8 | home | HomePage | `AppRoutePaths.home` | body B | `flutter_app/lib/features/home/presentation/pages/home_page.dart` |
| P3_followup_review | 8 | launchpad | LaunchpadContractPage | `AppRoutePaths.launchpadContractSample` | body B | `flutter_app/lib/features/launchpad/presentation/pages/launchpad_contract_page.dart` |
| P3_followup_review | 8 | markets | DerivativesOverviewPage | `AppRoutePaths.marketsDerivatives` | body B | `flutter_app/lib/features/markets/presentation/pages/derivatives_overview_page.dart` |
| P3_followup_review | 8 | predictions | PredictionEventDetailPage | `'/markets/predictions/event/:eventId'` | body B | `flutter_app/lib/features/predictions/presentation/pages/prediction_event_detail_page.dart` |
| P3_followup_review | 8 | rewards | RewardsHubPage | `AppRoutePaths.rewards` | body B | `flutter_app/lib/features/rewards/presentation/pages/rewards_hub_page.dart` |
| P3_followup_review | 8 | trade | CopyTradingPage | `AppRoutePaths.tradeCopyTrading` | body B | `flutter_app/lib/features/trade/presentation/pages/copy_trading_page.dart` |
| P3_followup_review | 8 | trade | TradePage | `AppRoutePaths.trade` | body B | `flutter_app/lib/features/trade/presentation/pages/trade_page.dart` |
| P3_followup_review | 8 | trade | TradePage | `'/trade/:pairId'` | body B | `flutter_app/lib/features/trade/presentation/pages/trade_page.dart` |
| P3_followup_review | 8 | wallet | AddressBookPage | `AppRoutePaths.walletAddressBook` | body B | `flutter_app/lib/features/wallet/presentation/pages/address_book_page.dart` |
| P3_followup_review | 8 | wallet | AssetDetailPage | `'/wallet/asset/:assetId'` | body B | `flutter_app/lib/features/wallet/presentation/pages/asset_detail_page.dart` |
| P3_followup_review | 8 | wallet | DepositPage | `AppRoutePaths.walletDeposit` | body B | `flutter_app/lib/features/wallet/presentation/pages/deposit_page.dart` |
| P3_followup_review | 8 | wallet | DepositPage | `'${AppRoutePaths.walletDeposit}/:asset'` | body B | `flutter_app/lib/features/wallet/presentation/pages/deposit_page.dart` |
| P3_followup_review | 8 | wallet | NetworkStatusPage | `AppRoutePaths.walletNetworkStatus` | body B | `flutter_app/lib/features/wallet/presentation/pages/network_status_page.dart` |
| P3_followup_review | 8 | wallet | PortfolioAnalyticsPage | `AppRoutePaths.walletPortfolioAnalytics` | body B | `flutter_app/lib/features/wallet/presentation/pages/portfolio_analytics_page.dart` |
| P3_followup_review | 8 | wallet | WalletGasOptimizerPage | `AppRoutePaths.walletGasOptimizer` | body B | `flutter_app/lib/features/wallet/presentation/pages/wallet_gas_optimizer_page.dart` |
| P3_followup_review | 8 | wallet | WithdrawLimitsPage | `AppRoutePaths.walletLimits` | body B | `flutter_app/lib/features/wallet/presentation/pages/withdraw_limits_page.dart` |
