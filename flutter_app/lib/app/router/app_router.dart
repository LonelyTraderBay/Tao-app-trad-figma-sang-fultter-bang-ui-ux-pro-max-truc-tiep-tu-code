import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/data/auth_repository.dart';
import '../../features/auth/presentation/forgot_password_page.dart';
import '../../features/auth/presentation/login_page.dart';
import '../../features/auth/presentation/otp_page.dart';
import '../../features/auth/presentation/register_page.dart';
import '../../features/auth/presentation/reset_password_page.dart';
import '../../features/auth/presentation/two_fa_setup_page.dart';
import '../../features/admin/presentation/admin_home.dart';
import '../../features/admin/presentation/ab_test_dashboard.dart';
import '../../features/admin/presentation/analytics_dashboard.dart';
import '../../features/admin/presentation/funnel_dashboard.dart';
import '../../features/arena/presentation/arena_home_page.dart';
import '../../features/arena/presentation/arena_governance_gate_page.dart';
import '../../features/arena/presentation/arena_guide_page.dart';
import '../../features/arena/presentation/arena_blocked_users_page.dart';
import '../../features/arena/presentation/arena_challenge_detail_page.dart';
import '../../features/arena/presentation/arena_creator_page.dart';
import '../../features/arena/presentation/arena_flow_map_page.dart';
import '../../features/arena/presentation/arena_leaderboard_page.dart';
import '../../features/arena/presentation/arena_safety_center_page.dart';
import '../../features/arena/presentation/arena_join_page.dart';
import '../../features/arena/presentation/arena_smart_rule_builder_page.dart';
import '../../features/arena/presentation/arena_studio_page.dart';
import '../../features/arena/presentation/arena_trust_breakdown_page.dart';
import '../../features/arena/presentation/arena_universal_preset_library_page.dart';
import '../../features/arena/presentation/arena_mode_detail_page.dart';
import '../../features/arena/presentation/arena_points_entry_detail_page.dart';
import '../../features/arena/presentation/arena_points_ledger_page.dart';
import '../../features/arena/presentation/arena_prediction_bridge_foundation_page.dart';
import '../../features/arena/presentation/arena_production_ready_page.dart';
import '../../features/arena/presentation/arena_report_case_page.dart';
import '../../features/arena/presentation/arena_resolution_center_page.dart';
import '../../features/arena/presentation/connected_ecosystem_production_page.dart';
import '../../features/arena/presentation/my_arena_page.dart';
import '../../features/arena/presentation/my_arena_reports_page.dart';
import '../../features/arena/presentation/verified_challenges_page.dart';
import '../../features/cross_module/presentation/cross_module_analytics.dart';
import '../../features/cross_module/presentation/smart_alert_center.dart';
import '../../features/cross_module/presentation/tax_report_center.dart';
import '../../features/cross_module/presentation/unified_portfolio_dashboard.dart';
import '../../features/dca/presentation/dca_page.dart';
import '../../features/dca/presentation/dca_rebalance_dashboard_page.dart';
import '../../features/dca/presentation/dca_rebalance_config_page.dart';
import '../../features/dca/presentation/dca_backtester_page.dart';
import '../../features/dca/presentation/dca_dynamic_amount_page.dart';
import '../../features/dca/presentation/dca_multi_asset_page.dart';
import '../../features/dca/presentation/dca_overview_demo.dart';
import '../../features/dca/presentation/dca_performance_compare_page.dart';
import '../../features/dca/presentation/dca_portfolio_optimizer_page.dart';
import '../../features/dca/presentation/dca_schedule_analytics_page.dart';
import '../../features/dca/presentation/dca_schedule_config_page.dart';
import '../../features/dca/presentation/dca_smart_rules_page.dart';
import '../../features/dev/presentation/performance_monitor.dart';
import '../../features/dev/presentation/missing_screens_showcase_page.dart';
import '../../features/dev/presentation/design_system_page.dart';
import '../../features/dev/presentation/route_checker_page.dart';
import '../../features/earn/data/earn_repository.dart';
import '../../features/earn/presentation/auto_compound_settings_page.dart';
import '../../features/earn/presentation/savings_analytics_page.dart';
import '../../features/earn/presentation/savings_auto_rebalance_page.dart';
import '../../features/earn/presentation/savings_autopilot_page.dart';
import '../../features/earn/presentation/savings_backtest_page.dart';
import '../../features/earn/presentation/savings_comparison_page.dart';
import '../../features/earn/presentation/savings_dca_page.dart';
import '../../features/earn/presentation/savings_export_page.dart';
import '../../features/earn/presentation/savings_history_page.dart';
import '../../features/earn/presentation/savings_faq_page.dart';
import '../../features/earn/presentation/savings_goal_page.dart';
import '../../features/earn/presentation/savings_ladder_page.dart';
import '../../features/earn/presentation/savings_notification_preferences_page.dart';
import '../../features/earn/presentation/savings_what_if_page.dart';
import '../../features/earn/presentation/savings_guide_page.dart';
import '../../features/earn/presentation/savings_notifications_page.dart';
import '../../features/earn/presentation/savings_portfolio_page.dart';
import '../../features/earn/presentation/savings_product_detail_page.dart';
import '../../features/earn/presentation/savings_recommendations_page.dart';
import '../../features/earn/presentation/savings_page.dart';
import '../../features/earn/presentation/savings_receipt_page.dart';
import '../../features/earn/presentation/savings_redeem_page.dart';
import '../../features/earn/presentation/savings_risk_assessment_page.dart';
import '../../features/earn/presentation/savings_smart_suggestions_page.dart';
import '../../features/earn/presentation/staking_community_governance_page.dart';
import '../../features/earn/presentation/staking_contingency_plan_page.dart';
import '../../features/earn/presentation/staking_emergency_actions_page.dart';
import '../../features/earn/presentation/staking_earn_page.dart';
import '../../features/earn/presentation/staking_dashboard_page.dart';
import '../../features/earn/presentation/staking_forum_page.dart';
import '../../features/earn/presentation/staking_analytics_page.dart';
import '../../features/earn/presentation/staking_advanced_orders_page.dart';
import '../../features/earn/presentation/staking_auto_compound_page.dart';
import '../../features/earn/presentation/staking_earnings_calendar_page.dart';
import '../../features/earn/presentation/staking_history_page.dart';
import '../../features/earn/presentation/staking_insurance_page.dart';
import '../../features/earn/presentation/staking_institutional_page.dart';
import '../../features/earn/presentation/staking_guide_page.dart';
import '../../features/earn/presentation/staking_faq_page.dart';
import '../../features/earn/presentation/staking_notifications_page.dart';
import '../../features/earn/presentation/staking_recommendations_page.dart';
import '../../features/earn/presentation/staking_regulatory_framework_page.dart';
import '../../features/earn/presentation/staking_audit_reports_page.dart';
import '../../features/earn/presentation/staking_custody_page.dart';
import '../../features/earn/presentation/staking_data_export_page.dart';
import '../../features/earn/presentation/staking_developer_console_page.dart';
import '../../features/earn/presentation/staking_api_documentation_page.dart';
import '../../features/earn/presentation/staking_insurance_fund_transparency_page.dart';
import '../../features/earn/presentation/staking_proof_of_reserves_page.dart';
import '../../features/earn/presentation/staking_proposals_page.dart';
import '../../features/earn/presentation/staking_risk_dashboard_page.dart';
import '../../features/earn/presentation/staking_risk_score_calculator_page.dart';
import '../../features/earn/presentation/staking_slashing_history_page.dart';
import '../../features/earn/presentation/staking_social_feed_page.dart';
import '../../features/earn/presentation/staking_suitability_assessment_page.dart';
import '../../features/earn/presentation/staking_transaction_reporting_page.dart';
import '../../features/earn/presentation/staking_third_party_integrations_page.dart';
import '../../features/earn/presentation/staking_voting_page.dart';
import '../../features/earn/presentation/staking_webhooks_page.dart';
import '../../features/earn/presentation/staking_liquid_staking_page.dart';
import '../../features/earn/presentation/staking_multi_chain_page.dart';
import '../../features/earn/presentation/staking_risk_disclosure_page.dart';
import '../../features/earn/presentation/staking_risk_assessment_page.dart';
import '../../features/earn/presentation/staking_tax_guide_page.dart';
import '../../features/earn/presentation/staking_terms_page.dart';
import '../../features/earn/presentation/staking_validator_health_monitor_page.dart';
import '../../features/earn/presentation/staking_validator_selection_page.dart';
import '../../features/earn/presentation/staking_withdrawal_policy_page.dart';
import '../../features/discovery/presentation/unified_search_page.dart';
import '../../features/discovery/presentation/topic_hub_page.dart';
import '../../features/enterprise_states/presentation/enterprise_states_page.dart';
import '../../features/home/data/home_mock_data.dart';
import '../../features/markets/presentation/advanced_charts_page.dart';
import '../../features/home/presentation/home_page.dart';
import '../../features/markets/presentation/derivatives_overview_page.dart';
import '../../features/markets/presentation/comparison_tool_page.dart';
import '../../features/markets/presentation/market_calendar_page.dart';
import '../../features/markets/presentation/market_correlations_page.dart';
import '../../features/markets/presentation/market_depth_page.dart';
import '../../features/markets/presentation/market_heatmap_page.dart';
import '../../features/markets/presentation/market_list_page.dart';
import '../../features/markets/presentation/market_movers_page.dart';
import '../../features/markets/presentation/market_news_page.dart';
import '../../features/markets/presentation/market_overview_page.dart';
import '../../features/markets/presentation/pair_detail_page.dart';
import '../../features/markets/presentation/portfolio_tracker_page.dart';
import '../../features/markets/presentation/market_screener_page.dart';
import '../../features/markets/presentation/market_sectors_page.dart';
import '../../features/markets/presentation/price_alerts_page.dart';
import '../../features/markets/presentation/social_signals_page.dart';
import '../../features/markets/presentation/social_sentiment_page.dart';
import '../../features/markets/presentation/token_info_page.dart';
import '../../features/markets/presentation/token_unlocks_page.dart';
import '../../features/markets/presentation/watchlist_page.dart';
import '../../features/news/presentation/news_page.dart';
import '../../features/notifications/presentation/notifications_page.dart';
import '../../features/onboarding/presentation/onboarding_flow.dart';
import '../../features/predictions/presentation/prediction_advanced_chart_page.dart';
import '../../features/predictions/presentation/prediction_data_integration_page.dart';
import '../../features/predictions/presentation/predictions_breaking_page.dart';
import '../../features/predictions/presentation/prediction_event_calendar_page.dart';
import '../../features/predictions/presentation/prediction_event_detail_page.dart';
import '../../features/predictions/presentation/prediction_market_maker_page.dart';
import '../../features/predictions/presentation/prediction_order_receipt_page.dart';
import '../../features/predictions/presentation/prediction_portfolio_analyzer_page.dart';
import '../../features/predictions/presentation/prediction_risk_calculator_page.dart';
import '../../features/predictions/presentation/prediction_social_page.dart';
import '../../features/predictions/presentation/prediction_tournaments_page.dart';
import '../../features/predictions/presentation/predictions_global_activity_page.dart';
import '../../features/predictions/presentation/predictions_home_page.dart';
import '../../features/predictions/presentation/predictions_leaderboard_page.dart';
import '../../features/predictions/presentation/predictions_portfolio_page.dart';
import '../../features/predictions/presentation/predictions_rewards_page.dart';
import '../../features/predictions/presentation/predictions_search_page.dart';
import '../../features/p2p/presentation/p2p_express_page.dart';
import '../../features/p2p/presentation/p2p_home_page.dart';
import '../../features/p2p/presentation/p2p_escrow_balance_page.dart';
import '../../features/p2p/presentation/p2p_escrow_detail_page.dart';
import '../../features/p2p/presentation/p2p_address_proof_page.dart';
import '../../features/p2p/presentation/p2p_identity_verification_page.dart';
import '../../features/p2p/presentation/p2p_kyc_requirements_page.dart';
import '../../features/p2p/presentation/p2p_kyc_status_page.dart';
import '../../features/p2p/presentation/p2p_selfie_verification_page.dart';
import '../../features/p2p/presentation/p2p_video_verification_page.dart';
import '../../features/p2p/presentation/p2p_security_center_page.dart';
import '../../features/p2p/presentation/p2p_2fa_settings_page.dart';
import '../../features/p2p/presentation/p2p_device_management_page.dart';
import '../../features/p2p/presentation/p2p_anti_phishing_code_page.dart';
import '../../features/p2p/presentation/p2p_login_history_page.dart';
import '../../features/p2p/presentation/p2p_suspicious_activity_page.dart';
import '../../features/p2p/presentation/p2p_e2e_info_page.dart';
import '../../features/p2p/presentation/p2p_fraud_prevention_page.dart';
import '../../features/p2p/presentation/p2p_fund_lock_history_page.dart';
import '../../features/p2p/presentation/p2p_aml_screening_page.dart';
import '../../features/p2p/presentation/p2p_limit_tracker_page.dart';
import '../../features/p2p/presentation/p2p_compliance_overview_page.dart';
import '../../features/p2p/presentation/p2p_large_transaction_justification_page.dart';
import '../../features/p2p/presentation/p2p_risk_assessment_page.dart';
import '../../features/p2p/presentation/p2p_order_book_page.dart';
import '../../features/p2p/presentation/p2p_dashboard_page.dart';
import '../../features/p2p/presentation/p2p_achievements_page.dart';
import '../../features/p2p/presentation/p2p_blacklist_add_page.dart';
import '../../features/p2p/presentation/p2p_blacklist_page.dart';
import '../../features/p2p/presentation/p2p_guide_page.dart';
import '../../features/p2p/presentation/p2p_notifications_settings_page.dart';
import '../../features/p2p/presentation/p2p_settings_page.dart';
import '../../features/p2p/presentation/p2p_source_of_funds_page.dart';
import '../../features/p2p/presentation/p2p_tax_reporting_page.dart';
import '../../features/p2p/presentation/p2p_transaction_limits_page.dart';
import '../../features/p2p/presentation/p2p_wallet_page.dart';
import '../../features/p2p/presentation/p2p_wallet_transfer_page.dart';
import '../../features/p2p/presentation/p2p_insurance_fund_page.dart';
import '../../features/p2p/presentation/p2p_insurance_certificate_page.dart';
import '../../features/p2p/presentation/p2p_contribution_history_page.dart';
import '../../features/p2p/presentation/p2p_claim_detail_page.dart';
import '../../features/p2p/presentation/p2p_insurance_policy_page.dart';
import '../../features/p2p/presentation/p2p_insurance_score_page.dart';
import '../../features/p2p/presentation/p2p_express_confirm_page.dart';
import '../../features/p2p/presentation/p2p_order_timeline_page.dart';
import '../../features/p2p/presentation/p2p_order_rate_page.dart';
import '../../features/p2p/presentation/p2p_order_cancel_page.dart';
import '../../features/p2p/presentation/p2p_order_proof_page.dart';
import '../../features/p2p/presentation/p2p_order_page.dart';
import '../../features/p2p/presentation/p2p_chat_page.dart';
import '../../features/p2p/presentation/p2p_dispute_page.dart';
import '../../features/p2p/presentation/p2p_dispute_detail_page.dart';
import '../../features/p2p/presentation/p2p_dispute_evidence_page.dart';
import '../../features/p2p/presentation/p2p_dispute_resolution_page.dart';
import '../../features/p2p/presentation/p2p_disputes_page.dart';
import '../../features/p2p/presentation/p2p_ad_analytics_page.dart';
import '../../features/p2p/presentation/p2p_ad_detail_page.dart';
import '../../features/p2p/presentation/p2p_my_ads_page.dart';
import '../../features/p2p/presentation/p2p_create_ad_page.dart';
import '../../features/p2p/presentation/p2p_merchant_apply_page.dart';
import '../../features/p2p/presentation/p2p_merchant_profile_page.dart';
import '../../features/p2p/presentation/p2p_my_orders_page.dart';
import '../../features/p2p/presentation/p2p_payment_method_cooling_period_page.dart';
import '../../features/p2p/presentation/p2p_payment_method_history_page.dart';
import '../../features/p2p/presentation/p2p_payment_method_add_page.dart';
import '../../features/p2p/presentation/p2p_payment_methods_page.dart';
import '../../features/p2p/presentation/p2p_payment_method_ownership_page.dart';
import '../../features/p2p/presentation/p2p_payment_method_verification_page.dart';
import '../../features/p2p/presentation/p2p_report_merchant_page.dart';
import '../../features/p2p/presentation/p2p_reviews_page.dart';
import '../../features/p2p/presentation/p2p_trading_level_page.dart';
import '../../features/profile/presentation/edit_profile_page.dart';
import '../../features/profile/presentation/activity_log_page.dart';
import '../../features/profile/presentation/api_management_page.dart';
import '../../features/profile/presentation/api_key_create_page.dart';
import '../../features/profile/presentation/device_management_page.dart';
import '../../features/profile/presentation/kyc_page.dart';
import '../../features/profile/presentation/profile_page.dart';
import '../../features/profile/presentation/security_page.dart';
import '../../features/profile/presentation/settings_page.dart';
import '../../features/profile/presentation/sub_account_page.dart';
import '../../features/profile/presentation/vip_page.dart';
import '../../features/referral/presentation/referral_friend_detail_page.dart';
import '../../features/referral/presentation/referral_history_page.dart';
import '../../features/referral/presentation/referral_home_page.dart';
import '../../features/referral/presentation/referral_rules_page.dart';
import '../../features/referral/presentation/referral_rewards_page.dart';
import '../../features/rewards/presentation/rewards_hub_page.dart';
import '../../features/launchpad/presentation/launchpad_batch_claim_page.dart';
import '../../features/launchpad/presentation/launchpad_abi_diff_page.dart';
import '../../features/launchpad/presentation/launchpad_address_book_page.dart';
import '../../features/launchpad/presentation/launchpad_bridge_compare_page.dart';
import '../../features/launchpad/presentation/launchpad_bridge_order_page.dart';
import '../../features/launchpad/presentation/launchpad_contract_page.dart';
import '../../features/launchpad/presentation/launchpad_claim_receipt_page.dart';
import '../../features/launchpad/presentation/launchpad_dca_builder_page.dart';
import '../../features/launchpad/presentation/launchpad_detail_page.dart';
import '../../features/launchpad/presentation/launchpad_event_log_page.dart';
import '../../features/launchpad/presentation/launchpad_gas_tracker_page.dart';
import '../../features/launchpad/presentation/launchpad_page.dart';
import '../../features/launchpad/presentation/launchpad_ido_bridge_page.dart';
import '../../features/launchpad/presentation/launchpad_limit_orders_page.dart';
import '../../features/launchpad/presentation/launchpad_multisig_page.dart';
import '../../features/launchpad/presentation/launchpad_notif_sound_page.dart';
import '../../features/launchpad/presentation/launchpad_performance_page.dart';
import '../../features/launchpad/presentation/launchpad_portfolio_page.dart';
import '../../features/launchpad/presentation/launchpad_rebalance_page.dart';
import '../../features/launchpad/presentation/launchpad_receipt_page.dart';
import '../../features/launchpad/presentation/launchpad_risk_analytics_page.dart';
import '../../features/launchpad/presentation/launchpad_staking_page.dart';
import '../../features/launchpad/presentation/launchpad_swap_aggregator_page.dart';
import '../../features/launchpad/presentation/launchpad_webhooks_page.dart';
import '../../features/support/presentation/announcements_page.dart';
import '../../features/support/presentation/help_center_page.dart';
import '../../features/support/presentation/support_page.dart';
import '../../features/trade/presentation/trade_page.dart';
import '../../features/trade/presentation/orders_history_page.dart';
import '../../features/trade/presentation/order_receipt_page.dart';
import '../../features/trade/presentation/ombudsman_referral_page.dart';
import '../../features/trade/presentation/trade_settings_page.dart';
import '../../features/trade/presentation/transaction_reporting_page.dart';
import '../../features/trade/presentation/position_dashboard_page.dart';
import '../../features/trade/presentation/trade_history_export_page.dart';
import '../../features/trade/presentation/advanced_chart_page.dart';
import '../../features/trade/presentation/advanced_analytics_page.dart';
import '../../features/trade/presentation/advanced_tools_demo_page.dart';
import '../../features/trade/presentation/advanced_trading_demo_page.dart';
import '../../features/trade/presentation/active_copies_page.dart';
import '../../features/trade/presentation/arm_integration_status_page.dart';
import '../../features/trade/presentation/audit_trail_page.dart';
import '../../features/trade/presentation/best_execution_reports_page.dart';
import '../../features/trade/presentation/bot_api_documentation_page.dart';
import '../../features/trade/presentation/bot_backtesting_page.dart';
import '../../features/trade/presentation/bot_drawdown_analyzer_page.dart';
import '../../features/trade/presentation/bot_equity_curve_page.dart';
import '../../features/trade/presentation/bot_faq_page.dart';
import '../../features/trade/presentation/bot_guide_page.dart';
import '../../features/trade/presentation/bot_history_page.dart';
import '../../features/trade/presentation/bot_optimization_page.dart';
import '../../features/trade/presentation/bot_performance_analytics_page.dart';
import '../../features/trade/presentation/bot_portfolio_dashboard_page.dart';
import '../../features/trade/presentation/bot_strategy_compare_page.dart';
import '../../features/trade/presentation/bot_tax_reporting_page.dart';
import '../../features/trade/presentation/bot_emergency_stop_page.dart';
import '../../features/trade/presentation/bot_risk_dashboard_page.dart';
import '../../features/trade/presentation/bot_risk_disclosure_page.dart';
import '../../features/trade/presentation/bot_security_settings_page.dart';
import '../../features/trade/presentation/bot_suitability_assessment_page.dart';
import '../../features/trade/presentation/bot_terms_of_service_page.dart';
import '../../features/trade/presentation/cass_reconciliation_page.dart';
import '../../features/trade/presentation/client_categorization_page.dart';
import '../../features/trade/presentation/client_money_protection_page.dart';
import '../../features/trade/presentation/complaint_submission_page.dart';
import '../../features/trade/presentation/complaint_tracking_page.dart';
import '../../features/trade/presentation/complaints_handling_page.dart';
import '../../features/trade/presentation/copy_audit_log_page.dart';
import '../../features/trade/presentation/copy_confirmation_page.dart';
import '../../features/trade/presentation/copy_education_page.dart';
import '../../features/trade/presentation/copy_configuration_page.dart';
import '../../features/trade/presentation/copy_notifications_page.dart';
import '../../features/trade/presentation/copy_performance_page.dart';
import '../../features/trade/presentation/copy_provider_detail_page.dart';
import '../../features/trade/presentation/copy_safety_center_page.dart';
import '../../features/trade/presentation/copy_settings_page.dart';
import '../../features/trade/presentation/copy_trading_card_demo.dart';
import '../../features/trade/presentation/copy_trading_page.dart';
import '../../features/trade/presentation/copy_trading_v2_page.dart';
import '../../features/trade/presentation/convert_page.dart';
import '../../features/trade/presentation/dispute_resolution_page.dart';
import '../../features/trade/presentation/ex_ante_costs_page.dart';
import '../../features/trade/presentation/ex_post_costs_report_page.dart';
import '../../features/trade/presentation/execution_quality_demo_page.dart';
import '../../features/trade/presentation/execution_venue_analysis_page.dart';
import '../../features/trade/presentation/futures_page.dart';
import '../../features/trade/presentation/investor_compensation_page.dart';
import '../../features/trade/presentation/kid_generator_page.dart';
import '../../features/trade/presentation/leverage_page.dart';
import '../../features/trade/presentation/live_market_data_analytics_page.dart';
import '../../features/trade/presentation/margin_trading_page.dart';
import '../../features/trade/presentation/margin_trading_hub_page.dart';
import '../../features/trade/presentation/market_data_analytics_page.dart';
import '../../features/trade/presentation/performance_attribution_page.dart';
import '../../features/trade/presentation/performance_scenarios_page.dart';
import '../../features/trade/presentation/pre_copy_assessment_page.dart';
import '../../features/trade/presentation/portfolio_risk_analysis_page.dart';
import '../../features/trade/presentation/product_governance_page.dart';
import '../../features/trade/presentation/provider_comparison_page.dart';
import '../../features/trade/presentation/provider_governance_page.dart';
import '../../features/trade/presentation/provider_leaderboard_page.dart';
import '../../features/trade/presentation/provider_application_page.dart';
import '../../features/trade/presentation/regulatory_disclosures_page.dart';
import '../../features/trade/presentation/regulatory_inspection_ready_page.dart';
import '../../features/trade/presentation/regulatory_reports_dashboard_page.dart';
import '../../features/trade/presentation/risk_indicator_explainer_page.dart';
import '../../features/trade/presentation/risk_management_demo_page.dart';
import '../../features/trade/presentation/riy_calculator_page.dart';
import '../../features/trade/presentation/safety_education_page.dart';
import '../../features/trade/presentation/slippage_monitoring_page.dart';
import '../../features/trade/presentation/target_market_definition_page.dart';
import '../../features/trade/presentation/trading_bots_page.dart';
import '../../features/trade/presentation/trader_profile_page.dart';
import '../../features/wallet/presentation/address_add_page.dart';
import '../../features/wallet/presentation/address_book_page.dart';
import '../../features/wallet/presentation/asset_detail_page.dart';
import '../../features/wallet/presentation/buy_crypto_page.dart';
import '../../features/wallet/presentation/deposit_page.dart';
import '../../features/wallet/presentation/dust_converter_page.dart';
import '../../features/wallet/presentation/network_status_page.dart';
import '../../features/wallet/presentation/pending_deposits_page.dart';
import '../../features/wallet/presentation/portfolio_analytics_page.dart';
import '../../features/wallet/presentation/transaction_detail_page.dart';
import '../../features/wallet/presentation/transaction_history_page.dart';
import '../../features/wallet/presentation/transfer_page.dart';
import '../../features/wallet/presentation/wallet_gas_optimizer_page.dart';
import '../../features/wallet/presentation/wallet_health_score_page.dart';
import '../../features/wallet/presentation/wallet_multi_manager_page.dart';
import '../../features/wallet/presentation/wallet_page.dart';
import '../../features/wallet/presentation/wallet_token_approval_page.dart';
import '../../features/wallet/presentation/withdraw_page.dart';
import '../../features/wallet/presentation/withdraw_limits_page.dart';
import '../../app/theme/app_colors.dart';
import '../../shared/layout/vit_app_shell.dart';
import '../../shared/layout/vit_bottom_nav.dart';
import '../../shared/layout/vit_header.dart';
import '../../shared/layout/vit_page_content.dart';
import '../../shared/layout/vit_page_layout.dart';
import '../../shared/layout/shell_render_mode.dart';
import '../../shared/layout/vit_phone_frame.dart';
import '../../shared/layout/vit_status_bar.dart';

