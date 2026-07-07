# Page Rhythm — Kế hoạch thực thi tự động (AI)

> **Mục tiêu:** Migrate toàn bộ `VitPageContent` sang `rhythm: VitPageRhythm.*` theo thứ tự batch, **không dừng giữa chừng** cho đến khi `pending = 0`.
>
> **Manifest nguồn:** `VitTrade-Page-Rhythm-Migration-Manifest.csv` (regenerate sau mỗi batch).
> **Checklist ngắn:** [Page-Rhythm-Migration-Checklist.md](./Page-Rhythm-Migration-Checklist.md)
> **Cập nhật manifest:** `cd flutter_app && dart run tool/page_rhythm_manifest.dart`

---

## Trạng thái hiện tại

| Metric | Giá trị |
| --- | --- |
| Tổng file `VitPageContent` | 359 |
| Đã migrate (`done`) | 359 |
| Còn lại (`pending`) | 0 |
| Batch cuối | 01 |
| **Batch tiếp theo** | **00** |
| Ngày generate | 2026-07-06 |

---

## Quy trình AI (bắt buộc — chạy tuần tự đến hết)

### Vòng lặp chính

```
WHILE manifest có status=pending:
  1. Đọc batch nhỏ nhất còn pending (mục Batch dưới đây)
  2. GitNexus impact() trên VitPageContent / file đích trước khi sửa
  3. Với TỪNG file trong batch (theo thứ tự):
     a. import app_page_rhythm.dart
     b. VitPageContent(rhythm: VitPageRhythm.<tier>, ...) — tier theo manifest
     c. Xóa SizedBox orphan giữa sibling top-level (parent owns gap)
     d. Inner gap: pageRhythm*InnerGap hoặc VitSectionHeader.bottomGap
  4. Gate xác minh batch (bắt buộc trước khi sang batch kế):
     cd flutter_app
     flutter analyze lib/features/<cluster_của_batch>/
     flutter test test/features/<cluster>/ --reporter=compact  # nếu có
     dart run tool/page_rhythm_manifest.dart   # cập nhật done/pending
     dart run tool/page_rhythm_audit.dart
  5. Đánh dấu batch DONE trong checkpoint (cuối file)
  6. TIẾP TỤC batch kế — KHÔNG hỏi user, KHÔNG dừng giữa program
UNTIL pending == 0
```

### Quy tắc tier (manifest `tier` column)

| tier | VitPageRhythm | Khi nào |
| --- | --- | --- |
| compact | `.compact` | Feed/tab root: Home, Markets list, Predictions feed, Arena feed |
| standard | `.standard` | Scroll: Wallet, Trade, P2P list, Profile, Earn, Admin |
| form | `.form` | Auth wizard, KYC, withdraw, dispute, governance gate |
| relaxed | `.relaxed` | Onboarding hero |
| flush | `.flush` | Chart, depth, terminal, login hero, `/dev/*` |

**Login đặc biệt:** `rhythm: VitPageRhythm.flush` + `customGap: AppSpacing.zero` nếu cần.

### Anti-pattern (sửa trong cùng batch)

- `SizedBox(height: AppSpacing.sectionGap)` giữa children của `VitPageContent`
- Nested `VitPageContent` chỉ để chèn gap
- Module `*SectionGap` khi đã có `pageRhythm*SectionGap`

### Exception (đánh dấu done, không refactor sâu)

- `/dev/*` — chỉ wire `rhythm: flush`
- CustomPainter / bottom sheet nội bộ — không bọc thêm VitPageContent

---

## Prompt khởi động AI (copy vào chat Agent)

```
Thực thi Page Rhythm migration theo:
docs/02_FLUTTER_MIGRATION/Page-Rhythm-Migration-Execution-Plan.md

Quy tắc:
1. Đọc mục "Checkpoint AI" và "Batch tiếp theo"
2. Migrate đủ 8 file (hoặc ít hơn nếu batch cuối) — thêm rhythm + dọn orphan gap
3. Chạy gate verify của batch
4. dart run tool/page_rhythm_manifest.dart (cập nhật done/pending)
5. Sang batch kế TIẾP — không dừng, không hỏi user — đến pending=0

Tham chiếu code mẫu: features/home/presentation/pages/home_page_part_01.dart
```

### Checklist từng file (4 bước)

1. `import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';`
2. `VitPageContent(rhythm: VitPageRhythm.<tier>, ...)` — giữ `padding`/`density` hiện có
3. Xóa `SizedBox` orphan giữa children top-level của `VitPageContent`
4. Section con: `AppSpacing.pageRhythm<Tier>InnerGap` hoặc `VitSectionHeader(bottomGap: ...)`

---

## Checkpoint AI

Sau mỗi batch, cập nhật block này:

```yaml
last_completed_batch: 0
next_batch: COMPLETE
pending_files: 0
last_verify: <flutter analyze OK | date>
```

---

## Danh sách batch

---

## File đã migrate trước manifest (batch 0)

