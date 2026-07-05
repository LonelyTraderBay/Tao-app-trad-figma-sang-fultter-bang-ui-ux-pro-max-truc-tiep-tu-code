# Checklist — 26 batch pending (redesign UI)

**Generated:** 2026-07-05 · **Baseline git:** `dad444ab0`

Mỗi dòng = **1 chat mới** (hoặc nhiều chat nếu batch >10 màn — max 5–10 file/chat).

Sau pass gate: `status=done` trong CSV → `py -3 flutter_app/tool/gen_redesign_plan.py`.

Playbook: [EXECUTION-PLAYBOOK.md](EXECUTION-PLAYBOOK.md) · Contract: [REDESIGN-CONTRACT.md](REDESIGN-CONTRACT.md)

**Prompt copy-paste (multi-run):** [EXECUTION-PENDING-26.md](EXECUTION-PENDING-26.md) — **27 chat** theo thứ tự, ghi rõ lần chạy từng batch.

---

## Tóm tắt

| Metric | Value |
| --- | --- |
| Batch pending | **26** |
| Màn trong các batch pending | 181 |
| Màn **còn thiếu** (chưa diff) | **86** |

## Bảng nhanh

| # | Batch | Module | Tier | Done | Còn | Hub / ghi chú |
| ---: | --- | --- | --- | ---: | ---: | --- |
| 1 | `RD-M02-B01` | auth | A_hub | 1/6 | **5** | `prompt-redesign/auth-hub.md` hub — Phase 1 có thể đã xong một phần |
| 3 | `RD-K01` | markets | A_hub | 1/5 | **4** | `prompt-redesign/markets-hub.md` hub — Phase 1 có thể đã xong một phần |
| 5 | `RD-K03` | markets | B_child | 6/8 | **2** | `prompt-redesign/markets-hub.md`  |
| 18 | `RD-W01` | wallet | A_hub | 2/6 | **4** | `prompt-redesign/wallet-hub.md` hub — Phase 1 có thể đã xong một phần |
| 21 | `RD-W04` | wallet | B_child | 5/7 | **2** | `prompt-redesign/wallet-hub.md`  |
| 22 | `RD-F01` | profile | B_simple | 5/8 | **3** | —  |
| 25 | `RD-P01` | p2p | A_hub | 2/6 | **4** | `prompt-redesign/p2p-hub.md` hub — Phase 1 có thể đã xong một phần |
| 26 | `RD-P02` | p2p | B_child | 3/8 | **5** | `prompt-redesign/p2p-hub.md`  |
| 27 | `RD-P03` | p2p | B_child | 4/9 | **5** | `prompt-redesign/p2p-hub.md`  |
| 29 | `RD-P05` | p2p | B_child | 8/9 | **1** | `prompt-redesign/p2p-hub.md`  |
| 31 | `RD-P07` | p2p | B_child | 3/8 | **5** | `prompt-redesign/p2p-hub.md`  |
| 32 | `RD-P08` | p2p | B_child | 3/6 | **3** | `prompt-redesign/p2p-hub.md`  |
| 35 | `RD-P11` | p2p | B_child | 2/4 | **2** | `prompt-redesign/p2p-hub.md`  |
| 36 | `RD-E01` | earn | A_hub | 2/6 | **4** | `prompt-redesign/earn-staking-hub.md` hub — Phase 1 có thể đã xong một phần |
| 42 | `RD-E07` | earn | B_child | 8/18 | **10** | `prompt-redesign/earn-staking-hub.md`  |
| 43 | `RD-C01` | dca | B_simple | 4/5 | **1** | —  |
| 46 | `RD-R01` | predictions | A_hub | 1/5 | **4** | `prompt-redesign/predictions-hub.md` hub — Phase 1 có thể đã xong một phần |
| 48 | `RD-R03` | predictions | B_child | 5/6 | **1** | `prompt-redesign/predictions-hub.md`  |
| 49 | `RD-A01` | arena | A_hub | 5/6 | **1** | `prompt-redesign/arena-hub.md` hub — Phase 1 có thể đã xong một phần |
| 50 | `RD-A02` | arena | B_child | 4/7 | **3** | `prompt-redesign/arena-hub.md`  |
| 53 | `RD-A05` | arena | B_child | 2/3 | **1** | `prompt-redesign/arena-hub.md`  |
| 54 | `RD-L01` | launchpad | A_hub | 1/4 | **3** | `prompt-redesign/launchpad-hub.md` hub — Phase 1 có thể đã xong một phần |
| 55 | `RD-L02` | launchpad | B_child | 3/7 | **4** | `prompt-redesign/launchpad-hub.md`  |
| 56 | `RD-L03` | launchpad | B_child | 12/13 | **1** | `prompt-redesign/launchpad-hub.md`  |
| 60 | `RD-M17-B01` | referral | B_simple | 2/5 | **3** | —  |
| 66 | `RD-M23-B01` | dev | B_simple | 1/6 | **5** | —  |

