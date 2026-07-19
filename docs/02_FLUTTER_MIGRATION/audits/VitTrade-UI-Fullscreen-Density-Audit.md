# VitTrade UI Fullscreen Density Audit

Generated from `flutter_app/tool/ui_fullscreen_density_audit.dart`.

```text
total_routed_screens=415
P1_density_refactor=0
P1_fullscreen_tool_visual_qa=5
P2_visual_density_review=29
P3_followup_review=44
Pass_or_low_signal=337
```

## Priority Counts

| Priority | Count |
| --- | ---: |
| `P1_density_refactor` | 0 |
| `P1_fullscreen_tool_visual_qa` | 5 |
| `P2_visual_density_review` | 29 |
| `P3_followup_review` | 44 |
| `Pass_or_low_signal` | 337 |

## Flagged Routes

| Priority | Score | Feature | Page | Route | Reason | Page file |
| --- | ---: | --- | --- | --- | --- | --- |
| P1_fullscreen_tool_visual_qa | 16 | enterprise_states | EnterpriseStatesPage | `AppRoutePaths.enterpriseStates` | body Tool; few dense sections/cards=1 | `flutter_app/lib/features/enterprise_states/presentation/pages/enterprise_states_page.dart` |
| P1_fullscreen_tool_visual_qa | 16 | trade | FuturesPage | `'/trade/:pairId/futures'` | body Tool; few dense sections/cards=2 | `flutter_app/lib/features/trade/presentation/pages/futures/futures_page.dart` |
| P1_fullscreen_tool_visual_qa | 14 | p2p | P2PChatPage | `'/p2p/chat/:orderId'` | body Tool; few dense sections/cards=2 | `flutter_app/lib/features/p2p/presentation/pages/orders/p2p_chat_page.dart` |
| P2_visual_density_review | 13 | arena | ArenaBlockedUsersPage | `AppRoutePaths.arenaBlocked` | body B; few dense sections/cards=2 | `flutter_app/lib/features/arena/presentation/pages/governance/arena_blocked_users_page.dart` |
| P2_visual_density_review | 13 | arena | VerifiedChallengesPage | `AppRoutePaths.arenaVerified` | body B; few dense sections/cards=1 | `flutter_app/lib/features/arena/presentation/pages/challenge/verified_challenges_page.dart` |
| P1_fullscreen_tool_visual_qa | 13 | trade_terminal | AdvancedChartPage | `'/trade/advanced-chart/:pairId'` | body Tool | `flutter_app/lib/features/trade_terminal/presentation/pages/tools/advanced_chart_page.dart` |
| P2_visual_density_review | 12 | arena | ArenaResolutionCenterPage | `AppRoutePaths.arenaResolution` | body B; few dense sections/cards=1 | `flutter_app/lib/features/arena/presentation/pages/governance/arena_resolution_center_page.dart` |
| P2_visual_density_review | 12 | auth | ForgotPasswordPage | `AppRoutePaths.authForgotPassword` | body B; few dense sections/cards=0 | `flutter_app/lib/features/auth/presentation/pages/forgot_password_page.dart` |
| P2_visual_density_review | 12 | auth | OTPPage | `AppRoutePaths.authOtp` | body B; few dense sections/cards=0 | `flutter_app/lib/features/auth/presentation/pages/otp_page.dart` |
| P2_visual_density_review | 12 | auth | RegisterPage | `AppRoutePaths.authRegister` | body B; few dense sections/cards=0 | `flutter_app/lib/features/auth/presentation/pages/register_page.dart` |
| P2_visual_density_review | 12 | auth | ResetPasswordPage | `AppRoutePaths.authResetPassword` | body B; few dense sections/cards=0 | `flutter_app/lib/features/auth/presentation/pages/reset_password_page.dart` |
| P2_visual_density_review | 12 | dca | DCARebalanceDashboard | `'/dca/rebalance/:configId/history'` | body B; few dense sections/cards=2 | `flutter_app/lib/features/dca/presentation/pages/portfolio/dca_rebalance_dashboard_page.dart` |
| P2_visual_density_review | 12 | dca | DCARebalanceDashboard | `AppRoutePaths.dcaRebalanceDashboard` | body B; few dense sections/cards=2 | `flutter_app/lib/features/dca/presentation/pages/portfolio/dca_rebalance_dashboard_page.dart` |
| P2_visual_density_review | 12 | dca | DCAScheduleAnalytics | `AppRoutePaths.dcaScheduleAnalytics` | body B; few dense sections/cards=2 | `flutter_app/lib/features/dca/presentation/pages/schedule/dca_schedule_analytics_page.dart` |
| P2_visual_density_review | 12 | enterprise_states | ForceUpdateGatePage | `AppRoutePaths.forceUpdateGate` | body B; few dense sections/cards=0 | `flutter_app/lib/features/enterprise_states/presentation/pages/force_update_gate_page.dart` |
| P2_visual_density_review | 12 | enterprise_states | MaintenanceGatePage | `AppRoutePaths.maintenanceGate` | body B; few dense sections/cards=0 | `flutter_app/lib/features/enterprise_states/presentation/pages/maintenance_gate_page.dart` |
| P2_visual_density_review | 12 | markets | PriceAlertsPage | `AppRoutePaths.marketsAlerts` | body B; few dense sections/cards=1 | `flutter_app/lib/features/markets/presentation/pages/portfolio/price_alerts_page.dart` |
| P2_visual_density_review | 12 | p2p | P2PComplianceOverviewPage | `AppRoutePaths.p2pComplianceOverview` | body B; few dense sections/cards=1 | `flutter_app/lib/features/p2p/presentation/pages/security/p2p_compliance_overview_page.dart` |
| P2_visual_density_review | 12 | p2p | P2PDisputeResolutionPage | `'/p2p/dispute/resolution/:disputeId'` | body B; few dense sections/cards=1 | `flutter_app/lib/features/p2p/presentation/pages/dispute/p2p_dispute_resolution_page.dart` |
| P2_visual_density_review | 12 | p2p | P2PNotificationsSettingsPage | `AppRoutePaths.p2pSettingsNotifications` | body B; few dense sections/cards=1 | `flutter_app/lib/features/p2p/presentation/pages/hub/p2p_notifications_settings_page.dart` |
| P2_visual_density_review | 12 | p2p | P2POrderTimelinePage | `'/p2p/order/timeline/:orderId'` | body B; few dense sections/cards=2 | `flutter_app/lib/features/p2p/presentation/pages/orders/p2p_order_timeline_page.dart` |
| P2_visual_density_review | 12 | p2p | P2PRiskAssessmentPage | `AppRoutePaths.p2pComplianceRiskAssessment` | body B; few dense sections/cards=1 | `flutter_app/lib/features/p2p/presentation/pages/security/p2p_risk_assessment_page.dart` |
| P2_visual_density_review | 12 | predictions | PredictionsSearchPage | `AppRoutePaths.marketsPredictionsSearch` | body B; few dense sections/cards=1 | `flutter_app/lib/features/predictions/presentation/pages/hub/predictions_search_page.dart` |
| P2_visual_density_review | 12 | profile | EditProfilePage | `AppRoutePaths.profileEdit` | body B; few dense sections/cards=2 | `flutter_app/lib/features/profile/presentation/pages/edit_profile_page.dart` |
| P2_visual_density_review | 12 | referral | ReferralFriendDetailPage | `'/referral/friend/:friendId'` | body B; few dense sections/cards=0 | `flutter_app/lib/features/referral/presentation/pages/referral_friend_detail_page.dart` |
| P2_visual_density_review | 12 | referral | ReferralHistoryPage | `AppRoutePaths.referralHistory` | body B; few dense sections/cards=2 | `flutter_app/lib/features/referral/presentation/pages/referral_history_page.dart` |
| P2_visual_density_review | 12 | support | AnnouncementsPage | `AppRoutePaths.supportAnnouncements` | body B; few dense sections/cards=1 | `flutter_app/lib/features/support/presentation/pages/announcements_page.dart` |
| P1_fullscreen_tool_visual_qa | 12 | trade_bots | TradingBotsPage | `AppRoutePaths.tradeBots` | body Tool | `flutter_app/lib/features/trade_bots/presentation/pages/hub/trading_bots_page.dart` |
| P2_visual_density_review | 12 | trade_copy | TraderProfilePage | `'/trade/trader/:traderId'` | body B; few dense sections/cards=1 | `flutter_app/lib/features/trade_copy/presentation/pages/provider/trader_profile_page.dart` |
| P2_visual_density_review | 12 | wallet | AddressAddPage | `AppRoutePaths.walletAddressBookAdd` | body B; few dense sections/cards=0 | `flutter_app/lib/features/wallet/presentation/pages/address/address_add_page.dart` |
| P2_visual_density_review | 12 | wallet | WalletMultiManagerPage | `AppRoutePaths.walletMultiManager` | body B; few dense sections/cards=0 | `flutter_app/lib/features/wallet/presentation/pages/tools/wallet_multi_manager_page.dart` |
| P2_visual_density_review | 11 | profile | ProfilePage | `AppRoutePaths.profile` | body B | `flutter_app/lib/features/profile/presentation/pages/profile_page.dart` |
| P2_visual_density_review | 10 | profile | SettingsPage | `AppRoutePaths.profileSettings` | body B | `flutter_app/lib/features/profile/presentation/pages/settings_page.dart` |
| P2_visual_density_review | 10 | profile | SubAccountPage | `AppRoutePaths.profileSubAccounts` | body B | `flutter_app/lib/features/profile/presentation/pages/sub_account_page.dart` |
| P3_followup_review | 9 | auth | LoginPage | `AppRoutePaths.authLogin` | body B; few dense sections/cards=0 | `flutter_app/lib/features/auth/presentation/pages/login_page.dart` |
| P3_followup_review | 9 | profile | SecurityPage | `AppRoutePaths.settingsSecurityChangePassword` | body B | `flutter_app/lib/features/profile/presentation/pages/security_page.dart` |
| P3_followup_review | 9 | profile | SecurityPage | `AppRoutePaths.settingsSecurityBiometric` | body B | `flutter_app/lib/features/profile/presentation/pages/security_page.dart` |
| P3_followup_review | 9 | profile | SecurityPage | `AppRoutePaths.settingsSecurity` | body B | `flutter_app/lib/features/profile/presentation/pages/security_page.dart` |
| P3_followup_review | 9 | profile | SecurityPage | `AppRoutePaths.profileSecurity` | body B | `flutter_app/lib/features/profile/presentation/pages/security_page.dart` |
| P3_followup_review | 9 | trade_bots | BotSecuritySettingsPage | `AppRoutePaths.tradeBotSecuritySettings` | body B | `flutter_app/lib/features/trade_bots/presentation/pages/settings/bot_security_settings_page.dart` |
| P3_followup_review | 9 | trade_copy | PreCopyAssessmentPage | `'/trade/copy-provider/:providerId/assessment'` | body B | `flutter_app/lib/features/trade_copy/presentation/pages/flow/pre_copy_assessment_page.dart` |
| P3_followup_review | 9 | wallet | TransactionHistoryPage | `AppRoutePaths.walletHistory` | body B | `flutter_app/lib/features/wallet/presentation/pages/history/transaction_history_page.dart` |
| P3_followup_review | 9 | wallet | WalletPage | `AppRoutePaths.wallet` | body B | `flutter_app/lib/features/wallet/presentation/pages/hub/wallet_page.dart` |
| P3_followup_review | 8 | admin | ABTestDashboard | `AppRoutePaths.adminAbtests` | body B | `flutter_app/lib/features/admin/presentation/pages/ab_test_dashboard.dart` |
| P3_followup_review | 8 | admin | AnalyticsDashboard | `AppRoutePaths.adminAnalytics` | body B | `flutter_app/lib/features/admin/presentation/pages/analytics_dashboard.dart` |
| P3_followup_review | 8 | admin | FunnelDashboard | `AppRoutePaths.adminFunnels` | body B | `flutter_app/lib/features/admin/presentation/pages/funnel_dashboard.dart` |
| P3_followup_review | 8 | home | HomePage | `AppRoutePaths.home` | body B | `flutter_app/lib/features/home/presentation/pages/home_page.dart` |
| P3_followup_review | 8 | predictions | PredictionEventDetailPage | `'/markets/predictions/event/:eventId'` | body B | `flutter_app/lib/features/predictions/presentation/pages/event/prediction_event_detail_page.dart` |
| P3_followup_review | 8 | profile | ActivityLogPage | `AppRoutePaths.profileActivity` | body B | `flutter_app/lib/features/profile/presentation/pages/activity_log_page.dart` |
| P3_followup_review | 8 | trade_bots | BotApiDocumentationPage | `AppRoutePaths.tradeBotApiDocumentation` | body B | `flutter_app/lib/features/trade_bots/presentation/pages/settings/bot_api_documentation_page.dart` |
| P3_followup_review | 8 | trade_bots | BotGuidePage | `AppRoutePaths.tradeBotGuide` | body B | `flutter_app/lib/features/trade_bots/presentation/pages/settings/bot_guide_page.dart` |
| P3_followup_review | 8 | trade_bots | BotSuitabilityAssessmentPage | `AppRoutePaths.tradeBotSuitabilityAssessment` | body B | `flutter_app/lib/features/trade_bots/presentation/pages/settings/bot_suitability_assessment_page.dart` |
| P3_followup_review | 8 | trade_compliance | BestExecutionReportsPage | `AppRoutePaths.tradeCopyBestExecutionReports` | body B | `flutter_app/lib/features/trade_compliance/presentation/pages/execution/best_execution_reports_page.dart` |
| P3_followup_review | 8 | trade_compliance | ClientCategorizationPage | `AppRoutePaths.tradeCopyClientCategorization` | body B | `flutter_app/lib/features/trade_compliance/presentation/pages/governance/client_categorization_page.dart` |
| P3_followup_review | 8 | trade_compliance | ClientMoneyProtectionPage | `AppRoutePaths.tradeCopyClientMoneyProtection` | body B | `flutter_app/lib/features/trade_compliance/presentation/pages/client_money/client_money_protection_page.dart` |
| P3_followup_review | 8 | trade_compliance | ClientOptUpRequestPage | `AppRoutePaths.tradeCopyClientOptUpRequest` | body B | `flutter_app/lib/features/trade_compliance/presentation/pages/governance/client_categorization_page.dart` |
| P3_followup_review | 8 | trade_compliance | ComplaintsHandlingPage | `AppRoutePaths.tradeCopyComplaintsHandling` | body B | `flutter_app/lib/features/trade_compliance/presentation/pages/complaints/complaints_handling_page.dart` |
| P3_followup_review | 8 | trade_compliance | ExAnteCostsPage | `AppRoutePaths.tradeCopyExAnteCosts` | body B | `flutter_app/lib/features/trade_compliance/presentation/pages/disclosures/ex_ante_costs_page.dart` |
| P3_followup_review | 8 | trade_compliance | ExecutionVenueAnalysisPage | `AppRoutePaths.tradeCopyExecutionVenueAnalysis` | body B | `flutter_app/lib/features/trade_compliance/presentation/pages/execution/execution_venue_analysis_page.dart` |
| P3_followup_review | 8 | trade_compliance | InvestorCompensationPage | `AppRoutePaths.tradeCopyInvestorCompensation` | body B | `flutter_app/lib/features/trade_compliance/presentation/pages/client_money/investor_compensation_page.dart` |
| P3_followup_review | 8 | trade_compliance | MarketDataAnalyticsPage | `AppRoutePaths.tradeMarginMarketDataAnalytics` | body B | `flutter_app/lib/features/trade_compliance/presentation/pages/execution/market_data_analytics_page.dart` |
| P3_followup_review | 8 | trade_compliance | PerformanceScenariosPage | `AppRoutePaths.tradeCopyPerformanceScenarios` | body B | `flutter_app/lib/features/trade_compliance/presentation/pages/disclosures/performance_scenarios_page.dart` |
| P3_followup_review | 8 | trade_compliance | ProductGovernancePage | `AppRoutePaths.tradeCopyProductGovernance` | body B | `flutter_app/lib/features/trade_compliance/presentation/pages/governance/product_governance_page.dart` |
| P3_followup_review | 8 | trade_compliance | RegulatoryDisclosuresPage | `AppRoutePaths.tradeCopyRegulatoryDisclosures` | body B | `flutter_app/lib/features/trade_compliance/presentation/pages/disclosures/regulatory_disclosures_page.dart` |
| P3_followup_review | 8 | trade_compliance | RegulatoryReportsDashboardPage | `AppRoutePaths.tradeCopyRegulatoryReportsDashboard` | body B | `flutter_app/lib/features/trade_compliance/presentation/pages/hub/regulatory_reports_dashboard_page.dart` |
| P3_followup_review | 8 | trade_compliance | RiskIndicatorExplainerPage | `AppRoutePaths.tradeCopyRiskIndicatorExplainer` | body B | `flutter_app/lib/features/trade_compliance/presentation/pages/disclosures/risk_indicator_explainer_page.dart` |
| P3_followup_review | 8 | trade_compliance | SlippageMonitoringPage | `AppRoutePaths.tradeCopySlippageMonitoring` | body B | `flutter_app/lib/features/trade_compliance/presentation/pages/execution/slippage_monitoring_page.dart` |
| P3_followup_review | 8 | trade_copy | ActiveCopiesPage | `AppRoutePaths.tradeCopyActive` | body B | `flutter_app/lib/features/trade_copy/presentation/pages/hub/active_copies_page.dart` |
| P3_followup_review | 8 | trade_copy | DisputeResolutionPage | `AppRoutePaths.tradeCopyDisputeResolution` | body B | `flutter_app/lib/features/trade_copy/presentation/pages/safety/dispute_resolution_page.dart` |
| P3_followup_review | 8 | trade_copy | PerformanceAttributionPage | `'/trade/copy-performance/:copyId/attribution'` | body B | `flutter_app/lib/features/trade_copy/presentation/pages/analytics/performance_attribution_page.dart` |
| P3_followup_review | 8 | trade_copy | ProviderGovernancePage | `AppRoutePaths.tradeCopyProviderGovernance` | body B | `flutter_app/lib/features/trade_copy/presentation/pages/provider/provider_governance_page.dart` |
| P3_followup_review | 8 | trade_copy | SafetyEducationPage | `AppRoutePaths.tradeCopySafety` | body B | `flutter_app/lib/features/trade_copy/presentation/pages/safety/safety_education_page.dart` |
| P3_followup_review | 8 | trade_terminal | AdvancedAnalyticsPage | `AppRoutePaths.tradeMarginAdvancedAnalytics` | body B | `flutter_app/lib/features/trade_terminal/presentation/pages/tools/advanced_analytics_page.dart` |
| P3_followup_review | 8 | trade_terminal | RiskManagementDemoPage | `AppRoutePaths.tradeRiskManagement` | body B | `flutter_app/lib/features/trade_terminal/presentation/pages/tools/risk_management_demo_page.dart` |
| P3_followup_review | 8 | wallet | AddressBookPage | `AppRoutePaths.walletAddressBook` | body B | `flutter_app/lib/features/wallet/presentation/pages/address/address_book_page.dart` |
| P3_followup_review | 8 | wallet | AssetDetailPage | `'/wallet/asset/:assetId'` | body B | `flutter_app/lib/features/wallet/presentation/pages/assets/asset_detail_page.dart` |
| P3_followup_review | 8 | wallet | NetworkStatusPage | `AppRoutePaths.walletNetworkStatus` | body B | `flutter_app/lib/features/wallet/presentation/pages/tools/network_status_page.dart` |
| P3_followup_review | 8 | wallet | PortfolioAnalyticsPage | `AppRoutePaths.walletPortfolioAnalytics` | body B | `flutter_app/lib/features/wallet/presentation/pages/tools/portfolio_analytics_page.dart` |