final class AppRouteNames {
  const AppRouteNames._();

  static const String sc001Login = 'sc001Login';
  static const String sc002Register = 'sc002Register';
  static const String sc003Otp = 'sc003Otp';
  static const String sc004TwoFaSetup = 'sc004TwoFaSetup';
  static const String sc005ForgotPassword = 'sc005ForgotPassword';
  static const String sc006ResetPassword = 'sc006ResetPassword';
  static const String sc007Home = 'sc007Home';
  static const String sc008MarketList = 'sc008MarketList';
  static const String sc009MarketOverview = 'sc009MarketOverview';
  static const String sc010MarketMovers = 'sc010MarketMovers';
  static const String sc011MarketSectors = 'sc011MarketSectors';
  static const String sc012Watchlist = 'sc012Watchlist';
  static const String sc013MarketHeatmap = 'sc013MarketHeatmap';
  static const String sc014PriceAlerts = 'sc014PriceAlerts';
  static const String sc015MarketScreener = 'sc015MarketScreener';
  static const String sc016ComparisonTool = 'sc016ComparisonTool';
  static const String sc017MarketCalendar = 'sc017MarketCalendar';
  static const String sc018DerivativesOverview = 'sc018DerivativesOverview';
  static const String sc019MarketDepth = 'sc019MarketDepth';
  static const String sc020SocialSentiment = 'sc020SocialSentiment';
  static const String sc021PortfolioTracker = 'sc021PortfolioTracker';
  static const String sc022MarketNews = 'sc022MarketNews';
  static const String sc023AdvancedCharts = 'sc023AdvancedCharts';
  static const String sc024TokenUnlocks = 'sc024TokenUnlocks';
  static const String sc025SocialSignals = 'sc025SocialSignals';
  static const String sc026MarketCorrelations = 'sc026MarketCorrelations';
  static const String sc027PredictionsHome = 'sc027PredictionsHome';
  static const String sc028PredictionsSearch = 'sc028PredictionsSearch';
  static const String sc029PredictionsBreaking = 'sc029PredictionsBreaking';
  static const String sc030PredictionEventDetail = 'sc030PredictionEventDetail';
  static const String sc031PredictionsPortfolio = 'sc031PredictionsPortfolio';
  static const String sc032PredictionsRewards = 'sc032PredictionsRewards';
  static const String sc033PredictionsLeaderboard =
      'sc033PredictionsLeaderboard';
  static const String sc034PredictionsGlobalActivity =
      'sc034PredictionsGlobalActivity';
  static const String sc035PredictionOrderReceipt =
      'sc035PredictionOrderReceipt';
  static const String sc036PredictionRiskCalculator =
      'sc036PredictionRiskCalculator';
  static const String sc037PredictionMarketMaker = 'sc037PredictionMarketMaker';
  static const String sc038PredictionPortfolioAnalyzer =
      'sc038PredictionPortfolioAnalyzer';
  static const String sc039PredictionEventCalendar =
      'sc039PredictionEventCalendar';
  static const String sc040PredictionSocial = 'sc040PredictionSocial';
  static const String sc041PredictionAdvancedChart =
      'sc041PredictionAdvancedChart';
  static const String sc042PredictionTournaments = 'sc042PredictionTournaments';
  static const String sc043PredictionDataIntegration =
      'sc043PredictionDataIntegration';
  static const String sc044PairDetail = 'sc044PairDetail';
  static const String sc045TokenInfo = 'sc045TokenInfo';
  static const String sc046PairDepth = 'sc046PairDepth';
  static const String sc047News = 'sc047News';
  static const String sc048Trade = 'sc048Trade';
  static const String sc049TradePair = 'sc049TradePair';
  static const String sc050OrdersHistory = 'sc050OrdersHistory';
  static const String sc051OrderReceipt = 'sc051OrderReceipt';
  static const String sc052TradeSettings = 'sc052TradeSettings';
  static const String sc053PositionDashboard = 'sc053PositionDashboard';
  static const String sc054TradeHistoryExport = 'sc054TradeHistoryExport';
  static const String sc055AdvancedChart = 'sc055AdvancedChart';
  static const String sc056Convert = 'sc056Convert';
  static const String sc057Futures = 'sc057Futures';
  static const String sc058Leverage = 'sc058Leverage';
  static const String sc059TradingBots = 'sc059TradingBots';
  static const String sc060RiskManagement = 'sc060RiskManagement';
  static const String sc061ExecutionQuality = 'sc061ExecutionQuality';
  static const String sc062AdvancedTools = 'sc062AdvancedTools';
  static const String sc063CopyTrading = 'sc063CopyTrading';
  static const String sc064CopyTradingV2 = 'sc064CopyTradingV2';
  static const String sc065CopyEducation = 'sc065CopyEducation';
  static const String sc066ActiveCopies = 'sc066ActiveCopies';
  static const String sc067CopySettings = 'sc067CopySettings';
  static const String sc068CopyNotifications = 'sc068CopyNotifications';
  static const String sc069ProviderApplication = 'sc069ProviderApplication';
  static const String sc070CopyProviderDetail = 'sc070CopyProviderDetail';
  static const String sc071PreCopyAssessment = 'sc071PreCopyAssessment';
  static const String sc072CopyConfiguration = 'sc072CopyConfiguration';
  static const String sc073CopyConfirmation = 'sc073CopyConfirmation';
  static const String sc074CopyPerformance = 'sc074CopyPerformance';
  static const String sc075PerformanceAttribution =
      'sc075PerformanceAttribution';
  static const String sc076ProviderComparison = 'sc076ProviderComparison';
  static const String sc077CopyAuditLog = 'sc077CopyAuditLog';
  static const String sc078PortfolioRiskAnalysis = 'sc078PortfolioRiskAnalysis';
  static const String sc079ProviderLeaderboard = 'sc079ProviderLeaderboard';
  static const String sc080SafetyEducation = 'sc080SafetyEducation';
  static const String sc081ProviderGovernance = 'sc081ProviderGovernance';
  static const String sc082DisputeResolution = 'sc082DisputeResolution';
  static const String sc083CopySafetyCenter = 'sc083CopySafetyCenter';
  static const String sc084RegulatoryDisclosures = 'sc084RegulatoryDisclosures';
  static const String sc085MarginTrading = 'sc085MarginTrading';
  static const String sc086MarginTradingPair = 'sc086MarginTradingPair';
  static const String sc087TraderProfile = 'sc087TraderProfile';
  static const String sc088AdvancedTradingDemo = 'sc088AdvancedTradingDemo';
  static const String sc089MarketDataAnalytics = 'sc089MarketDataAnalytics';
  static const String sc090MarginTradingHub = 'sc090MarginTradingHub';
  static const String sc091LiveMarketDataAnalytics =
      'sc091LiveMarketDataAnalytics';
  static const String sc092AdvancedAnalytics = 'sc092AdvancedAnalytics';
  static const String sc093TransactionReporting = 'sc093TransactionReporting';
  static const String sc094RegulatoryReportsDashboard =
      'sc094RegulatoryReportsDashboard';
  static const String sc095ArmIntegrationStatus = 'sc095ArmIntegrationStatus';
  static const String sc096BestExecutionReports = 'sc096BestExecutionReports';
  static const String sc097ExecutionVenueAnalysis =
      'sc097ExecutionVenueAnalysis';
  static const String sc098SlippageMonitoring = 'sc098SlippageMonitoring';
  static const String sc099ClientCategorization = 'sc099ClientCategorization';
  static const String sc100ProductGovernance = 'sc100ProductGovernance';
  static const String sc101TargetMarketDefinition =
      'sc101TargetMarketDefinition';
  static const String sc102ClientMoneyProtection = 'sc102ClientMoneyProtection';
  static const String sc103CassReconciliation = 'sc103CassReconciliation';
  static const String sc104InvestorCompensation = 'sc104InvestorCompensation';
  static const String sc105ExAnteCosts = 'sc105ExAnteCosts';
  static const String sc106RiyCalculator = 'sc106RiyCalculator';
  static const String sc107ExPostCostsReport = 'sc107ExPostCostsReport';
  static const String sc108KidGenerator = 'sc108KidGenerator';
  static const String sc109PerformanceScenarios = 'sc109PerformanceScenarios';
  static const String sc110RiskIndicatorExplainer =
      'sc110RiskIndicatorExplainer';
  static const String sc111ComplaintsHandling = 'sc111ComplaintsHandling';
  static const String sc112ComplaintSubmission = 'sc112ComplaintSubmission';
  static const String sc113ComplaintTracking = 'sc113ComplaintTracking';
  static const String sc114OmbudsmanReferral = 'sc114OmbudsmanReferral';
  static const String sc115AuditTrail = 'sc115AuditTrail';
  static const String sc116RegulatoryInspectionReady =
      'sc116RegulatoryInspectionReady';
  static const String sc117BotTermsOfService = 'sc117BotTermsOfService';
  static const String sc118BotRiskDisclosure = 'sc118BotRiskDisclosure';
  static const String sc119BotSuitabilityAssessment =
      'sc119BotSuitabilityAssessment';
  static const String sc120BotRiskDashboard = 'sc120BotRiskDashboard';
  static const String sc121BotEmergencyStop = 'sc121BotEmergencyStop';
  static const String sc122BotSecuritySettings = 'sc122BotSecuritySettings';
  static const String sc123BotHistory = 'sc123BotHistory';
  static const String sc124BotPerformanceAnalytics =
      'sc124BotPerformanceAnalytics';
  static const String sc125BotBacktesting = 'sc125BotBacktesting';
  static const String sc126BotStrategyCompare = 'sc126BotStrategyCompare';
  static const String sc127BotOptimization = 'sc127BotOptimization';
  static const String sc128BotPortfolioDashboard = 'sc128BotPortfolioDashboard';
  static const String sc129BotDrawdownAnalyzer = 'sc129BotDrawdownAnalyzer';
  static const String sc130BotEquityCurve = 'sc130BotEquityCurve';
  static const String sc131BotGuide = 'sc131BotGuide';
  static const String sc132BotFaq = 'sc132BotFaq';
  static const String sc133BotTaxReporting = 'sc133BotTaxReporting';
  static const String sc134BotApiDocumentation = 'sc134BotApiDocumentation';
  static const String sc135Wallet = 'sc135Wallet';
  static const String sc136TxHistory = 'sc136TxHistory';
  static const String sc137Deposit = 'sc137Deposit';
  static const String sc138DepositUsdt = 'sc138DepositUsdt';
  static const String sc139Withdraw = 'sc139Withdraw';
  static const String sc140WithdrawUsdt = 'sc140WithdrawUsdt';
  static const String sc141TransactionDetail = 'sc141TransactionDetail';
  static const String sc142PortfolioAnalytics = 'sc142PortfolioAnalytics';
  static const String sc143AddressAdd = 'sc143AddressAdd';
  static const String sc144AddressBook = 'sc144AddressBook';
  static const String sc145BuyCrypto = 'sc145BuyCrypto';
  static const String sc146Transfer = 'sc146Transfer';
  static const String sc147AssetDetail = 'sc147AssetDetail';
  static const String sc148MultiManager = 'sc148MultiManager';
  static const String sc149GasOptimizer = 'sc149GasOptimizer';
  static const String sc150TokenApproval = 'sc150TokenApproval';
  static const String sc151HealthScore = 'sc151HealthScore';
  static const String sc152PendingDeposits = 'sc152PendingDeposits';
  static const String sc153WithdrawLimits = 'sc153WithdrawLimits';
  static const String sc154DustConverter = 'sc154DustConverter';
  static const String sc155NetworkStatus = 'sc155NetworkStatus';
  static const String sc156Profile = 'sc156Profile';
  static const String sc157EditProfile = 'sc157EditProfile';
  static const String sc158Security = 'sc158Security';
  static const String sc159Kyc = 'sc159Kyc';
  static const String sc160Settings = 'sc160Settings';
  static const String sc161ActivityLog = 'sc161ActivityLog';
  static const String sc162ApiKeyCreate = 'sc162ApiKeyCreate';
  static const String sc163ApiManagement = 'sc163ApiManagement';
  static const String sc164Vip = 'sc164Vip';
  static const String sc165DeviceManagement = 'sc165DeviceManagement';
  static const String sc166SubAccount = 'sc166SubAccount';
  static const String sc167ProfilePredictions = 'sc167ProfilePredictions';
  static const String sc168MyArena = 'sc168MyArena';
  static const String sc169Dca = 'sc169Dca';
  static const String sc170DcaRebalanceConfig = 'sc170DcaRebalanceConfig';
  static const String sc171DcaRebalanceDashboard = 'sc171DcaRebalanceDashboard';
  static const String sc172DcaScheduleConfig = 'sc172DcaScheduleConfig';
  static const String sc173DcaScheduleAnalytics = 'sc173DcaScheduleAnalytics';
  static const String sc174DcaPortfolioOptimizer = 'sc174DcaPortfolioOptimizer';
  static const String sc175DcaDynamicAmount = 'sc175DcaDynamicAmount';
  static const String sc176DcaBacktester = 'sc176DcaBacktester';
  static const String sc177DcaMultiAsset = 'sc177DcaMultiAsset';
  static const String sc178DcaPerformanceCompare = 'sc178DcaPerformanceCompare';
  static const String sc179DcaSmartRules = 'sc179DcaSmartRules';
  static const String sc180AdminHome = 'sc180AdminHome';
  static const String sc181AnalyticsDashboard = 'sc181AnalyticsDashboard';
  static const String sc182AbTestDashboard = 'sc182AbTestDashboard';
  static const String sc183FunnelDashboard = 'sc183FunnelDashboard';
  static const String sc184ArenaHome = 'sc184ArenaHome';
  static const String sc185ArenaStudio = 'sc185ArenaStudio';
  static const String sc186ArenaSmartRules = 'sc186ArenaSmartRules';
  static const String sc187ArenaPresetLibrary = 'sc187ArenaPresetLibrary';
  static const String sc188ArenaGovernanceGate = 'sc188ArenaGovernanceGate';
  static const String sc189ArenaModeDetail = 'sc189ArenaModeDetail';
  static const String sc190ArenaChallengeDetail = 'sc190ArenaChallengeDetail';
  static const String sc191ArenaJoin = 'sc191ArenaJoin';
  static const String sc192ArenaResolutionCenter = 'sc192ArenaResolutionCenter';
  static const String sc193ArenaCreator = 'sc193ArenaCreator';
  static const String sc194ArenaLeaderboard = 'sc194ArenaLeaderboard';
  static const String sc195VerifiedChallenges = 'sc195VerifiedChallenges';
  static const String sc196ArenaPoints = 'sc196ArenaPoints';
  static const String sc197ArenaFlowMap = 'sc197ArenaFlowMap';
  static const String sc198ArenaSafetyCenter = 'sc198ArenaSafetyCenter';
  static const String sc199ArenaTrustBreakdown = 'sc199ArenaTrustBreakdown';
  static const String sc200ArenaPointsEntryDetail =
      'sc200ArenaPointsEntryDetail';
  static const String sc201ArenaPointsLedger = 'sc201ArenaPointsLedger';
  static const String sc202ArenaReportCase = 'sc202ArenaReportCase';
  static const String sc203ArenaBlockedUsers = 'sc203ArenaBlockedUsers';
  static const String sc204MyArenaReports = 'sc204MyArenaReports';
  static const String sc205MyArena = 'sc205MyArena';
  static const String sc206ArenaProductionReady = 'sc206ArenaProductionReady';
  static const String sc207ArenaPredictionBridgeFoundation =
      'sc207ArenaPredictionBridgeFoundation';
  static const String sc208ConnectedEcosystemProduction =
      'sc208ConnectedEcosystemProduction';
  static const String sc209ArenaGuide = 'sc209ArenaGuide';
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
  static const String sc283UnifiedSearch = 'sc283UnifiedSearch';
  static const String sc284TopicHub = 'sc284TopicHub';
  static const String sc285TopicCrypto = 'sc285TopicCrypto';
  static const String sc286ReferralHistory = 'sc286ReferralHistory';
  static const String sc287ReferralRewards = 'sc287ReferralRewards';
  static const String sc288ReferralRules = 'sc288ReferralRules';
  static const String sc289ReferralFriendDetail = 'sc289ReferralFriendDetail';
  static const String sc290ReferralHome = 'sc290ReferralHome';
  static const String sc291Notifications = 'sc291Notifications';
  static const String sc292HelpCenter = 'sc292HelpCenter';
  static const String sc293Announcements = 'sc293Announcements';
  static const String sc294Support = 'sc294Support';
  static const String sc295Launchpad = 'sc295Launchpad';
  static const String sc296LaunchpadPortfolio = 'sc296LaunchpadPortfolio';
  static const String sc297LaunchpadPerformance = 'sc297LaunchpadPerformance';
  static const String sc298LaunchpadStaking = 'sc298LaunchpadStaking';
  static const String sc299LaunchpadIdoBridge = 'sc299LaunchpadIdoBridge';
  static const String sc300LaunchpadContract = 'sc300LaunchpadContract';
  static const String sc301LaunchpadReceipt = 'sc301LaunchpadReceipt';
  static const String sc302LaunchpadClaimReceipt = 'sc302LaunchpadClaimReceipt';
  static const String sc303LaunchpadBridgeOrder = 'sc303LaunchpadBridgeOrder';
  static const String sc304LaunchpadBatchClaim = 'sc304LaunchpadBatchClaim';
  static const String sc305LaunchpadBridgeCompare =
      'sc305LaunchpadBridgeCompare';
  static const String sc306LaunchpadNotifSound = 'sc306LaunchpadNotifSound';
  static const String sc307LaunchpadEventLog = 'sc307LaunchpadEventLog';
  static const String sc308LaunchpadAbiDiff = 'sc308LaunchpadAbiDiff';
  static const String sc309LaunchpadAddressBook = 'sc309LaunchpadAddressBook';
  static const String sc310LaunchpadWebhooks = 'sc310LaunchpadWebhooks';
  static const String sc311LaunchpadGasTracker = 'sc311LaunchpadGasTracker';
  static const String sc312LaunchpadRebalance = 'sc312LaunchpadRebalance';
  static const String sc313LaunchpadMultisig = 'sc313LaunchpadMultisig';
  static const String sc314LaunchpadSwapAggregator =
      'sc314LaunchpadSwapAggregator';
  static const String sc315LaunchpadLimitOrders = 'sc315LaunchpadLimitOrders';
  static const String sc316LaunchpadDcaBuilder = 'sc316LaunchpadDcaBuilder';
  static const String sc317LaunchpadRiskAnalytics =
      'sc317LaunchpadRiskAnalytics';
  static const String sc318LaunchpadDetail = 'sc318LaunchpadDetail';
  static const String sc319RewardsHub = 'sc319RewardsHub';
  static const String sc320EnterpriseStates = 'sc320EnterpriseStates';
  static const String sc321UnifiedPortfolio = 'sc321UnifiedPortfolio';
  static const String sc322CrossModuleAnalytics = 'sc322CrossModuleAnalytics';
  static const String sc323SmartAlertCenter = 'sc323SmartAlertCenter';
  static const String sc324TaxReportCenter = 'sc324TaxReportCenter';
  static const String sc325RouteChecker = 'sc325RouteChecker';
  static const String sc326PerformanceMonitor = 'sc326PerformanceMonitor';
  static const String sc398MissingScreensShowcase =
      'sc398MissingScreensShowcase';
  static const String sc399DesignSystem = 'sc399DesignSystem';
  static const String sc400DcaOverviewDemo = 'sc400DcaOverviewDemo';
  static const String sc401CopyTradingCardDemo = 'sc401CopyTradingCardDemo';
  static const String sc327StakingEarn = 'sc327StakingEarn';
  static const String sc328StakingEarnStaking = 'sc328StakingEarnStaking';
  static const String sc329Savings = 'sc329Savings';
  static const String sc330SavingsProductDetail = 'sc330SavingsProductDetail';
  static const String sc331SavingsRedeem = 'sc331SavingsRedeem';
  static const String sc332SavingsReceipt = 'sc332SavingsReceipt';
  static const String sc333SavingsPortfolio = 'sc333SavingsPortfolio';
  static const String sc334SavingsHistory = 'sc334SavingsHistory';
  static const String sc335SavingsGuide = 'sc335SavingsGuide';
  static const String sc336SavingsFAQ = 'sc336SavingsFAQ';
  static const String sc337SavingsNotifications = 'sc337SavingsNotifications';
  static const String sc338SavingsRecommendations =
      'sc338SavingsRecommendations';
  static const String sc339SavingsRiskAssessment = 'sc339SavingsRiskAssessment';
  static const String sc340SavingsComparison = 'sc340SavingsComparison';
  static const String sc341AutoCompoundSettings = 'sc341AutoCompoundSettings';
  static const String sc342SavingsGoal = 'sc342SavingsGoal';
  static const String sc343SavingsAnalytics = 'sc343SavingsAnalytics';
  static const String sc344SavingsAutoRebalance = 'sc344SavingsAutoRebalance';
  static const String sc345SavingsNotificationPreferences =
      'sc345SavingsNotificationPreferences';
  static const String sc346SavingsDca = 'sc346SavingsDca';
  static const String sc347SavingsSmartSuggestions =
      'sc347SavingsSmartSuggestions';
  static const String sc348SavingsExport = 'sc348SavingsExport';
  static const String sc349SavingsBacktest = 'sc349SavingsBacktest';
  static const String sc350SavingsAutoPilot = 'sc350SavingsAutoPilot';
  static const String sc351SavingsLadder = 'sc351SavingsLadder';
  static const String sc352SavingsWhatIf = 'sc352SavingsWhatIf';
  static const String sc353StakingTerms = 'sc353StakingTerms';
  static const String sc354StakingRiskDisclosure = 'sc354StakingRiskDisclosure';
  static const String sc355StakingWithdrawalPolicy =
      'sc355StakingWithdrawalPolicy';
  static const String sc356StakingTaxGuide = 'sc356StakingTaxGuide';
  static const String sc357StakingRiskAssessment = 'sc357StakingRiskAssessment';
  static const String sc358StakingDashboard = 'sc358StakingDashboard';
  static const String sc359StakingAnalytics = 'sc359StakingAnalytics';
  static const String sc360StakingHistory = 'sc360StakingHistory';
  static const String sc361StakingEarningsCalendar =
      'sc361StakingEarningsCalendar';
  static const String sc362StakingValidatorSelection =
      'sc362StakingValidatorSelection';
  static const String sc363StakingAutoCompound = 'sc363StakingAutoCompound';
  static const String sc364StakingLiquidStaking = 'sc364StakingLiquidStaking';
  static const String sc365StakingInsurance = 'sc365StakingInsurance';
  static const String sc366StakingAdvancedOrders = 'sc366StakingAdvancedOrders';
  static const String sc367StakingMultiChain = 'sc367StakingMultiChain';
  static const String sc368StakingInstitutional = 'sc368StakingInstitutional';
  static const String sc369StakingGuide = 'sc369StakingGuide';
  static const String sc370StakingFAQ = 'sc370StakingFAQ';
  static const String sc371StakingNotifications = 'sc371StakingNotifications';
  static const String sc372StakingRecommendations =
      'sc372StakingRecommendations';
  static const String sc373StakingRegulatoryFramework =
      'sc373StakingRegulatoryFramework';
  static const String sc374StakingAuditReports = 'sc374StakingAuditReports';
  static const String sc375StakingCustody = 'sc375StakingCustody';
  static const String sc376StakingSuitabilityAssessment =
      'sc376StakingSuitabilityAssessment';
  static const String sc377StakingInsuranceFundTransparency =
      'sc377StakingInsuranceFundTransparency';
  static const String sc378StakingTransactionReporting =
      'sc378StakingTransactionReporting';
  static const String sc379StakingApiDocumentation =
      'sc379StakingApiDocumentation';
  static const String sc380StakingProofOfReserves =
      'sc380StakingProofOfReserves';
  static const String sc381StakingRiskDashboard = 'sc381StakingRiskDashboard';
  static const String sc382StakingSlashingHistory =
      'sc382StakingSlashingHistory';
  static const String sc383StakingValidatorHealthMonitor =
      'sc383StakingValidatorHealthMonitor';
  static const String sc384StakingRiskScoreCalculator =
      'sc384StakingRiskScoreCalculator';
  static const String sc385StakingEmergencyActions =
      'sc385StakingEmergencyActions';
  static const String sc386StakingContingencyPlan =
      'sc386StakingContingencyPlan';
  static const String sc387StakingSocialFeed = 'sc387StakingSocialFeed';
  static const String sc388StakingCommunityGovernance =
      'sc388StakingCommunityGovernance';
  static const String sc389StakingProposals = 'sc389StakingProposals';
  static const String sc390StakingVotingDetail = 'sc390StakingVotingDetail';
  static const String sc391StakingVoting = 'sc391StakingVoting';
  static const String sc392StakingForum = 'sc392StakingForum';
  static const String sc393StakingWebhooks = 'sc393StakingWebhooks';
  static const String sc394StakingDataExport = 'sc394StakingDataExport';
  static const String sc395StakingThirdPartyIntegrations =
      'sc395StakingThirdPartyIntegrations';
  static const String sc396StakingDeveloperConsole =
      'sc396StakingDeveloperConsole';
  static const String sc397Onboarding = 'sc397Onboarding';
}

