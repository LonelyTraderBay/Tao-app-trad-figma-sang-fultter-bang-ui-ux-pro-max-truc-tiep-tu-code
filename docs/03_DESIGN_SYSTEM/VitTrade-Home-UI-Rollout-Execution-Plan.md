# VitTrade Home UI Rollout Execution Plan

**Status:** Active tracking plan
**Foundation:** `docs/03_DESIGN_SYSTEM/VitTrade-Home-UI-Rollout-Playbook.md`
**Generated:** 2026-06-14
**Scope source:** `flutter_app/lib/features/**/presentation/pages/*.dart`

Autonomous execution prompt:
`docs/03_DESIGN_SYSTEM/AI-Home-UI-Rollout-Autonomous-Execution-Prompt.md`

---

## 1. Mục Tiêu

Roll out chuẩn UI từ Home sang toàn bộ Flutter app mà không bỏ sót màn hình và
không tốn token để đọc lại toàn bộ repo trong mỗi batch.

Plan này chỉ track **screen entry files**. Các file `*_part_*.dart` là phần
implementation của màn cha và dùng chung trạng thái với màn cha.

Inventory hiện tại lấy từ source thật:

```text
screen_entry_files = 390
raw_page_files_including_part_files = 607
test_feature_modules = 22
```

Mục tiêu chất lượng:

- Dùng hierarchy và shared components theo chuẩn Home.
- Giữ nguyên business logic, routes, providers, copy boundaries và financial
  safety của từng module.
- Không làm tăng token debt hoặc typography debt.
- Chia batch nhỏ để mỗi lần làm AI chỉ cần đọc màn target, local widgets,
  tests liên quan và playbook.

## 1.1 Home Baseline Snapshot

Home hiện là baseline UI phải giữ khi rollout sang module khác. Nếu Home source
thay đổi, cập nhật snapshot này cùng prompt/playbook/tests trong cùng batch.

| Contract | Current baseline |
| --- | --- |
| Audit state | `root_page_bundle_summary` cho `home_page.dart` phải `pass` với `totalDebt=0` |
| Page rhythm | compact announcement -> portfolio hero -> next action -> market ticker -> products -> recent -> discovery -> market/full lists |
| Surface order | `HomeSurfaceOrder.productsBeforeRecent` |
| Density policy | `HomeDensityVariant.compact` ở width `<= 480`; compact shows `6` primary actions; comfortable shows `9`; overflow actions vào `VitSheetPanel` |
| Announcement policy | Chỉ render active `campaign`, `security`, `risk`; `info` không surface ở Home; campaign auto-hide sau `96dp`; security/risk không auto-hide do scroll |
| Shared visual baseline | `VitAnnouncementBanner.compact`, `VitCard.hero`, `VitMetricDeltaPill`, `VitNextActionCard`, `VitMarketTickerStrip`, `VitActionTileGrid.maxVisibleItems`, `VitCompactProductCard`, `VitDiscoveryActionCard.compact`, `VitMarketPairRow`, `VitRankedAssetRow`, `VitAssetAvatar`, `VitSparkline` |
| Guardrail | Home page bundle không reintroduce local visual classes, local `Container`, `BoxDecoration`, raw `EdgeInsets`, raw radii, emoji tab labels, hoặc bottom nav inside Home |

## 1.2 Home Sync Checklist

Dùng checklist này trong mọi batch có thay đổi Home hoặc thay đổi shared primitive
ảnh hưởng tới Home:

- [ ] Source Home vẫn giữ order, density, announcement, ticker và bottom-nav
      clearance như snapshot trên, hoặc snapshot được cập nhật có lý do.
- [ ] `flutter_app/test/features/home/home_page_test.dart` vẫn cover contract
      mới nhất: products before recent, market ticker tap, announcement session
      behavior, first viewport và guardrail local-pattern.
- [ ] `docs/03_DESIGN_SYSTEM/AI-Home-UI-Rollout-Autonomous-Execution-Prompt.md`
      và playbook đã đồng bộ nếu Home baseline thay đổi.
