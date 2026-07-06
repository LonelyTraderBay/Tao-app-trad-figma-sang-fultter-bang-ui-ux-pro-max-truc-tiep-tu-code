import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_trade_instrument_hero.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_trade_order_list.dart';

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
}
