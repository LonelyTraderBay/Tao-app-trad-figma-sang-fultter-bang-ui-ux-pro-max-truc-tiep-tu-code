import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/discovery/presentation/pages/unified_search_page.dart';
import 'package:vit_trade_flutter/features/home/data/home_mock_data.dart';
import 'package:vit_trade_flutter/app/providers/home_controller_providers.dart';
import 'package:vit_trade_flutter/features/home/data/providers/home_repository_provider.dart';
import 'package:vit_trade_flutter/features/home/data/repositories/mock_home_repository.dart';
import 'package:vit_trade_flutter/features/home/domain/entities/home_entities.dart';
import 'package:vit_trade_flutter/features/home/domain/repositories/home_repository.dart';
import 'package:vit_trade_flutter/features/home/presentation/pages/home_page.dart';
import 'package:vit_trade_flutter/features/markets/presentation/pages/pair_detail_page.dart';
import 'package:vit_trade_flutter/features/notifications/presentation/pages/notifications_page.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/pages/withdraw_page.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/pages/wallet_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_sparkline.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_skeleton.dart';

void main() {
  test('SC-007 Home keeps the shared component foundation contract', () {
    final source = [
      for (final entity in Directory(
        'lib/features/home/presentation/pages',
      ).listSync().whereType<File>())
        entity.readAsStringSync(),
      for (final entity in Directory(
        'lib/features/home/presentation/widgets',
      ).listSync().whereType<File>())
        entity.readAsStringSync(),
    ].join('\n');

    // VitAutoHidePageScaffold composes VitAutoHideHeaderScaffold internally
    // for bottom-nav root pages (Home, Wallet, Profile) — either identifier
    // proves Home inherits the shared auto-hide header behaviour.
    expect(
      source.contains('VitAutoHideHeaderScaffold') ||
          source.contains('VitAutoHidePageScaffold'),
      isTrue,
    );
    expect(source, contains('VitSectionHeader'));
    expect(source, contains('VitActionTileGrid'));
    expect(source, contains('VitMarketPairRow'));
    expect(source, contains('VitAnnouncementBanner'));
    expect(source, contains('VitMarketTickerStrip'));
    expect(source, contains('VitMetricDeltaPill'));
    expect(source, contains('VitSparkline'));
    expect(source, contains('VitNextActionCard'));
    expect(source, contains('VitDiscoveryActionCard'));
    expect(source, contains('VitSheetPanel'));
    expect(source, contains('VitHeroGlow'));
    expect(source, contains('VitInsetScrollView'));
    expect(source, contains('HomeDensityVariant'));
    expect(source, contains('_homeDiscoveryQuickActionRoutes'));
    expect(source, contains('RefreshIndicator'));
    expect(source, contains('VitSkeleton'));
    expect(source, contains('VitErrorState'));

    for (final localPattern in const [
      'class _SectionHeader',
      'class _CommandChip',
      'class _CoinAvatar',
      'class _SparklinePainter',
      'class _Dot',
      'class _PortfolioGlow',
      'class _DiscoveryCard',
      'class _NextActionCard',
      'GridView.builder',
      'Container(',
      'BoxDecoration(',
      'BorderRadius.circular(',
      'Radius.circular(',
      'EdgeInsets.all(',
      'EdgeInsets.symmetric(',
      'EdgeInsets.only(',
      'EdgeInsets.fromLTRB(',
      '🔥',
      '📈',
      '📉',
      '🆕',
      'ðŸ',
    ]) {
      expect(
        source,
        isNot(contains(localPattern)),
        reason: 'Home should consume shared foundation components.',
      );
    }
  });

  Future<void> pumpHome(
    WidgetTester tester, {
    HomeSnapshot? snapshot,
    bool simulateError = false,
  }) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          homeRepositoryProvider.overrideWithValue(
            snapshot != null
                ? _StaticHomeRepository(snapshot)
                : MockHomeRepository(
                    simulateError: simulateError,
                    loadDelay: Duration.zero,
                  ),
          ),
        ],
        child: VitTradeApp(
          routerConfig: createAppRouter(initialLocation: AppRoutePaths.home),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('SC-007 HomePage renders the required proof sections', (
    tester,
  ) async {
    await pumpHome(tester);

    expect(find.text('VitTrade'), findsOneWidget);
    expect(find.byKey(HomePage.nextActionKey), findsOneWidget);
    expect(find.byKey(HomePage.marketTickerKey), findsOneWidget);
    expect(find.text('Hoàn tất rút USDT'), findsOneWidget);
    expect(find.byKey(HomePage.recentProductsKey), findsOneWidget);
    expect(find.byKey(HomePage.recentProductKey('spot-btc')), findsOneWidget);
    expect(find.byKey(HomePage.portfolioCardKey), findsOneWidget);
    expect(find.text('Tổng tài sản ước tính'), findsOneWidget);
    expect(find.text('PnL hôm nay'), findsOneWidget);
    expect(find.text('Biến động 7 ngày'), findsOneWidget);
    expect(
      find.descendant(
        of: find.byKey(HomePage.portfolioCardKey),
        matching: find.byType(VitSparkline),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byKey(HomePage.portfolioCardKey),
        matching: find.text('Earn'),
      ),
      findsOneWidget,
    );
    expect(find.text('Sản phẩm'), findsOneWidget);
    expect(find.text('Staking'), findsOneWidget);
    expect(find.text('Hỗ trợ'), findsNothing);
    expect(find.text('Margin'), findsNothing);
    expect(find.text('Dự đoán'), findsNothing);
    expect(find.text('Arena'), findsNothing);
    expect(find.text('Prediction Markets'), findsOneWidget);
    expect(find.text('Open Arena'), findsOneWidget);
    expect(find.text('Thị trường'), findsWidgets);
    expect(find.text('BTC/USDT'), findsWidgets);
    expect(find.text('Trang chủ'), findsOneWidget);
    expect(find.text('Giao dịch'), findsOneWidget);
  });

  testWidgets('SC-007 keeps advanced products in the more sheet', (
    tester,
  ) async {
    await pumpHome(tester);

    final moreProducts = find.descendant(
      of: find.byKey(HomePage.productsSectionKey),
      matching: find.textContaining('Xem th\u00EAm'),
    );
    await tester.ensureVisible(moreProducts);
    await tester.tap(moreProducts);
    await tester.pumpAndSettle();

    expect(find.byKey(HomePage.moreProductsSheetKey), findsOneWidget);
    expect(find.text('Ti\u1EBFt ki\u1EC7m'), findsOneWidget);
    expect(find.text('Launchpad'), findsOneWidget);
    expect(find.text('Margin'), findsOneWidget);
    expect(find.text('Bot'), findsOneWidget);
    expect(find.text('Copy Trade'), findsOneWidget);
    expect(find.text('Kh\u00E1m ph\u00E1'), findsOneWidget);
    expect(find.text('Gi\u1EDBi thi\u1EC7u'), findsOneWidget);
  });

  testWidgets('SC-007 flags leveraged products with a risk badge', (
    tester,
  ) async {
    await pumpHome(tester);

    final moreProducts = find.descendant(
      of: find.byKey(HomePage.productsSectionKey),
      matching: find.textContaining('Xem th\u00EAm'),
    );
    await tester.ensureVisible(moreProducts);
    await tester.tap(moreProducts);
    await tester.pumpAndSettle();

    expect(
      find.bySemanticsLabel(RegExp('Margin.*R\u1EE7i ro cao')),
      findsOneWidget,
    );
    expect(
      find.bySemanticsLabel(RegExp('Bot.*R\u1EE7i ro cao')),
      findsOneWidget,
    );
    expect(
      find.bySemanticsLabel(RegExp('Launchpad.*R\u1EE7i ro cao')),
      findsOneWidget,
    );
  });

  testWidgets('SC-007 orders products before recent surfaces', (tester) async {
    await pumpHome(tester);

    final productsTop = tester.getTopLeft(
      find.byKey(HomePage.productsSectionKey),
    );
    final recentTop = tester.getTopLeft(
      find.byKey(HomePage.recentProductsSectionKey),
    );

    expect(productsTop.dy, lessThan(recentTop.dy));
  });

  testWidgets('SC-007 uses uniform section gap between home blocks', (
    tester,
  ) async {
    await pumpHome(tester);

    final productsBottom = tester.getBottomLeft(
      find.byKey(HomePage.productsSectionKey),
    );
    final recentTop = tester.getTopLeft(
      find.byKey(HomePage.recentProductsSectionKey),
    );
    final recentBottom = tester.getBottomLeft(
      find.byKey(HomePage.recentProductsSectionKey),
    );
    final discoveryTop = tester.getTopLeft(find.text('Dự đoán & Thách đấu'));

    expect(
      recentTop.dy - productsBottom.dy,
      closeTo(AppSpacing.pageRhythmCompactSectionGap, 0.01),
    );
    expect(
      discoveryTop.dy - recentBottom.dy,
      closeTo(AppSpacing.pageRhythmCompactSectionGap, 0.01),
    );
  });

  testWidgets('SC-007 market ticker opens the pair route', (tester) async {
    await pumpHome(tester);

    // Ticker previews top movers (distinct from the Market section's
    // default "Hot" tab below) — SOL/USDT is the top 24h gainer in mock data.
    final tickerSol = find.descendant(
      of: find.byKey(HomePage.marketTickerKey),
      matching: find.text('SOL/USDT'),
    );

    expect(tickerSol, findsOneWidget);

    await tester.tap(tickerSol);
    await tester.pumpAndSettle();

    expect(find.byType(PairDetailPage), findsOneWidget);
  });

  testWidgets('SC-007 campaign announcement hides after session scroll', (
    tester,
  ) async {
    await pumpHome(
      tester,
      snapshot: _homeSnapshotWithAnnouncements(const [
        HomeAnnouncement(
          id: 'campaign-test',
          text: 'Campaign test',
          type: HomeAnnouncementType.campaign,
        ),
      ]),
    );

    expect(find.text('Campaign test'), findsOneWidget);

    await tester.drag(find.byKey(HomePage.contentKey), const Offset(0, -260));
    await tester.pumpAndSettle(const Duration(milliseconds: 220));

    expect(find.text('Campaign test'), findsNothing);
  });

  testWidgets('SC-007 security announcement does not auto-hide on scroll', (
    tester,
  ) async {
    await pumpHome(
      tester,
      snapshot: _homeSnapshotWithAnnouncements(const [
        HomeAnnouncement(
          id: 'security-test',
          text: 'Security test',
          type: HomeAnnouncementType.security,
        ),
      ]),
    );

    expect(find.text('Security test'), findsOneWidget);

    await tester.drag(find.byKey(HomePage.contentKey), const Offset(0, -260));
    await tester.pumpAndSettle(const Duration(milliseconds: 220));

    expect(find.text('Security test'), findsOneWidget);
  });

  testWidgets('SC-007 first viewport keeps key actions above bottom nav', (
    tester,
  ) async {
    await pumpHome(tester);

    final navTop = tester.getTopLeft(find.byType(VitBottomNav)).dy;
    final depositIcon = find.byIcon(Icons.file_download_outlined);

    expect(depositIcon, findsOneWidget);
    expect(find.byKey(HomePage.marketTickerKey), findsOneWidget);

    expect(tester.getBottomLeft(depositIcon).dy, lessThan(navTop));
    expect(
      tester.getBottomLeft(find.byKey(HomePage.nextActionKey)).dy,
      lessThan(navTop),
    );
    expect(
      tester.getBottomLeft(find.byKey(HomePage.marketTickerKey)).dy,
      lessThan(navTop),
    );
    expect(tester.getTopLeft(find.text('Sản phẩm')).dy, lessThan(navTop));
  });

  testWidgets('SC-007 portfolio card toggles USD and BTC display', (
    tester,
  ) async {
    await pumpHome(tester);

    expect(find.text('≈ 0.57133463 BTC'), findsOneWidget);

    await tester.tap(find.byTooltip('Chạm để đổi hiển thị USD/BTC'));
    await tester.pumpAndSettle();

    expect(find.text('0.57133463 BTC'), findsOneWidget);
    expect(find.text('\$54,276.79'), findsOneWidget);
  });

  testWidgets('SC-007 portfolio card shows onboarding empty state', (
    tester,
  ) async {
    await pumpHome(tester, snapshot: _emptyHomeSnapshot());

    expect(find.text('Chưa có tài sản'), findsOneWidget);
    expect(find.byKey(HomePage.portfolioDepositKey), findsOneWidget);
    expect(find.text('Nạp ngay'), findsOneWidget);
    expect(find.text('Xem thị trường'), findsOneWidget);
    expect(find.text('PnL hôm nay'), findsNothing);
  });

  testWidgets('SC-007 supports balance toggle and market tabs', (tester) async {
    await pumpHome(tester);

    await tester.tap(find.byIcon(Icons.visibility_outlined));
    await tester.pump();

    expect(find.text('••••••'), findsOneWidget);

    final gainersTab = find.textContaining('Tăng');
    await tester.ensureVisible(gainersTab);
    await tester.pumpAndSettle();
    await tester.tap(gainersTab);
    await tester.pump();

    expect(find.text('SOL/USDT'), findsWidgets);
  });

  testWidgets(
    'SC-007 hides the Home header on scroll down and shows it on scroll up',
    (tester) async {
      await pumpHome(tester);

      double headerHeight() {
        return tester.getSize(find.byKey(HomePage.headerKey)).height;
      }

      expect(headerHeight(), greaterThan(0));
      expect(find.text('VitTrade'), findsOneWidget);

      await tester.drag(find.byKey(HomePage.contentKey), const Offset(0, -320));
      await tester.pumpAndSettle(const Duration(milliseconds: 220));

      expect(headerHeight(), closeTo(0, 0.1));

      await tester.drag(find.byKey(HomePage.contentKey), const Offset(0, 120));
      await tester.pumpAndSettle(const Duration(milliseconds: 220));

      expect(headerHeight(), greaterThan(0));
      expect(find.text('VitTrade'), findsOneWidget);
    },
  );

  testWidgets(
    'SC-007 exposes Home outgoing navigation without porting targets',
    (tester) async {
      await pumpHome(tester);

      await tester.tap(find.byTooltip('Tìm kiếm toàn cục'));
      await tester.pumpAndSettle();

      expect(find.byType(UnifiedSearchPage), findsOneWidget);
      expect(find.text('Tìm kiếm'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.chevron_left_rounded));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.notifications_none_rounded));
      await tester.pumpAndSettle();

      expect(find.byType(NotificationsPage), findsOneWidget);

      await tester.tap(find.byIcon(Icons.chevron_left_rounded));
      await tester.pumpAndSettle();

      final p2pAction = find.text('P2P').last;
      await tester.ensureVisible(p2pAction);
      await tester.tap(p2pAction);
      await tester.pumpAndSettle();

      expect(find.text('P2P'), findsOneWidget);
    },
  );

  testWidgets('SC-007 notification badge follows global unread state', (
    tester,
  ) async {
    await pumpHome(tester);

    expect(
      find.descendant(
        of: find.byKey(const Key('vit_bottom_nav_home')),
        matching: find.text('7'),
      ),
      findsOneWidget,
    );

    await tester.tap(find.byIcon(Icons.notifications_none_rounded));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(NotificationsPage.markAllReadKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(HomePage), findsOneWidget);
    expect(
      find.descendant(
        of: find.byKey(const Key('vit_bottom_nav_home')),
        matching: find.text('7'),
      ),
      findsNothing,
    );
  });

  testWidgets('SC-007 opens the next action route from Home', (tester) async {
    await pumpHome(tester);

    await tester.tap(find.byKey(HomePage.nextActionKey));
    await tester.pumpAndSettle();

    expect(find.byType(WithdrawPage), findsOneWidget);
  });

  testWidgets('SC-007 full content scroll reaches market section', (
    tester,
  ) async {
    await pumpHome(tester);

    await tester.ensureVisible(find.text('Thị trường').last);
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Thị trường'), findsWidgets);
    expect(find.byKey(HomePage.contentKey), findsOneWidget);
  });

  testWidgets('SC-007 security announcement is prioritized over campaign', (
    tester,
  ) async {
    await pumpHome(
      tester,
      snapshot: _homeSnapshotWithAnnouncements(const [
        HomeAnnouncement(
          id: 'campaign-test',
          text: 'Campaign test',
          type: HomeAnnouncementType.campaign,
        ),
        HomeAnnouncement(
          id: 'security-test',
          text: 'Security test',
          type: HomeAnnouncementType.security,
        ),
      ]),
    );

    expect(find.text('Security test'), findsOneWidget);
    expect(find.text('Campaign test'), findsNothing);
  });

  testWidgets('SC-007 announcement cycles on tap', (tester) async {
    await pumpHome(
      tester,
      snapshot: _homeSnapshotWithAnnouncements(const [
        HomeAnnouncement(
          id: 'security-test',
          text: 'Security test',
          type: HomeAnnouncementType.security,
        ),
        HomeAnnouncement(
          id: 'campaign-test',
          text: 'Campaign test',
          type: HomeAnnouncementType.campaign,
        ),
      ]),
    );

    expect(find.text('Security test'), findsOneWidget);

    await tester.tap(find.byKey(HomePage.announcementKey));
    await tester.pumpAndSettle();

    expect(find.text('Campaign test'), findsOneWidget);
  });

  testWidgets('SC-007 hides next action after dismiss', (tester) async {
    await pumpHome(tester);

    expect(find.byKey(HomePage.nextActionKey), findsOneWidget);

    await tester.tap(find.byTooltip('Ẩn gợi ý'));
    await tester.pumpAndSettle();

    expect(find.byKey(HomePage.nextActionKey), findsNothing);
  });

  testWidgets('SC-007 hides next action when snapshot has none', (
    tester,
  ) async {
    await pumpHome(tester, snapshot: _homeSnapshotWithoutNextAction());

    expect(find.byKey(HomePage.nextActionKey), findsNothing);
  });

  testWidgets('SC-007 recent products empty state offers markets CTA', (
    tester,
  ) async {
    await pumpHome(tester, snapshot: _homeSnapshotWithoutRecentProducts());

    expect(find.text('Chưa có hoạt động gần đây'), findsOneWidget);
    expect(
      find.descendant(
        of: find.byKey(HomePage.recentProductsSectionKey),
        matching: find.text('Khám phá thị trường'),
      ),
      findsOneWidget,
    );
  });

  testWidgets('SC-007 portfolio breakdown opens wallet from spot pill', (
    tester,
  ) async {
    await pumpHome(tester);

    final spotPill = find.descendant(
      of: find.byKey(HomePage.portfolioCardKey),
      matching: find.text('Spot'),
    );
    await tester.tap(spotPill);
    await tester.pumpAndSettle();

    expect(find.byType(WalletPage), findsOneWidget);
  });

  testWidgets('SC-007 shows loading skeleton before snapshot resolves', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          homeRepositoryProvider.overrideWithValue(
            const MockHomeRepository(loadDelay: Duration(milliseconds: 500)),
          ),
        ],
        child: VitTradeApp(
          routerConfig: createAppRouter(initialLocation: AppRoutePaths.home),
        ),
      ),
    );
    await tester.pump();

    expect(find.byType(VitSkeleton), findsWidgets);

    await tester.pumpAndSettle();
  });

  testWidgets('SC-007 error state retries home fetch', (tester) async {
    final flakyRepository = _FlakyHomeRepository();

    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [homeRepositoryProvider.overrideWithValue(flakyRepository)],
        child: VitTradeApp(
          routerConfig: createAppRouter(initialLocation: AppRoutePaths.home),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Không tải được dữ liệu'), findsOneWidget);

    await tester.tap(find.text('Thử lại'));
    await tester.pumpAndSettle();

    expect(find.text('Tổng tài sản ước tính'), findsOneWidget);
  });

  testWidgets('SC-007 bottom content clears the bottom nav overlay', (
    tester,
  ) async {
    await pumpHome(tester);

    for (var i = 0; i < 8; i++) {
      await tester.drag(find.byKey(HomePage.contentKey), const Offset(0, -600));
      await tester.pump();
    }
    await tester.pumpAndSettle(const Duration(milliseconds: 220));

    final lastPair = find.text('SOL/USDT').last;
    final navTop = tester.getTopLeft(find.byType(VitBottomNav)).dy;

    expect(lastPair, findsOneWidget);
    expect(tester.getBottomLeft(lastPair).dy, lessThan(navTop - 8));
  });
}