---

## Chi tiết từng batch

### 1. `RD-M02-B01` — auth (5 màn còn)

- **Tier:** A_hub
- **Hub prompt:** `prompt-redesign/auth-hub.md`
- **Module prompt:** `prompt-redesign/auth-hub.md`
- **Tiến độ page_files:** 1/6 done

**Còn sửa:**
- [ ] `register_page` — `lib/features/auth/presentation/pages/register_page.dart`
- [ ] `otp_page` — `lib/features/auth/presentation/pages/otp_page.dart`
- [ ] `two_fa_setup_page` — `lib/features/auth/presentation/pages/two_fa_setup_page.dart`
- [ ] `forgot_password_page` — `lib/features/auth/presentation/pages/forgot_password_page.dart`
- [ ] `reset_password_page` — `lib/features/auth/presentation/pages/reset_password_page.dart`

**Đã có diff:**
- [x] `login_page`

**Chat checklist:**
- [ ] Copy prompt từ EXECUTION-PLAYBOOK bước 1
- [ ] GitNexus `impact()` trước edit
- [ ] Sửa tối đa 5–10 file (ưu tiên màn [ ] trên)
- [ ] `flutter analyze` + test module
- [ ] CSV `status=done` nếu **hết** màn trong batch
- [ ] `py -3 flutter_app/tool/gen_redesign_plan.py`

### 3. `RD-K01` — markets (4 màn còn)

- **Tier:** A_hub
- **Hub prompt:** `prompt-redesign/markets-hub.md`
- **Module prompt:** `prompt-redesign/markets-hub.md`
- **Tiến độ page_files:** 1/5 done

**Còn sửa:**
- [ ] `market_overview_page` — `lib/features/markets/presentation/pages/market_overview_page.dart`
- [ ] `market_movers_page` — `lib/features/markets/presentation/pages/market_movers_page.dart`
- [ ] `market_sectors_page` — `lib/features/markets/presentation/pages/market_sectors_page.dart`
- [ ] `watchlist_page` — `lib/features/markets/presentation/pages/watchlist_page.dart`

**Đã có diff:**
- [x] `market_list_page`

**Chat checklist:**
- [ ] Copy prompt từ EXECUTION-PLAYBOOK bước 3
- [ ] GitNexus `impact()` trước edit
- [ ] Sửa tối đa 5–10 file (ưu tiên màn [ ] trên)
- [ ] `flutter analyze` + test module
- [ ] CSV `status=done` nếu **hết** màn trong batch
- [ ] `py -3 flutter_app/tool/gen_redesign_plan.py`

### 5. `RD-K03` — markets (2 màn còn)

- **Tier:** B_child
- **Module prompt:** `prompt-redesign/markets-hub.md`
- **Tiến độ page_files:** 6/8 done

**Còn sửa:**
- [ ] `advanced_charts_page` — `lib/features/markets/presentation/pages/advanced_charts_page.dart`
- [ ] `token_unlocks_page` — `lib/features/markets/presentation/pages/token_unlocks_page.dart`

**Đã có diff:**
- [x] `market_depth_page`
- [x] `social_sentiment_page`
- [x] `portfolio_tracker_page`
- [x] `market_news_page`
- [x] `social_signals_page`
- [x] `market_correlations_page`

**Chat checklist:**
- [ ] Copy prompt từ EXECUTION-PLAYBOOK bước 5
- [ ] GitNexus `impact()` trước edit
- [ ] Sửa tối đa 5–10 file (ưu tiên màn [ ] trên)
- [ ] `flutter analyze` + test module
- [ ] CSV `status=done` nếu **hết** màn trong batch
- [ ] `py -3 flutter_app/tool/gen_redesign_plan.py`

### 18. `RD-W01` — wallet (4 màn còn)

- **Tier:** A_hub
- **Hub prompt:** `prompt-redesign/wallet-hub.md`
- **Module prompt:** `prompt-redesign/wallet-hub.md`
- **Tiến độ page_files:** 2/6 done

**Còn sửa:**
- [ ] `transaction_history_page` — `lib/features/wallet/presentation/pages/transaction_history_page.dart`
- [ ] `asset_detail_page` — `lib/features/wallet/presentation/pages/asset_detail_page.dart`
- [ ] `portfolio_analytics_page` — `lib/features/wallet/presentation/pages/portfolio_analytics_page.dart`
- [ ] `wallet_multi_manager_page` — `lib/features/wallet/presentation/pages/wallet_multi_manager_page.dart`

**Đã có diff:**
- [x] `wallet_page`
- [x] `wallet_health_score_page`

