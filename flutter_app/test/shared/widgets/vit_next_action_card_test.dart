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
}