final class _FlakyHomeRepository implements HomeRepository {
  var _attempts = 0;

  @override
  Future<HomeSnapshot> fetchHome() async {
    _attempts++;
    if (_attempts == 1) {
      throw StateError('home_fetch_failed');
    }
    return HomeMockData.snapshot;
  }
}

final class _StaticHomeRepository implements HomeRepository {
  const _StaticHomeRepository(this.snapshot);

  final HomeSnapshot snapshot;

  @override
  Future<HomeSnapshot> fetchHome() async => snapshot;
}

HomeSnapshot _homeSnapshotWithAnnouncements(
  List<HomeAnnouncement> announcements,
) {
  final snapshot = HomeMockData.snapshot;
  return HomeSnapshot(
    totalBalance: snapshot.totalBalance,
    totalBtc: snapshot.totalBtc,
    spotBalance: snapshot.spotBalance,
    earnBalance: snapshot.earnBalance,
    fundingBalance: snapshot.fundingBalance,
    dailyPnl: snapshot.dailyPnl,
    dailyPct: snapshot.dailyPct,
    portfolioTrend7d: snapshot.portfolioTrend7d,
    notifications: snapshot.notifications,
    announcements: announcements,
    quickActions: snapshot.quickActions,
    nextAction: snapshot.nextAction,
    recentProducts: snapshot.recentProducts,
    pairs: snapshot.pairs,
  );
}

