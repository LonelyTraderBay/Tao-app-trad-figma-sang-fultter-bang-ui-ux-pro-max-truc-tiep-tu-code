import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/app/vit_trade_app.dart';

void main() {
  _disableDebugVisualOverlays();
  runApp(const ProviderScope(child: VitTradeApp()));
}

void _disableDebugVisualOverlays() {
  assert(() {
    debugPaintBaselinesEnabled = false;
    return true;
  }());
}