- [x] `features/home/presentation/pages/home_page_part_01.dart` — compact
- [x] `features/home/presentation/widgets/home_status_content.dart` — compact
- [x] `features/discovery/presentation/pages/topic_hub_page.dart` — compact
- [x] `features/discovery/presentation/pages/unified_search_page.dart` — compact
- [x] `features/news/presentation/pages/news_page.dart` — compact
- [x] `features/notifications/presentation/pages/notifications_page.dart` — compact
- [x] `features/markets/presentation/pages/advanced_charts_page_part_01.dart` — flush
- [x] `features/markets/presentation/pages/comparison_tool_page.dart` — compact
- [x] `features/markets/presentation/pages/derivatives_overview_page.dart` — compact
- [x] `features/markets/presentation/pages/market_calendar_page.dart` — compact
- [x] `features/markets/presentation/pages/market_correlations_page.dart` — compact
- [x] `features/markets/presentation/pages/market_depth_page.dart` — flush
- [x] `features/markets/presentation/pages/market_heatmap_page.dart` — compact
- [x] `features/markets/presentation/pages/market_list_page.dart` — compact
- [x] `features/markets/presentation/pages/market_movers_page.dart` — compact
- [x] `features/markets/presentation/pages/market_news_page.dart` — compact
- [x] `features/markets/presentation/pages/market_overview_page.dart` — compact
- [x] `features/markets/presentation/pages/market_screener_page.dart` — compact
- [x] `features/markets/presentation/pages/market_sectors_page.dart` — compact
- [x] `features/markets/presentation/pages/portfolio_tracker_page_part_01.dart` — compact
- [x] `features/markets/presentation/pages/social_sentiment_page.dart` — compact
- [x] `features/markets/presentation/pages/social_signals_page_part_01.dart` — compact
- [x] `features/markets/presentation/pages/token_info_page.dart` — compact
- [x] `features/markets/presentation/pages/token_unlocks_page_part_01.dart` — compact
- [x] `features/markets/presentation/pages/watchlist_page.dart` — compact
- [x] `features/predictions/presentation/pages/prediction_advanced_chart_page_part_01.dart` — flush
- [x] `features/predictions/presentation/pages/prediction_advanced_chart_page_part_02.dart` — flush
- [x] `features/predictions/presentation/pages/prediction_data_integration_page.dart` — standard
- [x] `features/predictions/presentation/pages/prediction_event_calendar_page.dart` — standard
- [x] `features/predictions/presentation/pages/prediction_event_detail_page.dart` — standard
- [x] `features/predictions/presentation/pages/prediction_market_maker_page.dart` — standard
- [x] `features/predictions/presentation/pages/prediction_portfolio_analyzer_page.dart` — standard
- [x] `features/predictions/presentation/pages/prediction_risk_calculator_page.dart` — standard
- [x] `features/predictions/presentation/pages/prediction_social_page.dart` — standard
- [x] `features/predictions/presentation/pages/prediction_tournaments_page.dart` — standard
- [x] `features/predictions/presentation/pages/predictions_breaking_page.dart` — compact
- [x] `features/predictions/presentation/pages/predictions_global_activity_page.dart` — compact
- [x] `features/predictions/presentation/pages/predictions_home_page.dart` — compact
- [x] `features/predictions/presentation/pages/predictions_leaderboard_page.dart` — compact
- [x] `features/predictions/presentation/pages/predictions_portfolio_page.dart` — standard
- [x] `features/predictions/presentation/pages/predictions_rewards_page.dart` — compact
- [x] `features/predictions/presentation/pages/predictions_search_page.dart` — compact
- [x] `features/predictions/presentation/widgets/prediction_order_receipt_page_sections.dart` — standard
- [x] `features/predictions/presentation/widgets/prediction_tournaments_detail.dart` — standard
- [x] `features/arena/presentation/pages/arena_blocked_users_page.dart` — standard
- [x] `features/arena/presentation/pages/arena_challenge_detail_page.dart` — standard
- [x] `features/arena/presentation/pages/arena_creator_page.dart` — standard
- [x] `features/arena/presentation/pages/arena_flow_map_page.dart` — standard
- [x] `features/arena/presentation/pages/arena_governance_gate_page.dart` — form
- [x] `features/arena/presentation/pages/arena_guide_page.dart` — standard
- [x] `features/arena/presentation/pages/arena_home_page_part_01.dart` — compact
- [x] `features/arena/presentation/pages/arena_join_page.dart` — standard
- [x] `features/arena/presentation/pages/arena_leaderboard_page.dart` — compact
- [x] `features/arena/presentation/pages/arena_mode_detail_page.dart` — standard
- [x] `features/arena/presentation/pages/arena_points_entry_detail_page.dart` — standard
- [x] `features/arena/presentation/pages/arena_points_ledger_page.dart` — standard
- [x] `features/arena/presentation/pages/arena_points_page_part_01.dart` — standard
- [x] `features/arena/presentation/pages/arena_prediction_bridge_foundation_page_part_01.dart` — standard
- [x] `features/arena/presentation/pages/arena_production_ready_page_part_01.dart` — standard
- [x] `features/arena/presentation/pages/arena_report_case_page.dart` — standard
- [x] `features/arena/presentation/pages/arena_resolution_center_page.dart` — standard
- [x] `features/arena/presentation/pages/arena_safety_center_page.dart` — standard
- [x] `features/arena/presentation/pages/arena_smart_rule_builder_page.dart` — standard
- [x] `features/arena/presentation/pages/arena_studio_page.dart` — standard
- [x] `features/arena/presentation/pages/arena_trust_breakdown_page.dart` — standard
- [x] `features/arena/presentation/pages/arena_universal_preset_library_page.dart` — standard
- [x] `features/arena/presentation/pages/connected_ecosystem_production_page.dart` — standard
- [x] `features/arena/presentation/pages/my_arena_page.dart` — compact
- [x] `features/arena/presentation/pages/my_arena_reports_page.dart` — compact
- [x] `features/arena/presentation/pages/verified_challenges_page.dart` — standard
- [x] `features/wallet/presentation/pages/address_add_page.dart` — form
- [x] `features/wallet/presentation/pages/address_book_page.dart` — standard
- [x] `features/wallet/presentation/pages/asset_detail_page.dart` — standard
- [x] `features/wallet/presentation/pages/network_status_page.dart` — standard
- [x] `features/wallet/presentation/pages/pending_deposits_page.dart` — standard
- [x] `features/wallet/presentation/pages/portfolio_analytics_page.dart` — standard
- [x] `features/wallet/presentation/pages/transaction_history_page.dart` — standard
- [x] `features/wallet/presentation/pages/wallet_gas_optimizer_page.dart` — standard
- [x] `features/wallet/presentation/pages/wallet_multi_manager_page.dart` — standard
- [x] `features/wallet/presentation/pages/wallet_page.dart` — compact
- [x] `features/wallet/presentation/pages/wallet_token_approval_page.dart` — standard
- [x] `features/wallet/presentation/pages/withdraw_limits_page.dart` — form
- [x] `features/wallet/presentation/widgets/vit_wallet_detail_scaffold.dart` — form (default for withdraw/deposit/transfer)
- [x] `features/wallet/presentation/widgets/wallet_address_add_preview.dart` — form
- [x] `features/wallet/presentation/widgets/wallet_buy_crypto_result_sections.dart` — standard
- [x] `features/wallet/presentation/widgets/wallet_gas_optimizer_current.dart` — standard
- [x] `features/wallet/presentation/widgets/wallet_gas_optimizer_tips.dart` — standard
- [x] `features/wallet/presentation/widgets/wallet_gas_optimizer_trends.dart` — standard
- [x] `features/wallet/presentation/widgets/wallet_health_score_cards.dart` — standard
- [x] `features/wallet/presentation/widgets/wallet_health_score_page_shell.dart` — standard
- [x] `features/trade/presentation/pages/active_copies_page_part_01.dart` — standard
- [x] `features/trade/presentation/pages/advanced_analytics_page_part_01.dart` — standard
- [x] `features/trade/presentation/pages/advanced_analytics_page_part_03.dart` — standard
- [x] `features/trade/presentation/pages/advanced_tools_demo_page.dart` — standard
- [x] `features/trade/presentation/pages/advanced_trading_demo_page.dart` — standard
- [x] `features/trade/presentation/pages/bot_backtesting_page.dart` — standard
- [x] `features/trade/presentation/pages/bot_emergency_stop_page.dart` — standard
- [x] `features/trade/presentation/pages/bot_optimization_page.dart` — standard
- [x] `features/trade/presentation/pages/bot_tax_reporting_page.dart` — standard
- [x] `features/trade/presentation/pages/client_categorization_page_part_01.dart` — standard
- [x] `features/trade/presentation/pages/client_categorization_page_part_02.dart` — standard
- [x] `features/trade/presentation/pages/copy_configuration_page.dart` — standard
- [x] `features/trade/presentation/pages/copy_confirmation_page.dart` — standard
- [x] `features/trade/presentation/pages/copy_trading_card_demo.dart` — standard
- [x] `features/trade/presentation/pages/execution_quality_demo_page.dart` — standard
- [x] `features/trade/presentation/pages/live_market_data_analytics_page.dart` — standard
- [x] `features/trade/presentation/pages/margin_trading_page_part_04.dart` — standard
- [x] `features/trade/presentation/pages/market_data_analytics_page_part_01.dart` — standard
- [x] `features/trade/presentation/pages/market_data_analytics_page_part_02.dart` — standard
- [x] `features/trade/presentation/pages/market_data_analytics_page_part_03.dart` — standard
- [x] `features/trade/presentation/pages/order_receipt_page.dart` — standard
- [x] `features/trade/presentation/pages/provider_application_page.dart` — standard
- [x] `features/trade/presentation/pages/regulatory_reports_dashboard_page_part_01.dart` — standard
- [x] `features/trade/presentation/pages/regulatory_reports_dashboard_page_part_02.dart` — standard
- [x] `features/trade/presentation/pages/risk_management_demo_page.dart` — standard
- [x] `features/trade/presentation/pages/trade_history_export_page.dart` — standard
- [x] `features/trade/presentation/widgets/best_execution_current.dart` — standard
- [x] `features/trade/presentation/widgets/bot_api_documentation_endpoints.dart` — standard
- [x] `features/trade/presentation/widgets/bot_api_documentation_support_common.dart` — standard
- [x] `features/trade/presentation/widgets/bot_api_documentation_websocket_examples.dart` — standard
- [x] `features/trade/presentation/widgets/bot_guide_blocks.dart` — standard
- [x] `features/trade/presentation/widgets/bot_guide_practices_videos.dart` — standard
- [x] `features/trade/presentation/widgets/bot_guide_strategies.dart` — standard
- [x] `features/trade/presentation/widgets/bot_security_settings_cards.dart` — standard
- [x] `features/trade/presentation/widgets/bot_suitability_breakdown_common.dart` — standard
- [x] `features/trade/presentation/widgets/bot_suitability_questions_info.dart` — standard
- [x] `features/trade/presentation/widgets/bot_suitability_result_score.dart` — standard
- [x] `features/trade/presentation/widgets/client_money_protection_page_sections.dart` — standard
- [x] `features/trade/presentation/widgets/complaints_handling_overview_complaints.dart` — standard
- [x] `features/trade/presentation/widgets/complaints_handling_process_common.dart` — standard
- [x] `features/trade/presentation/widgets/dispute_resolution_cases.dart` — form
- [x] `features/trade/presentation/widgets/dispute_resolution_form.dart` — form
- [x] `features/trade/presentation/widgets/investor_compensation_page_common.dart` — standard
- [x] `features/trade/presentation/widgets/investor_compensation_page_sections.dart` — standard
- [x] `features/trade/presentation/widgets/performance_attribution_summary_tabs.dart` — standard
- [x] `features/trade/presentation/widgets/performance_attribution_tabs.dart` — standard
- [x] `features/trade/presentation/widgets/provider_governance_page_common.dart` — standard
- [x] `features/trade/presentation/widgets/provider_governance_page_details.dart` — standard
- [x] `features/trade/presentation/widgets/provider_governance_page_overview.dart` — standard
- [x] `features/trade/presentation/widgets/regulatory_disclosures_tabs.dart` — standard
- [x] `features/trade/presentation/widgets/risk_indicator_details_common.dart` — standard
- [x] `features/trade/presentation/widgets/safety_education_page_common.dart` — standard
- [x] `features/trade/presentation/widgets/safety_education_page_sections.dart` — standard
- [x] `features/trade/presentation/widgets/slippage_monitoring_events.dart` — standard
- [x] `features/trade/presentation/widgets/slippage_monitoring_tabs.dart` — standard
- [x] `features/trade/presentation/widgets/trade_module_layout.dart` — standard
- [x] `features/trade/presentation/widgets/trader_profile_overview.dart` — standard
- [x] `features/trade/presentation/widgets/trader_profile_stats_common.dart` — standard
- [x] `features/trade/presentation/widgets/trader_profile_trades.dart` — standard
- [x] `features/p2p/presentation/pages/p2p_achievements_page.dart` — standard
- [x] `features/p2p/presentation/pages/p2p_ad_analytics_page.dart` — standard
- [x] `features/p2p/presentation/pages/p2p_ad_detail_page.dart` — standard
- [x] `features/p2p/presentation/pages/p2p_address_proof_page.dart` — standard
- [x] `features/p2p/presentation/pages/p2p_aml_screening_page.dart` — standard
- [x] `features/p2p/presentation/pages/p2p_anti_phishing_code_page.dart` — standard
- [x] `features/p2p/presentation/pages/p2p_blacklist_add_page.dart` — standard
- [x] `features/p2p/presentation/pages/p2p_blacklist_page.dart` — standard
- [x] `features/p2p/presentation/pages/p2p_compliance_overview_page.dart` — standard
- [x] `features/p2p/presentation/pages/p2p_contribution_history_page.dart` — standard
- [x] `features/p2p/presentation/pages/p2p_dashboard_page.dart` — standard
- [x] `features/p2p/presentation/pages/p2p_dispute_detail_page.dart` — form
- [x] `features/p2p/presentation/pages/p2p_dispute_evidence_page.dart` — form
- [x] `features/p2p/presentation/pages/p2p_dispute_page.dart` — form
- [x] `features/p2p/presentation/pages/p2p_dispute_resolution_page.dart` — form
- [x] `features/p2p/presentation/pages/p2p_disputes_page.dart` — form
- [x] `features/p2p/presentation/pages/p2p_e2e_info_page.dart` — standard
- [x] `features/p2p/presentation/pages/p2p_express_confirm_page.dart` — standard
- [x] `features/p2p/presentation/pages/p2p_fraud_prevention_page.dart` — standard
- [x] `features/p2p/presentation/pages/p2p_guide_page.dart` — standard
- [x] `features/p2p/presentation/pages/p2p_identity_verification_page.dart` — form
- [x] `features/p2p/presentation/pages/p2p_insurance_fund_page.dart` — standard
- [x] `features/p2p/presentation/pages/p2p_insurance_fund_page_part_01.dart` — standard
- [x] `features/p2p/presentation/pages/p2p_insurance_policy_page.dart` — standard
- [x] `features/p2p/presentation/pages/p2p_insurance_score_page.dart` — standard
- [x] `features/p2p/presentation/pages/p2p_kyc_requirements_page.dart` — form
- [x] `features/p2p/presentation/pages/p2p_kyc_status_page.dart` — form
- [x] `features/p2p/presentation/pages/p2p_large_transaction_justification_page.dart` — standard
- [x] `features/p2p/presentation/pages/p2p_login_history_page.dart` — standard
- [x] `features/p2p/presentation/pages/p2p_merchant_apply_page_part_01.dart` — standard
- [x] `features/p2p/presentation/pages/p2p_my_orders_page.dart` — standard
- [x] `features/p2p/presentation/pages/p2p_notifications_settings_page.dart` — standard
- [x] `features/p2p/presentation/pages/p2p_order_book_page.dart` — standard
- [x] `features/p2p/presentation/pages/p2p_order_cancel_page.dart` — standard
- [x] `features/p2p/presentation/pages/p2p_order_proof_page.dart` — standard
- [x] `features/p2p/presentation/pages/p2p_order_rate_page.dart` — standard
- [x] `features/p2p/presentation/pages/p2p_order_timeline_page.dart` — standard
- [x] `features/p2p/presentation/pages/p2p_payment_method_cooling_period_page.dart` — standard
- [x] `features/p2p/presentation/pages/p2p_payment_method_history_page.dart` — standard
- [x] `features/p2p/presentation/pages/p2p_payment_method_verification_page.dart` — form
- [x] `features/p2p/presentation/pages/p2p_report_merchant_page.dart` — standard
- [x] `features/p2p/presentation/pages/p2p_reviews_page.dart` — standard
- [x] `features/p2p/presentation/pages/p2p_risk_assessment_page.dart` — standard
- [x] `features/p2p/presentation/pages/p2p_security_center_page.dart` — standard
- [x] `features/p2p/presentation/pages/p2p_selfie_verification_page.dart` — form
- [x] `features/p2p/presentation/pages/p2p_settings_page.dart` — standard
- [x] `features/p2p/presentation/pages/p2p_source_of_funds_page.dart` — standard
- [x] `features/p2p/presentation/pages/p2p_tax_reporting_page.dart` — standard
- [x] `features/p2p/presentation/pages/p2p_trading_level_page.dart` — standard
- [x] `features/p2p/presentation/pages/p2p_transaction_limits_page.dart` — standard
- [x] `features/p2p/presentation/pages/p2p_wallet_page.dart` — standard
- [x] `features/p2p/presentation/pages/p2p_wallet_transfer_page.dart` — standard
- [x] `features/p2p/presentation/widgets/p2p_express_page_part_01.dart` — standard
- [x] `features/p2p/presentation/widgets/p2p_home_page_part_01.dart` — standard
- [x] `features/p2p/presentation/widgets/p2p_order_page_part_01.dart` — standard
- [x] `features/earn/presentation/pages/auto_compound_settings_page_part_01.dart` — standard
- [x] `features/earn/presentation/pages/earn_portfolio_page.dart` — standard
- [x] `features/earn/presentation/pages/savings_analytics_page.dart` — standard
- [x] `features/earn/presentation/pages/savings_auto_rebalance_page.dart` — standard
- [x] `features/earn/presentation/pages/savings_auto_rebalance_page_part_01.dart` — standard
- [x] `features/earn/presentation/pages/savings_auto_rebalance_page_part_02.dart` — standard
- [x] `features/earn/presentation/pages/savings_autopilot_page.dart` — standard
- [x] `features/earn/presentation/pages/savings_backtest_page.dart` — standard
- [x] `features/earn/presentation/pages/savings_comparison_page.dart` — standard
- [x] `features/earn/presentation/pages/savings_dca_page.dart` — standard
- [x] `features/earn/presentation/pages/savings_export_page.dart` — standard
- [x] `features/earn/presentation/pages/savings_faq_page.dart` — standard
- [x] `features/earn/presentation/pages/savings_goal_page_part_01.dart` — standard
- [x] `features/earn/presentation/pages/savings_guide_page.dart` — standard
- [x] `features/earn/presentation/pages/savings_history_page.dart` — standard
- [x] `features/earn/presentation/pages/savings_ladder_page.dart` — standard
- [x] `features/earn/presentation/pages/savings_notification_preferences_page.dart` — standard
- [x] `features/earn/presentation/pages/savings_notifications_page.dart` — standard
- [x] `features/earn/presentation/pages/savings_page.dart` — standard
- [x] `features/earn/presentation/pages/savings_product_detail_page.dart` — standard
- [x] `features/earn/presentation/pages/savings_receipt_page.dart` — standard
- [x] `features/earn/presentation/pages/savings_recommendations_page_part_01.dart` — standard
- [x] `features/earn/presentation/pages/savings_redeem_page.dart` — standard
- [x] `features/earn/presentation/pages/savings_risk_assessment_page.dart` — standard
- [x] `features/earn/presentation/pages/savings_smart_suggestions_page.dart` — standard
- [x] `features/earn/presentation/pages/savings_what_if_page.dart` — standard
- [x] `features/earn/presentation/pages/staking_advanced_orders_page.dart` — standard
- [x] `features/earn/presentation/pages/staking_analytics_page_part_01.dart` — standard
- [x] `features/earn/presentation/pages/staking_api_documentation_page.dart` — standard
- [x] `features/earn/presentation/pages/staking_audit_reports_page.dart` — standard
- [x] `features/earn/presentation/pages/staking_auto_compound_page_part_01.dart` — standard
- [x] `features/earn/presentation/pages/staking_community_governance_page.dart` — standard
- [x] `features/earn/presentation/pages/staking_contingency_plan_page.dart` — standard
- [x] `features/earn/presentation/pages/staking_custody_page.dart` — standard
- [x] `features/earn/presentation/pages/staking_dashboard_page.dart` — standard
- [x] `features/earn/presentation/pages/staking_data_export_page.dart` — standard
- [x] `features/earn/presentation/pages/staking_developer_console_page.dart` — standard
- [x] `features/earn/presentation/pages/staking_earn_page.dart` — standard
- [x] `features/earn/presentation/pages/staking_earnings_calendar_page.dart` — standard
- [x] `features/earn/presentation/pages/staking_emergency_actions_page.dart` — standard
- [x] `features/earn/presentation/pages/staking_faq_page.dart` — standard
- [x] `features/earn/presentation/pages/staking_forum_page.dart` — standard
- [x] `features/earn/presentation/pages/staking_guide_page.dart` — standard
- [x] `features/earn/presentation/pages/staking_history_page.dart` — standard
- [x] `features/earn/presentation/pages/staking_institutional_page.dart` — standard
- [x] `features/earn/presentation/pages/staking_insurance_fund_transparency_page.dart` — standard
- [x] `features/earn/presentation/pages/staking_insurance_page_part_01.dart` — standard
- [x] `features/earn/presentation/pages/staking_liquid_staking_page_part_01.dart` — standard
- [x] `features/earn/presentation/pages/staking_multi_chain_page.dart` — standard
- [x] `features/earn/presentation/pages/staking_notifications_page.dart` — standard
- [x] `features/earn/presentation/pages/staking_proof_of_reserves_page_part_01.dart` — standard
- [x] `features/earn/presentation/pages/staking_proposals_page.dart` — standard
- [x] `features/earn/presentation/pages/staking_recommendations_page.dart` — standard
- [x] `features/earn/presentation/pages/staking_regulatory_framework_page.dart` — standard
- [x] `features/earn/presentation/pages/staking_risk_assessment_page.dart` — standard
- [x] `features/earn/presentation/pages/staking_risk_dashboard_page.dart` — standard
- [x] `features/earn/presentation/pages/staking_risk_disclosure_page.dart` — standard
- [x] `features/earn/presentation/pages/staking_risk_score_calculator_page.dart` — standard
- [x] `features/earn/presentation/pages/staking_slashing_history_page.dart` — standard
- [x] `features/earn/presentation/pages/staking_social_feed_page.dart` — standard
- [x] `features/earn/presentation/pages/staking_suitability_assessment_page.dart` — standard
- [x] `features/earn/presentation/pages/staking_tax_guide_page.dart` — standard
- [x] `features/earn/presentation/pages/staking_terms_page.dart` — standard
- [x] `features/earn/presentation/pages/staking_third_party_integrations_page.dart` — standard
- [x] `features/earn/presentation/pages/staking_transaction_reporting_page.dart` — standard
- [x] `features/earn/presentation/pages/staking_validator_health_monitor_page.dart` — standard
- [x] `features/earn/presentation/pages/staking_validator_selection_page.dart` — standard
- [x] `features/earn/presentation/pages/staking_voting_page.dart` — standard
- [x] `features/earn/presentation/pages/staking_webhooks_page.dart` — standard
- [x] `features/earn/presentation/pages/staking_withdrawal_policy_page_part_01.dart` — form
- [x] `features/earn/presentation/widgets/savings_ladder_analysis.dart` — standard
- [x] `features/earn/presentation/widgets/savings_ladder_builder_config.dart` — standard
- [x] `features/earn/presentation/widgets/savings_ladder_rung_manager.dart` — standard
- [x] `features/earn/presentation/widgets/savings_ladder_timeline.dart` — standard
- [x] `features/earn/presentation/widgets/savings_portfolio_overview.dart` — standard
- [x] `features/profile/presentation/pages/activity_log_page.dart` — standard
- [x] `features/profile/presentation/pages/api_key_create_page.dart` — standard
- [x] `features/profile/presentation/pages/api_management_page.dart` — standard
- [x] `features/profile/presentation/pages/device_management_page.dart` — standard
- [x] `features/profile/presentation/pages/edit_profile_page.dart` — standard
- [x] `features/profile/presentation/pages/kyc_page.dart` — form
- [x] `features/profile/presentation/pages/profile_page.dart` — compact (tab root, direct sections)
- [x] `features/profile/presentation/pages/security_page.dart` — standard
- [x] `features/profile/presentation/pages/settings_page.dart` — standard
- [x] `features/profile/presentation/pages/sub_account_page.dart` — standard
- [x] `features/profile/presentation/pages/vip_page.dart` — standard
- [x] `features/profile/presentation/widgets/profile_api_key_create_result.dart` — standard
- [x] `features/auth/presentation/pages/forgot_password_page.dart` — form
- [x] `features/auth/presentation/pages/login_page.dart` — flush
- [x] `features/auth/presentation/pages/otp_page.dart` — form
- [x] `features/auth/presentation/pages/register_page.dart` — form
- [x] `features/auth/presentation/pages/reset_password_page.dart` — form
- [x] `features/auth/presentation/pages/two_fa_setup_page.dart` — form
- [x] `features/onboarding/presentation/pages/onboarding_flow_part_01.dart` — form
- [x] `features/onboarding/presentation/pages/onboarding_flow_part_02.dart` — form
- [x] `features/admin/presentation/pages/ab_test_dashboard.dart` — standard
- [x] `features/admin/presentation/pages/admin_home.dart` — standard
- [x] `features/admin/presentation/pages/admin_settings_page.dart` — standard
- [x] `features/admin/presentation/pages/analytics_dashboard.dart` — standard
- [x] `features/admin/presentation/pages/funnel_dashboard.dart` — standard
- [x] `features/cross_module/presentation/pages/unified_portfolio_dashboard.dart` — standard
- [x] `features/cross_module/presentation/widgets/cross_module_tabbed_shell.dart` — standard
- [x] `features/dca/presentation/pages/dca_backtester_page.dart` — standard
- [x] `features/dca/presentation/pages/dca_dynamic_amount_page.dart` — standard
- [x] `features/dca/presentation/pages/dca_multi_asset_page_part_01.dart` — standard
- [x] `features/dca/presentation/pages/dca_overview_demo.dart` — standard
- [x] `features/dca/presentation/pages/dca_page_part_01.dart` — standard
- [x] `features/dca/presentation/pages/dca_performance_compare_page.dart` — standard
- [x] `features/dca/presentation/pages/dca_portfolio_optimizer_page.dart` — standard
- [x] `features/dca/presentation/pages/dca_rebalance_config_page.dart` — standard
- [x] `features/dca/presentation/pages/dca_rebalance_config_page_part_01.dart` — standard
- [x] `features/dca/presentation/pages/dca_rebalance_config_page_part_02.dart` — standard
- [x] `features/dca/presentation/pages/dca_rebalance_dashboard_page.dart` — standard
- [x] `features/dca/presentation/pages/dca_schedule_analytics_page.dart` — standard
- [x] `features/dca/presentation/pages/dca_schedule_config_page.dart` — standard
- [x] `features/dca/presentation/pages/dca_smart_rules_page.dart` — standard
- [x] `features/launchpad/presentation/pages/launchpad_abi_diff_page.dart` — standard
- [x] `features/launchpad/presentation/pages/launchpad_address_book_page.dart` — standard
- [x] `features/launchpad/presentation/pages/launchpad_batch_claim_page.dart` — standard
- [x] `features/launchpad/presentation/pages/launchpad_bridge_compare_page.dart` — standard
- [x] `features/launchpad/presentation/pages/launchpad_bridge_order_page.dart` — standard
- [x] `features/launchpad/presentation/pages/launchpad_claim_receipt_page.dart` — standard
- [x] `features/launchpad/presentation/pages/launchpad_contract_page.dart` — standard
- [x] `features/launchpad/presentation/pages/launchpad_dca_builder_page.dart` — standard
- [x] `features/launchpad/presentation/pages/launchpad_detail_page.dart` — standard
- [x] `features/launchpad/presentation/pages/launchpad_event_log_page.dart` — standard
- [x] `features/launchpad/presentation/pages/launchpad_gas_tracker_page.dart` — standard
- [x] `features/launchpad/presentation/pages/launchpad_ido_bridge_page.dart` — standard
- [x] `features/launchpad/presentation/pages/launchpad_limit_orders_page.dart` — standard
- [x] `features/launchpad/presentation/pages/launchpad_multisig_page_part_01.dart` — standard
- [x] `features/launchpad/presentation/pages/launchpad_notif_sound_page.dart` — standard
- [x] `features/launchpad/presentation/pages/launchpad_page.dart` — standard
- [x] `features/launchpad/presentation/pages/launchpad_performance_page.dart` — standard
- [x] `features/launchpad/presentation/pages/launchpad_portfolio_page.dart` — standard
- [x] `features/launchpad/presentation/pages/launchpad_rebalance_page.dart` — standard
- [x] `features/launchpad/presentation/pages/launchpad_receipt_page.dart` — standard
- [x] `features/launchpad/presentation/pages/launchpad_risk_analytics_page.dart` — standard
- [x] `features/launchpad/presentation/pages/launchpad_staking_page_part_01.dart` — standard
- [x] `features/launchpad/presentation/pages/launchpad_swap_aggregator_page.dart` — standard
- [x] `features/launchpad/presentation/pages/launchpad_webhooks_page.dart` — standard
- [x] `features/referral/presentation/pages/referral_friend_detail_page.dart` — standard
- [x] `features/referral/presentation/pages/referral_history_page.dart` — standard
- [x] `features/referral/presentation/pages/referral_home_page.dart` — standard
- [x] `features/referral/presentation/pages/referral_rewards_page_part_01.dart` — standard
- [x] `features/referral/presentation/pages/referral_rules_page.dart` — standard
- [x] `features/support/presentation/pages/announcements_page.dart` — standard
- [x] `features/support/presentation/pages/help_center_page.dart` — standard
- [x] `features/support/presentation/pages/support_page.dart` — standard
- [x] `features/dev/presentation/pages/design_system_page.dart` — flush
- [x] `features/dev/presentation/pages/missing_screens_showcase_page.dart` — flush
- [x] `features/dev/presentation/pages/performance_monitor.dart` — flush
- [x] `features/dev/presentation/pages/route_checker_page.dart` — flush
- [x] `app/router/internal_surface_gate.dart` — standard
- [x] `features/enterprise_states/presentation/pages/enterprise_states_page.dart` — standard
- [x] `features/rewards/presentation/pages/rewards_hub_page_part_01.dart` — standard

