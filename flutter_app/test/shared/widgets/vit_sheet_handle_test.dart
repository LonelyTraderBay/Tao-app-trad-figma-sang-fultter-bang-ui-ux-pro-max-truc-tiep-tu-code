import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/spacing/shared_spacing_tokens.dart';
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

      expect(
        handleSize.width,
        SharedSpacingTokens.homeMoreProductsSheetHandleWidth,
      );
      expect(
        handleSize.height,
        SharedSpacingTokens.homeMoreProductsSheetHandleHeight,
      );
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

    expect(
      surfacePadding.padding,
      SharedSpacingTokens.homeMoreProductsSheetPadding,
    );
    expect(decoration.color, AppColors.bg);
    expect(shape.borderRadius, AppRadii.sheetTopLargeRadius);
  });
}
