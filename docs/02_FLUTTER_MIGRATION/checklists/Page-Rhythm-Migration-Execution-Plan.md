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
| Tổng file `VitPageContent` | 348 |
| Đã migrate (`done`) | 346 |
| Còn lại (`pending`) | 2 |
| Batch cuối | 02 |
| **Batch tiếp theo** | **01** |
| Ngày generate | 2026-07-17 |

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

Tham chiếu code mẫu: features/home/presentation/pages/home_page_state.dart
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
| 1 | `features/wallet/presentation/widgets/hub/vit_wallet_detail_scaffold.dart` | standard | pending |

**Gate:** `flutter analyze lib/features/wallet/`

### Batch 02 — p2p

Trạng thái: ⏳ PENDING

| # | File | Tier | Status |
| --- | --- | --- | --- |
| 1 | `features/p2p/presentation/widgets/hub/vit_p2p_flow_scaffold.dart` | standard | pending |

**Gate:** `flutter analyze lib/features/p2p/`

---

## File đã migrate trước manifest (batch 0)

- [x] `features/home/presentation/pages/home_page_state.dart` — compact
- [x] `features/home/presentation/widgets/home_status_content.dart` — compact
- [x] `features/discovery/presentation/pages/topic_hub_page.dart` — compact
- [x] `features/discovery/presentation/pages/unified_search_page.dart` — compact
- [x] `features/news/presentation/pages/news_page.dart` — compact
- [x] `features/notifications/presentation/pages/notifications_page.dart` — compact
- [x] `features/markets/presentation/pages/hub/market_list_page.dart` — compact
- [x] `features/markets/presentation/pages/hub/market_overview_page.dart` — compact
- [x] `features/markets/presentation/pages/hub/watchlist_page.dart` — compact
- [x] `features/markets/presentation/pages/pair/market_depth_page.dart` — flush
- [x] `features/markets/presentation/pages/pair/market_heatmap_page.dart` — compact
- [x] `features/markets/presentation/pages/pair/pair_detail_page.dart` — compact
- [x] `features/markets/presentation/pages/portfolio/advanced_charts_page_tabs_filters_widgets.dart` — flush
- [x] `features/markets/presentation/pages/portfolio/portfolio_tracker_page_overview_widgets.dart` — compact
- [x] `features/markets/presentation/pages/portfolio/price_alerts_page.dart` — compact
- [x] `features/markets/presentation/pages/research/market_news_page.dart` — compact
- [x] `features/markets/presentation/pages/research/social_sentiment_page.dart` — compact
- [x] `features/markets/presentation/pages/research/social_signals_page_tabs_widgets.dart` — compact
- [x] `features/markets/presentation/pages/research/token_info_page.dart` — compact
- [x] `features/markets/presentation/pages/research/token_unlocks_page_upcoming_widgets.dart` — compact
- [x] `features/markets/presentation/pages/tools/comparison_tool_page.dart` — compact
- [x] `features/markets/presentation/pages/tools/derivatives_overview_page.dart` — compact
- [x] `features/markets/presentation/pages/tools/market_calendar_page.dart` — compact
- [x] `features/markets/presentation/pages/tools/market_correlations_page.dart` — compact
- [x] `features/markets/presentation/pages/tools/market_movers_page.dart` — compact
- [x] `features/markets/presentation/pages/tools/market_screener_page.dart` — compact
- [x] `features/markets/presentation/pages/tools/market_sectors_page.dart` — compact
- [x] `features/predictions/presentation/pages/event/prediction_advanced_chart_page.dart` — flush
- [x] `features/predictions/presentation/pages/event/prediction_event_detail_page.dart` — standard
- [x] `features/predictions/presentation/pages/hub/predictions_breaking_page.dart` — compact
- [x] `features/predictions/presentation/pages/hub/predictions_home_page.dart` — compact
- [x] `features/predictions/presentation/pages/hub/predictions_rewards_page.dart` — compact
- [x] `features/predictions/presentation/pages/hub/predictions_search_page.dart` — compact
- [x] `features/predictions/presentation/pages/portfolio/prediction_market_maker_page.dart` — standard
- [x] `features/predictions/presentation/pages/portfolio/prediction_portfolio_analyzer_page.dart` — standard
- [x] `features/predictions/presentation/pages/portfolio/prediction_risk_calculator_page.dart` — standard
- [x] `features/predictions/presentation/pages/portfolio/predictions_portfolio_page.dart` — standard
- [x] `features/predictions/presentation/pages/social/prediction_data_integration_page.dart` — standard
- [x] `features/predictions/presentation/pages/social/prediction_event_calendar_page.dart` — standard
- [x] `features/predictions/presentation/pages/social/prediction_social_page.dart` — standard
- [x] `features/predictions/presentation/pages/social/prediction_tournaments_page.dart` — standard
- [x] `features/predictions/presentation/pages/social/predictions_global_activity_page.dart` — compact
- [x] `features/predictions/presentation/pages/social/predictions_leaderboard_page.dart` — compact
- [x] `features/predictions/presentation/widgets/event/prediction_advanced_chart_analysis.dart` — flush
- [x] `features/predictions/presentation/widgets/event/prediction_advanced_chart_indicators.dart` — flush
- [x] `features/predictions/presentation/widgets/event/prediction_advanced_chart_overview.dart` — flush
- [x] `features/predictions/presentation/widgets/event/prediction_order_receipt_page_sections.dart` — standard
- [x] `features/predictions/presentation/widgets/social/prediction_tournaments_detail.dart` — standard
- [x] `features/arena/presentation/pages/bridge/arena_prediction_bridge_foundation_page_principles_section.dart` — standard
- [x] `features/arena/presentation/pages/bridge/connected_ecosystem_production_page.dart` — standard
- [x] `features/arena/presentation/pages/challenge/arena_challenge_detail_page.dart` — standard
- [x] `features/arena/presentation/pages/challenge/arena_join_page.dart` — standard
- [x] `features/arena/presentation/pages/challenge/arena_leaderboard_page.dart` — compact
- [x] `features/arena/presentation/pages/challenge/arena_mode_detail_page.dart` — standard
- [x] `features/arena/presentation/pages/challenge/verified_challenges_page.dart` — standard
- [x] `features/arena/presentation/pages/governance/arena_blocked_users_page.dart` — standard
- [x] `features/arena/presentation/pages/governance/arena_governance_gate_page.dart` — form
- [x] `features/arena/presentation/pages/governance/arena_guide_page.dart` — standard
- [x] `features/arena/presentation/pages/governance/arena_report_case_page.dart` — standard
- [x] `features/arena/presentation/pages/governance/arena_resolution_center_page.dart` — standard
- [x] `features/arena/presentation/pages/governance/arena_safety_center_page.dart` — standard
- [x] `features/arena/presentation/pages/governance/arena_trust_breakdown_page.dart` — standard
- [x] `features/arena/presentation/pages/governance/my_arena_reports_page.dart` — compact
- [x] `features/arena/presentation/pages/hub/arena_flow_map_page.dart` — standard
- [x] `features/arena/presentation/pages/hub/arena_home_page_hero_and_templates.dart` — compact
- [x] `features/arena/presentation/pages/hub/arena_production_ready_page_screens_states_section.dart` — standard
- [x] `features/arena/presentation/pages/hub/my_arena_page.dart` — compact
- [x] `features/arena/presentation/pages/points/arena_points_entry_detail_page.dart` — standard
- [x] `features/arena/presentation/pages/points/arena_points_ledger_page.dart` — standard
- [x] `features/arena/presentation/pages/studio/arena_creator_page.dart` — standard
- [x] `features/arena/presentation/pages/studio/arena_smart_rule_builder_page.dart` — standard
- [x] `features/arena/presentation/pages/studio/arena_studio_page.dart` — standard
- [x] `features/arena/presentation/pages/studio/arena_universal_preset_library_page.dart` — standard
- [x] `features/wallet/presentation/pages/address/address_add_page.dart` — form
- [x] `features/wallet/presentation/pages/address/address_book_page.dart` — standard
- [x] `features/wallet/presentation/pages/assets/asset_detail_page.dart` — standard
- [x] `features/wallet/presentation/pages/history/transaction_history_page.dart` — standard
- [x] `features/wallet/presentation/pages/hub/wallet_page.dart` — standard
- [x] `features/wallet/presentation/pages/tools/network_status_page.dart` — standard
- [x] `features/wallet/presentation/pages/tools/portfolio_analytics_page.dart` — standard
- [x] `features/wallet/presentation/pages/tools/wallet_gas_optimizer_page.dart` — standard
- [x] `features/wallet/presentation/pages/tools/wallet_multi_manager_page.dart` — standard
- [x] `features/wallet/presentation/pages/tools/wallet_token_approval_page.dart` — standard
- [x] `features/wallet/presentation/pages/transfer/pending_deposits_page.dart` — standard
- [x] `features/wallet/presentation/pages/transfer/withdraw_limits_page.dart` — form
- [x] `features/wallet/presentation/widgets/address/wallet_address_add_preview.dart` — form
- [x] `features/wallet/presentation/widgets/assets/wallet_buy_crypto_result_sections.dart` — standard
- [x] `features/wallet/presentation/widgets/tools/wallet_health_score_page_shell.dart` — standard
- [x] `features/p2p/presentation/pages/ads/p2p_ad_analytics_page.dart` — standard
- [x] `features/p2p/presentation/pages/ads/p2p_ad_detail_page.dart` — standard
- [x] `features/p2p/presentation/pages/ads/p2p_order_book_page.dart` — standard
- [x] `features/p2p/presentation/pages/dispute/p2p_dispute_detail_page.dart` — form
- [x] `features/p2p/presentation/pages/dispute/p2p_dispute_evidence_page.dart` — form
- [x] `features/p2p/presentation/pages/dispute/p2p_dispute_page.dart` — form
- [x] `features/p2p/presentation/pages/dispute/p2p_dispute_resolution_page.dart` — form
- [x] `features/p2p/presentation/pages/dispute/p2p_disputes_page.dart` — form
- [x] `features/p2p/presentation/pages/dispute/p2p_insurance_fund_overview_cards.dart` — form
- [x] `features/p2p/presentation/pages/dispute/p2p_insurance_fund_page.dart` — form
- [x] `features/p2p/presentation/pages/dispute/p2p_insurance_policy_page.dart` — form
- [x] `features/p2p/presentation/pages/dispute/p2p_insurance_score_page.dart` — form
- [x] `features/p2p/presentation/pages/hub/p2p_dashboard_page.dart` — standard
- [x] `features/p2p/presentation/pages/hub/p2p_express_confirm_page.dart` — standard
- [x] `features/p2p/presentation/pages/hub/p2p_guide_page.dart` — standard
- [x] `features/p2p/presentation/pages/hub/p2p_notifications_settings_page.dart` — standard
- [x] `features/p2p/presentation/pages/hub/p2p_settings_page.dart` — standard
- [x] `features/p2p/presentation/pages/hub/p2p_trading_level_page.dart` — standard
- [x] `features/p2p/presentation/pages/merchant/p2p_identity_verification_page.dart` — form
- [x] `features/p2p/presentation/pages/merchant/p2p_kyc_requirements_page.dart` — form
- [x] `features/p2p/presentation/pages/merchant/p2p_kyc_status_page.dart` — form
- [x] `features/p2p/presentation/pages/merchant/p2p_merchant_apply_page_state.dart` — standard
- [x] `features/p2p/presentation/pages/merchant/p2p_selfie_verification_page.dart` — form
- [x] `features/p2p/presentation/pages/orders/p2p_chat_page.dart` — standard
- [x] `features/p2p/presentation/pages/orders/p2p_my_orders_page.dart` — standard
- [x] `features/p2p/presentation/pages/orders/p2p_order_cancel_page.dart` — standard
- [x] `features/p2p/presentation/pages/orders/p2p_order_proof_page.dart` — standard
- [x] `features/p2p/presentation/pages/orders/p2p_order_rate_page.dart` — standard
- [x] `features/p2p/presentation/pages/orders/p2p_order_timeline_page.dart` — standard
- [x] `features/p2p/presentation/pages/payment/p2p_payment_method_cooling_period_page.dart` — standard
- [x] `features/p2p/presentation/pages/payment/p2p_payment_method_history_page.dart` — standard
- [x] `features/p2p/presentation/pages/payment/p2p_payment_method_verification_page.dart` — form
- [x] `features/p2p/presentation/pages/security/p2p_achievements_page.dart` — standard
- [x] `features/p2p/presentation/pages/security/p2p_address_proof_page.dart` — standard
- [x] `features/p2p/presentation/pages/security/p2p_aml_screening_page.dart` — standard
- [x] `features/p2p/presentation/pages/security/p2p_anti_phishing_code_page.dart` — standard
- [x] `features/p2p/presentation/pages/security/p2p_blacklist_add_page.dart` — standard
- [x] `features/p2p/presentation/pages/security/p2p_blacklist_page.dart` — standard
- [x] `features/p2p/presentation/pages/security/p2p_compliance_overview_page.dart` — standard
- [x] `features/p2p/presentation/pages/security/p2p_contribution_history_page.dart` — standard
- [x] `features/p2p/presentation/pages/security/p2p_e2e_info_page.dart` — standard
- [x] `features/p2p/presentation/pages/security/p2p_fraud_prevention_page.dart` — standard
- [x] `features/p2p/presentation/pages/security/p2p_large_transaction_justification_page.dart` — standard
- [x] `features/p2p/presentation/pages/security/p2p_login_history_page.dart` — standard
- [x] `features/p2p/presentation/pages/security/p2p_report_merchant_page.dart` — standard
- [x] `features/p2p/presentation/pages/security/p2p_reviews_page.dart` — standard
- [x] `features/p2p/presentation/pages/security/p2p_risk_assessment_page.dart` — standard
- [x] `features/p2p/presentation/pages/security/p2p_security_center_page.dart` — standard
- [x] `features/p2p/presentation/pages/security/p2p_source_of_funds_page.dart` — standard
- [x] `features/p2p/presentation/pages/security/p2p_tax_reporting_page.dart` — standard
- [x] `features/p2p/presentation/pages/security/p2p_transaction_limits_page.dart` — standard
- [x] `features/p2p/presentation/pages/wallet/p2p_wallet_page.dart` — standard
- [x] `features/p2p/presentation/pages/wallet/p2p_wallet_transfer_page.dart` — standard
- [x] `features/p2p/presentation/widgets/hub/p2p_express_page_state.dart` — standard
- [x] `features/p2p/presentation/widgets/hub/p2p_home_page_state.dart` — standard
- [x] `features/p2p/presentation/widgets/orders/p2p_order_page_state.dart` — standard
- [x] `features/earn/presentation/pages/savings/earn_portfolio_page.dart` — standard
- [x] `features/earn/presentation/pages/savings/savings_analytics_page.dart` — standard
- [x] `features/earn/presentation/pages/savings/savings_auto_rebalance_page.dart` — standard
- [x] `features/earn/presentation/pages/savings/savings_autopilot_page.dart` — standard
- [x] `features/earn/presentation/pages/savings/savings_backtest_page.dart` — standard
- [x] `features/earn/presentation/pages/savings/savings_comparison_page.dart` — standard
- [x] `features/earn/presentation/pages/savings/savings_dca_page.dart` — standard
- [x] `features/earn/presentation/pages/savings/savings_export_page.dart` — standard
- [x] `features/earn/presentation/pages/savings/savings_faq_page.dart` — standard
- [x] `features/earn/presentation/pages/savings/savings_goal_page.dart` — standard
- [x] `features/earn/presentation/pages/savings/savings_guide_page.dart` — standard
- [x] `features/earn/presentation/pages/savings/savings_history_page.dart` — standard
- [x] `features/earn/presentation/pages/savings/savings_ladder_page.dart` — standard
- [x] `features/earn/presentation/pages/savings/savings_notification_preferences_page.dart` — standard
- [x] `features/earn/presentation/pages/savings/savings_notifications_page.dart` — standard
- [x] `features/earn/presentation/pages/savings/savings_page.dart` — standard
- [x] `features/earn/presentation/pages/savings/savings_product_detail_page.dart` — standard
- [x] `features/earn/presentation/pages/savings/savings_receipt_page.dart` — standard
- [x] `features/earn/presentation/pages/savings/savings_recommendations_page.dart` — standard
- [x] `features/earn/presentation/pages/savings/savings_redeem_page.dart` — standard
- [x] `features/earn/presentation/pages/savings/savings_risk_assessment_page.dart` — standard
- [x] `features/earn/presentation/pages/savings/savings_smart_suggestions_page.dart` — standard
- [x] `features/earn/presentation/pages/savings/savings_what_if_page.dart` — standard
- [x] `features/earn/presentation/pages/staking/auto_compound_settings_page.dart` — standard
- [x] `features/earn/presentation/pages/staking/staking_advanced_orders_page.dart` — standard
- [x] `features/earn/presentation/pages/staking/staking_analytics_page.dart` — standard
- [x] `features/earn/presentation/pages/staking/staking_api_documentation_page.dart` — standard
- [x] `features/earn/presentation/pages/staking/staking_audit_reports_page.dart` — standard
- [x] `features/earn/presentation/pages/staking/staking_auto_compound_page.dart` — standard
- [x] `features/earn/presentation/pages/staking/staking_community_governance_page.dart` — standard
- [x] `features/earn/presentation/pages/staking/staking_contingency_plan_page.dart` — standard
- [x] `features/earn/presentation/pages/staking/staking_custody_page.dart` — standard
- [x] `features/earn/presentation/pages/staking/staking_dashboard_page.dart` — standard
- [x] `features/earn/presentation/pages/staking/staking_data_export_page.dart` — standard
- [x] `features/earn/presentation/pages/staking/staking_developer_console_page.dart` — standard
- [x] `features/earn/presentation/pages/staking/staking_earn_page.dart` — standard
- [x] `features/earn/presentation/pages/staking/staking_earnings_calendar_page.dart` — standard
- [x] `features/earn/presentation/pages/staking/staking_emergency_actions_page.dart` — standard
- [x] `features/earn/presentation/pages/staking/staking_faq_page.dart` — standard
- [x] `features/earn/presentation/pages/staking/staking_forum_page.dart` — standard
- [x] `features/earn/presentation/pages/staking/staking_guide_page.dart` — standard
- [x] `features/earn/presentation/pages/staking/staking_history_page.dart` — standard
- [x] `features/earn/presentation/pages/staking/staking_institutional_page.dart` — standard
- [x] `features/earn/presentation/pages/staking/staking_insurance_fund_transparency_page.dart` — standard
- [x] `features/earn/presentation/pages/staking/staking_insurance_page.dart` — standard
- [x] `features/earn/presentation/pages/staking/staking_liquid_staking_page.dart` — standard
- [x] `features/earn/presentation/pages/staking/staking_multi_chain_page.dart` — standard
- [x] `features/earn/presentation/pages/staking/staking_notifications_page.dart` — standard
- [x] `features/earn/presentation/pages/staking/staking_proof_of_reserves_page.dart` — standard
- [x] `features/earn/presentation/pages/staking/staking_proposals_page.dart` — standard
- [x] `features/earn/presentation/pages/staking/staking_recommendations_page.dart` — standard
- [x] `features/earn/presentation/pages/staking/staking_regulatory_framework_page.dart` — standard
- [x] `features/earn/presentation/pages/staking/staking_risk_assessment_page.dart` — standard
- [x] `features/earn/presentation/pages/staking/staking_risk_dashboard_page.dart` — standard
- [x] `features/earn/presentation/pages/staking/staking_risk_disclosure_page.dart` — standard
- [x] `features/earn/presentation/pages/staking/staking_risk_score_calculator_page.dart` — standard
- [x] `features/earn/presentation/pages/staking/staking_slashing_history_page.dart` — standard
- [x] `features/earn/presentation/pages/staking/staking_social_feed_page.dart` — standard
- [x] `features/earn/presentation/pages/staking/staking_suitability_assessment_page.dart` — standard
- [x] `features/earn/presentation/pages/staking/staking_tax_guide_page.dart` — standard
- [x] `features/earn/presentation/pages/staking/staking_terms_page.dart` — standard
- [x] `features/earn/presentation/pages/staking/staking_third_party_integrations_page.dart` — standard
- [x] `features/earn/presentation/pages/staking/staking_transaction_reporting_page.dart` — standard
- [x] `features/earn/presentation/pages/staking/staking_validator_health_monitor_page.dart` — standard
- [x] `features/earn/presentation/pages/staking/staking_validator_selection_page.dart` — standard
- [x] `features/earn/presentation/pages/staking/staking_voting_page.dart` — standard
- [x] `features/earn/presentation/pages/staking/staking_webhooks_page.dart` — standard
- [x] `features/earn/presentation/pages/staking/staking_withdrawal_policy_page.dart` — form
- [x] `features/earn/presentation/widgets/savings/savings_auto_rebalance_allocation.dart` — standard
- [x] `features/earn/presentation/widgets/savings/savings_auto_rebalance_drift_history.dart` — standard
- [x] `features/earn/presentation/widgets/savings/savings_auto_rebalance_settings.dart` — standard
- [x] `features/earn/presentation/widgets/savings/savings_auto_rebalance_strategy.dart` — standard
- [x] `features/earn/presentation/widgets/savings/savings_ladder_analysis.dart` — standard
- [x] `features/earn/presentation/widgets/savings/savings_ladder_builder_config.dart` — standard
- [x] `features/earn/presentation/widgets/savings/savings_ladder_rung_manager.dart` — standard
- [x] `features/earn/presentation/widgets/savings/savings_ladder_timeline.dart` — standard
- [x] `features/earn/presentation/widgets/savings/savings_portfolio_overview.dart` — standard
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
- [x] `features/onboarding/presentation/widgets/onboarding_step_screens.dart` — form
- [x] `features/admin/presentation/pages/ab_test_dashboard.dart` — standard
- [x] `features/admin/presentation/pages/admin_home.dart` — standard
- [x] `features/admin/presentation/pages/admin_settings_page.dart` — standard
- [x] `features/admin/presentation/pages/analytics_dashboard.dart` — standard
- [x] `features/admin/presentation/pages/funnel_dashboard.dart` — standard
- [x] `features/cross_module/presentation/widgets/cross_module_tabbed_shell.dart` — standard
- [x] `features/dca/presentation/pages/hub/dca_overview_demo.dart` — standard
- [x] `features/dca/presentation/pages/hub/dca_page_state_overview.dart` — standard
- [x] `features/dca/presentation/pages/portfolio/dca_multi_asset_page_setup.dart` — standard
- [x] `features/dca/presentation/pages/portfolio/dca_performance_compare_page.dart` — standard
- [x] `features/dca/presentation/pages/portfolio/dca_portfolio_optimizer_page.dart` — standard
- [x] `features/dca/presentation/pages/portfolio/dca_rebalance_config_page.dart` — standard
- [x] `features/dca/presentation/pages/portfolio/dca_rebalance_config_page_settings_and_preview.dart` — standard
- [x] `features/dca/presentation/pages/portfolio/dca_rebalance_dashboard_page.dart` — standard
- [x] `features/dca/presentation/pages/research/dca_backtester_page.dart` — standard
- [x] `features/dca/presentation/pages/research/dca_dynamic_amount_page.dart` — standard
- [x] `features/dca/presentation/pages/schedule/dca_schedule_analytics_page.dart` — standard
- [x] `features/dca/presentation/pages/schedule/dca_schedule_config_page.dart` — standard
- [x] `features/dca/presentation/pages/schedule/dca_smart_rules_page.dart` — standard
- [x] `features/launchpad/presentation/pages/bridge/launchpad_bridge_compare_page.dart` — standard
- [x] `features/launchpad/presentation/pages/bridge/launchpad_bridge_order_page.dart` — standard
- [x] `features/launchpad/presentation/pages/bridge/launchpad_ido_bridge_page.dart` — standard
- [x] `features/launchpad/presentation/pages/bridge/launchpad_swap_aggregator_page.dart` — standard
- [x] `features/launchpad/presentation/pages/claim/launchpad_batch_claim_page.dart` — standard
- [x] `features/launchpad/presentation/pages/claim/launchpad_claim_receipt_page.dart` — standard
- [x] `features/launchpad/presentation/pages/hub/launchpad_contract_page.dart` — standard
- [x] `features/launchpad/presentation/pages/hub/launchpad_detail_page.dart` — standard
- [x] `features/launchpad/presentation/pages/hub/launchpad_page.dart` — standard
- [x] `features/launchpad/presentation/pages/hub/launchpad_performance_page.dart` — standard
- [x] `features/launchpad/presentation/pages/hub/launchpad_portfolio_page.dart` — standard
- [x] `features/launchpad/presentation/pages/hub/launchpad_receipt_page.dart` — standard
- [x] `features/launchpad/presentation/pages/tools/launchpad_abi_diff_page.dart` — standard
- [x] `features/launchpad/presentation/pages/tools/launchpad_address_book_page.dart` — standard
- [x] `features/launchpad/presentation/pages/tools/launchpad_dca_builder_page.dart` — standard
- [x] `features/launchpad/presentation/pages/tools/launchpad_event_log_page.dart` — standard
- [x] `features/launchpad/presentation/pages/tools/launchpad_gas_tracker_page.dart` — standard
- [x] `features/launchpad/presentation/pages/tools/launchpad_limit_orders_page.dart` — standard
- [x] `features/launchpad/presentation/pages/tools/launchpad_multisig_page.dart` — standard
- [x] `features/launchpad/presentation/pages/tools/launchpad_notif_sound_page.dart` — standard
- [x] `features/launchpad/presentation/pages/tools/launchpad_rebalance_page.dart` — standard
- [x] `features/launchpad/presentation/pages/tools/launchpad_risk_analytics_page.dart` — standard
- [x] `features/launchpad/presentation/pages/tools/launchpad_staking_page.dart` — standard
- [x] `features/launchpad/presentation/pages/tools/launchpad_webhooks_page.dart` — standard
- [x] `features/referral/presentation/pages/referral_friend_detail_page.dart` — standard
- [x] `features/referral/presentation/pages/referral_history_page.dart` — standard
- [x] `features/referral/presentation/pages/referral_home_page.dart` — standard
- [x] `features/referral/presentation/pages/referral_rewards_page_state.dart` — standard
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
- [x] `features/rewards/presentation/pages/rewards_hub_page.dart` — standard
- [x] `features/trade_bots/presentation/widgets/settings/bot_api_documentation_endpoints.dart` — standard
- [x] `features/trade_bots/presentation/widgets/settings/bot_api_documentation_support_common.dart` — standard
- [x] `features/trade_bots/presentation/widgets/settings/bot_api_documentation_websocket_examples.dart` — standard
- [x] `features/trade_bots/presentation/widgets/settings/bot_guide_blocks.dart` — standard
- [x] `features/trade_bots/presentation/widgets/settings/bot_guide_practices_videos.dart` — standard
- [x] `features/trade_bots/presentation/widgets/settings/bot_guide_strategies.dart` — standard
- [x] `features/trade_bots/presentation/widgets/settings/bot_security_settings_cards.dart` — standard
- [x] `features/trade_bots/presentation/widgets/settings/bot_suitability_breakdown_common.dart` — standard
- [x] `features/trade_bots/presentation/widgets/settings/bot_suitability_questions_info.dart` — standard
- [x] `features/trade_bots/presentation/widgets/settings/bot_suitability_result_score.dart` — standard
- [x] `features/trade_compliance/presentation/widgets/client_money/client_money_protection_page_sections.dart` — standard
- [x] `features/trade_compliance/presentation/widgets/client_money/investor_compensation_page_common.dart` — standard
- [x] `features/trade_compliance/presentation/widgets/client_money/investor_compensation_page_sections.dart` — standard
- [x] `features/trade_compliance/presentation/widgets/complaints/complaints_handling_overview_complaints.dart` — standard
- [x] `features/trade_compliance/presentation/widgets/complaints/complaints_handling_process_common.dart` — standard
- [x] `features/trade_compliance/presentation/widgets/disclosures/regulatory_disclosures_tabs.dart` — standard
- [x] `features/trade_compliance/presentation/widgets/disclosures/risk_indicator_details_common.dart` — standard
- [x] `features/trade_compliance/presentation/widgets/execution/best_execution_current.dart` — standard
- [x] `features/trade_compliance/presentation/widgets/execution/market_data_analytics_funding_traders.dart` — standard
- [x] `features/trade_compliance/presentation/widgets/execution/market_data_analytics_liquidations.dart` — standard
- [x] `features/trade_compliance/presentation/widgets/execution/market_data_analytics_open_interest.dart` — standard
- [x] `features/trade_compliance/presentation/widgets/execution/market_data_analytics_sentiment.dart` — standard
- [x] `features/trade_compliance/presentation/widgets/execution/slippage_monitoring_events.dart` — standard
- [x] `features/trade_compliance/presentation/widgets/execution/slippage_monitoring_tabs.dart` — standard
- [x] `features/trade_compliance/presentation/widgets/governance/client_categorization_history_tab.dart` — standard
- [x] `features/trade_compliance/presentation/widgets/governance/client_categorization_overview_tab.dart` — standard
- [x] `features/trade_compliance/presentation/widgets/governance/client_categorization_page_chrome.dart` — standard
- [x] `features/trade_compliance/presentation/widgets/governance/client_categorization_protections_requirements_tab.dart` — standard
- [x] `features/trade_compliance/presentation/widgets/hub/regulatory_reports_dashboard_exports.dart` — standard
- [x] `features/trade_compliance/presentation/widgets/hub/regulatory_reports_dashboard_overview.dart` — standard
- [x] `features/trade_compliance/presentation/widgets/hub/regulatory_reports_dashboard_queue_compliance.dart` — standard
- [x] `features/trade_copy/presentation/widgets/analytics/performance_attribution_summary_tabs.dart` — standard
- [x] `features/trade_copy/presentation/widgets/analytics/performance_attribution_tabs.dart` — standard
- [x] `features/trade_copy/presentation/widgets/hub/active_copies_overview.dart` — standard
- [x] `features/trade_copy/presentation/widgets/provider/provider_governance_page_common.dart` — standard
- [x] `features/trade_copy/presentation/widgets/provider/provider_governance_page_details.dart` — standard
- [x] `features/trade_copy/presentation/widgets/provider/provider_governance_page_overview.dart` — standard
- [x] `features/trade_copy/presentation/widgets/provider/trader_profile_stats_common.dart` — standard
- [x] `features/trade_copy/presentation/widgets/provider/trader_profile_trades.dart` — standard
- [x] `features/trade_copy/presentation/widgets/safety/dispute_resolution_cases.dart` — form
- [x] `features/trade_copy/presentation/widgets/safety/dispute_resolution_form.dart` — form
- [x] `features/trade_copy/presentation/widgets/safety/safety_education_page_common.dart` — standard
- [x] `features/trade_copy/presentation/widgets/safety/safety_education_page_sections.dart` — standard
- [x] `features/trade_core/presentation/widgets/trade_module_layout.dart` — standard
- [x] `features/trade_terminal/presentation/pages/tools/advanced_chart_page.dart` — flush
- [x] `features/trade_terminal/presentation/widgets/tools/advanced_analytics_page_ai_signals.dart` — flush
- [x] `features/trade_terminal/presentation/widgets/tools/advanced_analytics_page_risk_journal.dart` — flush
- [x] `features/trade_terminal/presentation/widgets/tools/advanced_analytics_page_sizing_footer.dart` — flush

---

## Phase 5 (sau khi pending = 0)

1. `dart run tool/page_rhythm_audit.dart --check` bật fail CI
2. Deprecate module `*SectionGap` tokens trùng global
3. (Tuỳ chọn) VitDensity.standard.pageContentGap 16→13 khi ≥80% pass audit
