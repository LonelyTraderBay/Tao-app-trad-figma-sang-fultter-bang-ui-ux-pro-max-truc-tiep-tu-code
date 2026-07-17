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
}