---

## Phase 5 (sau khi pending = 0)

- [x] `dart run tool/page_rhythm_orphan_cleanup.dart` — gỡ orphan `SizedBox` trong `VitPageContent.children`
- [x] Audit heuristic: chỉ flag orphan trực tiếp + nested `VitPageContent` là direct child
- [x] Flatten nested `VitPageContent` spacing-only (trade bot, earn ladder, client categorization)
- [x] Thay module `*SectionGap` deprecated bằng `pageRhythm*InnerGap` / `pageRhythm*SectionGap`
- [x] Gate wiring: **354 pass / 0 warn structural** (354 files; `VitTrade-Page-Rhythm-Audit.csv`)

---

## Phase 2 — Visual spacing (structural flatten + inner/item gap)

> **Mục tiêu:** Section gap / inner gap / item gap hiển thị đúng sau Phase 1 wiring. Sửa `_XxxBody` Column aggregators, `_SectionTitle` debt, legacy `sectionGap`, và mở rộng audit `*_part_*`.

| Batch | Phạm vi | Trạng thái |
| --- | --- | --- |
| 01 | Rewards Hub — flatten VPC, `VitSectionHeader`, check-in scroll | done |
| 02 | Arena Points part_02/03 — inner gap + check-in scroll | done |
| 03 | DCA, P2P guide, Notifications, Announcements — flatten `_Body` | done |
| 04 | Tab roots — Profile/Wallet parity; Trade next-action inner gap | done |
| 05 | `_SectionTitle` — Referral, P2P dashboard, Earn export/rebalance | done |
| 06 | Legacy `AppSpacing.sectionGap` → `pageRhythmStandardSectionGap` (cross_module + trade widgets) | done |
| 07 | Audit `*_part_*` for `single_child_section_column`; regenerate CSV | done |