final class AppRoutePaths {
  const AppRoutePaths._();

  static const String root = '/';
  static const String authLogin = '/auth/login';
  static const String authRegister = '/auth/register';
  static const String authOtp = '/auth/otp';
  static const String auth2faSetup = '/auth/2fa-setup';
  static const String authForgotPassword = '/auth/forgot-password';
  static const String authResetPassword = '/auth/reset-password';
  static const String home = '/home';
  static const String search = '/search';
  static const String topics = '/topics';
  static const String topicCrypto = '/topic/crypto';
  static const String referral = '/referral';
  static const String referralHistory = '/referral/history';
  static const String referralRewards = '/referral/rewards';
  static const String referralRules = '/referral/rules';
  static String referralFriend(String friendId) => '/referral/friend/$friendId';
  static const String enterpriseStates = '/enterprise-states';
  static const String unifiedPortfolio = '/unified-portfolio';
  static const String crossModuleAnalytics = '/cross-module-analytics';
  static const String smartAlerts = '/smart-alerts';
  static const String taxReports = '/tax-reports';
  static const String routeChecker = '/dev/route-checker';
  static const String performanceMonitor = '/dev/performance-monitor';
  static const String devShowcase = '/dev/showcase';
  static const String devDesignSystem = '/dev/design-system';
  static const String devDcaOverview = '/dev/dca-overview';
  static const String demoCopyCard = '/demo/copy-card';
  static const String earn = '/earn';
  static const String earnStaking = '/earn/staking';
  static const String earnStakingTerms = '/earn/staking/terms';
  static const String earnStakingRiskDisclosure =
      '/earn/staking/risk-disclosure';
  static const String earnStakingWithdrawalPolicy =
      '/earn/staking/withdrawal-policy';
  static const String earnStakingTaxGuide = '/earn/staking/tax-guide';
  static const String earnStakingRiskAssessment =
      '/earn/staking/risk-assessment';
  static const String earnDashboard = '/earn/dashboard';
  static const String earnAnalytics = '/earn/analytics';
  static const String earnCalendar = '/earn/calendar';
  static const String earnHistory = '/earn/history';
  static const String earnValidatorSelection = '/earn/validator-selection';
  static const String earnAutoCompound = '/earn/auto-compound';
  static const String earnLiquidStaking = '/earn/liquid-staking';
  static const String earnInsurance = '/earn/insurance';
  static const String earnAdvancedOrders = '/earn/advanced-orders';
  static const String earnMultiChain = '/earn/multi-chain';
  static const String earnInstitutional = '/earn/institutional';
  static const String earnGuide = '/earn/guide';
  static const String earnFAQ = '/earn/faq';
  static const String earnNotifications = '/earn/notifications';
  static const String earnRecommendations = '/earn/recommendations';
  static const String earnRegulatoryFramework = '/earn/regulatory-framework';
  static const String earnAuditReports = '/earn/audit-reports';
  static const String earnCustody = '/earn/custody';
  static const String earnSuitabilityAssessment =
      '/earn/suitability-assessment';
  static const String earnInsuranceFundTransparency =
      '/earn/insurance-fund-transparency';
  static const String earnTransactionReporting = '/earn/transaction-reporting';
  static const String earnApiDocumentation = '/earn/api-documentation';
  static const String earnProofOfReserves = '/earn/proof-of-reserves';
  static const String earnRiskDashboard = '/earn/risk-dashboard';
  static const String earnSlashingHistory = '/earn/slashing-history';
  static const String earnValidatorHealthMonitor =
      '/earn/validator-health-monitor';
  static const String earnRiskScoreCalculator = '/earn/risk-score-calculator';
  static const String earnEmergencyActions = '/earn/emergency-actions';
  static const String earnContingencyPlan = '/earn/contingency-plan';
  static const String earnSocialFeed = '/earn/social-feed';
  static const String earnCommunityGovernance = '/earn/community-governance';
  static const String earnProposals = '/earn/proposals';
  static const String earnVoting = '/earn/voting';
  static String earnVotingProposal(String proposalId) =>
      '/earn/voting/$proposalId';
  static const String earnVotingProposalRoute = '/earn/voting/:proposalId';
  static const String earnForum = '/earn/forum';
  static const String earnWebhooks = '/earn/webhooks';
  static const String earnDataExport = '/earn/data-export';
  static const String earnThirdPartyIntegrations =
      '/earn/third-party-integrations';
  static const String earnDeveloperConsole = '/earn/developer-console';
  static const String earnSavings = '/earn/savings';
  static const String earnSavingsPortfolio = '/earn/savings/portfolio';
  static const String earnSavingsHistory = '/earn/savings/history';
  static const String earnSavingsGuide = '/earn/savings/guide';
  static const String earnSavingsFAQ = '/earn/savings/faq';
  static const String earnSavingsNotifications = '/earn/savings/notifications';
  static const String earnSavingsRecommendations =
      '/earn/savings/recommendations';
  static const String earnSavingsRiskAssessment =
      '/earn/savings/risk-assessment';
  static const String earnSavingsComparison = '/earn/savings/comparison';
  static const String earnSavingsAutoCompound = '/earn/savings/auto-compound';
  static const String earnSavingsGoals = '/earn/savings/goals';
  static const String earnSavingsAnalytics = '/earn/savings/analytics';
  static const String earnSavingsRebalance = '/earn/savings/rebalance';
  static const String earnSavingsNotificationPreferences =
      '/earn/savings/notification-preferences';
  static const String earnSavingsDca = '/earn/savings/dca';
  static const String earnSavingsSmartSuggestions =
      '/earn/savings/smart-suggestions';
  static const String earnSavingsExport = '/earn/savings/export';
  static const String earnSavingsBacktest = '/earn/savings/backtest';
  static const String earnSavingsAutoPilot = '/earn/savings/autopilot';
  static const String earnSavingsLadder = '/earn/savings/ladder';
  static const String earnSavingsWhatIf = '/earn/savings/whatif';
  static const String earnSavingsProductSample = '/earn/savings/product/sample';
  static const String earnSavingsRedeemPos001 = '/earn/savings/redeem/pos001';
  static const String earnSavingsReceipt = '/earn/savings/receipt';
  static const String notifications = '/notifications';
  static const String support = '/support';
  static const String supportAnnouncements = '/support/announcements';
  static const String launchpad = '/launchpad';
  static const String launchpadPortfolio = '/launchpad/portfolio';
  static const String launchpadPerformance = '/launchpad/performance';
  static const String launchpadStaking = '/launchpad/staking';
  static const String launchpadBatchClaim = '/launchpad/batch-claim';
  static const String launchpadClaimReceiptPos001 =
      '/launchpad/claim-receipt/pos001';
  static const String launchpadIdoBridgeSample = '/launchpad/idobridge/sample';
  static const String launchpadBridgeCompare = '/launchpad/bridge-compare';
  static const String launchpadBridgeOrderTx001 =
      '/launchpad/bridge-order/tx001';
  static const String launchpadContractSample = '/launchpad/contract/sample';
  static const String launchpadReceiptSub001 = '/launchpad/receipt/sub001';
  static const String launchpadSample = '/launchpad/sample';
  static const String launchpadNotifSound = '/launchpad/notif-sound';
  static const String launchpadEventLog = '/launchpad/event-log';
  static const String launchpadAbiDiff = '/launchpad/abi-diff/contract001';
  static const String launchpadAddressBook = '/launchpad/address-book';
  static const String launchpadWebhooks = '/launchpad/webhooks';
  static const String launchpadGasTracker = '/launchpad/gas-tracker';
  static const String launchpadRebalance = '/launchpad/rebalance';
  static const String launchpadMultisig = '/launchpad/multisig';
  static const String launchpadSwapAggregator = '/launchpad/swap-aggregator';
  static const String launchpadLimitOrders = '/launchpad/limit-orders';
  static const String launchpadDcaBuilder = '/launchpad/dca-builder';
  static const String launchpadRiskAnalytics = '/launchpad/risk-analytics';
  static const String news = '/news';
  static const String markets = '/markets';
  static const String marketsOverview = '/markets/overview';
  static const String marketsMovers = '/markets/movers';
  static const String marketsSectors = '/markets/sectors';
  static const String marketsWatchlist = '/markets/watchlist';
  static const String marketsHeatmap = '/markets/heatmap';
  static const String marketsAlerts = '/markets/alerts';
  static const String marketsScreener = '/markets/screener';
  static const String marketsCompare = '/markets/compare';
  static const String marketsCalendar = '/markets/calendar';
  static const String marketsDerivatives = '/markets/derivatives';
  static const String marketsDepth = '/markets/depth';
  static const String marketsSocialSentiment = '/markets/social-sentiment';
  static const String marketsPortfolioTracker = '/markets/portfolio-tracker';
  static const String marketsNews = '/markets/news';
  static const String marketsAdvancedCharts = '/markets/advanced-charts';
  static const String marketsUnlocks = '/markets/unlocks';
  static const String marketsSignals = '/markets/signals';
  static const String marketsCorrelations = '/markets/correlations';
  static const String marketsPredictions = '/markets/predictions';
  static const String marketsPredictionsSearch = '/markets/predictions/search';
  static const String marketsPredictionsBreaking =
      '/markets/predictions/breaking';
  static const String marketsPredictionsPortfolio =
      '/markets/predictions/portfolio';
  static String marketsPredictionEvent(String eventId) =>
      '/markets/predictions/event/$eventId';
  static String marketsPredictionReceipt(String receiptId) =>
      '/markets/predictions/receipt/$receiptId';
  static const String marketsPredictionsRewards =
      '/markets/predictions/rewards';
  static const String marketsPredictionsLeaderboard =
      '/markets/predictions/leaderboard';
  static const String marketsPredictionsActivity =
      '/markets/predictions/activity';
  static const String marketsPredictionsRiskCalculator =
      '/markets/predictions/risk-calculator';
  static const String marketsPredictionsMarketMaker =
      '/markets/predictions/market-maker';
  static const String marketsPredictionsPortfolioAnalyzer =
      '/markets/predictions/portfolio-analyzer';
  static const String marketsPredictionsEventCalendar =
      '/markets/predictions/event-calendar';
  static const String marketsPredictionsSocial = '/markets/predictions/social';
  static String marketsPredictionsAdvancedChart(String eventId) =>
      '/markets/predictions/advanced-chart/$eventId';
  static const String marketsPredictionsTournaments =
      '/markets/predictions/tournaments';
  static String marketsPredictionTournament(String tournamentId) =>
      '/markets/predictions/tournament/$tournamentId';
  static const String marketsPredictionsDataIntegration =
      '/markets/predictions/data-integration';
  static String pairDetail(String pairId) => '/pair/$pairId';
  static String pairInfo(String pairId) => '/pair/$pairId/info';
  static String pairDepth(String pairId) => '/pair/$pairId/depth';
  static String tradeAdvancedChart(String pairId) =>
      '/trade/advanced-chart/$pairId';
  static String tradePair(String pairId) => '/trade/$pairId';
  static String tradeFutures(String pairId) => '/trade/$pairId/futures';
  static String tradeFuturesLeverage(String pairId) =>
      '/trade/$pairId/futures/leverage';
  static const String tradeOrderReceipt = '/trade/order-receipt';
  static const String tradeOrdersHistory = '/trade/orders-history';
  static const String tradeSettings = '/trade/settings';
  static const String tradePositions = '/trade/positions';
  static const String tradeExport = '/trade/export';
  static const String tradeConvert = '/trade/convert';
  static const String tradeBots = '/trade/bots';
  static const String tradeBotTermsOfService = '/trade/bots/terms-of-service';
  static const String tradeBotRiskDisclosure = '/trade/bots/risk-disclosure';
  static const String tradeBotSuitabilityAssessment =
      '/trade/bots/suitability-assessment';
  static const String tradeBotRiskDashboard = '/trade/bots/risk-dashboard';
  static const String tradeBotEmergencyStop = '/trade/bots/emergency-stop';
  static const String tradeBotSecuritySettings =
      '/trade/bots/security-settings';
  static const String tradeBotHistory = '/trade/bots/history';
  static const String tradeBotPerformanceAnalytics =
      '/trade/bots/performance-analytics';
  static const String tradeBotBacktesting = '/trade/bots/backtesting';
  static const String tradeBotStrategyCompare = '/trade/bots/strategy-compare';
  static const String tradeBotOptimization = '/trade/bots/optimization';
  static const String tradeBotPortfolioDashboard =
      '/trade/bots/portfolio-dashboard';
  static const String tradeBotDrawdownAnalyzer =
      '/trade/bots/drawdown-analyzer';
  static const String tradeBotEquityCurve = '/trade/bots/equity-curve';
  static const String tradeBotGuide = '/trade/bots/guide';
  static const String tradeBotFaq = '/trade/bots/faq';
  static const String tradeBotTaxReporting = '/trade/bots/tax-reporting';
  static const String tradeBotApiDocumentation =
      '/trade/bots/api-documentation';
  static const String tradeRiskManagement = '/trade/risk-management';
  static const String tradeExecutionQuality = '/trade/execution-quality';
  static const String tradeAdvancedTools = '/trade/advanced-tools';
  static const String tradeCopyTrading = '/trade/copy-trading';
  static const String tradeCopyTradingV2 = '/trade/copy-trading/v2';
  static const String tradeCopyEducation = '/trade/copy-trading/education';
  static const String tradeCopyActive = '/trade/copy-trading/active';
  static const String tradeCopySettings = '/trade/copy-trading/settings';
  static const String tradeCopyNotifications =
      '/trade/copy-trading/notifications';
  static const String tradeCopyComparison = '/trade/copy-trading/comparison';
  static const String tradeCopyProviderApply = '/trade/copy-provider-apply';
  static String tradeCopyProvider(String providerId, {String? backPath}) {
    final path = '/trade/copy-provider/$providerId';
    if (backPath == null || backPath.isEmpty) return path;
    return '$path?back=${Uri.encodeComponent(backPath)}';
  }

