import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
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
  testWidgets('VitAccentIconBox renders 34px bordered accent container', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        const VitAccentIconBox(
          icon: Icons.task_alt_outlined,
          color: AppColors.primary,
        ),
      ),
    );

    final box = tester.getSize(find.byType(VitAccentIconBox));
    expect(box.width, AppSpacing.accentIconBoxSize);
    expect(box.height, AppSpacing.accentIconBoxSize);
    expect(find.byType(DecoratedBox), findsWidgets);
    expect(find.byIcon(Icons.task_alt_outlined), findsOneWidget);
  });

  testWidgets(
    'VitAccentIconBox muted variant uses surface2 without accent border',
    (tester) async {
      await tester.pumpWidget(
        _wrap(
          const VitAccentIconBox(
            icon: Icons.flash_on_rounded,
            color: AppColors.text3,
            muted: true,
          ),
        ),
      );

      final decorated = tester.widget<DecoratedBox>(
        find.descendant(
          of: find.byType(VitAccentIconBox),
          matching: find.byType(DecoratedBox),
        ),
      );
      final decoration = decorated.decoration as ShapeDecoration;
      expect(decoration.color, AppColors.surface2);
      expect(
        (decoration.shape as RoundedRectangleBorder).side,
        BorderSide.none,
      );
    },
  );
}