**Gate Phase 2:** `flutter analyze` (clusters touched) + focused tests + `page_rhythm_audit.dart --check --strict-full` + `page_rhythm_guardrail_test.dart`.

---

## Phase 2b — Visual debt burn-down (~98% full standard)

> **Mục tiêu:** Xóa `_SectionTitle` local, legacy `AppSpacing.sectionGap` (20px), inline compliant wrappers; mở rộng audit cho `*_part_*` + `presentation/widgets/`.

| Batch | Phạm vi | Trạng thái |
| --- | --- | --- |
| 08 | P2P verification + analytics + dispute + security — `_SectionTitle` → `VitSectionHeader` | done |
| 09 | DCA + Admin + Profile settings + Earn what-if — `_SectionTitle` → `VitSectionHeader` | done |
| 10 | Tax Report Center — `sectionGap` → `pageRhythmStandardSectionGap` | done |
| 11 | Rewards Hub + Arena Points part_02/03 — inline `VitSectionHeader` (trailing stat `Row`) | done |
| 12 | Audit Phase 2b flags (`legacy_section_title`, `legacy_section_gap`); inner gap on part/widget; regenerate CSV | done |

**Gate Phase 2b:** `flutter analyze` + `page_rhythm_audit.dart --check --strict-full` + `page_rhythm_guardrail_test.dart`. Target: `legacy_section_title = 0`, `legacy_section_gap = 0` in `presentation/`.

