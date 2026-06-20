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
  static const double nativeBottomChrome = 72;
  static const double contentPad = 20;

  static const double dynamicIslandWidth = 126;
  static const double dynamicIslandHeight = 37;
  static const double dynamicIslandTop = 11;
  static const double dynamicIslandRadius = 22;
  static const double dynamicIslandSensorLeft = 22;
  static const double dynamicIslandSensorSize = 5;
  static const double dynamicIslandLensRight = 18;
  static const double dynamicIslandLensSize = 12;
  static const double phoneChromeShadowBlur = 2;

  static const double homeBarWidth = 134;
  static const double homeBarHeight = 5;
  static const double homeBarBottomInset = 8;

  static const double statusBarPadStart = 32;
  static const double statusBarPadEnd = 28;
  static const double statusBarPadBottom = 4;
  static const double statusBarIconGap = 6;
  static const double statusBarWifiIcon = 16;
  static const double statusCellSignalWidth = 17;
  static const double statusCellSignalHeight = 12;
  static const double statusSignalBarWidth = 3;
  static const double statusSignalBarGap = 1.5;
  static const double statusSignalBarLow = 3;
  static const double statusSignalBarMedium = 6;
  static const double statusSignalBarHigh = 9;
  static const double statusSignalBarFull = 12;
  static const double statusSignalBarRadius = 0.75;
  static const double statusBatteryWidth = 27;
  static const double statusBatteryBodyWidth = 23;
  static const double statusBatteryHeight = 13;
  static const double statusBatteryPadding = 1.5;
  static const double statusBatteryFillWidth = 17;
  static const double statusBatteryTerminalWidth = 3;
  static const double statusBatteryTerminalHeight = 5;
}
