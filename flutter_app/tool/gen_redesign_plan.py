#!/usr/bin/env python3
"""Generate token-efficient redesign plan (slim MD + batches CSV)."""

from __future__ import annotations

import csv
import re
from collections import defaultdict
from datetime import date
from pathlib import Path

REPO = Path(__file__).resolve().parent.parent.parent
CSV_PATH = REPO / "docs/02_FLUTTER_MIGRATION/VitTrade-Screen-Redesign-Checklist.csv"
OUT_MD = REPO / "docs/02_FLUTTER_MIGRATION/ke-hoach-redesign-theo-module.md"
OUT_BATCHES = REPO / "docs/02_FLUTTER_MIGRATION/ke-hoach-redesign-batches.csv"

SKIP_REDESIGN_MODULES = {"home"}

HOME_REFERENCE = {
    "sc_id": "sc007Home",
    "route_path": "/home",
    "page_file": "lib/features/home/presentation/pages/home_page.dart",
    "doc": "../04_SCREEN_REFERENCES/home/HomePage-Flutter-Native-Standard.md",
}

MODULE_SEQUENCE = [
    ("RD-M01", "home", "SC-007 reference only", "sc007Home", "Global foundation"),
    ("RD-M02", "auth", "Trust, security", "sc001Login", "Trust, security, clarity"),
    ("RD-M03", "onboarding", "First-run", "sc397Onboarding", "Guided first-run"),
    ("RD-M04", "markets", "Bottom nav", "sc008MarketList", "Scan, compare, data"),
    ("RD-M05", "trade", "Bottom nav + bots", "sc048Trade", "Action, precision, risk"),
    ("RD-M06", "wallet", "Bottom nav", "sc135Wallet", "Assets, trust, security"),
    ("RD-M07", "profile", "Bottom nav", "sc156Profile", "Account, settings"),
    ("RD-M08", "p2p", "P2P fiat/crypto", "sc282P2PHome", "Escrow, compliance UX"),
    ("RD-M09", "earn", "Staking + Savings", "sc327StakingEarn", "Yield + risk transparency"),
    ("RD-M10", "dca", "DCA", "sc169Dca", "Disciplined investing"),
    ("RD-M11", "predictions", "Prediction Markets", "sc027PredictionsHome", "Probability, not casino"),
    ("RD-M12", "arena", "Open Arena", "sc184ArenaHome", "Points-only"),
    ("RD-M13", "launchpad", "Launchpad", "sc295Launchpad", "IDO participation"),
    ("RD-M14", "discovery", "Search", "sc283UnifiedSearch", "Discovery"),
    ("RD-M15", "news", "News", "sc047News", "Information"),
    ("RD-M16", "notifications", "Alerts", "sc291Notifications", "Actionable alerts"),
    ("RD-M17", "referral", "Referral", "sc290ReferralHome", "No hype"),
    ("RD-M18", "support", "Help", "sc292HelpCenter", "Help & trust"),
    ("RD-M19", "rewards", "Rewards", "sc319RewardsHub", "Rewards hub"),
    ("RD-M20", "cross_module", "Cross dashboards", "sc321UnifiedPortfolio", "Unified views"),
    ("RD-M21", "enterprise_states", "State demo", "sc320EnterpriseStates", "Enterprise states"),
    ("RD-M22", "admin", "Internal", "sc180AdminHome", "Ops dashboards"),
    ("RD-M23", "dev", "Dev/QA", "sc399DesignSystem", "Design system"),
]