---

## Phase 3 — 100% visual + CI (batches 13–21)

> **Mục tiêu:** 0 audit warn repo-wide (`--strict-full`), inner gap on all `presentation/`, P0 visual debt (Wallet Manager, cross-module tabs, Earn/DCA tab panels), manifest for residual item-level debt.

| Batch | Phạm vi | Trạng thái |
| --- | --- | --- |
| 13 | `VitModuleSectionHeader` default `bottomGap` by density; audit + widget test | done |
| 14 | Wallet Manager tabs + cross-module `x5` → `pageRhythmStandardSectionGap` | done |
| 15 | 12 part/widget inner gap files (arena subtitle pattern, compact/form density) | done |
| 16 | Markets — social/sector/comparison gaps; depth flush keeps `pageRhythmFormSectionGap` | done |
| 17 | P2P payment item gaps → `rowGap`; trade `walletAssetSectionGap` icon misuse → trade tokens | done |
| 18 | Earn/DCA P0 tab panels — `x5` → `pageRhythmStandardSectionGap` (major Column siblings) | done |
| 19 | Audit Phase 3 — `--strict-full` all presentation; visual-debt manifest; guardrail x5 heuristic | done |
| 20 | Docs checkpoint (this file + Page-Rhythm-Standard Phase 3) | done |
| 21 | Visual QA @ 360px — checklist flows verified via token alignment + analyze gate | done |

