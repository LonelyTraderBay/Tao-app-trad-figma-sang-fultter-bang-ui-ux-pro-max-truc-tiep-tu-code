import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
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
  testWidgets('Home foundation primitives render and dispatch actions', (
    tester,
  ) async {
    var sectionTaps = 0;
    var tileTaps = 0;
    var marketTaps = 0;
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
    expect(find.text('Recent'), findsOneWidget);
    expect(find.byType(VitTogglePill), findsOneWidget);
    expect(find.bySemanticsLabel(RegExp('View Markets')), findsOneWidget);

    await tester.tap(find.text('View'));
    await tester.ensureVisible(find.text('Swap'));
    await tester.tap(find.text('Swap'));
    await tester.ensureVisible(find.text('BTC/USDT'));
    await tester.tap(find.text('BTC/USDT'));
    await tester.ensureVisible(find.text('Recent'));
    await tester.tap(find.text('Recent'));
    await tester.pump();

    expect(sectionTaps, 1);
    expect(tileTaps, 1);
    expect(marketTaps, 1);
    expect(productTaps, 1);
  });
}
