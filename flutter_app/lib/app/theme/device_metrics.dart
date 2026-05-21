import 'dart:ui' show Size;

final class DeviceMetrics {
  const DeviceMetrics._();

  static const double width = 440;
  static const double height =
      1.0 * int.fromEnvironment('VISUAL_QA_HEIGHT', defaultValue: 956);
  static const Size viewport = Size(width, height);

  static const double safeTop = 59;
  static const double safeBottom = 34;
  static const double tabBar = 56;
  static const double bottomChrome = 90;
  static const double nativeBottomChrome = 56;
  static const double contentPad = 20;

  static const double dynamicIslandWidth = 126;
  static const double dynamicIslandHeight = 37;
  static const double dynamicIslandTop = 11;

  static const double homeBarWidth = 134;
  static const double homeBarHeight = 5;
}