**Chat checklist:**
- [ ] Copy prompt từ EXECUTION-PLAYBOOK bước 18
- [ ] GitNexus `impact()` trước edit
- [ ] Sửa tối đa 5–10 file (ưu tiên màn [ ] trên)
- [ ] `flutter analyze` + test module
- [ ] CSV `status=done` nếu **hết** màn trong batch
- [ ] `py -3 flutter_app/tool/gen_redesign_plan.py`

### 21. `RD-W04` — wallet (2 màn còn)

- **Tier:** B_child
- **Module prompt:** `prompt-redesign/wallet-hub.md`
- **Tiến độ page_files:** 5/7 done

**Còn sửa:**
- [ ] `dust_converter_page` — `lib/features/wallet/presentation/pages/dust_converter_page.dart`
- [ ] `transaction_detail_page` — `lib/features/wallet/presentation/pages/transaction_detail_page.dart`

**Đã có diff:**
- [x] `buy_crypto_page`
- [x] `transfer_page`
- [x] `network_status_page`
- [x] `wallet_gas_optimizer_page`
- [x] `wallet_token_approval_page`

**Chat checklist:**
- [ ] Copy prompt từ EXECUTION-PLAYBOOK bước 21
- [ ] GitNexus `impact()` trước edit
- [ ] Sửa tối đa 5–10 file (ưu tiên màn [ ] trên)
- [ ] `flutter analyze` + test module
- [ ] CSV `status=done` nếu **hết** màn trong batch
- [ ] `py -3 flutter_app/tool/gen_redesign_plan.py`

### 22. `RD-F01` — profile (3 màn còn)

- **Tier:** B_simple
- **Tiến độ page_files:** 5/8 done

**Còn sửa:**
- [ ] `profile_page` — `lib/features/profile/presentation/pages/profile_page.dart`
- [ ] `vip_page` — `lib/features/profile/presentation/pages/vip_page.dart`
- [ ] `sub_account_page` — `lib/features/profile/presentation/pages/sub_account_page.dart`

**Đã có diff:**
- [x] `edit_profile_page`
- [x] `settings_page`
- [x] `activity_log_page`
- [x] `my_arena_page`
- [x] `predictions_portfolio_page`

**Chat checklist:**
- [ ] Copy prompt từ EXECUTION-PLAYBOOK bước 22
- [ ] GitNexus `impact()` trước edit
- [ ] Sửa tối đa 5–10 file (ưu tiên màn [ ] trên)
- [ ] `flutter analyze` + test module
- [ ] CSV `status=done` nếu **hết** màn trong batch
- [ ] `py -3 flutter_app/tool/gen_redesign_plan.py`

### 25. `RD-P01` — p2p (4 màn còn)

- **Tier:** A_hub
- **Hub prompt:** `prompt-redesign/p2p-hub.md`
- **Module prompt:** `prompt-redesign/p2p-hub.md`
- **Tiến độ page_files:** 2/6 done

**Còn sửa:**
- [ ] `p2p_order_book_page` — `lib/features/p2p/presentation/pages/p2p_order_book_page.dart`
- [ ] `p2p_my_orders_page` — `lib/features/p2p/presentation/pages/p2p_my_orders_page.dart`
- [ ] `p2p_settings_page` — `lib/features/p2p/presentation/pages/p2p_settings_page.dart`
- [ ] `p2p_guide_page` — `lib/features/p2p/presentation/pages/p2p_guide_page.dart`

**Đã có diff:**
- [x] `p2p_home_page`
- [x] `p2p_dashboard_page`

**Chat checklist:**
- [ ] Copy prompt từ EXECUTION-PLAYBOOK bước 25
- [ ] GitNexus `impact()` trước edit
- [ ] Sửa tối đa 5–10 file (ưu tiên màn [ ] trên)
- [ ] `flutter analyze` + test module
- [ ] CSV `status=done` nếu **hết** màn trong batch
- [ ] `py -3 flutter_app/tool/gen_redesign_plan.py`

### 26. `RD-P02` — p2p (5 màn còn)

- **Tier:** B_child
- **Module prompt:** `prompt-redesign/p2p-hub.md`
- **Tiến độ page_files:** 3/8 done

**Còn sửa:**
- [ ] `p2p_express_confirm_page` — `lib/features/p2p/presentation/pages/p2p_express_confirm_page.dart`
- [ ] `p2p_order_rate_page` — `lib/features/p2p/presentation/pages/p2p_order_rate_page.dart`
- [ ] `p2p_order_cancel_page` — `lib/features/p2p/presentation/pages/p2p_order_cancel_page.dart`
- [ ] `p2p_order_proof_page` — `lib/features/p2p/presentation/pages/p2p_order_proof_page.dart`
- [ ] `p2p_chat_page` — `lib/features/p2p/presentation/pages/p2p_chat_page.dart`

**Đã có diff:**
- [x] `p2p_express_page`
- [x] `p2p_order_timeline_page`
- [x] `p2p_order_page`

