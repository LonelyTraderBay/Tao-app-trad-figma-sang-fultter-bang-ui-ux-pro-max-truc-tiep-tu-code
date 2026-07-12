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
| Tổng file `VitPageContent` | 358 |
| Đã migrate (`done`) | 356 |
| Còn lại (`pending`) | 2 |
| Batch cuối | 02 |
| **Batch tiếp theo** | **01** |
| Ngày generate | 2026-07-10 |

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
docs/02_FLUTTER_MIGRATION/checklists/Page-Rhythm-Migration-Execution-Plan.md

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
next_batch: 1
pending_files: 2
last_verify: <flutter analyze OK | date>
```

---

## Danh sách batch

### Batch 01 — wallet

Trạng thái: ⏳ PENDING

| # | File | Tier | Status |
| --- | --- | --- | --- |
| 1 | `features/wallet/presentation/widgets/vit_wallet_detail_scaffold.dart` | standard | pending |

**Gate:** `flutter analyze lib/features/wallet/`

### Batch 02 — p2p

Trạng thái: ⏳ PENDING

| # | File | Tier | Status |
| --- | --- | --- | --- |
| 1 | `features/p2p/presentation/widgets/vit_p2p_flow_scaffold.dart` | standard | pending |

**Gate:** `flutter analyze lib/features/p2p/`

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
- [x] `features/markets/presentation/pages/pair_detail_page.dart` — compact
- [x] `features/markets/presentation/pages/portfolio_tracker_page_part_01.dart` — compact
- [x] `features/markets/presentation/pages/price_alerts_page.dart` — compact
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
- [x] `features/wallet/presentation/pages/wallet_page.dart` — standard
- [x] `features/wallet/presentation/pages/wallet_token_approval_page.dart` — standard
- [x] `features/wallet/presentation/pages/withdraw_limits_page.dart` — form
- [x] `features/wallet/presentation/widgets/wallet_address_add_preview.dart` — form
- [x] `features/wallet/presentation/widgets/wallet_buy_crypto_result_sections.dart` — standard
- [x] `features/wallet/presentation/widgets/wallet_health_score_page_shell.dart` — standard
- [x] `features/trade/presentation/pages/active_copies_page_part_01.dart` — standard
- [x] `features/trade/presentation/pages/advanced_analytics_page_part_01.dart` — standard
- [x] `features/trade/presentation/pages/advanced_analytics_page_part_03.dart` — standard
- [x] `features/trade/presentation/pages/advanced_chart_page.dart` — flush
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
- [x] `features/p2p/presentation/pages/p2p_chat_page.dart` — standard
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
- [x] `features/profile/presentation/pages/profile_page.dart` — standard
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

1. `dart run tool/page_rhythm_audit.dart --check` bật fail CI
2. Deprecate module `*SectionGap` tokens trùng global
3. (Tuỳ chọn) VitDensity.standard.pageContentGap 16→13 khi ≥80% pass audit