- [ ] Audit evidence vẫn giữ Home `totalDebt=0`; không sửa audit tool để né debt.

---

## 2. Chuẩn Áp Dụng Shared Components

Không ép mọi màn hình dùng **toàn bộ** shared components của dự án. Chuẩn đúng
là ép theo **pattern + token + safety contract**:

```text
Shared component is mandatory when the screen has the matching UI pattern.
Domain-specific composition stays local when it owns business logic or safety copy.
```

Điều này giúp UI đồng bộ mà không làm sai UX của các màn đặc thù như auth,
onboarding, advanced chart, fullscreen tools, Arena points-only, hoặc high-risk
financial forms.

### Enforcement Levels

| Level | Rule | Bắt buộc khi nào |
| --- | --- | --- |
| L0 - Token compliance | Dùng `AppColors`, `AppSpacing`, `AppTextStyles`, `AppModuleAccents`; không tạo local palette/font/spacing/radius trong page bundle | Mọi màn hình |
| L1 - Shared layout | Dùng `VitPageLayout`, `VitPageContent`, `VitHeader`/`VitTopChrome`, `VitInsetScrollView`, `VitCard`, state widgets khi phù hợp | Mọi màn có page shell/content/card/state tương ứng |
| L2 - Pattern shared | Dùng `VitMarketPairRow`, `VitActionTileGrid`, `VitDiscoveryActionCard`, `VitHighRiskStatePanel`, `VitInput`, `VitTabBar`, `VitStatusPill` khi pattern khớp | Màn có market rows, action launcher, cross-module discovery, high-risk form, input form, tabs, status |
| L3 - Domain local | Giữ local cho composition chứa business boundary, provider state, copy domain, route logic, financial safety, Arena points-only language | Khi shared component sẽ làm mờ domain hoặc buộc truyền business logic vào shared |

### Hard Rules

- Không tạo local scaffold, header, card, CTA, input, tab, section header,
  status pill, avatar, sparkline, bottom-sheet handle hoặc state widget nếu
  shared primitive đã cover cùng behavior.
- Không dùng local `TextStyle(fontSize: ...)`, raw color, raw spacing, raw
  radius/decoration trong page bundle khi token hoặc shared primitive đã cover.
- Wallet/Trade/P2P phải giữ masking, fee/risk/limit, preview/confirm và
  next-step copy.
- Market/Trade/Wallet/Earn/DCA/Launchpad numbers phải dùng
  `AppTextStyles.tabularFigures`.
- Arena luôn points-only; không dùng wallet, payout, profit hoặc stake-return
  language.
- Prediction Markets giữ wallet-value language riêng: positions, probability,
  receipt, P/L; không trộn với Arena.
- Module pages không copy `VitTopChromeType.rootBrand` từ Home nếu không phải
  true app-root surface.

### Soft Rules

- Nếu pattern chỉ xuất hiện ở một màn và chứa business logic rõ ràng, giữ local
  trước.
- Nếu cùng visual pattern lặp ở 2-3 màn hoặc 2 module, tạo hoặc mở rộng shared
  component domain-neutral.
- Guardrail mới nên bắt đầu advisory nếu repo còn nhiều legacy variants; chỉ
  chuyển strict sau khi batch migration đã chứng minh component phù hợp.
- Không refactor route/provider/business logic chỉ để áp dụng shared component.

### Allowed Exceptions

| Exception | Lý do |
| --- | --- |
| Auth/onboarding | Có thể cần fullscreen hoặc no-bottom-nav flow khác Home |
| Advanced chart/fullscreen workspace | Tối ưu canvas/tool interaction quan trọng hơn card/page rhythm |
| Dev/admin preview tools | Có thể cần hiển thị nhiều primitive cùng lúc để QA design system |
| Financial confirmation with domain-specific copy | Safety copy và route logic phải ở feature layer |
| Arena/Prediction bridge surfaces | Boundary language phải rõ, không gộp thành shared business card chung |

Batch chỉ đạt chuẩn khi implementer có thể chỉ ra level áp dụng cho từng màn:
L0/L1 luôn được kiểm; L2 được áp dụng khi pattern khớp; L3 được ghi lý do nếu
giữ local composition.