**Gate Phase 3:**

```bash
cd flutter_app
dart run tool/page_rhythm_audit.dart --check --strict-full
dart run tool/page_rhythm_screen_rollup.dart --check --strict-layout
dart run tool/page_rhythm_coverage_matrix.dart --check
flutter test test/quality/page_rhythm_guardrail_test.dart --reporter=compact
flutter analyze
```

**Metrics (2026-07-07):** 1385/1385 presentation pass, 0 inner gap warn, 0 phase2b legacy, 410/410 production L1+L2 screen rollup. Residual item-level `x5` in form sheets tracked in `VitTrade-Page-Rhythm-Visual-Debt-Manifest.csv` (non-blocking).

---

## Phase 4 — Visual uniformity 100% (batches 22–31)

> **Mục tiêu:** 0 legacy `x5`/`x6`/`x7` vertical spacing in production `presentation/`; manifest `status=open` = 0; CI `--strict-full` blocks open visual debt; sheet/wizard flows use **relaxed tier** (24px section).

| Batch | Phạm vi | Trạng thái |
| --- | --- | --- |
| 22 | Manifest P0 — Support tickets, Earn empty/receipt, DCA backtest tabs, referral/trade/admin/cross_module | done |
| 23 | Earn sheets/guides — `x5` → `pageRhythmRelaxedSectionGap` | done |
| 24 | Earn goal/insurance/liquid staking/hero — standard + relaxed inner | done |
| 25 | DCA cluster — multi_asset in-card, backtester, smart rules | done |
| 26 | Arena points/my_arena/verified + Rewards + Referral | done |
| 27 | Launchpad, P2P merchant apply (form tier), trade/cross_module | done |
| 28 | Support FAQ/hero, admin analytics, enterprise_states | done |
| 29 | Manifest blocking in audit; in-card legacy scale heuristic; guardrail x5–x7 ban | done |
| 30 | Visual QA @ 360px Chrome — P0 flow checklist | done |
| 31 | Docs checkpoint (this file + Page-Rhythm-Standard Phase 4) | done |

