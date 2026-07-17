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
}