---

## 3. Quy Trình Tiết Kiệm Token

Dùng đúng workflow này cho từng batch:

1. Chọn một module và 2-5 screen entry files từ inventory bên dưới.
2. Chỉ đọc các screen files đó, local widgets của chúng và tests liên quan.
3. Map từng màn vào một pattern trong playbook:
   `command center`, `financial hero`, `market/data list`, `high-risk form`,
   `confirmation/receipt`, `profile/settings`, `points-only/social`, or
   `support/info`.
4. Áp dụng L0/L1 bắt buộc, áp dụng L2 khi pattern khớp, và ghi rõ lý do nếu
   giữ L3 local composition.
5. Giữ nguyên routes, providers, keys, masking, fee/risk/limit copy và
   Prediction/Arena boundaries.
6. Chạy focused tests cho module đó cùng token audit checks.
7. Cập nhật batch log với `Home pattern applied`, `L3 local reason`,
   `first viewport evidence`, và `tests/audit evidence` trước khi chuyển batch
   tiếp theo.

Không yêu cầu AI "sửa toàn bộ UI app" trong một prompt. Dùng một batch prompt
ngắn như sau:

```text
Target docs:
- docs/03_DESIGN_SYSTEM/VitTrade-Home-UI-Rollout-Playbook.md
- docs/03_DESIGN_SYSTEM/VitTrade-Home-UI-Rollout-Execution-Plan.md

Target module:
- <module>

Target screens:
- <screen_1.dart>
- <screen_2.dart>

Required behavior:
- Use Home-derived shared components.
- Keep business logic/safety unchanged.
- Update tests/audit evidence.
```

---

## 4. Priority Và Batch Rules

| Priority | Modules | Vì sao ưu tiên | Batch size | Verification bắt buộc |
| --- | --- | --- | ---: | --- |
| P0 | `wallet`, `trade`, `p2p` | Money movement, orders, escrow, account safety | 2-4 screens | Focused module tests, design-token audit, high-risk guardrail when applicable |
| P1 | `markets`, `profile`, `auth`, `onboarding`, `notifications`, `support` | Primary navigation, account/security, first-run trust | 3-5 screens | Focused module tests, top-header guardrails if header changes |
| P2 | `predictions`, `arena`, `earn`, `dca`, `launchpad` | Product depth, boundary-sensitive copy, dense cards/lists | 3-5 screens | Focused module tests, copy boundary review, responsive QA for grids/forms |
| P3 | `discovery`, `cross_module`, `referral`, `rewards`, `news`, `admin`, `dev`, `enterprise_states` | Secondary/internal surfaces after main product flows | 4-6 screens | Focused tests or nearest tests, full suite if shared previews change |
| Done | `home` | Source foundation already aligned | N/A | Keep Home root bundle `totalDebt=0` |

Giá trị status:

| Status | Meaning |
| --- | --- |
| `Not started` | Chưa bắt đầu rollout chuẩn Home cho màn/module này. |
| `In progress` | Batch hiện tại đang sửa hoặc test màn này. |
| `Blocked` | Cần quyết định product/design hoặc thiếu shared primitive. |
| `Done` | Màn đã migrate, có test/audit evidence, không regression safety. |
| `Deferred` | Chủ động hoãn, thường là dev/internal hoặc demo cũ. |

---

## 5. Module Tracking Matrix