CUSTOM_BATCHES: dict[str, list[tuple[str, str, list[str]]]] = {
    "trade": [
        ("RD-T01", "Hub giao dịch cốt lõi", ["sc048Trade", "sc049TradePair", "sc052TradeSettings", "sc053PositionDashboard", "sc054TradeHistoryExport", "sc055AdvancedChart", "sc056Convert", "sc057Futures", "sc058Leverage"]),
        ("RD-T02", "Hub Trading Bots SC-059", ["sc059TradingBots"]),
        ("RD-T03", "Bot vận hành & analytics", ["sc117BotTermsOfService", "sc118BotRiskDisclosure", "sc119BotSuitabilityAssessment", "sc120BotRiskDashboard", "sc121BotEmergencyStop", "sc122BotSecuritySettings", "sc123BotHistory", "sc124BotPerformanceAnalytics", "sc125BotBacktesting", "sc126BotStrategyCompare", "sc127BotOptimization", "sc128BotPortfolioDashboard", "sc129BotDrawdownAnalyzer", "sc130BotEquityCurve"]),
        ("RD-T04", "Bot guide & tax", ["sc131BotGuide", "sc132BotFaq", "sc133BotTaxReporting", "sc134BotApiDocumentation"]),
        ("RD-T05", "Copy trading hub", ["sc063CopyTrading", "sc064CopyTradingV2", "sc065CopyEducation", "sc066ActiveCopies", "sc067CopySettings", "sc068CopyNotifications", "sc079ProviderLeaderboard", "sc083CopySafetyCenter"]),
        ("RD-T06", "Copy provider & performance", ["sc069ProviderApplication", "sc070CopyProviderDetail", "sc071PreCopyAssessment", "sc072CopyConfiguration", "sc073CopyConfirmation", "sc074CopyPerformance", "sc075PerformanceAttribution", "sc076ProviderComparison", "sc077CopyAuditLog", "sc078PortfolioRiskAnalysis", "sc080SafetyEducation", "sc081ProviderGovernance", "sc082DisputeResolution", "sc084RegulatoryDisclosures", "sc412TradeCopyRegulatoryDisclosuresAlias"]),
        ("RD-T07", "Margin & trader", ["sc085MarginTrading", "sc086MarginTradingPair", "sc087TraderProfile", "sc088AdvancedTradingDemo", "sc090MarginTradingHub"]),
        ("RD-T08", "Tools & analytics", ["sc060RiskManagement", "sc061ExecutionQuality", "sc062AdvancedTools", "sc089MarketDataAnalytics", "sc091LiveMarketDataAnalytics", "sc092AdvancedAnalytics"]),
        ("RD-T09", "Compliance 1", ["sc093TransactionReporting", "sc094RegulatoryReportsDashboard", "sc095ArmIntegrationStatus", "sc096BestExecutionReports", "sc097ExecutionVenueAnalysis", "sc098SlippageMonitoring", "sc099ClientCategorization", "sc100ProductGovernance", "sc101TargetMarketDefinition", "sc102ClientMoneyProtection", "sc103CassReconciliation", "sc104InvestorCompensation"]),
        ("RD-T10", "Compliance 2 & complaints", ["sc105ExAnteCosts", "sc106RiyCalculator", "sc107ExPostCostsReport", "sc108KidGenerator", "sc109PerformanceScenarios", "sc110RiskIndicatorExplainer", "sc111ComplaintsHandling", "sc112ComplaintSubmission", "sc113ComplaintTracking", "sc114OmbudsmanReferral", "sc115AuditTrail", "sc116RegulatoryInspectionReady", "sc411ClientOptUpRequest", "sc415TargetMarketDefinitionDetail", "sc416ComplaintTrackingDetail"]),
        ("RD-T11", "Orders & receipts", ["sc050OrdersHistory", "sc051OrderReceipt"]),
    ],
    "p2p": [
        ("RD-P01", "Hub & navigation", ["sc282P2PHome", "sc274P2PDashboard", "sc273P2POrderBook", "sc281P2PMyOrders", "sc279P2PSettings", "sc280P2PGuide"]),
        ("RD-P02", "Express & orders", ["sc210P2PExpressConfirm", "sc211P2PExpress", "sc212P2POrderTimeline", "sc213P2POrderRate", "sc214P2POrderCancel", "sc215P2POrderProof", "sc216P2POrder", "sc217P2PChat"]),
        ("RD-P03", "Ads & merchant", ["sc223P2PAdAnalytics", "sc224P2PAdDetail", "sc225P2PMyAds", "sc226P2PCreateAd", "sc227P2PMerchantApply", "sc228P2PMerchantProfile", "sc229P2PReportMerchant", "sc230P2PTradingLevel", "sc231P2PReviews"]),
        ("RD-P04", "Payment methods", ["sc232P2PPaymentMethodAdd", "sc233P2PPaymentMethodVerification", "sc234P2PPaymentMethodOwnership", "sc235P2PPaymentMethodCoolingPeriod", "sc236P2PPaymentMethodHistory", "sc237P2PPaymentMethods"]),
        ("RD-P05", "Insurance & escrow", ["sc238P2PInsuranceFund", "sc239P2PInsuranceCertificate", "sc240P2PInsuranceScore", "sc241P2PInsurancePolicy", "sc242P2PContributionHistory", "sc243P2PClaimDetail", "sc244P2PInsuranceFundAlias", "sc245P2PEscrowBalance", "sc246P2PEscrowDetail"]),
        ("RD-P06", "KYC", ["sc247P2PKycRequirements", "sc248P2PKycStatus", "sc249P2PIdentityVerification", "sc250P2PAddressProof", "sc251P2PSelfieVerification", "sc252P2PVideoVerification", "sc402P2PKycVerify", "sc403P2PKycFaceMatch", "sc404P2PWhitelistMode"]),
        ("RD-P07", "Security", ["sc253P2PSecurityCenter", "sc254P2P2FASettings", "sc255P2PDeviceManagement", "sc256P2PAntiPhishingCode", "sc257P2PLoginHistory", "sc258P2PSuspiciousActivity", "sc259P2PE2EInfo", "sc260P2PFraudPrevention"]),
        ("RD-P08", "Wallet & limits", ["sc261P2PWalletTransfer", "sc262P2PFundLockHistory", "sc263P2PWalletHistoryAlias", "sc264P2PWallet", "sc265P2PLimitTracker", "sc266P2PTransactionLimits"]),
        ("RD-P09", "Compliance & tax", ["sc267P2PComplianceOverview", "sc268P2PAmlScreening", "sc269P2PSourceOfFunds", "sc270P2PLargeTransaction", "sc271P2PRiskAssessment", "sc272P2PTaxReporting", "sc407P2PTaxReportDetail"]),
        ("RD-P10", "Disputes", ["sc218P2PDisputeDetail", "sc219P2PDisputeEvidence", "sc220P2PDisputeResolution", "sc221P2PDispute", "sc222P2PDisputes"]),
        ("RD-P11", "Social & settings", ["sc275P2PAchievements", "sc276P2PBlacklistAdd", "sc277P2PBlacklist", "sc278P2PNotificationsSettings"]),
    ],
    "earn": [
        ("RD-E01", "Staking entry", ["sc327StakingEarn", "sc328StakingEarnStaking", "sc358StakingDashboard", "sc359StakingAnalytics", "sc360StakingHistory", "sc361StakingEarningsCalendar"]),
        ("RD-E02", "Staking ops", ["sc362StakingValidatorSelection", "sc363StakingAutoCompound", "sc364StakingLiquidStaking", "sc365StakingInsurance", "sc366StakingAdvancedOrders", "sc367StakingMultiChain", "sc368StakingInstitutional"]),
        ("RD-E03", "Staking legal/risk", ["sc353StakingTerms", "sc354StakingRiskDisclosure", "sc355StakingWithdrawalPolicy", "sc356StakingTaxGuide", "sc357StakingRiskAssessment", "sc376StakingSuitabilityAssessment", "sc381StakingRiskDashboard", "sc385StakingEmergencyActions", "sc386StakingContingencyPlan"]),
        ("RD-E04", "Staking compliance", ["sc373StakingRegulatoryFramework", "sc374StakingAuditReports", "sc375StakingCustody", "sc377StakingInsuranceFundTransparency", "sc378StakingTransactionReporting", "sc379StakingApiDocumentation", "sc380StakingProofOfReserves", "sc382StakingSlashingHistory", "sc383StakingValidatorHealthMonitor", "sc384StakingRiskScoreCalculator"]),
        ("RD-E05", "Staking community", ["sc369StakingGuide", "sc370StakingFAQ", "sc371StakingNotifications", "sc372StakingRecommendations", "sc387StakingSocialFeed", "sc388StakingCommunityGovernance", "sc389StakingProposals", "sc390StakingVotingDetail", "sc391StakingVoting", "sc392StakingForum", "sc393StakingWebhooks", "sc394StakingDataExport", "sc395StakingThirdPartyIntegrations", "sc396StakingDeveloperConsole"]),
        ("RD-E06", "Savings entry", ["sc329Savings", "sc330SavingsProductDetail", "sc331SavingsRedeem", "sc332SavingsReceipt", "sc333SavingsPortfolio", "sc334SavingsHistory"]),
        ("RD-E07", "Savings tools", ["sc335SavingsGuide", "sc336SavingsFAQ", "sc337SavingsNotifications", "sc338SavingsRecommendations", "sc339SavingsRiskAssessment", "sc340SavingsComparison", "sc341AutoCompoundSettings", "sc342SavingsGoal", "sc343SavingsAnalytics", "sc344SavingsAutoRebalance", "sc345SavingsNotificationPreferences", "sc346SavingsDca", "sc347SavingsSmartSuggestions", "sc348SavingsExport", "sc349SavingsBacktest", "sc350SavingsAutoPilot", "sc351SavingsLadder", "sc352SavingsWhatIf"]),
    ],
    "markets": [
        ("RD-K01", "Hub & overview", ["sc008MarketList", "sc009MarketOverview", "sc010MarketMovers", "sc011MarketSectors", "sc012Watchlist"]),
        ("RD-K02", "Discovery tools", ["sc013MarketHeatmap", "sc014PriceAlerts", "sc015MarketScreener", "sc016ComparisonTool", "sc017MarketCalendar", "sc018DerivativesOverview"]),
        ("RD-K03", "Depth & sentiment", ["sc019MarketDepth", "sc020SocialSentiment", "sc021PortfolioTracker", "sc022MarketNews", "sc023AdvancedCharts", "sc024TokenUnlocks", "sc025SocialSignals", "sc026MarketCorrelations"]),
        ("RD-K04", "Pair detail", ["sc044PairDetail", "sc045TokenInfo", "sc046PairDepth"]),
    ],
    "wallet": [
        ("RD-W01", "Hub & assets", ["sc135Wallet", "sc136TxHistory", "sc147AssetDetail", "sc142PortfolioAnalytics", "sc148MultiManager", "sc151HealthScore"]),
        ("RD-W02", "Deposit", ["sc137Deposit", "sc138DepositUsdt", "sc152PendingDeposits"]),
        ("RD-W03", "Withdraw", ["sc139Withdraw", "sc140WithdrawUsdt", "sc153WithdrawLimits", "sc143AddressAdd", "sc144AddressBook"]),
        ("RD-W04", "Transfer & buy", ["sc145BuyCrypto", "sc146Transfer", "sc154DustConverter", "sc155NetworkStatus", "sc149GasOptimizer", "sc150TokenApproval", "sc141TransactionDetail"]),
    ],
    "profile": [
        ("RD-F01", "Hub & settings", ["sc156Profile", "sc157EditProfile", "sc160Settings", "sc161ActivityLog", "sc164Vip", "sc166SubAccount", "sc168MyArena", "sc167ProfilePredictions"]),
        ("RD-F02", "Security & KYC", ["sc158Security", "sc159Kyc", "sc165DeviceManagement", "sc405SettingsSecurityBiometric", "sc406SettingsSecurityChangePassword", "sc413SettingsSecurity"]),
        ("RD-F03", "API keys", ["sc162ApiKeyCreate", "sc163ApiManagement"]),
    ],
    "arena": [
        ("RD-A01", "Hub & studio", ["sc184ArenaHome", "sc185ArenaStudio", "sc186ArenaSmartRules", "sc187ArenaPresetLibrary", "sc188ArenaGovernanceGate", "sc209ArenaGuide"]),
        ("RD-A02", "Challenge flow", ["sc189ArenaModeDetail", "sc190ArenaChallengeDetail", "sc191ArenaJoin", "sc192ArenaResolutionCenter", "sc193ArenaCreator", "sc194ArenaLeaderboard", "sc195VerifiedChallenges"]),
        ("RD-A03", "Points & ledger", ["sc196ArenaPoints", "sc200ArenaPointsEntryDetail", "sc201ArenaPointsLedger", "sc205MyArena", "sc204MyArenaReports"]),
        ("RD-A04", "Safety & trust", ["sc198ArenaSafetyCenter", "sc199ArenaTrustBreakdown", "sc202ArenaReportCase", "sc203ArenaBlockedUsers", "sc197ArenaFlowMap"]),
        ("RD-A05", "Production bridges", ["sc206ArenaProductionReady", "sc207ArenaPredictionBridgeFoundation", "sc208ConnectedEcosystemProduction"]),
    ],
    "launchpad": [
        ("RD-L01", "Hub & portfolio", ["sc295Launchpad", "sc296LaunchpadPortfolio", "sc297LaunchpadPerformance", "sc318LaunchpadDetail"]),
        ("RD-L02", "Participation", ["sc298LaunchpadStaking", "sc299LaunchpadIdoBridge", "sc300LaunchpadContract", "sc301LaunchpadReceipt", "sc302LaunchpadClaimReceipt", "sc303LaunchpadBridgeOrder", "sc304LaunchpadBatchClaim"]),
        ("RD-L03", "Advanced tools", ["sc305LaunchpadBridgeCompare", "sc306LaunchpadNotifSound", "sc307LaunchpadEventLog", "sc308LaunchpadAbiDiff", "sc309LaunchpadAddressBook", "sc310LaunchpadWebhooks", "sc311LaunchpadGasTracker", "sc312LaunchpadRebalance", "sc313LaunchpadMultisig", "sc314LaunchpadSwapAggregator", "sc315LaunchpadLimitOrders", "sc316LaunchpadDcaBuilder", "sc317LaunchpadRiskAnalytics"]),
    ],
    "predictions": [
        ("RD-R01", "Hub & discovery", ["sc027PredictionsHome", "sc028PredictionsSearch", "sc029PredictionsBreaking", "sc030PredictionEventDetail", "sc039PredictionEventCalendar"]),
        ("RD-R02", "Portfolio & social", ["sc031PredictionsPortfolio", "sc032PredictionsRewards", "sc033PredictionsLeaderboard", "sc034PredictionsGlobalActivity", "sc040PredictionSocial", "sc042PredictionTournaments", "sc414PredictionTournamentDetail"]),
        ("RD-R03", "Tools", ["sc035PredictionOrderReceipt", "sc036PredictionRiskCalculator", "sc037PredictionMarketMaker", "sc038PredictionPortfolioAnalyzer", "sc041PredictionAdvancedChart", "sc043PredictionDataIntegration"]),
    ],
    "dca": [
        ("RD-C01", "Hub & schedule", ["sc169Dca", "sc172DcaScheduleConfig", "sc173DcaScheduleAnalytics", "sc175DcaDynamicAmount", "sc179DcaSmartRules"]),
        ("RD-C02", "Rebalance", ["sc170DcaRebalanceConfig", "sc171DcaRebalanceDashboard", "sc408DcaRebalanceEdit", "sc409DcaRebalanceHistory"]),
        ("RD-C03", "Optimizer", ["sc174DcaPortfolioOptimizer", "sc176DcaBacktester", "sc177DcaMultiAsset", "sc178DcaPerformanceCompare"]),
    ],
}

