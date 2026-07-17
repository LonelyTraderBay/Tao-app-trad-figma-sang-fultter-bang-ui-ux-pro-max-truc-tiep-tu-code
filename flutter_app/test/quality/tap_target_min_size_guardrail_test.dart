import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header_action_button.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_icon_button.dart';

/// A11Y-2 (docs/02_FLUTTER_MIGRATION/a-plus-roadmap/A-Plus-Task-Manifest.csv):
/// the visible box of these two shared primitives is intentionally smaller
/// than 44dp (36/40dp) at some sizes, but the tappable (InkWell) region must
/// still be at least 44x44 — WCAG 2.5.5 / Material minimum tap target.
///
/// Wraps every case in `Scaffold > Center`, the worst case for this class of
/// bug: `Center`'s default behavior is to expand to fill any *bounded*
/// incoming constraint. Asserting only a lower bound (`>= 44`) does NOT
/// catch that failure mode — an accidentally-unbounded tap target (e.g.
/// filling the whole 800x600 test viewport) still satisfies `>= 44`. Every
/// assertion here also checks a tight upper bound, so a regression back to
/// "expands to fill the parent" fails loudly instead of accidentally
/// passing.
void main() {
  Future<void> pumpCentered(WidgetTester tester, Widget child) {
    return tester.pumpWidget(
      MaterialApp(home: Scaffold(body: Center(child: child))),
    );
  }

  Size inkWellSizeWithin(WidgetTester tester, Type widgetType) {
    final finder = find.descendant(
      of: find.byType(widgetType),
      matching: find.byType(InkWell),
    );
    expect(
      finder,
      findsOneWidget,
      reason: 'expected exactly one InkWell inside $widgetType',
    );
    return tester.getSize(finder);
  }

  const upperBound = 52.0; // 44dp minimum + generous slack, not "any size".

  group('VitHeaderActionButton', () {
    for (final size in VitHeaderActionSize.values) {
      testWidgets('$size has a tap target of exactly ~44dp', (tester) async {
        await pumpCentered(
          tester,
          VitHeaderActionButton(
            type: VitHeaderActionType.back,
            onPressed: () {},
            size: size,
          ),
        );

        final inkWellSize = inkWellSizeWithin(tester, VitHeaderActionButton);
        expect(inkWellSize.width, inInclusiveRange(44, upperBound));
        expect(inkWellSize.height, inInclusiveRange(44, upperBound));
      });
    }
  });

  group('VitIconButton', () {
    for (final size in VitIconButtonSize.values) {
      testWidgets('$size icon-only has a tap target of exactly ~44dp', (
        tester,
      ) async {
        await pumpCentered(
          tester,
          VitIconButton(
            icon: Icons.close,
            tooltip: 'Đóng',
            onPressed: () {},
            size: size,
          ),
        );

        final inkWellSize = inkWellSizeWithin(tester, VitIconButton);
        expect(inkWellSize.width, inInclusiveRange(44, upperBound));
        expect(inkWellSize.height, inInclusiveRange(44, upperBound));
      });

      testWidgets(
        '$size with a label keeps a ~44dp tap height without capping width',
        (tester) async {
          await pumpCentered(
            tester,
            VitIconButton(
              icon: Icons.close,
              tooltip: 'Đóng',
              label: 'Đóng',
              onPressed: () {},
              size: size,
            ),
          );

          final inkWellSize = inkWellSizeWithin(tester, VitIconButton);
          expect(inkWellSize.height, inInclusiveRange(44, upperBound));
          // Width hugs the label content (icon + gap + text), not capped —
          // this is a sanity check that it isn't ALSO accidentally filling
          // the 800-wide test viewport.
          expect(inkWellSize.width, lessThan(200));
        },
      );
    }
  });
}
