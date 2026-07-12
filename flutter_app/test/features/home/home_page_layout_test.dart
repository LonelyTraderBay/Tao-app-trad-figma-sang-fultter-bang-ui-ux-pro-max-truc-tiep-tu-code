import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/home/data/providers/home_repository_provider.dart';
import 'package:vit_trade_flutter/features/home/data/repositories/mock_home_repository.dart';
import 'package:vit_trade_flutter/features/home/domain/entities/home_entities.dart';
import 'package:vit_trade_flutter/features/home/domain/repositories/home_repository.dart';
import 'package:vit_trade_flutter/features/home/presentation/pages/home_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_sparkline.dart';

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

  testWidgets('SC-007 full content scroll reaches market section', (
    tester,
  ) async {
    await pumpHome(tester);

    await tester.ensureVisible(find.text('Thị trường').last);
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Thị trường'), findsWidgets);
    expect(find.byKey(HomePage.contentKey), findsOneWidget);
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

final class _StaticHomeRepository implements HomeRepository {
  const _StaticHomeRepository(this.snapshot);

  final HomeSnapshot snapshot;

  @override
  Future<HomeSnapshot> fetchHome() async => snapshot;
}
