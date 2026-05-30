import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'package:vit_trade_flutter/app/vit_trade_app.dart';

void main() {
  _disableDebugVisualOverlays();
  runApp(const VitTradeApp());
}

void _disableDebugVisualOverlays() {
  assert(() {
    debugPaintBaselinesEnabled = false;
    return true;
  }());
}