SPECIAL_PROMPTS = {
    "sc059TradingBots": "prompt-redesign-trading-bots-hub-sc059.md",
}


def sc_sort_key(sc_id: str) -> int:
    m = re.match(r"sc(\d+)", sc_id)
    return int(m.group(1)) if m else 9999


def default_batches(
    module_id: str, module: str, rows: list[dict[str, str]]
) -> list[tuple[str, str, list[str]]]:
    if len(rows) <= 6:
        return [(f"{module_id}-B01", f"{module} — all", [r["sc_id"] for r in rows])]
    mid = (len(rows) + 1) // 2
    return [
        (f"{module_id}-B01", f"{module} — batch 1", [r["sc_id"] for r in rows[:mid]]),
        (f"{module_id}-B02", f"{module} — batch 2", [r["sc_id"] for r in rows[mid:]]),
    ]


def special_prompt_for(sc_ids: list[str]) -> str:
    for sc in sc_ids:
        if sc in SPECIAL_PROMPTS:
            return SPECIAL_PROMPTS[sc]
    return ""


def collect_batch_rows(
    by_mod: dict[str, list[dict[str, str]]],
    by_sc: dict[str, dict[str, str]],
) -> list[dict[str, str]]:
    rows: list[dict[str, str]] = []
    order = 0
    for mod_id, module, _desc, hub_sc, accent in MODULE_SEQUENCE:
        if module in SKIP_REDESIGN_MODULES:
            continue
        mod_rows = sorted(by_mod.get(module, []), key=lambda x: sc_sort_key(x["sc_id"]))
        batches = CUSTOM_BATCHES.get(module) or default_batches(mod_id, module, mod_rows)
        for batch_id, title, sc_ids in batches:
            order += 1
            pages = []
            for sc in sc_ids:
                pf = by_sc.get(sc, {}).get("page_file", "-")
                if pf != "-":
                    pages.append(pf)
            rows.append(
                {
                    "order": str(order),
                    "batch_id": batch_id,
                    "module_id": mod_id,
                    "module": module,
                    "hub_sc": hub_sc,
                    "accent": accent,
                    "batch_title": title,
                    "sc_count": str(len(sc_ids)),
                    "sc_ids": ";".join(sc_ids),
                    "page_files": ";".join(pages),
                    "special_prompt": special_prompt_for(sc_ids),
                    "status": "pending",
                }
            )
    return rows


