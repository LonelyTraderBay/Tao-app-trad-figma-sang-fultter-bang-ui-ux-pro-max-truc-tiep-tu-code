import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';

void main() {
  const route = String.fromEnvironment('CAPTURE_ROUTE', defaultValue: '/home');
  const outputPath = String.fromEnvironment(
    'CAPTURE_OUT',
    defaultValue:
        '../output/flutter-ui-reference/flutter-candidates/screenshots/capture.png',
  );
  const width = int.fromEnvironment('CAPTURE_WIDTH', defaultValue: 440);
  const height = int.fromEnvironment('CAPTURE_HEIGHT', defaultValue: 956);

  testWidgets('captures a visual QA route screenshot', (tester) async {
    await tester.runAsync(_loadCaptureFonts);

    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = Size(width.toDouble(), height.toDouble());
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final captureKey = GlobalKey();

    await tester.pumpWidget(
      RepaintBoundary(
        key: captureKey,
        child: ProviderScope(
          child: VitTradeApp(
            routerConfig: createAppRouter(
              initialLocation: route,
              shellRenderMode: ShellRenderMode.visualQa,
            ),
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 500));

    final boundary =
        captureKey.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    await tester.runAsync(() async {
      final image = await boundary.toImage(pixelRatio: 1);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final bytes = byteData!.buffer.asUint8List();

      final output = File(outputPath);
      output.parent.createSync(recursive: true);
      output.writeAsBytesSync(bytes);
    });
  });
}

Future<void> _loadCaptureFonts() async {
  final flutterRoot = Platform.environment['FLUTTER_ROOT'];
  if (flutterRoot == null || flutterRoot.isEmpty) return;

  final materialFonts = Directory(
    '$flutterRoot/bin/cache/artifacts/material_fonts',
  );
  if (!materialFonts.existsSync()) return;

  final loader = FontLoader('Roboto')
    ..addFont(_fontBytes(File('${materialFonts.path}/roboto-regular.ttf')))
    ..addFont(_fontBytes(File('${materialFonts.path}/roboto-medium.ttf')))
    ..addFont(_fontBytes(File('${materialFonts.path}/roboto-bold.ttf')));
  await loader.load();

  final iconLoader = FontLoader('MaterialIcons')
    ..addFont(
      _fontBytes(File('${materialFonts.path}/materialicons-regular.otf')),
    );
  await iconLoader.load();
}

Future<ByteData> _fontBytes(File file) async {
  final bytes = file.readAsBytesSync();
  return ByteData.view(Uint8List.fromList(bytes).buffer);
}