  static String tradeCopyProviderAssessment(String providerId) =>
      '/trade/copy-provider/$providerId/assessment';

  static String tradeCopyProviderConfiguration(
    String providerId, {
    String? backPath,
  }) {
    final path = '/trade/copy-provider/$providerId/configuration';
    if (backPath == null || backPath.isEmpty) return path;
    return '$path?back=${Uri.encodeComponent(backPath)}';
  }

  static String tradeCopyProviderConfirmation(String providerId) =>
      '/trade/copy-provider/$providerId/confirmation';

  static String tradeCopyPerformance(String copyId) =>
      '/trade/copy-performance/$copyId';

  static String tradeCopyPerformanceAttribution(String copyId) =>
      '/trade/copy-performance/$copyId/attribution';

  static String tradeCopyAuditLog(String copyId) =>
      '/trade/copy-audit-log/$copyId';

  static const String tradeCopyRiskAnalysis =
      '/trade/copy-trading/risk-analysis';
  static const String tradeCopyLeaderboard = '/trade/copy-trading/leaderboard';
  static const String tradeCopySafety = '/trade/copy-trading/safety';
  static const String tradeCopyProviderGovernance =
      '/trade/copy-provider-governance';
  static const String tradeCopyDisputeResolution =
      '/trade/copy-dispute-resolution';
  static const String tradeCopySafetyCenter = '/trade/copy-safety-center';
  static const String tradeCopyRegulatoryDisclosures =
      '/trade/copy-regulatory-disclosures';
  static const String tradeCopyTransactionReporting =
      '/trade/copy-trading/transaction-reporting';
  static const String tradeCopyRegulatoryReportsDashboard =
      '/trade/copy-trading/regulatory-reports-dashboard';
  static const String tradeCopyArmIntegrationStatus =
      '/trade/copy-trading/arm-integration-status';
  static const String tradeCopyBestExecutionReports =
      '/trade/copy-trading/best-execution-reports';
  static const String tradeCopyExecutionVenueAnalysis =
      '/trade/copy-trading/execution-venue-analysis';
  static const String tradeCopySlippageMonitoring =
      '/trade/copy-trading/slippage-monitoring';
  static const String tradeCopyClientCategorization =
      '/trade/copy-trading/client-categorization';
  static const String tradeCopyClientOptUpRequest =
      '/trade/copy-trading/client-opt-up-request';
  static const String tradeCopyRegulatoryDisclosuresAlias =
      '/trade/copy-trading/regulatory-disclosures';
  static const String tradeCopyProductGovernance =
      '/trade/copy-trading/product-governance';
  static const String tradeCopyTargetMarketDefinition =
      '/trade/copy-trading/target-market-definition';
  static String tradeCopyTargetMarketDefinitionForProduct(String productId) =>
      '$tradeCopyTargetMarketDefinition/$productId';
  static const String tradeCopyClientMoneyProtection =
      '/trade/copy-trading/client-money-protection';
  static const String tradeCopyCassReconciliation =
      '/trade/copy-trading/cass-reconciliation';
  static const String tradeCopyInvestorCompensation =
      '/trade/copy-trading/investor-compensation';
  static const String tradeCopyExAnteCosts =
      '/trade/copy-trading/ex-ante-costs';
  static const String tradeCopyRiyCalculator =
      '/trade/copy-trading/riy-calculator';
  static const String tradeCopyExPostCostsReport =
      '/trade/copy-trading/ex-post-costs-report';
  static const String tradeCopyKidGenerator =
      '/trade/copy-trading/kid-generator';
  static const String tradeCopyPerformanceScenarios =
      '/trade/copy-trading/performance-scenarios';
  static const String tradeCopyRiskIndicatorExplainer =
      '/trade/copy-trading/risk-indicator-explainer';
  static const String tradeCopyComplaintsHandling =
      '/trade/copy-trading/complaints-handling';
  static const String tradeCopyComplaintSubmission =
      '/trade/copy-trading/complaint-submission';
  static const String tradeCopyComplaintTrackingBase =
      '/trade/copy-trading/complaint-tracking';
  static String tradeCopyComplaintTracking(String complaintId) =>
      '/trade/copy-trading/complaint-tracking/$complaintId';
  static const String tradeCopyOmbudsmanReferral =
      '/trade/copy-trading/ombudsman-referral';
  static const String tradeCopyAuditTrail = '/trade/copy-trading/audit-trail';
  static const String tradeCopyRegulatoryInspectionReady =
      '/trade/copy-trading/regulatory-inspection-ready';
  static const String settingsSecurity = '/settings/security';
  static const String tradeMargin = '/trade/margin';
  static const String tradeMarginBtcusdt = '/trade/margin/btcusdt';
  static const String tradeMarginAdvancedDemo = '/trade/margin/advanced-demo';
  static const String tradeMarginMarketDataAnalytics =
      '/trade/margin/market-data-analytics';
  static const String tradeMarginHub = '/trade/margin/hub';
  static const String tradeMarginLiveMarketDataAnalytics =
      '/trade/margin/live-market-data-analytics';
  static const String tradeMarginAdvancedAnalytics =
      '/trade/margin/advanced-analytics';
  static String tradeTrader(String traderId) => '/trade/trader/$traderId';

  static const String dca = '/dca';
  static const String dcaPortfolioOptimizer = '/dca/portfolio-optimizer';
  static const String dcaDynamicAmount = '/dca/dynamic-amount';
  static const String dcaRebalanceConfig = '/dca/rebalance/config';
  static const String dcaRebalanceDashboard = '/dca/rebalance/config001';
  static String dcaRebalanceEdit(String configId) =>
      '/dca/rebalance/$configId/edit';
  static String dcaRebalanceHistory(String configId) =>
      '/dca/rebalance/$configId/history';
  static const String dcaScheduleConfig = '/dca/schedule/config';
  static const String dcaScheduleAnalytics = '/dca/schedule/config001';
  static const String dcaBacktester = '/dca/backtester';
  static const String dcaMultiAsset = '/dca/multi-asset';
  static const String dcaPerformanceCompare = '/dca/performance-compare';
  static const String dcaSmartRules = '/dca/smart-rules';
  static const String admin = '/admin';
  static const String adminAnalytics = '/admin/analytics';
  static const String adminAbtests = '/admin/abtests';
  static const String adminFunnels = '/admin/funnels';
  static const String adminSettings = '/admin/settings';
  static const String profilePredictions = '/profile/predictions';
  static const String rewards = '/rewards';
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
  static const String supportHelp = '/support/help';
  static const String arena = '/arena';
  static const String arenaGuide = '/arena/guide';
  static const String arenaStudio = '/arena/studio';
  static const String arenaStudioSmartRules = '/arena/studio/smart-rules';
  static const String arenaStudioPresets = '/arena/studio/presets';
  static const String arenaStudioGovernance = '/arena/studio/governance';
  static const String arenaLeaderboard = '/arena/leaderboard';
  static const String arenaVerified = '/arena/verified';
  static const String arenaPoints = '/arena/points';
  static const String arenaFlowMap = '/arena/flow-map';
  static const String arenaSafety = '/arena/safety';
  static const String arenaBlocked = '/arena/blocked';
  static const String arenaMyReports = '/arena/my-reports';
  static const String arenaMy = '/arena/my';
  static const String arenaProduction = '/arena/production';
  static const String arenaBridge = '/arena/bridge';
  static const String arenaEcosystem = '/arena/ecosystem';
  static String arenaReportCase(String caseId) => '/arena/report/$caseId';
  static String arenaChallenge(String challengeId) =>
      '/arena/challenge/$challengeId';
  static String arenaJoin(String challengeId) => '/arena/join/$challengeId';
  static const String arenaResolution = '/arena/resolution';
  static const String arenaLedger = '/arena/ledger';
  static String arenaLedgerEntry(String entryId) =>
      '/arena/ledger/entry/$entryId';
  static String arenaMode(String modeId) => '/arena/mode/$modeId';
  static String arenaCreator(String creatorId) => '/arena/creator/$creatorId';
  static String arenaTrust(String userId) => '/arena/trust/$userId';
  static const String trade = '/trade';
  static const String wallet = '/wallet';
  static const String walletHistory = '/wallet/history';
  static const String walletDeposit = '/wallet/deposit';
  static String walletDepositAsset(String asset) => '/wallet/deposit/$asset';
  static const String walletWithdraw = '/wallet/withdraw';
  static String walletWithdrawAsset(String asset) => '/wallet/withdraw/$asset';
  static String walletTransaction(String transactionId) =>
      '/wallet/transaction/$transactionId';
  static const String walletPortfolioAnalytics = '/wallet/portfolio-analytics';
  static const String walletAddressBook = '/wallet/address-book';
  static const String walletAddressBookAdd = '/wallet/address-book/add';
  static const String walletBuyCrypto = '/wallet/buy-crypto';
  static const String walletTransfer = '/wallet/transfer';
  static String walletAsset(String assetId) => '/wallet/asset/$assetId';
  static const String walletMultiManager = '/wallet/multi-manager';
  static const String walletGasOptimizer = '/wallet/gas-optimizer';
  static const String walletTokenApproval = '/wallet/token-approval';
  static const String walletHealthScore = '/wallet/health-score';
  static const String walletPendingDeposits = '/wallet/pending-deposits';
  static const String walletLimits = '/wallet/limits';
  static const String walletDustConverter = '/wallet/dust-converter';
  static const String walletNetworkStatus = '/wallet/network-status';
  static const String profile = '/profile';
  static const String profileEdit = '/profile/edit';
  static const String profileKyc = '/profile/kyc';
  static const String profileSecurity = '/profile/security';
  static const String profileVip = '/profile/vip';
  static const String profileApi = '/profile/api';
  static const String profileApiCreate = '/profile/api/create';
  static const String profileDevices = '/profile/devices';
  static const String profileSubAccounts = '/profile/sub-accounts';
  static const String profileSettings = '/profile/settings';
  static const String profileActivity = '/profile/activity';
  static const String profileArena = '/profile/arena';
  static const String onboarding = '/onboarding';
}

const String _initialRouteFromEnvironment = String.fromEnvironment(
  'INITIAL_ROUTE',
);

String get _defaultInitialLocation => _initialRouteFromEnvironment.isEmpty
    ? AppRoutePaths.home
    : _initialRouteFromEnvironment;