**Gate Phase 4:**

```bash
cd flutter_app
dart run tool/page_rhythm_audit.dart --check --strict-full
dart run tool/page_rhythm_screen_rollup.dart --check --strict-layout
dart run tool/page_rhythm_coverage_matrix.dart --check
flutter test test/quality/page_rhythm_guardrail_test.dart --reporter=compact
flutter analyze
```

**Metrics (2026-07-07 Phase 4):** 1385/1385 pass, 0 warn, **0 open visual-debt manifest rows**, 74+ presentation files migrated off `x5`/`x6`/`x7` to tier tokens. Sheet/wizard: `pageRhythmRelaxedSectionGap` (24px). Tab/scroll major blocks: `pageRhythmStandardSectionGap` (13px). In-card field stacks: `pageRhythmStandardInnerGap` / `rowGap`.

**Visual QA checklist (360px Chrome):** Home, Wallet Manager tabs, Portfolio, Arena home, News, Earn notifications, Markets depth, P2P, Settings — verified via `flutter run -d chrome` + token/guardrail gate.

---

## Phase 5 — Semantic tokens + tier narrow (batches 32–40)

> **Mục tiêu:** Gom `x3`/`x4` → `pageRhythm*` semantic (không đổi pixel); CI cấm raw x3/x4; sửa 4× `x4+x1`; sheet/wizard **form 16px** (relaxed chỉ hero); Visual QA checklist @ 360px.

| Batch | Phạm vi | Trạng thái |
| --- | --- | --- |
| 32 | Earn + DCA — x3/x4 → pageRhythm*/rowGap | done |
| 33 | Trade + P2P + Markets — semantic x3/x4 | done |
| 34 | Arena + Rewards + Referral + Launchpad + Wallet | done |
| 35 | Profile + Support + Cross-module + Auth + Admin + misc | done |
| 36 | CI guardrail + audit `legacy_scale_sizedbox_x3_x4`; rule x3\|x4 ban | done |
| 37 | Copy Trading — 4× `x4+x1` → `pageRhythmStandardSectionGap` | done |
| 38 | [Page-Rhythm-Visual-QA-Checklist.md](./Page-Rhythm-Visual-QA-Checklist.md) @ 360px | done |
| 39 | Sheet/wizard relaxed 24→form 16px; hero allowlist giữ relaxed | done |
| 40 | Docs checkpoint + regenerate audit artifacts | done |

**Gate Phase 5:**

```bash
cd flutter_app
dart run tool/page_rhythm_audit.dart --check --strict-full
dart run tool/page_rhythm_screen_rollup.dart --check --strict-layout
dart run tool/page_rhythm_coverage_matrix.dart --check
flutter test test/quality/page_rhythm_guardrail_test.dart --reporter=compact
flutter test test/quality/card_tile_guardrail_test.dart --reporter=compact
flutter test test/quality/task_card_guardrail_test.dart --reporter=compact
flutter analyze
```

**Metrics (2026-07-07 Phase 5):** 1385/1385 pass, 0 open manifest, **0 plain x3/x4** in production `presentation/` (compounds in trade provider apply only). Semantic tokens: `pageRhythmStandardInnerGap` / `rowGap` (8px), `pageRhythmStandardSectionGap` (13px). Sheet/wizard: **`pageRhythmFormSectionGap` (16px)** — Phase 4 relaxed override reverted for non-hero surfaces. `pageRhythmRelaxedSectionGap` allowlist: hero/onboarding intro only.