**Chat checklist:**
- [ ] Copy prompt từ EXECUTION-PLAYBOOK bước 26
- [ ] GitNexus `impact()` trước edit
- [ ] Sửa tối đa 5–10 file (ưu tiên màn [ ] trên)
- [ ] `flutter analyze` + test module
- [ ] CSV `status=done` nếu **hết** màn trong batch
- [ ] `py -3 flutter_app/tool/gen_redesign_plan.py`

### 27. `RD-P03` — p2p (5 màn còn)

- **Tier:** B_child
- **Module prompt:** `prompt-redesign/p2p-hub.md`
- **Tiến độ page_files:** 4/9 done

**Còn sửa:**
- [ ] `p2p_merchant_apply_page` — `lib/features/p2p/presentation/pages/p2p_merchant_apply_page.dart`
- [ ] `p2p_merchant_profile_page` — `lib/features/p2p/presentation/pages/p2p_merchant_profile_page.dart`
- [ ] `p2p_report_merchant_page` — `lib/features/p2p/presentation/pages/p2p_report_merchant_page.dart`
- [ ] `p2p_trading_level_page` — `lib/features/p2p/presentation/pages/p2p_trading_level_page.dart`
- [ ] `p2p_reviews_page` — `lib/features/p2p/presentation/pages/p2p_reviews_page.dart`

**Đã có diff:**
- [x] `p2p_ad_analytics_page`
- [x] `p2p_ad_detail_page`
- [x] `p2p_my_ads_page`
- [x] `p2p_create_ad_page`

**Chat checklist:**
- [ ] Copy prompt từ EXECUTION-PLAYBOOK bước 27
- [ ] GitNexus `impact()` trước edit
- [ ] Sửa tối đa 5–10 file (ưu tiên màn [ ] trên)
- [ ] `flutter analyze` + test module
- [ ] CSV `status=done` nếu **hết** màn trong batch
- [ ] `py -3 flutter_app/tool/gen_redesign_plan.py`

### 29. `RD-P05` — p2p (1 màn còn)

- **Tier:** B_child
- **Module prompt:** `prompt-redesign/p2p-hub.md`
- **Tiến độ page_files:** 8/9 done

**Còn sửa:**
- [ ] `p2p_claim_detail_page` — `lib/features/p2p/presentation/pages/p2p_claim_detail_page.dart`

**Đã có diff:**
- [x] `p2p_insurance_fund_page`
- [x] `p2p_insurance_certificate_page`
- [x] `p2p_insurance_score_page`
- [x] `p2p_insurance_policy_page`
- [x] `p2p_contribution_history_page`
- [x] `p2p_insurance_fund_page`
- [x] `p2p_escrow_balance_page`
- [x] `p2p_escrow_detail_page`

**Chat checklist:**
- [ ] Copy prompt từ EXECUTION-PLAYBOOK bước 29
- [ ] GitNexus `impact()` trước edit
- [ ] Sửa tối đa 5–10 file (ưu tiên màn [ ] trên)
- [ ] `flutter analyze` + test module
- [ ] CSV `status=done` nếu **hết** màn trong batch
- [ ] `py -3 flutter_app/tool/gen_redesign_plan.py`

### 31. `RD-P07` — p2p (5 màn còn)

- **Tier:** B_child
- **Module prompt:** `prompt-redesign/p2p-hub.md`
- **Tiến độ page_files:** 3/8 done

**Còn sửa:**
- [ ] `p2p_2fa_settings_page` — `lib/features/p2p/presentation/pages/p2p_2fa_settings_page.dart`
- [ ] `p2p_device_management_page` — `lib/features/p2p/presentation/pages/p2p_device_management_page.dart`
- [ ] `p2p_login_history_page` — `lib/features/p2p/presentation/pages/p2p_login_history_page.dart`
- [ ] `p2p_e2e_info_page` — `lib/features/p2p/presentation/pages/p2p_e2e_info_page.dart`
- [ ] `p2p_fraud_prevention_page` — `lib/features/p2p/presentation/pages/p2p_fraud_prevention_page.dart`

**Đã có diff:**
- [x] `p2p_security_center_page`
- [x] `p2p_anti_phishing_code_page`
- [x] `p2p_suspicious_activity_page`

**Chat checklist:**
- [ ] Copy prompt từ EXECUTION-PLAYBOOK bước 31
- [ ] GitNexus `impact()` trước edit
- [ ] Sửa tối đa 5–10 file (ưu tiên màn [ ] trên)
- [ ] `flutter analyze` + test module
- [ ] CSV `status=done` nếu **hết** màn trong batch
- [ ] `py -3 flutter_app/tool/gen_redesign_plan.py`

### 32. `RD-P08` — p2p (3 màn còn)

- **Tier:** B_child
- **Module prompt:** `prompt-redesign/p2p-hub.md`
- **Tiến độ page_files:** 3/6 done

