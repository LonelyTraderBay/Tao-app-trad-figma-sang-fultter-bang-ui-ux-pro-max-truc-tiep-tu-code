import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

/// Page Rhythm Visual QA — phone viewport (360×800 logical px).
/// Mirrors [Page-Rhythm-Visual-QA-Checklist.md] flows 1–32.
void main() {
  const phone = Size(360, 800);

  for (final flostWidgets( 'phone QA ${flow.id}: ${flow.name} @ 360×800',
      ester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = phone;
      addTearDown(tester.view.resetDevicePixelRatio);
        addTearDown(tester.view.resetPhysicalSize);

      final errors = <FlutterErrorDetails>[];
      final previousOnError = FlutterError.onError;
        FlutterError.onError = errors.add;

        y {
          ait tester.pumpWidget(
            tTradeApp(
            routerConfig: createAppRouter(initialLocation: flow.route),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));
          ait tester.pumpAndSettle(
          const Duration(milliseconds: 50),
          EnginePhase.sendSemanticsUpdate,
          const Duration(seconds: 5),
          );

          nal semantics = find.byWidgetPredicate(
            (wget) =>
              widget is Semantics &&
              widget.properties.label == flow.semanticLabel,
        );
          pect(
          semantics,
          findsWidgets,
          reason: 'Expected ${flow.semanticLabel} on ${flow.route}',
          );

           (flow.expectBottomNav) {
          expect(find.byType(VitBottomNav), findsOneWidget);
          }

          pect(
          errors,
          isEmpty,
          reason: errors.map((e) => e.exceptionAsString()).join('\n'),
          );

        Object? exception = tester.takeException();
        expect(exception, isNull, reason: '$exception');
        finally {
        FlutterError.onError = previousOnError;
       },
    ) {
     {}
  }
  }
}

class _VisualQaFlow {
  const _VisualQaFlow({
    required this.id,
    required this.name,
    required this.route,
    required this.semanticLabel,
    this.expectBottomNav = false,
  });

  final int id;
  final String name;
  final String route;
  final String semanticLabel;
  final bool expectBottomNav;
}

const _pageRhythmVisualQaFlows = [
  _VisualQaFlow(
    id: 1,
    name: 'Home tab root (compact 8px)',
    route: AppRoutePaths.home,
    semanticLabel: 'SC-007 HomePage',
    expectBottomNav: true,
  ),
  _VisualQaFlow(
    id: 2,
    name: 'Wallet multi-manager (standard 13px)',
    route: AppRoutePaths.walletMultiManager,
    semanticLabel: 'SC-148 WalletMultiManagerPage',
  ),
  _VisualQaFlow(
    id: 3,
    name: 'Savings Guide (form 16px)',
    route: AppRoutePaths.earnSavingsGuide,
    semanticLabel: 'SC-335 SavingsGuidePage',
  ),
  _VisualQaFlow(
    id: 4,
    name: 'P2P Merchant Apply (form 16px)',
    route: AppRoutePaths.p2pMerchantApply,
    semanticLabel: 'SC-227 P2PMerchantApplyPage',
  ),
  _VisualQaFlow(
    id: 5,
    name: 'Arena home (compact 8px)',
    route: AppRoutePaths.arena,
    semanticLabel: 'SC-184 ArenaHomePage',
  ),
  _VisualQaFlow(
    id: 6,
    name: 'Settings scroll (standard 13px)',
    route: AppRoutePaths.profileSettings,
    semanticLabel: 'SC-160 SettingsPage',
  ),
  _VisualQaFlow(
    id: 7,
    name: 'Admin analytics (standard 13px)',
    route: AppRoutePaths.adminAnalytics,
    semanticLabel: 'SC-181 AnalyticsDashboard',
  ),
  _VisualQaFlow(
    id: 8,
    name: 'Copy Trading provider apply (form 16px)',
    route: AppRoutePaths.tradeCopyProviderApply,
    semanticLabel: 'SC-069 ProviderApplicationPage',
  ),
  _VisualQaFlow(
    id: 9,
    name: 'Cross-module portfolio (standard 13px)',
    route: AppRoutePaths.unifiedPortfolio,
    semanticLabel: 'SC-321 UnifiedPortfolioDashboard',
  ),
  _VisualQaFlow(
    id: 10,
    name: 'Markets depth (flush + form inner)',
    route: AppRoutePaths.marketsDepth,
    semanticLabel: 'SC-019 MarketDepthPage',
  ),
  _VisualQaFlow(
    id: 11,
    name: 'Home product grid (Tier B badges)',
    route: AppRoutePaths.home,
    semanticLabel: 'SC-007 HomePage',
    expectBottomNav: true,
  ),
  _VisualQaFlow(
    id: 12,
    name: 'Rewards task list (VitTaskCard Tier E)',
    route: AppRoutePaths.rewards,
    semanticLabel: 'SC-319 RewardsHubPage',
  ),
  _VisualQaFlow(
    id: 13,
    name: 'P2P home (compact ad rows)',
    route: AppRoutePaths.p2p,
    semanticLabel: 'SC-282 P2PHomePage',
  ),
  _VisualQaFlow(
    id: 14,
    name: 'DCA home (overview metrics)',
    route: AppRoutePaths.dca,
    semanticLabel: 'SC-169 DCAPage',
  ),
  _VisualQaFlow(
    id: 15,
    name: 'Trader profile (hero copiers row)',
    route: '/trade/trader/demo',
    semanticLabel: 'SC-087 TraderProfilePage',
  ),
  _VisualQaFlow(
    id: 16,
    name: 'Referral history (friend cards)',
    route: AppRoutePaths.referralHistory,
    semanticLabel: 'SC-286 ReferralHistoryPage',
  ),
  _VisualQaFlow(
    id: 17,
    name: 'Markets correlations (underline tabs)',
    route: AppRoutePaths.marketsCorrelations,
    semanticLabel: 'SC-026 MarketCorrelationsPage',
  ),
  _VisualQaFlow(
    id: 18,
    name: 'Savings analytics (chart header)',
    route: AppRoutePaths.earnSavingsAnalytics,
    semanticLabel: 'SC-343 SavingsAnalyticsPage',
  ),
  _VisualQaFlow(
    id: 19,
    name: 'Arena leaderboard (season filters)',
    route: AppRoutePaths.arenaLeaderboard,
    semanticLabel: 'SC-194 ArenaLeaderboardPage',
  ),
  _VisualQaFlow(
    id: 20,
    name: 'Wallet withdraw (form 16px sections)',
    route: AppRoutePaths.walletWithdraw,
    semanticLabel: 'SC-139 WithdrawPage',
  ),
  _VisualQaFlow(
    id: 21,
    name: 'Wallet deposit (form 16px sections)',
    route: AppRoutePaths.walletDeposit,
    semanticLabel: 'SC-137 DepositPage',
  ),
  _VisualQaFlow(
    id: 22,
    name: 'Wallet transfer (form 16px sections)',
    route: AppRoutePaths.walletTransfer,
    semanticLabel: 'SC-146 TransferPage',
  ),
  _VisualQaFlow(
    id: 23,
    name: 'Wallet buy crypto (form 16px sections)',
    route: AppRoutePaths.walletBuyCrypto,
    semanticLabel: 'SC-145 BuyCryptoPage',
  ),
  _VisualQaFlow(
    id: 24,
    name: 'Wallet address add (form 16px sections)',
    route: AppRoutePaths.walletAddressBookAdd,
    semanticLabel: 'SC-143 AddressAddPage',
  ),
  _VisualQaFlow(
    id: 25,
    name: 'Wallet dust converter (form 16px sections)',
    route: AppRoutePaths.walletDustConverter,
    semanticLabel: 'SC-154 DustConverterPage',
  ),
  _VisualQaFlow(
    id: 26,
    name: 'Wallet withdraw limits (form 16px sections)',
    route: AppRoutePaths.walletLimits,
    semanticLabel: 'SC-153 WithdrawLimitsPage',
  ),
  _VisualQaFlow(
    id: 27,
    name: 'Wallet token approval (form 16px sections)',
    route: AppRoutePaths.walletTokenApproval,
    semanticLabel: 'SC-150 WalletTokenApprovalPage',
  ),
  _VisualQaFlow(
    id: 28,
    name: 'Wallet tx history (standard 13px sections)',
    route: AppRoutePaths.walletHistory,
    semanticLabel: 'SC-136 TxHistoryPage',
  ),
  _VisualQaFlow(
    id: 29,
    name: 'Wallet asset detail (standard 13px sections)',
    route: '/wallet/asset/btc',
    semanticLabel: 'SC-147 AssetDetailPage',
  ),
  _VisualQaFlow(
    id: 30,
    name: 'Wallet address book (standard 13px sections)',
    route: AppRoutePaths.walletAddressBook,
    semanticLabel: 'SC-144 AddressBookPage',
  ),
  _VisualQaFlow(
    id: 31,
    name: 'Wallet portfolio analytics (standard 13px)',
    route: AppRoutePaths.walletPortfolioAnalytics,
    semanticLabel: 'SC-142 PortfolioAnalyticsPage',
  ),
  _VisualQaFlow(
    id: 32,
    name: 'Wallet network status (standard 13px sections)',
    route: AppRoutePaths.walletNetworkStatus,
    semanticLabel: 'SC-155 NetworkStatusPage',
  ),
  _VisualQaFlow(
    id: 33,
    name: 'Wallet tab root (compact 8px sections)',
    route: AppRoutePaths.wallet,
    semanticLabel: 'SC-135 WalletPage',
  ),
  _VisualQaFlow(
    id: 34,
    name: 'Wallet pending deposits (standard 13px sections)',
    route: AppRoutePaths.walletPendingDeposits,
    semanticLabel: 'SC-152 PendingDepositsPage',
  ),
  _VisualQaFlow(
    id: 35,
    name: 'Wallet gas optimizer (standard 13px sections)',
    route: AppRoutePaths.walletGasOptimizer,
    semanticLabel: 'SC-149 WalletGasOptimizerPage',
  ),
  _VisualQaFlow(
    id: 36,
    name: 'Wallet health score (standard 13px sections)',
    route: AppRoutePaths.walletHealthScore,
    semanticLabel: 'SC-151 WalletHealthScorePage',
  ),
  _VisualQaFlow(
    id: 37,
    name: 'Wallet portfolio analytics overview sections',
    route: AppRoutePaths.walletPortfolioAnalytics,
    semanticLabel: 'SC-142 PortfolioAnalyticsPage',
  ),
  _VisualQaFlow(
    id: 38,
    name: 'Wallet token approval tab sections (form 16px)',
    route: AppRoutePaths.walletTokenApproval,
    semanticLabel: 'SC-150 WalletTokenApprovalPage',
  ),
  _VisualQaFlow(
    id: 39,
    name: 'Wallet multi-manager tab sections (standard 13px)',
    route: AppRoutePaths.walletMultiManager,
    semanticLabel: 'SC-148 WalletMultiManagerPage',
  ),
  _VisualQaFlow(
    id: 40,
    name: 'Wallet transaction detail (standard 13px sections)',
    route: '/wallet/transaction/tx001',
    semanticLabel: 'SC-141 TransactionDetailPage',
  ),
];