| Module | Count | Priority | Target Home pattern | Batch slicing rule | Safety/token focus | Status |
| --- | ---: | --- | --- | --- | --- | --- |
| `wallet` | 19 | P0 | Financial command center, high-risk form, receipt/history | Start with `wallet_page`, `deposit_page`, `withdraw_page`, `transfer_page`; then asset/history/tools | Masking, fee/risk/limit, preview/confirm, tabular figures | Not started |
| `trade` | 86 | P0 | Instrument workspace, high-risk order form, data lists, receipts | Split by families: core trade, convert, futures/margin, bots, copy, regulatory | Price/amount tabular, buy/sell semantics, order preview, risk disclosure | Not started |
| `p2p` | 71 | P0 | Escrow command center, high-risk forms, dispute/support, security | Split by wallet/order/payment/security/dispute/merchant | Escrow, payment method confirmation, account masking, KYC/security copy | Not started |
| `markets` | 21 | P1 | Market/data list, ticker, pair detail, charts | Start with market list/detail/movers/watchlist; then analytics pages | Dense rows, sparklines, tabular price/percent, no hype copy | Not started |
| `profile` | 11 | P1 | Profile/settings, security/account hub | Start with profile/security/settings/KYC | Masked identifiers, security preview/confirm | Not started |
| `auth` | 6 | P1 | Auth/onboarding exception, support/info, high-risk security | Login/register/OTP/reset/2FA | No root app chrome; clear security copy | Not started |
| `onboarding` | 1 | P1 | First-run onboarding exception | Single screen | No bottom nav unless app shell requires it | Not started |
| `notifications` | 1 | P1 | Support/info inbox | Single screen | Security/risk notices explicit | Not started |
| `support` | 3 | P1 | Support/info | Support hub, help, announcements | Clear next step and offline/error states | Not started |
| `predictions` | 17 | P2 | Prediction market data, positions, receipt | Home/detail/portfolio/receipt/risk/social | Keep wallet-value language separate from Arena | Not started |
| `arena` | 26 | P2 | Points-only/social, challenge detail, governance | Home/points/challenge/join/safety/governance | Points-only language, no wallet/profit/payout | Not started |
| `earn` | 68 | P2 | Yield/product hub, high-risk disclosures, receipt/history | Split staking vs savings; then risk/developer/social | APY tabular, lock/risk terms, no guaranteed returns | Not started |
| `dca` | 12 | P2 | Recurring investment setup, preview, analytics | Core DCA, config pages, analytics pages | Frequency, budget, fee/risk preview | Not started |
| `launchpad` | 24 | P2 | Campaign/detail, allocation, receipt, tools | Core launchpad, receipts/claims, tools | Eligibility, lock/risk, no FOMO | Not started |
| `discovery` | 2 | P3 | Cross-module search/discovery | Search then topic hub | Prediction/Arena boundaries | Not started |
| `cross_module` | 4 | P3 | Cross-module portfolio/alerts/tax | Portfolio, analytics, alerts, tax | Avoid mixing value/points semantics | Not started |
| `referral` | 5 | P3 | Support/info and rewards list | Hub, history, rewards, rules, detail | No payout hype; clear eligibility | Not started |
| `rewards` | 1 | P3 | Rewards hub | Single screen | Keep reward copy factual | Not started |
| `news` | 1 | P3 | Info feed | Single screen | No trading recommendation copy | Not started |
| `admin` | 5 | P3 | Internal dashboard | Home, analytics, funnels, A/B, settings | Internal-only actions remain internal | Not started |
| `dev` | 4 | P3 | Internal design/QA tools | Design system, showcase, route checker, performance | No production UI drift from experiments | Not started |
| `enterprise_states` | 1 | P3 | State preview/reference | Single screen | Preserve state semantics | Not started |
| `home` | 1 | Done | Source foundation | N/A | Keep Home audit `totalDebt=0` | Done |

---

## 6. Screen Inventory

Dùng inventory này để không bỏ sót màn. Mỗi dòng chỉ liệt kê screen entry files.
Nếu màn có `*_part_*.dart`, coi các part files là implementation details của
entry file đã liệt kê.