**Còn sửa:**
- [ ] `p2p_wallet_transfer_page` — `lib/features/p2p/presentation/pages/p2p_wallet_transfer_page.dart`
- [ ] `p2p_wallet_page` — `lib/features/p2p/presentation/pages/p2p_wallet_page.dart`
- [ ] `p2p_transaction_limits_page` — `lib/features/p2p/presentation/pages/p2p_transaction_limits_page.dart`

**Đã có diff:**
- [x] `p2p_fund_lock_history_page`
- [x] `p2p_fund_lock_history_page`
- [x] `p2p_limit_tracker_page`

**Chat checklist:**
- [ ] Copy prompt từ EXECUTION-PLAYBOOK bước 32
- [ ] GitNexus `impact()` trước edit
- [ ] Sửa tối đa 5–10 file (ưu tiên màn [ ] trên)
- [ ] `flutter analyze` + test module
- [ ] CSV `status=done` nếu **hết** màn trong batch
- [ ] `py -3 flutter_app/tool/gen_redesign_plan.py`

### 35. `RD-P11` — p2p (2 màn còn)

- **Tier:** B_child
- **Module prompt:** `prompt-redesign/p2p-hub.md`
- **Tiến độ page_files:** 2/4 done

**Còn sửa:**
- [ ] `p2p_blacklist_page` — `lib/features/p2p/presentation/pages/p2p_blacklist_page.dart`
- [ ] `p2p_notifications_settings_page` — `lib/features/p2p/presentation/pages/p2p_notifications_settings_page.dart`

**Đã có diff:**
- [x] `p2p_achievements_page`
- [x] `p2p_blacklist_add_page`

**Chat checklist:**
- [ ] Copy prompt từ EXECUTION-PLAYBOOK bước 35
- [ ] GitNexus `impact()` trước edit
- [ ] Sửa tối đa 5–10 file (ưu tiên màn [ ] trên)
- [ ] `flutter analyze` + test module
- [ ] CSV `status=done` nếu **hết** màn trong batch
- [ ] `py -3 flutter_app/tool/gen_redesign_plan.py`

### 36. `RD-E01` — earn (4 màn còn)

- **Tier:** A_hub
- **Hub prompt:** `prompt-redesign/earn-staking-hub.md`
- **Module prompt:** `prompt-redesign/earn-staking-hub.md`
- **Tiến độ page_files:** 2/6 done

**Còn sửa:**
- [ ] `staking_dashboard_page` — `lib/features/earn/presentation/pages/staking_dashboard_page.dart`
- [ ] `staking_analytics_page` — `lib/features/earn/presentation/pages/staking_analytics_page.dart`
- [ ] `staking_history_page` — `lib/features/earn/presentation/pages/staking_history_page.dart`
- [ ] `staking_earnings_calendar_page` — `lib/features/earn/presentation/pages/staking_earnings_calendar_page.dart`

**Đã có diff:**
- [x] `staking_earn_page`
- [x] `staking_earn_page`

**Chat checklist:**
- [ ] Copy prompt từ EXECUTION-PLAYBOOK bước 36
- [ ] GitNexus `impact()` trước edit
- [ ] Sửa tối đa 5–10 file (ưu tiên màn [ ] trên)
- [ ] `flutter analyze` + test module
- [ ] CSV `status=done` nếu **hết** màn trong batch
- [ ] `py -3 flutter_app/tool/gen_redesign_plan.py`

### 42. `RD-E07` — earn (10 màn còn)

- **Tier:** B_child
- **Module prompt:** `prompt-redesign/earn-staking-hub.md`
- **Tiến độ page_files:** 8/18 done

**Còn sửa:**
- [ ] `savings_faq_page` — `lib/features/earn/presentation/pages/savings_faq_page.dart`
- [ ] `savings_recommendations_page` — `lib/features/earn/presentation/pages/savings_recommendations_page.dart`
- [ ] `savings_goal_page` — `lib/features/earn/presentation/pages/savings_goal_page.dart`
- [ ] `savings_analytics_page` — `lib/features/earn/presentation/pages/savings_analytics_page.dart`
- [ ] `savings_auto_rebalance_page` — `lib/features/earn/presentation/pages/savings_auto_rebalance_page.dart`
- [ ] `savings_notification_preferences_page` — `lib/features/earn/presentation/pages/savings_notification_preferences_page.dart`
- [ ] `savings_dca_page` — `lib/features/earn/presentation/pages/savings_dca_page.dart`
- [ ] `savings_smart_suggestions_page` — `lib/features/earn/presentation/pages/savings_smart_suggestions_page.dart`
- [ ] `savings_export_page` — `lib/features/earn/presentation/pages/savings_export_page.dart`
- [ ] `savings_what_if_page` — `lib/features/earn/presentation/pages/savings_what_if_page.dart`

