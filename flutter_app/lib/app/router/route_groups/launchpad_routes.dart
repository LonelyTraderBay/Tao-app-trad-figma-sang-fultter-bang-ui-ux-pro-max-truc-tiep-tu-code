import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/features/launchpad/presentation/pages/claim/launchpad_batch_claim_page.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/pages/tools/launchpad_abi_diff_page.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/pages/tools/launchpad_address_book_page.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/pages/bridge/launchpad_bridge_compare_page.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/pages/bridge/launchpad_bridge_order_page.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/pages/hub/launchpad_contract_page.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/pages/claim/launchpad_claim_receipt_page.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/pages/tools/launchpad_dca_builder_page.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/pages/hub/launchpad_detail_page.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/pages/tools/launchpad_event_log_page.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/pages/tools/launchpad_gas_tracker_page.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/pages/hub/launchpad_page.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/pages/bridge/launchpad_ido_bridge_page.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/pages/tools/launchpad_limit_orders_page.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/pages/tools/launchpad_multisig_page.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/pages/tools/launchpad_notif_sound_page.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/pages/hub/launchpad_performance_page.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/pages/hub/launchpad_portfolio_page.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/pages/tools/launchpad_rebalance_page.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/pages/hub/launchpad_receipt_page.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/pages/tools/launchpad_risk_analytics_page.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/pages/tools/launchpad_staking_page.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/pages/bridge/launchpad_swap_aggregator_page.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/pages/tools/launchpad_webhooks_page.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/router/route_groups/placeholder_routes.dart';

List<RouteBase> launchpadRoutes(ShellRenderMode shellRenderMode) {
  return [
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
      builder: (_, _) => LaunchpadStakingPage(shellRenderMode: shellRenderMode),
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
      builder: (_, _) => LaunchpadReceiptPage(shellRenderMode: shellRenderMode),
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
      builder: (_, _) => LaunchpadAbiDiffPage(shellRenderMode: shellRenderMode),
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
      builder: (_, _) => LaunchpadDetailPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.launchpadBridgeOrderTx001,
      name: AppRouteNames.sc303LaunchpadBridgeOrder,
      builder: (_, _) =>
          LaunchpadBridgeOrderPage(shellRenderMode: shellRenderMode),
    ),
    ...launchpadOutgoingPlaceholders,
  ];
}