| Module | Screen entry files |
| --- | --- |
| `wallet` | `address_add_page.dart`, `address_book_page.dart`, `asset_detail_page.dart`, `buy_crypto_page.dart`, `deposit_page.dart`, `dust_converter_page.dart`, `network_status_page.dart`, `pending_deposits_page.dart`, `portfolio_analytics_page.dart`, `transaction_detail_page.dart`, `transaction_history_page.dart`, `transfer_page.dart`, `wallet_gas_optimizer_page.dart`, `wallet_health_score_page.dart`, `wallet_multi_manager_page.dart`, `wallet_page.dart`, `wallet_token_approval_page.dart`, `withdraw_limits_page.dart`, `withdraw_page.dart` |
| `trade` | `active_copies_page.dart`, `advanced_analytics_page.dart`, `advanced_chart_page.dart`, `advanced_tools_demo_page.dart`, `advanced_trading_demo_page.dart`, `arm_integration_status_page.dart`, `audit_trail_page.dart`, `best_execution_reports_page.dart`, `bot_api_documentation_page.dart`, `bot_backtesting_page.dart`, `bot_drawdown_analyzer_page.dart`, `bot_emergency_stop_page.dart`, `bot_equity_curve_page.dart`, `bot_faq_page.dart`, `bot_guide_page.dart`, `bot_history_page.dart`, `bot_optimization_page.dart`, `bot_performance_analytics_page.dart`, `bot_portfolio_dashboard_page.dart`, `bot_risk_dashboard_page.dart`, `bot_risk_disclosure_page.dart`, `bot_security_settings_page.dart`, `bot_strategy_compare_page.dart`, `bot_suitability_assessment_page.dart`, `bot_tax_reporting_page.dart`, `bot_terms_of_service_page.dart`, `cass_reconciliation_page.dart`, `client_categorization_page.dart`, `client_money_protection_page.dart`, `complaint_submission_page.dart`, `complaint_tracking_page.dart`, `complaints_handling_page.dart`, `convert_page.dart`, `copy_audit_log_page.dart`, `copy_configuration_page.dart`, `copy_confirmation_page.dart`, `copy_education_page.dart`, `copy_notifications_page.dart`, `copy_performance_page.dart`, `copy_provider_detail_page.dart`, `copy_safety_center_page.dart`, `copy_settings_page.dart`, `copy_trading_card_demo.dart`, `copy_trading_page.dart`, `copy_trading_v2_page.dart`, `dispute_resolution_page.dart`, `ex_ante_costs_page.dart`, `ex_post_costs_report_page.dart`, `execution_quality_demo_page.dart`, `execution_venue_analysis_page.dart`, `futures_page.dart`, `investor_compensation_page.dart`, `kid_generator_page.dart`, `leverage_page.dart`, `live_market_data_analytics_page.dart`, `margin_trading_hub_page.dart`, `margin_trading_page.dart`, `market_data_analytics_page.dart`, `ombudsman_referral_page.dart`, `order_receipt_page.dart`, `orders_history_page.dart`, `performance_attribution_page.dart`, `performance_scenarios_page.dart`, `portfolio_risk_analysis_page.dart`, `position_dashboard_page.dart`, `pre_copy_assessment_page.dart`, `product_governance_page.dart`, `provider_application_page.dart`, `provider_comparison_page.dart`, `provider_governance_page.dart`, `provider_leaderboard_page.dart`, `regulatory_disclosures_page.dart`, `regulatory_inspection_ready_page.dart`, `regulatory_reports_dashboard_page.dart`, `risk_indicator_explainer_page.dart`, `risk_management_demo_page.dart`, `riy_calculator_page.dart`, `safety_education_page.dart`, `slippage_monitoring_page.dart`, `target_market_definition_page.dart`, `trade_history_export_page.dart`, `trade_page.dart`, `trade_settings_page.dart`, `trader_profile_page.dart`, `trading_bots_page.dart`, `transaction_reporting_page.dart` |
| `p2p` | `p2p_2fa_settings_page.dart`, `p2p_achievements_page.dart`, `p2p_ad_analytics_page.dart`, `p2p_ad_detail_page.dart`, `p2p_address_proof_page.dart`, `p2p_aml_screening_page.dart`, `p2p_anti_phishing_code_page.dart`, `p2p_blacklist_add_page.dart`, `p2p_blacklist_page.dart`, `p2p_chat_page.dart`, `p2p_claim_detail_page.dart`, `p2p_compliance_overview_page.dart`, `p2p_contribution_history_page.dart`, `p2p_create_ad_page.dart`, `p2p_dashboard_page.dart`, `p2p_device_management_page.dart`, `p2p_dispute_detail_page.dart`, `p2p_dispute_evidence_page.dart`, `p2p_dispute_page.dart`, `p2p_dispute_resolution_page.dart`, `p2p_disputes_page.dart`, `p2p_e2e_info_page.dart`, `p2p_escrow_balance_page.dart`, `p2p_escrow_detail_page.dart`, `p2p_express_confirm_page.dart`, `p2p_express_page.dart`, `p2p_fraud_prevention_page.dart`, `p2p_fund_lock_history_page.dart`, `p2p_guide_page.dart`, `p2p_home_page.dart`, `p2p_identity_verification_page.dart`, `p2p_insurance_certificate_page.dart`, `p2p_insurance_fund_page.dart`, `p2p_insurance_policy_page.dart`, `p2p_insurance_score_page.dart`, `p2p_kyc_requirements_page.dart`, `p2p_kyc_status_page.dart`, `p2p_large_transaction_justification_page.dart`, `p2p_limit_tracker_page.dart`, `p2p_login_history_page.dart`, `p2p_merchant_apply_page.dart`, `p2p_merchant_profile_page.dart`, `p2p_my_ads_page.dart`, `p2p_my_orders_page.dart`, `p2p_notifications_settings_page.dart`, `p2p_order_book_page.dart`, `p2p_order_cancel_page.dart`, `p2p_order_page.dart`, `p2p_order_proof_page.dart`, `p2p_order_rate_page.dart`, `p2p_order_timeline_page.dart`, `p2p_payment_method_add_page.dart`, `p2p_payment_method_cooling_period_page.dart`, `p2p_payment_method_history_page.dart`, `p2p_payment_method_ownership_page.dart`, `p2p_payment_method_verification_page.dart`, `p2p_payment_methods_page.dart`, `p2p_report_merchant_page.dart`, `p2p_reviews_page.dart`, `p2p_risk_assessment_page.dart`, `p2p_security_center_page.dart`, `p2p_selfie_verification_page.dart`, `p2p_settings_page.dart`, `p2p_source_of_funds_page.dart`, `p2p_suspicious_activity_page.dart`, `p2p_tax_reporting_page.dart`, `p2p_trading_level_page.dart`, `p2p_transaction_limits_page.dart`, `p2p_video_verification_page.dart`, `p2p_wallet_page.dart`, `p2p_wallet_transfer_page.dart` |
| `markets` | `advanced_charts_page.dart`, `comparison_tool_page.dart`, `derivatives_overview_page.dart`, `market_calendar_page.dart`, `market_correlations_page.dart`, `market_depth_page.dart`, `market_heatmap_page.dart`, `market_list_page.dart`, `market_movers_page.dart`, `market_news_page.dart`, `market_overview_page.dart`, `market_screener_page.dart`, `market_sectors_page.dart`, `pair_detail_page.dart`, `portfolio_tracker_page.dart`, `price_alerts_page.dart`, `social_sentiment_page.dart`, `social_signals_page.dart`, `token_info_page.dart`, `token_unlocks_page.dart`, `watchlist_page.dart` |
| `profile` | `activity_log_page.dart`, `api_key_create_page.dart`, `api_management_page.dart`, `device_management_page.dart`, `edit_profile_page.dart`, `kyc_page.dart`, `profile_page.dart`, `security_page.dart`, `settings_page.dart`, `sub_account_page.dart`, `vip_page.dart` |
| `arena` | `arena_blocked_users_page.dart`, `arena_challenge_detail_page.dart`, `arena_creator_page.dart`, `arena_flow_map_page.dart`, `arena_governance_gate_page.dart`, `arena_guide_page.dart`, `arena_home_page.dart`, `arena_join_page.dart`, `arena_leaderboard_page.dart`, `arena_mode_detail_page.dart`, `arena_points_entry_detail_page.dart`, `arena_points_ledger_page.dart`, `arena_points_page.dart`, `arena_prediction_bridge_foundation_page.dart`, `arena_production_ready_page.dart`, `arena_report_case_page.dart`, `arena_resolution_center_page.dart`, `arena_safety_center_page.dart`, `arena_smart_rule_builder_page.dart`, `arena_studio_page.dart`, `arena_trust_breakdown_page.dart`, `arena_universal_preset_library_page.dart`, `connected_ecosystem_production_page.dart`, `my_arena_page.dart`, `my_arena_reports_page.dart`, `verified_challenges_page.dart` |
| `predictions` | `prediction_advanced_chart_page.dart`, `prediction_data_integration_page.dart`, `prediction_event_calendar_page.dart`, `prediction_event_detail_page.dart`, `prediction_market_maker_page.dart`, `prediction_order_receipt_page.dart`, `prediction_portfolio_analyzer_page.dart`, `prediction_risk_calculator_page.dart`, `prediction_social_page.dart`, `prediction_tournaments_page.dart`, `predictions_breaking_page.dart`, `predictions_global_activity_page.dart`, `predictions_home_page.dart`, `predictions_leaderboard_page.dart`, `predictions_portfolio_page.dart`, `predictions_rewards_page.dart`, `predictions_search_page.dart` |
| `earn` | `auto_compound_settings_page.dart`, `savings_analytics_page.dart`, `savings_auto_rebalance_page.dart`, `savings_autopilot_page.dart`, `savings_backtest_page.dart`, `savings_comparison_page.dart`, `savings_dca_page.dart`, `savings_export_page.dart`, `savings_faq_page.dart`, `savings_goal_page.dart`, `savings_guide_page.dart`, `savings_history_page.dart`, `savings_ladder_page.dart`, `savings_notification_preferences_page.dart`, `savings_notifications_page.dart`, `savings_page.dart`, `savings_portfolio_page.dart`, `savings_product_detail_page.dart`, `savings_receipt_page.dart`, `savings_recommendations_page.dart`, `savings_redeem_page.dart`, `savings_risk_assessment_page.dart`, `savings_smart_suggestions_page.dart`, `savings_what_if_page.dart`, `staking_advanced_orders_page.dart`, `staking_analytics_page.dart`, `staking_api_documentation_page.dart`, `staking_audit_reports_page.dart`, `staking_auto_compound_page.dart`, `staking_community_governance_page.dart`, `staking_contingency_plan_page.dart`, `staking_custody_page.dart`, `staking_dashboard_page.dart`, `staking_data_export_page.dart`, `staking_developer_console_page.dart`, `staking_earn_page.dart`, `staking_earnings_calendar_page.dart`, `staking_emergency_actions_page.dart`, `staking_faq_page.dart`, `staking_forum_page.dart`, `staking_guide_page.dart`, `staking_history_page.dart`, `staking_institutional_page.dart`, `staking_insurance_fund_transparency_page.dart`, `staking_insurance_page.dart`, `staking_liquid_staking_page.dart`, `staking_multi_chain_page.dart`, `staking_notifications_page.dart`, `staking_proof_of_reserves_page.dart`, `staking_proposals_page.dart`, `staking_recommendations_page.dart`, `staking_regulatory_framework_page.dart`, `staking_risk_assessment_page.dart`, `staking_risk_dashboard_page.dart`, `staking_risk_disclosure_page.dart`, `staking_risk_score_calculator_page.dart`, `staking_slashing_history_page.dart`, `staking_social_feed_page.dart`, `staking_suitability_assessment_page.dart`, `staking_tax_guide_page.dart`, `staking_terms_page.dart`, `staking_third_party_integrations_page.dart`, `staking_transaction_reporting_page.dart`, `staking_validator_health_monitor_page.dart`, `staking_validator_selection_page.dart`, `staking_voting_page.dart`, `staking_webhooks_page.dart`, `staking_withdrawal_policy_page.dart` |
| `dca` | `dca_backtester_page.dart`, `dca_dynamic_amount_page.dart`, `dca_multi_asset_page.dart`, `dca_overview_demo.dart`, `dca_page.dart`, `dca_performance_compare_page.dart`, `dca_portfolio_optimizer_page.dart`, `dca_rebalance_config_page.dart`, `dca_rebalance_dashboard_page.dart`, `dca_schedule_analytics_page.dart`, `dca_schedule_config_page.dart`, `dca_smart_rules_page.dart` |
| `launchpad` | `launchpad_abi_diff_page.dart`, `launchpad_address_book_page.dart`, `launchpad_batch_claim_page.dart`, `launchpad_bridge_compare_page.dart`, `launchpad_bridge_order_page.dart`, `launchpad_claim_receipt_page.dart`, `launchpad_contract_page.dart`, `launchpad_dca_builder_page.dart`, `launchpad_detail_page.dart`, `launchpad_event_log_page.dart`, `launchpad_gas_tracker_page.dart`, `launchpad_ido_bridge_page.dart`, `launchpad_limit_orders_page.dart`, `launchpad_multisig_page.dart`, `launchpad_notif_sound_page.dart`, `launchpad_page.dart`, `launchpad_performance_page.dart`, `launchpad_portfolio_page.dart`, `launchpad_rebalance_page.dart`, `launchpad_receipt_page.dart`, `launchpad_risk_analytics_page.dart`, `launchpad_staking_page.dart`, `launchpad_swap_aggregator_page.dart`, `launchpad_webhooks_page.dart` |
| `discovery` | `topic_hub_page.dart`, `unified_search_page.dart` |
| `notifications` | `notifications_page.dart` |
| `news` | `news_page.dart` |
| `support` | `announcements_page.dart`, `help_center_page.dart`, `support_page.dart` |
| `admin` | `ab_test_dashboard.dart`, `admin_home.dart`, `admin_settings_page.dart`, `analytics_dashboard.dart`, `funnel_dashboard.dart` |
| `dev` | `design_system_page.dart`, `missing_screens_showcase_page.dart`, `performance_monitor.dart`, `route_checker_page.dart` |
| `auth` | `forgot_password_page.dart`, `login_page.dart`, `otp_page.dart`, `register_page.dart`, `reset_password_page.dart`, `two_fa_setup_page.dart` |
| `onboarding` | `onboarding_flow.dart` |
| `cross_module` | `cross_module_analytics.dart`, `smart_alert_center.dart`, `tax_report_center.dart`, `unified_portfolio_dashboard.dart` |
| `referral` | `referral_friend_detail_page.dart`, `referral_history_page.dart`, `referral_home_page.dart`, `referral_rewards_page.dart`, `referral_rules_page.dart` |
| `rewards` | `rewards_hub_page.dart` |
| `enterprise_states` | `enterprise_states_page.dart` |
| `home` | `home_page.dart` |