def render_slim_markdown(
    batch_rows: list[dict[str, str]],
    redesign_screen_count: int,
    today: str,
) -> str:
    lines = [
        "# Kế hoạch Redesign UI theo Module — VitTrade (token-lite)",
        "",
        f"**Version:** 2.1 | **Updated:** {today}",
        "",
        "> **Mục tiêu file này:** ~200 dòng — đủ cho AI biết module/batch. Chi tiết màn hình **không** nhúng ở đây.",
        "",
        "| Artifact | Khi nào load |",
        "| --- | --- |",
        "| **File này** (sections 1–4) | Mỗi chat redesign — **1 lần** |",
        "| [ke-hoach-redesign-batches.csv](ke-hoach-redesign-batches.csv) | **1 dòng** = batch đang làm |",
        "| [VitTrade-Screen-Redesign-Checklist.csv](VitTrade-Screen-Redesign-Checklist.csv) | Lọc theo `sc_id` của batch — **không** load cả file vào chat |",
        "| [AI_PROMPT_SHELL.md](../01_AI_RULES/AI_PROMPT_SHELL.md) | Workspace rule — không paste lại |",
        "| [DESIGN.md](../../DESIGN.md) | Workspace rule — không paste lại |",
        "| Headroom MCP (`headroom_compress` / `headroom_retrieve`) | **STEP 4** — log test/analyze/audit >500 dòng |",
        "",
        "**Không load vào chat redesign:**",
        "",
        "- `VitTrade-Screen-Redesign-Checklist.md` (551 dòng — trùng CSV)",
        "- Phiên bản plan cũ section 6 (1950+ dòng)",
        "- `ke-hoach-redesign-batches.csv` toàn bộ — chỉ 1 row",
        "- Full `home_page.dart` — đọc section hero/layout qua GitNexus `context()`",
        "",
        "---",
        "",
        "## 1. Quy tắc token (Cursor AI)",
        "",
        "1. User chỉ định **`batch_id`** (vd. `RD-M02-B01`, `RD-T02`).",
        "2. Load **section 1–4** file này + **1 row** `ke-hoach-redesign-batches.csv`.",
        "3. Resolve path: lọc checklist CSV theo `sc_ids` (split `;`) — tối đa ~10 dòng/batch.",
        "4. Nếu `special_prompt` có giá trị → load **chỉ file đó** (vd. SC-059).",
        "5. Mirror **SC-007 Home** — **không sửa** `home_page.dart`.",
        "6. **Chat mới** sau mỗi batch. Max **5–10 file** code/batch.",
        "7. Verify (STEP 4): gate theo `AI_PROMPT_SHELL.md` — không lặp lại checklist verify trong chat.",
        "",
        "### STEP 4 — Headroom (log tool dài)",
        "",
        "Áp dụng **sau implementation**, khi chạy `flutter test`, `flutter analyze`, hoặc `dart run tool/*_audit.dart`:",
        "",
        "| Khi | Làm |",
        "| --- | --- |",
        "| Output **≤500 dòng** | Đọc trực tiếp; fix lỗi |",
        "| Output **>500 dòng** | MCP `headroom_compress` → đọc summary |",
        "| Cần dòng lỗi / số dòng cụ thể | `headroom_retrieve` (hash + query) |",
        "",
        "**Điều kiện:** MCP `headroom` Connected — `scripts/headroom/Start-VitTradeHeadroom.ps1` (xem [scripts/headroom/README.md](../../scripts/headroom/README.md)).",
        "",
        "**Không dùng Headroom cho:** plan/CSV/checklist tĩnh; file `.dart` đang sửa trong batch (rule workspace).",
        "",
        "**Không thay GitNexus:** `impact()` / `context()` trước edit; Headroom chỉ cho output lệnh verify.",
        "",
        "**Thứ tự redesign:** `RD-M02` → `RD-M23`. **`RD-M01` = reference only.**",
        "",
        "**Lấy row batch (PowerShell):**",
        "",
        "```powershell",
        "Import-Csv docs/02_FLUTTER_MIGRATION/ke-hoach-redesign-batches.csv |",
        "  Where-Object batch_id -eq 'RD-M02-B01'",
        "```",
        "",
        "---",
        "",
        "## 2. Home reference — RD-M01 (skip redesign)",
        "",
        f"| sc | route | page | doc |",
        f"| --- | --- | --- | --- |",
        f"| `{HOME_REFERENCE['sc_id']}` | `{HOME_REFERENCE['route_path']}` | `{HOME_REFERENCE['page_file']}` | [Home standard]({HOME_REFERENCE['doc']}) |",
        "",
        "Mirror: hero → CTA → sections; `AppSpacing`/`AppRadii`/`AppTextStyles`; empty + CTA.",
        "",
        "---",
        "",
        "## 3. Charter (tóm tắt — chi tiết ở AGENTS/DESIGN/shell)",
        "",
        "**North Star:** Tin cậy trước · đơn giản trước · chuyên nghiệp luôn.",
        "",
        "**Vit* bắt buộc:** `VitPageLayout`, `VitCard`, `VitHeader`, `VitTabBar`, `VitSegmentedChoice`, `VitCtaButton`, `VitStatusPill`.",
        "",
        "**Cấm:** card-in-card · tab trong `VitCard` border · local duplicate Vit* · magic radius · hype/casino · sửa Home.",
        "",
        "**Product:** Arena = points only · Predictions ≠ casino · financial = preview/confirm · giữ `sc*` test keys.",
        "",
        "**Gate batch:** clutter after ≤4/10 · analyze clean · focused tests pass · ≤3 section above fold (hub).",
        "",
        "**STEP 0→5:** explore → audit → spec → code → verify → self-check (`vittrade-minimal-review`).",
        "",
        "---",
        "",
        "## 4. Module & batch index",
        "",
        "### 4.1 Module progress (22 redesign + 1 reference)",
        "",
        "| module_id | module | hub_sc | màn | accent | status |",
        "| --- | --- | --- | ---: | --- | --- |",
    ]

    mod_id_to_batches: dict[str, list[str]] = defaultdict(list)
    for br in batch_rows:
        mod_id_to_batches[br["module_id"]].append(br["batch_id"])

    for mod_id, module, _desc, hub_sc, accent in MODULE_SEQUENCE:
        if module in SKIP_REDESIGN_MODULES:
            lines.append(
                f"| `{mod_id}` | **{module}** | `{hub_sc}` | 1 | {accent} | 🔒 reference |"
            )
        else:
            n_screens = sum(
                int(b["sc_count"]) for b in batch_rows if b["module_id"] == mod_id
            )
            batch_ids = ", ".join(f"`{x}`" for x in mod_id_to_batches[mod_id])
            lines.append(
                f"| `{mod_id}` | **{module}** | `{hub_sc}` | {n_screens} | {accent} | ⬜ ({batch_ids}) |"
            )

    lines.extend(
        [
            "",
            f"Inventory **416** · redesign scope **{redesign_screen_count}** · batches **{len(batch_rows)}**.",
            "",
            "### 4.2 Batch table (chi tiết sc_id → `ke-hoach-redesign-batches.csv`)",
            "",
            "| batch_id | module_id | title | sc# | special_prompt | status |",
            "| --- | --- | --- | ---: | --- | --- |",
        ]
    )

    for br in batch_rows:
        sp = br["special_prompt"] or "-"
        lines.append(
            f"| `{br['batch_id']}` | `{br['module_id']}` | {br['batch_title']} | "
            f"{br['sc_count']} | {sp} | ⬜ |"
        )

    lines.extend(
        [
            "",
            "---",
            "",
            "## 5. Prompt mẫu (1 template — thay placeholder)",
            "",
            "```text",
            "Batch: <batch_id>  Module: <module_id>",
            "",
            "Load:",
            "- docs/01_AI_RULES/AI_PROMPT_SHELL.md (rule)",
            "- docs/02_FLUTTER_MIGRATION/ke-hoach-redesign-theo-module.md §1-4",
            "- ke-hoach-redesign-batches.csv row <batch_id>",
            "- VitTrade-Screen-Redesign-Checklist.csv rows matching sc_ids (batch only)",
            "- <special_prompt file if any>",
            "",
            "Mirror SC-007 Home (read-only). Không sửa home_page.dart.",
            "STEP 0→5. Max 5-10 files. New chat next batch.",
            "",
            "Completion: MODULE UI REDESIGN DONE — <module_id> — <batch_id>",
            "```",
            "",
            "**SC-059:** batch `RD-T02` → load `prompt-redesign-trading-bots-hub-sc059.md`.",
            "Completion: `TRADING BOTS HUB UI REDESIGN DONE — SC-059 v2`.",
            "",
            "---",
            "",
            "## Regenerate",
            "",
            "```bash",
            "python flutter_app/tool/gen_redesign_plan.py",
            "python flutter_app/tool/export_screen_checklist.py",
            "```",
            "",
        ]
    )

    return "\n".join(lines)


