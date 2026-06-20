# VitTrade UI Fullscreen Density Audit

Generated from `flutter_app/tool/ui_fullscreen_density_audit.dart`.

```text
total_routed_screens=414
P1_density_refactor=0
P1_fullscreen_tool_visual_qa=5
P2_visual_density_review=0
P3_followup_review=0
Pass_or_low_signal=409
```

## Priority Counts

| Priority | Count |
| --- | ---: |
| `P1_density_refactor` | 0 |
| `P1_fullscreen_tool_visual_qa` | 5 |
| `P2_visual_density_review` | 0 |
| `P3_followup_review` | 0 |
| `Pass_or_low_signal` | 409 |

## Flagged Routes

| Priority | Score | Feature | Page | Route | Reason | Page file |
| --- | ---: | --- | --- | --- | --- | --- |
| P1_fullscreen_tool_visual_qa | 14 | p2p | P2PChatPage | `'/p2p/chat/:orderId'` | body Tool; few dense sections/cards=0 | `flutter_app/lib/features/p2p/presentation/pages/p2p_chat_page.dart` |
| P1_fullscreen_tool_visual_qa | 13 | trade | AdvancedChartPage | `'/trade/advanced-chart/:pairId'` | body Tool | `flutter_app/lib/features/trade/presentation/pages/advanced_chart_page.dart` |
| P1_fullscreen_tool_visual_qa | 13 | trade | FuturesPage | `'/trade/:pairId/futures'` | body Tool | `flutter_app/lib/features/trade/presentation/pages/futures_page.dart` |
| P1_fullscreen_tool_visual_qa | 13 | trade | TradingBotsPage | `AppRoutePaths.tradeBots` | body Tool | `flutter_app/lib/features/trade/presentation/pages/trading_bots_page.dart` |
| P1_fullscreen_tool_visual_qa | 12 | enterprise_states | EnterpriseStatesPage | `AppRoutePaths.enterpriseStates` | body Tool | `flutter_app/lib/features/enterprise_states/presentation/pages/enterprise_states_page.dart` |
