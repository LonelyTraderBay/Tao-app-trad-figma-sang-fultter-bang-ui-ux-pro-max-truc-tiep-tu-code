import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    home: Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(padding: const EdgeInsets.all(16), child: child),
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('showVitBottomSheet opens and returns a typed value', (
    tester,
  ) async {
    Future<String?>? result;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  result = showVitBottomSheet<String>(
                    context: context,
                    builder: (sheetContext) {
                      return SafeArea(
                        top: false,
                        child: TextButton(
                          onPressed: () =>
                              Navigator.of(sheetContext).pop('selected'),
                          child: const Text('Choose value'),
                        ),
                      );
                    },
                  );
                },
                child: const Text('Open sheet'),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open sheet'));
    await tester.pumpAndSettle();

    expect(find.text('Choose value'), findsOneWidget);

    await tester.tap(find.text('Choose value'));
    await tester.pumpAndSettle();

    expect(await result, 'selected');
    expect(find.text('Choose value'), findsNothing);
  });

  testWidgets('VitCard supports tap and visual variants', (tester) async {
    var taps = 0;

    await tester.pumpWidget(
      _wrap(
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            VitCard(
              padding: const EdgeInsets.all(16),
              onTap: () => taps++,
              child: const Text('standard card'),
            ),
            const SizedBox(height: 8),
            const VitCard(
              variant: VitCardVariant.hero,
              padding: EdgeInsets.all(16),
              background: ColoredBox(color: AppColors.primary08),
              child: Text('hero card'),
            ),
          ],
        ),
      ),
    );

    await tester.tap(find.text('standard card'));
    await tester.pump();

    expect(taps, 1);
    expect(find.text('hero card'), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (widget) => widget is ColoredBox && widget.color == AppColors.primary08,
      ),
      findsOneWidget,
    );

    final heroContainer = tester.widget<Container>(
      find
          .ancestor(
            of: find.text('hero card'),
            matching: find.byType(Container),
          )
          .first,
    );
    final heroDecoration = heroContainer.decoration! as BoxDecoration;
    expect(heroDecoration.boxShadow, const [
      BoxShadow(
        color: AppColors.primary08,
        blurRadius: AppSpacing.ctaElevationBlur,
        spreadRadius: AppSpacing.ctaElevationSpread,
        offset: Offset(0, AppSpacing.ctaElevationYOffset),
      ),
    ]);
  });

  testWidgets('VitCtaButton and VitIconButton expose action states', (
    tester,
  ) async {
    var ctaTaps = 0;
    var iconTaps = 0;

    await tester.pumpWidget(
      _wrap(
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            VitCtaButton(
              onPressed: () => ctaTaps++,
              leading: const Icon(Icons.add_rounded),
              child: const Text('Continue'),
            ),
            const SizedBox(height: 8),
            VitIconButton(
              icon: Icons.search_rounded,
              tooltip: 'Search',
              onPressed: () => iconTaps++,
            ),
            const SizedBox(height: 8),
            const VitCtaButton(loading: true, child: Text('Loading')),
          ],
        ),
      ),
    );

    await tester.tap(find.text('Continue'));
    await tester.tap(find.byIcon(Icons.search_rounded));
    await tester.pump();

    expect(ctaTaps, 1);
    expect(iconTaps, 1);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('VitSearchBar handles input, clear, and filter action', (
    tester,
  ) async {
    String query = '';
    var filters = 0;

    await tester.pumpWidget(
      _wrap(
        VitSearchBar(
          placeholder: 'Search assets',
          onChanged: (value) => query = value,
          onFilterTap: () => filters++,
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), 'btc');
    await tester.pump();

    expect(query, 'btc');
    expect(find.byIcon(Icons.close_rounded), findsOneWidget);

    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pump();

    expect(query, '');

    await tester.tap(find.byIcon(Icons.tune_rounded));
    await tester.pump();

    expect(filters, 1);
  });

  testWidgets('VitInput renders label, affixes, errors, and password mode', (
    tester,
  ) async {
    final controller = TextEditingController(text: 'secret');

    await tester.pumpWidget(
      _wrap(
        VitInput(
          controller: controller,
          label: 'Password',
          hintText: 'Enter password',
          prefix: const Icon(Icons.lock_outline_rounded),
          suffix: const Icon(Icons.visibility_outlined),
          errorText: 'Required',
          obscureText: true,
        ),
      ),
    );

    expect(find.text('Password'), findsOneWidget);
    expect(find.byIcon(Icons.lock_outline_rounded), findsOneWidget);
    expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
    expect(find.text('Required'), findsOneWidget);

    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.obscureText, isTrue);

    final container = tester.widget<Container>(
      find
          .ancestor(
            of: find.byType(TextField),
            matching: find.byType(Container),
          )
          .first,
    );
    final decoration = container.decoration! as BoxDecoration;
    expect(decoration.border, isA<Border>());

    controller.dispose();
  });

  testWidgets('status and state primitives render shared Home-proof states', (
    tester,
  ) async {
    var retry = 0;

    await tester.pumpWidget(
      _wrap(
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const VitStatusPill(
              label: 'Live',
              status: VitStatusPillStatus.success,
              pulse: true,
              count: 3,
            ),
            const SizedBox(height: 8),
            const VitSkeletonList(rows: 2),
            const SizedBox(height: 8),
            const VitEmptyState(title: 'No assets'),
            const SizedBox(height: 8),
            VitErrorState(onAction: () => retry++),
            const SizedBox(height: 8),
            const VitOfflineBanner(detail: 'Updated 2 minutes ago.'),
          ],
        ),
      ),
    );

    expect(find.text('Live'), findsOneWidget);
    expect(find.text('No assets'), findsOneWidget);
    expect(find.text('Offline. Showing latest cached data.'), findsOneWidget);

    await tester.ensureVisible(find.text('Retry'));
    await tester.pump(const Duration(milliseconds: 100));
    await tester.tap(find.text('Retry'));
    await tester.pump();

    expect(retry, 1);
  });

  testWidgets('Home foundation primitives render and dispatch actions', (
    tester,
  ) async {
    var sectionTaps = 0;
    var tileTaps = 0;
    var marketTaps = 0;
    var rankedTaps = 0;
    var productTaps = 0;

    await tester.pumpWidget(
      _wrap(
        SizedBox(
          width: 360,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              VitSectionHeader(
                title: 'Markets',
                icon: Icons.trending_up_rounded,
                iconColor: AppColors.buy,
                actionLabel: 'View',
                onAction: () => sectionTaps++,
              ),
              const SizedBox(height: 8),
              const VitAccentPill(
                label: 'Live',
                accentColor: AppColors.buy,
                semanticStatus: VitStatusPillStatus.success,
              ),
              const SizedBox(height: 8),
              const SizedBox(
                width: 96,
                height: 32,
                child: VitSparkline(
                  values: [1, 2.4, 1.8, 3.1, 2.7],
                  color: AppColors.buy,
                ),
              ),
              const SizedBox(height: 8),
              const VitAssetAvatar(label: 'BTC', accentColor: AppColors.warn),
              const SizedBox(height: 8),
              VitActionTileGrid(
                density: VitDensity.compact,
                itemCount: 1,
                itemBuilder: (context, index, density) {
                  return VitServiceTile(
                    icon: Icons.swap_horiz_rounded,
                    label: 'Swap',
                    accentColor: AppColors.primary,
                    density: density,
                    onTap: () => tileTaps++,
                  );
                },
              ),
              const SizedBox(height: 8),
              VitMarketPairRow(
                leading: const VitAssetAvatar(
                  label: 'BTC',
                  accentColor: AppColors.warn,
                ),
                title: 'BTC/USDT',
                subtitle: 'Vol \$1.20B',
                price: '\$68,000.00',
                changeLabel: '+2.10%',
                trend: VitTrendDirection.positive,
                sparkline: const [1, 1.4, 1.2, 1.8],
                onTap: () => marketTaps++,
              ),
              VitRankedAssetRow(
                rank: 1,
                leading: const VitAssetAvatar(
                  label: 'ETH',
                  accentColor: AppColors.accent,
                ),
                title: 'ETH/USDT',
                badgeLabel: '-1.30%',
                trend: VitTrendDirection.negative,
                onTap: () => rankedTaps++,
              ),
              const SizedBox(height: 8),
              VitCompactProductCard(
                icon: Icons.account_balance_wallet_outlined,
                title: 'Recent',
                subtitle: 'Wallet',
                accentColor: AppColors.primary,
                badgeLabel: 'Ready',
                onTap: () => productTaps++,
              ),
              const SizedBox(height: 8),
              const VitTogglePill(enabled: true),
            ],
          ),
        ),
      ),
    );

    expect(find.text('Markets'), findsOneWidget);
    expect(find.text('Live'), findsOneWidget);
    expect(find.byType(VitSparkline), findsWidgets);
    expect(find.text('BTC/USDT'), findsOneWidget);
    expect(find.text('ETH/USDT'), findsOneWidget);
    expect(find.text('Recent'), findsOneWidget);
    expect(find.byType(VitTogglePill), findsOneWidget);

    await tester.tap(find.text('View'));
    await tester.ensureVisible(find.text('Swap'));
    await tester.tap(find.text('Swap'));
    await tester.ensureVisible(find.text('BTC/USDT'));
    await tester.tap(find.text('BTC/USDT'));
    await tester.ensureVisible(find.text('ETH/USDT'));
    await tester.tap(find.text('ETH/USDT'));
    await tester.ensureVisible(find.text('Recent'));
    await tester.tap(find.text('Recent'));
    await tester.pump();

    expect(sectionTaps, 1);
    expect(tileTaps, 1);
    expect(marketTaps, 1);
    expect(rankedTaps, 1);
    expect(productTaps, 1);
  });

  testWidgets('VitCarouselDots renders active and inactive widths', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(const VitCarouselDots(itemCount: 3, activeIndex: 1)),
    );

    final inactiveSize = tester.getSize(
      find.byKey(const ValueKey('vit_carousel_dot_0')),
    );
    final activeSize = tester.getSize(
      find.byKey(const ValueKey('vit_carousel_dot_1')),
    );

    expect(inactiveSize.width, AppSpacing.homeAnnouncementDotInactiveWidth);
    expect(activeSize.width, AppSpacing.homeAnnouncementDotActiveWidth);
    expect(find.bySemanticsLabel('Carousel page 2 of 3'), findsOneWidget);
  });

  testWidgets('VitCarouselDots supports keyed tap callbacks', (tester) async {
    var selectedIndex = -1;

    await tester.pumpWidget(
      _wrap(
        VitCarouselDots(
          itemCount: 3,
          activeIndex: 0,
          dotKeyBuilder: (index) => ValueKey('onboarding_dot_$index'),
          onDotTap: (index) => selectedIndex = index,
        ),
      ),
    );

    await tester.tap(find.byKey(const ValueKey('onboarding_dot_2')));
    await tester.pump();

    expect(selectedIndex, 2);
    expect(find.bySemanticsLabel('Go to carousel page 3'), findsOneWidget);
  });

  testWidgets('VitMetricDeltaPill renders semantic tones', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            VitMetricDeltaPill(
              label: '+12.34%',
              tone: VitMetricDeltaTone.positive,
            ),
            SizedBox(height: 8),
            VitMetricDeltaPill(
              label: '-2.10%',
              tone: VitMetricDeltaTone.negative,
            ),
            SizedBox(height: 8),
            VitMetricDeltaPill(label: '0.00%'),
          ],
        ),
      ),
    );

    expect(find.text('+12.34%'), findsOneWidget);
    expect(find.text('-2.10%'), findsOneWidget);
    expect(find.text('0.00%'), findsOneWidget);

    final positiveIcon = tester.widget<Icon>(
      find.byIcon(Icons.trending_up_rounded),
    );
    final negativeIcon = tester.widget<Icon>(
      find.byIcon(Icons.trending_down_rounded),
    );

    expect(positiveIcon.color, AppColors.buy);
    expect(negativeIcon.color, AppColors.sell);
    final neutralText = tester.widget<Text>(find.text('0.00%'));
    expect(neutralText.style?.color, AppColors.text2);
  });

  testWidgets('VitNextActionCard dispatches taps', (tester) async {
    var taps = 0;

    await tester.pumpWidget(
      _wrap(
        VitNextActionCard(
          icon: Icons.file_upload_outlined,
          title: 'Complete withdrawal',
          subtitle: 'Review saved USDT request',
          statusLabel: 'Pending',
          ctaLabel: 'Resume',
          accentColor: AppColors.primary,
          onTap: () => taps++,
        ),
      ),
    );

    await tester.tap(find.text('Complete withdrawal'));
    await tester.pump();

    expect(find.text('Pending'), findsOneWidget);
    expect(find.text('Resume'), findsOneWidget);
    expect(taps, 1);
  });

  testWidgets('VitDiscoveryActionCard renders badge action and tap', (
    tester,
  ) async {
    var taps = 0;

    await tester.pumpWidget(
      _wrap(
        VitDiscoveryActionCard(
          title: 'Prediction Markets',
          badgeLabel: 'Prediction Market',
          subtitle: 'Probability markets',
          actionLabel: 'Explore',
          icon: Icons.adjust_rounded,
          accentColor: AppColors.accent,
          borderColor: AppColors.accent20,
          background: const LinearGradient(
            colors: [AppColors.accent15, AppColors.primary08],
          ),
          onTap: () => taps++,
        ),
      ),
    );

    expect(find.text('Prediction Markets'), findsOneWidget);
    expect(find.text('Prediction Market'), findsOneWidget);
    expect(find.text('Explore'), findsOneWidget);

    await tester.tap(find.text('Prediction Markets'));
    await tester.pump();

    expect(taps, 1);
  });

  testWidgets('VitDiscoveryActionCard compact variant keeps action contract', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        VitDiscoveryActionCard(
          title: 'Open Arena',
          badgeLabel: 'Arena Points only',
          subtitle: 'Points-only room',
          actionLabel: 'Enter',
          icon: Icons.sports_esports_outlined,
          accentColor: AppColors.warn,
          borderColor: AppColors.warningBorder,
          background: const LinearGradient(
            colors: [AppColors.warn15, AppColors.warn10],
          ),
          variant: VitDiscoveryActionCardVariant.compact,
          onTap: () {},
        ),
      ),
    );

    final card = tester.widget<VitDiscoveryActionCard>(
      find.byType(VitDiscoveryActionCard),
    );

    expect(card.variant, VitDiscoveryActionCardVariant.compact);
    expect(find.text('Arena Points only'), findsOneWidget);
    expect(find.text('Enter'), findsOneWidget);
  });

  testWidgets('VitActionTileGrid maxVisibleItems caps rendered tiles', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        VitActionTileGrid(
          itemCount: 3,
          maxVisibleItems: 2,
          itemBuilder: (context, index, density) {
            return VitServiceTile(
              icon: Icons.bolt_rounded,
              label: 'Action $index',
              accentColor: AppColors.primary,
              density: density,
            );
          },
        ),
      ),
    );

    expect(find.text('Action 0'), findsOneWidget);
    expect(find.text('Action 1'), findsOneWidget);
    expect(find.text('Action 2'), findsNothing);
  });

  testWidgets('VitAnnouncementBanner supports compact, dots, and dismiss', (
    tester,
  ) async {
    var dismissed = 0;

    await tester.pumpWidget(
      _wrap(
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            VitAnnouncementBanner(
              message: 'Campaign update',
              itemCount: 2,
              activeIndex: 1,
              onDismiss: () => dismissed++,
            ),
            const SizedBox(height: 8),
            const VitAnnouncementBanner(
              message: 'Compact update',
              itemCount: 2,
              variant: VitAnnouncementBannerVariant.compact,
            ),
          ],
        ),
      ),
    );

    expect(find.text('Campaign update'), findsOneWidget);
    expect(find.text('Compact update'), findsOneWidget);
    expect(find.byType(VitCarouselDots), findsOneWidget);

    await tester.tap(find.byTooltip('Dismiss announcement'));
    await tester.pump();

    expect(dismissed, 1);
  });

  testWidgets('VitMarketTickerStrip renders trends and dispatches taps', (
    tester,
  ) async {
    var taps = 0;

    await tester.pumpWidget(
      _wrap(
        VitMarketTickerStrip(
          items: [
            VitMarketTickerData(
              title: 'BTC/USDT',
              price: '\$68,000.00',
              changeLabel: '+2.10%',
              trend: VitTrendDirection.positive,
              onTap: () => taps++,
            ),
            const VitMarketTickerData(
              title: 'ETH/USDT',
              price: '\$3,400.00',
              changeLabel: '-1.20%',
              trend: VitTrendDirection.negative,
            ),
          ],
        ),
      ),
    );

    expect(find.text('BTC/USDT'), findsOneWidget);
    expect(find.text('-1.20%'), findsOneWidget);

    await tester.tap(find.text('BTC/USDT'));
    await tester.pump();

    expect(taps, 1);
  });

  testWidgets(
    'VitSheetHandle and VitSheetPanel render tokenized sheet chrome',
    (tester) async {
      await tester.pumpWidget(
        _wrap(
          const SizedBox(
            height: 260,
            child: VitSheetPanel(
              title: 'More products',
              child: Center(child: Text('Sheet child')),
            ),
          ),
        ),
      );

      expect(find.byType(VitSheetHandle), findsOneWidget);
      expect(find.text('More products'), findsOneWidget);
      expect(find.text('Sheet child'), findsOneWidget);

      final handleSize = tester.getSize(
        find.descendant(
          of: find.byType(VitSheetHandle),
          matching: find.byType(Container),
        ),
      );

      expect(handleSize.width, AppSpacing.homeMoreProductsSheetHandleWidth);
      expect(handleSize.height, AppSpacing.homeMoreProductsSheetHandleHeight);
    },
  );

  testWidgets('VitSheetSurface renders tokenized sheet surface', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(const VitSheetSurface(child: Text('Surface child'))),
    );

    expect(find.text('Surface child'), findsOneWidget);

    final surface = tester.widget<Container>(
      find
          .descendant(
            of: find.byType(VitSheetSurface),
            matching: find.byType(Container),
          )
          .first,
    );
    final decoration = surface.decoration as BoxDecoration;

    expect(surface.padding, AppSpacing.homeMoreProductsSheetPadding);
    expect(decoration.color, AppColors.bg);
    expect(decoration.borderRadius, AppRadii.sheetTopLargeRadius);
  });
}