---

## 7. Batch Log Template

Copy dòng mẫu này vào log khi bắt đầu mỗi implementation batch. Không đánh dấu
`Done` nếu thiếu Home pattern, L3 reason, first viewport evidence, hoặc
tests/audit evidence.

| Date | Batch | Module | Screens | Home pattern applied | L3 local reason | First viewport evidence | Tests/audit evidence | Status | Notes |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| YYYY-MM-DD | P0.Wallet.01 | `wallet` | `wallet_page.dart`, `deposit_page.dart` | Financial command center / high-risk form | None or precise reason | TBD | TBD | Not started | Keep masking and fees. |

---

## 8. Commands Bắt Buộc Theo Loại Thay Đổi

Docs-only tracking update:

```bash
git diff --check -- docs/03_DESIGN_SYSTEM/VitTrade-Home-UI-Rollout-Execution-Plan.md
```

Single module UI batch:

```bash
cd flutter_app
dart run tool/design_token_consistency_audit.dart --check
flutter test test/quality/design_token_consistency_guardrail_test.dart --reporter=compact
flutter analyze
flutter test test/features/<module> --reporter=compact
```

Shared primitive or cross-module batch:

```bash
cd flutter_app
dart run tool/design_token_consistency_audit.dart --check
flutter analyze
flutter test --reporter=compact
```

Chạy emulator hoặc responsive visual QA khi batch thay đổi first viewport,
bottom chrome clearance, dense grids, high-risk forms hoặc market rows.