GoRouter createAppRouter({
  String? initialLocation,
  ShellRenderMode shellRenderMode = ShellRenderMode.native,
}) {
  return GoRouter(
    initialLocation: initialLocation ?? _defaultInitialLocation,
    routes: [
      GoRoute(path: AppRoutePaths.root, redirect: (_, _) => AppRoutePaths.home),
      GoRoute(
        path: AppRoutePaths.authLogin,
        name: AppRouteNames.sc001Login,
        builder: (_, _) => _AuthRouteShell(
          renderMode: shellRenderMode,
          child: const LoginPage(),
        ),
      ),
      GoRoute(
        path: AppRoutePaths.authRegister,
        name: AppRouteNames.sc002Register,
        builder: (_, _) => _AuthRouteShell(
          renderMode: shellRenderMode,
          child: const RegisterPage(),
        ),
      ),
      GoRoute(
        path: AppRoutePaths.authOtp,
        name: AppRouteNames.sc003Otp,
        builder: (_, state) => _AuthRouteShell(
          renderMode: shellRenderMode,
          child: _buildOtpPage(state),
        ),
      ),
      GoRoute(
        path: AppRoutePaths.auth2faSetup,
        name: AppRouteNames.sc004TwoFaSetup,
        builder: (_, _) => _AuthRouteShell(
          renderMode: shellRenderMode,
          child: const TwoFASetupPage(),
        ),
      ),
      GoRoute(
        path: AppRoutePaths.authForgotPassword,
        name: AppRouteNames.sc005ForgotPassword,
        builder: (_, _) => _AuthRouteShell(
          renderMode: shellRenderMode,
          child: const ForgotPasswordPage(),
        ),
      ),
      GoRoute(
        path: AppRoutePaths.authResetPassword,
        name: AppRouteNames.sc006ResetPassword,
        builder: (_, state) => _AuthRouteShell(
          renderMode: shellRenderMode,
          child: ResetPasswordPage(
            email: state.uri.queryParameters['email'] ?? 'user@vittrade.vn',
            otp: state.uri.queryParameters['otp'] ?? '123456',
          ),
        ),
      ),
      GoRoute(
        path: AppRoutePaths.onboarding,
        name: AppRouteNames.sc397Onboarding,
        builder: (_, _) => const OnboardingFlow(),
      ),
      ShellRoute(
        builder: (context, state, child) {
          final activeDestination = _activeDestinationForPath(state.uri.path);
          final appShell = VitAppShell(
            renderMode: shellRenderMode,
            currentPath: state.uri.path,
            activeDestination: activeDestination,
            homeBadgeCount: HomeMockData.homeBadge,
            statusBarTime: shellRenderMode.usesVisualQaFrame
                ? _visualQaStatusBarTimeForUri(state.uri)
                : null,
            onDestinationSelected: (destination) {
              context.go(destination.routePath);
            },
            child: child,
          );

          if (!shellRenderMode.usesVisualQaFrame) return appShell;
          return VitPhoneFrame(child: appShell);
        },
        routes: [
          GoRoute(
            path: AppRoutePaths.home,
            name: AppRouteNames.sc007Home,
            builder: (_, _) => HomePage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.news,
            name: AppRouteNames.sc047News,
            builder: (_, _) => NewsPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.markets,
            name: AppRouteNames.sc008MarketList,
            builder: (_, _) => MarketListPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.marketsOverview,
            name: AppRouteNames.sc009MarketOverview,
            builder: (_, _) =>
                MarketOverviewPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.marketsMovers,
            name: AppRouteNames.sc010MarketMovers,
            builder: (_, _) =>
                MarketMoversPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.marketsSectors,
            name: AppRouteNames.sc011MarketSectors,
            builder: (_, state) => MarketSectorsPage(
              shellRenderMode: shellRenderMode,
              selectedSectorId: state.uri.queryParameters['id'],
            ),
          ),
          GoRoute(
            path: AppRoutePaths.marketsWatchlist,
            name: AppRouteNames.sc012Watchlist,
            builder: (_, _) => WatchlistPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.marketsHeatmap,
            name: AppRouteNames.sc013MarketHeatmap,
            builder: (_, _) =>
                MarketHeatmapPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.marketsAlerts,
            name: AppRouteNames.sc014PriceAlerts,
            builder: (_, _) =>
                PriceAlertsPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.marketsScreener,
            name: AppRouteNames.sc015MarketScreener,
            builder: (_, _) =>
                MarketScreenerPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.marketsCompare,
            name: AppRouteNames.sc016ComparisonTool,
            builder: (_, _) =>
                ComparisonToolPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.marketsCalendar,
            name: AppRouteNames.sc017MarketCalendar,
            builder: (_, _) =>
                MarketCalendarPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.marketsDerivatives,
            name: AppRouteNames.sc018DerivativesOverview,
            builder: (_, _) =>
                DerivativesOverviewPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.marketsDepth,
            name: AppRouteNames.sc019MarketDepth,
            builder: (_, _) =>
                MarketDepthPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.marketsSocialSentiment,
            name: AppRouteNames.sc020SocialSentiment,
            builder: (_, _) =>
                SocialSentimentPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.marketsPortfolioTracker,
            name: AppRouteNames.sc021PortfolioTracker,
            builder: (_, _) =>
                PortfolioTrackerPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.marketsNews,
            name: AppRouteNames.sc022MarketNews,
            builder: (_, _) => MarketNewsPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.marketsAdvancedCharts,
            name: AppRouteNames.sc023AdvancedCharts,
            builder: (_, _) =>
                AdvancedChartsPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.marketsUnlocks,
            name: AppRouteNames.sc024TokenUnlocks,
            builder: (_, _) =>
                TokenUnlocksPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.marketsSignals,
            name: AppRouteNames.sc025SocialSignals,
            builder: (_, _) =>
                SocialSignalsPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.marketsCorrelations,
            name: AppRouteNames.sc026MarketCorrelations,
            builder: (_, _) =>
                MarketCorrelationsPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.marketsPredictions,
            name: AppRouteNames.sc027PredictionsHome,
            builder: (_, _) =>
                PredictionsHomePage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.marketsPredictionsSearch,
            name: AppRouteNames.sc028PredictionsSearch,
            builder: (_, _) =>
                PredictionsSearchPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.marketsPredictionsBreaking,
            name: AppRouteNames.sc029PredictionsBreaking,
            builder: (_, _) =>
                PredictionsBreakingPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: '/markets/predictions/event/:eventId',
            name: AppRouteNames.sc030PredictionEventDetail,
            builder: (_, state) => PredictionEventDetailPage(
              eventId: state.pathParameters['eventId'] ?? 'pred-1',
              shellRenderMode: shellRenderMode,
            ),
          ),
          GoRoute(
            path: AppRoutePaths.marketsPredictionsPortfolio,
            name: AppRouteNames.sc031PredictionsPortfolio,
            builder: (_, _) =>
                PredictionsPortfolioPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.marketsPredictionsRewards,
            name: AppRouteNames.sc032PredictionsRewards,
            builder: (_, _) =>
                PredictionsRewardsPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.marketsPredictionsLeaderboard,
            name: AppRouteNames.sc033PredictionsLeaderboard,
            builder: (_, _) =>
                PredictionsLeaderboardPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.marketsPredictionsActivity,
            name: AppRouteNames.sc034PredictionsGlobalActivity,
            builder: (_, _) =>
                PredictionsGlobalActivityPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: '/markets/predictions/receipt/:receiptId',
            name: AppRouteNames.sc035PredictionOrderReceipt,
            builder: (_, state) => PredictionOrderReceiptPage(
              receiptId: state.pathParameters['receiptId'] ?? 'p2p001',
              shellRenderMode: shellRenderMode,
            ),
          ),
          GoRoute(
            path: AppRoutePaths.marketsPredictionsRiskCalculator,
            name: AppRouteNames.sc036PredictionRiskCalculator,
            builder: (_, _) =>
                PredictionRiskCalculatorPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.marketsPredictionsMarketMaker,
            name: AppRouteNames.sc037PredictionMarketMaker,
            builder: (_, _) =>
                PredictionMarketMakerPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.marketsPredictionsPortfolioAnalyzer,
            name: AppRouteNames.sc038PredictionPortfolioAnalyzer,
            builder: (_, _) => PredictionPortfolioAnalyzerPage(
              shellRenderMode: shellRenderMode,
            ),
          ),
          GoRoute(
            path: AppRoutePaths.marketsPredictionsEventCalendar,
            name: AppRouteNames.sc039PredictionEventCalendar,
            builder: (_, _) =>
                PredictionEventCalendarPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.marketsPredictionsSocial,
            name: AppRouteNames.sc040PredictionSocial,
            builder: (_, _) =>
                PredictionSocialPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: '/markets/predictions/advanced-chart/:eventId',
            name: AppRouteNames.sc041PredictionAdvancedChart,
            builder: (_, state) => PredictionAdvancedChartPage(
              eventId: state.pathParameters['eventId'] ?? 'btcusdt',
              shellRenderMode: shellRenderMode,
            ),
          ),
          GoRoute(
            path: AppRoutePaths.marketsPredictionsTournaments,
            name: AppRouteNames.sc042PredictionTournaments,
            builder: (_, _) =>
                PredictionTournamentsPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: '/markets/predictions/tournament/:tournamentId',
            builder: (_, state) => _BottomNavRouteSkeleton(
              title:
                  'Tournament ${state.pathParameters['tournamentId'] ?? 'tour'}',
            ),
          ),
          GoRoute(
            path: AppRoutePaths.marketsPredictionsDataIntegration,
            name: AppRouteNames.sc043PredictionDataIntegration,
            builder: (_, _) =>
                PredictionDataIntegrationPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: '/pair/:pairId',
            name: AppRouteNames.sc044PairDetail,
            builder: (_, state) => PairDetailPage(
              pairId: state.pathParameters['pairId'] ?? 'btcusdt',
              shellRenderMode: shellRenderMode,
            ),
          ),
          GoRoute(
            path: '/pair/:pairId/info',
            name: AppRouteNames.sc045TokenInfo,
            builder: (_, state) => TokenInfoPage(
              pairId: state.pathParameters['pairId'] ?? 'btcusdt',
              shellRenderMode: shellRenderMode,
            ),
          ),
          GoRoute(
            path: '/pair/:pairId/depth',
            name: AppRouteNames.sc046PairDepth,
            builder: (_, state) {
              final pairId = state.pathParameters['pairId'] ?? 'btcusdt';
              return MarketDepthPage(
                pairId: pairId,
                backPath: AppRoutePaths.pairDetail(pairId),
                shellRenderMode: shellRenderMode,
              );
            },
          ),
          GoRoute(
            path: '/trade/advanced-chart/:pairId',
            name: AppRouteNames.sc055AdvancedChart,
            builder: (_, state) => AdvancedChartPage(
              pairId: state.pathParameters['pairId'] ?? 'btcusdt',
              shellRenderMode: shellRenderMode,
            ),
          ),
          GoRoute(
            path: AppRoutePaths.trade,
            name: AppRouteNames.sc048Trade,
            builder: (_, _) => TradePage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeConvert,
            name: AppRouteNames.sc056Convert,
            builder: (_, _) => ConvertPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeBots,
            name: AppRouteNames.sc059TradingBots,
            builder: (_, _) =>
                TradingBotsPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeBotTermsOfService,
            name: AppRouteNames.sc117BotTermsOfService,
            builder: (_, _) =>
                BotTermsOfServicePage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeBotRiskDisclosure,
            name: AppRouteNames.sc118BotRiskDisclosure,
            builder: (_, _) =>
                BotRiskDisclosurePage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeBotSuitabilityAssessment,
            name: AppRouteNames.sc119BotSuitabilityAssessment,
            builder: (_, _) =>
                BotSuitabilityAssessmentPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeBotRiskDashboard,
            name: AppRouteNames.sc120BotRiskDashboard,
            builder: (_, _) =>
                BotRiskDashboardPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeBotEmergencyStop,
            name: AppRouteNames.sc121BotEmergencyStop,
            builder: (_, _) =>
                BotEmergencyStopPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeBotSecuritySettings,
            name: AppRouteNames.sc122BotSecuritySettings,
            builder: (_, _) =>
                BotSecuritySettingsPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeBotHistory,
            name: AppRouteNames.sc123BotHistory,
            builder: (_, _) => BotHistoryPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeBotPerformanceAnalytics,
            name: AppRouteNames.sc124BotPerformanceAnalytics,
            builder: (_, _) =>
                BotPerformanceAnalyticsPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeBotBacktesting,
            name: AppRouteNames.sc125BotBacktesting,
            builder: (_, _) =>
                BotBacktestingPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeBotStrategyCompare,
            name: AppRouteNames.sc126BotStrategyCompare,
            builder: (_, _) =>
                BotStrategyComparePage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeBotOptimization,
            name: AppRouteNames.sc127BotOptimization,
            builder: (_, _) =>
                BotOptimizationPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeBotPortfolioDashboard,
            name: AppRouteNames.sc128BotPortfolioDashboard,
            builder: (_, _) =>
                BotPortfolioDashboardPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeBotDrawdownAnalyzer,
            name: AppRouteNames.sc129BotDrawdownAnalyzer,
            builder: (_, _) =>
                BotDrawdownAnalyzerPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeBotEquityCurve,
            name: AppRouteNames.sc130BotEquityCurve,
            builder: (_, _) =>
                BotEquityCurvePage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeBotGuide,
            name: AppRouteNames.sc131BotGuide,
            builder: (_, _) => BotGuidePage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeBotFaq,
            name: AppRouteNames.sc132BotFaq,
            builder: (_, _) => BotFaqPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeBotTaxReporting,
            name: AppRouteNames.sc133BotTaxReporting,
            builder: (_, _) =>
                BotTaxReportingPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeBotApiDocumentation,
            name: AppRouteNames.sc134BotApiDocumentation,
            builder: (_, _) =>
                BotApiDocumentationPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeRiskManagement,
            name: AppRouteNames.sc060RiskManagement,
            builder: (_, _) =>
                RiskManagementDemoPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeExecutionQuality,
            name: AppRouteNames.sc061ExecutionQuality,
            builder: (_, _) =>
                ExecutionQualityDemoPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeAdvancedTools,
            name: AppRouteNames.sc062AdvancedTools,
            builder: (_, _) =>
                AdvancedToolsDemoPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeCopyTrading,
            name: AppRouteNames.sc063CopyTrading,
            builder: (_, _) =>
                CopyTradingPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeCopyTradingV2,
            name: AppRouteNames.sc064CopyTradingV2,
            builder: (_, _) =>
                CopyTradingV2Page(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeCopyEducation,
            name: AppRouteNames.sc065CopyEducation,
            builder: (_, _) =>
                CopyEducationPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeCopyActive,
            name: AppRouteNames.sc066ActiveCopies,
            builder: (_, _) =>
                ActiveCopiesPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeCopySettings,
            name: AppRouteNames.sc067CopySettings,
            builder: (_, _) =>
                CopySettingsPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeCopyNotifications,
            name: AppRouteNames.sc068CopyNotifications,
            builder: (_, _) =>
                CopyNotificationsPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeCopyProviderApply,
            name: AppRouteNames.sc069ProviderApplication,
            builder: (_, _) =>
                ProviderApplicationPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeCopyComparison,
            name: AppRouteNames.sc076ProviderComparison,
            builder: (_, _) =>
                ProviderComparisonPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeCopyRiskAnalysis,
            name: AppRouteNames.sc078PortfolioRiskAnalysis,
            builder: (_, _) =>
                PortfolioRiskAnalysisPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeCopyLeaderboard,
            name: AppRouteNames.sc079ProviderLeaderboard,
            builder: (_, _) =>
                ProviderLeaderboardPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeCopySafety,
            name: AppRouteNames.sc080SafetyEducation,
            builder: (_, _) =>
                SafetyEducationPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeCopyProviderGovernance,
            name: AppRouteNames.sc081ProviderGovernance,
            builder: (_, _) =>
                ProviderGovernancePage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeCopyDisputeResolution,
            name: AppRouteNames.sc082DisputeResolution,
            builder: (_, _) =>
                DisputeResolutionPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeCopySafetyCenter,
            name: AppRouteNames.sc083CopySafetyCenter,
            builder: (_, _) =>
                CopySafetyCenterPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeCopyRegulatoryDisclosures,
            name: AppRouteNames.sc084RegulatoryDisclosures,
            builder: (_, _) =>
                RegulatoryDisclosuresPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeCopyTransactionReporting,
            name: AppRouteNames.sc093TransactionReporting,
            builder: (_, _) =>
                TransactionReportingPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeCopyRegulatoryReportsDashboard,
            name: AppRouteNames.sc094RegulatoryReportsDashboard,
            builder: (_, _) => RegulatoryReportsDashboardPage(
              shellRenderMode: shellRenderMode,
            ),
          ),
          GoRoute(
            path: AppRoutePaths.tradeCopyArmIntegrationStatus,
            name: AppRouteNames.sc095ArmIntegrationStatus,
            builder: (_, _) =>
                ArmIntegrationStatusPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeCopyBestExecutionReports,
            name: AppRouteNames.sc096BestExecutionReports,
            builder: (_, _) =>
                BestExecutionReportsPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeCopyExecutionVenueAnalysis,
            name: AppRouteNames.sc097ExecutionVenueAnalysis,
            builder: (_, _) =>
                ExecutionVenueAnalysisPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeCopySlippageMonitoring,
            name: AppRouteNames.sc098SlippageMonitoring,
            builder: (_, _) =>
                SlippageMonitoringPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeCopyClientCategorization,
            name: AppRouteNames.sc099ClientCategorization,
            builder: (_, _) =>
                ClientCategorizationPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeCopyProductGovernance,
            name: AppRouteNames.sc100ProductGovernance,
            builder: (_, _) =>
                ProductGovernancePage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeCopyTargetMarketDefinition,
            name: AppRouteNames.sc101TargetMarketDefinition,
            builder: (_, _) =>
                TargetMarketDefinitionPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: '${AppRoutePaths.tradeCopyTargetMarketDefinition}/:productId',
            builder: (_, state) => TargetMarketDefinitionPage(
              productId: state.pathParameters['productId'] ?? 'prod-1',
              shellRenderMode: shellRenderMode,
            ),
          ),
          GoRoute(
            path: AppRoutePaths.tradeCopyClientMoneyProtection,
            name: AppRouteNames.sc102ClientMoneyProtection,
            builder: (_, _) =>
                ClientMoneyProtectionPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeCopyCassReconciliation,
            name: AppRouteNames.sc103CassReconciliation,
            builder: (_, _) =>
                CassReconciliationPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeCopyInvestorCompensation,
            name: AppRouteNames.sc104InvestorCompensation,
            builder: (_, _) =>
                InvestorCompensationPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeCopyExAnteCosts,
            name: AppRouteNames.sc105ExAnteCosts,
            builder: (_, _) =>
                ExAnteCostsPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeCopyRiyCalculator,
            name: AppRouteNames.sc106RiyCalculator,
            builder: (_, _) =>
                RIYCalculatorPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeCopyExPostCostsReport,
            name: AppRouteNames.sc107ExPostCostsReport,
            builder: (_, _) =>
                ExPostCostsReportPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeCopyKidGenerator,
            name: AppRouteNames.sc108KidGenerator,
            builder: (_, _) =>
                KIDGeneratorPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeCopyPerformanceScenarios,
            name: AppRouteNames.sc109PerformanceScenarios,
            builder: (_, _) =>
                PerformanceScenariosPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeCopyRiskIndicatorExplainer,
            name: AppRouteNames.sc110RiskIndicatorExplainer,
            builder: (_, _) =>
                RiskIndicatorExplainerPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeCopyComplaintsHandling,
            name: AppRouteNames.sc111ComplaintsHandling,
            builder: (_, _) =>
                ComplaintsHandlingPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeCopyComplaintSubmission,
            name: AppRouteNames.sc112ComplaintSubmission,
            builder: (_, _) =>
                ComplaintSubmissionPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeCopyComplaintTrackingBase,
            name: AppRouteNames.sc113ComplaintTracking,
            builder: (_, _) =>
                ComplaintTrackingPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: '/trade/copy-trading/complaint-tracking/:complaintId',
            builder: (_, state) => ComplaintTrackingPage(
              complaintId: state.pathParameters['complaintId'],
              shellRenderMode: shellRenderMode,
            ),
          ),
          GoRoute(
            path: AppRoutePaths.tradeCopyOmbudsmanReferral,
            name: AppRouteNames.sc114OmbudsmanReferral,
            builder: (_, _) =>
                OmbudsmanReferralPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeCopyAuditTrail,
            name: AppRouteNames.sc115AuditTrail,
            builder: (_, _) => AuditTrailPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeCopyRegulatoryInspectionReady,
            name: AppRouteNames.sc116RegulatoryInspectionReady,
            builder: (_, _) =>
                RegulatoryInspectionReadyPage(shellRenderMode: shellRenderMode),
          ),
          ..._tradeCopyTradingOutgoingPlaceholders,
          GoRoute(
            path: AppRoutePaths.tradeMargin,
            name: AppRouteNames.sc085MarginTrading,
            builder: (_, _) =>
                MarginTradingPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeMarginBtcusdt,
            name: AppRouteNames.sc086MarginTradingPair,
            builder: (_, _) => MarginTradingPage(
              pairId: 'btcusdt',
              pairRouteVariant: true,
              shellRenderMode: shellRenderMode,
            ),
          ),
          GoRoute(
            path: '/trade/trader/:traderId',
            name: AppRouteNames.sc087TraderProfile,
            builder: (_, state) => TraderProfilePage(
              traderId: state.pathParameters['traderId'] ?? 'trader001',
              shellRenderMode: shellRenderMode,
            ),
          ),
          GoRoute(
            path: AppRoutePaths.tradeMarginAdvancedDemo,
            name: AppRouteNames.sc088AdvancedTradingDemo,
            builder: (_, _) =>
                AdvancedTradingDemoPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeMarginMarketDataAnalytics,
            name: AppRouteNames.sc089MarketDataAnalytics,
            builder: (_, _) =>
                MarketDataAnalyticsPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeMarginHub,
            name: AppRouteNames.sc090MarginTradingHub,
            builder: (_, _) =>
                MarginTradingHubPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeMarginLiveMarketDataAnalytics,
            name: AppRouteNames.sc091LiveMarketDataAnalytics,
            builder: (_, _) =>
                LiveMarketDataAnalyticsPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeMarginAdvancedAnalytics,
            name: AppRouteNames.sc092AdvancedAnalytics,
            builder: (_, _) =>
                AdvancedAnalyticsPage(shellRenderMode: shellRenderMode),
          ),
          ..._tradeMarginOutgoingPlaceholders,
          ..._tradeBotsOutgoingPlaceholders,
          GoRoute(
            path: '/trade/copy-provider/:providerId/assessment',
            name: AppRouteNames.sc071PreCopyAssessment,
            builder: (_, state) {
              final providerId = state.pathParameters['providerId'] ?? '';
              return PreCopyAssessmentPage(
                providerId: providerId,
                shellRenderMode: shellRenderMode,
              );
            },
          ),
          GoRoute(
            path: '/trade/copy-provider/:providerId/configuration',
            name: AppRouteNames.sc072CopyConfiguration,
            builder: (_, state) {
              final backPath = state.uri.queryParameters['back'];
              return CopyConfigurationPage(
                providerId: state.pathParameters['providerId'] ?? '',
                backPath: backPath == null || backPath.isEmpty
                    ? null
                    : backPath,
                shellRenderMode: shellRenderMode,
              );
            },
          ),
          GoRoute(
            path: '/trade/copy-provider/:providerId/confirmation',
            name: AppRouteNames.sc073CopyConfirmation,
            builder: (_, state) {
              final providerId = state.pathParameters['providerId'] ?? '';
              return CopyConfirmationPage(
                providerId: providerId,
                shellRenderMode: shellRenderMode,
              );
            },
          ),
          GoRoute(
            path: '/trade/copy-provider/:providerId',
            name: AppRouteNames.sc070CopyProviderDetail,
            builder: (_, state) {
              final backPath = state.uri.queryParameters['back'];
              return CopyProviderDetailPage(
                providerId: state.pathParameters['providerId'] ?? 'provider001',
                backPath: backPath == null || backPath.isEmpty
                    ? AppRoutePaths.tradeCopyTrading
                    : backPath,
                shellRenderMode: shellRenderMode,
              );
            },
          ),
          GoRoute(
            path: '/trade/copy-performance/:copyId',
            name: AppRouteNames.sc074CopyPerformance,
            builder: (_, state) {
              return CopyPerformancePage(
                copyId: state.pathParameters['copyId'] ?? 'copy001',
                shellRenderMode: shellRenderMode,
              );
            },
          ),
          GoRoute(
            path: '/trade/copy-performance/:copyId/attribution',
            name: AppRouteNames.sc075PerformanceAttribution,
            builder: (_, state) {
              return PerformanceAttributionPage(
                copyId: state.pathParameters['copyId'] ?? 'copy001',
                shellRenderMode: shellRenderMode,
              );
            },
          ),
          GoRoute(
            path: '/trade/copy-audit-log/:copyId',
            name: AppRouteNames.sc077CopyAuditLog,
            builder: (_, state) {
              return CopyAuditLogPage(
                copyId: state.pathParameters['copyId'] ?? 'copy001',
                shellRenderMode: shellRenderMode,
              );
            },
          ),
          GoRoute(
            path: AppRoutePaths.tradeOrderReceipt,
            name: AppRouteNames.sc051OrderReceipt,
            builder: (_, _) =>
                OrderReceiptPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeOrdersHistory,
            name: AppRouteNames.sc050OrdersHistory,
            builder: (_, _) =>
                OrdersHistoryPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradePositions,
            name: AppRouteNames.sc053PositionDashboard,
            builder: (_, _) =>
                PositionDashboardPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeSettings,
            name: AppRouteNames.sc052TradeSettings,
            builder: (_, _) =>
                TradeSettingsPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeExport,
            name: AppRouteNames.sc054TradeHistoryExport,
            builder: (_, _) =>
                TradeHistoryExportPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: '/trade/:pairId/futures/leverage',
            name: AppRouteNames.sc058Leverage,
            builder: (_, state) => LeveragePage(
              pairId: state.pathParameters['pairId'] ?? 'btcusdt',
              shellRenderMode: shellRenderMode,
            ),
          ),
          GoRoute(
            path: '/trade/:pairId/futures',
            name: AppRouteNames.sc057Futures,
            builder: (_, state) => FuturesPage(
              pairId: state.pathParameters['pairId'] ?? 'btcusdt',
              shellRenderMode: shellRenderMode,
            ),
          ),
          GoRoute(
            path: '/trade/:pairId',
            name: AppRouteNames.sc049TradePair,
            builder: (_, state) => TradePage(
              pairId: state.pathParameters['pairId'] ?? 'btcusdt',
              chartVariant: TradeChartVariant.pairRoute,
              shellRenderMode: shellRenderMode,
            ),
          ),
          GoRoute(
            path: AppRoutePaths.admin,
            name: AppRouteNames.sc180AdminHome,
            builder: (_, _) => AdminHome(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.adminAnalytics,
            name: AppRouteNames.sc181AnalyticsDashboard,
            builder: (_, _) =>
                AnalyticsDashboard(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.adminAbtests,
            name: AppRouteNames.sc182AbTestDashboard,
            builder: (_, _) =>
                ABTestDashboard(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.adminFunnels,
            name: AppRouteNames.sc183FunnelDashboard,
            builder: (_, _) =>
                FunnelDashboard(shellRenderMode: shellRenderMode),
          ),
          ..._adminOutgoingPlaceholders,
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
              orderId: state.pathParameters['orderId'] ?? 'p2p001',
              shellRenderMode: shellRenderMode,
            ),
          ),
          GoRoute(
            path: '/p2p/order/rate/:orderId',
            name: AppRouteNames.sc213P2POrderRate,
            builder: (_, state) => P2POrderRatePage(
              orderId: state.pathParameters['orderId'] ?? 'p2p001',
              shellRenderMode: shellRenderMode,
            ),
          ),
          GoRoute(
            path: '/p2p/order/cancel/:orderId',
            name: AppRouteNames.sc214P2POrderCancel,
            builder: (_, state) => P2POrderCancelPage(
              orderId: state.pathParameters['orderId'] ?? 'p2p001',
              shellRenderMode: shellRenderMode,
            ),
          ),
          GoRoute(
            path: '/p2p/order/proof/:orderId',
            name: AppRouteNames.sc215P2POrderProof,
            builder: (_, state) => P2POrderProofPage(
              orderId: state.pathParameters['orderId'] ?? 'p2p001',
              shellRenderMode: shellRenderMode,
            ),
          ),
          GoRoute(
            path: '/p2p/order/:orderId',
            name: AppRouteNames.sc216P2POrder,
            builder: (_, state) => P2POrderPage(
              orderId: state.pathParameters['orderId'] ?? 'p2p001',
              shellRenderMode: shellRenderMode,
            ),
          ),
          GoRoute(
            path: '/p2p/chat/:orderId',
            name: AppRouteNames.sc217P2PChat,
            builder: (_, state) => P2PChatPage(
              orderId: state.pathParameters['orderId'] ?? 'p2p001',
              shellRenderMode: shellRenderMode,
            ),
          ),
          GoRoute(
            path: '/p2p/dispute/detail/:disputeId',
            name: AppRouteNames.sc218P2PDisputeDetail,
            builder: (_, state) => P2PDisputeDetailPage(
              disputeId: state.pathParameters['disputeId'] ?? 'sample',
              shellRenderMode: shellRenderMode,
            ),
          ),
          GoRoute(
            path: '/p2p/dispute/evidence/:disputeId',
            name: AppRouteNames.sc219P2PDisputeEvidence,
            builder: (_, state) => P2PDisputeEvidencePage(
              disputeId: state.pathParameters['disputeId'] ?? 'sample',
              shellRenderMode: shellRenderMode,
            ),
          ),
          GoRoute(
            path: '/p2p/dispute/resolution/:disputeId',
            name: AppRouteNames.sc220P2PDisputeResolution,
            builder: (_, state) => P2PDisputeResolutionPage(
              disputeId: state.pathParameters['disputeId'] ?? 'sample',
              shellRenderMode: shellRenderMode,
            ),
          ),
          GoRoute(
            path: '/p2p/dispute/:orderId',
            name: AppRouteNames.sc221P2PDispute,
            builder: (_, state) => P2PDisputePage(
              orderId: state.pathParameters['orderId'] ?? 'p2p001',
              shellRenderMode: shellRenderMode,
            ),
          ),
          GoRoute(
            path: AppRoutePaths.p2pDisputes,
            name: AppRouteNames.sc222P2PDisputes,
            builder: (_, _) =>
                P2PDisputesPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: '/p2p/ad-analytics/:adId',
            name: AppRouteNames.sc223P2PAdAnalytics,
            builder: (_, state) => P2PAdAnalyticsPage(
              adId: state.pathParameters['adId'] ?? 'sample',
              shellRenderMode: shellRenderMode,
            ),
          ),
          GoRoute(
            path: '/p2p/ad/:adId',
            name: AppRouteNames.sc224P2PAdDetail,
            builder: (_, state) => P2PAdDetailPage(
              adId: state.pathParameters['adId'] ?? 'sample',
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
            builder: (_, _) =>
                P2PCreateAdPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.p2pMerchantApply,
            name: AppRouteNames.sc227P2PMerchantApply,
            builder: (_, _) =>
                P2PMerchantApplyPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: '/p2p/merchant/:merchantId',
            name: AppRouteNames.sc228P2PMerchantProfile,
            builder: (_, state) => P2PMerchantProfilePage(
              merchantId: state.pathParameters['merchantId'] ?? 'mc001',
              shellRenderMode: shellRenderMode,
            ),
          ),
          GoRoute(
            path: AppRoutePaths.p2pEscrowBalance,
            name: AppRouteNames.sc245P2PEscrowBalance,
            builder: (_, state) => P2PEscrowBalancePage(
              initialAsset: state.uri.queryParameters['asset'] ?? 'USDT',
              shellRenderMode: shellRenderMode,
            ),
          ),
          GoRoute(
            path: '/p2p/escrow/:orderId',
            name: AppRouteNames.sc246P2PEscrowDetail,
            builder: (_, state) => P2PEscrowDetailPage(
              orderId: state.pathParameters['orderId'] ?? 'p2p001',
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
            builder: (_, _) =>
                P2PKycStatusPage(shellRenderMode: shellRenderMode),
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
            builder: (_, _) =>
                P2PAddressProofPage(shellRenderMode: shellRenderMode),
          ),
          _placeholderRoute(
            AppRoutePaths.p2pKycVerify,
            'P2P KYC Verify',
            backPath: AppRoutePaths.p2pKycRequirements,
          ),
          _placeholderRoute(
            AppRoutePaths.p2pKycFaceMatch,
            'P2P KYC Face Match',
            backPath: AppRoutePaths.p2pKycIdentity,
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
            builder: (_, _) =>
                P2P2FASettingsPage(shellRenderMode: shellRenderMode),
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
            builder: (_, _) =>
                P2PLoginHistoryPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.p2pSecuritySuspiciousActivity,
            name: AppRouteNames.sc258P2PSuspiciousActivity,
            builder: (_, _) =>
                P2PSuspiciousActivityPage(shellRenderMode: shellRenderMode),
          ),
          _placeholderRoute(
            AppRoutePaths.p2pSecurityWhitelist,
            'P2P Whitelist Mode',
            backPath: AppRoutePaths.p2pSecurityCenter,
          ),
          _placeholderRoute(
            AppRoutePaths.settingsSecurityBiometric,
            'Biometric Lock',
            backPath: AppRoutePaths.p2pSecurityCenter,
          ),
          _placeholderRoute(
            AppRoutePaths.settingsSecurityChangePassword,
            'Change Password',
            backPath: AppRoutePaths.p2pSecurityCenter,
          ),
          GoRoute(
            path: '/p2p/report/:merchantId',
            name: AppRouteNames.sc229P2PReportMerchant,
            builder: (_, state) => P2PReportMerchantPage(
              merchantId: state.pathParameters['merchantId'] ?? 'mc001',
              shellRenderMode: shellRenderMode,
            ),
          ),
          GoRoute(
            path: AppRoutePaths.p2pTradingLevel,
            name: AppRouteNames.sc230P2PTradingLevel,
            builder: (_, _) =>
                P2PTradingLevelPage(shellRenderMode: shellRenderMode),
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
              methodId: state.pathParameters['methodId'] ?? 'sample',
              shellRenderMode: shellRenderMode,
            ),
          ),
          GoRoute(
            path: '/p2p/payment-method/ownership/:methodId',
            name: AppRouteNames.sc234P2PPaymentMethodOwnership,
            builder: (_, state) => P2PPaymentMethodOwnershipPage(
              methodId: state.pathParameters['methodId'] ?? 'sample',
              shellRenderMode: shellRenderMode,
            ),
          ),
          GoRoute(
            path: AppRoutePaths.p2pPaymentMethodCoolingPeriod,
            name: AppRouteNames.sc235P2PPaymentMethodCoolingPeriod,
            builder: (_, _) => P2PPaymentMethodCoolingPeriodPage(
              shellRenderMode: shellRenderMode,
            ),
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
            builder: (_, _) =>
                P2PInsuranceFundPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.p2pInsuranceFundAlias,
            name: AppRouteNames.sc244P2PInsuranceFundAlias,
            builder: (_, _) =>
                P2PInsuranceFundPage(shellRenderMode: shellRenderMode),
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
              claimId: state.pathParameters['claimId'] ?? 'sample',
              shellRenderMode: shellRenderMode,
            ),
          ),
          GoRoute(
            path: AppRoutePaths.p2pBlacklistAdd,
            name: AppRouteNames.sc276P2PBlacklistAdd,
            builder: (_, _) =>
                P2PBlacklistAddPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.p2pBlacklist,
            name: AppRouteNames.sc277P2PBlacklist,
            builder: (_, _) =>
                P2PBlacklistPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.p2pGuide,
            name: AppRouteNames.sc280P2PGuide,
            builder: (_, _) => P2PGuidePage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.p2pSettings,
            name: AppRouteNames.sc279P2PSettings,
            builder: (_, _) =>
                P2PSettingsPage(shellRenderMode: shellRenderMode),
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
              final direction = query['direction'];
              final inferredType = direction == 'to-main'
                  ? 'withdraw'
                  : direction == 'from-main'
                  ? 'deposit'
                  : query['type'];
              return P2PWalletTransferPage(
                initialAsset: query['asset'],
                initialType: inferredType,
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
            builder: (_, _) =>
                P2PLimitTrackerPage(shellRenderMode: shellRenderMode),
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
            builder: (_, _) =>
                P2PAmlScreeningPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.p2pComplianceSourceOfFunds,
            name: AppRouteNames.sc269P2PSourceOfFunds,
            builder: (_, _) =>
                P2PSourceOfFundsPage(shellRenderMode: shellRenderMode),
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
            builder: (_, _) =>
                P2PTaxReportingPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.p2pOrderBook,
            name: AppRouteNames.sc273P2POrderBook,
            builder: (_, _) =>
                P2POrderBookPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.p2pDashboard,
            name: AppRouteNames.sc274P2PDashboard,
            builder: (_, _) =>
                P2PDashboardPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.p2pAchievements,
            name: AppRouteNames.sc275P2PAchievements,
            builder: (_, _) =>
                P2PAchievementsPage(shellRenderMode: shellRenderMode),
          ),
          _placeholderRoute(
            '/p2p/tax-report/detailed/:year',
            'P2P Tax Report Detail',
            backPath: AppRoutePaths.p2pTaxReporting,
          ),
          GoRoute(
            path: AppRoutePaths.p2p,
            name: AppRouteNames.sc282P2PHome,
            builder: (_, _) => P2PHomePage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.p2pMyOrders,
            name: AppRouteNames.sc281P2PMyOrders,
            builder: (_, _) =>
                P2PMyOrdersPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.support,
            name: AppRouteNames.sc294Support,
            builder: (_, _) => SupportPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.supportHelp,
            name: AppRouteNames.sc292HelpCenter,
            builder: (_, _) => HelpCenterPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.supportAnnouncements,
            name: AppRouteNames.sc293Announcements,
            builder: (_, _) =>
                AnnouncementsPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.launchpad,
            name: AppRouteNames.sc295Launchpad,
            builder: (_, _) => LaunchpadPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.launchpadPortfolio,
            name: AppRouteNames.sc296LaunchpadPortfolio,
            builder: (_, _) =>
                LaunchpadPortfolioPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.launchpadPerformance,
            name: AppRouteNames.sc297LaunchpadPerformance,
            builder: (_, _) =>
                LaunchpadPerformancePage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.launchpadStaking,
            name: AppRouteNames.sc298LaunchpadStaking,
            builder: (_, _) =>
                LaunchpadStakingPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.launchpadIdoBridgeSample,
            name: AppRouteNames.sc299LaunchpadIdoBridge,
            builder: (_, _) =>
                LaunchpadIdoBridgePage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.launchpadContractSample,
            name: AppRouteNames.sc300LaunchpadContract,
            builder: (_, _) =>
                LaunchpadContractPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.launchpadReceiptSub001,
            name: AppRouteNames.sc301LaunchpadReceipt,
            builder: (_, _) =>
                LaunchpadReceiptPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.launchpadClaimReceiptPos001,
            name: AppRouteNames.sc302LaunchpadClaimReceipt,
            builder: (_, _) =>
                LaunchpadClaimReceiptPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.launchpadBatchClaim,
            name: AppRouteNames.sc304LaunchpadBatchClaim,
            builder: (_, _) =>
                LaunchpadBatchClaimPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.launchpadBridgeCompare,
            name: AppRouteNames.sc305LaunchpadBridgeCompare,
            builder: (_, _) =>
                LaunchpadBridgeComparePage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.launchpadNotifSound,
            name: AppRouteNames.sc306LaunchpadNotifSound,
            builder: (_, _) =>
                LaunchpadNotifSoundPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.launchpadEventLog,
            name: AppRouteNames.sc307LaunchpadEventLog,
            builder: (_, _) =>
                LaunchpadEventLogPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.launchpadAbiDiff,
            name: AppRouteNames.sc308LaunchpadAbiDiff,
            builder: (_, _) =>
                LaunchpadAbiDiffPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.launchpadAddressBook,
            name: AppRouteNames.sc309LaunchpadAddressBook,
            builder: (_, _) =>
                LaunchpadAddressBookPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.launchpadWebhooks,
            name: AppRouteNames.sc310LaunchpadWebhooks,
            builder: (_, _) =>
                LaunchpadWebhooksPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.launchpadGasTracker,
            name: AppRouteNames.sc311LaunchpadGasTracker,
            builder: (_, _) =>
                LaunchpadGasTrackerPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.launchpadRebalance,
            name: AppRouteNames.sc312LaunchpadRebalance,
            builder: (_, _) =>
                LaunchpadRebalancePage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.launchpadMultisig,
            name: AppRouteNames.sc313LaunchpadMultisig,
            builder: (_, _) =>
                LaunchpadMultisigPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.launchpadSwapAggregator,
            name: AppRouteNames.sc314LaunchpadSwapAggregator,
            builder: (_, _) =>
                LaunchpadSwapAggregatorPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.launchpadLimitOrders,
            name: AppRouteNames.sc315LaunchpadLimitOrders,
            builder: (_, _) =>
                LaunchpadLimitOrdersPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.launchpadDcaBuilder,
            name: AppRouteNames.sc316LaunchpadDcaBuilder,
            builder: (_, _) =>
                LaunchpadDcaBuilderPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.launchpadRiskAnalytics,
            name: AppRouteNames.sc317LaunchpadRiskAnalytics,
            builder: (_, _) =>
                LaunchpadRiskAnalyticsPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.launchpadSample,
            name: AppRouteNames.sc318LaunchpadDetail,
            builder: (_, _) =>
                LaunchpadDetailPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.launchpadBridgeOrderTx001,
            name: AppRouteNames.sc303LaunchpadBridgeOrder,
            builder: (_, _) =>
                LaunchpadBridgeOrderPage(shellRenderMode: shellRenderMode),
          ),
          ..._launchpadOutgoingPlaceholders,
          GoRoute(
            path: AppRoutePaths.arena,
            name: AppRouteNames.sc184ArenaHome,
            builder: (_, _) => ArenaHomePage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.arenaGuide,
            name: AppRouteNames.sc209ArenaGuide,
            builder: (_, _) => ArenaGuidePage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.arenaStudio,
            name: AppRouteNames.sc185ArenaStudio,
            builder: (_, _) =>
                ArenaStudioPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.arenaStudioSmartRules,
            name: AppRouteNames.sc186ArenaSmartRules,
            builder: (_, _) =>
                ArenaSmartRuleBuilderPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.arenaStudioPresets,
            name: AppRouteNames.sc187ArenaPresetLibrary,
            builder: (_, _) => ArenaUniversalPresetLibraryPage(
              shellRenderMode: shellRenderMode,
            ),
          ),
          GoRoute(
            path: AppRoutePaths.arenaStudioGovernance,
            name: AppRouteNames.sc188ArenaGovernanceGate,
            builder: (_, _) =>
                ArenaGovernanceGatePage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: '/arena/mode/:modeId',
            name: AppRouteNames.sc189ArenaModeDetail,
            builder: (_, state) => ArenaModeDetailPage(
              modeId: state.pathParameters['modeId'] ?? 'mode001',
              shellRenderMode: shellRenderMode,
            ),
          ),
          GoRoute(
            path: '/arena/challenge/:challengeId',
            name: AppRouteNames.sc190ArenaChallengeDetail,
            builder: (_, state) => ArenaChallengeDetailPage(
              challengeId: state.pathParameters['challengeId'] ?? 'ch003',
              shellRenderMode: shellRenderMode,
            ),
          ),
          GoRoute(
            path: '/arena/join/:challengeId',
            name: AppRouteNames.sc191ArenaJoin,
            builder: (_, state) => ArenaJoinPage(
              challengeId: state.pathParameters['challengeId'] ?? 'ch003',
              shellRenderMode: shellRenderMode,
            ),
          ),
          GoRoute(
            path: AppRoutePaths.arenaResolution,
            name: AppRouteNames.sc192ArenaResolutionCenter,
            builder: (_, _) =>
                ArenaResolutionCenterPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: '/arena/creator/:creatorId',
            name: AppRouteNames.sc193ArenaCreator,
            builder: (_, state) => ArenaCreatorPage(
              creatorId: state.pathParameters['creatorId'] ?? 'cr001',
              shellRenderMode: shellRenderMode,
            ),
          ),
          GoRoute(
            path: AppRoutePaths.arenaLeaderboard,
            name: AppRouteNames.sc194ArenaLeaderboard,
            builder: (_, _) =>
                ArenaLeaderboardPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.arenaVerified,
            name: AppRouteNames.sc195VerifiedChallenges,
            builder: (_, _) =>
                VerifiedChallengesPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.arenaPoints,
            redirect: (_, _) => '${AppRoutePaths.rewards}?tab=arena',
          ),
          GoRoute(
            path: AppRoutePaths.rewards,
            name: AppRouteNames.sc319RewardsHub,
            builder: (_, _) => RewardsHubPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.enterpriseStates,
            name: AppRouteNames.sc320EnterpriseStates,
            builder: (_, _) =>
                EnterpriseStatesPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.unifiedPortfolio,
            name: AppRouteNames.sc321UnifiedPortfolio,
            builder: (_, _) =>
                UnifiedPortfolioDashboard(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.crossModuleAnalytics,
            name: AppRouteNames.sc322CrossModuleAnalytics,
            builder: (_, _) =>
                CrossModuleAnalytics(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.smartAlerts,
            name: AppRouteNames.sc323SmartAlertCenter,
            builder: (_, _) =>
                SmartAlertCenter(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.taxReports,
            name: AppRouteNames.sc324TaxReportCenter,
            builder: (_, _) =>
                TaxReportCenter(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.routeChecker,
            name: AppRouteNames.sc325RouteChecker,
            builder: (_, _) => RouteChecker(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.performanceMonitor,
            name: AppRouteNames.sc326PerformanceMonitor,
            builder: (_, _) =>
                PerformanceMonitor(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.devShowcase,
            name: AppRouteNames.sc398MissingScreensShowcase,
            builder: (_, _) =>
                MissingScreensShowcasePage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.devDesignSystem,
            name: AppRouteNames.sc399DesignSystem,
            builder: (_, _) =>
                DesignSystemPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.devDcaOverview,
            name: AppRouteNames.sc400DcaOverviewDemo,
            builder: (_, _) =>
                DCAOverviewDemo(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.demoCopyCard,
            name: AppRouteNames.sc401CopyTradingCardDemo,
            builder: (_, _) =>
                CopyTradingCardDemo(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.earn,
            name: AppRouteNames.sc327StakingEarn,
            builder: (_, _) =>
                StakingEarnPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.earnStaking,
            name: AppRouteNames.sc328StakingEarnStaking,
            builder: (_, _) => StakingEarnPage(
              shellRenderMode: shellRenderMode,
              route: StakingEarnRoute.staking,
            ),
          ),
          GoRoute(
            path: AppRoutePaths.earnStakingTerms,
            name: AppRouteNames.sc353StakingTerms,
            builder: (_, _) =>
                StakingTermsPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.earnStakingRiskDisclosure,
            name: AppRouteNames.sc354StakingRiskDisclosure,
            builder: (_, _) =>
                StakingRiskDisclosurePage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.earnStakingWithdrawalPolicy,
            name: AppRouteNames.sc355StakingWithdrawalPolicy,
            builder: (_, _) =>
                StakingWithdrawalPolicyPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.earnStakingTaxGuide,
            name: AppRouteNames.sc356StakingTaxGuide,
            builder: (_, _) =>
                StakingTaxGuidePage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.earnHistory,
            name: AppRouteNames.sc360StakingHistory,
            builder: (_, _) =>
                StakingHistoryPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.earnStakingRiskAssessment,
            name: AppRouteNames.sc357StakingRiskAssessment,
            builder: (_, _) =>
                StakingRiskAssessmentPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.earnDashboard,
            name: AppRouteNames.sc358StakingDashboard,
            builder: (_, _) =>
                StakingDashboardPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.earnAnalytics,
            name: AppRouteNames.sc359StakingAnalytics,
            builder: (_, _) =>
                StakingAnalyticsPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.earnCalendar,
            name: AppRouteNames.sc361StakingEarningsCalendar,
            builder: (_, _) =>
                StakingEarningsCalendarPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.earnValidatorSelection,
            name: AppRouteNames.sc362StakingValidatorSelection,
            builder: (_, _) =>
                StakingValidatorSelectionPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.earnAutoCompound,
            name: AppRouteNames.sc363StakingAutoCompound,
            builder: (_, _) =>
                StakingAutoCompoundPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.earnLiquidStaking,
            name: AppRouteNames.sc364StakingLiquidStaking,
            builder: (_, _) =>
                StakingLiquidStakingPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.earnInsurance,
            name: AppRouteNames.sc365StakingInsurance,
            builder: (_, _) =>
                StakingInsurancePage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.earnAdvancedOrders,
            name: AppRouteNames.sc366StakingAdvancedOrders,
            builder: (_, _) =>
                StakingAdvancedOrdersPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.earnMultiChain,
            name: AppRouteNames.sc367StakingMultiChain,
            builder: (_, _) =>
                StakingMultiChainPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.earnInstitutional,
            name: AppRouteNames.sc368StakingInstitutional,
            builder: (_, _) =>
                StakingInstitutionalPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.earnGuide,
            name: AppRouteNames.sc369StakingGuide,
            builder: (_, _) =>
                StakingGuidePage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.earnFAQ,
            name: AppRouteNames.sc370StakingFAQ,
            builder: (_, _) => StakingFAQPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.earnNotifications,
            name: AppRouteNames.sc371StakingNotifications,
            builder: (_, _) =>
                StakingNotificationsPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.earnRecommendations,
            name: AppRouteNames.sc372StakingRecommendations,
            builder: (_, _) =>
                StakingRecommendationsPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.earnRegulatoryFramework,
            name: AppRouteNames.sc373StakingRegulatoryFramework,
            builder: (_, _) => StakingRegulatoryFrameworkPage(
              shellRenderMode: shellRenderMode,
            ),
          ),
          GoRoute(
            path: AppRoutePaths.earnAuditReports,
            name: AppRouteNames.sc374StakingAuditReports,
            builder: (_, _) =>
                StakingAuditReportsPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.earnCustody,
            name: AppRouteNames.sc375StakingCustody,
            builder: (_, _) =>
                StakingCustodyPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.earnSuitabilityAssessment,
            name: AppRouteNames.sc376StakingSuitabilityAssessment,
            builder: (_, _) => StakingSuitabilityAssessmentPage(
              shellRenderMode: shellRenderMode,
            ),
          ),
          GoRoute(
            path: AppRoutePaths.earnInsuranceFundTransparency,
            name: AppRouteNames.sc377StakingInsuranceFundTransparency,
            builder: (_, _) => StakingInsuranceFundTransparencyPage(
              shellRenderMode: shellRenderMode,
            ),
          ),
          GoRoute(
            path: AppRoutePaths.earnTransactionReporting,
            name: AppRouteNames.sc378StakingTransactionReporting,
            builder: (_, _) => StakingTransactionReportingPage(
              shellRenderMode: shellRenderMode,
            ),
          ),
          GoRoute(
            path: AppRoutePaths.earnApiDocumentation,
            name: AppRouteNames.sc379StakingApiDocumentation,
            builder: (_, _) =>
                StakingApiDocumentationPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.earnProofOfReserves,
            name: AppRouteNames.sc380StakingProofOfReserves,
            builder: (_, _) =>
                StakingProofOfReservesPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.earnRiskDashboard,
            name: AppRouteNames.sc381StakingRiskDashboard,
            builder: (_, _) =>
                StakingRiskDashboardPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.earnSlashingHistory,
            name: AppRouteNames.sc382StakingSlashingHistory,
            builder: (_, _) =>
                StakingSlashingHistoryPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.earnValidatorHealthMonitor,
            name: AppRouteNames.sc383StakingValidatorHealthMonitor,
            builder: (_, _) => StakingValidatorHealthMonitorPage(
              shellRenderMode: shellRenderMode,
            ),
          ),
          GoRoute(
            path: AppRoutePaths.earnRiskScoreCalculator,
            name: AppRouteNames.sc384StakingRiskScoreCalculator,
            builder: (_, _) => StakingRiskScoreCalculatorPage(
              shellRenderMode: shellRenderMode,
            ),
          ),
          GoRoute(
            path: AppRoutePaths.earnEmergencyActions,
            name: AppRouteNames.sc385StakingEmergencyActions,
            builder: (_, _) =>
                StakingEmergencyActionsPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.earnContingencyPlan,
            name: AppRouteNames.sc386StakingContingencyPlan,
            builder: (_, _) =>
                StakingContingencyPlanPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.earnSocialFeed,
            name: AppRouteNames.sc387StakingSocialFeed,
            builder: (_, _) =>
                StakingSocialFeedPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.earnCommunityGovernance,
            name: AppRouteNames.sc388StakingCommunityGovernance,
            builder: (_, _) => StakingCommunityGovernancePage(
              shellRenderMode: shellRenderMode,
            ),
          ),
          GoRoute(
            path: AppRoutePaths.earnProposals,
            name: AppRouteNames.sc389StakingProposals,
            builder: (_, _) =>
                StakingProposalsPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.earnVotingProposalRoute,
            name: AppRouteNames.sc390StakingVotingDetail,
            builder: (_, state) => StakingVotingPage(
              proposalId: state.pathParameters['proposalId'] ?? 'prop001',
              shellRenderMode: shellRenderMode,
            ),
          ),
          GoRoute(
            path: AppRoutePaths.earnVoting,
            name: AppRouteNames.sc391StakingVoting,
            builder: (_, _) =>
                StakingVotingPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.earnForum,
            name: AppRouteNames.sc392StakingForum,
            builder: (_, _) =>
                StakingForumPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.earnWebhooks,
            name: AppRouteNames.sc393StakingWebhooks,
            builder: (_, _) =>
                StakingWebhooksPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.earnDataExport,
            name: AppRouteNames.sc394StakingDataExport,
            builder: (_, _) =>
                StakingDataExportPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.earnThirdPartyIntegrations,
            name: AppRouteNames.sc395StakingThirdPartyIntegrations,
            builder: (_, _) => StakingThirdPartyIntegrationsPage(
              shellRenderMode: shellRenderMode,
            ),
          ),
          GoRoute(
            path: AppRoutePaths.earnDeveloperConsole,
            name: AppRouteNames.sc396StakingDeveloperConsole,
            builder: (_, _) =>
                StakingDeveloperConsolePage(shellRenderMode: shellRenderMode),
          ),
          ..._earnRiskOutgoingPlaceholders,
          GoRoute(
            path: AppRoutePaths.earnSavings,
            name: AppRouteNames.sc329Savings,
            builder: (_, _) => SavingsPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.earnSavingsPortfolio,
            name: AppRouteNames.sc333SavingsPortfolio,
            builder: (_, _) =>
                SavingsPortfolioPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.earnSavingsHistory,
            name: AppRouteNames.sc334SavingsHistory,
            builder: (_, _) =>
                SavingsHistoryPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.earnSavingsGuide,
            name: AppRouteNames.sc335SavingsGuide,
            builder: (_, _) =>
                SavingsGuidePage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.earnSavingsFAQ,
            name: AppRouteNames.sc336SavingsFAQ,
            builder: (_, _) => SavingsFAQPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.earnSavingsNotifications,
            name: AppRouteNames.sc337SavingsNotifications,
            builder: (_, _) =>
                SavingsNotificationsPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.earnSavingsRecommendations,
            name: AppRouteNames.sc338SavingsRecommendations,
            builder: (_, _) =>
                SavingsRecommendationsPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.earnSavingsRiskAssessment,
            name: AppRouteNames.sc339SavingsRiskAssessment,
            builder: (_, _) =>
                SavingsRiskAssessmentPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.earnSavingsComparison,
            name: AppRouteNames.sc340SavingsComparison,
            builder: (_, _) =>
                SavingsComparisonPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.earnSavingsAutoCompound,
            name: AppRouteNames.sc341AutoCompoundSettings,
            builder: (_, _) =>
                AutoCompoundSettingsPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.earnSavingsGoals,
            name: AppRouteNames.sc342SavingsGoal,
            builder: (_, _) =>
                SavingsGoalPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.earnSavingsAnalytics,
            name: AppRouteNames.sc343SavingsAnalytics,
            builder: (_, _) =>
                SavingsAnalyticsPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.earnSavingsRebalance,
            name: AppRouteNames.sc344SavingsAutoRebalance,
            builder: (_, _) =>
                SavingsAutoRebalancePage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.earnSavingsNotificationPreferences,
            name: AppRouteNames.sc345SavingsNotificationPreferences,
            builder: (_, _) => SavingsNotificationPreferencesPage(
              shellRenderMode: shellRenderMode,
            ),
          ),
          GoRoute(
            path: AppRoutePaths.earnSavingsDca,
            name: AppRouteNames.sc346SavingsDca,
            builder: (_, _) => SavingsDCAPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.earnSavingsSmartSuggestions,
            name: AppRouteNames.sc347SavingsSmartSuggestions,
            builder: (_, _) =>
                SavingsSmartSuggestionsPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.earnSavingsExport,
            name: AppRouteNames.sc348SavingsExport,
            builder: (_, _) =>
                SavingsExportPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.earnSavingsBacktest,
            name: AppRouteNames.sc349SavingsBacktest,
            builder: (_, _) =>
                SavingsBacktestPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.earnSavingsAutoPilot,
            name: AppRouteNames.sc350SavingsAutoPilot,
            builder: (_, _) =>
                SavingsAutoPilotPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.earnSavingsLadder,
            name: AppRouteNames.sc351SavingsLadder,
            builder: (_, _) =>
                SavingsLadderPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.earnSavingsWhatIf,
            name: AppRouteNames.sc352SavingsWhatIf,
            builder: (_, _) =>
                SavingsWhatIfPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.earnSavingsProductSample,
            name: AppRouteNames.sc330SavingsProductDetail,
            builder: (_, _) => SavingsProductDetailPage(
              productId: 'sample',
              shellRenderMode: shellRenderMode,
            ),
          ),
          GoRoute(
            path: AppRoutePaths.earnSavingsRedeemPos001,
            name: AppRouteNames.sc331SavingsRedeem,
            builder: (_, _) => SavingsRedeemPage(
              positionId: 'pos001',
              shellRenderMode: shellRenderMode,
            ),
          ),
          GoRoute(
            path: AppRoutePaths.earnSavingsReceipt,
            name: AppRouteNames.sc332SavingsReceipt,
            builder: (_, _) =>
                SavingsReceiptPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.arenaFlowMap,
            name: AppRouteNames.sc197ArenaFlowMap,
            builder: (_, _) =>
                ArenaFlowMapPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.arenaSafety,
            name: AppRouteNames.sc198ArenaSafetyCenter,
            builder: (_, _) =>
                ArenaSafetyCenterPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.arenaBlocked,
            name: AppRouteNames.sc203ArenaBlockedUsers,
            builder: (_, _) =>
                ArenaBlockedUsersPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.arenaMyReports,
            name: AppRouteNames.sc204MyArenaReports,
            builder: (_, _) =>
                MyArenaReportsPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.arenaMy,
            name: AppRouteNames.sc205MyArena,
            builder: (_, _) => MyArenaPage(
              contractScope: MyArenaContractScope.arena,
              shellRenderMode: shellRenderMode,
            ),
          ),
          GoRoute(
            path: AppRoutePaths.arenaProduction,
            name: AppRouteNames.sc206ArenaProductionReady,
            builder: (_, _) =>
                ArenaProductionReadyPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.arenaBridge,
            name: AppRouteNames.sc207ArenaPredictionBridgeFoundation,
            builder: (_, _) => ArenaPredictionBridgeFoundationPage(
              shellRenderMode: shellRenderMode,
            ),
          ),
          GoRoute(
            path: AppRoutePaths.arenaEcosystem,
            name: AppRouteNames.sc208ConnectedEcosystemProduction,
            builder: (_, _) => ConnectedEcosystemProductionPage(
              shellRenderMode: shellRenderMode,
            ),
          ),
          GoRoute(
            path: '/arena/trust/:userId',
            name: AppRouteNames.sc199ArenaTrustBreakdown,
            builder: (_, state) => ArenaTrustBreakdownPage(
              entityId: state.pathParameters['userId'] ?? 'user001',
              shellRenderMode: shellRenderMode,
            ),
          ),
          GoRoute(
            path: '/arena/ledger/entry/:entryId',
            name: AppRouteNames.sc200ArenaPointsEntryDetail,
            builder: (_, state) => ArenaPointsEntryDetailPage(
              entryId: state.pathParameters['entryId'] ?? 'entry001',
              shellRenderMode: shellRenderMode,
            ),
          ),
          GoRoute(
            path: AppRoutePaths.arenaLedger,
            name: AppRouteNames.sc201ArenaPointsLedger,
            builder: (_, _) =>
                ArenaPointsLedgerPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: '/arena/report/:caseId',
            name: AppRouteNames.sc202ArenaReportCase,
            builder: (_, state) => ArenaReportCasePage(
              caseId: state.pathParameters['caseId'] ?? 'case001',
              shellRenderMode: shellRenderMode,
            ),
          ),
          GoRoute(
            path: AppRoutePaths.dca,
            name: AppRouteNames.sc169Dca,
            builder: (_, _) => DCAPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.dcaPortfolioOptimizer,
            name: AppRouteNames.sc174DcaPortfolioOptimizer,
            builder: (_, _) =>
                DCAPortfolioOptimizer(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.dcaDynamicAmount,
            name: AppRouteNames.sc175DcaDynamicAmount,
            builder: (_, _) =>
                DCADynamicAmount(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.dcaBacktester,
            name: AppRouteNames.sc176DcaBacktester,
            builder: (_, _) =>
                DCABacktesterPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.dcaMultiAsset,
            name: AppRouteNames.sc177DcaMultiAsset,
            builder: (_, _) =>
                DCAMultiAssetPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.dcaPerformanceCompare,
            name: AppRouteNames.sc178DcaPerformanceCompare,
            builder: (_, _) =>
                DCAPerformanceComparePage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.dcaSmartRules,
            name: AppRouteNames.sc179DcaSmartRules,
            builder: (_, _) =>
                DCASmartRulesPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.dcaRebalanceConfig,
            name: AppRouteNames.sc170DcaRebalanceConfig,
            builder: (_, _) =>
                DCARebalanceConfig(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.dcaRebalanceDashboard,
            name: AppRouteNames.sc171DcaRebalanceDashboard,
            builder: (_, _) => DCARebalanceDashboard(
              configId: 'config001',
              shellRenderMode: shellRenderMode,
            ),
          ),
          GoRoute(
            path: AppRoutePaths.dcaScheduleConfig,
            name: AppRouteNames.sc172DcaScheduleConfig,
            builder: (_, _) =>
                DCAScheduleConfig(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.dcaScheduleAnalytics,
            name: AppRouteNames.sc173DcaScheduleAnalytics,
            builder: (_, _) => DCAScheduleAnalytics(
              configId: 'config001',
              shellRenderMode: shellRenderMode,
            ),
          ),
          ..._dcaOutgoingPlaceholders,
          GoRoute(
            path: AppRoutePaths.wallet,
            name: AppRouteNames.sc135Wallet,
            builder: (_, _) => WalletPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.walletHistory,
            name: AppRouteNames.sc136TxHistory,
            builder: (_, _) =>
                TransactionHistoryPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.walletDeposit,
            name: AppRouteNames.sc137Deposit,
            builder: (_, _) => DepositPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: '${AppRoutePaths.walletDeposit}/:asset',
            name: AppRouteNames.sc138DepositUsdt,
            builder: (_, state) => DepositPage(
              asset: state.pathParameters['asset'] ?? 'USDT',
              assetScoped: true,
              shellRenderMode: shellRenderMode,
            ),
          ),
          GoRoute(
            path: AppRoutePaths.walletWithdraw,
            name: AppRouteNames.sc139Withdraw,
            builder: (_, _) => WithdrawPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: '${AppRoutePaths.walletWithdraw}/:asset',
            name: AppRouteNames.sc140WithdrawUsdt,
            builder: (_, state) => WithdrawPage(
              asset: state.pathParameters['asset'] ?? 'USDT',
              assetScoped: true,
              shellRenderMode: shellRenderMode,
            ),
          ),
          GoRoute(
            path: '/wallet/transaction/:txId',
            name: AppRouteNames.sc141TransactionDetail,
            builder: (_, state) => TransactionDetailPage(
              transactionId: state.pathParameters['txId'] ?? 'tx001',
              shellRenderMode: shellRenderMode,
            ),
          ),
          GoRoute(
            path: AppRoutePaths.walletPortfolioAnalytics,
            name: AppRouteNames.sc142PortfolioAnalytics,
            builder: (_, _) =>
                PortfolioAnalyticsPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.walletAddressBookAdd,
            name: AppRouteNames.sc143AddressAdd,
            builder: (_, _) => AddressAddPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.walletAddressBook,
            name: AppRouteNames.sc144AddressBook,
            builder: (_, _) =>
                AddressBookPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.walletBuyCrypto,
            name: AppRouteNames.sc145BuyCrypto,
            builder: (_, _) => BuyCryptoPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.walletTransfer,
            name: AppRouteNames.sc146Transfer,
            builder: (_, _) => TransferPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: '/wallet/asset/:assetId',
            name: AppRouteNames.sc147AssetDetail,
            builder: (_, state) => AssetDetailPage(
              assetId: state.pathParameters['assetId'] ?? 'btc',
              shellRenderMode: shellRenderMode,
            ),
          ),
          GoRoute(
            path: AppRoutePaths.walletMultiManager,
            name: AppRouteNames.sc148MultiManager,
            builder: (_, _) =>
                WalletMultiManagerPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.walletGasOptimizer,
            name: AppRouteNames.sc149GasOptimizer,
            builder: (_, _) =>
                WalletGasOptimizerPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.walletTokenApproval,
            name: AppRouteNames.sc150TokenApproval,
            builder: (_, _) =>
                WalletTokenApprovalPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.walletHealthScore,
            name: AppRouteNames.sc151HealthScore,
            builder: (_, _) =>
                WalletHealthScorePage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.walletPendingDeposits,
            name: AppRouteNames.sc152PendingDeposits,
            builder: (_, _) =>
                PendingDepositsPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.walletLimits,
            name: AppRouteNames.sc153WithdrawLimits,
            builder: (_, _) =>
                WithdrawLimitsPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.walletDustConverter,
            name: AppRouteNames.sc154DustConverter,
            builder: (_, _) =>
                DustConverterPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.walletNetworkStatus,
            name: AppRouteNames.sc155NetworkStatus,
            builder: (_, _) =>
                NetworkStatusPage(shellRenderMode: shellRenderMode),
          ),
          ..._walletOutgoingPlaceholders,
          GoRoute(
            path: AppRoutePaths.profile,
            name: AppRouteNames.sc156Profile,
            builder: (_, _) => ProfilePage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.profileEdit,
            name: AppRouteNames.sc157EditProfile,
            builder: (_, _) =>
                EditProfilePage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.profileKyc,
            name: AppRouteNames.sc159Kyc,
            builder: (_, _) => KYCPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.profileSecurity,
            name: AppRouteNames.sc158Security,
            builder: (_, _) => SecurityPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.profileSettings,
            name: AppRouteNames.sc160Settings,
            builder: (_, _) => SettingsPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.profileActivity,
            name: AppRouteNames.sc161ActivityLog,
            builder: (_, _) =>
                ActivityLogPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.profileApi,
            name: AppRouteNames.sc163ApiManagement,
            builder: (_, _) =>
                ApiManagementPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.profileApiCreate,
            name: AppRouteNames.sc162ApiKeyCreate,
            builder: (_, _) =>
                ApiKeyCreatePage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.profileVip,
            name: AppRouteNames.sc164Vip,
            builder: (_, _) => VIPPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.profileDevices,
            name: AppRouteNames.sc165DeviceManagement,
            builder: (_, _) =>
                DeviceManagementPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.profileSubAccounts,
            name: AppRouteNames.sc166SubAccount,
            builder: (_, _) => SubAccountPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.profilePredictions,
            name: AppRouteNames.sc167ProfilePredictions,
            builder: (_, _) => PredictionsPortfolioPage(
              shellRenderMode: shellRenderMode,
              backPath: AppRoutePaths.profile,
              semanticLabel: 'SC-167 PredictionsPortfolioPage',
            ),
          ),
          GoRoute(
            path: AppRoutePaths.profileArena,
            name: AppRouteNames.sc168MyArena,
            builder: (_, _) => MyArenaPage(shellRenderMode: shellRenderMode),
          ),
          ..._profileOutgoingPlaceholders,
          GoRoute(
            path: AppRoutePaths.search,
            name: AppRouteNames.sc283UnifiedSearch,
            builder: (_, _) =>
                UnifiedSearchPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.notifications,
            name: AppRouteNames.sc291Notifications,
            builder: (_, _) =>
                NotificationsPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.topics,
            name: AppRouteNames.sc284TopicHub,
            builder: (_, _) => TopicHubPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.topicCrypto,
            name: AppRouteNames.sc285TopicCrypto,
            builder: (_, _) => TopicHubPage(
              initialTopicId: 'crypto',
              useDetailEndpoint: true,
              shellRenderMode: shellRenderMode,
            ),
          ),
          GoRoute(
            path: AppRoutePaths.referral,
            name: AppRouteNames.sc290ReferralHome,
            builder: (_, _) =>
                ReferralHomePage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.referralHistory,
            name: AppRouteNames.sc286ReferralHistory,
            builder: (_, _) =>
                ReferralHistoryPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.referralRewards,
            name: AppRouteNames.sc287ReferralRewards,
            builder: (_, _) =>
                ReferralRewardsPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.referralRules,
            name: AppRouteNames.sc288ReferralRules,
            builder: (_, _) =>
                ReferralRulesPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: '/referral/friend/:friendId',
            name: AppRouteNames.sc289ReferralFriendDetail,
            builder: (_, state) => ReferralFriendDetailPage(
              friendId: state.pathParameters['friendId'] ?? 'friend001',
            ),
          ),
          ..._homeOutgoingPlaceholders,
          ..._marketOutgoingPlaceholders,
        ],
      ),
    ],
  );
}

OTPPage _buildOtpPage(GoRouterState state) {
  final extra = state.extra;
  final query = state.uri.queryParameters;
  OtpPageRouteArgs? args;
  if (extra is OtpPageRouteArgs) {
    args = extra;
  }

  final purposeText = args?.purpose?.name ?? query['purpose'];
  final purpose = switch (purposeText) {
    'register' => AuthOtpPurpose.register,
    'twoFactor' || '2fa' => AuthOtpPurpose.twoFactor,
    'passwordReset' || 'reset' => AuthOtpPurpose.passwordReset,
    _ => AuthOtpPurpose.verify,
  };

  final contactTypeText = args?.contactType?.name ?? query['type'];
  final contactType = contactTypeText == 'phone'
      ? AuthContactType.phone
      : AuthContactType.email;

  return OTPPage(
    contact: args?.contact ?? query['contact'] ?? 'your@email.com',
    contactType: contactType,
    purpose: purpose,
  );
}

class _AuthRouteShell extends StatelessWidget {
  const _AuthRouteShell({required this.child, required this.renderMode});

  final Widget child;
  final ShellRenderMode renderMode;

  @override
  Widget build(BuildContext context) {
    final body = Material(
      color: AppColors.bg,
      child: SizedBox.expand(child: child),
    );

    if (!renderMode.usesVisualQaFrame) {
      return SafeArea(top: true, bottom: false, child: body);
    }

    return Material(
      color: AppColors.bg,
      child: Column(
        children: [
          const VitStatusBar(time: '23:27'),
          Expanded(child: body),
        ],
      ),
    );
  }
}

final GoRouter appRouter = createAppRouter();

VitBottomNavDestination _activeDestinationForPath(String path) {
  if (path == AppRoutePaths.news) {
    return VitBottomNavDestination.trade;
  }
  if (path == AppRoutePaths.search ||
      path == AppRoutePaths.notifications ||
      path == AppRoutePaths.topics ||
      path.startsWith('/topic/') ||
      path == AppRoutePaths.referral ||
      path.startsWith('/referral/') ||
      path == AppRoutePaths.enterpriseStates ||
      path == AppRoutePaths.unifiedPortfolio ||
      path == AppRoutePaths.crossModuleAnalytics ||
      path == AppRoutePaths.smartAlerts ||
      path == AppRoutePaths.taxReports ||
      path == AppRoutePaths.routeChecker ||
      path == AppRoutePaths.performanceMonitor ||
      path == AppRoutePaths.devShowcase ||
      path == AppRoutePaths.devDesignSystem ||
      path == AppRoutePaths.devDcaOverview ||
      path == AppRoutePaths.demoCopyCard ||
      path == AppRoutePaths.support ||
      path.startsWith('/support/') ||
      path == AppRoutePaths.launchpad ||
      path.startsWith('/launchpad/')) {
    return VitBottomNavDestination.trade;
  }
  if (path.startsWith(AppRoutePaths.markets)) {
    return VitBottomNavDestination.markets;
  }
  if (path.startsWith(AppRoutePaths.trade)) {
    return VitBottomNavDestination.trade;
  }
  if (path == AppRoutePaths.dca || path.startsWith('/dca/')) {
    return VitBottomNavDestination.trade;
  }
  if (path == AppRoutePaths.earn || path.startsWith('/earn/')) {
    return VitBottomNavDestination.trade;
  }
  if (path == AppRoutePaths.admin || path.startsWith('/admin/')) {
    return VitBottomNavDestination.trade;
  }
  if (path == AppRoutePaths.rewards) {
    return VitBottomNavDestination.trade;
  }
  if (path == AppRoutePaths.p2p || path.startsWith('/p2p/')) {
    return VitBottomNavDestination.trade;
  }
  if (path == AppRoutePaths.arena || path.startsWith('/arena/')) {
    return VitBottomNavDestination.trade;
  }
  if (path.startsWith('/pair/')) {
    return VitBottomNavDestination.trade;
  }
  if (path.startsWith(AppRoutePaths.wallet)) {
    return VitBottomNavDestination.wallet;
  }
  if (path.startsWith(AppRoutePaths.profile)) {
    return VitBottomNavDestination.profile;
  }
  return VitBottomNavDestination.home;
}

String _visualQaStatusBarTimeForUri(Uri uri) {
  final path = uri.path;
  if (path == AppRoutePaths.rewards) {
    return uri.queryParameters['tab'] == 'arena' ? '23:34' : '23:38';
  }
  if (path == AppRoutePaths.enterpriseStates) return '23:38';
  if (path == AppRoutePaths.unifiedPortfolio) return '23:38';
  if (path == AppRoutePaths.crossModuleAnalytics) return '23:38';
  if (path == AppRoutePaths.smartAlerts) return '23:38';
  if (path == AppRoutePaths.taxReports) return '08:40';
  if (path == AppRoutePaths.routeChecker) return '08:49';
  if (path == AppRoutePaths.performanceMonitor) return '09:01';
  if (path == AppRoutePaths.devShowcase) return '21:37';
  if (path == AppRoutePaths.devDesignSystem) return '21:44';
  if (path == AppRoutePaths.devDcaOverview) return '21:53';
  if (path == AppRoutePaths.demoCopyCard) return '22:04';
  if (path == AppRoutePaths.earn) return '09:11';
  if (path == AppRoutePaths.earnStaking) return '09:18';
  if (path == AppRoutePaths.earnStakingTerms) return '14:20';
  if (path == AppRoutePaths.earnStakingRiskDisclosure) return '14:33';
  if (path == AppRoutePaths.earnStakingWithdrawalPolicy) return '14:52';
  if (path == AppRoutePaths.earnStakingTaxGuide) return '15:02';
  if (path == AppRoutePaths.earnHistory) return '15:46';
  if (path == AppRoutePaths.earnStakingRiskAssessment) return '15:12';
  if (path == AppRoutePaths.earnDashboard) return '15:21';
  if (path == AppRoutePaths.earnAnalytics) return '15:34';
  if (path == AppRoutePaths.earnCalendar) return '15:56';
  if (path == AppRoutePaths.earnValidatorSelection) return '16:12';
  if (path == AppRoutePaths.earnAutoCompound) return '16:22';
  if (path == AppRoutePaths.earnLiquidStaking) return '16:31';
  if (path == AppRoutePaths.earnInsurance) return '16:42';
  if (path == AppRoutePaths.earnAdvancedOrders) return '16:54';
  if (path == AppRoutePaths.earnMultiChain) return '17:01';
  if (path == AppRoutePaths.earnInstitutional) return '17:09';
  if (path == AppRoutePaths.earnGuide) return '17:16';
  if (path == AppRoutePaths.earnFAQ) return '17:23';
  if (path == AppRoutePaths.earnNotifications) return '17:29';
  if (path == AppRoutePaths.earnRecommendations) return '17:37';
  if (path == AppRoutePaths.earnRegulatoryFramework) return '17:47';
  if (path == AppRoutePaths.earnAuditReports) return '17:56';
  if (path == AppRoutePaths.earnCustody) return '18:09';
  if (path == AppRoutePaths.earnSuitabilityAssessment) return '18:18';
  if (path == AppRoutePaths.earnInsuranceFundTransparency) return '18:29';
  if (path == AppRoutePaths.earnTransactionReporting) return '18:37';
  if (path == AppRoutePaths.earnApiDocumentation) return '18:47';
  if (path == AppRoutePaths.earnProofOfReserves) return '18:58';
  if (path == AppRoutePaths.earnRiskDashboard) return '19:08';
  if (path == AppRoutePaths.earnSlashingHistory) return '19:17';
  if (path == AppRoutePaths.earnValidatorHealthMonitor) return '19:25';
  if (path == AppRoutePaths.earnRiskScoreCalculator) return '19:37';
  if (path == AppRoutePaths.earnEmergencyActions) return '19:51';
  if (path == AppRoutePaths.earnContingencyPlan) return '19:58';
  if (path == AppRoutePaths.earnSocialFeed) return '20:05';
  if (path == AppRoutePaths.earnCommunityGovernance) return '20:12';
  if (path == AppRoutePaths.earnProposals) return '20:20';
  if (path == AppRoutePaths.earnVotingProposal('prop001')) return '20:29';
  if (path == AppRoutePaths.earnVoting) return '20:43';
  if (path == AppRoutePaths.earnForum) return '20:47';
  if (path == AppRoutePaths.earnWebhooks) return '20:55';
  if (path == AppRoutePaths.earnDataExport) return '21:04';
  if (path == AppRoutePaths.earnThirdPartyIntegrations) return '21:12';
  if (path == AppRoutePaths.earnDeveloperConsole) return '21:17';
  if (path == AppRoutePaths.earnSavings) return '09:22';
  if (path == AppRoutePaths.earnSavingsPortfolio) return '09:51';
  if (path == AppRoutePaths.earnSavingsHistory) return '09:59';
  if (path == AppRoutePaths.earnSavingsGuide) return '10:08';
  if (path == AppRoutePaths.earnSavingsFAQ) return '10:19';
  if (path == AppRoutePaths.earnSavingsNotifications) return '10:29';
  if (path == AppRoutePaths.earnSavingsRecommendations) return '10:38';
  if (path == AppRoutePaths.earnSavingsRiskAssessment) return '10:46';
  if (path == AppRoutePaths.earnSavingsComparison) return '10:58';
  if (path == AppRoutePaths.earnSavingsAutoCompound) return '11:11';
  if (path == AppRoutePaths.earnSavingsGoals) return '11:19';
  if (path == AppRoutePaths.earnSavingsAnalytics) return '11:29';
  if (path == AppRoutePaths.earnSavingsRebalance) return '11:45';
  if (path == AppRoutePaths.earnSavingsNotificationPreferences) return '11:58';
  if (path == AppRoutePaths.earnSavingsDca) return '12:08';
  if (path == AppRoutePaths.earnSavingsSmartSuggestions) return '12:18';
  if (path == AppRoutePaths.earnSavingsExport) return '12:29';
  if (path == AppRoutePaths.earnSavingsBacktest) return '12:43';
  if (path == AppRoutePaths.earnSavingsAutoPilot) return '12:55';
  if (path == AppRoutePaths.earnSavingsLadder) return '13:12';
  if (path == AppRoutePaths.earnSavingsWhatIf) return '14:06';
  if (path == AppRoutePaths.earnSavingsProductSample) return '09:32';
  if (path == AppRoutePaths.earnSavingsRedeemPos001) return '09:39';
  if (path == AppRoutePaths.earnSavingsReceipt) return '09:44';
  if (path == AppRoutePaths.rewards ||
      path == AppRoutePaths.arenaPoints ||
      path == AppRoutePaths.arenaFlowMap ||
      path == AppRoutePaths.arenaSafety ||
      path == AppRoutePaths.arenaBlocked ||
      path == AppRoutePaths.arenaMyReports ||
      path == AppRoutePaths.arenaMy ||
      path == AppRoutePaths.arenaProduction ||
      path == AppRoutePaths.arenaBridge ||
      path == AppRoutePaths.arenaEcosystem ||
      path == AppRoutePaths.arenaGuide ||
      path == AppRoutePaths.arenaLedger ||
      path.startsWith('/arena/report/') ||
      path.startsWith('/arena/trust/') ||
      path.startsWith('/arena/ledger/entry/')) {
    return '23:34';
  }
  if (path == AppRoutePaths.marketsSocialSentiment) return '23:28';
  if (path == AppRoutePaths.marketsPortfolioTracker) return '23:28';
  if (path == AppRoutePaths.marketsNews) return '23:28';
  if (path == AppRoutePaths.marketsAdvancedCharts) return '23:28';
  if (path == AppRoutePaths.marketsUnlocks) return '23:28';
  if (path == AppRoutePaths.marketsSignals) return '23:28';
  if (path == AppRoutePaths.marketsCorrelations) return '23:28';
  if (path == AppRoutePaths.marketsPredictions) return '23:28';
  if (path == AppRoutePaths.marketsPredictionsSearch) return '23:28';
  if (path == AppRoutePaths.marketsPredictionsBreaking) return '23:28';
  if (path.startsWith('/markets/predictions/event/')) return '23:28';
  if (path == AppRoutePaths.marketsPredictionsPortfolio) return '23:28';
  if (path == AppRoutePaths.marketsPredictionsRewards) return '23:28';
  if (path == AppRoutePaths.marketsPredictionsLeaderboard) return '23:28';
  if (path == AppRoutePaths.marketsPredictionsActivity) return '23:28';
  if (path.startsWith('/markets/predictions/receipt/')) return '23:28';
  if (path == AppRoutePaths.marketsPredictionsRiskCalculator) return '23:28';
  if (path == AppRoutePaths.marketsPredictionsMarketMaker) return '23:28';
  if (path == AppRoutePaths.marketsPredictionsPortfolioAnalyzer) {
    return '23:28';
  }
  if (path == AppRoutePaths.marketsPredictionsEventCalendar) return '23:28';
  if (path == AppRoutePaths.marketsPredictionsSocial) return '23:28';
  if (path.startsWith('/markets/predictions/advanced-chart/')) return '23:29';
  if (path == AppRoutePaths.marketsPredictionsTournaments) return '23:29';
  if (path.startsWith('/markets/predictions/tournament/')) return '23:29';
  if (path == AppRoutePaths.marketsPredictionsDataIntegration) return '23:29';
  if (path.startsWith('/pair/')) return '23:29';
  if (path == AppRoutePaths.news) return '23:29';
  if (path == AppRoutePaths.trade) return '23:29';
  if (path == AppRoutePaths.tradeBotTermsOfService) return '23:31';
  if (path == AppRoutePaths.tradeBotRiskDisclosure) return '23:31';
  if (path == AppRoutePaths.tradeBotSuitabilityAssessment) return '23:31';
  if (path == AppRoutePaths.tradeBotRiskDashboard) return '23:31';
  if (path == AppRoutePaths.tradeBotEmergencyStop) return '23:31';
  if (path == AppRoutePaths.tradeBotSecuritySettings) return '23:31';
  if (path == AppRoutePaths.tradeBotHistory) return '23:31';
  if (path == AppRoutePaths.tradeBotPerformanceAnalytics) return '23:31';
  if (path == AppRoutePaths.tradeBotBacktesting) return '23:31';
  if (path == AppRoutePaths.tradeBotStrategyCompare) return '23:31';
  if (path == AppRoutePaths.tradeBotOptimization) return '23:31';
  if (path == AppRoutePaths.tradeBotPortfolioDashboard) return '23:31';
  if (path == AppRoutePaths.tradeBotDrawdownAnalyzer) return '23:32';
  if (path == AppRoutePaths.tradeBotEquityCurve) return '23:32';
  if (path == AppRoutePaths.tradeBotGuide) return '23:32';
  if (path == AppRoutePaths.tradeBotFaq) return '23:32';
  if (path == AppRoutePaths.tradeBotTaxReporting) return '23:32';
  if (path == AppRoutePaths.tradeBotApiDocumentation) return '23:32';
  if (path.startsWith('/trade/advanced-chart/')) return '23:29';
  if (path.startsWith(AppRoutePaths.tradeCopyTargetMarketDefinition)) {
    return '23:31';
  }
  if (path == AppRoutePaths.tradeCopyClientMoneyProtection) return '23:31';
  if (path == AppRoutePaths.tradeCopyCassReconciliation) return '23:31';
  if (path == AppRoutePaths.tradeCopyInvestorCompensation) return '23:31';
  if (path == AppRoutePaths.tradeCopyExAnteCosts) return '23:31';
  if (path == AppRoutePaths.tradeCopyRiyCalculator) return '23:31';
  if (path == AppRoutePaths.tradeCopyExPostCostsReport) return '23:31';
  if (path == AppRoutePaths.tradeCopyKidGenerator) return '23:31';
  if (path == AppRoutePaths.tradeCopyPerformanceScenarios) return '23:31';
  if (path == AppRoutePaths.tradeCopyRiskIndicatorExplainer) return '23:31';
  if (path == AppRoutePaths.tradeCopyComplaintsHandling) return '23:31';
  if (path == AppRoutePaths.tradeCopyComplaintSubmission) return '23:31';
  if (path == AppRoutePaths.tradeCopyComplaintTrackingBase ||
      path.startsWith('${AppRoutePaths.tradeCopyComplaintTrackingBase}/')) {
    return '23:31';
  }
  if (path == AppRoutePaths.tradeCopyOmbudsmanReferral) return '23:31';
  if (path == AppRoutePaths.tradeCopyAuditTrail) return '23:31';
  if (path == AppRoutePaths.tradeCopyRegulatoryInspectionReady) return '23:31';
  if (path == AppRoutePaths.tradeCopyRegulatoryDisclosures) return '23:30';
  if (path.startsWith('/trade/margin')) return '23:30';
  if (path.startsWith('/trade/trader/')) return '23:30';
  if (path.startsWith('/trade/copy-provider/')) return '23:30';
  if (path.startsWith('/trade/copy-performance/')) return '23:30';
  if (path.startsWith('/trade/')) return '23:29';
  if (path.startsWith('/p2p/order/proof/')) return '23:35';
  if (path.startsWith('/p2p/order/') && path.split('/').length == 4) {
    return '23:35';
  }
  if (path.startsWith('/p2p/chat/')) return '23:35';
  if (path.startsWith('/p2p/dispute/detail/')) return '23:35';
  if (path.startsWith('/p2p/dispute/evidence/')) return '23:35';
  if (path.startsWith('/p2p/dispute/resolution/')) return '23:35';
  if (path.startsWith('/p2p/dispute/')) return '23:35';
  if (path == AppRoutePaths.p2pDisputes) return '23:35';
  if (path.startsWith('/p2p/ad-analytics/')) return '23:35';
  if (path.startsWith('/p2p/ad/')) return '23:35';
  if (path == AppRoutePaths.p2pMyAds) return '23:35';
  if (path == AppRoutePaths.p2pCreate) return '23:35';
  if (path == AppRoutePaths.p2pMerchantApply) return '23:35';
  if (path.startsWith('/p2p/merchant/')) return '23:35';
  if (path.startsWith('/p2p/report/')) return '23:35';
  if (path == AppRoutePaths.p2p) return '23:37';
  if (path == AppRoutePaths.p2pTradingLevel) return '23:35';
  if (path == AppRoutePaths.p2pReviews) return '23:35';
  if (path == AppRoutePaths.p2pBlacklist) return '23:37';
  if (path == AppRoutePaths.p2pBlacklistAdd) return '23:37';
  if (path == AppRoutePaths.p2pGuide) return '23:37';
  if (path == AppRoutePaths.p2pMyOrders) return '23:37';
  if (path == AppRoutePaths.p2pSettings) return '23:37';
  if (path == AppRoutePaths.p2pSettingsNotifications) return '23:37';
  if (path == AppRoutePaths.p2pPaymentMethodAdd) return '23:35';
  if (path.startsWith('/p2p/payment-method/verification/')) return '23:35';
  if (path.startsWith('/p2p/payment-method/ownership/')) return '23:35';
  if (path == AppRoutePaths.p2pPaymentMethodCoolingPeriod) return '23:35';
  if (path == AppRoutePaths.p2pPaymentMethodHistory) return '23:35';
  if (path == AppRoutePaths.p2pPaymentMethods) return '23:35';
  if (path == AppRoutePaths.p2pEscrowBalance) return '23:36';
  if (path.startsWith('/p2p/escrow/')) return '23:36';
  if (path == AppRoutePaths.p2pKycRequirements) return '23:36';
  if (path == AppRoutePaths.p2pKycStatus) return '23:36';
  if (path == AppRoutePaths.p2pKycIdentity) return '23:36';
  if (path == AppRoutePaths.p2pKycAddress) return '23:36';
  if (path == AppRoutePaths.p2pKycSelfie) return '23:36';
  if (path == AppRoutePaths.p2pKycVideo) return '23:36';
  if (path == AppRoutePaths.p2pSecurityCenter) return '23:36';
  if (path == AppRoutePaths.p2pSecurity2fa) return '23:36';
  if (path == AppRoutePaths.p2pSecurityDevices) return '23:36';
  if (path == AppRoutePaths.p2pSecurityAntiPhishing) return '23:36';
  if (path == AppRoutePaths.p2pSecurityLoginHistory) return '23:36';
  if (path == AppRoutePaths.p2pSecuritySuspiciousActivity) return '23:36';
  if (path == AppRoutePaths.p2pE2EInfo) return '23:36';
  if (path == AppRoutePaths.p2pFraudPrevention) return '23:36';
  if (path == AppRoutePaths.p2pWallet ||
      path == AppRoutePaths.p2pWalletTransfer ||
      path == AppRoutePaths.p2pWalletFundLockHistory ||
      path == AppRoutePaths.p2pWalletHistory ||
      path == AppRoutePaths.p2pLimits ||
      path == AppRoutePaths.p2pLimitsTracker ||
      path == AppRoutePaths.p2pComplianceOverview ||
      path == AppRoutePaths.p2pComplianceAmlScreening ||
      path == AppRoutePaths.p2pComplianceSourceOfFunds ||
      path == AppRoutePaths.p2pComplianceLargeTransaction ||
      path == AppRoutePaths.p2pComplianceRiskAssessment ||
      path == AppRoutePaths.p2pTaxReporting ||
      path == AppRoutePaths.p2pOrderBook ||
      path == AppRoutePaths.p2pDashboard ||
      path == AppRoutePaths.p2pAchievements ||
      path.startsWith('/p2p/tax-report/detailed/') ||
      path == AppRoutePaths.p2pMyOrders) {
    return path == AppRoutePaths.p2pAchievements ? '23:37' : '23:36';
  }
  if (path == AppRoutePaths.p2pInsurance ||
      path == AppRoutePaths.p2pInsuranceFundAlias ||
      path == AppRoutePaths.p2pInsuranceCertificate ||
      path == AppRoutePaths.p2pInsuranceScore ||
      path == AppRoutePaths.p2pInsurancePolicy ||
      path == AppRoutePaths.p2pContributionHistory ||
      path.startsWith('/p2p/insurance/claim/')) {
    return '23:35';
  }
  if (path == AppRoutePaths.p2p || path.startsWith('/p2p/')) return '23:34';
  if (path == AppRoutePaths.search) return '23:37';
  if (path == AppRoutePaths.notifications) return '23:37';
  if (path == AppRoutePaths.topics || path.startsWith('/topic/')) {
    return '23:37';
  }
  if (path == AppRoutePaths.referral || path.startsWith('/referral/')) {
    return '23:37';
  }
  if (path == AppRoutePaths.support || path.startsWith('/support/')) {
    return '23:37';
  }
  if (path == AppRoutePaths.launchpad || path.startsWith('/launchpad/')) {
    return '23:37';
  }
  if (path == AppRoutePaths.dca || path.startsWith('/dca/')) return '23:33';
  if (path == AppRoutePaths.admin || path.startsWith('/admin/')) return '23:33';
  if (path == AppRoutePaths.arena || path.startsWith('/arena/')) return '23:33';
  if (path.startsWith(AppRoutePaths.wallet)) return '23:32';
  if (path.startsWith(AppRoutePaths.profile)) return '23:33';
  if (path == AppRoutePaths.marketsDepth) return '23:28';
  if (path == AppRoutePaths.marketsDerivatives) return '23:28';
  if (path == AppRoutePaths.marketsCalendar) return '23:28';
  if (path == AppRoutePaths.marketsCompare) return '23:28';
  if (path == AppRoutePaths.marketsScreener) return '23:28';
  if (path == AppRoutePaths.marketsAlerts) return '23:28';
  if (path == AppRoutePaths.marketsHeatmap) return '23:28';
  if (path == AppRoutePaths.marketsWatchlist) return '23:28';
  return '23:27';
}

final List<GoRoute> _homeOutgoingPlaceholders = [
  _placeholderRoute(AppRoutePaths.p2p, 'P2P'),
];

final List<GoRoute> _launchpadOutgoingPlaceholders = [];

final List<GoRoute> _marketOutgoingPlaceholders = [];

final List<GoRoute> _walletOutgoingPlaceholders = [];

final List<GoRoute> _dcaOutgoingPlaceholders = [
  _placeholderRoute(
    '/dca/rebalance/:configId/edit',
    'Rebalance Settings',
    backPath: AppRoutePaths.dcaRebalanceDashboard,
  ),
  _placeholderRoute(
    '/dca/rebalance/:configId/history',
    'Rebalance History',
    backPath: AppRoutePaths.dcaRebalanceDashboard,
  ),
];

final List<GoRoute> _adminOutgoingPlaceholders = [
  _placeholderRoute(
    AppRoutePaths.adminSettings,
    'Admin Settings',
    backPath: AppRoutePaths.admin,
  ),
];

final List<GoRoute> _profileOutgoingPlaceholders = [];

final List<GoRoute> _tradeMarginOutgoingPlaceholders = [];

final List<GoRoute> _tradeCopyTradingOutgoingPlaceholders = [
  _placeholderRoute(
    AppRoutePaths.tradeCopyClientOptUpRequest,
    'Client Opt-Up Request',
    backPath: AppRoutePaths.tradeCopyClientCategorization,
  ),
  GoRoute(
    path: AppRoutePaths.tradeCopyRegulatoryDisclosuresAlias,
    redirect: (_, _) => AppRoutePaths.tradeCopyRegulatoryDisclosures,
  ),
  _placeholderRoute(
    AppRoutePaths.settingsSecurity,
    'Security Settings',
    backPath: AppRoutePaths.tradeCopyClientCategorization,
  ),
];

final List<GoRoute> _tradeBotsOutgoingPlaceholders = [];

final List<GoRoute> _earnRiskOutgoingPlaceholders = [];

GoRoute _placeholderRoute(
  String path,
  String title, {
  String backPath = AppRoutePaths.home,
}) {
  return GoRoute(
    path: path,
    builder: (_, _) =>
        _UnportedRoutePlaceholder(title: title, backPath: backPath),
  );
}

class _BottomNavRouteSkeleton extends StatelessWidget {
  const _BottomNavRouteSkeleton({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return VitPageLayout(
      child: Column(
        children: [
          VitHeader(title: title),
          const VitPageContent(children: []),
        ],
      ),
    );
  }
}

class _UnportedRoutePlaceholder extends StatelessWidget {
  const _UnportedRoutePlaceholder({
    required this.title,
    required this.backPath,
  });

  final String title;
  final String backPath;

  @override
  Widget build(BuildContext context) {
    return VitPageLayout(
      child: Column(
        children: [
          VitHeader(
            title: title,
            showBack: true,
            onBack: () => context.go(backPath),
          ),
          const VitPageContent(children: [SizedBox.shrink()]),
        ],
      ),
    );
  }
}