**Đã có diff:**
- [x] `savings_guide_page`
- [x] `savings_notifications_page`
- [x] `savings_risk_assessment_page`
- [x] `savings_comparison_page`
- [x] `auto_compound_settings_page`
- [x] `savings_backtest_page`
- [x] `savings_autopilot_page`
- [x] `savings_ladder_page`

**Chat checklist:**
- [ ] Copy prompt từ EXECUTION-PLAYBOOK bước 42
- [ ] GitNexus `impact()` trước edit
- [ ] Sửa tối đa 5–10 file (ưu tiên màn [ ] trên)
- [ ] `flutter analyze` + test module
- [ ] CSV `status=done` nếu **hết** màn trong batch
- [ ] `py -3 flutter_app/tool/gen_redesign_plan.py`

### 43. `RD-C01` — dca (1 màn còn)

- **Tier:** B_simple
- **Tiến độ page_files:** 4/5 done

**Còn sửa:**
- [ ] `dca_page` — `lib/features/dca/presentation/pages/dca_page.dart`

**Đã có diff:**
- [x] `dca_schedule_config_page`
- [x] `dca_schedule_analytics_page`
- [x] `dca_dynamic_amount_page`
- [x] `dca_smart_rules_page`

**Chat checklist:**
- [ ] Copy prompt từ EXECUTION-PLAYBOOK bước 43
- [ ] GitNexus `impact()` trước edit
- [ ] Sửa tối đa 5–10 file (ưu tiên màn [ ] trên)
- [ ] `flutter analyze` + test module
- [ ] CSV `status=done` nếu **hết** màn trong batch
- [ ] `py -3 flutter_app/tool/gen_redesign_plan.py`

### 46. `RD-R01` — predictions (4 màn còn)

- **Tier:** A_hub
- **Hub prompt:** `prompt-redesign/predictions-hub.md`
- **Module prompt:** `prompt-redesign/predictions-hub.md`
- **Tiến độ page_files:** 1/5 done

**Còn sửa:**
- [ ] `predictions_search_page` — `lib/features/predictions/presentation/pages/predictions_search_page.dart`
- [ ] `predictions_breaking_page` — `lib/features/predictions/presentation/pages/predictions_breaking_page.dart`
- [ ] `prediction_event_detail_page` — `lib/features/predictions/presentation/pages/prediction_event_detail_page.dart`
- [ ] `prediction_event_calendar_page` — `lib/features/predictions/presentation/pages/prediction_event_calendar_page.dart`

**Đã có diff:**
- [x] `predictions_home_page`

**Chat checklist:**
- [ ] Copy prompt từ EXECUTION-PLAYBOOK bước 46
- [ ] GitNexus `impact()` trước edit
- [ ] Sửa tối đa 5–10 file (ưu tiên màn [ ] trên)
- [ ] `flutter analyze` + test module
- [ ] CSV `status=done` nếu **hết** màn trong batch
- [ ] `py -3 flutter_app/tool/gen_redesign_plan.py`

### 48. `RD-R03` — predictions (1 màn còn)

- **Tier:** B_child
- **Module prompt:** `prompt-redesign/predictions-hub.md`
- **Tiến độ page_files:** 5/6 done

**Còn sửa:**
- [ ] `prediction_order_receipt_page` — `lib/features/predictions/presentation/pages/prediction_order_receipt_page.dart`

**Đã có diff:**
- [x] `prediction_risk_calculator_page`
- [x] `prediction_market_maker_page`
- [x] `prediction_portfolio_analyzer_page`
- [x] `prediction_advanced_chart_page_part_01`
- [x] `prediction_data_integration_page`

**Chat checklist:**
- [ ] Copy prompt từ EXECUTION-PLAYBOOK bước 48
- [ ] GitNexus `impact()` trước edit
- [ ] Sửa tối đa 5–10 file (ưu tiên màn [ ] trên)
- [ ] `flutter analyze` + test module
- [ ] CSV `status=done` nếu **hết** màn trong batch
- [ ] `py -3 flutter_app/tool/gen_redesign_plan.py`

### 49. `RD-A01` — arena (1 màn còn)

- **Tier:** A_hub
- **Hub prompt:** `prompt-redesign/arena-hub.md`
- **Module prompt:** `prompt-redesign/arena-hub.md`
- **Tiến độ page_files:** 5/6 done

**Còn sửa:**
- [ ] `arena_guide_page` — `lib/features/arena/presentation/pages/arena_guide_page.dart`

**Đã có diff:**
- [x] `arena_home_page`
- [x] `arena_studio_page`
- [x] `arena_smart_rule_builder_page`
- [x] `arena_universal_preset_library_page`
- [x] `arena_governance_gate_page`