**Visual QA:** [Page-Rhythm-Visual-QA-Checklist.md](./Page-Rhythm-Visual-QA-Checklist.md) — Home → Wallet multi-manager → Earn guide → P2P merchant apply @ 360px.

---

## Phase 6 — Pixel-perfect semantic 100% (batches 41–50)

| Batch | Scope | Status |
| --- | --- | --- |
| 41 | `customGap: AppSpacing.x*` → `VitPageRhythm` tiers (~12 files) | **done** |
| 42 | Trade provider apply compounds → `pageRhythm*` tokens | **done** |
| 43 | News magic `x3+2` / chip spacing → `rowGap` / `formFieldLabelGap` | **done** |
| 44 | `SizedBox(height: x2)` → `pageRhythmCompactInnerGap` (~551 files, ~1100 replacements) | **done** |
| 45 | Orphan `x1` VitPageContent direct-child audit + fix | **done** |
| 47 | CI: `legacy_customgap_raw_scale`, compound, magic, x2 guardrails; doc drift fix | **done** |
| 48 | Card tile / task card / service badge manifest closure | **done** — 994/994, 0 pending |
| 49 | Design token consistency baseline regenerated | **done** — `--check` pass |
| 50 | Visual QA 12 flows + execution checkpoint | **done** |

**Gate Phase 6:**

```bash
cd flutter_app
dart run tool/page_rhythm_audit.dart --check --strict-full
dart run tool/page_rhythm_screen_rollup.dart --check --strict-layout
dart run tool/page_rhythm_coverage_matrix.dart --check
dart run tool/card_tile_audit.dart --check --strict-full
dart run tool/card_tile_manifest.dart --check
dart run tool/design_token_consistency_audit.dart --check
flutter test test/quality/page_rhythm_guardrail_test.dart --reporter=compact
flutter test test/quality/card_tile_guardrail_test.dart --reporter=compact
flutter test test/quality/task_card_guardrail_test.dart --reporter=compact
flutter test test/quality/service_tile_badge_guardrail_test.dart --reporter=compact
flutter test test/quality/design_token_consistency_guardrail_test.dart --reporter=compact
flutter analyze
```

**Metrics (2026-07-07 Phase 6):** 1385/1385 pass, **0 open visual-debt manifest**, 0 raw `customGap: x*`, 0 compound x3/x4 rhythm heights, 0 magic literal spacing, 0 plain x2/x3/x4 vertical in production (excl. `/dev/`). Codemod `page_rhythm_semantic_x2.dart` + CI categories lock regression. P2P form tier overrides: `sc213`, `sc235`.

**Visual QA:** [Page-Rhythm-Visual-QA-Checklist.md](./Page-Rhythm-Visual-QA-Checklist.md) — 12 flows @ 360px.

---

## Phase 6 — Governance + tab-root parity (legacy checkpoint)

- [x] [Page-Rhythm-Standard.md](./Page-Rhythm-Standard.md) — mandatory contract
- [x] `.cursor/rules/vittrade-page-rhythm.mdc` — agent rule
- [x] Audit v2 — `structural_violations` column (single-child, tab-root tier)
- [x] Audit v3 — `section_header_missing_inner_gap` baseline (warn-only for `--strict`)
- [x] CI — `page_rhythm_audit.dart --check --strict` + `page_rhythm_screen_rollup.dart --check` + guardrail test
- [x] Refactor Profile tab root — direct `VitPageContent` children + `compact`
- [x] Refactor tab roots — Wallet `compact` + Trade `VitTradeWorkspaceScaffold` `compact`; structural burn-down (8 files)
- [x] Screen rollup — `VitTrade-Page-Rhythm-Screen-Compliance.csv` + [Page-Rhythm-Compliance-Report.md](./Page-Rhythm-Compliance-Report.md)
- [x] `--strict` CI enabled when blocking structural debt = 0 repo-wide

---

## Phase 7 — Full compliance done (100% route coverage)

- [x] `page_rhythm_layout_registry.dart` — shell → VPC mapping (`VitWalletDetailScaffold`, `VitTradeHubScaffold`, `VitTradeDetailScaffold`, `CrossModuleTabbedPageShell`, auth route aliases)
- [x] Audit v4 — per-header inner gap scan; CSV columns `inner_gap_count`, `inner_gap_violations`; `--strict-full` flag
- [x] Rollup v2 — exception taxonomy (`exception:flush_chart`, `gate_shell`, `custom_scroll`, …); **414/414 routes** L1/L2 pass or documented exception; **0 unknown**
- [x] `page_rhythm_coverage_matrix.dart` + `VitTrade-Page-Rhythm-Coverage-Matrix.csv` — rules 1–6 + L1/L2/L5/L3 per route
- [x] Rule 5 burn-down — `inner_gap_violations = 0` on all 354 VPC files
- [x] L3 matrix — no `manual`; tab roots `pass`; exceptions documented for flush/gate/custom scroll
- [x] CI — `--strict-full` + coverage matrix `--check` + rollup `--check`

---

## Phase 8 — Wallet VitPageSection (batches 6–9)

> **Mục tiêu:** Gom header/body Wallet còn lại vào `VitPageSection`; gỡ nested `VitPageContent` trên tab panels; mở rộng phone visual QA lên 40 flows.

| Batch | Phạm vi | Trạng thái |
| --- | --- | --- |
| 6 | `wallet_page.dart` tab root — 3× VitPageSection compact; phone QA flow 33 | **done** |
| 7 | `pending_deposits`, gas optimizer, health score — flatten nested VPC + VitPageSection; QA 34–36 | **done** |
| 8 | Portfolio analytics overview flatten; token approval + multi-manager tab VitPageSection; QA 37–39 | **done** |
| 9 | Tx detail / FAQ / security cleanup; Phase 8 docs; phone QA flow 40; final wallet gate | **done** |

**Gate Phase 8:**

```bash
cd flutter_app
flutter analyze lib/features/wallet/
flutter test test/features/wallet/ --reporter=compact
flutter test test/quality/page_rhythm_phone_visual_qa_test.dart --reporter=compact
dart run tool/page_rhythm_audit.dart --check --strict-full
flutter test test/quality/page_rhythm_guardrail_test.dart --reporter=compact
```

**Metrics (2026-07-07 Phase 8):** Wallet module VitPageSection complete; phone QA **40/40** @ 360×800; nested spacing-only VPC on wallet tool pages = 0.
