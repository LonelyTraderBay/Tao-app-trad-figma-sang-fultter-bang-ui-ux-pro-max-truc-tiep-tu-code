import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
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
}
