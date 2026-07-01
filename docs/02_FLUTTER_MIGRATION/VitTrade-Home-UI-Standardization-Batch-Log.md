# VitTrade Home UI Standardization Batch Log

Residual-pass tracking for
[`VitTrade-Home-UI-Project-Wide-Standardization-Deep-Plan.md`](VitTrade-Home-UI-Project-Wide-Standardization-Deep-Plan.md).

**Sync:** every row here must match Deep Plan §4.0, §4.3.1, §11, §12.2, §12.4
(see Deep Plan §2.2).

## Phase 0 Baseline

| Metric | Value | Date |
| --- | ---: | --- |
| total_debt | 374 → **0** | 2026-07-01 |
| p0_p2p_debt | 173 → 0 | 2026-07-01 |
| p0_trade_debt | 2 → 0 | 2026-07-01 |
| p0_markets_debt | 6 → 0 | 2026-07-01 |
| scope_shared_widget_debt | 1 → 0 | 2026-07-01 |
| Phase 0–7 status | **Done** | 2026-07-01 |

## Batch Log

| Date | Batch | Module | Screens | Home pattern applied | L3 local reason | GitNexus evidence | First viewport evidence | Tests/audit evidence | Status | Notes |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 2026-07-01 | P2P-HOME-01 | p2p | payment-method pages (6) | L3 high-risk form / list + delete confirm | None | Blocked (MCP unavailable) | Preserved shell + first action row | analyze pass; p2p tests pass; copy guardrails pass; bundles pass | Done | Moved local EdgeInsets → AppSpacing.p2pPayment*; p0_p2p 173→149 |
| 2026-07-01 | P2P-HOME-02 | p2p | escrow/orders (8) | Escrow detail, balance, orders, order flow | order_book + order_page part_03: orderbook/custompainter L3 | Blocked (MCP unavailable) | Preserved payment/escrow preview surfaces | analyze pass; p2p tests pass; bundles pass/exception | Done | AppSpacing.p2pEscrow*/p2pMyOrders*/p2pOrderBook*/p2pOrder*; p0_p2p 149→119 |
| 2026-07-01 | P2P-HOME-03 | p2p | KYC/verification (5) | KYC capture + status surfaces | None | Blocked (MCP unavailable) | Preserved shell + first action row | analyze pass; p2p tests pass; bundles pass | Done | AppSpacing.p2pSelfie*/p2pKyc*/p2pVideo*/p2pAddressProof*; p0_p2p 119→97 |
| 2026-07-01 | P2P-HOME-04 | p2p | risk/compliance (9) | Risk limits + compliance surfaces | None | Blocked (MCP unavailable) | Preserved high-risk preview panels | analyze pass; p2p tests pass; bundles pass | Done | AppSpacing.p2pFraud*/p2pRiskAssessment*/p2pLimitTracker* etc.; p0_p2p 97→72 |
| 2026-07-01 | P2P-HOME-05 | p2p | merchant/ads (5) | Merchant profile + ad create/list/detail | None | Blocked (MCP unavailable) | Preserved ad publish + certificate surfaces | analyze pass; p2p tests pass; bundles pass | Done | AppSpacing.p2pMerchantCommerce*/p2pAdDetailFlush*/p2pInsuranceCertificate*; p0_p2p 72→45 |
| 2026-07-01 | P2P-HOME-06 | p2p | account/security (11) | Settings, 2FA, devices, blacklist, notifications, tax, login history, achievements, fund/contribution history | None | Blocked (MCP unavailable) | Preserved security preview + blacklist confirm surfaces | analyze pass; p2p tests pass; copy guardrails pass; bundles pass | Done | AppSpacing.p2pSettingsPage*/p2pTwoFactor*/p2pDevices*/p2pBlacklistList*/p2pNotifications*/p2pTax*/p2pLoginHistoryPage*/p2pAchievementsPage*/p2pFundLock*/p2pContribution*; p0_p2p 45→19 |
| 2026-07-01 | P2P-HOME-07 | p2p | dispute/express/misc (9) | Dispute resolution/detail/evidence, express, wallet transfer, home, dashboard, insurance fund | dashboard + insurance_fund: custompainter L3 | Blocked (MCP unavailable) | Preserved dispute/transfer preview surfaces | analyze pass; p2p tests pass; copy guardrails pass; bundles pass/exception | Done | AppSpacing.p2pDispute*/p2pExpress*/p2pWalletTransfer*/p2pHomeClearFilter*/p2pDashboardPage*/p2pInsuranceFundTourSkip*; p0_p2p 19→0 |
| 2026-07-01 | EARN-TRADE-01 | earn, trade | staking_earn_page, kid_generator_page, trade_page | L2 earn positions + L3 regulatory/orderbook | trade_page: orderbook L3 | Blocked (MCP unavailable) | Preserved APY/lockup copy + order workspace | earn+trade tests pass; analyze pass; total_debt 35→7 | Done | AppSpacing.stakingEarnPosition*; kidGenerator*; trade BoxDecoration→ColoredBox |
| 2026-07-01 | DEEP-MARKETS-SHARED-01 | markets, shared | market_list_* (4), vit_choice_pill | L3 market data rows + shared pill | None | Blocked (MCP unavailable) | Pair rows + filters unchanged | markets+shared tests pass; total_debt 7→0 | Done | AppSpacing.marketList*; vitChoicePill* |
| 2026-07-01 | DEEP-DENSITY-WALLET-01 | wallet, earn | 5 P2 medium-density screens | Review-only (Wallet reference) | bottom_nav_inset structural | N/A | Widget tests confirm first actionable rows | wallet+earn tests pass; density audit current | Done | No spacing churn; financial safety preserved |
| 2026-07-01 | DEEP-TOOL-QA-01 | trade, p2p, enterprise_states | FuturesPage, TradingBotsPage, AdvancedChartPage, EnterpriseStatesPage, P2PChatPage | L3_fullscreenTool | Tool exception per taxonomy | N/A | Widget tests + UI-05 layout at 360dp | trade+p2p+enterprise_states tests pass | Done | P1_TOOL=5 documented; no code edits required |
| 2026-07-01 | Phase 5 | all | P3 ledger (166 rows) | monitor_when_touched triage | N/A | N/A | P2-A candidates documented in §Phase 5 | No bulk P3 edits | Done | Systemic fixes deferred until touched |
| 2026-07-01 | DEEP-COPY-01 | all | copy boundaries | Product safety copy | N/A | N/A | Arena points-only preserved | copy + a11y guardrails pass | Done | — |
| 2026-07-01 | Phase 7 | all | global closure | Full audit + test gate | N/A | CLI detect_changes recorded | All P0 gates pass | full flutter test pass; all audit --check pass | Done | Residual pass complete |