HomeSnapshot _homeSnapshotWithoutNextAction() {
  final snapshot = HomeMockData.snapshot;
  return HomeSnapshot(
    totalBalance: snapshot.totalBalance,
    totalBtc: snapshot.totalBtc,
    spotBalance: snapshot.spotBalance,
    earnBalance: snapshot.earnBalance,
    fundingBalance: snapshot.fundingBalance,
    dailyPnl: snapshot.dailyPnl,
    dailyPct: snapshot.dailyPct,
    portfolioTrend7d: snapshot.portfolioTrend7d,
    notifications: snapshot.notifications,
    announcements: snapshot.announcements,
    quickActions: snapshot.quickActions,
    nextAction: null,
    recentProducts: snapshot.recentProducts,
    pairs: snapshot.pairs,
  );
}

HomeSnapshot _homeSnapshotWithoutRecentProducts() {
  final snapshot = HomeMockData.snapshot;
  return HomeSnapshot(
    totalBalance: snapshot.totalBalance,
    totalBtc: snapshot.totalBtc,
    spotBalance: snapshot.spotBalance,
    earnBalance: snapshot.earnBalance,
    fundingBalance: snapshot.fundingBalance,
    dailyPnl: snapshot.dailyPnl,
    dailyPct: snapshot.dailyPct,
    portfolioTrend7d: snapshot.portfolioTrend7d,
    notifications: snapshot.notifications,
    announcements: snapshot.announcements,
    quickActions: snapshot.quickActions,
    nextAction: snapshot.nextAction,
    recentProducts: const [],
    pairs: snapshot.pairs,
  );
}

HomeSnapshot _emptyHomeSnapshot() {
  final snapshot = HomeMockData.snapshot;
  return HomeSnapshot(
    totalBalance: 0,
    totalBtc: 0,
    spotBalance: 0,
    earnBalance: 0,
    fundingBalance: 0,
    dailyPnl: 0,
    dailyPct: 0,
    portfolioTrend7d: const [0, 0, 0, 0, 0, 0, 0],
    notifications: snapshot.notifications,
    announcements: snapshot.announcements,
    quickActions: snapshot.quickActions,
    nextAction: snapshot.nextAction,
    recentProducts: snapshot.recentProducts,
    pairs: snapshot.pairs,
  );
}
