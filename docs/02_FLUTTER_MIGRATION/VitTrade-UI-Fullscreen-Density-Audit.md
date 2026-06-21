# VitTrade UI Fullscreen Density Audit

Generated from `flutter_app/tool/ui_fullscreen_density_audit.dart`.

```text
total_routed_screens=414
P1_density_refactor=0
P1_fullscreen_tool_visual_qa=5
P2_visual_density_review=4
P3_followup_review=3
Pass_or_low_signal=402
```

## Priority Counts

| Priority | Count |
| --- | ---: |
| `P1_density_refactor` | 0 |
| `P1_fullscreen_tool_visual_qa` | 5 |
| `P2_visual_density_review` | 4 |
| `P3_followup_review` | 3 |
| `Pass_or_low_signal` | 402 |

## Flagged Routes

| Priority | Score | Feature | Page | Route | Reason | Page file |
| --- | ---: | --- | --- | --- | --- | --- |
| P2_visual_density_review | 19 | predictions | PredictionEventDetailPage | `'/markets/predictions/event/:eventId'` | body B; custom>27 by 14 | `flutter_app/lib/features/predictions/presentation/pages/prediction_event_detail_page.dart` |
| P1_fullscreen_tool_visual_qa | 14 | p2p | P2PChatPage | `'/p2p/chat/:orderId'` | body Tool; few dense sections/cards=0 | `flutter_app/lib/features/p2p/presentation/pages/p2p_chat_page.dart` |
| P2_visual_density_review | 14 | predictions | PredictionsSearchPage | `AppRoutePaths.marketsPredictionsSearch` | body B; custom>7 by 2; few dense sections/cards=2 | `flutter_app/lib/features/predictions/presentation/pages/predictions_search_page.dart` |
| P1_fullscreen_tool_visual_qa | 13 | trade | AdvancedChartPage | `'/trade/advanced-chart/:pairId'` | body Tool | `flutter_app/lib/features/trade/presentation/pages/advanced_chart_page.dart` |
| P1_fullscreen_tool_visual_qa | 13 | trade | FuturesPage | `'/trade/:pairId/futures'` | body Tool | `flutter_app/lib/features/trade/presentation/pages/futures_page.dart` |
| P1_fullscreen_tool_visual_qa | 13 | trade | TradingBotsPage | `AppRoutePaths.tradeBots` | body Tool | `flutter_app/lib/features/trade/presentation/pages/trading_bots_page.dart` |
| P1_fullscreen_tool_visual_qa | 12 | enterprise_states | EnterpriseStatesPage | `AppRoutePaths.enterpriseStates` | body Tool | `flutter_app/lib/features/enterprise_states/presentation/pages/enterprise_states_page.dart` |
| P2_visual_density_review | 12 | profile | ApiManagementPage | `AppRoutePaths.profileApi` | body B; few dense sections/cards=2 | `flutter_app/lib/features/profile/presentation/pages/api_management_page.dart` |
| P2_visual_density_review | 12 | profile | EditProfilePage | `AppRoutePaths.profileEdit` | body B; few dense sections/cards=2 | `flutter_app/lib/features/profile/presentation/pages/edit_profile_page.dart` |
| P3_followup_review | 8 | p2p | P2PWalletPage | `AppRoutePaths.p2pWallet` | few dense sections/cards=2 | `flutter_app/lib/features/p2p/presentation/pages/p2p_wallet_page.dart` |
| P3_followup_review | 8 | profile | DeviceManagementPage | `AppRoutePaths.profileDevices` | body B | `flutter_app/lib/features/profile/presentation/pages/device_management_page.dart` |
| P3_followup_review | 8 | trade | ConvertPage | `AppRoutePaths.tradeConvert` | body B | `flutter_app/lib/features/trade/presentation/pages/convert_page.dart` |
