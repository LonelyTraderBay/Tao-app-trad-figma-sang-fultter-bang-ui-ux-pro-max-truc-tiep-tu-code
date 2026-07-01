import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';

void main() {
  testWidgets('tradeScrollBottomInset matches Home formula at 360px native',
      (tester) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    late double inset;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            inset = tradeScrollBottomInset(
              context,
              shellRenderMode: ShellRenderMode.native,
            );
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    expect(
      inset,
      AppSpacing.buttonStandard + AppSpacing.x5,
    );
  });

  testWidgets('tradeTerminalScrollBottomInset includes chrome at visual QA',
      (tester) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    late double nativeInset;
    late double visualInset;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            nativeInset = tradeTerminalScrollBottomInset(
              context,
              shellRenderMode: ShellRenderMode.native,
            );
            visualInset = tradeTerminalScrollBottomInset(
              context,
              shellRenderMode: ShellRenderMode.visualQa,
            );
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    expect(visualInset, greaterThan(nativeInset));
    expect(nativeInset, greaterThan(AppSpacing.tradeBottomInsetNative));
  });
}
