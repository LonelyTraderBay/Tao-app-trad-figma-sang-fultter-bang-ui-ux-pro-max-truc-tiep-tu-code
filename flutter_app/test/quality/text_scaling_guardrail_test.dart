import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_cta_button.dart';

/// A11Y-3 (docs/02_FLUTTER_MIGRATION/a-plus-roadmap/A-Plus-Task-Manifest.csv):
/// OS-level font-scaling accessibility settings must never be silently
/// neutralized by the app.
void main() {
  testWidgets('VitTradeApp clamps extreme OS text scaling to at most 1.3x', (
    tester,
  ) async {
    tester.platformDispatcher.textScaleFactorTestValue = 3.0;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

    await tester.pumpWidget(
      VitTradeApp(
        routerConfig: createAppRouter(initialLocation: AppRoutePaths.home),
      ),
    );
    await tester.pumpAndSettle();

    final scaler = MediaQuery.textScalerOf(
      tester.element(find.byType(VitBottomNav)),
    );
    expect(scaler.scale(100), closeTo(130, 0.01));
  });

  testWidgets(
    'VitCtaButton label grows to fit larger OS text scaling instead of '
    'shrinking back down, without overflowing',
    (tester) async {
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

      // A narrow button forces this label to wrap across lines — the case
      // that used to make FittedBox(scaleDown) shrink the whole label back
      // down to fit a fixed height, silently canceling out OS text-scaling.
      // NOTE: tester.getSize(find.text(...)) reports the RenderParagraph's
      // own (pre-transform) size, which FittedBox's scale-down transform
      // does not affect — so the *button's* outer size is what actually
      // reveals whether content was shrunk-to-fit vs. genuinely rendered
      // larger.
      Future<Size> pumpAndMeasureButton(double scale) async {
        tester.platformDispatcher.textScaleFactorTestValue = scale;
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: SizedBox(
                  width: 220,
                  child: VitCtaButton(
                    onPressed: () {},
                    child: const Text(
                      'Xác nhận và tiếp tục giao dịch ngay bây giờ',
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        return tester.getSize(find.byType(VitCtaButton));
      }

      final baseSize = await pumpAndMeasureButton(1.0);
      final scaledSize = await pumpAndMeasureButton(1.3);

      expect(scaledSize.height, greaterThan(baseSize.height));
      expect(scaledSize.width, equals(baseSize.width));
    },
  );
}