**Chat checklist:**
- [ ] Copy prompt từ EXECUTION-PLAYBOOK bước 49
- [ ] GitNexus `impact()` trước edit
- [ ] Sửa tối đa 5–10 file (ưu tiên màn [ ] trên)
- [ ] `flutter analyze` + test module
- [ ] CSV `status=done` nếu **hết** màn trong batch
- [ ] `py -3 flutter_app/tool/gen_redesign_plan.py`

### 50. `RD-A02` — arena (3 màn còn)

- **Tier:** B_child
- **Module prompt:** `prompt-redesign/arena-hub.md`
- **Tiến độ page_files:** 4/7 done

**Còn sửa:**
- [ ] `arena_join_page` — `lib/features/arena/presentation/pages/arena_join_page.dart`
- [ ] `arena_creator_page` — `lib/features/arena/presentation/pages/arena_creator_page.dart`
- [ ] `arena_leaderboard_page` — `lib/features/arena/presentation/pages/arena_leaderboard_page.dart`

**Đã có diff:**
- [x] `arena_mode_detail_page`
- [x] `arena_challenge_detail_page`
- [x] `arena_resolution_center_page`
- [x] `verified_challenges_page`

**Chat checklist:**
- [ ] Copy prompt từ EXECUTION-PLAYBOOK bước 50
- [ ] GitNexus `impact()` trước edit
- [ ] Sửa tối đa 5–10 file (ưu tiên màn [ ] trên)
- [ ] `flutter analyze` + test module
- [ ] CSV `status=done` nếu **hết** màn trong batch
- [ ] `py -3 flutter_app/tool/gen_redesign_plan.py`

### 53. `RD-A05` — arena (1 màn còn)

- **Tier:** B_child
- **Module prompt:** `prompt-redesign/arena-hub.md`
- **Tiến độ page_files:** 2/3 done

**Còn sửa:**
- [ ] `arena_production_ready_page` — `lib/features/arena/presentation/pages/arena_production_ready_page.dart`

**Đã có diff:**
- [x] `arena_prediction_bridge_foundation_page`
- [x] `connected_ecosystem_production_page`

**Chat checklist:**
- [ ] Copy prompt từ EXECUTION-PLAYBOOK bước 53
- [ ] GitNexus `impact()` trước edit
- [ ] Sửa tối đa 5–10 file (ưu tiên màn [ ] trên)
- [ ] `flutter analyze` + test module
- [ ] CSV `status=done` nếu **hết** màn trong batch
- [ ] `py -3 flutter_app/tool/gen_redesign_plan.py`

### 54. `RD-L01` — launchpad (3 màn còn)

- **Tier:** A_hub
- **Hub prompt:** `prompt-redesign/launchpad-hub.md`
- **Module prompt:** `prompt-redesign/launchpad-hub.md`
- **Tiến độ page_files:** 1/4 done

**Còn sửa:**
- [ ] `launchpad_portfolio_page` — `lib/features/launchpad/presentation/pages/launchpad_portfolio_page.dart`
- [ ] `launchpad_performance_page` — `lib/features/launchpad/presentation/pages/launchpad_performance_page.dart`
- [ ] `launchpad_detail_page` — `lib/features/launchpad/presentation/pages/launchpad_detail_page.dart`

**Đã có diff:**
- [x] `launchpad_page`

**Chat checklist:**
- [ ] Copy prompt từ EXECUTION-PLAYBOOK bước 54
- [ ] GitNexus `impact()` trước edit
- [ ] Sửa tối đa 5–10 file (ưu tiên màn [ ] trên)
- [ ] `flutter analyze` + test module
- [ ] CSV `status=done` nếu **hết** màn trong batch
- [ ] `py -3 flutter_app/tool/gen_redesign_plan.py`

### 55. `RD-L02` — launchpad (4 màn còn)

- **Tier:** B_child
- **Module prompt:** `prompt-redesign/launchpad-hub.md`
- **Tiến độ page_files:** 3/7 done

**Còn sửa:**
- [ ] `launchpad_staking_page` — `lib/features/launchpad/presentation/pages/launchpad_staking_page.dart`
- [ ] `launchpad_receipt_page` — `lib/features/launchpad/presentation/pages/launchpad_receipt_page.dart`
- [ ] `launchpad_claim_receipt_page` — `lib/features/launchpad/presentation/pages/launchpad_claim_receipt_page.dart`
- [ ] `launchpad_bridge_order_page` — `lib/features/launchpad/presentation/pages/launchpad_bridge_order_page.dart`

**Đã có diff:**
- [x] `launchpad_ido_bridge_page`
- [x] `launchpad_contract_page`
- [x] `launchpad_batch_claim_page`

**Chat checklist:**
- [ ] Copy prompt từ EXECUTION-PLAYBOOK bước 55
- [ ] GitNexus `impact()` trước edit
- [ ] Sửa tối đa 5–10 file (ưu tiên màn [ ] trên)
- [ ] `flutter analyze` + test module
- [ ] CSV `status=done` nếu **hết** màn trong batch
- [ ] `py -3 flutter_app/tool/gen_redesign_plan.py`

