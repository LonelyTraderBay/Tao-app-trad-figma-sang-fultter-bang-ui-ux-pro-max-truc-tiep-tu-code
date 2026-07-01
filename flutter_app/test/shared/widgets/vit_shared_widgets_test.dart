import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
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

    final heroDecoratedBox = tester.widget<DecoratedBox>(
      find
          .ancestor(
            of: find.text('hero card'),
            matching: find.byWidgetPredicate(
              (widget) =>
                  widget is DecoratedBox &&
                  widget.decoration is ShapeDecoration,
            ),
          )
          .first,
    );
    final heroDecoration = heroDecoratedBox.decoration as ShapeDecoration;
    expect(heroDecoration.shadows, const [
      BoxShadow(
        color: AppColors.primary08,
        blurRadius: AppSpacing.ctaElevationBlur,
        spreadRadius: AppSpacing.ctaElevationSpread,
        offset: Offset(0, AppSpacing.ctaElevationYOffset),
      ),
    ]);
  });

  testWidgets('shared primitives expose opt-in compact density', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    var infoRowTaps = 0;

    await tester.pumpWidget(
      _wrap(
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const VitPageContent(
              key: ValueKey('density_content'),
              density: VitDensity.compact,
              children: [
                Text('first compact section'),
                Text('second compact section'),
              ],
            ),
            const SizedBox(height: 8),
            const VitCard(
              key: ValueKey('density_card'),
              density: VitDensity.compact,
              child: Text('compact card'),
            ),
            const SizedBox(height: 8),
            const VitMetricCard(
              label: 'Compact metric',
              value: '\$12.4K',
              density: VitDensity.compact,
            ),
            const SizedBox(height: 8),
            const VitSectionHeader(
              title: 'Compact section',
              density: VitDensity.compact,
            ),
            const SizedBox(height: 8),
            VitInfoRow(
              label: 'Network',
              value: 'Ethereum',
              density: VitDensity.compact,
              leading: const Icon(Icons.account_tree_outlined),
              onTap: () => infoRowTaps++,
            ),
          ],
        ),
      ),
    );

    final contentPadding = tester.widget<Padding>(
      find
          .descendant(
            of: find.byKey(const ValueKey('density_content')),
            matching: find.byType(Padding),
          )
          .first,
    );
    expect(
      contentPadding.padding,
      const EdgeInsetsDirectional.only(
        start: AppSpacing.contentPad,
        end: AppSpacing.contentPad,
        top: AppSpacing.pageContentTopCompact,
      ),
    );

    final contentGap = tester.widget<SizedBox>(
      find
          .descendant(
            of: find.byKey(const ValueKey('density_content')),
            matching: find.byType(SizedBox),
          )
          .first,
    );
    expect(contentGap.height, AppSpacing.pageContentGapTight);

    final cardPadding = tester.widget<Padding>(
      find
          .descendant(
            of: find.byKey(const ValueKey('density_card')),
            matching: find.byType(Padding),
          )
          .first,
    );
    expect(cardPadding.padding, VitDensity.compact.cardPadding);
    expect(VitDensity.hero.pageContentGap, AppSpacing.pageContentGapDefault);
    expect(VitDensity.tool.cardVerticalPadding, AppSpacing.x2);
    expect(find.text('Compact section'), findsOneWidget);

    final infoRowBox = tester.widget<ConstrainedBox>(
      find
          .ancestor(
            of: find.text('Network'),
            matching: find.byType(ConstrainedBox),
          )
          .first,
    );
    expect(infoRowBox.constraints.minHeight, VitDensity.compact.controlHeight);

    await tester.tap(find.text('Network'));
    await tester.pump();

    expect(infoRowTaps, 1);
    final infoNode = tester.getSemantics(find.byType(VitInfoRow));
    expect(infoNode.label, 'Network, Ethereum');
    semantics.dispose();
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

  testWidgets('VitSegmentedChoice renders borderless buy sell pills', (
    tester,
  ) async {
    var selected = 'buy';

    await tester.pumpWidget(
      _wrap(
        StatefulBuilder(
          builder: (context, setState) {
            return VitSegmentedChoice<String>(
              selected: selected,
              onChanged: (value) => setState(() => selected = value),
              options: const [
                VitSegmentedChoiceOption(
                  value: 'buy',
                  label: 'MUA',
                  accentColor: AppColors.buy,
                ),
                VitSegmentedChoiceOption(
                  value: 'sell',
                  label: 'BÁN',
                  accentColor: AppColors.sell,
                ),
              ],
            );
          },
        ),
      ),
    );

    expect(find.text('MUA'), findsOneWidget);
    expect(find.text('BÁN'), findsOneWidget);
    expect(find.byType(VitSegmentedChoice<String>), findsOneWidget);

    await tester.tap(find.text('BÁN'));
    await tester.pump();

    expect(selected, 'sell');
  });

  testWidgets('VitSegmentedChoice.buySell factory toggles MUA and BAN', (
    tester,
  ) async {
    var isBuy = true;

    await tester.pumpWidget(
      _wrap(
        StatefulBuilder(
          builder: (context, setState) {
            return VitSegmentedChoice.buySell(
              isBuy: isBuy,
              onChanged: (value) => setState(() => isBuy = value),
            );
          },
        ),
      ),
    );

    expect(find.text('MUA'), findsOneWidget);
    expect(find.text('BÁN'), findsOneWidget);

    await tester.tap(find.text('BÁN'));
    await tester.pump();

    expect(isBuy, isFalse);
  });

  testWidgets('VitCommunityRulesLink renders label and handles tap', (
    tester,
  ) async {
    var tapped = false;

    await tester.pumpWidget(
      _wrap(VitCommunityRulesLink(onTap: () => tapped = true)),
    );

    expect(find.text('Quy tắc cộng đồng'), findsOneWidget);
    expect(find.byIcon(Icons.menu_book_outlined), findsOneWidget);

    await tester.tap(find.text('Quy tắc cộng đồng'));
    await tester.pump();

    expect(tapped, isTrue);
  });

  testWidgets('VitCommunityRulesLink static mode does not crash', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(const VitCommunityRulesLink(label: 'Quy tắc cộng đồng')),
    );

    expect(find.text('Quy tắc cộng đồng'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('VitCommunityRulesLink uses ghost VitCard not CTA or inner', (
    tester,
  ) async {
    await tester.pumpWidget(_wrap(VitCommunityRulesLink(onTap: () {})));

    final linkFinder = find.byType(VitCommunityRulesLink);
    expect(linkFinder, findsOneWidget);

    expect(
      find.ancestor(
        of: find.text('Quy tắc cộng đồng'),
        matching: find.byType(VitCtaButton),
      ),
      findsNothing,
    );

    final cards = tester.widgetList<VitCard>(
      find.descendant(of: linkFinder, matching: find.byType(VitCard)),
    );

    expect(cards.length, 1);
    expect(cards.first.variant, VitCardVariant.ghost);
    expect(cards.first.variant, isNot(VitCardVariant.inner));
  });

  testWidgets('VitPresetChipRow.percentBalance renders and taps', (
    tester,
  ) async {
    int? tapped;

    await tester.pumpWidget(
      _wrap(
        VitPresetChipRow.percentBalance(
          onTap: (value) => tapped = value,
          keyFor: (value) => Key('pct_$value'),
        ),
      ),
    );

    expect(find.text('25%'), findsOneWidget);
    expect(find.text('100%'), findsOneWidget);

    await tester.tap(find.text('50%'));
    await tester.pump();

    expect(tapped, 50);
  });

  testWidgets('VitPresetChipRow highlights selectedValue', (tester) async {
    await tester.pumpWidget(
      _wrap(
        VitPresetChipRow.percentBalance(
          selectedValue: 75,
          onTap: (_) {},
          keyFor: (value) => Key('pct_$value'),
        ),
      ),
    );

    final selectedPill = tester.widget<VitChoicePill>(
      find.byWidgetPredicate(
        (widget) => widget is VitChoicePill && widget.label == '75%',
      ),
    );
    expect(selectedPill.selected, isTrue);
  });

  testWidgets('VitPresetChipRow has no VitCard ancestor', (tester) async {
    await tester.pumpWidget(
      _wrap(
        VitPresetChipRow.percentBalance(
          onTap: (_) {},
          keyFor: (value) => Key('pct_$value'),
        ),
      ),
    );

    expect(
      find.ancestor(
        of: find.byType(VitPresetChipRow<int>),
        matching: find.byType(VitCard),
      ),
      findsNothing,
    );
  });

  testWidgets('VitSegmentedTabBar has no VitCard outer wrapper', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        VitSegmentedTabBar(
          activeKey: 'overview',
          onChanged: (_) {},
          tabs: const [
            VitTabItem(key: 'overview', label: 'Overview'),
            VitTabItem(key: 'history', label: 'History'),
          ],
        ),
      ),
    );

    expect(find.byType(VitSegmentedTabBar), findsOneWidget);
    expect(find.byType(VitCard), findsNothing);
    expect(
      find.ancestor(
        of: find.byType(VitSegmentedTabBar),
        matching: find.byType(VitCard),
      ),
      findsNothing,
    );
  });

  testWidgets('segment tab unselected pills use ghost border', (tester) async {
    await tester.pumpWidget(
      _wrap(
        VitSegmentedTabBar(
          activeKey: 'overview',
          onChanged: (_) {},
          tabs: const [
            VitTabItem(key: 'overview', label: 'Overview'),
            VitTabItem(key: 'history', label: 'History'),
          ],
        ),
      ),
    );

    final inactiveDecorations = tester
        .widgetList<DecoratedBox>(
          find.descendant(
            of: find.byType(VitSegmentedTabBar),
            matching: find.byWidgetPredicate(
              (widget) =>
                  widget is DecoratedBox &&
                  widget.decoration is ShapeDecoration,
            ),
          ),
        )
        .map((box) => box.decoration as ShapeDecoration)
        .where((decoration) => decoration.color == AppColors.transparent)
        .toList();

    expect(inactiveDecorations, isNotEmpty);

    final inactiveShape =
        inactiveDecorations.first.shape as RoundedRectangleBorder;

    expect(inactiveShape.side.color, AppColors.portfolioBtnGhostBorder);
  });

  testWidgets('VitChoicePill renders selected and disabled states', (
    tester,
  ) async {
    var taps = 0;

    await tester.pumpWidget(
      _wrap(
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            VitChoicePill(
              label: 'Bank transfer',
              selected: true,
              showSelectedIcon: true,
              onTap: () => taps++,
            ),
            const SizedBox(height: 8),
            VitChoicePill(
              label: 'Disabled option',
              selected: false,
              enabled: false,
              onTap: () => taps++,
            ),
          ],
        ),
      ),
    );

    expect(find.text('Bank transfer'), findsOneWidget);
    expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);

    await tester.tap(find.text('Bank transfer'));
    await tester.tap(find.text('Disabled option'), warnIfMissed: false);
    await tester.pump();

    expect(taps, 1);
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

    final inputPadding = tester.widget<Padding>(
      find
          .ancestor(of: find.byType(TextField), matching: find.byType(Padding))
          .first,
    );
    expect(
      inputPadding.padding,
      const EdgeInsetsDirectional.symmetric(horizontal: AppSpacing.x4),
    );

    final shell = tester.widget<DecoratedBox>(
      find
          .ancestor(
            of: find.byType(TextField),
            matching: find.byType(DecoratedBox),
          )
          .first,
    );
    final decoration = shell.decoration as ShapeDecoration;
    final shape = decoration.shape as RoundedRectangleBorder;
    expect(shape.side.color, AppColors.sell);
    expect(shape.side.width, AppSpacing.borderWidth);

    controller.dispose();
  });

  testWidgets('VitTabBar variants render and dispatch changes', (tester) async {
    var selected = '';
    var pillActive = 'spot';
    var segmentActive = 'overview';
    var underlineActive = 'open';

    await tester.pumpWidget(
      _wrap(
        SizedBox(
          width: 360,
          child: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  VitTabBar(
                    activeKey: pillActive,
                    onChanged: (key) {
                      selected = 'pill:$key';
                      setState(() => pillActive = key);
                    },
                    tabs: const [
                      VitTabItem(
                        key: 'spot',
                        label: 'Spot',
                        icon: Icons.show_chart_rounded,
                        widgetKey: Key('pill_spot'),
                      ),
                      VitTabItem(
                        key: 'margin',
                        label: 'Margin',
                        widgetKey: Key('pill_margin'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  VitTabBar(
                    variant: VitTabBarVariant.segment,
                    activeKey: segmentActive,
                    onChanged: (key) {
                      selected = 'segment:$key';
                      setState(() => segmentActive = key);
                    },
                    tabs: const [
                      VitTabItem(
                        key: 'overview',
                        label: 'Overview',
                        widgetKey: Key('segment_overview'),
                      ),
                      VitTabItem(
                        key: 'history',
                        label: 'History',
                        widgetKey: Key('segment_history'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  VitTabBar(
                    variant: VitTabBarVariant.underline,
                    activeKey: underlineActive,
                    onChanged: (key) {
                      selected = 'underline:$key';
                      setState(() => underlineActive = key);
                    },
                    tabs: const [
                      VitTabItem(
                        key: 'open',
                        label: 'Open',
                        widgetKey: Key('underline_open'),
                      ),
                      VitTabItem(
                        key: 'closed',
                        label: 'Closed',
                        widgetKey: Key('underline_closed'),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );

    expect(find.byType(VitTabBar), findsNWidgets(3));
    expect(find.text('Spot'), findsOneWidget);
    expect(find.text('Overview'), findsOneWidget);
    expect(find.text('Open'), findsOneWidget);

    await tester.tap(find.byKey(const Key('pill_margin')));
    await tester.pump();
    expect(selected, 'pill:margin');

    await tester.tap(find.byKey(const Key('segment_history')));
    await tester.pump();
    expect(selected, 'segment:history');

    await tester.tap(find.byKey(const Key('underline_closed')));
    await tester.pump();
    expect(selected, 'underline:closed');
  });

  testWidgets('VitStatusPill supports count overflow and tap', (tester) async {
    var taps = 0;

    await tester.pumpWidget(
      _wrap(
        VitStatusPill(
          label: 'Queued',
          status: VitStatusPillStatus.warning,
          icon: Icons.schedule_rounded,
          count: 120,
          outline: true,
          onTap: () => taps++,
        ),
      ),
    );

    expect(find.text('Queued'), findsOneWidget);
    expect(find.text('99+'), findsOneWidget);
    expect(find.byIcon(Icons.schedule_rounded), findsOneWidget);

    await tester.tap(find.text('Queued'));
    await tester.pump();

    expect(taps, 1);
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
    expect(find.text('3'), findsOneWidget);
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

  testWidgets('Vit module cards render labels and dispatch actions', (
    tester,
  ) async {
    var heroTaps = 0;
    var actionTaps = 0;

    await tester.pumpWidget(
      _wrap(
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            VitModuleHeroCard(
              accentColor: AppColors.primary,
              onTap: () => heroTaps++,
              child: const Text('Arena points hero'),
            ),
            const SizedBox(height: 8),
            const VitMetricCard(
              label: 'Volume',
              value: '\$12.4K',
              trailing: Icon(Icons.trending_up_rounded),
            ),
            const SizedBox(height: 8),
            VitModuleSectionHeader(
              title: 'Quick actions',
              actionLabel: 'View all',
              onAction: () => actionTaps++,
            ),
          ],
        ),
      ),
    );

    expect(find.text('Arena points hero'), findsOneWidget);
    expect(find.text('Volume'), findsOneWidget);
    expect(find.text('\$12.4K'), findsOneWidget);
    expect(find.byIcon(Icons.trending_up_rounded), findsOneWidget);
    expect(find.text('Quick actions'), findsOneWidget);

    await tester.tap(find.text('Arena points hero'));
    await tester.tap(find.text('View all'));
    await tester.pump();

    expect(heroTaps, 1);
    expect(actionTaps, 1);
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
          matching: find.byType(SizedBox),
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

    final surfacePadding = tester.widget<Padding>(
      find
          .descendant(
            of: find.byType(VitSheetSurface),
            matching: find.byType(Padding),
          )
          .first,
    );
    final surfaceDecoration = tester.widget<DecoratedBox>(
      find
          .descendant(
            of: find.byType(VitSheetSurface),
            matching: find.byType(DecoratedBox),
          )
          .first,
    );
    final decoration = surfaceDecoration.decoration as ShapeDecoration;
    final shape = decoration.shape as RoundedRectangleBorder;

    expect(surfacePadding.padding, AppSpacing.homeMoreProductsSheetPadding);
    expect(decoration.color, AppColors.bg);
    expect(shape.borderRadius, AppRadii.sheetTopLargeRadius);
  });
}