## Segmented UI Sync inventory (2026-07-01)

| Type | Count | Action |
| --- | ---: | --- |
| A — VitCard wraps VitTabBar segment | 21 | Remove wrapper → VitSegmentedTabBar |
| B — VitCard + Row + VitChoicePill toggle | 8 | → VitSegmentedChoice |
| C — Material/DecoratedBox shell | 5 | Strip shell / VitSegmentedTabBar |
| Fixed prior | 5 | P2P MUA/BÁN, Trade side, DCA tabs |

Baseline before SEG-UI sync: design_token `--check` pass; vit_shared_widgets_test pass.

| 2026-07-01 | SEG-UI-SYNC | shared, trade, p2p, earn, launchpad, cross_module | VitSegmentedTabBar + VitSegmentedChoice rollout | ~40 segment anti-patterns | N/A | Shared foundation + bulk migrate | All Phase 3 gates | shared + module tests pass | Done | VitTabBar segment ghost border; factories; AGENTS contract |
| 2026-07-01 | TRADE-UI-01 | trade | TradePage, FuturesPage, ConvertPage, OrdersHistoryPage | L1 instrument workspace + Home section rhythm | orderbook/chart CustomPainter L3 | Blocked (MCP unavailable) | Hero + hub grid + first-viewport buy side | trade_page/futures/convert tests pass; 443+ trade tests | Done | VitTradeInstrumentHero, VitTradeProductHub, VitOrderBookPanel, VitTradesTapePanel, VitTradeOrderList, VitTradeChartPanel |
| 2026-07-01 | TRADE-UI-02 | trade | TradingBotsPage + bot sub-flows | L3 tool + VitTradeSection | Tool exception | Blocked (MCP unavailable) | Bot hub grid + strategy sections | trading_bots tests pass | Done | VitActionTileGrid strategy row; VitInsetScrollView |
| 2026-07-01 | TRADE-UI-03 | trade | CopyTrading hubs (copy_trading, v2, active_copies) | L2 detail + dense provider lists | None | Blocked (MCP unavailable) | Provider list clip+dividers | copy trading tests pass | Done | VitCard clip list pattern |
| 2026-07-01 | TRADE-UI-04 | trade | Margin hub, advanced/market analytics, position dashboard | L2 financial hero + sections | None | Blocked (MCP unavailable) | Hero metrics visible | margin/analytics tests pass | Done | VitTradeInstrumentHero on market analytics |
| 2026-07-01 | TRADE-UI-05 | trade | trade_module_layout + shared widgets test | Foundation primitives | None | N/A | trade_shared_widgets_test | full trade module tests pass | Done | VitTradeSection, VitTradeDetailScaffold, VitTradeWorkspaceScaffold |
| 2026-07-01 | TRADE-HOME-01 | trade | trade_module_layout foundation | tradeScrollBottomInset helpers + tradePageContentGap | None | Blocked (MCP unavailable) | trade_module_layout_test 360dp | analyze pass; trade_home_ui_sync.dart | Done | Home formula: buttonStandard + x5/x7 + safeArea |
| 2026-07-01 | TRADE-HOME-02 | trade | L1 terminals (Trade, Futures, Margin, Convert) | VitTradeTerminalLayout + tradeTerminalScrollBottomInset | orderbook/chart L3 | Blocked (MCP unavailable) | SC-048/049/320 first-viewport | trade/futures/margin/convert tests pass | Done | Home bottom inset formula; order-type VitIconButton |
| 2026-07-01 | TRADE-HOME-03 | trade | L2 hubs (Copy, Bots, Orders, Positions, Settings) | VitTradeHubScaffold + tradeScrollBottomInset | TradingBots L3 tool chrome only | Blocked (MCP unavailable) | Hub grids + list clip at 360dp | copy/bots/orders tests pass | Done | VitHeader + VitAutoHideHeaderScaffold on bots hub |
| 2026-07-01 | TRADE-HOME-04 | trade | Bot subtree (~18 routes) | VitTradeSection + scroll inset tokens | Bot strategy painters L3 | Blocked (MCP unavailable) | Bot sub-flow first action row | bot subtree tests pass | Done | trade_home_ui_sync codemod + VitTradeSection rhythm |
| 2026-07-01 | TRADE-HOME-05 | trade | Copy provider + regulatory (~40 routes) | copyTradingScrollBottomInset + dense lists | None | Blocked (MCP unavailable) | MiFID/copy scroll clearance | copy/regulatory tests pass | Done | Replaced local _*ScrollClearance constants |
| 2026-07-01 | TRADE-HOME-06 | trade | Margin analytics + demo tools + residual | tradeScrollBottomInset on analytics/demo | AdvancedChart L3 QA only | Blocked (MCP unavailable) | Margin hub + live analytics viewport | margin/analytics/demo tests pass | Done | Audits regenerated; trade_module_layout_test 360dp baseline |
| 2026-07-01 | PRED-PORTFOLIO-HOME-01 | predictions | PredictionsPortfolioPage, PredictionPortfolioAnalyzerPage | Hero VitCard+VitHeroGlow, VitTabBar segment, VitAnnouncementBanner, grouped VitCard lists, VitDiscoveryActionCard bridge, VitCardStat/VitMetricDeltaPill/VitAccentPill | Analyzer chart painters L3 | Blocked (MCP unavailable) | SC-031/SC-038 first-viewport keys preserved | 14 focused tests pass; analyze pass; design_token --check pass | Done | Deleted prediction_portfolio_tabs.dart; deprecated legacy predictionPortfolio* spacing tokens |