### 56. `RD-L03` — launchpad (1 màn còn)

- **Tier:** B_child
- **Module prompt:** `prompt-redesign/launchpad-hub.md`
- **Tiến độ page_files:** 12/13 done

**Còn sửa:**
- [ ] `launchpad_multisig_page` — `lib/features/launchpad/presentation/pages/launchpad_multisig_page.dart`

**Đã có diff:**
- [x] `launchpad_bridge_compare_page`
- [x] `launchpad_notif_sound_page`
- [x] `launchpad_event_log_page`
- [x] `launchpad_abi_diff_page`
- [x] `launchpad_address_book_page`
- [x] `launchpad_webhooks_page`
- [x] `launchpad_gas_tracker_page`
- [x] `launchpad_rebalance_page`
- [x] `launchpad_swap_aggregator_page`
- [x] `launchpad_limit_orders_page`
- [x] `launchpad_dca_builder_page`
- [x] `launchpad_risk_analytics_page`

**Chat checklist:**
- [ ] Copy prompt từ EXECUTION-PLAYBOOK bước 56
- [ ] GitNexus `impact()` trước edit
- [ ] Sửa tối đa 5–10 file (ưu tiên màn [ ] trên)
- [ ] `flutter analyze` + test module
- [ ] CSV `status=done` nếu **hết** màn trong batch
- [ ] `py -3 flutter_app/tool/gen_redesign_plan.py`

### 60. `RD-M17-B01` — referral (3 màn còn)

- **Tier:** B_simple
- **Tiến độ page_files:** 2/5 done

**Còn sửa:**
- [ ] `referral_rewards_page` — `lib/features/referral/presentation/pages/referral_rewards_page.dart`
- [ ] `referral_rules_page` — `lib/features/referral/presentation/pages/referral_rules_page.dart`
- [ ] `referral_home_page` — `lib/features/referral/presentation/pages/referral_home_page.dart`

**Đã có diff:**
- [x] `referral_history_page`
- [x] `referral_friend_detail_page`

**Chat checklist:**
- [ ] Copy prompt từ EXECUTION-PLAYBOOK bước 60
- [ ] GitNexus `impact()` trước edit
- [ ] Sửa tối đa 5–10 file (ưu tiên màn [ ] trên)
- [ ] `flutter analyze` + test module
- [ ] CSV `status=done` nếu **hết** màn trong batch
- [ ] `py -3 flutter_app/tool/gen_redesign_plan.py`

### 66. `RD-M23-B01` — dev (5 màn còn)

- **Tier:** B_simple
- **Tiến độ page_files:** 1/6 done

**Còn sửa:**
- [ ] `route_checker_page` — `lib/features/dev/presentation/pages/route_checker_page.dart`
- [ ] `performance_monitor` — `lib/features/dev/presentation/pages/performance_monitor.dart`
- [ ] `missing_screens_showcase_page` — `lib/features/dev/presentation/pages/missing_screens_showcase_page.dart`
- [ ] `design_system_page` — `lib/features/dev/presentation/pages/design_system_page.dart`
- [ ] `dca_overview_demo` — `lib/features/dca/presentation/pages/dca_overview_demo.dart`

**Đã có diff:**
- [x] `copy_trading_card_demo`

**Chat checklist:**
- [ ] Copy prompt từ EXECUTION-PLAYBOOK bước 66
- [ ] GitNexus `impact()` trước edit
- [ ] Sửa tối đa 5–10 file (ưu tiên màn [ ] trên)
- [ ] `flutter analyze` + test module
- [ ] CSV `status=done` nếu **hết** màn trong batch
- [ ] `py -3 flutter_app/tool/gen_redesign_plan.py`

---

## Thứ tự đề xuất (hub trước, rồi batch con cùng module)

1. **Auth** — bước 1 `RD-M02-B01`
2. **Markets** — bước 3 `RD-K01`, bước 5 `RD-K03`
3. **Wallet** — bước 18 `RD-W01`, bước 21 `RD-W04`
4. **Profile** — bước 22 `RD-F01`
5. **P2P** — bước 25–35 (hub `RD-P01` trước)
6. **Earn** — bước 36 `RD-E01`, bước 42 `RD-E07`
7. **DCA** — bước 43 `RD-C01`
8. **Predictions** — bước 46 `RD-R01`, bước 48 `RD-R03`
9. **Arena** — bước 49–53 (`RD-A01`, `A02`, `A05`)
10. **Launchpad** — bước 54–56
11. **Referral / Dev** — bước 60 `RD-M17-B01`, bước 66 `RD-M23-B01`

Sau **hết 26 batch**: module gates + final gate cuối EXECUTION-PLAYBOOK.
