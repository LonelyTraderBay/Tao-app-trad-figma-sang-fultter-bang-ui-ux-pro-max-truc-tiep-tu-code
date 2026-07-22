// Origin: 905aebcd (2026-07-07) - feat(flutter): chuẩn hóa UI toàn app theo 6 tiêu chuẩn thiết kế
// Guardrail này có lý do tồn tại riêng - đọc commit gốc ở trên trước khi nới lỏng hoặc xóa.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_card.dart';

import 'page_rhythm_phone_visual_qa_test_utils.dart';

/// Page Rhythm Visual QA — phone viewport (360×800 logical px).
/// Mirrors [Page-Rhythm-Visual-QA-Checklist.md] flows 1–32.
void main() {
  const phone = Size(360, 800);

  for (final flow in pageRhythmVisualQaFlows) {
    testWidgets('phone QA ${flow.id}: ${flow.name} @ 360×800', (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = phone;
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetPhysicalSize);

      final errors = <FlutterErrorDetails>[];
      final previousOnError = FlutterError.onError;
      FlutterError.onError = errors.add;

      try {
        await tester.pumpWidget(
          VitTradeApp(
            routerConfig: createAppRouter(initialLocation: flow.route),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));
        await tester.pumpAndSettle(
          const Duration(milliseconds: 50),
          EnginePhase.sendSemanticsUpdate,
          const Duration(seconds: 5),
        );
        await tester.pump(const Duration(milliseconds: 350));
        await tester.pump();

        final semantics = find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              widget.properties.label == flow.semanticLabel,
        );
        expect(
          semantics,
          findsWidgets,
          reason: 'Expected ${flow.semanticLabel} on ${flow.route}',
        );

        if (flow.expectBottomNav) {
          expect(find.byType(VitBottomNav), findsOneWidget);
        }

        if (flow.assertStandardContentWidth) {
          final cards = find.byType(VitCard);
          expect(
            cards,
            findsWidgets,
            reason: 'Expected VitCard on ${flow.route} for width assert',
          );
          // Prefer a full-bleed content card (~320 @ 360px). Grid/half tiles
          // often appear first in the tree and must not fail the invariant.
          final widths = <double>[
            for (var i = 0; i < cards.evaluate().length; i++)
              tester.getSize(cards.at(i)).width,
          ];
          final hasStandardWidth = widths.any(
            (width) => width >= 318 && width <= 322,
          );
          expect(
            hasStandardWidth,
            isTrue,
            reason:
                'Expected a VitCard at viewport - 2×contentPad @ 360px '
                '(318–322). Found widths: $widths',
          );
        }

        expect(
          errors,
          isEmpty,
          reason: errors.map((e) => e.exceptionAsString()).join('\n'),
        );

        final Object? exception = tester.takeException();
        expect(exception, isNull, reason: '$exception');
      } finally {
        FlutterError.onError = previousOnError;
      }
    });
  }
}
