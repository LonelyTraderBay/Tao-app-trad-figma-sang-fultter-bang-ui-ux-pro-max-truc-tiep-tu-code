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
}
