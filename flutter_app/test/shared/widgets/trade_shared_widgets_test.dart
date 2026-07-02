import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_trade_chart_panel.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_trade_instrument_hero.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_trade_market_panels.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_trade_order_list.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_trade_product_hub.dart';

void main() {
  testWidgets('VitTradeInstrumentHero compact density renders', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: VitTradeInstrumentHero(
            symbol: 'ETH/USDT',
            priceLabel: '3,456.78',
            changePct: -0.52,
            density: VitTradeInstrumentHeroDensity.compact,
          ),
        ),
      ),
    );

    expect(find.text('ETH/USDT'), findsOneWidget);
    expect(find.text('3,456.78'), findsOneWidget);
    expect(find.textContaining('-0.52%'), findsOneWidget);
  });

  testWidgets('VitTradeInstrumentHero renders price and delta', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: VitTradeInstrumentHero(
            symbol: 'BTC/USDT',
            priceLabel: '67,543.21',
            changePct: 1.24,
            highLabel: '68,000.00',
            lowLabel: '66,000.00',
          ),
        ),
      ),
    );

    expect(find.text('BTC/USDT'), findsOneWidget);
    expect(find.text('67,543.21'), findsOneWidget);
    expect(find.textContaining('+1.24%'), findsOneWidget);
  });

  testWidgets('VitOrderBookPanel renders book rows', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: VitOrderBookPanel(
            asks: [VitOrderBookLevel(price: 67550, amount: 1.2, total: 100)],
            bids: [VitOrderBookLevel(price: 67540, amount: 0.8, total: 80)],
          ),
        ),
      ),
    );

    expect(find.text('Giá'), findsOneWidget);
    expect(find.text('67550.00'), findsOneWidget);
    expect(find.text('67540.00'), findsOneWidget);
  });

  testWidgets('VitTradeOrderList uses dense list-in-card', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: VitTradeOrderList(
            records: [
              VitTradeOrderRecord(
                id: '1',
                symbol: 'BTC/USDT',
                sideLabel: 'MUA',
                sideColor: AppColors.buy,
                detail: '0.1 @ 67543.21',
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.text('BTC/USDT'), findsOneWidget);
    expect(find.text('MUA'), findsOneWidget);
  });

  testWidgets('VitTradeChartPanel renders chart chrome', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: VitTradeChartPanel(),
        ),
      ),
    );

    expect(find.text('TV'), findsOneWidget);
  });

  testWidgets('VitTradeProductHub shows primary tiles', (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: VitTradeProductHub(
            items: [
              VitTradeHubItem(
                id: 'spot',
                label: 'Spot',
                badge: 'Core',
                icon: Icons.show_chart_rounded,
                accentColor: AppColors.primary,
                onTap: () => tapped = true,
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.text('Sản phẩm giao dịch'), findsOneWidget);
    expect(find.text('Spot'), findsOneWidget);
    await tester.tap(find.text('Spot'));
    expect(tapped, isTrue);
  });
}