def main() -> None:
    screen_rows = list(csv.DictReader(CSV_PATH.open(encoding="utf-8-sig")))
    by_mod: dict[str, list[dict[str, str]]] = defaultdict(list)
    by_sc = {r["sc_id"]: r for r in screen_rows}
    for r in screen_rows:
        by_mod[r["module"]].append(r)

    batch_rows = collect_batch_rows(by_mod, by_sc)
    unique_redesign_screens = len({sc for r in batch_rows for sc in r["sc_ids"].split(";")})
    today = date.today().isoformat()

    OUT_BATCHES.parent.mkdir(parents=True, exist_ok=True)
    batch_fields = [
        "order",
        "batch_id",
        "module_id",
        "module",
        "hub_sc",
        "accent",
        "batch_title",
        "sc_count",
        "sc_ids",
        "page_files",
        "special_prompt",
        "status",
    ]
    with OUT_BATCHES.open("w", newline="", encoding="utf-8-sig") as handle:
        writer = csv.DictWriter(handle, fieldnames=batch_fields)
        writer.writeheader()
        writer.writerows(batch_rows)

    md = render_slim_markdown(batch_rows, unique_redesign_screens, today)
    OUT_MD.write_text(md, encoding="utf-8")

    print(f"Wrote {OUT_MD} ({len(md.splitlines())} lines)")
    print(f"Wrote {OUT_BATCHES} ({len(batch_rows)} batches)")


if __name__ == "__main__":
    main()
